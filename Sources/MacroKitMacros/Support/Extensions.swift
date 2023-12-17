extension DeclGroupSyntax {
  public var properties: [VariableDeclSyntax] {
    return memberBlock.members.compactMap({ $0.decl.as(VariableDeclSyntax.self) })
  }
}
