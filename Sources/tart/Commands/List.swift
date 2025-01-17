import ArgumentParser
import Dispatch
import SwiftUI

struct List: AsyncParsableCommand {
  static var configuration = CommandConfiguration(abstract: "List created VMs")

  @Flag(name: [.short, .long], help: ArgumentHelp("Only display VM names"))
  var quiet: Bool = false

  func run() async throws {
    do {
      if !quiet {
        print("Source\tName")
      }

      displayTable("local", try VMStorageLocal().list())
      displayTable("oci", try VMStorageOCI().list().map { (name, vmDir, _) in (name, vmDir) })

      Foundation.exit(0)
    } catch {
      print(error)

      Foundation.exit(1)
    }
  }

  private func displayTable(_ source: String, _ vms: [(String, VMDirectory)]) {
    for (name, _) in vms.sorted(by: { left, right in left.0 < right.0 }) {
      if quiet {
        print(name)
      } else {
        print("\(source)\t\(name)")
      }
    }
  }
}
