//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Maria Habib on 28/10/2021.
//

import XCTest
import Hippolyte
@testable import NewsApp

class NewsAppTests: XCTestCase {
    
    var viewModel: NewsListViewModel!
    
    var didStartLoadingCalledExpectation: XCTestExpectation!
    var didFinishLoadingCalledExpectation: XCTestExpectation!
    var didFailLoadingCalledExpection: XCTestExpectation!
    
    let didStartLoadingCalledExpectationDescription = "didStartLoadingCalledExpectation"
    let didFinishLoadingCalledExpectationDescription = "didFinishLoadingCalledExpectation"
    let didFailLoadingCalledExpectationDescription = "didFailLoadingCalledExpectation"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.viewModel = NewsListViewModel(dataManager: NewsDataManager(remoteDataManager: RemoteNewsDataManager()), delegate: self)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
    }

    //Test number of news articles are loaded successfully with complete details and view model returns correct number of news articles
    //Test required delegate methods are called
    func testNewsLoadedSuccessfully() throws {
        //Setting up stub response to get json data
        if let url = APIPath.topHeadlinesURL {
            var stub = StubRequest(method: .GET, url: url)
            var response = StubResponse()
            let body = JSONHelper().loadJSONDataFrom(fileName: "News")
            response.body = body
            stub.response = response
            Hippolyte.shared.add(stubbedRequest: stub)
            Hippolyte.shared.start()
            
            //Setting up expectations
            didStartLoadingCalledExpectation = expectation(description: didStartLoadingCalledExpectationDescription)
            didFinishLoadingCalledExpectation = expectation(description: didFinishLoadingCalledExpectationDescription)
            
            //Calling view model to load data and wait for expectations
            self.viewModel.load()
            waitForExpectations(timeout: 10)
            
            //Check if view model returns correct number of objects
            XCTAssertEqual(viewModel.numberOfNewsItems(), 20)
        }
    }
    
    //Test that empty json is handled and required delegate methods are called
    func testNewsLoadingFailed() throws {
        if let url = APIPath.topHeadlinesURL {
            var stub = StubRequest(method: .GET, url: url)
            var response = StubResponse()
            let body = JSONHelper().loadJSONDataFrom(fileName: "Empty")
            response.body = body
            stub.response = response
            Hippolyte.shared.add(stubbedRequest: stub)
            Hippolyte.shared.start()
            
            //Setting up expectations
            didStartLoadingCalledExpectation = expectation(description: didStartLoadingCalledExpectationDescription)
            didFailLoadingCalledExpection = expectation(description: didFailLoadingCalledExpectationDescription)
            
            //Calling view model to load data and wait for expectations
            self.viewModel.load()
            waitForExpectations(timeout: 10)
        }
    }
    
    //Test article model is properly populated
    func testNewsViewModel() {
        do {
            let data = JSONHelper().loadJSONDataFrom(fileName: "News")
            let result = try JSONDecoder().decode(APIResponse.self, from: data)
            XCTAssertEqual(result.articles.count, 20)
            
            guard let article = result.articles.first else { return }
            let newsCellViewModel = NewsCellViewModel(news: article)
            
            XCTAssertEqual(article.title, newsCellViewModel.titleText)
            XCTAssertEqual(article.description, newsCellViewModel.description)
            XCTAssertEqual(article.urlToImage, newsCellViewModel.imageURL?.absoluteString)
        
        } catch {
            print("Error: \(error)")
            XCTAssert(false, "News articles not loaded.")
        }
    }
}

extension NewsAppTests: NewsListViewModelDelegate {
    func didStartLoading() {
        didStartLoadingCalledExpectation.fulfill()
    }
    
    func didFinishLoading() {
        didFinishLoadingCalledExpectation.fulfill()
    }
    
    func didFailLoading(message: String) {
        didFailLoadingCalledExpection.fulfill()
    }
    
    func displayDetails(newsArticle: Article) {
        //Not tested
    }
}
