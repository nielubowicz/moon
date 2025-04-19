import Foundation

enum MoonCacheEntry {
    case ready(MoonViewModel)
    case loading(Task<MoonViewModel, Error>)
}

final class MoonCacheEntryObject {
    let entry: MoonCacheEntry
    
    init(entry: MoonCacheEntry) {
        self.entry = entry
    }
}

// https://developer.apple.com/tutorials/app-dev-training/caching-network-data
extension NSCache where KeyType == NSString, ObjectType == MoonCacheEntryObject {
    subscript(_ date: Date) -> MoonCacheEntry? {
        get {
            let key = NSString(string: date.formatted(.networkFormat))
            let value = object(forKey: key)
            return value?.entry
        }
        set {
            let key = date.formatted(.networkFormat) as NSString
            if let entry = newValue {
                let value = MoonCacheEntryObject(entry: entry)
                setObject(value, forKey: key)
            }
        }
    }
}
