//
//  SettingsView.swift
//  Wanderlust
//
//  Created by Claude on 1/23/26.
//

import SwiftUI

/// Settings screen for API key configuration
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("claudeAPIKey") private var userAPIKey: String = ""
    @State private var tempAPIKey: String = ""
    @State private var showKey: Bool = false

    /// Effective API key: user-entered takes priority, then Secrets.plist
    private var apiKey: String {
        if !userAPIKey.isEmpty {
            return userAPIKey
        }
        return Self.loadSecretKey("CLAUDE_API_KEY") ?? ""
    }

    /// Check if using plist key (not user-entered)
    private var isUsingPlistKey: Bool {
        userAPIKey.isEmpty && !apiKey.isEmpty
    }

    /// Load a key from Secrets.plist
    private static func loadSecretKey(_ key: String) -> String? {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            return nil
        }
        return plist[key] as? String
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image(systemName: "key.fill")
                                .font(.title)
                                .foregroundStyle(Color.wanderlustTeal)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Claude API Key")
                                    .font(.headline)
                                    .fontWeight(.bold)

                                Text("Required for AI features")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("API Configuration")
                }

                Section {
                    HStack {
                        if showKey {
                            TextField("sk-ant-...", text: $tempAPIKey)
                                .textContentType(.password)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        } else {
                            SecureField("sk-ant-...", text: $tempAPIKey)
                                .textContentType(.password)
                        }

                        Button(action: { showKey.toggle() }) {
                            Image(systemName: showKey ? "eye.slash.fill" : "eye.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                } header: {
                    Text("API Key")
                } footer: {
                    if isUsingPlistKey {
                        Text("Using key from Info.plist. Enter a key here to override.")
                    } else {
                        Text("Your API key is stored securely on your device.")
                    }
                }

                Section {
                    Link(destination: URL(string: "https://console.anthropic.com/settings/keys")!) {
                        HStack {
                            Label("Get an API Key", systemImage: "arrow.up.forward.app")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } footer: {
                    Text("You'll need an Anthropic account to create an API key.")
                }

                if !apiKey.isEmpty {
                    Section {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("API Key configured")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        userAPIKey = tempAPIKey
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .disabled(tempAPIKey.isEmpty && apiKey.isEmpty)
                }
            }
            .onAppear {
                tempAPIKey = apiKey
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    SettingsView()
}
