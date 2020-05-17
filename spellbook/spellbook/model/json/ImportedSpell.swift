import Foundation

struct ImportedSpell: Codable {
  let name: String
  let level: Int
  let castingTime: String
  let range: String
  let components: SpellComponents
  let materials: String
  let duration: String
  let concentration: Bool
  let ritual: Bool
  let school: MagicSchool
  let save: String
  let effect: String
  let damageType: String
  let description: String
  let referencedSpells: [ImportedSpell]
}

enum SpellComponents {
  case verbal
  case somatic
  case material
}

enum MagicSchool {
  case conjuration
  case necromancy
  case evocation
  case abjuration
  case transmutation
  case divination
  case enchantment
  case illusion
}
