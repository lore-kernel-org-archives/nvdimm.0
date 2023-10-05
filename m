Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC46837C9D
	for <nvdimm@lists.linux.dev>; Thu,  5 Oct 2023 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q3GvmeYI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696526242; x=1728062242;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YsLfxe7k/tcvJkdDPjzaz3nc8cKn/Il4uV3c1X2VITY=;
  b=Q3GvmeYIMaU4Ik89ceaObz6Zx7khjKrAWAGNdKm91+fdvp8xOZ2AAx/C
   bprMdCpOC7HKAIUEElSAdRfFgAHZSZqXok7Lz5SLrsnshw6OOGf6Z/1pf
   I1wRstH4vX/nKhFoCabWLsIDUa6B7QzsmM5WZeSd4Q6PABT1TYs7CIo5P
   N3AJSvnm35oFFhgymzGbEirONsNCWj1CQHiPujxFBonaB0j3PCAzndzrX
   qdHdKO8kobL+3YGdeoHinfg7sdNQdi7kMyBJjcudhCZDCzSj+3QlkEP/7
   GQHlAhVx5p5mZZlElTGcBdJWjOQU1Tb3dic+S4YnlrUNJtZGPrq8jfXbD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="380840827"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="380840827"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 10:17:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="822202973"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="822202973"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Oct 2023 10:17:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 5 Oct 2023 10:17:21 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 5 Oct 2023 10:17:21 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 5 Oct 2023 10:17:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z8pqXmqZ1Dy0DbK3gmyUF2EQIKa8fHv3cjE3REqZUwlyrbAI5sk1qvZwmCQHbCzPcLmHSZloCNf9K9j+47JoxeP4i3TJXcbn5PmsuuBkHDEZO3kppOK27IjOLeLjD6eC/PbMJRDBmJUQmghfIsD+qCPd2WDXFfHTRcrLbQW+C+6xysVH+wHrsQBrQLIf/t+EBBBw0iZ22TXz2tJ2sq+G+QM2uZXmN8025iWaq2uwTGzYcI8p812WFY01uDi3Ewyc7xSa92HMtemfgDKcVv8Y91a0LddlGRFOXudkDIfl+u+EJ/1v6Uqi05a7WB8gpTut82eh9thaCQTO0HBZafej7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YsLfxe7k/tcvJkdDPjzaz3nc8cKn/Il4uV3c1X2VITY=;
 b=U1haN/yysMj2nrowaMPlq9r2JIFmSRVf6g6SredXRzvbk2sqah4gghi5piq6nlt7LxFcEZ0NdzzRtatJ4zwjkiUXJ3oJc29eM+kkjpshegbi2f/ndqsv28+tC5ppBCp2vRejHQF+eti7Z1oty3f/Mhhv6f/HC6iZpOFKu+ew775a5ni1UuSvxNBt1Gr1NQwGNxmyoLFoWt13coKIAw6DD2mt4ffNM9zRSmctRagKtiiaFN22sk21ktvpxNIXeqRRv8MS4Zfa0iIO+43c03VGXnswASZoX+5Yofkb8WKLxqlgn2LAF9D62u7AZkjCDXjuFakx/Px83HRQ/Mpcbtc1zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB7121.namprd11.prod.outlook.com (2603:10b6:510:20c::7)
 by CO1PR11MB5187.namprd11.prod.outlook.com (2603:10b6:303:94::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.20; Thu, 5 Oct
 2023 17:17:17 +0000
Received: from PH7PR11MB7121.namprd11.prod.outlook.com
 ([fe80::a24a:d4ae:e4a8:5f34]) by PH7PR11MB7121.namprd11.prod.outlook.com
 ([fe80::a24a:d4ae:e4a8:5f34%6]) with mapi id 15.20.6813.027; Thu, 5 Oct 2023
 17:17:17 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "dan.carpenter@linaro.org"
	<dan.carpenter@linaro.org>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "kernel-janitors@vger.kernel.org"
	<kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] dax: remove unnecessary check
