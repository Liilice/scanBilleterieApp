//
//  ScanView.swift
//  billeterieScan
//
//  Created by Alice Zheng on 27/05/2026.
//
import SwiftUI
import CodeScanner

private struct ScannedCode: Identifiable {
    let id = UUID()
    let value: String
}

struct ScanView: View {
    @State private var scanned: ScannedCode?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                CodeScannerView(
                    codeTypes: [.qr],
                    scanMode: .continuous,
                    showViewfinder: true
                ) { result in
                    handleScan(result)
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
        .sheet(item: $scanned) { code in
            resultSheet(for: code.value)
                .presentationDetents([.medium])
        }
    }

    private func handleScan(_ result: Result<ScanResult, ScanError>) {
        guard scanned == nil else { return }
        switch result {
        case .success(let code):
            scanned = ScannedCode(value: code.string)
        case .failure(let error):
            print("Scan failed: \(error.localizedDescription)")
        }
    }

    private func resultSheet(for code: String) -> some View {
        VStack(spacing: 24) {
            Image(systemName: "qrcode.viewfinder")
                .font(.system(size: 48))
                .foregroundStyle(.white)

            Text("QR code scanné")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.white)

            Text(code)
                .font(.system(size: 15))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .textSelection(.enabled)
                .padding(.horizontal)

            if let url = URL(string: code) {
                Link(destination: url) {
                    Label("Ouvrir le lien", systemImage: "arrow.up.right.square")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(hex: "#E5484D"))
                        .cornerRadius(8)
                }
            }

            Button {
                scanned = nil
            } label: {
                Text("Scanner à nouveau")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#1D1617").ignoresSafeArea())
    }
}

#Preview {
    ScanView()
}
