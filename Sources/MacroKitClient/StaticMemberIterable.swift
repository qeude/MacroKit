import Foundation
import MacroKit

@StaticMemberIterable
struct Chili {
  let name: String
  let heatLevel: Int

  static let jalapeño = Chili(name: "jalapeño", heatLevel: 2)
  static let habenero = Chili(name: "habenero", heatLevel: 5)
}

struct MyRecord {
  // ...
  @StaticMemberIterable
  enum Fixtures {
    static let a = MyRecord()
    static let b = MyRecord()
  }
}

// Generates a compiler warning when there aren't any static members.
@StaticMemberIterable
struct Fruit {
  let name: String
}

func testStaticMemberIterable() {
  print(Chili.allStaticMembers)
  print(MyRecord.Fixtures.allStaticMembers)
}
