//
//  ClaudeService.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import Foundation

/// Service for interacting with the Claude API
@Observable
final class ClaudeService {
    var isLoading = false
    var lastError: String?

    private let apiEndpoint = "https://api.anthropic.com/v1/messages"

    /// Send a modification request to Claude
    func sendModificationRequest(
        userRequest: String,
        itinerary: ItineraryDTO,
        apiKey: String
    ) async throws -> ClaudeModificationResponse {
        isLoading = true
        lastError = nil
        defer { isLoading = false }

        guard !apiKey.isEmpty else {
            throw ClaudeServiceError.noAPIKey
        }

        let systemPrompt = buildSystemPrompt()
        let userMessage = buildUserMessage(request: userRequest, itinerary: itinerary)

        let requestBody = ClaudeAPIRequest(
            model: "claude-sonnet-4-20250514",
            max_tokens: 4096,
            system: systemPrompt,
            messages: [
                ClaudeMessage(role: "user", content: userMessage)
            ]
        )

        var request = URLRequest(url: URL(string: apiEndpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ClaudeServiceError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            lastError = "API Error: \(httpResponse.statusCode)"
            throw ClaudeServiceError.apiError(statusCode: httpResponse.statusCode, message: errorMessage)
        }

        let apiResponse = try JSONDecoder().decode(ClaudeAPIResponse.self, from: data)

        // Extract JSON from Claude's response
        guard let textContent = apiResponse.content.first?.text else {
            throw ClaudeServiceError.noContent
        }

        // Parse the modification response from Claude's text
        return try parseModificationResponse(from: textContent)
    }

    // MARK: - Private

    private func buildSystemPrompt() -> String {
        """
        You are an AI assistant for a travel itinerary app called Wanderlust. Your job is to help users modify their trip itinerary based on natural language requests.

        IMPORTANT: You must respond ONLY with valid JSON in the following schema. No explanations, no markdown, just JSON.

        Response Schema:
        {
          "modifications": [
            {
              "type": "modify" | "add" | "delete",
              "target": "timedActivity" | "untimedActivity" | "subActivity",
              "dayIndex": <number or null>,
              "activityId": "<uuid string>",
              "changes": {
                "time": "<new time or null>",
                "place": "<new place or null>",
                "what": "<new description or null>",
                "context": "<new context or null>",
                "priority": "mustDo" | "flexible" | "skip" | null
              }
            }
          ],
          "reasoning": "<brief explanation of what you changed>",
          "warnings": ["<any concerns about the request>"]
        }

        Rules:
        1. Only return the JSON object, nothing else
        2. Only modify activities that exist in the provided itinerary
        3. For "modify" type, only include non-null fields that should change
        4. Use activityId from the provided itinerary
        5. Priority values must be exactly: "mustDo", "flexible", or "skip"
        6. If the request is unclear, add a warning but make your best guess
        """
    }

    private func buildUserMessage(request: String, itinerary: ItineraryDTO) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let itineraryJSON = (try? encoder.encode(itinerary)).flatMap { String(data: $0, encoding: .utf8) } ?? "{}"

        return """
        Current Itinerary:
        \(itineraryJSON)

        User Request: \(request)

        Please modify the itinerary according to the user's request and return ONLY the JSON response.
        """
    }

    private func parseModificationResponse(from text: String) throws -> ClaudeModificationResponse {
        // Try to extract JSON from the response
        let jsonString: String

        if let startIndex = text.firstIndex(of: "{"),
           let endIndex = text.lastIndex(of: "}") {
            jsonString = String(text[startIndex...endIndex])
        } else {
            jsonString = text
        }

        guard let data = jsonString.data(using: .utf8) else {
            throw ClaudeServiceError.parseError
        }

        return try JSONDecoder().decode(ClaudeModificationResponse.self, from: data)
    }
}

// MARK: - API Request/Response Types

struct ClaudeAPIRequest: Codable {
    let model: String
    let max_tokens: Int
    let system: String
    let messages: [ClaudeMessage]
}

struct ClaudeMessage: Codable {
    let role: String
    let content: String
}

struct ClaudeAPIResponse: Codable {
    let content: [ClaudeContentBlock]
}

struct ClaudeContentBlock: Codable {
    let type: String
    let text: String?
}

// MARK: - Errors

enum ClaudeServiceError: LocalizedError {
    case noAPIKey
    case invalidResponse
    case apiError(statusCode: Int, message: String)
    case noContent
    case parseError

    var errorDescription: String? {
        switch self {
        case .noAPIKey:
            return "No API key configured. Please add your Claude API key in Settings."
        case .invalidResponse:
            return "Invalid response from server."
        case .apiError(let statusCode, let message):
            return "API Error (\(statusCode)): \(message)"
        case .noContent:
            return "No content in API response."
        case .parseError:
            return "Could not parse AI response."
        }
    }
}
