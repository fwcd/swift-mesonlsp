public class TargetMachine: AbstractObject {
  public let name: String = "target_machine"
  public let parent: AbstractObject? = BuildMachine()
  public var methods: [Method] = []

  public init() {}
}