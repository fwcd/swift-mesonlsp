import SwiftTreeSitter

public enum UnaryOperator {
  case not
  case exclamationMark
  case minus
  static func fromString(str: String) -> Self? {
    switch str {
    case "not": return .not
    case "!": return .exclamationMark
    case "-": return .minus
    default: return nil
    }
  }
}
public final class UnaryExpression: Expression {
  public let file: MesonSourceFile
  public var expression: Node
  public let op: UnaryOperator?
  public var types: [Type] = []
  public let location: Location
  public weak var parent: Node?

  init(file: MesonSourceFile, node: SwiftTreeSitter.Node) {
    self.file = file
    self.location = Location(node: node)
    self.expression = from_tree(file: file, tree: node.namedChild(at: 0))!
    self.op = UnaryOperator.fromString(str: string_value(file: file, node: node.child(at: 0)!))
  }
  public func visit(visitor: CodeVisitor) { visitor.visitUnaryExpression(node: self) }
  public func visitChildren(visitor: CodeVisitor) { self.expression.visit(visitor: visitor) }

  public func setParents() {
    self.expression.parent = self
    self.expression.setParents()
  }
  fileprivate init(file: MesonSourceFile, location: Location, expression: Node, op: UnaryOperator?)
  {
    self.file = file
    self.location = location
    self.expression = expression
    self.op = op
  }
  public func clone() -> Node {
    let location = self.location.clone()
    return Self(file: file, location: location, expression: self.expression.clone(), op: self.op)
  }

  public var description: String {
    return "(UnaryExpression \(String(describing: op)) \(expression))"
  }
}
