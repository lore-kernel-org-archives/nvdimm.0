Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10042.outbound.protection.outlook.com [40.107.1.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686F83481
	for <nvdimm@lists.linux.dev>; Thu, 29 Jul 2021 00:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B837LvsqlGY9Pm9ZCQOOf/KYQS8CyoqrKPRjknDKGcU=;
 b=PB2l6lppPm0nd63CccaROdiLEeidJzLKq5KziOKYGmcWgWHvDfE6nnEQ4HOvGS/KRy18SqW9iAyWAvMlH6gtWsrnL0w+IwPsmZ096BhhuuWlIcN/EH1tIh6hSEdw2hCmRWKOHdvZgPjm66JHbdF9stp7P3YJzvibAHQrWqeO61c=
Received: from DB6PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:6:2c::30) by
 AM6PR08MB3863.eurprd08.prod.outlook.com (2603:10a6:20b:8b::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.28; Thu, 29 Jul 2021 00:21:02 +0000
Received: from DB5EUR03FT061.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:6:2c:cafe::ec) by DB6PR07CA0116.outlook.office365.com
 (2603:10a6:6:2c::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.8 via Frontend
 Transport; Thu, 29 Jul 2021 00:21:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; lists.linux.dev; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;lists.linux.dev; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT061.mail.protection.outlook.com (10.152.21.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 00:21:01 +0000
Received: ("Tessian outbound 1e4fcc40c873:v100"); Thu, 29 Jul 2021 00:21:01 +0000
X-CR-MTA-TID: 64aa7808
Received: from cc5cf15003c7.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 6A3E7FB1-A3FA-41F4-A559-EBFB1CDDAF03.1;
	Thu, 29 Jul 2021 00:20:55 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id cc5cf15003c7.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 29 Jul 2021 00:20:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chEcXfzKErXk0ydOwJjU5naFI1tm+5Ait5wdxOVIcObeDxOGzO6YRa9Ki6Y9uyaYlHR6bI2C6JO6Ztsv3OdJmH+OdBhzAYs2NjUVeXqN19dVuMomWG9cd9Ie7j1L6qK4Re0JPwuLYGCquSeN9DN0lHZ8I+1T4WKOGJyXAY3zfi9uyVzFyeyADNUTVhwHM2/ScotkQ3HCNd7u2OMIF4WpuK2HHoTn61Mub9Av1pbiSs4aviZgMwJCQ3xisEZ/Rzjp2y/8v3uEUnzSPaqCIH6+a6AMLsGRV/LFNQopdpaavg6S1bmW++t6FTQzQex2tdCThdF1F0xkKYRMnpZeht/2Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B837LvsqlGY9Pm9ZCQOOf/KYQS8CyoqrKPRjknDKGcU=;
 b=R9A/MhNi58X1OeIUah4mUcunN68K8KOyuy2KF1y8Nt3diNYjmoexUV5FCE1KrRAbdhLZy7/fANeTSSNe4eZ/lcYEcnTQ033uYsHqMPWs2QHDZx/c7ZI92eEVCQnGJ7F0Duq/b6AGWeXROJwC9p+V95DqWs3FO6Avh9fi0wlzOilpzQw1KL802ll79QjcXUcOxsixW9JN0dSz6bq730/whTlqC4aHWCYPGQI+q4EZ/givU4FzETAE3JQ7rihgdRnDgRPiY4ucORrcRBVsqcOXD3y9ZSd3qNXtId2MGjSunL3a0ltyyt+P6sC39X1gt9/DWVK0pPHNmcJLi1+0tgNM8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B837LvsqlGY9Pm9ZCQOOf/KYQS8CyoqrKPRjknDKGcU=;
 b=PB2l6lppPm0nd63CccaROdiLEeidJzLKq5KziOKYGmcWgWHvDfE6nnEQ4HOvGS/KRy18SqW9iAyWAvMlH6gtWsrnL0w+IwPsmZ096BhhuuWlIcN/EH1tIh6hSEdw2hCmRWKOHdvZgPjm66JHbdF9stp7P3YJzvibAHQrWqeO61c=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AS8PR08MB6901.eurprd08.prod.outlook.com (2603:10a6:20b:39c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Thu, 29 Jul
 2021 00:20:40 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1%5]) with mapi id 15.20.4352.031; Thu, 29 Jul 2021
 00:20:39 +0000
From: Justin He <Justin.He@arm.com>
To: David Hildenbrand <david@redhat.com>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, nd
	<nd@arm.com>
Subject: RE: [PATCH] device-dax: use fallback nid when numa_node is invalid
Thread-Topic: [PATCH] device-dax: use fallback nid when numa_node is invalid
Thread-Index: AQHXg4m9IaMvGdbjFEawG5ZIccmDr6tY1AuAgABDhaA=
Date: Thu, 29 Jul 2021 00:20:38 +0000
Message-ID:
 <AM6PR08MB437663A6F8ABE7FCBC22B4E0F7EB9@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210728082226.22161-1-justin.he@arm.com>
 <20210728082226.22161-2-justin.he@arm.com>
 <fc31c6ab-d147-10c0-7678-d820bc8ec96e@redhat.com>
In-Reply-To: <fc31c6ab-d147-10c0-7678-d820bc8ec96e@redhat.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ts-tracking-id: 47F1EEEB3B7D764EA3B7BD6F080E1B46.0
x-checkrecipientchecked: true
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 31351cff-f632-409d-ba14-08d95226bf36
x-ms-traffictypediagnostic: AS8PR08MB6901:|AM6PR08MB3863:
X-Microsoft-Antispam-PRVS:
	<AM6PR08MB38630ADF507D91449E358305F7EB9@AM6PR08MB3863.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:6108;OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original:
 IsNheqpO+GfCDqOvuf9xHTI92iiNvV1DnCdKh4z2CeOWpY2uCsEskfvrMw17euBJUzl60/vzHFkTHIPm/KVXeOcbz9GjY4zqnc5iUkDSnmW9Jl89EqJZxWBvCwbTjkkrw8pwR0VSdSfeT3NLBvlm5SwxUh9XdMR1+i+EGNBUTA24D9HgBFX7ci65VgjC4I8TGdD5i5141fCLkuCmo0b7Wo9HHJo8Gk7sadtP3UDTdaBOgxWT2Z6ALUS6NoUT2tZz1FP8T33muKtkuhWVrnIYW1eh5SnwRhsDFiO67nvRsni0bmDVoGzRdVjVxcEOfTRqlStdK+/zFlLYGYoFPGreurbxHQ3GpLsVVTVRcq1sceQ1Y5i8JUNWolDCBQ2Btf1FPGuGIn8j+QyxsvWFfHy63znkHyi7eykjENcvBqX8ktMPq1YzHZy0VsvQ0/t0mfW8U+kVbWZCZBwBDWIn49C9JP7neUDKoDPxf/N0rOypFiLhcUPkZPHWzG0gAxEFuDFOLE2GVuXK6Mcwhron8UWh+lTCPVosL8imvyk789FPrb17zlG7i6SPiRhT1dkir+n1Oi57jRNx8kygUrCtN+c1mxuNhPIShH6qTkPRQO0iwBO7/5Y0tzLVLirRZj+/V+M10DAD/Ea++uBDqMjscOkXFCJexA/5lmSNknww53vnWF+iYMijX3j0fTjQNhCX0GfGD5xAhtiIwuNI1rDr8btanSwjRkpUdevpp081nfcTMdEdTmI767ebWuT4kg/t46Jb9KmIWVwSquv7fVdZbk75AikYO/YaFjt/TGwLiTUJmvowwOUt3xeCGCwCvYQ1ZZsHB5XSgEaLgz9OPuZ7A4PAyw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(396003)(366004)(346002)(376002)(4326008)(122000001)(5660300002)(7696005)(53546011)(38070700005)(6506007)(83380400001)(38100700002)(76116006)(66946007)(52536014)(8676002)(54906003)(66476007)(966005)(66556008)(64756008)(66446008)(71200400001)(316002)(478600001)(9686003)(86362001)(55016002)(26005)(110136005)(186003)(2906002)(8936002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OUdLTnpyRWNVWG9sUEw1RXRjZ0IwdVV4ZXNQbXRaMmZhS0hDMzF4bzlFSDQ1?=
 =?utf-8?B?elNtenNzWjY5b3FldXVvY2NPUDBkaUJpVWpORlBaWDFJYnJGMTlkVktSckVC?=
 =?utf-8?B?UlVtT21KMVdxNGVxcVZWRVNhaGpxMklVYjBUVW1WcTdDQmhHdlUxVk15M1R0?=
 =?utf-8?B?WENpNGNvT3hhTHlOeDhwTFY4M2l4YVNFVFQvYXBZSFJQdGZld1orNWJjTVhH?=
 =?utf-8?B?Tm5WVEYwVGlkd1ZtSTM2NUdNM2ZPTGFlSnd4RWJiRTU4VFYvZk0yVk8vTmlY?=
 =?utf-8?B?ZXlicnZKRHhoUU9iNEhIaENLSTJkNWF4enVXTmFWaFJnY2k0T1RQbHVSVFNQ?=
 =?utf-8?B?YmNtT0ZmR0g2YkphRi94d2plbktFYkxTbFhSWFhzYXloUU1BMnFFK2tJNWU5?=
 =?utf-8?B?N3M0ejR6SkhyendGZG9DUm02ZWpHRnJzTUJ0a2pnUnlKTGRqeXRJYUhEamp0?=
 =?utf-8?B?SEw1M3FZMVNEZ0puekRCMnI4Y0kxUlpzR3BLWGFJU2MrV0JSNDRKdmZSMDBo?=
 =?utf-8?B?NXU2VU5mSGF6ZUJSMk8xN3VUaE8xeEFMUlBiSlg3YVBPa25DcjZaMVdYelB0?=
 =?utf-8?B?UHlKTW1HSmh2RGkyR2MvSmRwdEkrdEo2QUF3RlNJZy9sd0lFUHN0M1NMbHUy?=
 =?utf-8?B?aU5La0NQdy9OdHR5aU45RllWb1RIeWhtRjBqVmtSQURVVGFJb1ZVZmVVVTUz?=
 =?utf-8?B?Nm93dDJnVzAxczczVGcyLzExRmFXRHBDYk0yaXVpbmVJV2NTTE5leVhUbXJK?=
 =?utf-8?B?LzZ6YjVkQWpMOEozWERPeVc0dmVNYVA2ejg5bFBlQW9iMTdpR0xkNUNRZjZW?=
 =?utf-8?B?L3dITXI4bUU4UXJoWEhmVTZuQXhxWFdyVmgybk5YejZHdU9IZmQ5dlUyNkNu?=
 =?utf-8?B?KzZPRTNlbW9UcE4vUFlEYUl2Zy9IOG5EZXNBTzQyWE9UU1E1ejRRODFVRkM5?=
 =?utf-8?B?dW85aDN3RVpJb3B4WmkzSGpvMVFaQmNVTXJhNnBwOVdSUWRSQXNrZnFHZDR2?=
 =?utf-8?B?ejVNQnFTWU5DbGlrWXRqQ2JkOUk3cEF4T09hRWlHdVM2cHo2SloycTBjUFBD?=
 =?utf-8?B?VFF6aE5mNFJBQ2IwMFR6R1A3bmYrNFNOVHh6azAzVEp3UW5rak1KdmJmWnps?=
 =?utf-8?B?Tk5hMDZyWlRMTGIvZytEQTE1bE1LZnNzbVZIcy85ZGxxVGh1eTBPVGs0R3hB?=
 =?utf-8?B?NnhVVFZJaXZwYUVQb3JoZkhvMzZrMFlsTXJqNERnSVFRT3krZnNDSHZjZ3R4?=
 =?utf-8?B?SmZpMGJHYzJNTFJEZmFzMzhWdVdtSlB5S3lrS0ZCMEVJNUN2Q0F1Um1Rb2Nq?=
 =?utf-8?B?aFVSV2ZJMk4vekV2WUZkYWIvTS92aEo5N1RiZjRrdGlaWDZDTEZNblZkL2RN?=
 =?utf-8?B?WUJ4RmpXeWJhMWx4bStxbEc1bVU0VmF1NUJZaW1qYVRTNjA2Z2Q1NXdHNGVO?=
 =?utf-8?B?di9JbmJwTUpZUTFnR1ZwMm5UM2pWd2JFQ2tzaFNhRFRSaXpaQWpNbk1EeGQ4?=
 =?utf-8?B?SzhCenc5VkNvYlMwMWQrVkdZbGNoSlk4ZXdJOWN3ZmNQdnZRODVQZ3lvcXJz?=
 =?utf-8?B?T0VVeU1ZWW5OaXcyaXBSUFptNGluSERSbjJOOWNqTTRoTGVyY0c5MFEvZDhU?=
 =?utf-8?B?U1UxQ0FIQ3JPMXdrQnB4bVdWYTVmVGljZkp3dEV0OGFzU3VlcytIdFRaSGFO?=
 =?utf-8?B?eUh1MTlydGt4TmZpdW0ybkxQMnY2Ui9WckZsNzhrTFJRR3pFZVJiNzJkMmR2?=
 =?utf-8?Q?2gPS1qCHUuIGei5AOmS8tKZbk0vMcdlcZX8F1dL?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6901
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5EUR03FT061.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	95510a13-d80d-4f60-5789-08d95226b207
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	T7mvdHu0221eIK0deTQGE0HYB3OChVer+hP8p5Tb8b1edqWxJLPmWrtXv5vlnx57u3rqKNBjaAQCvRuHyQshZKqZzQk0zRR780UyyFffiJhMou3vIem4TgTjR7+QXXbbMbIVInifj6BlA73n5BLxhiwFiweJ0wOoeZ9XDtGEniqkE9d7bjjxXztpONxDDXURwxBw1cgRbfRpSdfCE71KiWTACVpxjSxR8kBE5tfwkc4l533jitqzrE3Ot6qp7xTyBSBvwERh7pK2qaFkHKDIt6xxba6l5Ip4fSQh8gbE4c1hPg/BEBQGjT+ZHF/LJjT/xYD30oLmfWz1IVYFT9eQ209E2cUza8JFHjcTZqGkidvpNktD+KyQglWY0t0IFimJGmjU9BgtyWYBwaIsDNtxal5omU0h0bcenK08v3V7FPimuUNeeoamnarKZbDDop/Kn99BpzKoe5oALTZL/qahtcritF7RIkEup8G2IZOBx5GtoET1FaUyBTc9J26YSWeHtDjfBzjwEtkuBGVmqYNiRycpnmq9+HDtfTZaJEh0CXS2SZ7OsPK1Wl9buT0AZ72UHWyCjslxcYsK0vUCQBOLrcMIYAEJT+T5Lv79S3HZOBqxp/DzTCUa+bl5talvf/PdsJj81LTy71NIn+dAZHazqr+0AuJIJXQeH8SBbLtbODElFB7KnjH6wcBGmfbhdFee/aYLIBmriBM16VTbEyjYNWi5jYooboQG7kFmrDi4dyI1EbMajj7QoSujsdbxsLdwQjQ8Oh4oGflLCaMIswSM1NEJ9Kf1oD4nDQYz3rienpsXVnTEQ+Rxot3g6GIXhUKYWCU3MIOFy/lfZ1jS3Z+How==
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(396003)(136003)(36840700001)(46966006)(86362001)(52536014)(33656002)(47076005)(7696005)(336012)(9686003)(110136005)(356005)(186003)(70206006)(54906003)(478600001)(2906002)(82740400003)(966005)(8936002)(4326008)(316002)(6506007)(36860700001)(8676002)(82310400003)(81166007)(83380400001)(70586007)(5660300002)(53546011)(55016002)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 00:21:01.9825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31351cff-f632-409d-ba14-08d95226bf36
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5EUR03FT061.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3863

SGkgRGF2aWQNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBI
aWxkZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEp1bHkgMjks
IDIwMjEgNDoxNyBBTQ0KPiBUbzogSnVzdGluIEhlIDxKdXN0aW4uSGVAYXJtLmNvbT47IERhbiBX
aWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPjsNCj4gVmlzaGFsIFZlcm1hIDx2aXNo
YWwubC52ZXJtYUBpbnRlbC5jb20+OyBEYXZlIEppYW5nIDxkYXZlLmppYW5nQGludGVsLmNvbT4N
Cj4gQ2M6IG52ZGltbUBsaXN0cy5saW51eC5kZXY7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IG5kIDxuZEBhcm0uY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBkZXZpY2UtZGF4OiB1
c2UgZmFsbGJhY2sgbmlkIHdoZW4gbnVtYV9ub2RlIGlzIGludmFsaWQNCj4gDQo+IE9uIDI4LjA3
LjIxIDEwOjIyLCBKaWEgSGUgd3JvdGU6DQo+ID4gUHJldmlvdXNseSwgbnVtYV9vZmYgd2FzIHNl
dCB1bmNvbmRpdGlvbmFsbHkgaW4gZHVtbXlfbnVtYV9pbml0KCkNCj4gPiBldmVuIHdpdGggYSBm
YWtlIG51bWEgbm9kZS4gVGhlbiBBQ1BJIHNldCBub2RlIGlkIGFzIE5VTUFfTk9fTk9ERSgtMSkN
Cj4gPiBhZnRlciBhY3BpX21hcF9weG1fdG9fbm9kZSgpIGJlY2F1c2UgaXQgcmVnYXJkcyBudW1h
X29mZiBhcyB0dXJuaW5nDQo+ID4gb2ZmIHRoZSBudW1hIG5vZGUuIEhlbmNlIGRldl9kYXgtPnRh
cmdldF9ub2RlIGlzIE5VTUFfTk9fTk9ERSBvbg0KPiA+IGFybTY0IHdpdGggZmFrZSBudW1hLg0K
PiA+DQo+ID4gV2l0aG91dCB0aGlzIHBhdGNoLCBwbWVtIGNhbid0IGJlIHByb2JlZCBhcyBhIFJB
TSBkZXZpY2Ugb24gYXJtNjQgaWYNCj4gPiBTUkFUIHRhYmxlIGlzbid0IHByZXNlbnQ6DQo+ID4g
ICAgJG5kY3RsIGNyZWF0ZS1uYW1lc3BhY2UgLWZlIG5hbWVzcGFjZTAuMCAtLW1vZGU9ZGV2ZGF4
IC0tbWFwPWRldiAtcyAxZw0KPiAtYSA2NEsNCj4gPiAgICBrbWVtIGRheDAuMDogcmVqZWN0aW5n
IERBWCByZWdpb24gW21lbSAweDI0MDQwMDAwMC0weDJiZmZmZmZmZl0gd2l0aA0KPiBpbnZhbGlk
IG5vZGU6IC0xDQo+ID4gICAga21lbTogcHJvYmUgb2YgZGF4MC4wIGZhaWxlZCB3aXRoIGVycm9y
IC0yMg0KPiA+DQo+ID4gVGhpcyBmaXhlcyBpdCBieSB1c2luZyBmYWxsYmFjayBtZW1vcnlfYWRk
X3BoeXNhZGRyX3RvX25pZCgpIGFzIG5pZC4NCj4gPg0KPiA+IFN1Z2dlc3RlZC1ieTogRGF2aWQg
SGlsZGVuYnJhbmQgPGRhdmlkQHJlZGhhdC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogSmlhIEhl
IDxqdXN0aW4uaGVAYXJtLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvZGF4L2ttZW0uYyB8
IDM2ICsrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLQ0KPiA+ICAgMSBmaWxlIGNo
YW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDE2IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvZGF4L2ttZW0uYyBiL2RyaXZlcnMvZGF4L2ttZW0uYw0KPiA+IGluZGV4
IGFjMjMxY2MzNjM1OS4uNzQ5Njc0OTA5ZTUxIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvZGF4
L2ttZW0uYw0KPiA+ICsrKyBiL2RyaXZlcnMvZGF4L2ttZW0uYw0KPiA+IEBAIC00NiwyMCArNDYs
NyBAQCBzdGF0aWMgaW50IGRldl9kYXhfa21lbV9wcm9iZShzdHJ1Y3QgZGV2X2RheCAqZGV2X2Rh
eCkNCj4gPiAgIAlzdHJ1Y3QgZGF4X2ttZW1fZGF0YSAqZGF0YTsNCj4gPiAgIAlpbnQgcmMgPSAt
RU5PTUVNOw0KPiA+ICAgCWludCBpLCBtYXBwZWQgPSAwOw0KPiA+IC0JaW50IG51bWFfbm9kZTsN
Cj4gPiAtDQo+ID4gLQkvKg0KPiA+IC0JICogRW5zdXJlIGdvb2QgTlVNQSBpbmZvcm1hdGlvbiBm
b3IgdGhlIHBlcnNpc3RlbnQgbWVtb3J5Lg0KPiA+IC0JICogV2l0aG91dCB0aGlzIGNoZWNrLCB0
aGVyZSBpcyBhIHJpc2sgdGhhdCBzbG93IG1lbW9yeQ0KPiA+IC0JICogY291bGQgYmUgbWl4ZWQg
aW4gYSBub2RlIHdpdGggZmFzdGVyIG1lbW9yeSwgY2F1c2luZw0KPiA+IC0JICogdW5hdm9pZGFi
bGUgcGVyZm9ybWFuY2UgaXNzdWVzLg0KPiA+IC0JICovDQo+ID4gLQludW1hX25vZGUgPSBkZXZf
ZGF4LT50YXJnZXRfbm9kZTsNCj4gPiAtCWlmIChudW1hX25vZGUgPCAwKSB7DQo+ID4gLQkJZGV2
X3dhcm4oZGV2LCAicmVqZWN0aW5nIERBWCByZWdpb24gd2l0aCBpbnZhbGlkIG5vZGU6ICVkXG4i
LA0KPiA+IC0JCQkJbnVtYV9ub2RlKTsNCj4gPiAtCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiAtCX0N
Cj4gPiArCWludCBudW1hX25vZGUgPSBkZXZfZGF4LT50YXJnZXRfbm9kZSwgbmV3X25vZGU7DQo+
ID4NCj4gPiAgIAlkYXRhID0ga3phbGxvYyhzdHJ1Y3Rfc2l6ZShkYXRhLCByZXMsIGRldl9kYXgt
Pm5yX3JhbmdlKSwNCj4gR0ZQX0tFUk5FTCk7DQo+ID4gICAJaWYgKCFkYXRhKQ0KPiA+IEBAIC0x
MDQsNiArOTEsMjAgQEAgc3RhdGljIGludCBkZXZfZGF4X2ttZW1fcHJvYmUoc3RydWN0IGRldl9k
YXggKmRldl9kYXgpDQo+ID4gICAJCSAqLw0KPiA+ICAgCQlyZXMtPmZsYWdzID0gSU9SRVNPVVJD
RV9TWVNURU1fUkFNOw0KPiA+DQo+ID4gKwkJLyoNCj4gPiArCQkgKiBFbnN1cmUgZ29vZCBOVU1B
IGluZm9ybWF0aW9uIGZvciB0aGUgcGVyc2lzdGVudCBtZW1vcnkuDQo+ID4gKwkJICogV2l0aG91
dCB0aGlzIGNoZWNrLCB0aGVyZSBpcyBhIHJpc2sgYnV0IG5vdCBmYXRhbCB0aGF0IHNsb3cNCj4g
PiArCQkgKiBtZW1vcnkgY291bGQgYmUgbWl4ZWQgaW4gYSBub2RlIHdpdGggZmFzdGVyIG1lbW9y
eSwgY2F1c2luZw0KPiA+ICsJCSAqIHVuYXZvaWRhYmxlIHBlcmZvcm1hbmNlIGlzc3Vlcy4gRnVy
dGhlcm1vcmUsIGZhbGxiYWNrIG5vZGUNCj4gPiArCQkgKiBpZCBjYW4gYmUgdXNlZCB3aGVuIG51
bWFfbm9kZSBpcyBpbnZhbGlkLg0KPiA+ICsJCSAqLw0KPiA+ICsJCWlmIChudW1hX25vZGUgPCAw
KSB7DQo+ID4gKwkJCW5ld19ub2RlID0gbWVtb3J5X2FkZF9waHlzYWRkcl90b19uaWQocmFuZ2Uu
c3RhcnQpOw0KPiA+ICsJCQlkZXZfaW5mbyhkZXYsICJjaGFuZ2luZyBuaWQgZnJvbSAlZCB0byAl
ZCBmb3IgREFYDQo+IHJlZ2lvbiAlcFJcbiIsDQo+ID4gKwkJCQludW1hX25vZGUsIG5ld19ub2Rl
LCByZXMpOw0KPiA+ICsJCQludW1hX25vZGUgPSBuZXdfbm9kZTsNCj4gPiArCQl9DQo+ID4gKw0K
PiA+ICAgCQkvKg0KPiA+ICAgCQkgKiBFbnN1cmUgdGhhdCBmdXR1cmUga2V4ZWMnZCBrZXJuZWxz
IHdpbGwgbm90IHRyZWF0DQo+ID4gICAJCSAqIHRoaXMgYXMgUkFNIGF1dG9tYXRpY2FsbHkuDQo+
ID4gQEAgLTE0MSw2ICsxNDIsNyBAQCBzdGF0aWMgdm9pZCBkZXZfZGF4X2ttZW1fcmVtb3ZlKHN0
cnVjdCBkZXZfZGF4DQo+ICpkZXZfZGF4KQ0KPiA+ICAgCWludCBpLCBzdWNjZXNzID0gMDsNCj4g
PiAgIAlzdHJ1Y3QgZGV2aWNlICpkZXYgPSAmZGV2X2RheC0+ZGV2Ow0KPiA+ICAgCXN0cnVjdCBk
YXhfa21lbV9kYXRhICpkYXRhID0gZGV2X2dldF9kcnZkYXRhKGRldik7DQo+ID4gKwlpbnQgbnVt
YV9ub2RlID0gZGV2X2RheC0+dGFyZ2V0X25vZGU7DQo+ID4NCj4gPiAgIAkvKg0KPiA+ICAgCSAq
IFdlIGhhdmUgb25lIHNob3QgZm9yIHJlbW92aW5nIG1lbW9yeSwgaWYgc29tZSBtZW1vcnkgYmxv
Y2tzIHdlcmUNCj4gbm90DQo+ID4gQEAgLTE1Niw4ICsxNTgsMTAgQEAgc3RhdGljIHZvaWQgZGV2
X2RheF9rbWVtX3JlbW92ZShzdHJ1Y3QgZGV2X2RheA0KPiAqZGV2X2RheCkNCj4gPiAgIAkJaWYg
KHJjKQ0KPiA+ICAgCQkJY29udGludWU7DQo+ID4NCj4gPiAtCQlyYyA9IHJlbW92ZV9tZW1vcnko
ZGV2X2RheC0+dGFyZ2V0X25vZGUsIHJhbmdlLnN0YXJ0LA0KPiA+IC0JCQkJcmFuZ2VfbGVuKCZy
YW5nZSkpOw0KPiA+ICsJCWlmIChudW1hX25vZGUgPCAwKQ0KPiA+ICsJCQludW1hX25vZGUgPSBt
ZW1vcnlfYWRkX3BoeXNhZGRyX3RvX25pZChyYW5nZS5zdGFydCk7DQo+ID4gKw0KPiA+ICsJCXJj
ID0gcmVtb3ZlX21lbW9yeShudW1hX25vZGUsIHJhbmdlLnN0YXJ0LCByYW5nZV9sZW4oJnJhbmdl
KSk7DQo+ID4gICAJCWlmIChyYyA9PSAwKSB7DQo+ID4gICAJCQlyZWxlYXNlX3Jlc291cmNlKGRh
dGEtPnJlc1tpXSk7DQo+ID4gICAJCQlrZnJlZShkYXRhLT5yZXNbaV0pOw0KPiA+DQo+IA0KPiBO
b3RlIHRoYXQgdGhpcyBwYXRjaCBjb25mbGljdHMgd2l0aDoNCj4gDQo+IGh0dHBzOi8vbGttbC5r
ZXJuZWwub3JnL3IvMjAyMTA3MjMxMjUyMTAuMjk5ODctNy1kYXZpZEByZWRoYXQuY29tDQo+IA0K
PiBCdXQgbm90aGluZyBmdW5kYW1lbnRhbC4gRGV0ZXJtaW5pbmcgYSBzaW5nbGUgTklEIGlzIHNp
bWlsYXIgdG8gaG93IEknbQ0KPiBoYW5kbGluZyBpdCBmb3IgQUNQSToNCj4gDQo+IGh0dHBzOi8v
bGttbC5rZXJuZWwub3JnL3IvMjAyMTA3MjMxMjUyMTAuMjk5ODctNi1kYXZpZEByZWRoYXQuY29t
DQo+IA0KDQpPa2F5LCBnb3QgaXQuIFRoYW5rcyBmb3IgdGhlIHJlbWluZGVyLg0KU2VlbXMgbXkg
cGF0Y2ggaXMgbm90IHVzZWZ1bCBhZnRlciB5b3VyIHBhdGNoLg0KDQoNCi0tDQpDaGVlcnMsDQpK
dXN0aW4gKEppYSBIZSkNCg0KDQo=
