Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E1D6AA6
	for <nvdimm@lists.linux.dev>; Thu, 16 Jun 2022 20:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655411604; x=1686947604;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=CkI5uP8lVKdrR/AUq1QtGVsYxWGB1YS7PY02ofdRAmE=;
  b=a5aDlGRPPJHdX01zhDf8qMYfjMfJ+NMk4JpBOLAKyRuWUGfjlT4RrJZ6
   1HkW9UzmdwhtjY1+J+TtAK0E54LN66lHNpA0Jljhf1MIAADMbBdWI8Ohl
   ijXG8Dv/r9loo50FOfTjYiIc2K/RqkOBkLoDrOPx1KXCp6GrmTV+utYp7
   DpxlALpKFwmY7LLL7THITzMnJLmBtdbwrVI0+XZy0MuFvQM3bsfz4b2jV
   5HlRp4RlGpDpFgTjTlPXlPpWcHjOkfvE+y1Xi77ialxV+znSpZR2lixcz
   83PA+9A/HQTOUlButCK4zaWg408fkNwere4ly6Exm5IfsmcwNeWrg1HtU
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="365698332"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="365698332"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 13:33:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="831723683"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 16 Jun 2022 13:33:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 16 Jun 2022 13:33:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 16 Jun 2022 13:33:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 16 Jun 2022 13:33:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmYX7u5KrG1OMISlJGj+8MPxknDd4+ELa3nRQBqwcBHYbITJUT7IJNXlgxxj7q/CXb1/NiQREXEfBs7bnqCEP+lXfCd+m75HINzugVcQSCasHmk6WQWal99JvzFJ5uY/ZtRHxQuq2o6i2Apm54lC8W3q6uvQt/WX9TgiRwrVn5MpqgeK4ZP4AXwEemK13rwleLo3mTgzc0A9GEFyKAzEqRCptAD1Y8fFANmsn9Z91+rH9acrVBBAkBS2GXfl4RMnhZFztikbTdq2Gpi8yJ0yT9sSPzS9RKasRITiNug2//ng/OA4VgfhUEe+P8d5lx3zMoXVgN4wI/uYLHsawE8Tcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CkI5uP8lVKdrR/AUq1QtGVsYxWGB1YS7PY02ofdRAmE=;
 b=a4UabC5CJgZM4mfuOcYIYEAs7+9mwYG6SjxjI4pytPXpm4wlzF1aMecXlfxdxOsi8oSu+88yTTKsIbZzRff9ZGlGqM23vB6XoZ37AHOmncpRTOw8JpUWmoAE7UrXaAg4qRTN3Dqncu9FWHBXIFUIe1LUU+/J15ZUGLMJKYeaAbtiX5793gUbyAbn24YCNWTAe5VMzdB9sZtQKvToj9q1HHRNKMRXrajs+D/MCJe6uxzs2bKGtZaGiL3nIt8WeFExcuatc1EdVagRJ9LFxNfxhn1EEHyGvnvSPoRnghaEuZWJ1ZBU6S//gxOKXTuYgOi24XozHc04XQMM+IQWa8O2zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BYAPR11MB3175.namprd11.prod.outlook.com (2603:10b6:a03:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Thu, 16 Jun
 2022 20:33:21 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::40ef:2d29:7d1a:21be]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::40ef:2d29:7d1a:21be%7]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 20:33:21 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] util/wrapper.c: Fix gcc warning in xrealloc()
Thread-Topic: [ndctl PATCH] util/wrapper.c: Fix gcc warning in xrealloc()
Thread-Index: AQHYgbhDo/SnQCWf+UaRf8tIPPfI7K1SfG+AgAAAwYA=
Date: Thu, 16 Jun 2022 20:33:21 +0000
Message-ID: <445789e623b61cbac7e325c5069a3156475f6fb3.camel@intel.com>
References: <20220616193529.56513-1-vishal.l.verma@intel.com>
	 <62ab92ed68a0e_734c329441@dwillia2-xfh.notmuch>
