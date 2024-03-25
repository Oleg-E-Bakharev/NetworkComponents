//
//  AnyPrimitiveCodable.swift
//  AsyncHttpClient
//
//  Created by Oleg Bakharev on 23.06.2022.
//  Copyright © 2022 Wildberries OOO. All rights reserved.
//

import Foundation

/// Type, representable one of possible primitive types in JSON
/// In JSON there will be only target value.
/// Dates should be encoded only in ISO8601 format otherwise any date will be decoded into number
public enum AnyPrimitiveCodable {
    case date(Date)
    case string(String)
    case double(Double) // Do not use directly. Use anyDouble instead.
    case int(Int)
    case bool(Bool)
    case unknown

    /// If target type is Double then automatic decoding transforms Double values without fractional part into Int
    /// This property convert Int to Double if it is present.
    var anyDouble: Double? {
        switch self {
        case .double(let value):
            value
        case .int(let value):
            Double(value)
        default:
            nil
        }
    }
}

extension AnyPrimitiveCodable: Decodable {

    public init(from decoder: Decoder) throws {
        // Int must preceeding Double for properly decoding
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }

        if let double = try? decoder.singleValueContainer().decode(Double.self) {
            self = .double(double)
            return
        }

        // Do not use numberic date format, otherwise dates will decode into numeric types
        if let date = try? decoder.singleValueContainer().decode(Date.self) {
            self = .date(date)
            return
        }

        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }

        if let bool = try? decoder.singleValueContainer().decode(Bool.self) {
            self = .bool(bool)
            return
        }

        self = .unknown
    }

}

extension AnyPrimitiveCodable: Encodable {

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .int(let int):
            try int.encode(to: encoder)
        case .date(let date):
            // We must use level of indirection for properly support target date format
            // https://stackoverflow.com/questions/48658574/jsonencoders-dateencodingstrategy-not-working
            var container = encoder.singleValueContainer()
            try container.encode(date)
        case .string(let string):
            try string.encode(to: encoder)
        case .bool(let bool):
            try bool.encode(to: encoder)
        case .double(let double):
            try double.encode(to: encoder)
        default:
            break
        }
    }

}
