//
//  CSVConverter.swift
//  FitBodChallenge_RobBooth
//
//  Created by Rob Booth on 5/31/24.
//

import Foundation

enum CSVParsingError: Error, CustomStringConvertible {
    case readError(Error)
    case emptyFile
    case invalidFormat
    case inconsistentRowLength
    case missingHeaders
    case fileNotFound
    case cantConvertToJSON
    
    var description: String {
        switch self {
        case .readError:
            return "Error reading CSV file."
        case .emptyFile:
            return "The CSV file is empty."
        case .invalidFormat:
            return "The CSV file format is invalid."
        case .inconsistentRowLength:
            return "Inconsistent row length found in CSV data."
        case .missingHeaders:
            return "CSV headers are missing or incorrectly formatted."
        case .fileNotFound:
            return "CSV file not found."
        case .cantConvertToJSON:
            return "Failed to convert CSV to JSON."
        }
    }
}

struct CSVConverter {
    
    // Function to read a CSV file from a given path
    static func read(from filePath: String) throws -> String {
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            return content
        } catch {
            throw CSVParsingError.readError(error)
        }
    }
    
    // Function to convert CSV content to an array of dictionaries
    static func parse(_ content: String) throws -> [[String: String]] {
        var result: [[String: String]] = []
        
        // Check if the CSV content is empty
        guard content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false else {
            throw CSVParsingError.emptyFile
        }
        
        let rows = content.components(separatedBy: "\n").filter { !$0.isEmpty }
        
        // Check if there are headers and rows
        guard let headers = rows.first?.components(separatedBy: ",").map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) }),
              headers.isEmpty == false else {
            throw CSVParsingError.missingHeaders
        }
                
        for row in rows.dropFirst() {
            let values = row.components(separatedBy: ",")
            
            if values.count != headers.count {
                throw CSVParsingError.inconsistentRowLength
            }
            
            let dictionary = Dictionary(uniqueKeysWithValues: zip(headers, values))
            result.append(dictionary)            
        }
        
        return result
    }
    
    // Function to convert an array of dictionaries to JSON data
    static func convertToJSON(_ data: [[String: String]]) throws -> Data {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return jsonData
        } catch {
            throw CSVParsingError.invalidFormat
        }
    }
}
