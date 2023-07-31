Received: from mgamail.intel.com (unknown [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB8319BD5
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 19:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690833260; x=1722369260;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CnuRhtnMKbaXvxIaOlsKx5VyUKOy4S3b7So7ky0ymWY=;
  b=Cl7HPYvs/o16R6ViUNpfTXINDQtVb3Ms1fCGIPg/i05tqnh45SMd6Yqr
   iAO33yQaY3zHzZO9jLqTaFZGdU2w1J9hInxm0HKTVPcSOS1Jrfj4y0iBn
   7wo8SVkEKEgGIl/SBQ5b8QFFT9wbmCEOCCjLn1nM3V++0utMEaIHnobOK
   tYeWKQQUJsE4EWP60Nk3IU2qthzCAhr1Mkp2VTvxnzFfuSJ/LQNkwbxN+
   0/69Cz64+naq+XJMJbCaiKw7/3TDKi3/ZjE60dLycFXHxxEbRxwHhJS6W
   A1sGUas3KGGnsm9PS/iAS4UX9i0h3TqzDA/mbXTz7xtrVpjztm6vL5Orv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="435425750"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="435425750"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 12:54:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="1059111387"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="1059111387"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 31 Jul 2023 12:54:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 12:54:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 31 Jul 2023 12:54:19 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 31 Jul 2023 12:54:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlSf3rjWaBJd8Wp33ZBpgxA7ZF+vKO6LLaRUHlNi8RgtaEmaX+q5eA9Z0AijxBC2SDsXx0nUZbZzaXPsQSBCXxtJOjWCtb5vHHTskRKjptNVOZP+58jpmbuIgGGOoNpmo4E3P9zwGGcYsjpDgO+tbpKBz42mQKkv3mg4LE5xhK0Fo/Ub5UeqCzAQijDRSaaQSQQrXwKoTULwUSiPcIFBLPpN4gXUBYLML7YIPZI2kceesCHYBt3WAM9k1qWkMVUth5PhiPVMXvEAdLGh62BfYnkxN7G+HNXQKeUKNL2YxWq4s/in6Ypo4+2zjlzhn+KgvANcjB1Yi5LEjdXkUYwvVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CnuRhtnMKbaXvxIaOlsKx5VyUKOy4S3b7So7ky0ymWY=;
 b=JyVYE+JbfLQCwEEFB5xoKpSPXFQwCYEl89aHY1/34qJN1svHBybPzCrt+Ov5bOoOdmqmTmGSvVHesmbRWeUKWV3NjlkcmCkQmmlyGZjn2fsKecXnqysGK8+DOrCtEgchxyTtvvVLIIzq3GwG/s8Tc22FicSHYKnT9RTjsYpPYzMhNiBBIQjD0VNL7/aqE48acM573cgoze7uMtgdC0fqcukZE0zSqBG24dTy3aezaJAemQ/3uW8y8r43PutrGzXo5tusOA3LQyzXDxhVYXn2r4yMtoPFMq8zP6G0Jr8jCS78av0DkvF/qMytpHgQfyskNgsIjbkvDQNSOPoyP/Q+Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SA2PR11MB5209.namprd11.prod.outlook.com (2603:10b6:806:110::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.43; Mon, 31 Jul
 2023 19:54:11 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e527:d79c:2bb3:e370]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e527:d79c:2bb3:e370%2]) with mapi id 15.20.6631.026; Mon, 31 Jul 2023
 19:54:11 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Weiny, Ira" <ira.weiny@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl] ndctl/cxl/test: Add CXL event test
