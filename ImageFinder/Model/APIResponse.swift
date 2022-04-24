

import Foundation
struct APIResponse: Codable{
    let total: Int
    let total_pages: Int
    let results: [Result]
}
