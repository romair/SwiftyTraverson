/*
* Copyright 2016 smoope GmbH
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import XCTest
import OHHTTPStubs
import SwiftyJSON
import SwiftyTraverson

class TraversingJsonHalPostTests: BaseTraversingTests {
  
  let objectToAdd: Dictionary<String, AnyObject> = ["id": "3" as AnyObject, "name": "Darth Vader" as AnyObject]
  
  func testFollowUrl() {
    stub(condition: isHost(host)) { _ in
      return self.fixtures.item()
    }
    
    let expectation = self.expectation(description: "request should succeed")
    
    var test: JSON?
    traverson
      .from("http://\(host)")
      .followUri("http://\(host)/some")
      .post(objectToAdd) { result, _ in
        test = result!.data
        
        expectation.fulfill()
      }
    
    self.waitForExpectations(timeout: self.timeout, handler: nil)
    
    if let test = test {
      XCTAssertNotNil(test["_links"].dictionaryObject, "response should contain links")
      XCTAssertEqual(test["_links"].dictionaryObject!.count, 2, "response should contain 2 links")
      XCTAssertNotNil(test["id"].int, "response should contain payload")
      XCTAssertNotNil(test["name"].string, "response should contain payload")
    } else {
      XCTAssertNotNil(test, "response should exists")
    }
  }
  
  func testFollowRelation() {
    var calls = 0
    stub(condition: isHost(host)) { _ in
      calls += 1
      
      switch calls {
      case 1:
        return self.fixtures.root()
      case 2:
        return self.fixtures.item()
      default:
        return self.fixtures.responseWithCode(404)
      }
    }
    
    let expectation = self.expectation(description: "request should succeed")
    
    var test: JSON?
    traverson
      .from("http://\(host)")
      .follow("jedi")
      .post(objectToAdd) { result, _ in
        test = result!.data
        
        expectation.fulfill()
      }
    
    self.waitForExpectations(timeout: self.timeout, handler: nil)
    
    if let test = test {
      XCTAssertNotNil(test["_links"].dictionaryObject, "response should contain links")
      XCTAssertEqual(test["_links"].dictionaryObject!.count, 2, "response should contain 2 links")
      XCTAssertNotNil(test["id"].int, "response should contain payload")
      XCTAssertNotNil(test["name"].string, "response should contain payload")
    } else {
      XCTAssertNotNil(test, "response should exists")
    }
  }
}
