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
import SwiftyTraverson
  
class Fixtures {
  
  enum MediaType: String {
    case json = "", jsonHal = ".hal"
  }
  
  private func response(file: String, code: Int32) -> OHHTTPStubsResponse {
    return OHHTTPStubsResponse(
      fileAtPath: OHPathForFile(file, self.dynamicType)!,
      statusCode: code,
      headers:["Content-Type": contentTypeHal]
    )
  }
  
  func root(code: Int32 = 200, type: MediaType = .jsonHal) -> OHHTTPStubsResponse {
    return response("root\(type.rawValue).json", code: code)
  }
  
  func collection(code: Int32 = 200, type: MediaType = .jsonHal) -> OHHTTPStubsResponse {
    return response("collection\(type.rawValue).json", code: code)
  }
  
  func item(code: Int32 = 200, type: MediaType = .jsonHal) -> OHHTTPStubsResponse {
    return response("item\(type.rawValue).json", code: code)
  }
  
  func responseWithCode(code: Int32) -> OHHTTPStubsResponse {
    var headers: Dictionary<String, String> = [:]
    if code == 201 {
      headers["Location"] = "http://\(host)/created"
      headers["Content-Type"] = contentTypeHal
    }
    
    return OHHTTPStubsResponse(data: "".dataUsingEncoding(NSUTF8StringEncoding)!, statusCode: code, headers: headers)
  }
}