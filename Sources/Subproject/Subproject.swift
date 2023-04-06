import Foundation
import Logging
import Wrap

public class Subproject: CustomStringConvertible {
  internal static let LOG: Logger = Logger(label: "Subproject::Subproject")

  public let name: String
  public let realpath: String
  public let parent: Subproject?

  internal init(name: String, parent: Subproject? = nil) throws {
    self.name = name
    self.parent = parent
    if let p = self.parent {
      self.realpath = p.realpath + "/subprojects/" + name
    } else {
      self.realpath = "subprojects/" + name
    }
    Self.LOG.info("Found subproject \(name) with the real path \(self.realpath)")
  }

  internal func discoverMore(state: SubprojectState) throws {

  }

  public var description: String { return "Subproject(\(name),\(realpath))" }
}
