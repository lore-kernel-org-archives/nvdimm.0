Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9762C8B
	for <nvdimm@lists.linux.dev>; Wed, 20 Oct 2021 06:21:12 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="208804893"
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="208804893"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 23:21:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="720312605"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga005.fm.intel.com with ESMTP; 19 Oct 2021 23:21:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 19 Oct 2021 23:21:10 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 19 Oct 2021 23:21:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 19 Oct 2021 23:21:09 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 19 Oct 2021 23:21:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FotFw7D+rNcCI87adIaEqCmFP9rHD9huVfrYZZEgwu1YMwwNTllXtbDBGkhZ+5RpSv8GNJs3XJAzjz8qXYlY+v1d9o9YIeVckJNb1fSvs5S0uZOnYdyzGnCHNRJmCrAGAxxPrz2PAZAFuNgOdur/JOC0u72905G1C6w/N0m5sq7Z23mbaA5yxywSDJsb2/mFXPZS28I99nNgmVoRXsQizI+srz+BhackJdYeCuPgBi5Wq3adr1g5rg5elAfSNECdCK9bsbIXlrdmz48IC5QeUSwoQsldSDqTV9324cwhjH1YD+czRo3KnqtRSy43pCO3QtOsluFMfUozBCOGDn3WgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0EzRgw+DhvtalJP/4r8z1M+N9qxFyXkKi/1yA+nbmsc=;
 b=l11RDKJT5JZhCYjV0aXSHDxi+CDQber5XwbR1dFI5KvODCwIex8sG6sZH/ui9bk4Oa5ph/flsWeINJBLzk8gaTOJYFgd3idL7BFY0PpRiX1q4f1RcgSP2i9Trclz6KV80RgJ9tjOeRHDhtRZW6Nhlaw2P/7HvXv88qZodULoE8QatBsQ7Y/Ypa88HhQ5Xz1YF6kLz9IiYawpcdy0QnQTR46SBwzloB8+l+5SBuyQwbKY6T0QRJhsfYm0x58maHX/NOyfsj4GCfqr+s307dMOfRQz9BBkEmKdhaLfQ/i7qyHnYIUR5HXhqqLDEHAgnIjMNkVHDpaeg7DqNQI+pJbM4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EzRgw+DhvtalJP/4r8z1M+N9qxFyXkKi/1yA+nbmsc=;
 b=VLBRfY1YUu+a8hW1GXsxg7WZHK4iHWUJTS/1I+1dHYYOqVT33Zla3n31dhVzVVP7YTWP7IncnJ1dZIoor8tVm45Z6xIj+WIwSyceIBvm06qZiN4YTRcJRbuak0XoH1Ymk98+KBkXiL/y+UD8DNLzr6tAMnU05wYVHVF0bZ2m3sc=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB3887.namprd11.prod.outlook.com (2603:10b6:208:156::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Wed, 20 Oct
 2021 06:21:08 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 06:21:08 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "johnny.li@montage-tech.com" <johnny.li@montage-tech.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: can call libcxl function outside ndctl tool?
Thread-Topic: can call libcxl function outside ndctl tool?
Thread-Index: AQHXxK6HxRNjljCbT0GAsng/nfViFavba/cA
Date: Wed, 20 Oct 2021 06:21:07 +0000
Message-ID: <78e901122fa889e595e709d69a303446351540f4.camel@intel.com>
References: <20211019175518.GB47179@montage-desktop>
In-Reply-To: <20211019175518.GB47179@montage-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: montage-tech.com; dkim=none (message not signed)
 header.d=none;montage-tech.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1996a4b-fcc0-4541-5077-08d99391cdcc
x-ms-traffictypediagnostic: MN2PR11MB3887:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3887356C26628D02AF3B3878C7BE9@MN2PR11MB3887.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XCfmLyfz3gTZHKt9RNmRunB8pJb3xNIK6bmFWBY991LPeYpfxGDltWSCSHTdiz3yXSaA/IYgRXxU0zTbwg2yv176QxwwW2NsLTbEyNmvFHhfMLNUV/yGCWwga71qoip2D00PYfvsPiBwH64YprrQ+z/yK527ofolMWlpmCp0uoZPUQeQauZ3M71MnexAQdFbjIlJYJuI0j3Afk7DNjMGtuKfZzr6WYan+ENERdNH99eLJB4NQLnK5bB0T910NDXRDI65U+w1v1zkFqNxqSvz4CAtfNhOtccztgw+wRqJM0xU+XR/d1xSxieVwPgH7IKpXzl9gwEJYIBp3uudvaOGcjMARKzALMPC1HMKwD5WDpYtCM2B64LtmKAlYcY0nedy1eaSBDcuOYPKCnHvmLWME+tb2G6c+xB0Ty4tIpjTE7Za6b9i0v4JQqMFB44omTilTW+365q7GKo/TtrHvebLCwOvlDfSWnU+5ayWSvczQ93X6olBa443UpSnIY56EDFw1JOLXGnxzYRo//kR/lHdOA4FuA8HYCYBZNs1/5orwFy8Xk9W36MliNRyqvAeAhM4xccEUzF6/YhIIWwkB9Dn8UmCUkZ/I+20C5r6q2PLhRg1JdPYGvQRM4EtQ4+eSDaxlVr2rbvuJpzEz7nGTxmtj/VxHzTHAcCxXhOAHxqeD6pBAogFQYeXBEpMSP1BIOrANVwDH1YQ1Yym4Ib8Q90Ttg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(54906003)(8676002)(6506007)(4001150100001)(36756003)(26005)(4744005)(110136005)(8936002)(2616005)(4326008)(5660300002)(86362001)(66946007)(316002)(186003)(71200400001)(38070700005)(66556008)(38100700002)(83380400001)(66446008)(6486002)(122000001)(66476007)(64756008)(2906002)(508600001)(91956017)(82960400001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aWU0WVdEZXE5ZnFCRmp4K2ZCQVB2a0RqK2JVT3E0cFRwOUkreU03bEwxRWN4?=
 =?utf-8?B?cGlLK0p6OTdkWTNzbVd3MFZmK0tYc0J1N3ZyUk9NRFU3dGxwaE9MUXhaRm9p?=
 =?utf-8?B?K25LemMxYzVkbzN4bEVOZWlTMWJ1TjNpMkZJamVrYzNKN0UwYldZTGhGOS9D?=
 =?utf-8?B?VUNHbzBmSTZnd0pUZWEyakg0eVE3alRDTXBxdkJrNld2aUQ3QXFWWnRFTVJh?=
 =?utf-8?B?SGYrVzFmRnNhVk9nR0xoVE5jWUI4UlZYWEcwNXNJaSs0eDErQkFCSGd6S3E1?=
 =?utf-8?B?RFloV2d6eW41N3lTdGNpTUlNcW9PUUExTEk1L25aRWQrVitnY3BrV3d0U054?=
 =?utf-8?B?Ujl0WnhmTUZFb2RlSHdOeENEOFZkOVdoakp5V0R1aHJ5ZURMdUJ4NXRTcndU?=
 =?utf-8?B?cHJRMExMcEtSMk9lM01WZTFLNXNoTEhjclhtVkFZZEk1TDJhWkJSTHo0N201?=
 =?utf-8?B?UDdqeDF0b0pxQnZSOFlvTThKS25NcURsbWVOL0pTM2hodlFVd3c4U09BRlNL?=
 =?utf-8?B?NWNZMndoRlBndFdoclhQSzdnUVFWRFFvSUlwUXIyTytSc1NvVHh0djA1V0py?=
 =?utf-8?B?ZjNmTk16MHNKMmJNRDhjQWdlamx3ZjdZd3JxeThSeWRQUjVqWVlOcnpJWkIr?=
 =?utf-8?B?ZFo1Rkt2ZXNkNTl1RlQxK1BTU05nalEvbDdOZlRpZXowOGM0U093TUtPeXhn?=
 =?utf-8?B?VXRETVE3ZkNnb21mQXB6UGxFV2JDdm8wY2pFaDJXdWFvNHRVQnBHa2MvZTda?=
 =?utf-8?B?RnVEU05IWUJsbi81bzE2SVA2K2RCMEVqMXpJbDZWazJadDZtSWh2dElkcElQ?=
 =?utf-8?B?OVZvdHJQSERiZ2orZXhhQVVpdThWeWNtais0OU1KL0hJR01uOHh4N0IyQzNw?=
 =?utf-8?B?Vmtja01QWU12RDBadFBVYy9BZnJyMHlXdVBBT1orbmFFMlo1SmFIdXpjblYx?=
 =?utf-8?B?OWNqY1dPL0RTNllzcDgwSzZ4QXBtUVFFeVpjRVVRU3FoTGduRm03UHJzVTV0?=
 =?utf-8?B?S005UC9vTTBaSlkwK0pqa053dlZuTjNmY3AwZXV3WGRRRDNwMjFWYllMaEEy?=
 =?utf-8?B?YTNqTjIrVERyaW9CZmdqTzFtdnppR09jK2RiODlLbmJJckdQeDIvYWY2YVds?=
 =?utf-8?B?NW9rVlJWZGJvUVZIRERva2RNbjBuTXYzMWF3K1I3RFRyRUxHd2wva2ZacVdV?=
 =?utf-8?B?V3ZZQ0U3emQ4Q2RkbzB0NEdWa0d3M1ZTbU12aE12QzdLSFFrRlNsME55c2Fw?=
 =?utf-8?B?NjJ1QjVBdkZIOUdLMGhLNlUvMnBYR2pWN1dXT1hyVnIwS05OMWh2TVhvR0tK?=
 =?utf-8?B?REp1dlBNQ1hSeTErMFFGWXdVWUJKOWVFTmRrSjJWVU1YbXZXTUlKQU5iRDhp?=
 =?utf-8?B?cE5rTGRPeWk3TzkvTXdtTTdaaExSYnU5L21mTVJCQ2ZwQ21IcXB0Z0Q5YnZn?=
 =?utf-8?B?TGJzNGRaaHZJK2hndVZxb3FubkVDRGcvZGRiN24wNGU4U0FwbW80SWFWYWkw?=
 =?utf-8?B?Tk5zY1ZxWHRwUFpQTTIrdFZwbFp1ZnpCMlBaQm1mMHRHQjY0UzllQklVajhQ?=
 =?utf-8?B?amtXZUw0UEVEbXhSTnZvWEdwZEdFZUJobjZLSDl6MGNWZmp2WFZVZG1KaDNz?=
 =?utf-8?B?Y3R6YXJsQXBTVmw0RDdlb25CNCsxYjRrclFhZ3Q1eFkrNjhJTktxTnZGRjdR?=
 =?utf-8?B?c1FWWkhmY1ZKWUNLV3FXZ2dhTCtvbWJiNldudkR3eWxTNGY4WTVRbWJnU2lQ?=
 =?utf-8?B?a2NXdWNtd1dnQ24wTXlXcTRhZVlKc25nUklEYzBOMjlFWkNtVDlmaUJ3ZUNn?=
 =?utf-8?B?eFIyd2t5N1JVRzNrSXJqdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02F9F0F9C0C3AE4D8E5C4A0C5F66EBF7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1996a4b-fcc0-4541-5077-08d99391cdcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2021 06:21:07.9867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1PRAULPa5ohFKvTCYyPm9cdPs4gAotBaW2TbyAtGfXDlrQ4wHryQ2bcq3yMjcrE4wjyJVGqzi0HWmh/WsEoYDkt2vRGd1lGcnHZOp7+4zrM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3887
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIxLTEwLTE5IGF0IDEzOjU1IC0wNDAwLCBMaSBRaWFuZyB3cm90ZToNCj4gVGFr
ZSBjeGxfY21kX25ld19pZGVudGlmeSBhcyBleGFtcGxlLg0KPiBUaGVyZSBpcyBDWExfRVhQT1JU
IHByZWZpeCwgaXQgc2VlbXMgY2FuIGJlIGNhbGxlZCBvdXRzaWRlIG5kY3RsIHRvb2wuDQoNClll
cyBpdCBjYW4gYmUgbGlua2VkIHRvIGxpa2UgYW55IG90aGVyIGxpYnJhcnkuDQoNCj4gV2hpbGUg
dGhlIGludHB1dCBhbmQgb3V0cHVzdCBzdHJ1Y3QgY3hsX21lbWRldiBhbmQgY3hsX2NtZCBhcmUg
cHJpdmF0ZS4NCj4gDQo+IGBgYA0KPiANCj4gQ1hMX0VYUE9SVCBzdHJ1Y3QgY3hsX2NtZCAqY3hs
X2NtZF9uZXdfaWRlbnRpZnkoc3RydWN0IGN4bF9tZW1kZXYgKm1lbWRldikNCj4gew0KPiAJcmV0
dXJuIGN4bF9jbWRfbmV3X2dlbmVyaWMobWVtZGV2LCBDWExfTUVNX0NPTU1BTkRfSURfSURFTlRJ
RlkpOw0KPiB9DQo+IA0KPiBgYGANCg0KUmlnaHQgLSB0aGUgaW50ZW50aW9uIGlzIHRoYXQgdGhv
c2Ugc3RydWN0cyBhbHdheXMgcmVtYWluIHByaXZhdGUuDQpJbnN0ZWFkIHdlIHByb3ZpZGUgYWNj
ZXNzb3IgQVBJcyB0byBnZXQgZmllbGRzIG91dCBvZiB0aGUgZGlmZmVyZW50DQpjb21tYW5kIHN0
cnVjdHVyZXMuIGUuZy4gZm9yICdpZGVudGlmeScgd2UgaGF2ZQ0KY3hsX2NtZF9pZGVudGlmeV9n
ZXRfZndfcmV2LCBhbmQgc28gb24uIElmIHRoZXJlIGFyZSBvdGhlciBmaWVsZHMgdGhhdA0KbGFj
ayB0aGVzZSBnZXR0ZXIgQVBJcywgd2UgY2FuIGRlZmluaXRlbHkgYWRkIHRoZW0uIGUuZy4gVGhl
DQpoZWFsdGhfaW5mbyBjb21tYW5kIGhhcyBhbiBleGhhdXN0aXZlIHNldCBvZiBnZXR0ZXIgQVBJ
cy4NCg0KPiANCj4gDQo+IFRoYW5rcw0KPiBKb2hubnkNCj4gDQo+IA0KDQo=
