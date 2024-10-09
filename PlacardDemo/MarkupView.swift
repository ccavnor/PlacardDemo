//
//  MarkupView.swift
//  PlacardDemo
//
//  Created by Christopher Charles Cavnor on 10/3/24.
//

import SwiftUI

/*
 Modfied from https://medium.com/@orhanerday/building-a-swiftui-code-block-view-with-syntax-highlighting-d3d737a90a65
 */
struct CodeBlockView: View {
    var code: String
    var body: some View {
        ScrollView(.horizontal) {
            Text(attributedString(for: code))
                .frame(maxWidth: .infinity)
                .font(.system(.body, design: .monospaced))
                .padding(10)
                .background(Color.black)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.windowBackground, lineWidth: 1)
                )
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .scrollIndicators(.automatic, axes: .horizontal)
    }
    // Helper function to create an AttributedString with simulated syntax highlighting
    func attributedString(for code: String) -> AttributedString {
        var attributedString = AttributedString(code)
        // Add syntax highlighting for Swift keywords, strings, etc.
        let keywords = ["let", "var", "if", "else", "struct", "func", "return"]
        let stringPattern = "\".*?\"" // Pattern to match strings
        // Highlight keywords
        for keyword in keywords {
            let ranges = code.ranges(of: keyword)
            for range in ranges {
                if let attributedRange = Range(NSRange(range, in: code), in: attributedString) {
                    attributedString[attributedRange].foregroundColor = .blue // Swift keywords in blue
                }
            }
        }
        // Highlight strings (enclosed in quotation marks)
        if let regex = try? NSRegularExpression(pattern: stringPattern) {
            let matches = regex.matches(in: code, range: NSRange(code.startIndex..., in: code))
            for match in matches {
                if let stringRange = Range(match.range, in: code),
                   let attributedRange = Range(NSRange(stringRange, in: code), in: attributedString) {
                    attributedString[attributedRange].foregroundColor = .green // Strings in green
                }
            }
        }
        return attributedString
    }
}

struct CommentBlockView: View {
    var comment: String
    var fontStyle: Font.TextStyle = .callout
    var strokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [10])
    var fontWeight: Font.Weight = .semibold
    var foregroundColor: Color = .blue

    var body: some View {
        Text(comment)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .fontWeight(fontWeight)
            .font(.system(fontStyle, design: .default))
            .padding(8)
            .background(.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: strokeStyle)
            )
            .multilineTextAlignment(.leading)
            .foregroundColor(foregroundColor)
            .padding(.vertical, 10)
    }
}

struct SectionHeaderBlockView: View {
    var title: String

    var body: some View {
        CommentBlockView(comment: title,
                         fontStyle: .largeTitle,
                         strokeStyle: StrokeStyle(lineWidth: 1),
                         fontWeight: .heavy,
                         foregroundColor: .primary)
    }
}

struct TitleBlockView: View {
    var title: String

    var body: some View {
        CommentBlockView(comment: title,
                         fontStyle: .headline,
                         strokeStyle: StrokeStyle(lineWidth: 1),
                         fontWeight: .heavy,
                         foregroundColor: .black)
    }
}


extension String {
    /// Helper to find all ranges of a substring within a string
    func ranges(of substring: String) -> [Range<String.Index>] {
        var result: [Range<String.Index>] = []
        var startIndex = self.startIndex
        while startIndex < self.endIndex,
              let range = self.range(of: substring, range: startIndex..<self.endIndex) {
            result.append(range)
            startIndex = range.upperBound
        }
        return result
    }
}
