Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA56A28
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 00:55:00 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZ84Hijh153hr51SzI2fIJbmyIaXo6Q828HWhBUoSUPJApfWRm3gbjeRZFR4AClOzLZ0xDCKE7Mdes3BmgovmJRTSRzCsKfW5AZw2BlOCf4iVHRx1oq1VF4H3m8aqAwf/GU+mbV6NJWqs+iPDzoRX4c0ppfomNxuX2s7EHTYQXd2lOgRvib5S1AtdLcsHExn0ORKIECfts36P6VQe4hAJGAjtV+SP07WxqICPY93jRrs6XxMxG8t4Mq5fHaXMYej28u7nhU3q4ZnH1QkgZNaKdVPUOhC8SvhcmjRlXd9pyMZWLeMJ3LI6Au1pkavDB1I6Q+INxBg6p5goq/pe96RNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=drUluuinHji8AFLk1G2Ta4xBFtrtUwiTYETn+ETRLCg=;
 b=oZ8RqK/clMm0BbAxYqde3jvmboCkxDfRW0ZoV1M9cIMA7pxerB/WEMKJCnRdJqcTwhLBbpiKwlckG9oUlV4lYCiYW5Ckve7SllSq5RxBpwvwM/7PeA7ZW5nx/DmxccJxu2PiYMTwKrhmym/vkrALQUQXcgrCInyhlAA5iQCSPIu1fbl9R3DkXXLY2s1oU5MXMEnhSQ91VeGwPmggxh1UZVE9kZy1acXdE+heoEQgXCJSCSdrKYx01rOGNHhP2IRSZmvwh2/ZnjXI9m5FDaBE0p0OdxpnpNmGeX1wsBXJBsVCOG3XkCDCeQ50dNf5sGSV1CKtgNy6HhCbhQUPQlDGSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=drUluuinHji8AFLk1G2Ta4xBFtrtUwiTYETn+ETRLCg=;
 b=DGtbw6sRjJqTfgl02JYAb7Yv3L+zgv9P5JMMOwRrpo2g0Gwm5RT3/fiGlsuTJxJHaILWS5dhtos/cxk5J6VHEhfpawERRYl2Sshp46aJgLrRPMsZSfmtfOgMDJtIcZq89DyBa1nt3OjJefNBPaybMl8EDYkzqg0H45cb46nNbZjvLNSrlcpBiMxI4gLLVdqfgurBXWm5Xdzuv6ILN05XfWJ59DLFzpiCFQt9iDNDoyW0m9T3VNkreOhlC8f1K1PKtjsb74mBoyTtuNhUHGrGkZOqy41uquAXc7xFq2yxoC68Uhm6UzabRN567SnExmbGQEIXmwjO0bnsNc+p6GJjFw==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by LV2PR12MB5797.namprd12.prod.outlook.com (2603:10b6:408:17b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Sat, 13 May
 2023 00:54:57 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::92c6:4b21:586d:dabc%4]) with mapi id 15.20.6387.021; Sat, 13 May 2023
 00:54:57 +0000
From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>, Chaitanya Kulkarni
	<chaitanyak@nvidia.com>
CC: "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, "dave.jiang@intel.com"
	<dave.jiang@intel.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH 0/1] pmem: allow user to set QUEUE_FLAG_NOWAIT
Thread-Topic: [PATCH 0/1] pmem: allow user to set QUEUE_FLAG_NOWAIT
Thread-Index: AQHZhL6T8P8y2Gk4rkeCNAmIHrRfv69WohGAgAC/gwA=
Date: Sat, 13 May 2023 00:54:57 +0000
Message-ID: <b90ff1ba-b22c-bb37-db0a-4c46bb5f2a06@nvidia.com>
References: <20230512104302.8527-1-kch@nvidia.com>
 <ZF4/OWd9aqBaDacL@infradead.org>
