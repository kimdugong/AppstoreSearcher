//
//  App.swift
//  AppstoreSearcher
//
//  Created by Dugong on 2020/08/06.
//  Copyright © 2020 dugong. All rights reserved.
//

import Foundation

/*
{
    "resultCount": 6,
    "results": [
        {
            "screenshotUrls": [
                "https://is5-ssl.mzstatic.com/image/thumb/Purple113/v4/0f/1a/1b/0f1a1b45-f6f2-10d7-5cc0-2a4f06b8f7a0/pr_source.png/392x696bb.png",
                "https://is4-ssl.mzstatic.com/image/thumb/Purple123/v4/56/3d/90/563d90f3-c0c8-fb76-d5b6-5ba554ddf53c/pr_source.png/392x696bb.png",
                "https://is4-ssl.mzstatic.com/image/thumb/Purple113/v4/e6/3c/ec/e63cece0-e918-4f7a-dd03-18a8dd34c447/pr_source.png/392x696bb.png",
                "https://is4-ssl.mzstatic.com/image/thumb/Purple123/v4/56/f1/d2/56f1d281-2b9c-4a26-d0bb-a69501263b73/pr_source.png/392x696bb.png",
                "https://is1-ssl.mzstatic.com/image/thumb/Purple123/v4/58/d2/e8/58d2e806-f372-2303-18a0-d41bcf547fd8/pr_source.png/392x696bb.png",
                "https://is4-ssl.mzstatic.com/image/thumb/Purple113/v4/01/eb/7d/01eb7daa-4f23-9c68-e1cf-81e063ddf263/pr_source.png/392x696bb.png"
            ],
            "ipadScreenshotUrls": [],
            "appletvScreenshotUrls": [],
            "artworkUrl60": "https://is4-ssl.mzstatic.com/image/thumb/Purple124/v4/9d/13/f1/9d13f121-e097-5bcc-01a6-07e744ec6494/source/60x60bb.jpg",
            "artworkUrl512": "https://is4-ssl.mzstatic.com/image/thumb/Purple124/v4/9d/13/f1/9d13f121-e097-5bcc-01a6-07e744ec6494/source/512x512bb.jpg",
            "artworkUrl100": "https://is4-ssl.mzstatic.com/image/thumb/Purple124/v4/9d/13/f1/9d13f121-e097-5bcc-01a6-07e744ec6494/source/100x100bb.jpg",
            "artistViewUrl": "https://apps.apple.com/kr/developer/inicis-co-ltd/id351845232?uo=4",
            "supportedDevices": [
                "iPadPro-iPadPro",
                "iPad834-iPad834",
                "iPadAirCellular-iPadAirCellular",
                "iPad71-iPad71",...
            ],
            "advisories": [],
            "isGameCenterEnabled": false,
            "features": [],
            "kind": "software",
            "trackCensoredName": "Kpay",
            "languageCodesISO2A": [
                "EN"
            ],
            "fileSizeBytes": "153479168",
            "contentAdvisoryRating": "4+",
            "averageUserRatingForCurrentVersion": 1.5789500000000000756728013584506697952747344970703125,
            "userRatingCountForCurrentVersion": 19,
            "averageUserRating": 1.5789500000000000756728013584506697952747344970703125,
            "trackViewUrl": "https://apps.apple.com/kr/app/kpay/id911636268?uo=4",
            "trackContentRating": "4+",
            "trackName": "Kpay",
            "trackId": 911636268,
            "releaseDate": "2014-11-20T07:26:03Z",
            "genreIds": [
                "6015",
                "6012"
            ],
            "formattedPrice": "무료",
            "primaryGenreName": "Finance",
            "isVppDeviceBasedLicensingEnabled": true,
            "currentVersionReleaseDate": "2020-02-20T00:01:04Z",
            "releaseNotes": "- KPAY 약관개정 및 UI 변경\n- 현대카드 할부정책 변경\n- 기타 오류 수정",
            "primaryGenreId": 6015,
            "sellerName": "INICIS CO., LTD.",
            "minimumOsVersion": "10.0",
            "description": "KPAY는 온라인 전자결제 전문기업 KG이니시스의 쉽고 빠른 간편결제입니다.\n​\n사용자가 KPAY에 신용카드/휴대폰 등의 결제정보를 미리 등록하면, 온라인 결제시 쉽고 빠르고 안전하게 결제할 수 있습니다.\n​\n[KPAY 특징]\n- 결제수단 한 번 등록으로 쉽고 빨라진 간편결제!\n- 부정거래방지시스템으로 안전하게 결제 끝!\n- 10만 가맹점에서 사용 가능한 KPAY\n​\n[필수 허용 권한]\n- 푸시 허용: PC결제시 필요하며, 가입필수값\n* 필수 권한을 허용하지 않으면, 가입이 불가합니다.\n​\n* 원활한 사용을 위해, OS는 최신버전을 권장합니다.\n​\n개발자 연락처\n - 서울시 중구 통일로 92(순화동 1-170) KG타워 14~15층\n - Tel. 1588-4954\n - e-mail. kpay@kggroup.co.kr",
            "artistId": 351845232,
            "artistName": "INICIS Co., LTD",
            "genres": [
                "금융",
                "라이프 스타일"
            ],
            "price": 0.00,
            "currency": "KRW",
            "bundleId": "com.inicis.kpay",
            "version": "3.01",
            "wrapperType": "software",
            "userRatingCount": 19
        }, ...
    ]
}
**/

struct App: Codable {
    let screenshotUrls: [String]
    let description: String
    let artworkUrl60: String
    let averageUserRatingForCurrentVersion: Double
}
