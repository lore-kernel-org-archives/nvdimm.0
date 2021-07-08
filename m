Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D4970
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 05:59:27 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="270561983"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="270561983"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 22:59:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="560526225"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 07 Jul 2021 22:59:27 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 7 Jul 2021 22:59:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 7 Jul 2021 22:59:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 7 Jul 2021 22:59:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VHN5CD9+ehoK8WftCZ0EVR/aCD/aLBWeuihiu3OYErowNBn28PSsezYGuZjNNR2itqy/mnnh+DbwvgBluVV35dmv9fG8NkE8EML+LlYvGEipb9mlklYKls2t3wlLjDhH4ycUJaDkN+YP99M45ENIvqBITRY55DQvXfvKju4fF5PvoSpxUfevP0/Kj7mg3dE8d5WlXllvga54bL3tlBTLNd2+UDq0PWO7vpkNY2CVrC/mLH8ceyGoKiccSqi5HF414GGmJmZXUxGeb6DsX+8Inqb/cvHOs05cyjUXJsR4y6/MTlYNT6OPtgYb0GX8WGYr85PSQN9yHH+ReI/D0ADCzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Lp54qsjfAZSmHWisJz30yNJFpFZtVRdNzqYMmU2wQQ=;
 b=RA43sHAmCWHFPK4N125xfo8JuMDcuXtEsClUICwaplvfSjoS9RsxVNMPmijN9R2RTkZmy9FJQZR915Bf6RleocFDfktLB/YAmlsHF2/+Q/nIvqgph614M16e+EABMioBypoY5wGxA7YpI4eo7caf9KUYJBOoAyQDvNiR++DwAuYZqOuLId/WiqN16dZxSqGZdXZudLQ4+n8PxIPiudJDKSrKQw2NV4pPEbjhVK/J7gC0D2ITkOv/1VXXLByrXxnZHme3QhfuHpoTwXb5wlKc1wNpQSAu6m9gcnCC5U3LZNxNW30GFgV2pJikaQXPfup26xtypMnIp/sfTe5wn8+bmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Lp54qsjfAZSmHWisJz30yNJFpFZtVRdNzqYMmU2wQQ=;
 b=F6aIbJ1V7N4CVg6FPh+ZJDCTqOVg9WvFci4EVImE0N49uaOYyBxqa/ETVp+YkbHTh3DKDvhwz+6hgqmBaPLfJGwYtFTo69dkbcsXe07vQlG3BB8uUbCOpB0+3tAWLJFaNlWBtVfnufFE/FTUbyZCCf9uAgESxNwy/qSpVVaErr4=
Received: from BYAPR11MB3448.namprd11.prod.outlook.com (2603:10b6:a03:76::21)
 by SJ0PR11MB4862.namprd11.prod.outlook.com (2603:10b6:a03:2de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19; Thu, 8 Jul
 2021 05:59:17 +0000
Received: from BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::de7:9279:792c:4d75]) by BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::de7:9279:792c:4d75%3]) with mapi id 15.20.4287.034; Thu, 8 Jul 2021
 05:59:17 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "Liu, Jingqi" <jingqi.liu@intel.com>
Subject: Re: [PATCH] ndctl/dimm: Fix to dump namespace indexs and labels
Thread-Topic: [PATCH] ndctl/dimm: Fix to dump namespace indexs and labels
Thread-Index: AQHXXN3on4dBmZFFKE+nf1QtJqtwjqs4ZLAAgAAZqQCAAESvAA==
Date: Thu, 8 Jul 2021 05:59:17 +0000
Message-ID: <d9d858e2431193f9aacba83f8a792a34486ac900.camel@intel.com>
References: <20210609030642.66204-1-jingqi.liu@intel.com>
	 <8110e80df98fb57fd20d0bf73dc7d266fef5ab84.camel@intel.com>
	 <9cba6794-e3ea-fb89-1391-e3bd992912a6@intel.com>
