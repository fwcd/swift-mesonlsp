import SwiftTreeSitter

public final class ArgumentList: Expression {
  public let file: MesonSourceFile
  public var args: [Node]
  public var types: [Type] = []
  public let location: Location
  public weak var parent: Node?

  init(file: MesonSourceFile, node: SwiftTreeSitter.Node) {
    self.file = file
    self.location = Location(node: node)
    var bb: [Node] = []
    node.enumerateNamedChildren { bb.append(from_tree(file: file, tree: $0)!) }
    self.args = bb
  }

  fileprivate init(file: MesonSourceFile, location: Location, args: [Node]) {
    self.file = file
    self.location = location
    self.args = args
  }
  public func clone() -> Node {
    let newArgs: [Node] = Array(self.args.map { $0.clone() })
    let location = self.location.clone()
    return Self(file: file, location: location, args: newArgs)
  }
  public func visit(visitor: CodeVisitor) { visitor.visitArgumentList(node: self) }
  public func visitChildren(visitor: CodeVisitor) {
    for arg in self.args { arg.visit(visitor: visitor) }
  }

  public func setParents() {
    for arg in self.args {
      arg.parent = self
      arg.setParents()
    }
  }

  public func getPositionalArg(idx: Int) -> Node? {
    var cnter = 0
    var idx1 = idx
    while idx >= 0 {
      if cnter == args.count { return nil }
      if args[cnter] is KeywordItem {
        cnter += 1
        continue
      }
      if idx1 == 0 { return args[cnter] }
      idx1 -= 1
      cnter += 1
    }
    return nil
  }

  public func getKwarg(name: String) -> Node? {
    for a in self.args {
      if let b = a as? KeywordItem {
        if let ide = b.key as? IdExpression, ide.id == name { return b.value }
      }
    }
    return nil
  }

  public func countPositionalArgs() -> Int {
    var cnter = 0
    for a in self.args where a as? KeywordItem == nil { cnter += 1 }
    return cnter
  }

  public var description: String { return "(ArgumentList \(args))" }
}
