import Foundation

struct Exchange: Decodable {
    let exchangeId: String
    let rank: Int
    let name: String?
    let website: String?
    let volume1hrsUsd: Double
    let volume1dayUsd: Double
    let volume1mthUsd: Double
    
    private enum CodingKeys: String, CodingKey {
        case exchangeId = "exchange_id"
        case name, rank, website
        case volume1hrsUsd = "volume_1hrs_usd"
        case volume1dayUsd = "volume_1day_usd"
        case volume1mthUsd = "volume_1mth_usd"
    }
    
    init(
        exchangeId: String,
        rank: Int, name: String?,
        website: String?,
        volume1hrsUsd: Double,
        volume1dayUsd: Double,
        volume1mthUsd: Double
    ) {
        self.exchangeId = exchangeId
        self.rank = rank
        self.name = name
        self.website = website
        self.volume1hrsUsd = volume1hrsUsd
        self.volume1dayUsd = volume1dayUsd
        self.volume1mthUsd = volume1mthUsd
    }
}
