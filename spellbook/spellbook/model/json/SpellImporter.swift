import Foundation

final class SpellImporter {
  
  let jsonData: Data
  var spells: [ImportedSpell] = []
  
  init(from jsonData: Data) {
    self.jsonData = jsonData
  }
  
  func importSpells() {
    
  }
  
}
