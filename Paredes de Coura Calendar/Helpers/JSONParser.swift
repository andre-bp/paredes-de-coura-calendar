import Foundation

final class JSONParser {
    static let shared = JSONParser()
    
    func parse(filename: String) -> [Concert] {
        do {
            guard let data = readLocalFile(forName: filename) else { return [] }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedData = try decoder.decode(ConcertsData.self, from: data)

            return decodedData.concerts
        } catch {
            print("decode error")
            print(error)
            return []
        }
    }

    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }

        return nil
    }
}

struct ConcertsData: Decodable {
    let concerts: [Concert]
}