In-Reply-To: <ZF4/OWd9aqBaDacL@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|LV2PR12MB5797:EE_
x-ms-office365-filtering-correlation-id: cad87444-106f-4671-850a-08db534cac12
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 k0p8WpijYWbWYLgHY6K8b1BNdtjqoYraXRQRgfyK17JswtvCE+P0k4D5jBj7haFOSXQGDT8gtfXe9ipeOdHoS1jEOvYAvDAK1ePVqBhmwW0eCKcHw7OAabdYWJ8KljhOYgBljKL7tmy2KjYLTo6S+Xp0gYAJp8kLvLxjMevu5Tn7v+lwBfH5/tdGe0cCEf/3OzcjWynmv5vdq7aNZio6AhZzh8zQCSUk7cBb5xTKEaRzVL+ANrHFyVWIsaF/daOIT18DdBg90rOVmXH8Vi8y+lbmYaNLnOJ43Q+RaP7lJyh7qf01uQsmUw8Dxcc4wxIHk5TvdhB75XX6hXI1c6pwa3QET5x/UfcWZ7+WG+1bq3oK8EQkR1WoM29Ok6rIOyhG2aZkhm0sLUnyf64sCCkCUb2qfcV5OPc7QwWQwexxewrNhvHtWpearpaFjpwJRr7ZOCXf168GeKaC1XEo9OsXwLTqNWuHyOKUo/iNdn4SUDNJE4UGkkXLEuxCQG9Q6rjwBPV+0sUcZ5qfOswR51h+YOQXahQ4zlN7HQWJ2ec1jDZKocmtjfcl39MeoVRxWIYFRrR25pwTdIdFKpS1bxQDuJh5FMTdvNxMMdh2P9Z9qsD2MPCWbyp4BaDVvJCTPPZRNVXiSZbYUw8pQxYaauOHdbGl/bIyM0mVnLazLU+bcw8O1JjI+d3FcVPcwRtSTSwX
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199021)(66556008)(31686004)(66476007)(64756008)(66946007)(91956017)(76116006)(41300700001)(66446008)(4326008)(71200400001)(110136005)(54906003)(478600001)(316002)(6486002)(6512007)(6506007)(8676002)(8936002)(5660300002)(31696002)(53546011)(86362001)(2906002)(558084003)(186003)(83380400001)(2616005)(38100700002)(38070700005)(122000001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UjdQYlNtbzh5SmRLNXBxS0VHRkpJeWZDb2NxUFVUejNmaE9ldUlxanFzQ1NI?=
 =?utf-8?B?dHF3Q1g2aTR4YkwyUWVVOWY0OWZRaWdyODRNRjZWZFNuaXEza0Y0bWRuK1NK?=
 =?utf-8?B?R21hL1gvNWo3ZHBPRzlQK04vWmlTLzlDejlESzZQcWNrSittdWxxT1BHWmI5?=
 =?utf-8?B?QVlielF3cjIzVHBMSkUxQUN4d2h3SWFoOVZlWkttMlNzZzMrNFF5cnpKNGd3?=
 =?utf-8?B?RFI2aDRrQVNGS3FzUVVHR05GQ2xEMVV3RjRrYUFvY1ZqNnVLVlU4bm1wdlRx?=
 =?utf-8?B?MlUwbTlOd0ZXOS9nNVNzbXpBVzFUYy9vb2J1U2pVeU5zU1FReHN0OGUrU2tP?=
 =?utf-8?B?K0I1VGtjcmoySDVNejl6RytNdGpZRk8wNUMyaGR6UzNWc2x6Z1JZTGJIZjVE?=
 =?utf-8?B?RzB6V3pYeFo3NGIrcVJSMkt0UW1RWElVTm05L0NGZnZBYS9ab2NlaVVxSTMr?=
 =?utf-8?B?b0YvblZ6TVNVc0JGaHdqK1Uzell4YjRsMklHeUZoc1lYUVZ6bVNSZURHL2ly?=
 =?utf-8?B?cUNGQUtxZk5qSFU5SmhzSzg2T3hwNFllL3V3VlA2K2t6cFNWb0hsbTdES3Zw?=
 =?utf-8?B?TGJpRVFCL3EvOU14RjNlK1dHYnNyZVdiMnVvMlVZSkR3U3hsVytaSEdqN2dG?=
 =?utf-8?B?aWtjRFRFZEZYRDNOVVNiZmpEVkpRRVF0Z0o1N0xyMW1RVG5aNkZmWWY4bTN5?=
 =?utf-8?B?eWZyMDRMNFFzVklaUjU5QUIzTmk4VFVJMDBBbGVBRGdqcThzckRoREl1R0xW?=
 =?utf-8?B?MU1OTFcyc1NPOWZTYWsyb3RSVmRoWW9HMmdFTDRPaUxla3p3YTY0THZ1a3lq?=
 =?utf-8?B?NzlDSFA2VENKalZmbzk3QmdwK014dE5SdncvZlhqUDdKV0gwQTVjVTVGUVNS?=
 =?utf-8?B?SDZ5b1VVR0xlaTdsWjl2RnUrVEE2Y3Z3cmp4ODBPYUcyNFRUQzVYN0ZFSWZn?=
 =?utf-8?B?VXkyMUNDK2I1dXNJbW5IbkE0d3JJa1p4bGFMM0x5b2hhZ3E0UHd4VUdXclRW?=
 =?utf-8?B?d0FHMC9PWlppV2lRbE91NXl5RWU2TkZYQkFaWU9YK2JIeHdpRHZNZG16Risw?=
 =?utf-8?B?RjRLLzFYa2o3ckxhZU9rckVVMU5zb0srMlRTTFZ6NjBWdm9xeGhUeUtMdkxo?=
 =?utf-8?B?MU81RHYwSDVlN2ZKdWoycUZKR3ZZMHA0RklMTVdnT3ZWMnE4Umd3bHpCamZx?=
 =?utf-8?B?TVVueURIc1V6M2toLzh1MUN6RGZUc0JSbVJQaTdHbHNlYlpMOE94bFZzTWFC?=
 =?utf-8?B?MCs3TUo1YjZKclhVeDBENFNlTWsxQUpBaXM0Z1NuQ1B4d0dMQjBEWnhway9O?=
 =?utf-8?B?OEZwRUw3NG5BcWNmNUpzQTVYTkUyQzlUT3BNam1vY3JOZS9XVjF6SWJ2MXV5?=
 =?utf-8?B?L3hjcTYrdmFGR1hERk9rdUJ4cEtNMkRFUk1PQjh3eldCOW5wb2NUZm1UdUVT?=
 =?utf-8?B?bU1hc0ZzWitOUjFSaFNRaHh1N09ycWFLOFdHZjZ6cHowR3BCcmwrNVRNcndo?=
 =?utf-8?B?dExZWmQwemlQbGcvM0NHNkhYUkphNk00Y3dWa2tlRFYvaG9WYWJYSnFqdGV0?=
 =?utf-8?B?VkU0RVBUWlRlL1pCNnAzVDhncUp1ejZWQXYrTHdZeS9kK2ErOTlSUyt4LzdQ?=
 =?utf-8?B?WFo3QzJYcksxT21QL3JRcUtJR0hMWUlQYTZLYmZjcC9GRC93UWlUM0UzUloz?=
 =?utf-8?B?ZDdHZjBsRjVTSlJOU1NzaW5GbitqWitraTJ3ZHlzc1ZBYmtqbVdFZ2hNVjRF?=
 =?utf-8?B?aG12bnArV29Iam41VkYwMldWOEJPa2VWR3ZlYTVCTzVyNDN4cmQ1R1kzOCtB?=
 =?utf-8?B?KzcyRWNnTXFkQThvNWpVV1ViOU4zNVhHelpiRzkwK0ZMNkJCM0RkYzZGZ0lC?=
 =?utf-8?B?cDRxTFd2TGwrbGlWUlUzaEVrNEpWR1h1S3MzMmw4ZUMxUFNYS0VDT3RpZ1U2?=
 =?utf-8?B?Qm9aTkpkZlE1MFJlOC80VVhsVHpWTEJBTy9PRzR2dTIyU0VINUhHRlFDMlFV?=
 =?utf-8?B?UWNKV01sUmRtaHlybHdaSG1TeWlNbzhzUFZCWG1HbmJCclBsVUNmNU1XNGF3?=
 =?utf-8?B?VjVXOS82VnNpTmtDMXU5emJTM0hSa3RKTysxaDhwNGtPTEQ5cmg2bW9Idk51?=
 =?utf-8?B?djE1cG8waDQxUWVEYy9GM09lb2lMak5EQ2MwNXpGYTNYeHo5eDE5RENFN1dk?=
 =?utf-8?Q?+COTFzUAhURIPFnRgUupj0mCnobt7988UoT5SVgwfpM6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7704E701B4F3504BA4E89C4E2DC214F2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cad87444-106f-4671-850a-08db534cac12
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2023 00:54:57.2194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w1T/ltc3FLqCfPmGK5BgshyUHcQ/Kpb38aSvbuSnCqxM7KkaQzQMJ8NXzJJJw3xOEXWMtAQC/DjKAGcc/MWNBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5797

T24gNS8xMi8yMyAwNjoyOSwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6DQo+IE9uIEZyaSwgTWF5
IDEyLCAyMDIzIGF0IDAzOjQzOjAxQU0gLTA3MDAsIENoYWl0YW55YSBLdWxrYXJuaSB3cm90ZToN
Cj4+IEFsbG93IHVzZXIgdG8gc2V0IHRoZSBRVUVVRV9GTEFHX05PV0FJVCBvcHRpb25hbGx5IHVz
aW5nIG1vZHVsZQ0KPj4gcGFyYW1ldGVyIHRvIHJldGFpbiB0aGUgZGVmYXVsdCBiZWhhdmlvdXIu
DQo+IFdoeT8NCg0Kbm90IG5lZWRlZCwgc2VuZGluZyB2MiB3aXRob3V0IG1vZHVsZSBwYXJhbWV0
ZXIuDQoNCi1jaw0KDQoNCg==
