public protocol Node {
  var file: MesonSourceFile { get }
  var types: [Type] { get }
  func visit(visitor: CodeVisitor)
  func visitChildren(visitor: CodeVisitor)
}

public protocol Statement: Node {

}

public protocol Expression: Node {

}
