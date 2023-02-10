Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CB3624
	for <nvdimm@lists.linux.dev>; Fri, 10 Feb 2023 01:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675991452; x=1707527452;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gojcScSSsR5ZY86S0gx+tfuTLyKlpv4MWembfSM2i8s=;
  b=nj/3EPyQF9z4payiKLo4aAB63PpBItXx1YuanB8VTx/Mp/341RgfMpTz
   GUAFUX98UFtHzhOlOBYciJkGg/kn93QyShBY+R6jLPH7LI6cWvflbP94j
   mI6pJ9E+5avD0vI1HCLbFgyKCAp7V1WPqNYPDQv6MPvlj5CvxhtX1vnGj
   tnX5gs4aBH67jTahT0x3E2n4gNZyXAASeb9ZJ8OOEAEF8Xf+hWbZPNCbV
   +st2aIw71Gly5iWCdaEncm9C3XK90lZCf5/2uox54NY7X0m/VW8hpz7KN
   0OfhUfmpebfowdkioMcA/KriCXr2iihwRdjMwcAL9CgABC1Ni5wiC6FKJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="318317067"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="318317067"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 17:10:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="617728822"
X-IronPort-AV: E=Sophos;i="5.97,285,1669104000"; 
   d="scan'208";a="617728822"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 09 Feb 2023 17:10:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 17:10:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 17:10:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 17:10:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SaSgY1F2tHeAVjuDGNDaJTjBssYs/RFq9Y8fK+zlnp7JZPsIDUdoXeOb9vUNjROcXgBEs/Z/XaSv09S2jgmgOw3/SzO6pcT9AqpBBxAMTAnJxrTSKyuieg9h2WNSUvWp/GfVhTl8kn+q2ocNYu7USipAtTB2n6CfukHG5II1XN83K82Q1SmmiC8qDAlHMfCZzxACxa/58dl9OonLIWg4vRpO05tQp22zNTHy6zf7hOgbBe26aAcVTPiI43IfTBdz+cGRTg0XRZJZjwSg3jJJ7AGsv36cN5RoO8fwmhmxD76ySfkU/GJTRT+d68vSs3efrbh9BUzyrVWRKgFEq4DZ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gojcScSSsR5ZY86S0gx+tfuTLyKlpv4MWembfSM2i8s=;
 b=fg8vqFXuq32ksFE0ZuDYFMXsyboepgXVmgG4twd1fJh4rwvL2KVtlcVG577PNIWNPfbphp0ZY8oEqNEgCHCy2du7Uye4hab1fQAGacVmrgKlMpMvjXRewQIloXwyPVuW47EinM60HZj3nlaFB9tkBPaszCi3mJCmoI5bBOl3LFE8+AmNwQxT6eLvOZ7a3yWKsZFvCDghOl58R7vHy7mavZz3kHveThcrjx6Uyb4wIR4cJSkcNAdPkCZIM9mQw9m8WNnaHQNzPtgDoHxbQLR7jdzG9qGMbzg3fCmkTL70mh3/lov5/G6YdkcoOQ2sZ0vYYoi33izt/MFc1umtNh/w9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by LV2PR11MB5974.namprd11.prod.outlook.com (2603:10b6:408:17e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Fri, 10 Feb
 2023 01:10:47 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627%5]) with mapi id 15.20.6086.017; Fri, 10 Feb 2023
 01:10:45 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "fan.ni@samsung.com" <fan.ni@samsung.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "gregory.price@memverge.com"
	<gregory.price@memverge.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "Jonathan.Cameron@Huawei.com"
	<Jonathan.Cameron@Huawei.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 3/7] cxl: add core plumbing for creation of ram
 regions
Thread-Topic: [PATCH ndctl 3/7] cxl: add core plumbing for creation of ram
 regions
Thread-Index: AQHZOyjQmol0gElqfEWoXyX0vnCTrq7HYNeAgAAB1YA=
Date: Fri, 10 Feb 2023 01:10:44 +0000
Message-ID: <4bfa274f616bc6167439d5a822b60bf4c7121f0e.camel@intel.com>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
	 <20230120-vv-volatile-regions-v1-3-b42b21ee8d0b@intel.com>
	 <CGME20230210010415uscas1p1211243c08bc794b314f7b20bdad93267@uscas1p1.samsung.com>
	 <20230210010409.GB883957@bgt-140510-bm03>