In-Reply-To: <62ab92ed68a0e_734c329441@dwillia2-xfh.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.2 (3.44.2-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2e48a81-c155-42cd-ee01-08da4fd77451
x-ms-traffictypediagnostic: BYAPR11MB3175:EE_
x-microsoft-antispam-prvs: <BYAPR11MB31757C5C140F0D5F3203A26AC7AC9@BYAPR11MB3175.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FnO5gjL8LB772gmiFj+KgJz41Mxh/tyq2pLLWzWCzMKp9S8mK8uPRFSW5jhmUReZgoOJ5oNmTxmUovL+W6N9DjArWCF5eOfI40M/bn3/K6PAKNstJLLbBmzArLRuKgcgKHZFxkBFQPJ1G9jdieKpMhJ+Cv6sMGYL1yfcapHLwnfYjAIDFU+mltvF345z9mZ8/fyj/ZphPsvQ7FRpny/aVsZzJNwkULlGRnlNPsL9b2A4u19WTqYKuTFv1H25339yc3UBjAPxuS7DLwxpyk9hP5WXV0dgeK4XxQZtxcGMgKuMfJG3HRVfRttTwTT2yyxYFmIK1IBXoOiOHN5jJ8+AuiJ3fdWh+Mlj4qYkOO+sWUbAM1oVOJ77j5Wsx0pWK8De7f4wWDEqw0cuNRCGF1gb2O7LTW9WWOPhGY/s6HGbmlLq5PayUBnfkGbIcvenYBak82Nmv+PRYE94qMpPLlLajjc30eVNFc94XVPzFkXARXobOwDP19oEtha6h1dgmudtthdGt4NlNTJovEJa+rAe/NPGjgIDzUE4u4oGNhqveYWOI9+/y3LzYbcjnMyW/ChHcNaiPxq+mGex5VnFiUSdA9f1sHbXMW4vNxfuzPwDkP762VUIUTmdOAYlGvuJaxTeonbtsAbQ6iqs21C5c2RF+7t2zSfXBFrcBDOVXTQsPH3q7RUQEBOZhHcP8dOlprDex0BPoRYYDqJ9CME/mHTqGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(38070700005)(64756008)(508600001)(66476007)(82960400001)(122000001)(8676002)(66446008)(5660300002)(110136005)(86362001)(83380400001)(66946007)(71200400001)(66556008)(76116006)(6486002)(186003)(26005)(38100700002)(2616005)(6512007)(316002)(91956017)(36756003)(6506007)(4744005)(8936002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWFEKy9GOGtDZHNhdXJDc2FNbENFZnpWb2FTdXNsR1pYSVEvZVVjMkdaZWVl?=
 =?utf-8?B?ajBwYmlVMzREL3hTeFZFVStHdm5yYkp2a01ZQ3NQdTlNWUxHRkdCVTlmUys4?=
 =?utf-8?B?ZEJqenRHS2NML2RBRy9RNUl2UzhCbitvNW5rWTc2dEVHVTlmNFc2WnRyQjR1?=
 =?utf-8?B?T0NJNTg0dFRycmVacThXQUFzSHluaFpjeUVIRjRhaXlsN09OdzZSdjBIbWNZ?=
 =?utf-8?B?VDVSMmpGM3JPNGVJR0lBNkNjRFNJK1F6Q1Q0VmczcjFpQXdPQi81ZWFuMnBj?=
 =?utf-8?B?bFNXdU9aNHVxNTFDdUgzVDIzK2tDL2ZGek1SM2o0eENwOTBhcUs3RnhkdGEx?=
 =?utf-8?B?Skg2ZWkwRDd5ZkJTVVpQLzhSWWFrMHl3bkRkUklqQ0hYRVFLVzFGbTl6ajhs?=
 =?utf-8?B?VWd6TkdEYlZKRGtkZnczYWVUazZOTlVWSXpmVWg1T1dVSXF4VWcwWVRIUjNP?=
 =?utf-8?B?MnJIYkJRSm8xOGpwMnFQUEd6NzJqMmpDem1BaE9hRkh0aWxkNkJTNEkxczh3?=
 =?utf-8?B?dXdubDhPL1l1QVowdjhxajdKZTBJVXRMaXZJUk5jVnI4Q1ppVVJxYU13Y0du?=
 =?utf-8?B?V3QyWHo3YnIwdHJ5V21yNEgzWEdUWk9zVzdYNHRpUXpqMCtsZ3JlbmxSOTk3?=
 =?utf-8?B?S2k1OS9zbHk2YXd5R3VGUW9JWlFvem1vL1RibzlvMit2a2lhOUpHOTFFblZm?=
 =?utf-8?B?VGp2YlRuUmYybVc1WVhCVUtvRitHSThDR01zZzhXWGg2bWFZY2N1UWo3d1dm?=
 =?utf-8?B?dUtsMDNSRE1tVlhxRnBKdk4wNjF2V1RtWGdabHZ4QXJ2K2NJaTBJZ0RuMXNR?=
 =?utf-8?B?dDZ0SEZoWm0waDVkUzF4T0k0SjI0Q0hCcDI4NzBya0poUzNZMWVFaklVRHk3?=
 =?utf-8?B?UmVxRVNvdUprRnpQYWZ6dFpWMkZwdlRSdFM2NHVlcDNleHdNWHUvZ2dVeFNI?=
 =?utf-8?B?ZjZMU2tZTmR4RWYxSG5hVTNYVGkvU1E2RUdGVVhDcXhTL2ZsaVZkTnhOK0cz?=
 =?utf-8?B?MWx4cVB4dnFuenl6SXNZMWlLTmoxb3F6TFFXY2hBTkZGeE96amZodDRQblZJ?=
 =?utf-8?B?RFVPQ2l3SktSbEJyRS9FdDFCUmtmdEFGQTVyb09LRUNQNExXOW9zYTFkZndL?=
 =?utf-8?B?eWFFTXZ5YUNMbDRkVlNRMzJQNUp5d1JCUzdiVzRFNEpGNUs3bXhWUmI4UDdR?=
 =?utf-8?B?OEttLzdibyt4Q1JSU1RNNWJOaldnYWNEcUMvV04vZ1NvcUlMWDhjRUZXYmJM?=
 =?utf-8?B?ZHA1NU94UFNGUk1zZC9KWUZ4cGMzOERNZ2ZwanlWRno1bDA2K0N5Q3J1RFhu?=
 =?utf-8?B?Z0pDSlRyYkF0Z3U4UDFLVEpJVW03amF4dDV1ZjJmYjVZS2EyaUxHZlVXbjZO?=
 =?utf-8?B?YlNJZXhhVVMzbDZtTzhCSkZST2xKdmFMVkltV3Yzc3ZWbXNWZm5qTFBLQjJ6?=
 =?utf-8?B?YzNsZ0VoWTFuNkVCV0hhLys1SzRjcm5jOGJVdzJQaGlHQ0UyTjA1QUhmMVNG?=
 =?utf-8?B?azNJMVpxckRETFV4M1hCTkREMlZaR3pSRVNadktZQlZZVHJjckdFN3ltSkdU?=
 =?utf-8?B?SUppVHRoMG1leURCNWxNNjN4TWxZait0WmFlS05SdVdabnZkMGtoWExVc0V6?=
 =?utf-8?B?WnljVHpVSXNIYUh0RUp1R3VLQTZ5ZlVCUjVoVU40a0YxczFkVDdVV0tyd205?=
 =?utf-8?B?RWZCV01XZDdIQ01BMjB3Y0pEeG4wQUFOalIxN3R6Wnlmdm0yNkF1RkhkUVBZ?=
 =?utf-8?B?K2ZLSDhyMWpKaGxzUVRodVFpYlNKdGZjNk1YaUNycS9JaS95a0FoL3lUTmFJ?=
 =?utf-8?B?Y2lWZlVHZG1waElDY2ZtOUhPRFdEOUNmODVENzNQL2xIVjEyUW9TbVcxMnRx?=
 =?utf-8?B?RnVWdk15SzVTZEtteXYyTCtHWDlrdG9zYkQwMlNMdytDRWpMUUZacDhpWmNO?=
 =?utf-8?B?WTZQbnlPZTFBd3JTWVh6cU5HTUxxdnNxUHNXMFA1TS82dDhmY3FZbFRLSkpD?=
 =?utf-8?B?ZHF0c1pBNnJMWFE5UGNUV0JOVjBHeUthTG9LMXJQYkFEdnB6cjFKMGR0QmdZ?=
 =?utf-8?B?dUtZTWlGWWR1ZExjUllWdEFsckNnM2V6RmVnY0hOcXBWME5tODNaYVdsTkNa?=
 =?utf-8?B?Q2gzWTErcTA3R1UxSDlhOC9KTnNwSTdiQVVVMzFJN3NTSnFEOUxVK2RwVC91?=
 =?utf-8?B?Rkt5VFh0YVZlMm9UMzViNVc2YlprY0V5cFZWZGcyUjNIWS85L2dQMGNBM3FY?=
 =?utf-8?B?dTFlMUoyZnhLRjZpNWhiMWNoVDRPc2gxd3FCRlBuQ2RVZWxPUjVUdWlFSTFT?=
 =?utf-8?B?U1JrQ0FrN3pXemZlaFM2dVQzcWNVSjhNMlNUaExqSWpNSVo5d3FmUEdTd0Nh?=
 =?utf-8?Q?54F7hSNdGT1r9mSo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B26153432924C04F953FCF04B90A77EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e48a81-c155-42cd-ee01-08da4fd77451
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2022 20:33:21.3810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AfXFkmu+CObGiOrnZJpJGJvyr4czuFeQn6OceuT/EufkMDny7a+yXDWDfENLklcKlj6qLe77O+6sQ15dPi+EedXHKStSvOez/DlNkGRNwK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3175
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIyLTA2LTE2IGF0IDEzOjMwIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFZpc2hhbCBWZXJtYSB3cm90ZToNCj4gPiBBIEdDQyB1cGRhdGUgKDEyLjEuMSkgbm93IHByb2R1
Y2VzIGEgd2FybmluZyBpbiB0aGUgeHJlYWxsb2MoKQ0KPiA+IHdyYXBwZXINCj4gPiAob3JpZ2lu
YWxseSBjb3BpZWQgZnJvbSBnaXQsIGFuZCB1c2VkIGluIHN0cmJ1ZiBvcGVyYXRpb25zKToNCj4g
PiANCj4gPiDCoCAuLi91dGlsL3dyYXBwZXIuYzogSW4gZnVuY3Rpb24g4oCYeHJlYWxsb2PigJk6
DQo+ID4gwqAgLi4vdXRpbC93cmFwcGVyLmM6MzQ6MzE6IHdhcm5pbmc6IHBvaW50ZXIg4oCYcHRy
4oCZIG1heSBiZSB1c2VkIGFmdGVyDQo+ID4g4oCYcmVhbGxvY+KAmSBbLVd1c2UtYWZ0ZXItZnJl
ZV0NCj4gPiDCoMKgwqDCoCAzNCB8wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHJldCA9IHJlYWxsb2MocHRyLCAxKTsNCj4gPiDCoMKgwqDCoMKgwqDCoCB8
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIF5+fn5+fn5+fn5+fn5+fg0KPiA+IA0KPiA+IFB1bGwgaW4gYW4gdXBkYXRlZCBkZWZpbml0
aW9uIGZvciB4cmVhbGxvYygpIGZyb20gdGhlIGdpdCBwcm9qZWN0DQo+ID4gdG8gZml4IHRoaXMu
DQo+ID4gDQo+ID4gQ2M6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29t
Pg0KPiANCj4gTG9va3MgbGlrZSBhIGZhaXRoZnVsIHJlcHJvZHVjdGlvbiBvZiB3aGF0IHVwc3Ry
ZWFtIGdpdCBkaWQgbWludXMgdGhlDQo+IG1lbW9yeV9saW1pdF9jaGVjaygpIGluZnJhLCBidXQg
d2UgY2FuIHRoaW5rIGFib3V0IHRoYXQgbGF0ZXIuDQoNCkFuZCBtaW51cyB0aGUgeG1hbGxvYygp
IHN0dWZmLCBidXQgSSBkb24ndCB0aGluayB3ZSAvbmVlZC8gdGhhdCAoeWV0KS4NCg0KPiANCj4g
UmV2aWV3ZWQtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KDQpU
aGFua3MhDQoNCg==
