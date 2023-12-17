extension VariableDeclSyntax {
  public var isComputed: Bool {
    return bindings.contains { binding in
      switch binding.accessorBlock?.accessors {
      case .none:
        return false

      case let .some(.accessors(list)):
        return !list.allSatisfy {
          ["willSet", "didSet"].contains($0.accessorSpecifier.trimmed.text)
        }

      case .getter:
        return true
      }
    }
  }
  public var isStored: Bool {
    return !isComputed
  }
  public var isStatic: Bool {
    return modifiers.lazy.contains(where: { $0.name.tokenKind == .keyword(.static) }) == true
  }
  public var identifier: TokenSyntax {
    return bindings.lazy.compactMap({ $0.pattern.as(IdentifierPatternSyntax.self) }).first!.identifier
  }

  public var type: TypeAnnotationSyntax? {
    return bindings.lazy.compactMap(\.typeAnnotation).first
  }

  public var initializerValue: ExprSyntax? {
    return bindings.lazy.compactMap(\.initializer).first?.value
  }

  public var effectSpecifiers: AccessorEffectSpecifiersSyntax? {
    return bindings
      .lazy
      .compactMap(\.accessorBlock)
      .compactMap({ accessor in
        switch accessor.accessors {
        case .accessors(let syntax):
          return syntax.lazy.compactMap(\.effectSpecifiers).first
        case .getter:
          return nil
        }
      })
      .first
  }

  public var isThrowing: Bool {
    return bindings
      .compactMap(\.accessorBlock)
      .contains(where: { accessor in
        switch accessor.accessors {
        case .accessors(let syntax):
          return syntax.contains(where: { $0.effectSpecifiers?.throwsSpecifier != nil })
        case .getter:
          return false
        }
      })
  }
  
  public var isAsync: Bool {
    return bindings
      .compactMap(\.accessorBlock)
      .contains(where: { accessor in
        switch accessor.accessors {
        case .accessors(let syntax):
          return syntax.contains(where: { $0.effectSpecifiers?.asyncSpecifier != nil })
        case .getter:
          return false
        }
      })
  }
}
