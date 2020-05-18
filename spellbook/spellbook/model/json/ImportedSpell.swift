import Foundation

struct ImportedSpell: Decodable {
  let name: String
  let level: Int
  let castingTime: String
  let range: String
  let components: [Components]
  let materials: String
  let duration: String
  let concentration: Bool
  let ritual: Bool
  let school: School
  let save: String
  let effect: String
  let damageType: String
  let description: String
  let referencedSpells: String
  
  enum CodingKeys: String, CodingKey {
    case name
    case level
    case castingTime
    case range
    case components
    case materials
    case duration
    case concentration
    case ritual
    case school
    case save
    case effect
    case damageType
    case description
    case referencedSpells
  }
  
  enum Components: String {
    case verbal = "v"
    case somatic = "s"
    case material = "m"
  }

  enum School: String {
    case conjuration
    case necromancy
    case evocation
    case abjuration
    case transmutation
    case divination
    case enchantment
    case illusion
    
  }
 
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)
    level = try values.decode(Int.self, forKey: .level)
    castingTime = try values.decode(String.self, forKey: .castingTime)
    range = try values.decode(String.self, forKey: .range)
    components = ImportedSpell.parse(components: try values.decode(String.self, forKey: .components))
    materials = try values.decode(String.self, forKey: .materials)
    duration = try values.decode(String.self, forKey: .duration)
    concentration = ImportedSpell.parse(yesNoValue: try values.decode(String.self, forKey: .concentration))
    ritual = ImportedSpell.parse(yesNoValue: try values.decode(String.self, forKey: .ritual))
    school = School(rawValue: try values.decode(String.self, forKey: .school))! // if school doesn't exist, crash the import
    save = try values.decode(String.self, forKey: .save)
    effect = try values.decode(String.self, forKey: .effect)
    damageType = try values.decode(String.self, forKey: .damageType)
    description = try values.decode(String.self, forKey: .description)
    referencedSpells = try values.decode(String.self, forKey: .referencedSpells)
  }
  
  static func parse(components: String) -> [Components] {
    let individualComponents = components.split(separator: ",")
    let spellComponents = individualComponents.compactMap { component -> Components? in
      Components(rawValue: component.trimmingCharacters(in: .whitespaces).lowercased())
    }
    return spellComponents
  }
  
  static func parse(yesNoValue: String) -> Bool {
    if yesNoValue.lowercased() == "yes" {
      return true
    }
    return false
  }
  
  
}


