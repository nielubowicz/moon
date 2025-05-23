import Foundation

extension Sequence {
    func asyncMap<T>(_ transform: @escaping (Element) async -> T) async -> [T] {
        return await withTaskGroup(of: T.self) { group in
            var transformedElements = [T]()

            for element in self {
                group.addTask {
                    await transform(element)
                }
            }

            for await transformedElement in group {
                transformedElements.append(transformedElement)
            }

            return transformedElements
        }
    }

    func asyncCompactMap<T>(_ transform: @escaping (Element) async -> T?) async -> [T] {
        return await withTaskGroup(of: T?.self) { group in
            var transformedElements = [T]()

            for element in self {
                group.addTask {
                    await transform(element)
                }
            }

            for await transformedElement in group {
                guard let transformedElement = transformedElement else { continue }
                transformedElements.append(transformedElement)
            }

            return transformedElements
        }
    }
}
