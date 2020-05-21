import Foundation

final class SpellImporter {
  
  let jsonData: Data
  var spells: [ImportedSpell] = []
  
  enum ImportError: Error {
    case notFound
  }
  
  init(from jsonData: Data) {
    self.jsonData = jsonData
  }
  
  /// Reads the json file of spells, converts them to Imported Spell objects and then associates related spell objects with each other.
  /// - Throws: An JSON parsing error.
  
  func importSpells() throws {
    spells = try JSONDecoder().decode([ImportedSpell].self, from: jsonData)
    try associateSpells()
  }
  
  /// Loops through a list of referenced spells (if any), finds them and then assigns them to the related spell property.
  /// - Throws: If a referenced spell isn't found, then a NotFound error is thrown
  
  func associateSpells() throws {
    _ = try spells.map { spell in
      var spell = spell
      // loop through each spell's referenced spell list
      _ = try spell.referencedSpells.map { referencedSpell in
        // search for spell
        let foundSpell = spells.first(where: { $0.name.lowercased() == referencedSpell.lowercased() })
        // associate the found spell with the current spell (if one exists)
        if let relatedSpell = foundSpell {
          spell.relatedSpells.append(relatedSpell)
        } else {
          throw ImportError.notFound
        }
      }
    }
  }

}

