/*
 * Copyright 2016 JD Fergason
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Foundation

/**
    Error thrown when a TOML syntax error is encountered

    - DuplicateKey: Document contains a duplicate key
    - InvalidDateFormat: Date string is not a supported format
    - InvalidEscapeSequence: Unsupported escape sequence used in string
    - InvalidUnicodeCharacter: Non-existant unicode character specified
    - KeyError: Key does not exist
    - MixedArrayType: Array is composed of multiple types, members must all be the same type
    - SyntaxError: Document cannot be parsed due to a syntax error
*/
public enum TomlError: Error {
    case DuplicateKey(String)
    case InvalidDateFormat(String)
    case InvalidEscapeSequence(String)
    case InvalidUnicodeCharacter(Int)
    case KeyError(String)
    case MixedArrayType(String)
    case SyntaxError(String)
}

/**
    Data parsed from a TOML document
*/
public class Toml: CustomStringConvertible {
    var data: [String: Any] = [String: Any]()
    var tables = [String]()
    var keyPath: [String] = []
    var currentKey: String = "."

    /**
        Get an array of all keys in the TOML document.

        - Returns: An array of supported key names
    */
    public var keys: [String] {
        return Array(data.keys)
    }

    /**
        Check if the TOML document contains the specified key.

        - Parameter key: Key path to check

        - Returns: True if key exists; false otherwise
    */
    public func hasKey(_ key: String...) -> Bool {
        let keyExists = data[String(key)] != nil
        return keyExists
    }

    /**
        Get an array of type T from the TOML document

        - Parameter path: Key path of array

        - Throws: `TomlError.KeyError` if the requested key path does not exist
            `RuntimeError` if the array cannot be coerced to type [T]

        - Returns: An array of type [T]
    */
    public func array<T>(_ path: String...) throws -> [T] {
        if let val = data[String(path)] {
            return val as! [T]
        }

        throw TomlError.KeyError(String(path))
    }

    /**
        Get a boolean value from the specified key path.

        - Parameter path: Key path of value

        - Throws: `TomlError.KeyError` if the requested key path does not exist
            `RuntimeError` if the value cannot be coerced to type boolean

        - Returns: boolean value of key path
    */
    public func bool(_ path: String...) throws -> Bool {
        if let val = data[String(path)] {
            return val as! Bool
        }

        throw TomlError.KeyError(String(path))
    }

    /**
        Get a date value from the specified key path.

        - Parameter path: Key path of value

        - Throws: `TomlError.KeyError` if the requested key path does not exist
            `RuntimeError` if the value cannot be coerced to type date

        - Returns: date value of key path
    */
    public func date(_ path: String...) throws -> Date {
        if let val = data[String(path)] {
            return val as! Date
        }

        throw TomlError.KeyError (String(path))
    }

    /**
        Get a double value from the specified key path.

        - Parameter path: Key path of value

        - Throws: `TomlError.KeyError` if the requested key path does not exist
            `RuntimeError` if the value cannot be coerced to type double

        - Returns: double value of key path
    */
    public func double(_ path: [String]) throws -> Double {
        if let val = data[String(path)] {
            return val as! Double
        }

        throw TomlError.KeyError(String(path))
    }

    /**
        Get a double value from the specified key path.

        - Parameter path: Key path of value

        - Throws: `TomlError.KeyError` if the requested key path does not exist
            `RuntimeError` if the value cannot be coerced to type double

        - Returns: double value of key path
    */
    public func double(_ path: String...) throws -> Double {
        return try double(path)
    }

    /**
        Get a double value from the specified key path.

        - Parameter path: Key path of value

        - Throws: `TomlError.KeyError` if the requested key path does not exist
            `RuntimeError` if the value cannot be coerced to type double

        - Returns: double value of key path
    */
    public func float(_ path: String...) throws -> Double {
        return try double(path)
    }

    /**
        Get a int value from the specified key path.

        - Parameter path: Key path of value

        - Throws: `TomlError.KeyError` if the requested key path does not exist
            `RuntimeError` if the value cannot be coerced to type int

        - Returns: int value of key path
    */
    public func int(_ path: String...) throws -> Int {
        if let val = data[String(path)] {
            return val as! Int
        }

        throw TomlError.KeyError(String(path))
    }

    /**
        Get a string value from the specified key path.

        - Parameter path: Key path of value

        - Throws: `TomlError.KeyError` if the requested key path does not exist
            `RuntimeError` if the value cannot be coerced to type string

        - Returns: string value of key path
    */
    public func string(_ path: String...) throws -> String {
        if let val = data[String(path)] {
            return val as! String
        }

        throw TomlError.KeyError(String(path))
    }

    /**
        Get a TOML table from the document

        - Parameter path: Key path of value

        - Throws: `TomlError.KeyError` if the requested key path does not exist
            `RuntimeError` if the value requested is not a table

        - Returns: Table of name `path`
    */
    public func table(_ path: String...) throws -> Toml {
        if let val = data[String(path)] {
            return val as! Toml
        }

        throw TomlError.KeyError(String(path))
    }

    /**
        Get a value of type T from the specified key path.

        - Parameter path: Key path of value

        - Throws: `TomlError.KeyError` if the requested key path does not exist
            `RuntimeError` if the value cannot be coerced to type T

        - Returns: value of key path
    */
    public func value<T>(_ path: String...) throws -> T {
        if let val = data[String(path)] {
            return val as! T
        }

        throw TomlError.KeyError(String(path))
    }

    /**
        Get a string representation of the TOML document

        - Returns: String version of TOML document
    */
    public var description: String {
        return "\(String(data))"
    }
}
