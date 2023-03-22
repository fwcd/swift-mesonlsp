import Foundation

public class FileWrap: Wrap {
  public private(set) var sourceURL: String?
  public private(set) var sourceFallbackURL: String?
  public private(set) var sourceFilename: String?
  public private(set) var sourceHash: String?
  public private(set) var leadDirectoryMissing: Bool

  internal init(
    directory: String?,
    patchURL: String?,
    patchFallbackURL: String?,
    patchFilename: String?,
    patchHash: String?,
    patchDirectory: String?,
    diffFiles: [String]?,
    sourceURL: String?,
    sourceFallbackURL: String?,
    sourceFilename: String?,
    sourceHash: String?,
    leadDirectoryMissing: Bool
  ) {
    self.sourceURL = sourceURL
    self.sourceFallbackURL = sourceFallbackURL
    self.sourceFilename = sourceFilename
    self.sourceHash = sourceHash
    self.leadDirectoryMissing = leadDirectoryMissing
    super.init(
      directory: directory,
      patchURL: patchURL,
      patchFallbackURL: patchFallbackURL,
      patchFilename: patchFilename,
      patchHash: patchHash,
      patchDirectory: patchDirectory,
      diffFiles: diffFiles
    )
  }

  public override func setupDirectory(path: String, packagefilesPath: String) throws {
    guard let urlAsString = self.sourceURL else {
      throw WrapError.genericError("Expected URL to clone")
    }
    if let url = URL(string: urlAsString) {
      // Do something like https://github.com/mesonbuild/meson/blob/3e7c08f358e9bd91808c8ff3b76c11aedeb82f85/mesonbuild/wrap/wrap.py#L549
      let targetDirectory =
        self.directory
        ?? url.lastPathComponent.replacingOccurrences(of: ".zip", with: "").replacingOccurrences(
          of: ".tar.xz",
          with: ""
        ).replacingOccurrences(of: ".tar.gz", with: "").replacingOccurrences(
          of: ".tar.bz2",
          with: ""
        ).replacingOccurrences(of: ".tgz", with: "")
      let fullPath = path + "/" + targetDirectory
      // Alamofire does not fit in, as everything is synchronous
      // URLSession.shared does not seem to exist.
      // All other libraries I tried (SwiftHTTP, Just) didn't even compile
      // So declare defeat and simply shell out to curl/wget, as one of those is always
      // installed.
      let archiveFile = try self.download(url: url.description)
      do {
        try FileManager.default.createDirectory(
          atPath: self.leadDirectoryMissing ? fullPath : path,
          withIntermediateDirectories: true,
          attributes: nil
        )
      } catch {
        // Ignore
      }
      let wd = self.leadDirectoryMissing ? fullPath : path
      let fileName = url.lastPathComponent
      if fileName.hasSuffix(".zip") {
        try self.assertRequired("unzip")
        try self.executeCommand(["unzip", archiveFile], wd)
      } else if fileName.hasSuffix("tar.xz") || fileName.hasSuffix(".tar.bz2")
        || fileName.hasSuffix(".tgz") || fileName.hasSuffix(".tar.gz")
      {
        try self.assertRequired("tar")
        try self.executeCommand(["tar", "xzvf", archiveFile], wd)
      }
    } else {
      throw WrapError.genericError("Malformed URL: \(String(describing: self.sourceURL))")
    }
  }
}
