import MesonAST

public class ImportTypeAnalyzer: MesonTypeAnalyzer {
  public func derive(node: Node, fn: Function, options: [MesonOption], ns: TypeNamespace) -> [Type]
  {
    if let fe = node as? FunctionExpression, let feid = fe.id as? IdExpression, feid.id == "import"
    {
      if let alo = fe.argumentList, let al = alo as? ArgumentList, !al.args.isEmpty {
        let arg0 = al.args[0]
        if let sl = arg0 as? StringLiteral {
          let t = sl.contents()
          if let ret = self.nameToModule(name: t, ns: ns) { return ret }
        }
      }
    }
    return [
      ns.types["cmake_module"]!, ns.types["fs_module"]!, ns.types["gnome_module"]!,
      ns.types["i18n_module"]!, ns.types["rust_module"]!, ns.types["python_module"]!,
      ns.types["python3_module"]!, ns.types["pkgconfig_module"]!, ns.types["keyval_module"]!,
      ns.types["dlang_module"]!, ns.types["external_project_module"]!, ns.types["hotdoc_module"]!,
      ns.types["java_module"]!, ns.types["windows_module"]!, ns.types["cuda_module"]!,
      ns.types["icestorm_module"]!, ns.types["qt4_module"]!, ns.types["qt5_module"]!,
      ns.types["qt6_module"]!, ns.types["wayland_module"]!, ns.types["simd_module"]!,
      ns.types["sourceset_module"]!,
    ]
  }

  private func nameToModule(name: String, ns: TypeNamespace) -> [Type]? {
    let mapping = [
      "cmake": ns.types["cmake_module"]!, "fs": ns.types["fs_module"]!,
      "gnome": ns.types["gnome_module"]!, "i18n": ns.types["i18n_module"]!,
      "rust": ns.types["rust_module"]!, "unstable-rust": ns.types["rust_module"]!,
      "python": ns.types["python_module"]!, "python3": ns.types["python3_module"]!,
      "pkgconfig": ns.types["pkgconfig_module"]!, "keyval": ns.types["keyval_module"]!,
      "dlang": ns.types["dlang_module"]!,
      "unstable-external_project": ns.types["external_project_module"]!,
      "hotdoc": ns.types["hotdoc_module"]!, "java": ns.types["java_module"]!,
      "windows": ns.types["windows_module"]!, "cuda": ns.types["cuda_module"]!,
      "unstable-cuda": ns.types["cuda_module"]!, "icestorm": ns.types["icestorm_module"]!,
      "unstable-icestorm": ns.types["icestorm_module"]!, "qt4": ns.types["qt4_module"]!,
      "qt5": ns.types["qt5_module"]!, "qt6": ns.types["qt6_module"]!,
      "unstable-wayland": ns.types["wayland_module"]!, "unstable-simd": ns.types["simd_module"]!,
      "sourceset": ns.types["sourceset_module"]!,
    ]
    if let type = mapping[name] { return [type] }
    return nil
  }
}
