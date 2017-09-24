//
//  CodeGenerator.swift
//  dikitgenTests
//
//  Created by Yosuke Ishikawa on 2017/09/16.
//

import Foundation
import SourceKittenFramework
import Stencil

public final class CodeGenerator {
    let context: [String: Any]

    public init(path: String) throws {
        let types = Array(files(atPath: path)
            .map { file in
                return Structure(file: file)
                    .substructures
                    .flatMap { Type(structure: $0, file: file) }
            }
            .joined())

        let resolvers = try types
            .flatMap { type -> Resolver? in
                do {
                    return try Resolver(type: type, allTypes: types)
                } catch let error as Resolver.Error where error.reason == .protocolConformanceNotFound {
                    return nil
                } catch {
                    throw error
                }
            }

        context = ["resolvers": resolvers]
    }

    public func generate() throws -> String {
        let template = Template(templateString: """
            //
            //  Resolver.swift
            //  Generated by dikitgen.
            //
            {% for resolver in resolvers %}
            extension {{ resolver.name }} {
            {% for method in resolver.generatedMethods %}
                func {{ method.name }}({{ method.parametersDeclaration }}) -> {{ method.returnTypeName }} {
                    {% for line in method.bodyLines %}{{ line }}{% if not forloop.last %}
                    {% endif %}{% endfor %}
                }
            {% endfor %}
            }
            {% endfor %}
            """)

        return try template.render(context)
    }
}

private func files(atPath path: String) -> [File] {
    let url = URL(fileURLWithPath: path)
    let fileManager = FileManager.default

    var isDirectory = false as ObjCBool
    if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) && !isDirectory.boolValue {
        if let file = File(path: url.path) {
            return [file]
        }
    }

    let enumerator = fileManager.enumerator(atPath: path)
    var files = [] as [File]
    while let subpath = enumerator?.nextObject() as? String {
        let url = url.appendingPathComponent(subpath)

        var isDirectory = false as ObjCBool
        if fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                files.append(contentsOf: DIGenKit.files(atPath: url.path))
            } else if url.pathExtension == "swift", let file = File(path: url.path), file.contents.contains("DIKit") {
                files.append(file)
            }
        }
    }

    return files
}