In-Reply-To: <20230210010409.GB883957@bgt-140510-bm03>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|LV2PR11MB5974:EE_
x-ms-office365-filtering-correlation-id: a93bf7d9-b7c8-4c8e-5a61-08db0b03a2cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5D1Lp6JDAJZtYHPacLymRZe9xmai043lGx4eXqGdma/yGxRiBgrXjuVbUGeB24tNJVBzhlOYNEzUe95T/scG0RTs3khiutqOPIa3cvxi3Fln2rL9YfbIxtk/d0agThz/1Fs6We4uDEmWWFrTLqVpFchMh40el8kZ9/Hzjz4IAdL/7RoJPfV9mY9GuE88BauhYbsQu0hVDKP7/gS/Pn/hT++2M8aLpq0yWZuR3EhNAVMTMxMwoLw6SQ1/68LHmE8DiBphKqsAnv4yfPnZw2gcawejNcot0L0IeXjkflLB7Wo+gYVDG6mHJDSbp+b77PLAeBrr8RJ2XJINomM7wYGueNWqAN6NEbusIjxpPPSMkNxb7N1lGhA1/i3PCh4P6YTuKPAIpTGFnYcgaHZ3JN/82strxidu6m6zPFZigqHebJl82P9qjdnWARccCTxjissYjGySoKVTuic6PXkhRGdfagqFc2qa9mDY1P01WlrFa4z/jOnGPAz5KQz/6Aduj7bFJHqpEVq2X7YmXjEZJQqsOvINviDeqj/5nREzQ3yqjnmObP5+HaL/kG6DeRufOVc4na1ryrxlJAu79VCGmixDDaYqXsg1Uk+ZdoClBGEXnFE+brlaBUHIhpiQJ0zb/k78UNcEMjckK9rqV80M28w3fgY2hnPDKZNuymWo5mSYQvm4/7ysuwwJcOovsNbGpLJ3QYMUppMRg8Fh15IlDEO7ww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199018)(122000001)(82960400001)(38100700002)(8936002)(6512007)(186003)(26005)(5660300002)(6486002)(2616005)(36756003)(4744005)(38070700005)(71200400001)(4326008)(478600001)(6506007)(76116006)(66946007)(66556008)(91956017)(64756008)(316002)(6916009)(8676002)(66476007)(86362001)(66446008)(54906003)(2906002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGZpcVFXWTFsdlNyQ0V3dGlKSlFBVHptYzFCVk9hSytvWFlxMGpSQUNsNENI?=
 =?utf-8?B?OWM4RlI4aFlQTThCTmVyUm9CdVZGN0IwVmVUY3VUYlhrYVZBT09kbEs1N3VO?=
 =?utf-8?B?RDNidHAvWmxZb3FlczRLcFdtaVZCb0JWWVcreC9sekFFd2hiS1gwaHVTVUJT?=
 =?utf-8?B?elU3YUVSZWRtU25ISEJXWTEzK1F6OElZVzhadDNqK1lMcEU1Ky96ajdReWwv?=
 =?utf-8?B?U1cvYWxKenppaUlIMlM3QTFnSlB3c0I2TkZSVWpKcGEzeERndDFORzZ4aVRS?=
 =?utf-8?B?V25xWk4zUzJOZkdjNFMzMDY2dVVjQmN1V2JkN2J1Nkh6Vm5lYUNZOVNMbzla?=
 =?utf-8?B?ZmlkNjQ0Ung5ZzRZQ0p1VGhrVk83dWd0ZGVwc25sN2tSVHhpRHptckNNa1hv?=
 =?utf-8?B?UElYdy9VbTZkMlgyUWVCYTYvbjM5MUZSOGUzZGZvQ2s3cFNSeUs3dkwxemox?=
 =?utf-8?B?UlZVbjR0RlJNUHFoMkRFNzdiL1pHb1hhZndDRnJ4d0ZYOXBEclhVeHNmRFhM?=
 =?utf-8?B?Qm9ZTkt6cUUzNjhtL0dnUnN5SHRCODFmVXVmQ1RjZXVZNHpBNWQwVWZTc1l3?=
 =?utf-8?B?UlIzSVZlaEJ2TVZtcmtFYnRzY2V2ZVFwc3F6N3p5NDVieXhaaGFVc25UNkg4?=
 =?utf-8?B?RzZndGxxcWdMd2o3bEZQSHpKMVVtdzN4eFFoaWlwTkR4NWZidnFlV0hBUnBn?=
 =?utf-8?B?L3JwbmZzOGJ0MjVwWktxcHdKL1cyS1l1L1N2S05Cak54cGhOSUZDTmIvM2NG?=
 =?utf-8?B?eWJVanJ4cDd6dlpYUTlyczR6ZGRPaWxMWWJiT0ljYnlZZU13WU95S1Ywalpn?=
 =?utf-8?B?KzAwRyt5d1YyZHlYYU03WjJnQ29MZzhyd2RBQXRNdnZ0YWQ2U0c4UlNPc29C?=
 =?utf-8?B?VDVyUEdIZ1VWMnpGWkk0eVdCMC9qODZhU2tvMzNtV2U5b0lzQWwxNVVBTjRi?=
 =?utf-8?B?M0FYWWxGdFk4MHllak5OTlVsRkZzS0orUG5oNVFFMFh6bUN2MkprWVJ5YitQ?=
 =?utf-8?B?ZG84K1FHcVNiWTRwSm1rTkUybjdRNlNXQitIS0dGN25qbWxqQWM1UHU4UlFu?=
 =?utf-8?B?ZEhrQmpNUWNGM3hlQ2NnWjA4ZHh2VTdlVjQ5dE9vUmJTdVZIVnNQTHpZL3hD?=
 =?utf-8?B?SHpwYzgvVndnU3E2UzUrdSt6M29TNFVLcE1OWHR3bUNENDd4VHJQSFhMa3dq?=
 =?utf-8?B?dlFhNlJndm5ITVd5aXAwdjNSckJOcnRWdFBsLzExUFcxb0M0NkpBRE85d3Vx?=
 =?utf-8?B?ZzdmNGN1RHMzcDlVWjhRM0FqK04vcTBiYTFYa2xMbG9KWFJYaEZoZDJFaXVC?=
 =?utf-8?B?WWpDc1k4NHRmTWNKRTFqTlFyTWx3TlZpWkYyL1NTdXVFWU5UQVEzK3NkSm02?=
 =?utf-8?B?WWluUTB2WWxVVHEyQ1cyS0h1a25NUDhOTS9CWk5DUVY4TlBjWUhTdlFDemFI?=
 =?utf-8?B?SDk5b1RpZGdtMklyZ0Z1K25IdGtXb1JUWVJRQzBCMnNlQVA4TURJVXM3ZzBE?=
 =?utf-8?B?OU8wMWtvM3pKSnBBY2FhbC9pOXVGc3o5WnRuRDYrd2tkaGlvRmFkc2FzVFkv?=
 =?utf-8?B?NVM1SmFlN0lsWlNENi9oUkQ4MzhoYUJpdjljSjFTL2J1cEtvdE4zSGtJdVpT?=
 =?utf-8?B?cnZaVy9TN0NSVFlpVGM3cFNEMmxnbUw0TzZWWGY4aG9lRnhDS0NGbFFUOGc1?=
 =?utf-8?B?cGpzODRldmhkbVZqYXlneDFaWUt4ZVp4Mlltb2lvODZaVlZqSGdiRk84ZHFP?=
 =?utf-8?B?aFdUaFJrRFZqL3VxaU03YWtQckxOc0t6elE2dFJmcGJVek96bDNyb2RCWDht?=
 =?utf-8?B?eFYrb0FraGhodEdqT1AyOEFvMVQ2dmNCOVpFLzdTYzhpaEY3YzkycFNNZjda?=
 =?utf-8?B?WXhmYkwrcEJFRnFkL21NQW1ISW43eUFWcHEwWkNER2s1K1dJcTY5U0VXbjc2?=
 =?utf-8?B?a1NyRmxzaUpzV0tvUUVwZHVHTld5NDBCNUhSZE9BUlpoNVZUTmFTYlhCNVhM?=
 =?utf-8?B?QVJEQmMyK1RrU2V3U2FIRzBONU1ZR2dKV0xNZExBSXpGRlFJeGRnUzRFNkZ0?=
 =?utf-8?B?a2pyYXNHQ1RBS2pDZ2plRkZXcnVaK3ExcC9ZZlZqcFY5TDNZT1dsZitSQnla?=
 =?utf-8?B?bHVmZUpLeSt5Z3p4dVNVbFl2TWM0eEFRSUc2aXh4MGlZV09nbGVWaG9yY1d0?=
 =?utf-8?B?WGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F1FFBB5EE79294292F0290119FFADA4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a93bf7d9-b7c8-4c8e-5a61-08db0b03a2cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 01:10:44.6475
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RZNg4ogOR3YoFpDMtjeuIc9vJFR299Mtz66L9bd/TzzvdbMlDJ5OO0T27dnP8LjDAqafTKDwYwe6wJ7JWoea4ze2nJOJobR6DcymwwpNehc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5974
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIzLTAyLTEwIGF0IDAxOjA0ICswMDAwLCBGYW4gTmkgd3JvdGU6DQo+IE9uIFR1
ZSwgRmViIDA3LCAyMDIzIGF0IDEyOjE2OjI5UE0gLTA3MDAsIFZpc2hhbCBWZXJtYSB3cm90ZToN
Cj4gPiBBZGQgc3VwcG9ydCBpbiBsaWJjeGwgdG8gY3JlYXRlIHJhbSByZWdpb25zIHRocm91Z2gg
YSBuZXcNCj4gPiBjeGxfZGVjb2Rlcl9jcmVhdGVfcmFtX3JlZ2lvbigpIEFQSSwgd2hpY2ggd29y
a3Mgc2ltaWxhcmx5IHRvIGl0cyBwbWVtDQo+ID4gc2libGluZy4NCj4gPiANCj4gPiBFbmFibGUg
cmFtIHJlZ2lvbiBjcmVhdGlvbiBpbiBjeGwtY2xpLCB3aXRoIHRoZSBvbmx5IGRpZmZlcmVuY2Vz
IGZyb20NCj4gPiB0aGUgcG1lbSBmbG93IGJlaW5nOg0KPiA+IMKgIDEvIFVzZSB0aGUgYWJvdmUg
Y3JlYXRlX3JhbV9yZWdpb24gQVBJLCBhbmQNCj4gPiDCoCAyLyBFbGlkZSBzZXR0aW5nIHRoZSBV
VUlELCBzaW5jZSByYW0gcmVnaW9ucyBkb24ndCBoYXZlIG9uZQ0KPiA+IA0KPiA+IENjOiBEYW4g
V2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBW
aXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCj4gDQo+IFJldmlld2VkLWJ5
OiBGYW4gTmkgPGZhbi5uaUBzYW1zdW5nLmNvbT4NCg0KSGkgRmFuLA0KDQpXb3VsZCB5b3UgbWlu
ZCByZXNwb25kaW5nIG9uIHYyIG9mIHRoaXMgc2VyaWVzIC0gYjQgZG9lc24ndCB3YW50IHRvDQpw
aWNrIHVwIHRyYWlsZXJzIGZyb20gdjEgbm93IHRoYXQgdjIgaGFzIGJlZW4gc2VudCBvdXQuDQoN
Cj4gDQo+IE9uZSBtaW5vciB0aGluZywgdGhlcmUgZXhpc3RzIHNvbWUgY29kZSBmb3JtYXQgaW5j
b25zaXN0ZW5jeSBpbg0KPiBjeGwvcmVnaW9uLmMgZmlsZSAobm90IGludHJvZHVjZWQgYnkgdGhl
IHBhdGNoKS4gRm9yIGV4bWFwbGUsDQo+IHRoZSAic3dpdGNoIiBzb21ldGltZXMgaXMgZm9sbG93
ZWQgd2l0aCBhIHNwYWNlIGJ1dCBzb21ldGltZSBub3QuDQoNCkFoIHRoYW5rcywgSSdsbCB0YWtl
IGEgbG9vayBhbmQgc2VuZCBzZXBhcmF0ZSBjbGVhbnVwIHBhdGNoZXMuDQoNCg0KDQo=
