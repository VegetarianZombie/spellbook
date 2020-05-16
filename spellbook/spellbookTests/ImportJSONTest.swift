import XCTest
@testable import spellbook

final class ImportJSONTest: XCTestCase {
  
  func test_importJSON_count() {
    
    let bundle = Bundle(for: ImportJSONTest.self)
    guard let testUrl = bundle.url(forResource: "test-spells", withExtension: "json"),
          let testData = try? Data(contentsOf: testUrl) else {
      XCTFail("Unable to load test data")
      return
    }
    
    let importer = SpellImporter(from: testData)
    importer.importSpells()
    let spells = importer.spells
    
    XCTAssert(spells.count == 3, "Expected 3 spells, found \(spells.count)")
  }
  
}
