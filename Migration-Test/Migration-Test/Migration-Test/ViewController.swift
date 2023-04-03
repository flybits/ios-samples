//
//  ViewController.swift
//  Migration-Test
//
//  Created by Michael Hollis on 2023-03-24.
//

import UIKit

import FlybitsSDK
import FlybitsKernelSDK
import FlybitsContextSDK

class ViewController: UIViewController {

    let onlySDKs = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        login()

    }




    func login() {



            let  = APIKeyIDP(email: "tduser@tdbank.com", apiKey: "27A3D5C8-B58C-47C1-ACFB-8B4506017AEC")
//            FlybitsManager.connect(b, projectId: "2CE41988-B1D3-4116-98DD-42FFB8754384") { user, error in
//            }

            FlybitsManager.connect(b) { user, error in
                print(user, error)
                self.fetchContent()
                self.startContext()
            }
    }

    func fetchContent() {

        let p = ["concierge-card-buttons": CustomContent.self]

        Content.getAllRelevant(with: ContentQuery(contentTypes: p, labelsQuery: nil, pager: nil)) { pagedContent, error in
            print(pagedContent?.elements, error)
            print(pagedContent?.elements[0])
        }
    }

    func startContext() {
        ContextManager.shared.startPlugins()
    }
}



//
//  APIKeyIDP.swift
//  FlybitsSDK
//
//  Created by Caio on 2021-11-02.
//  Copyright © 2021 Flybits. All rights reserved.
//

import Foundation

@objc
public class APIKeyIDP: NSObject, IDP {

    public var projectID: String?

    struct Constants {
        static let apiKey = "apikey"
        static let projectId = "projectId"
        static let email = "email"
        static let provider = "provider"
        static let accessToken = "accessToken"
        static let authenticateEndpoint = "/oauth"
    }

    public let apiKey: String
    public let email: String
    public let accessToken: String?

    public var provider: String {
        return "apikey"
    }

    public var authenticationEndPoint: String {
        return Constants.authenticateEndpoint
    }

    public var requestBody: String {
        let dict = [
            Constants.projectId: "2CE41988-B1D3-4116-98DD-42FFB8754384",
            Constants.provider: provider,
            Constants.accessToken: accessToken ?? ""
        ]

        guard
            let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions(rawValue: 0)),
            let body = String(data: data, encoding: .utf8)
        else {
            return ""
        }

        return body
    }

    public init(email: String, apiKey: String) {
        self.apiKey = apiKey
        self.email = email
        let dict: [String: String] = [
            Constants.email: email,
            Constants.apiKey: apiKey
        ]

        if let data = try? JSONSerialization.data(withJSONObject: dict, options: []) {
            accessToken = data.base64EncodedString()
        } else {
            accessToken = nil
        }
    }

    public func encode(with coder: NSCoder) {
        coder.encode(apiKey, forKey: Constants.apiKey)
        coder.encode(email, forKey: Constants.email)
    }

    public required convenience init?(coder: NSCoder) {
        guard
            let apiKey = coder.decodeObject(forKey: Constants.apiKey) as? String,
            let email = coder.decodeObject(forKey: Constants.email) as? String
        else {
            return nil
        }

        self.init(email: email, apiKey: apiKey)
    }
}


class CustomContent: ContentData {
//    required init?(responseData: Any) throws {
//        guard let representation = responseData as? [String: Any],
//            let localizedDict = representation["localizations"] as? [String: [String: Any]] else {
//            return nil
//        }
//
//        print(LocalizedObject<String>(key: "title", localizations: localizedDict))
//
//
//        try super.init(responseData: responseData)
//    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
}
