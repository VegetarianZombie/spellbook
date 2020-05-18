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
  let referencedSpells: [String]
  
  enum ParsingError: Swift.Error {
    case noComponents
  }
  
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
    referencedSpells = ImportedSpell.parse(referencedSpells: try values.decode(String.self, forKey: .referencedSpells))
  }

  /// Converts string of spell names into an array of spell names
  /// - Parameter referencedSpells: Takes a string of spell names separted by commas such as "Alert, Magic Missle, Light"
  /// - Returns: An array of strings without whitespace
  
  static func parse(referencedSpells: String) -> [String] {
    guard referencedSpells.isEmpty == false else {
      return [] // empty array for an empty string
    }
    let extractedSpells = referencedSpells.split(separator: ",")
    var formattedSpells = [String]()
    if extractedSpells.count > 1 {
      formattedSpells = extractedSpells.compactMap { spell in
        spell.trimmingCharacters(in: .whitespaces)
      }
    } else {
      // called when only one spell is passed as a parameter.
      formattedSpells.append(referencedSpells.trimmingCharacters(in: .whitespaces))
    }
    return formattedSpells
  }
  
  /// Converts a string  to an array of components.
  /// - Parameter components: A string of spell components such as "V, S, M"
  /// - Returns: An array of components representing components
  
  static func parse(components: String) -> [Components]  {
    let individualComponents = components.split(separator: ",")
    let spellComponents = individualComponents.compactMap { component -> Components? in
      Components(rawValue: component.trimmingCharacters(in: .whitespaces).lowercased())
    }
    assert(!spellComponents.isEmpty, "Every spell should have at least one component")
    return spellComponents
  }
  
  /// Converts a yes/no string into a boolean value
  /// - Parameter yesNoValue: Take in a yes or no value
  /// - Returns: Returns either a true or false value. False returns is the default return value
  
  static func parse(yesNoValue: String) -> Bool {
    if yesNoValue.lowercased() == "yes" {
      return true
    }
    return false
  }
  
  
}


