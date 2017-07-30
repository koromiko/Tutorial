//: Playground - noun: a place where people can play

import UIKit




//MARK: Test

class HttpClientTests: XCTestCase {
    
    var httpClient: HttpClient!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        httpClient = HttpClient(session: session)
        
    }
    override func tearDown() {
        super.tearDown()
    }
    
    
    func test_get_requestWithURL() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        
        let url = URL(string: "https://mockurl")
        httpClient.get(url: url) { (success, response) in
            
        }
        
        XCTAssert(session.lastURL == url)
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func test_get_returnData() {
        let expectedData = "{}".data(using: .utf8)
        
        session.nextData = expectedData
        
        var actualData: Data?
        httpClient.get(url: URL(string: "http://mockurl")!) { (data, error) in
            actualData = data
        }
        
        XCTAssertNotNil(actualData)
    }
    
}

HttpClientTests.defaultTestSuite().run()