import Foundation

public class SvnWrap: VcsWrap {
  public override func setupDirectory(path: String, packagefilesPath: String) throws {
    try self.assertRequired("svn")
    guard let urlAsString = self.url else { throw WrapError.genericError("Expected URL to clone") }
    if let url = URL(string: urlAsString) {
      guard let rev = self.revision else { throw WrapError.genericError("Missing revision") }
      // Do something like https://github.com/mesonbuild/meson/blob/3e7c08f358e9bd91808c8ff3b76c11aedeb82f85/mesonbuild/wrap/wrap.py#L549
      let targetDirectory =
        self.directory ?? url.lastPathComponent.replacingOccurrences(of: ".git", with: "")
      let fullPath = path + "/" + targetDirectory
      try self.executeCommand(["svn", "checkout", "-r", rev, url.description, fullPath])
    } else {
      throw WrapError.genericError("Malformed URL: \(String(describing: self.url))")
    }
  }
}