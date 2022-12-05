import Foundation
import XCTest
@testable import BreakingBad

protocol MockURLResponder {
    static func respond(to request: URLRequest) throws -> Data
}

class MockURLProtocol<Responder: MockURLResponder>: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let client = client else { return }

        do {
            let data = try Responder.respond(to: request)
            let response = try XCTUnwrap(HTTPURLResponse(
                url: XCTUnwrap(request.url),
                statusCode: 200,
                httpVersion: "HTTP/1.1",
                headerFields: nil
            ))

            client.urlProtocol(self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed
            )
            client.urlProtocol(self, didLoad: data)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }

        client.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

extension URLSession {
    convenience init<T: MockURLResponder>(mockResponder: T.Type) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol<T>.self]
        self.init(configuration: config)
        URLProtocol.registerClass(MockURLProtocol<T>.self)
    }
}

extension Character {
    enum MockDataURLResponder: MockURLResponder {
        static let characters = [Character(id: 0, name: "testName", image: "testURL")]

        static func respond(to request: URLRequest) throws -> Data {
            return try JSONEncoder().encode(characters)
        }
    }
}

extension Quote {
    enum MockDataURLResponder: MockURLResponder {
        static let quotes = [Quote(id: 0, quote: "testQuote")]

        static func respond(to request: URLRequest) throws -> Data {
            return try JSONEncoder().encode(quotes)
        }
    }
}

