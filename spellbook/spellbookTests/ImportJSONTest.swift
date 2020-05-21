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

  func test_importJSON_first() {
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
    guard let spell = importer.spells.first else {
      XCTFail()
      return
    }
    XCTAssert(spell.name == "Acid Arrow")
    XCTAssert(spell.level == 2)
    XCTAssert(spell.castingTime == "1 Action")
    XCTAssert(spell.range == "90 ft")
    XCTAssert(spell.area == "")
    XCTAssert(spell.components[0] == ImportedSpell.Components.verbal)
    XCTAssert(spell.components[1] == ImportedSpell.Components.somatic)
    XCTAssert(spell.components[2] == ImportedSpell.Components.material)
    XCTAssert(spell.materials == "powdered rhubarb leaf and an adder’s stomach")
    XCTAssert(spell.duration == "Instantaneous")
    XCTAssert(spell.concentration == false)
    XCTAssert(spell.ritual == false)
    XCTAssert(spell.school == ImportedSpell.School.evocation)
    XCTAssert(spell.save == "None")
    XCTAssert(spell.effect == "Damage")
    XCTAssert(spell.description == "A shimmering green arrow streaks toward a target within range and bursts in a spray of acid. Make a ranged spell attack against the target. On a hit, the target takes 4d4 acid damage immediately and 2d4 acid damage at the end of its next turn. On a miss, the arrow splashes the target with acid for half as much of the initial damage and no damage at the end of its next turn\\n\\n**At Higher Levels**. When you cast this spell using a spell slot of 3rd level or higher, the damage (both initial and later) increases by 1d4 for each slot level above 2nd.")
    XCTAssert(spell.referencedSpells.isEmpty)
  }
  
  func test_importJSON_referencedSpells() {
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
    let spell = importer.spells[1]
    XCTAssert(spell.name == "Arcane Lock")
    XCTAssert(spell.level == 2)
    XCTAssert(spell.castingTime == "1 Action")
    XCTAssert(spell.range == "Touch")
    XCTAssert(spell.area == "")
    XCTAssert(spell.components[0] == ImportedSpell.Components.verbal)
    XCTAssert(spell.components[1] == ImportedSpell.Components.somatic)
    XCTAssert(spell.components[2] == ImportedSpell.Components.material)
    XCTAssert(spell.materials == "gold dust worth at least 25 gp, which the spell consumes")
    XCTAssert(spell.duration == "Until dispelled")
    XCTAssert(spell.concentration == false)
    XCTAssert(spell.ritual == false)
    XCTAssert(spell.school == ImportedSpell.School.abjuration)
    XCTAssert(spell.save == "None")
    XCTAssert(spell.effect == "Utility")
    XCTAssert(spell.description == "You touch a closed door, window, gate, chest, or other entryway, and it becomes locked for the duration. You and the creatures you designate when you cast this spell can open the object normally. You can also set a password that, when spoken within 5 feet of the object, suppresses this spell for 1 minute. Otherwise, it is impassable until it is broken or the spell is dispelled or suppressed. Casting --knock-- on the object suppresses **arcane lock** for 10 minutes. \\n\\nWhile affected by this spell, the object is more difficult to break or force open; the DC to break it or pick any locks on it increases by 10.")
    XCTAssert(spell.referencedSpells[0] == "Knock")
  }
  
}
