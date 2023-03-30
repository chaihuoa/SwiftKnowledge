import Foundation

let quote = "The primary factor leading to the significance of alienation among the neighbors is prosperity of economy."
let tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]

var result = [String]()

func partsOfSpeech(for text: String) {
    tagger.string = text
    let range = NSRange(location: 0, length: text.utf16.count)
    tagger.enumerateTags(in: range, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
        if let tag = tag {
            let word = (text as NSString).substring(with: tokenRange)
//            print("\(word): \(tag.rawValue)")
            result.append("\(word): \(tag.rawValue)")
        }
    }
}

partsOfSpeech(for: "prosperity")
print(result)


func namedEntityRecognition(for text: String) {
    tagger.string = text
    let range = NSRange(location: 0, length: text.utf16.count)
    let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
    tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, stop in
        if let tag = tag, tags.contains(tag) {
            let name = (text as NSString).substring(with: tokenRange)
            print("\(name): \(tag.rawValue)")
        }
    }
}

namedEntityRecognition(for: "prosperity")