Thread-Topic: [PATCH] dax: remove unnecessary check
Thread-Index: AQHZ95QalX9JK4cK1Uy9nacypVKre7A7cGqA
Date: Thu, 5 Oct 2023 17:17:17 +0000
Message-ID: <21381c1e57c2fc2aa7579d4655ea7d3f1c74f6a5.camel@intel.com>
References: <554b10f3-dbd5-46a2-8d98-9b3ecaf9465a@moroto.mountain>
In-Reply-To: <554b10f3-dbd5-46a2-8d98-9b3ecaf9465a@moroto.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB7121:EE_|CO1PR11MB5187:EE_
x-ms-office365-filtering-correlation-id: 09fac080-e610-481d-99d4-08dbc5c6ed1a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZahgmaCCmeLBNJsC/F4vnu0g7I3ohGjqonw2RyfXnFph8LXXlvBOluY0q5fBz01JEmSU4ZIX+0SSIDv6bkAwhUIxJk5CUnhB+86bXh0z2wSE1o0W+8g6knjSo2Wj1/D0kY2KMRnp/JnUc2g9OmVYuzWQvCbzkN3SqtuIC9aZdA80BvcosETzOp1QJAakJo2vKqQqnBgxPtmfX9wB6YBpJkVIEYECPgyaInkipOF44jHR0OSxVVe5Cl5Yx7aRHc3gswcr67t2lCnDoHrs2iFiFAE4NGIZeLB95tKSUl//LqrHQualrRwvfMtEMCTFVtP7a6HEsNgj7CHbwXIOx+pNpvYxqjA7CYBTGsc6Aa89zaNymH6DGx31SNGeM3xf0LUHjOge9upVbOzco7eSf4rzuR71edf7RWc2DVxBXKi5NmRJ1QwZkWzvEESs2NwZ0n5v/N8e3nQ5a/OrCuQZDlPZ6EC56B/NpmEJFhG1ME64VHr6JJHBvfpFIfd3h7JPGeqf7tX4d2LBtc+ssAUhxawt9Cn+n5Wv9vKnjHOs+0DdvX4JjjYtYPJXeTo5TLpKiD0asvbRNrKMeJwq59zjlS47CHrjoKLckr0ACaL0ozh1eHCcMZADa9zLcF30LU/1NG8T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB7121.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(136003)(39860400002)(396003)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(316002)(8936002)(41300700001)(4326008)(66556008)(91956017)(66946007)(110136005)(5660300002)(8676002)(6512007)(83380400001)(478600001)(2616005)(26005)(66476007)(66446008)(6506007)(64756008)(54906003)(38100700002)(36756003)(82960400001)(38070700005)(76116006)(4744005)(6486002)(122000001)(86362001)(71200400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmgzZW41RHovbmtMY3ByOWxEeEh2d0wyMWVsT1dWNG9tS1VWR1BnMmR2VmRC?=
 =?utf-8?B?MnhOOG81ZHZvZlYrVjY2Z1pOQjMxQ1ZhSk5rTkVNQ082d2Rxd3Azdno0REl6?=
 =?utf-8?B?SFpmcWdBSTVUWU01RzN2WFlGL1hYV005SlNaNndFVGRXNmRHSC9JSkhCQ2Rs?=
 =?utf-8?B?bTg0Z1Fac3kyUUxkTWJEZStHTmlKY1dlQWQyVE5FQjAwck1EUytKSFRIT0xp?=
 =?utf-8?B?YTRiQnNqVXpzNmJITHpLVm5Ya1VMTTJxWm4wcXMzamJWTHlLOXV1WEhCaTI5?=
 =?utf-8?B?NU4vVkRGTGhlNVIwaUt3VEQvUnJ5V01PWkV3bFZoRWxVdEJvNEM5cHl6S1dF?=
 =?utf-8?B?Sy9sdCtaOXFudXRETENLaW1XQWcyYms1RDk5T0oxSktyM3FUc3lXdHdPbktT?=
 =?utf-8?B?WHZ5L2VCR3RTdWxvZFVkUStBQmx3ek10S3VwOU1RaTBJTDdXOHBhUEhiaXJp?=
 =?utf-8?B?SDhJeS9telBHdlVKRUpmQkVSMmlZUzJPZUNPL2x5akJFT2I3dU5PTU9VblZh?=
 =?utf-8?B?bWJMaXhTa1N0MERIMWxtaTZRVEsraVg3TkFLMFZnbEI1d3hOSnYySVJCM1kv?=
 =?utf-8?B?V0hDSXhHQkxIcTZYM0t3M0tEeC85bVQxUXowU0VscUF4SlV4bENRZXh1UEJQ?=
 =?utf-8?B?SWJEbFlZREg5SEVhaVBySDZqRUdubFl2d084b1owVHdzSU5FT3Rhb3BOYnhj?=
 =?utf-8?B?NDA1dTBVYUIrdnErbDViMFl5Sm9JbkphaW9IeU14eDZ6WVZ4T3lkNXI0Tlor?=
 =?utf-8?B?eWYzcnVpVjFDcVJRMjZJS1Vtd2l4TWNqSy9IWTJEUk1pV0JnRXdpZ2kwdkRk?=
 =?utf-8?B?eHVMaGRQaUg5Z1crclRZSEo0YlJuVlY3cWM4S3pCMFlkZTlLQklhMTREVmxW?=
 =?utf-8?B?UnROZDM3YTNqd3grSDg1MXByQVJ1TG91bG9TakZnSlN4cWhLVlphbUY5Vllu?=
 =?utf-8?B?SWQ4NHZ5UFF4ak1BOWRJL0I1cXhhNW1Jd3VVUXNMVk9IdWo3MjE2VkpvUjQw?=
 =?utf-8?B?S1piNnhtYlpRY05Ub09sbG9Ca2J6eXpsdkJDYzFYNy9tU1M4U3FRSWluaW9q?=
 =?utf-8?B?YWt1bk1wR2M5NHZkdDNLbVRJUjNRSzVnRU1NQ0lVeVBZVmpSNXFuVjYyVnFB?=
 =?utf-8?B?ck5jQXZ6dEQ4RU55bEx2YmhWbFRaV2RTc1RpeFFEODZucjZzSlJacm9oSkE4?=
 =?utf-8?B?T2p1bkZ3NnBwMXpzeVFOaXRmOUlORVI0Mm15ei9lYm91RnBLK2M1MS8vRC9L?=
 =?utf-8?B?bVFHY2o5NERzWEs1WWc3N0J5QUg0WXlCSHJqMW9CK2p2NVM1R0ZTRUdYdE9R?=
 =?utf-8?B?cDMrQUFpTEpEUUExbnIxVW1SZXNONE9vSjlYM3Ztd2tHclRLYjZBTlRFNXRy?=
 =?utf-8?B?Nlk2SFJuZ1dHWVc4MTBoaTVKdDJlSzY0cGxGSXIxUzlZUVVLT3VrMlQrdjNS?=
 =?utf-8?B?UHRwc0drVXI3SzRQSTA0U2tYbFpoRnQ4Wk4wQ3Q1ZTBZa1FPSHFuYXFaa2tN?=
 =?utf-8?B?WmZtZkc2TVBjVWJycUcxMUw5M2VUalI2VXEwZkFOT0xGTjFRVURCU0hFdG1C?=
 =?utf-8?B?YzFWZmc5RFRRcTd1SGZkdDZKbmptYkNGaG91WVVCSS9KeE9jQjBtY1FSVHFE?=
 =?utf-8?B?aGhZSkFGVGdsMGF4N3U4bFZZTEFyOFhhL2JJaHRUTjZOQlBQZDM0bXo3YlNT?=
 =?utf-8?B?ZE55NVp2UUg0OGh3bWk3UkdENzVCNmc5dVJtaHFkYmp6bmRFVlJDZ0RLQ2Rk?=
 =?utf-8?B?SGhBOEd1Q1MxTUhDYTdGZWVFQ2cvVTFodEJQOThXUlM4dTJoTVpCZFJwSENv?=
 =?utf-8?B?SU0wQjhlclVleFZScUsxUWo2Zm1mRWJIVWZMZ29ScTQ1TWRxalRCL1AzTW5Z?=
 =?utf-8?B?a2kxZ1RqWDN1T2hsUnRzZTNpb0s1emxlRy9XZm5yYmlLRUZvaWRnNHF0Wlg4?=
 =?utf-8?B?SENHeTBkQ0JXazExSVdjQ2R6Yml3WnlWWG1YV1JEUUJOYmpMeSs5eUlYN3dq?=
 =?utf-8?B?bHhwMkhzY2F3cjVtdnFvQTFkZGlmd25ZblY5MERuNjRMbGpQWWpRVXpXRFFZ?=
 =?utf-8?B?ay9RdnpwVWUzcjhZZUIvNzBTMURlVzJReGhSMmhvelZUczN1YXJvK2tGN0xk?=
 =?utf-8?B?dXUySEM2eTNMTjhIWTRTZ3oyY0Z3NzNUQTd0dXNTVktLVExmT0NxVTlPNHNz?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04EC91AB409A4147983F9D4C1EA7F86F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB7121.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09fac080-e610-481d-99d4-08dbc5c6ed1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2023 17:17:17.4791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XEbkEp8WoZbczcxrO/CVBWgYbnQFdDu2dUvo2PO3k8B8JFDup9hPyUd7ZK3gTeYE252I99DsSqirRhmY0ntcyJktQ5rOsi5J+Q6YAlHsOKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5187
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIzLTEwLTA1IGF0IDE2OjU4ICswMzAwLCBEYW4gQ2FycGVudGVyIHdyb3RlOg0K
PiBXZSBrbm93IHRoYXQgInJjIiBpcyB6ZXJvIHNvIHRoZXJlIGlzIG5vIG5lZWQgdG8gY2hlY2su
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYW4gQ2FycGVudGVyIDxkYW4uY2FycGVudGVyQGxpbmFy
by5vcmc+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvZGF4L2J1cy5jIHwgMiArLQ0KPiDCoDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvZGF4L2J1cy5jIGIvZHJpdmVycy9kYXgvYnVzLmMNCj4gaW5kZXggMWQ4MTg0MDEx
MDNiLi5lYTcyOThkOGRhOTkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZGF4L2J1cy5jDQo+ICsr
KyBiL2RyaXZlcnMvZGF4L2J1cy5jDQo+IEBAIC0xMzAwLDcgKzEzMDAsNyBAQCBzdGF0aWMgc3Np
emVfdCBtZW1tYXBfb25fbWVtb3J5X3N0b3JlKHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gwqDCoMKg
wqDCoMKgwqDCoGRldl9kYXgtPm1lbW1hcF9vbl9tZW1vcnkgPSB2YWw7DQo+IMKgDQo+IMKgwqDC
oMKgwqDCoMKgwqBkZXZpY2VfdW5sb2NrKGRheF9yZWdpb24tPmRldik7DQo+IC3CoMKgwqDCoMKg
wqDCoHJldHVybiByYyA9PSAwID8gbGVuIDogcmM7DQo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBs
ZW47DQo+IMKgfQ0KPiDCoHN0YXRpYyBERVZJQ0VfQVRUUl9SVyhtZW1tYXBfb25fbWVtb3J5KTsN
Cj4gwqANCkhpIERhbiwgdGhhbmtzIGZvciB0aGUgcmVwb3J0IC0gc2luY2UgdGhpcyBmdW5jdGlv
biBpcyBvbmx5IGluIG1tLQ0KdW5zdGFibGUgY3VycmVudGx5LCBhbmQgSSBoYXZlIGEgbmV3IHJl
dmlzaW9uIGFib3V0IHRvIGdvIG91dCwgSSdsbA0KanVzdCBpbmNsdWRlIHRoaXMgZml4dXAgaW4g
aXQuDQo=
