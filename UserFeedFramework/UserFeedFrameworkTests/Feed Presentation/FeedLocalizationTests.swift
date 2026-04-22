//
//  FeedLocalizationTests.swift
//  UserFeedFrameworkTests
//
//  Created by Dimitra Malliarou on 22/4/26.
//

import XCTest
import UserFeedFramework


final class FeedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "User"
        let presentationBundle = (Bundle(for: UserPresenter.self))
        let localizationBundles = allLocalizationBundles(in: presentationBundle)
        let allKeysAndValues = self.allLocalizedStringKeys(in: localizationBundles, table: table)
        
        localizationBundles.forEach { bundle, localization in
            allKeysAndValues.forEach { key in
                let localizedString = bundle.localizedString(forKey: key, value: nil, table: table)
                
                if localizedString == key {
                    let language = Locale.current.localizedString(forLanguageCode: localization) ?? ""
                    
                    XCTFail("Missing \(language) \(localization) localization for key: \(key) in \(table) table.")
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private typealias LocalizedBundle = (bundle: Bundle, localization: String)
    
    private func allLocalizationBundles(in bundle: Bundle, file: StaticString = #file, line: UInt = #line) -> [LocalizedBundle] {
        return bundle.localizations.compactMap { localization in
            guard let path = bundle.path(forResource: localization, ofType: "lproj"), let localizedBundle = Bundle(path: path) else {
                XCTFail("No bundle found for localization: \(localization)", file: file, line: line)
                return nil
            }
            return (localizedBundle, localization)
        }
    }
    
    private func allLocalizedStringKeys(in bundles: [LocalizedBundle], table: String, file: StaticString = #file, line: UInt = #line) -> Set<String> {
        return bundles.reduce([]) { (acc, current) in
            guard let path = current.bundle.path(forResource: table, ofType: "strings"), let dict = NSDictionary(contentsOfFile: path) as? [String: String] else {
                XCTFail("No Localizable.strings with table: \(table) found in bundle for localization: \(current.localization)", file: file, line: line)
                return acc
            }
            
            return acc.union(Set(dict.keys))
        }
    }
}
