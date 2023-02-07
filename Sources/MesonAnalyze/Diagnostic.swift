import MesonAST

public enum MesonDiagnosticSeverity {
  case warning
  case error
}
public class MesonDiagnostic {
  public let severity: MesonDiagnosticSeverity
  public let startLine: UInt32
  public let endLine: UInt32
  public let startColumn: UInt32
  public let endColumn: UInt32
  public let message: String

  public init(sev: MesonDiagnosticSeverity, node: Node, message: String) {
    self.severity = sev
    let loc = node.location
    self.startLine = loc.startLine
    self.endLine = loc.endLine
    self.startColumn = loc.startColumn
    self.endColumn = loc.endColumn
    self.message = message
    print(message)
  }
}