In-Reply-To: <9cba6794-e3ea-fb89-1391-e3bd992912a6@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.2 (3.40.2-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 591beba0-c5a9-42a5-0b52-08d941d585a2
x-ms-traffictypediagnostic: SJ0PR11MB4862:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB4862BB87202888FCB288735EC7199@SJ0PR11MB4862.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o2gcAWOjsvYLQOV7Wwe+DaqJ57boUpnFMXwMBvnmU5/E7K1xhwNKa7fIErloVhuRsVVVDgrVHy74igyIAqSLmYrsipZ6GGksvIRNW/x0OmpWBesylm3WnOcioge1TIZ22PJ+crCfrrbSbq5iSQ+f7dDHNkdstlB52lpDhcDJE9Dt9WevQdT2PM+JOIdsirSDEiV6X+hC46S2iycQN7AzI+A+CR/APUmKwHHSakCvgrHAlBEgBEfElDcdeZ8QM6DlJC8g5+PED06RJ16GBrq66jSokb6iZEIYTK9w7IarZxxtlyip3IikxX1XNKS6Wkaxh45kAXYbZ3M88HKI0mJFn3zbSPRuPF+hRNRqgq5y8HJcyMcaAyG58o0vgvD5+fE5fX4lwqYsQRZKAPjgYLEsaj8v50Ycl1A/q/zu0LzQNr+0moJq2ALbx4wbiqsTbHvUhyaf0M+rnIlFeEErowxtpUX9Equv3fDlUKFuiGW1hNhsXA7tZq/cxEAP2VfDpGVMQx8vi4WkeknG6gaotwBZ+NmApnvAYukUhfwU5vBtxxsMCXWDqMfCKpHMG3AqQRBTIj6t3Cs9d3G2whny2KSrsL7TcMD9X/xrFGY7FOf3L9CWca8qhByVIAIvzVBYN0q67qWalaDQeo7xDvC0L1JOLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3448.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(346002)(376002)(6506007)(71200400001)(8676002)(76116006)(64756008)(26005)(5660300002)(8936002)(2616005)(86362001)(186003)(6636002)(122000001)(38100700002)(66476007)(66946007)(66446008)(6512007)(478600001)(66556008)(110136005)(6486002)(316002)(36756003)(2906002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXAyTm1LMDRrZjBmNEc3RVJRaHEwcFc4UVlORW5lSU9BblpwYjhTL0pGN0x4?=
 =?utf-8?B?ajYzdVF1OWJyaUNxYTBDZVBDOFZYdHI1ZS9SR1pyaUZpOHFYTm10Snd3bjZn?=
 =?utf-8?B?WUFOaWd1VldWanVRbWRFbXJCOGkzc3oyWWh5NVV5bWNVNElCTjlMN0VyOTZL?=
 =?utf-8?B?Wm5nNVFLdzMrYm4yS1orbjNIN2RnWGdJd0w0MU9sVjZnMXJNN3d3VGt0Z0Vs?=
 =?utf-8?B?SVFrcUh0b3BQVm90Sm1PK2E5cXV6YmhodVZSY01OUWxDTUY3TDJoZlc0ZW9J?=
 =?utf-8?B?RHBZUWF0dFZodGRyNEtCSXhSOVFWcGlGR0pjaDA0MTF2RmVwVllkZXZzNk8v?=
 =?utf-8?B?TzlubGJIQ01idlhKajNOVnFTL1o2N2VURUpVNWVvc2pnUFhuTEk5YmREVjB3?=
 =?utf-8?B?RlRIeUdjaVpsVjRBNXJ6M1ZsNjdTWEplM2RaN3ZMOGJMWk90ajNhUTNLNUtw?=
 =?utf-8?B?OXBXQkdrMkgzTy9RNUZ6ZlptdVRSaDJSczNuc2NsSDJ0UG5xODdEQ2VxS01q?=
 =?utf-8?B?TjVobWN5SFYwWTBRZjZxUjhQSmZHdHVKMThpV0l6OGxTeU5iR2xmK2lOeDJ6?=
 =?utf-8?B?NFpNTlNJelRMcTJCV3NFNU5QcTJrL0wxSHgrSGcxM1N3a2dCaXhvSjRUcUNR?=
 =?utf-8?B?ekFDMThWUGJ4V1BiY2JjSU1YRHVDbFNzYXo2allGd2RkdkZHbnZyaGMwRk1y?=
 =?utf-8?B?UmtWejlCRk1USWxGbWl4ZDN2aTZTbk53dEtVd1VURk1UL0Vxa0I4Z0Q0cnB2?=
 =?utf-8?B?ZUwrZ0xHS0JVR2RFUkZLbmxHcFVhMXQwZnlzbm9PV0FlV21GeHEzVGpHNHZr?=
 =?utf-8?B?eDZFYXV2LzhxOTBlMnB5Vk1hb2w2U21NTUR5em03N0o4MmRMS2IxY0VJT05R?=
 =?utf-8?B?dlNtVk5hQXdNUHRmb1pRQStlZ1JIRXR0T2xxd1RCaHV6YWZkK2trZ0MrT0Ja?=
 =?utf-8?B?Z0lCaVpKOEI0M2R0cEFOUmFrOVllRVpRWnNzY3NzaGRTMVo5NzVqcG82ZHhZ?=
 =?utf-8?B?bjd2aitCcVVBQWJGVjJkVy9jbmZuM2RVVWM2VDdvK0V2TVJpU1pZZFJUSVdt?=
 =?utf-8?B?MnpDN0pZZlBYS0xsWTVHSVkxaSttc2lxS2I1U1pzWWpGNXExbVpUZ1J5aUl2?=
 =?utf-8?B?d0I4dW9LcEJGSk9DOFhFb0tUKzJtWkJ5SzhuYVF6NjVldlYxbXFiU2QvQ0tk?=
 =?utf-8?B?ZlRuZ3JYNjZSZ1VwNCtpcnFhNXJYL1pOU2JFVGx3dU9pbEs0a0N5MkRqdjZN?=
 =?utf-8?B?T28yWWVHMXFkejg0cmpsK01QSFpid3dYaEhtS0gzeFVRTmVnRDlTM3g4WVg4?=
 =?utf-8?B?NG8xNnRvTnJQUVJYRXUrSmdGWUgrNVhObUdMTC9lUFJrbUNVdUF0emZ3aHd1?=
 =?utf-8?B?b1poQjFRZ2xRWXpzTDJaTzBZb1pjbkxBWHRLZ25xUm9zTEMrb0ZKTXVnRVla?=
 =?utf-8?B?dGN4UmhvSSswTGhacmx6WnhFZjJxK2hkM2tnZ0FhckpNUER4eTN4bFFWcjNw?=
 =?utf-8?B?ck9yVHFXNmtQaXRWZEdBMldZOXowcHUyQjBQZ0VOcHZZaEFoQ0FXUTdweEhq?=
 =?utf-8?B?Qis4N3NFcWllS09RekhFVWFnMlFEMk83SWFtYnExbytCc0sxU2cxMlc1NXB5?=
 =?utf-8?B?VndSZUZnUVFpWXVMSVV1elFVSFNvOUY3aEMvTFM1MW42ZTlVOERWbnJCcVFD?=
 =?utf-8?B?TkRoN3ZJcWN2VWl4dEo2aXN4TndYNEVGQmVNZ1hkOUpHbFlyWnNPSlNzNXhq?=
 =?utf-8?Q?BHEXhYyAqXLv3z5ISpIpxzgNlLvwvLbgEtaSO+K?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <672763E2A622034E9A2AAD42C4C4C74B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3448.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 591beba0-c5a9-42a5-0b52-08d941d585a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 05:59:17.4335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b2/ipTQHdp7aNb0ezncQcoTAScWIUhpNWgyepPaYefEEbuBs0+iF2HDcn6KInLrdCyYUjF47v2bJcbTpGf2aV30thiFefBZZoSMdAj7qDzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4862
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTA3LTA4IGF0IDA5OjUzICswODAwLCBMaXUsIEppbmdxaSB3cm90ZToNCj4g
PiANCj4gPiBbLi5dDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9uZGN0bC9saWIvbGlibmRj
dGwuc3ltIGIvbmRjdGwvbGliL2xpYm5kY3RsLnN5bQ0KPiA+ID4gaW5kZXggMGE4MjYxNi4uMGNl
MmJiOSAxMDA2NDQNCj4gPiA+IC0tLSBhL25kY3RsL2xpYi9saWJuZGN0bC5zeW0NCj4gPiA+ICsr
KyBiL25kY3RsL2xpYi9saWJuZGN0bC5zeW0NCj4gPiA+IEBAIC0yOTAsNiArMjkwLDcgQEAgZ2xv
YmFsOg0KPiA+ID4gICAgICAgIG5kY3RsX2RpbW1fdmFsaWRhdGVfbGFiZWxzOw0KPiA+ID4gICAg
ICAgIG5kY3RsX2RpbW1faW5pdF9sYWJlbHM7DQo+ID4gPiAgICAgICAgbmRjdGxfZGltbV9zaXpl
b2ZfbmFtZXNwYWNlX2xhYmVsOw0KPiA+ID4gKyAgICAgbmRjdGxfZGltbV9zaXplb2ZfbmFtZXNw
YWNlX2luZGV4Ow0KPiA+IA0KPiA+IFRoaXMgY2FuJ3QgZ28gaW50byBhbiAnb2xkJyBzZWN0aW9u
IG9mIHRoZSBzeW1ib2wgdmVyc2lvbiBzY3JpcHQgLSBpZg0KPiA+IHlvdSBiYXNlIG9mZiB0aGUg
Y3VycmVudCAncGVuZGluZycgYnJhbmNoLCB5b3Ugc2hvdWxkIHNlZSBhIExJQk5EQ1RMXzI2DQo+
ID4gc2VjdGlvbiBhdCB0aGUgYm90dG9tLiBZb3UgY2FuIGFkZCB0aGlzIHRoZXJlLg0KPiANCj4g
SXQncyBiYXNlZCBvbiB0aGUgY3VycmVudCAnbWFzdGVyJyBicmFuY2guDQo+IEkgZG9uJ3Qgc2Vl
IGEgTElCTkRDVExfMjYgc2VjdGlvbiwganVzdCAnTElCTkRDVExfMjUnLg0KPiBIb3cgYWJvdXQg
YWRkaW5nICduZGN0bF9kaW1tX3NpemVvZl9uYW1lc3BhY2VfaW5kZXgnIHRvIExJQk5EQ1RMXzI1
IA0KPiBzZWN0aW9uID8NCj4gDQpObyAtIHNvIG9uY2UgYSByZWxlYXNlIGhhcHBlbnMsIHRoYXQg
c2VjdGlvbiBpcyAnY2xvc2VkJyBmb3JldmVyLiBUaGUNCm1hc3RlciBicmFuY2ggY29pbmNpZGVz
IHdpdGggdGhlIHY3MSByZWxlYXNlLiBUaGF0IHJlbGVhc2UgaGFkIGFkZGVkDQpuZXcgc3ltYm9s
cyBpbiB0aGUgTElCTkRDVExfMjUgc2VjdGlvbiwgYW5kIHRoYXQgc2VjdGlvbiBpcyBub3cgZG9u
ZS4NCk5ldyBzeW1ib2xzIGFmdGVyIHY3MSBuZWVkIHRvIGdvIGluIGEgbmV3IHNlY3Rpb24sIExJ
Qk5EQ1RMXzI2Lg0KDQpUaGUgcGVuZGluZyBicmFuY2gganVzdCBoYXBwZW5zIHRvIGhhdmUgcGF0
Y2hlcyB0aGF0IGFkZGVkIGEgbmV3DQpzeW1ib2wsIHNvIHRoZSBuZXcgc2VjdGlvbiBpcyBhbHJl
YWR5IGNyZWF0ZWQgZm9yIHlvdSAtIHNvIGlmIHlvdQ0KcmViYXNlIHRvIHBlbmRpbmcsIHlvdSBj
YW4ganVzdCByZXVzZSB0aGF0LiBBbHRlcm5hdGl2ZWx5LCBiYXNlIG9mZg0KbWFzdGVyLCBhbmQg
Y3JlYXRlIGEgbmV3IExJQk5EQ1RMXzI2IHNlY3Rpb24sIGFuZCBJJ2xsIGZpeCB1cCB0aGUNCnRy
aXZpYWwgY29uZmxpY3Qgd2hlbiBtZXJnaW5nLg0KDQpIb3BlIHRoaXMgY2xhcmlmaWVzIHRoaW5n
cyBhIGJpdCENCg0KVGhhbmtzLA0KLVZpc2hhbA0K
