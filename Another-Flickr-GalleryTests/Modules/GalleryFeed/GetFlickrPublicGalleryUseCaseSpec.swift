//
// Created by Adam Borek on 16.05.2017.
// Copyright (c) 2017 adamborek.com. All rights reserved.
//

import Foundation
import Quick
import Nimble
import RxSwift
import RxBlocking

@testable import Another_Flickr_Gallery

final class GetFlickrPublicGalleryUseCaseSpec: QuickSpec {
    override func spec() {
        describe("GetFlickrPublicGalleryUseCase") {
            var subject: GetFlickrPublicGalleryUseCase!
            var apiConnection: APIClientStub!

            beforeEach {
                apiConnection = APIClientStub()
                subject = GetFlickrPublicGalleryUseCase(apiClient: DecodableAPIClient(apiClient: apiConnection))
                let bundle = Bundle(for: type(of: self))
                let json = bundle
                        .url(forResource: "flickr_gallery_feed_sample", withExtension: "json")
                        .flatMap { try? Data(contentsOf: $0) }
                        .flatMap { try? JSONSerialization.jsonObject(with: $0) } ?? NSNull()
                apiConnection.jsonResponse = .just(json)
            }

            it("parses array of photos") {
                let expectedPhotos = [
                    PhotoMeta(title: "IMG_8249",
                              tags: [],
                              imageURL: "https://farm5.staticflickr.com/4174/33833951824_5215e9a80b_m.jpg",
                              createdAt: dateInUTC(year: 2017, month: 5, day: 12, hour: 3, minutes: 23, seconds: 50),
                              publishedAt: dateInUTC(year: 2017, month: 5, day: 15, hour: 15, minutes: 3, seconds: 27)),
                    PhotoMeta(title: "Some of our pictures",
                              tags: ["theTag"],
                              imageURL: "https://farm5.staticflickr.com/4170/33833952974_2378c05ac4_m.jpg",
                              createdAt: dateInUTC(year: 2017, month: 5, day: 12, hour: 17, minutes: 55, seconds: 59),
                              publishedAt: dateInUTC(year: 2017, month: 5, day: 15, hour: 16, minutes: 3, seconds: 31))
                ]

                let photos = try! subject.photos.toBlocking().first()!

                expect(photos) == expectedPhotos
            }
        }
    }
}
