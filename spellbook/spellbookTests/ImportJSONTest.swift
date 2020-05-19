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
    do {
      try importer.importSpells()
    } catch {
      print(error)
      XCTFail("JSON importing error")
    }
    
    let spells = importer.spells

    XCTAssert(spells.count == 3, "Expected 3 spells, found \(spells.count)")
  }
  
  
  func test_ParseMaterials_threeComponentsTotal() {
    let materials = "V, S, M"
    let components = ImportedSpell.parse(components: materials)
    XCTAssert(components.count == 3)
  }

  func test_ParseMaterials_twoComponentsTotalMissing() {
    let materials = "V, , M"
    let components = ImportedSpell.parse(components: materials)
    XCTAssert(components.count == 2)
  }

  func test_ParseMaterials_twoComponents() {
    let materials = "V, M"
    let components = ImportedSpell.parse(components: materials)
    XCTAssert(components.count == 2)
  }
  
  func test_ParseMaterials_oneComponent() {
    let materials = "V"
    let components = ImportedSpell.parse(components: materials)
    XCTAssert(components.count == 1)
  }
  
  func test_ParseMaterials_threeComponentsType() {
    let materials = "V, S, M"
    let components = ImportedSpell.parse(components: materials)
    XCTAssert(components[0] == ImportedSpell.Components.verbal)
    XCTAssert(components[1] == ImportedSpell.Components.somatic)
    XCTAssert(components[2] == ImportedSpell.Components.material)
  }
  
  func test_ParseYesOrNo_Expected() {
    let yesValue = "Yes"
    let noValue = "No"
    XCTAssert(ImportedSpell.parse(yesNoValue: yesValue) == true)
    XCTAssert(ImportedSpell.parse(yesNoValue: noValue) == false)
  }
  
  func test_ParseYesOrNo_Unexpected() {
    let value1 = ""
    let value2 = "false"
    XCTAssert(ImportedSpell.parse(yesNoValue: value1) == false)
    XCTAssert(ImportedSpell.parse(yesNoValue: value2) == false)
  }
    
}