Thread-Topic: [PATCH ndctl] ndctl/cxl/test: Add CXL event test
Thread-Index: AQHZwNEXh87x+l+JpkqKV9zFIAoTPK/UT+eA
Date: Mon, 31 Jul 2023 19:54:10 +0000
Message-ID: <03c94c0834e31035322299dd2c7952d97a70ebc3.camel@intel.com>
References: <20230726-cxl-event-v1-1-1cf8cb02b211@intel.com>
In-Reply-To: <20230726-cxl-event-v1-1-1cf8cb02b211@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SA2PR11MB5209:EE_
x-ms-office365-filtering-correlation-id: 171277ca-4669-4100-f552-08db91ffe8b3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QWA2/u2cjnSwmuhN+gkuojlnTvBQCvhtJ2eGurmey834BU0Uq35ZWKhqjAZ9+CQjb1pdMfB1Kycb4b9tdwqbk8xXXIW8zz/Vzb5VAFxT9sYuDFja9mczaAZbVYVLlgMMz7XIIwnv59xVos92pKbiSJfXY2ah8IbtiG24Ayu0QFF/NdzSjBV4bqoAlxLUFenYmf1H+fh6lHtpkrA1onY1EDNQxqDKqrlL9vv/RG9pNk0P0EtJw6vLcWINB4RVYh+A9x2ut1utEAT93w0T+7pOSw+fCjO6k/saMTSApe4CyFGVTTOeu+ohJpEwo6jT+1cnK3WoLi4EqVqhAHYzQvSL90wN9PkDs80Gw6L5wAdMkdZebVCnVWIOI6sByE9X7340VDvLJuRX8+YiPhFxsQ+/cekeUTvQS6khmYvnDqTkDLp9sBj6wawryokPJBkQpQ7emDn1JIwMwdT/8q5LmLoagLuhTMdGN3JD5uf1lIgQZ/L2E50VzLGxGXmHtBQRUfSr3uM9SfOFgO+xB5nbgDx6IdtkziX6MnJA0UC/xlxLeMa/Cu1VRBYlnvcT0XZ140sq9Px1IVFRkASi/jbkXjFzZKMqfPA8XyuOenHmUbjFsHOLHiDzW8DTNAOHWRLAZT0U
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199021)(38070700005)(2616005)(36756003)(26005)(71200400001)(6486002)(6512007)(6506007)(54906003)(478600001)(86362001)(37006003)(82960400001)(38100700002)(122000001)(186003)(83380400001)(66556008)(64756008)(66476007)(41300700001)(6636002)(6862004)(8676002)(8936002)(4326008)(316002)(5660300002)(2906002)(76116006)(66446008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mk5JMWpaZUgrTCtDY0svOG9HUmg5VkNkajJWdGxpYnZBSzZFVUVLL0tiM3hQ?=
 =?utf-8?B?TWx4UFBxSlRxOVQ4OENMdGFVQjBmVTNSN3ZJSURYL2g1dDFJdTdsOVg4MFZm?=
 =?utf-8?B?cEZ4MUJJUGk1Y2lrQ0VxWk9BaWNnWThWTXQ4cVgxWGJtNFVTODl3TjFqWVFo?=
 =?utf-8?B?M1lZb3p5OFF6VEdQM2xHVGJ4a2tXaEF4R0hGdkNaaFpIT3UzWUN6OXV1L0p6?=
 =?utf-8?B?WWpBRjFFd05kckloc1VjaU53SlZsa1NPTnpiWUo0anNQSmVXak5xNUdxZ1hC?=
 =?utf-8?B?d2JIbXlFY2JLT3QrbytzNEpBdzBKdlEvc2JaOWFWSjlOd1B5cG55WG8yQ0F4?=
 =?utf-8?B?VmRMdmZ6YmkxZUkvTG42ZDhsQVVqVjVSYzJ5NENKYXpGTlYvNVZETTZDT3VE?=
 =?utf-8?B?TWFRVG51eHF1S2F4dmNRN0oxYzhoRVRMODVmRGxkU3Z2bDViYkRDbGJwTWtO?=
 =?utf-8?B?MWN6WmhDcVdnRGdGdnFlbksvTEs1YWxGR2crVmkrdXBoVFFEZUVnWGpDTjVM?=
 =?utf-8?B?N28wcXVzWWdxSWc3czJHQnA2eGRCSVh5Z1NENW4zSmhCYk5XWUtrcXdqRVpB?=
 =?utf-8?B?RCszUXltbFdzSWZBRUlvbVJWVlVKay9VRmJGQ0hoZVcyRFBNNU50SGQva0lQ?=
 =?utf-8?B?OTZNOGNPNEJSVzVqc3B0dytxOHAxY20wNGJpbzgrZ1hiQWhpNXl3Ujg2bW0w?=
 =?utf-8?B?bmxsbHBUc1hwdjNvLzhNWW9PODdOOEZieGFjTGhScXFid0NFRHZwazd4MU53?=
 =?utf-8?B?bTNQTVE1bmZwRmhqQUppZnpNTm9iVThrR0JYOTladk5EcjQyNFdVK0pQa0Iz?=
 =?utf-8?B?OUJpRnZFTUhiYUVnZGpLSWVaam9rTnlURnZEbHJaejROK2ZQTWFNb0pSYVow?=
 =?utf-8?B?bFRtTmowYU5YYmROOHMrMTZCSkZNSURjNGNDendlekhSZmY2Tm9nbllGQzBD?=
 =?utf-8?B?ZlFGaUs0SWIwWkp5TndEenBnUVMxeGRBV001aE9ES1A3KytzUyt1aGFSbk5X?=
 =?utf-8?B?a3VRSFp3cHVxQ3QvOFlLdnZqeitRVVVNOVlxUTVZTHJwcmVpamU2elFxbmlo?=
 =?utf-8?B?dHZxYXE5dUVPZnFMMnY0dWk3L29vbUQ3STk3VXkrd0UyUWd0SVJ4VjFJdHNK?=
 =?utf-8?B?aXp0OVYwdFNsUklDRzVLaU8wQVNJaUFaeTcrRWFzOGxSQTRJV1RVMXVJOXdy?=
 =?utf-8?B?UTVBekNHRC9hZlhaK3V4eUV0TTlSWGx2VnF3eGVYakdFWkdWay9NQUxxcjQw?=
 =?utf-8?B?NjJDQUZaOTlmMVVLenV2UU9EeUZUbTB2Z1JqWVkwY1Z0WTMzbkN1UFFRZzRq?=
 =?utf-8?B?T2taMzV4Z1RuTjZwb0RQa3pJcWE2ODJ3MVJ3UUY0THBwK3ZSVm85WmNlYWFE?=
 =?utf-8?B?cThwb0RFK0JaRlJLWVhiQmdLUVNRdjZoaUZuSG80MnpmbGNFY0UyV0xvSVAw?=
 =?utf-8?B?T1VXbG92NXVJZUJZTVlpU0MyUVRjQmhlUStTSXJWYVlwN1NUTDhZQWcxYTFK?=
 =?utf-8?B?dlRoTWY5MjVaYWpjek42K3phNElYS3ZjZ0Fla2o3MTJuaGZ3NUdQUGlWRkND?=
 =?utf-8?B?RnYzYW1ZUG1vM3BRMkJJVDVwY1VOaWUxNEExLytNYno0a25JK0Z5M1A5UHZK?=
 =?utf-8?B?OCt0U0QxN3lPNzNvM3V6b2M5eVFTY0ZWTlBwYjhMdVdmdnJReDJDajNwVGxF?=
 =?utf-8?B?TTRLTlVXNFk2N2IwTkc4dk1pVGI0MGYzN0kwRERFb3hFcWhGR1RLSWFENmgr?=
 =?utf-8?B?WVhJZDI4bmJsUTNRUzJDeDZLd3MxUmdJN2kwRmRaQ2F5RFRtN3l2UThGK25x?=
 =?utf-8?B?d0Y4eHVGd0tSRjU1Z3RQU2FrMjI1Q2IyRlBCWGdXTlRHekZ0cFVRMk1XSG4w?=
 =?utf-8?B?ZWhzUUxxRTB1ejJid0l3bDVTYk1Za2NwMVRGcnRGZm1OdlFJM1UwYWRaeDda?=
 =?utf-8?B?VnJoWWUxSHhwNE81MTVVWVZtZW1kcUlXTU45cTdBZUFnaUF6cHR6N3FseE50?=
 =?utf-8?B?WVlORGZyejNtQ05zZjdPcHU0SnBhMDdEd1J3c0hvdEE0NFJVeWg1T3VBcHhG?=
 =?utf-8?B?KzFxMTVwell3aGVrOFprUUFTQXFBb3ZqSEVXRjNQWk02NWhyWUR3R2lyMVds?=
 =?utf-8?B?clVzSHJub1dmZVgrQi9JZURqejg3M21sOW80VUZiZGcwVEhycHp2S241WEsw?=
 =?utf-8?B?SXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5057615D0F44045A715921316D8910E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 171277ca-4669-4100-f552-08db91ffe8b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2023 19:54:10.9626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c6PWufDg7SIqdbN6i+/tL2CEdtqp4UPh62dtzffrdU45tDTg+Vtdi3qYOMfjuVWbnsQsSGJVZMg06NYIi4bqF8w1c2VwT2YD+f374D0kOe8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5209
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIzLTA3LTI3IGF0IDE0OjIxIC0wNzAwLCBJcmEgV2Vpbnkgd3JvdGU6DQo+IFBy
ZXZpb3VzbHkgQ1hMIGV2ZW50IHRlc3Rpbmcgd2FzIHJ1biBieSBoYW5kLsKgIFRoaXMgcmVkdWNl
cyB0ZXN0aW5nDQo+IGNvdmVyYWdlIGluY2x1ZGluZyBhIGxhY2sgb2YgcmVncmVzc2lvbiB0ZXN0
aW5nLg0KPiANCj4gQWRkIGEgQ1hMIHRlc3QgYXMgcGFydCBvZiB0aGUgbWVzb24gdGVzdCBpbmZy
YXN0cnVjdHVyZS7CoCBQYXNzaW5nIGlzDQo+IHByZWRpY2F0ZWQgb24gcmVjZWl2aW5nIHRoZSBh
cHByb3ByaWF0ZSBudW1iZXIgb2YgZXJyb3JzIGluIGVhY2ggbG9nLg0KPiBJbmRpdmlkdWFsIGV2
ZW50IHZhbHVlcyBhcmUgbm90IGNoZWNrZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBJcmEgV2Vp
bnkgPGlyYS53ZWlueUBpbnRlbC5jb20+DQo+IC0tLQ0KPiDCoHRlc3QvY3hsLWV2ZW50cy5zaCB8
IDY4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
Kw0KPiDCoHRlc3QvbWVzb24uYnVpbGTCoMKgIHzCoCAyICsrDQo+IMKgMiBmaWxlcyBjaGFuZ2Vk
LCA3MCBpbnNlcnRpb25zKCspDQoNCkhpIElyYSwNCg0KVGhhbmtzIGZvciBhZGRpbmcgdGhpcyB0
ZXN0LiBKdXN0IGEgZmV3IG1pbm9yIGNvbW1lbnRzIGJlbG93LCBvdGhlcndpc2UNCmxvb2tzIGdv
b2QuDQoNCj4gDQo+IGRpZmYgLS1naXQgYS90ZXN0L2N4bC1ldmVudHMuc2ggYi90ZXN0L2N4bC1l
dmVudHMuc2gNCj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gaW5kZXggMDAwMDAwMDAwMDAwLi5m
NTEwNDZlYzM5YWQNCj4gLS0tIC9kZXYvbnVsbA0KPiArKysgYi90ZXN0L2N4bC1ldmVudHMuc2gN
Cj4gQEAgLTAsMCArMSw2OCBAQA0KPiArIyEvYmluL2Jhc2gNCj4gKyMgU1BEWC1MaWNlbnNlLUlk
ZW50aWZpZXI6IEdQTC0yLjANCj4gKyMgQ29weXJpZ2h0IChDKSAyMDIzIEludGVsIENvcnBvcmF0
aW9uLiBBbGwgcmlnaHRzIHJlc2VydmVkLg0KPiArDQo+ICsuICQoZGlybmFtZSAkMCkvY29tbW9u
DQo+ICsNCj4gK3NldCAtZXgNCj4gKw0KPiArdHJhcCAnZXJyICRMSU5FTk8nIEVSUg0KPiArDQo+
ICtjaGVja19wcmVyZXEgImpxIg0KPiArDQo+ICttb2Rwcm9iZSAtciBjeGxfdGVzdA0KPiArbW9k
cHJvYmUgY3hsX3Rlc3QNCj4gKw0KPiArZGV2X3BhdGg9Ii9zeXMvYnVzL3BsYXRmb3JtL2Rldmlj
ZXMiDQo+ICsNCj4gK3Rlc3RfY3hsX2V2ZW50cygpDQo+ICt7DQo+ICvCoMKgwqDCoMKgwqDCoG1l
bWRldj0iJDEiDQo+ICsNCj4gK8KgwqDCoMKgwqDCoMKgZWNobyAiVEVTVDogdHJpZ2dlcmluZyAk
bWVtZGV2Ig0KPiArwqDCoMKgwqDCoMKgwqBlY2hvIDEgPiAkZGV2X3BhdGgvJG1lbWRldi9ldmVu
dF90cmlnZ2VyDQoNClF1b3RlIHRoZSAiJHZhcmlhYmxlcyIgaGVyZS4gV2UgZG9uJ3QgZXhwZWN0
IHNwYWNlcyBpbiB0aGUgcGF0aCBpbiB0aGlzDQpjYXNlLCBzbyBpdCB3aWxsIHN0aWxsIHdvcmss
IGJ1dCBpdCBpcyBnb29kIHByYWN0aWNlIHRvIGFsd2F5cyBxdW90ZQ0KZXZlcnl0aGluZy4NCg0K
V2UgbWlnaHQgYWxzbyBuZWVkIGEgdGVzdCB0byBzZWUgaWYgdGhpcyBmaWxlIGV4aXN0cyBmaXJz
dC4gRm9yIGtlcm5lbHMNCnRoYXQgZG9uJ3QgaGF2ZSB0aGlzIHN1cHBvcnQsIHdlIHByb2JhYmx5
IHdhbnQgdG8gcHJpbnQgYSBtZXNzYWdlIGFuZA0Kc2tpcCB0aGUgdGVzdCAocmV0dXJuICc3Nycp
Lg0KDQo+ICt9DQo+ICsNCj4gK3JlYWRhcnJheSAtdCBtZW1kZXZzIDwgPCgiJENYTCIgbGlzdCAt
YiBjeGxfdGVzdCAtTWkgfCBqcSAtciAnLltdLmhvc3QnKQ0KPiArDQo+ICtlY2hvICJURVNUOiBQ
cmVwIGV2ZW50IHRyYWNlIg0KPiArZWNobyAiIiA+IC9zeXMva2VybmVsL3RyYWNpbmcvdHJhY2UN
Cj4gK2VjaG8gMSA+IC9zeXMva2VybmVsL3RyYWNpbmcvZXZlbnRzL2N4bC9lbmFibGUNCj4gK2Vj
aG8gMSA+IC9zeXMva2VybmVsL3RyYWNpbmcvdHJhY2luZ19vbg0KPiArDQo+ICsjIE9ubHkgbmVl
ZCB0byB0ZXN0IDEgZGV2aWNlDQo+ICsjZm9yIG1lbWRldiBpbiAke21lbWRldnNbQF19OyBkbw0K
PiArI2RvbmUNCg0KUHJvYmFibHkganVzdCByZW1vdmUgdGhlIGNvbW1lbnRlZCBvdXQgbG9vcCwg
aWYgd2UgbmVlZCB0byB0ZXN0IG1vcmUNCnRoYW4gb25lIG1lbWRldiBpbiB0aGUgZnV0dXJlLCBp
dCBpcyBlYXN5IGVub3VnaCB0byBhZGQgYmFjayB0aGVuLg0KDQo+ICsNCj4gK3Rlc3RfY3hsX2V2
ZW50cyAiJG1lbWRldnMiDQoNClNob3VsZG4ndCB1c2UgIiRtZW1kZXZzIiBoZXJlIHNpbmNlIGl0
IGlzIGFuIGFycmF5LiBJZiB5b3Ugd2FudCB0byBwYXNzDQppbiBqdXN0IHRoZSBmaXJzdCBtZW1k
ZXYsIHVzZSAiJHttZW1kZXZzWzBdfSINCg0KPiArDQo+ICtlY2hvIDAgPiAvc3lzL2tlcm5lbC90
cmFjaW5nL3RyYWNpbmdfb24NCj4gKw0KPiArZWNobyAiVEVTVDogRXZlbnRzIHNlZW4iDQo+ICtj
YXQgL3N5cy9rZXJuZWwvdHJhY2luZy90cmFjZQ0KPiArbnVtX292ZXJmbG93PSQoZ3JlcCAiY3hs
X292ZXJmbG93IiAvc3lzL2tlcm5lbC90cmFjaW5nL3RyYWNlIHwgd2MgLWwpDQo+ICtudW1fZmF0
YWw9JChncmVwICJsb2c9RmF0YWwiIC9zeXMva2VybmVsL3RyYWNpbmcvdHJhY2UgfCB3YyAtbCkN
Cj4gK251bV9mYWlsdXJlPSQoZ3JlcCAibG9nPUZhaWx1cmUiIC9zeXMva2VybmVsL3RyYWNpbmcv
dHJhY2UgfCB3YyAtbCkNCj4gK251bV9pbmZvPSQoZ3JlcCAibG9nPUluZm9ybWF0aW9uYWwiIC9z
eXMva2VybmVsL3RyYWNpbmcvdHJhY2UgfCB3YyAtbCkNCg0KTWlub3Igbml0LCBidXQgeW91IGNh
biAnZ3JlcCAtYycgaW5zdGVhZCBvZiAnZ3JlcCB8IHdjIC1sJw0KDQpBbHNvIGNvdWxkIHB1dCAv
c3lzL2tlcm5lbC90cmFjaW5nL3RyYWNlIGludG8gYSB2YXJpYWJsZSBqdXN0IGZvcg0KcmVhZGFi
aWxpdHkgc2luY2UgaXQgaXMgdXNlZCBtYW55IHRpbWVzLg0KDQo+ICtlY2hvICLCoMKgwqDCoCBM
T0fCoMKgwqDCoCAoRXhwZWN0ZWQpIDogKEZvdW5kKSINCj4gK2VjaG8gIsKgwqDCoMKgIG92ZXJm
bG93wqDCoMKgwqDCoCAoIDEpIDogJG51bV9vdmVyZmxvdyINCj4gK2VjaG8gIsKgwqDCoMKgIEZh
dGFswqDCoMKgwqDCoMKgwqDCoCAoIDIpIDogJG51bV9mYXRhbCINCj4gK2VjaG8gIsKgwqDCoMKg
IEZhaWx1cmXCoMKgwqDCoMKgwqAgKDE2KSA6ICRudW1fZmFpbHVyZSINCj4gK2VjaG8gIsKgwqDC
oMKgIEluZm9ybWF0aW9uYWwgKCAzKSA6ICRudW1faW5mbyINCj4gKw0KPiAraWYgWyAiJG51bV9v
dmVyZmxvdyIgLW5lIDEgXTsgdGhlbg0KPiArwqDCoMKgwqDCoMKgwqBlcnIgIiRMSU5FTk8iDQo+
ICtmaQ0KPiAraWYgWyAiJG51bV9mYXRhbCIgLW5lIDIgXTsgdGhlbg0KPiArwqDCoMKgwqDCoMKg
wqBlcnIgIiRMSU5FTk8iDQo+ICtmaQ0KPiAraWYgWyAiJG51bV9mYWlsdXJlIiAtbmUgMTYgXTsg
dGhlbg0KPiArwqDCoMKgwqDCoMKgwqBlcnIgIiRMSU5FTk8iDQo+ICtmaQ0KPiAraWYgWyAiJG51
bV9pbmZvIiAtbmUgMyBdOyB0aGVuDQo+ICvCoMKgwqDCoMKgwqDCoGVyciAiJExJTkVOTyINCj4g
K2ZpDQoNClBlcmhhcHMgZGVmaW5lIHZhcmlhYmxlcyBmb3IgZWFjaCBvZiB0aGUgZXhwZWN0ZWQg
bnVtcywgdGhhdCB3YXkgdGhlcmUNCmlzIG9ubHkgb25lIHNwb3QgdG8gY2hhbmdlIGluIGNhc2Ug
dGhlIG51bWJlcnMgY2hhbmdlIGluIHRoZSBmdXR1cmUuDQoNCj4gKw0KPiArY2hlY2tfZG1lc2cg
IiRMSU5FTk8iDQo+ICsNCj4gK21vZHByb2JlIC1yIGN4bF90ZXN0DQo+IGRpZmYgLS1naXQgYS90
ZXN0L21lc29uLmJ1aWxkIGIvdGVzdC9tZXNvbi5idWlsZA0KPiBpbmRleCBhOTU2ODg1ZjZkZjYu
LmEzMzI1NWJkZTFhOCAxMDA2NDQNCj4gLS0tIGEvdGVzdC9tZXNvbi5idWlsZA0KPiArKysgYi90
ZXN0L21lc29uLmJ1aWxkDQo+IEBAIC0xNTUsNiArMTU1LDcgQEAgY3hsX3N5c2ZzID0gZmluZF9w
cm9ncmFtKCdjeGwtcmVnaW9uLXN5c2ZzLnNoJykNCj4gwqBjeGxfbGFiZWxzID0gZmluZF9wcm9n
cmFtKCdjeGwtbGFiZWxzLnNoJykNCj4gwqBjeGxfY3JlYXRlX3JlZ2lvbiA9IGZpbmRfcHJvZ3Jh
bSgnY3hsLWNyZWF0ZS1yZWdpb24uc2gnKQ0KPiDCoGN4bF94b3JfcmVnaW9uID0gZmluZF9wcm9n
cmFtKCdjeGwteG9yLXJlZ2lvbi5zaCcpDQo+ICtjeGxfZXZlbnRzID0gZmluZF9wcm9ncmFtKCdj
eGwtZXZlbnRzLnNoJykNCj4gwqANCj4gwqB0ZXN0cyA9IFsNCj4gwqDCoCBbICdsaWJuZGN0bCcs
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBsaWJuZGN0bCzCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgICduZGN0bCcgXSwNCj4gQEAgLTE4Myw2ICsxODQsNyBAQCB0ZXN0cyA9
IFsNCj4gwqDCoCBbICdjeGwtbGFiZWxzLnNoJyzCoMKgwqDCoMKgwqDCoMKgwqAgY3hsX2xhYmVs
cyzCoMKgwqDCoMKgwqDCoCAnY3hsJ8KgwqAgXSwNCj4gwqDCoCBbICdjeGwtY3JlYXRlLXJlZ2lv
bi5zaCcswqDCoCBjeGxfY3JlYXRlX3JlZ2lvbizCoCAnY3hsJ8KgwqAgXSwNCj4gwqDCoCBbICdj
eGwteG9yLXJlZ2lvbi5zaCcswqDCoMKgwqDCoCBjeGxfeG9yX3JlZ2lvbizCoMKgwqDCoCAnY3hs
J8KgwqAgXSwNCj4gK8KgIFsgJ2N4bC1ldmVudHMuc2gnLMKgwqDCoMKgwqDCoMKgwqDCoCBjeGxf
ZXZlbnRzLMKgwqDCoMKgwqDCoMKgwqAgJ2N4bCfCoMKgIF0sDQo+IMKgXQ0KPiDCoA0KPiDCoGlm
IGdldF9vcHRpb24oJ2Rlc3RydWN0aXZlJykuZW5hYmxlZCgpDQo+IA0KPiAtLS0NCj4gYmFzZS1j
b21taXQ6IDJmZDU3MGEwZWQ3ODhiMWJkMDk3MWRmZGIxNDY2YTVkYmNiNzk3NzUNCj4gY2hhbmdl
LWlkOiAyMDIzMDcyNi1jeGwtZXZlbnQtZGMwMGEyZjk0YjYwDQo+IA0KPiBCZXN0IHJlZ2FyZHMs
DQoNCg==
