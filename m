Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE553EB8
	for <nvdimm@lists.linux.dev>; Tue, 23 Aug 2022 07:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661239670; x=1692775670;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=N+zVj1WZqFI4fjGQyaUYlDphCrBl79kQPOPFIGRolJA=;
  b=XmejplcoXjaGdhT0yZfi9NUJXKzZ8Xo2qkKH7V+O8mP3eRoHnVxk1txA
   rSFRJ/PAAWEYkjfQEsOYYPvt32YMFRS0igg/1L8REC6auXd0AlDAKej7X
   L2Nvzy5gqoa+qgkh5o54H347PnFwyh8rL4xN1iTXs4bYJf2rTyDGVeOhJ
   uDFHeVu/MwLnsFEnM0UA7ft9jDqs+cTSTlBsLbVYajEPKJqwtBGg4r6eS
   6W+UnciC5dKoJVzlPmyT7sBjha7mPuiMi83WHb3kcZwXdpf+vzEpGrshm
   F42EIUzR5tYqtszdqh/8kbEdvJXLD/IU43vnvzoGUcEdM+RVfgs6I4FOa
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="280587453"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="280587453"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:27:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="642344126"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 23 Aug 2022 00:27:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 00:27:39 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 00:27:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 23 Aug 2022 00:27:39 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 23 Aug 2022 00:27:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2ZYfdAwl9cfW0g3T732cEg7Y3mLMZ5GUelShAQvJuQP1OQKnsOlOxZcRfC+WXTdlyH93tlPmGuwwF1xBHPof8gb7MTW+wu+iN8dOl7xPPU5RfqMV7yNWJzC5TjcFMBFuCrvtrz2J+496maZzzatFeg3FAnmaJAEuTFvgzdUUaVihbTOUyaC+XQmZ9zkbJcjVt2aspvidlVXxY3Px+vmJFHacSw5ZKTDDGbBkZx7lquqztRnOSnI0HCOSc/mus4Xr8cYxAUL2cRlKzLHyBhcuShaG/xktsKP0nXphYGlOVJYQbFB9HLQXLrp4YkMBZS9LZJVIco7FOdOohk8P18liw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N+zVj1WZqFI4fjGQyaUYlDphCrBl79kQPOPFIGRolJA=;
 b=m/+OPX7k723EKQgb5HPq84X+AkuHeaaEhm9ZdGXQzCFBo59UokgAWIRujGdYeX0g2dfOb0g/qdaLQTer6aguCFbrlHidWjm4gBewITYqyDAAb8O8VsDIJ2w5wmT7Zci3lgUxOBBk9zm0hxc+bCBMMOSnu1ihuBiR1Vvsp7quU4l9ZHyzZS1SjBVmyrJHE1ZSth/9csZ7V0z1GxKSCXOPaBhapzfeKQkVi+4uVmdcEjHVe6kRyg79LueYRjhIf+tRq7h8chY+JtSDrHNvSp1SUI+OEqmWj642S4SLQQGqd4SCacUrm0JlTHOhYhNhtBrr5qubnPlJDZS8kzqEs7v0SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by SJ0PR11MB5661.namprd11.prod.outlook.com (2603:10b6:a03:3b9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Tue, 23 Aug
 2022 07:27:36 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1c88:c1bd:6295:cba4]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1c88:c1bd:6295:cba4%7]) with mapi id 15.20.5546.023; Tue, 23 Aug 2022
 07:27:35 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 1/3] cxl/region: fix a dereferecnce after NULL check
Thread-Topic: [ndctl PATCH 1/3] cxl/region: fix a dereferecnce after NULL
 check
Thread-Index: AQHYtsDxocByuQuDGUi+m1HS0uvoZq28Fh0A
Date: Tue, 23 Aug 2022 07:27:35 +0000
Message-ID: <b0f9fefbad1ab051bd1b458bac84221792de7dcb.camel@intel.com>
References: <20220823072106.398076-1-vishal.l.verma@intel.com>
	 <20220823072106.398076-2-vishal.l.verma@intel.com>
In-Reply-To: <20220823072106.398076-2-vishal.l.verma@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f9a5830-6808-4ed8-752d-08da84d8f34c
x-ms-traffictypediagnostic: SJ0PR11MB5661:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CKSWEZ/gmWySzJZEi6M4L8+ccOrcm3Gs2lTV1fs/RhJj1+A7+o+ehoORbygTTtK3H/JDZKJlE+A8Q0vOo2/arCplRBNYrQA1ZmHEztrDkHNOWZIICdqGskHY5nMyE6/RIxjvt3PzODjCriLA+5ouvVX+z0K/ARXZwTBuZwk2RdTEeqqXcrGDz0+D+vTaLvEOnT0oJgSG3SGZlAOYXTfZJbAn7iNWt/iYks+v7b3LxxzJsEy7xsy8pD5hAOOessLjW9DXerSlJk75Yj1kqOs9DJiXGRpCe519/E6Di+MUqhAnO2+ruc4gzN9s5q74erganS7A8HzNaQQ5mfpuoXbXptN1hcjkyhk2y9tP/gZvzOyb1tKeemNcUsipUIEyLwRp5VMhyPeoqAnERLm+UCMhyxiiqK2YM0niJGfF+jPw0mlo9SIdgaiK2jn05HETsivsA6RzUHXICVcrOfAhUAcvCGtY4/T5yPxAWmdlQaux5ATIijnfYhWQVqzKw2K3vC+JFYUlBTBD4KDaSkrb5o1+zrMDCz6CsIB/XKg9rAb5v8w4nw/BHx5/ed2tu0xmzvGfZVKOgOgdUL0ymDiQvfTLLqve3MtyhSjHbXq2StFi67IvehhyLZsX2mHC+DLc3p79o5wsihvB1tETZHpKuTG36ylgLHSha+AdiCvmVsdZQomRYrH8Sgde5ZzIao3/bKmemqiEzEpYAfJ7jeCpZDQFo12hApuaL+fREtlQ59obs8zG7nr0VOUXIbdw29uDKxvmwHzARR1PKqSQ00MxcUGxcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(136003)(346002)(376002)(396003)(83380400001)(2906002)(8936002)(66446008)(8676002)(66946007)(66476007)(76116006)(5660300002)(64756008)(4326008)(66556008)(41300700001)(6512007)(6506007)(26005)(71200400001)(36756003)(186003)(2616005)(6486002)(478600001)(38070700005)(82960400001)(86362001)(316002)(91956017)(122000001)(54906003)(6916009)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TzJlYVYzOHVPUi9XZnFhZVVreWk3TGhRbEc0QWZnSUx4Z0tZZUxEOTM0UDB5?=
 =?utf-8?B?TXZXY3AwbENvT2dlakNkT1RVOUxvZkZ1SUwvV2pLQW1jT3RabDMyMllzd285?=
 =?utf-8?B?SkU2SGlEdXNDa2VXMTkySVU3L3RsOWFCTGUyRHoyY1o4TGk2c1ZJSUs4ZUg0?=
 =?utf-8?B?WjFoTU9uamEwMmd1TDdaRXIyeVNtMkxJRHpIWUdrN3lvM2hVdUh4VENVaU1w?=
 =?utf-8?B?TXNKNTN6N0ovNGw4cDdvYVFIUTB5RENVZGdTN1BxZGpybXY2MW41ZzllbDJF?=
 =?utf-8?B?ZHdCL2ZGZzRaMVdFeFlhUGl1QVBiV3ByRnBjcy9EdkhJY1RSczlJaU03Y2Zm?=
 =?utf-8?B?czFONkwzUzdCaFQrUHBCNEtyRG5YcHc2RXQ2YTlieVU3NVBRSElmNUVCejJW?=
 =?utf-8?B?bEIzWVlLWXdWU29EMi9aaVF1MHVlUEtYZjNBWTVBVlBsc3NVdHZvVGcyOTVC?=
 =?utf-8?B?NjFHZldSTXdEa3F6L3BNN01QdW9QV29pOUJOZkx2R21CZUxTZWEyVEgweldL?=
 =?utf-8?B?TXZVblR0YlpobFQyWEpVWWFob0NtOGdMakpPMXhpUHNud2tGM2NDbUxTU2Zz?=
 =?utf-8?B?ai9Pb1R6OUo0Sm1uK1F3RXJ5OENEUktkT3VwWDRIbzk2aklIL01QOTFQVVEr?=
 =?utf-8?B?MU5TWkhmbXZPK29HYi9QSWR1aitGdFppamZ1VkpRNVA1Rk5OaEY2TUJEdVQ5?=
 =?utf-8?B?SS9XazNWbmF4cnF1c3RHbG1Yem5YeU5qd0Rka29HNi9FMmx3NFNCakpxMHpq?=
 =?utf-8?B?bDkwcnR0eXQ5WERyNkpTc21pNm5wc1h4SEtkdkNTSlJjcTJNVjM2eTRoZHJG?=
 =?utf-8?B?bVRsZHVwRXhpbHdaWkFoOHY5aFBGVUdzZ0xvbzU2YVhFdWpQZjR2T1owZWNj?=
 =?utf-8?B?ZEhPS0RDVS9XWmdFSXkyNkFwZE5JWjFkZGdybGM2SDdTMW5sak4xdU1iQ05F?=
 =?utf-8?B?ZG1DUHo0K3oxMlNSSWVwQUJuUWlGdUV6eG81U1JRaVpwM3NvUHJobnBTbUNZ?=
 =?utf-8?B?ZDZ5S0F0RHNpeDQxVzgrdEZrckpQSXRvMXdJVWFXb29Pb283WG95b29kbExH?=
 =?utf-8?B?b0g2Q2d2QUgrMG9PRkxuUXF1QjlrQnlkRGpBYWdPZ2tBYlc4SFAxdUh5T0hj?=
 =?utf-8?B?OGpLWS9rbFh0OXBjdUR6cWZKWVZlRUFKbUo1REh0cnQ1WEE1b29QdzZ2bTlM?=
 =?utf-8?B?TUx2b3JibVlBY04rTjRXbUd3MHVYYlJoOEQvM09QbUQ1Q0Fiem5YbUh1Mlps?=
 =?utf-8?B?OGovczNJUGdRWTZFSVB6RDhDZTkrbFJyeWRHNVJhVzVpeGZ1YlpvVldFTlhO?=
 =?utf-8?B?NGY4cEI1U1g3Ynl2R282aldQRlFFVnlBMUxpb1lyaHFpbkJ6ZGtDWmpubHF6?=
 =?utf-8?B?ZG53cWdxaWxHQ1dRbFlsS2dENUsxdGtReitLRU1kdlVIT3dWencrczQ1K051?=
 =?utf-8?B?dkN4QzAvajR4OU1WT1J1cGR2NEVzdHB5bVkvUkxMeDVSbkl2VVdFSVlMVFBy?=
 =?utf-8?B?MDJvbit4YzhVVElSM2NLcGdPVmxtQUphQjhxZk5MWXdtQXR1K2l0UEVHOTVE?=
 =?utf-8?B?R0EzSzJJM0dsSmpzSUFuMC9sb1IwNDJKRHZoMjZSNTB2M2RkL2hPd3UyRHVi?=
 =?utf-8?B?UU1YeG9XK0VuWnZ6eW14ekpBZDR2ajhWOFF0djJqYzFyL3E4ZXUyTjdIUFpN?=
 =?utf-8?B?ZlJXam1lT1dvTElNWWh4dU9ZUlVMcGNaeFh1UEpsaUJlRjV2dDdnd0c2dGNW?=
 =?utf-8?B?VHVGaU9hY09EMlBzQWNoSk0xcGZNS3BSTjBKMW1Bdzl3N3BLOW1ZTkN6dE42?=
 =?utf-8?B?M2ZnZ1kvMVZWYSt3S1V0aGdrVFFmcEU3SUphVVB5TnAwZWRpcDY4ZUxFNSs1?=
 =?utf-8?B?Tk5VTVJObVFiV3RGTitaRW9BcUJQTGtiZHpyOXFnalFPN3ZFUUkwNmYySnRo?=
 =?utf-8?B?YmYwTXBKemhjNmtkYjV2UzdFZGtJc3QyWlVVS256UDVsSVdMWXFYK2IzaWFH?=
 =?utf-8?B?WWtHeFNoSG1jMnlzcm1QVkpaaVUrV2YwaXdZS0t0TDJWbDdyU0RkU3Noandu?=
 =?utf-8?B?Nll5ZDBLYUhkcWtaUGgwNDlNU1RqRkt0QXVhbzJRMFNiZkFoS1l1c3dvNzNK?=
 =?utf-8?B?VTVsLzhiK0VVb0JNWFN3cXFjbWtQRldsc1VBampmTytvc0UxcG95TWk0M0Ru?=
 =?utf-8?B?a3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6605DB6CDB363499102147347126C65@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f9a5830-6808-4ed8-752d-08da84d8f34c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2022 07:27:35.5554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZQaJpc6P4kmsMXMpV692w1TCDFs+rhk6iCpiImhkwsNRefkyDiDGV53sYx9de/GAxu2ZP0lJR7CvFdHwS+LWqvSt3Tguwek4DqaX5Cq4oMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5661
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIyLTA4LTIzIGF0IDAxOjIxIC0wNjAwLCBWaXNoYWwgVmVybWEgd3JvdGU6Cj4g
QSBOVUxMIGNoZWNrIGluIHJlZ2lvbl9hY3Rpb24oKSBpbXBsaWVzIHRoYXQgJ2RlY29kZXInIG1p
Z2h0IGJlIE5VTEwsIGJ1dAo+IGxhdGVyIHdlIGRlcmVmZXJlbmNlIGl0IGR1cmluZyBjeGxfZGVj
b2Rlcl9mb3JlYWNoKCkuCj4gCj4gU2luY2UgY3hsX2RlY29kZXJfZm9yZWFjaCgpIHdvbid0IGV2
ZXIgZW50ZXIgdGhlIGxvb3Agd2l0aCBhIE5VTEwgZGVjb2RlciwKPiB0aGUgY2hlY2sgd2FzIHN1
cGVyZmx1b3VzLiBSZW1vdmUgaXQuCj4gCj4gQ2M6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlh
bXNAaW50ZWwuY29tPgo+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVy
bWFAaW50ZWwuY29tPgo+IC0tLQo+IMKgY3hsL3JlZ2lvbi5jIHwgMiAtLQo+IMKgMSBmaWxlIGNo
YW5nZWQsIDIgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2N4bC9yZWdpb24uYyBiL2N4
bC9yZWdpb24uYwo+IGluZGV4IGEzMDMxM2MuLjkzNzJkNmIgMTAwNjQ0Cj4gLS0tIGEvY3hsL3Jl
Z2lvbi5jCj4gKysrIGIvY3hsL3JlZ2lvbi5jCj4gQEAgLTY4OCw4ICs2ODgsNiBAQCBzdGF0aWMg
aW50IHJlZ2lvbl9hY3Rpb24oaW50IGFyZ2MsIGNvbnN0IGNoYXIgKiphcmd2LCBzdHJ1Y3QgY3hs
X2N0eCAqY3R4LAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY3hsX2RlY29kZXJf
Zm9yZWFjaCAocG9ydCwgZGVjb2Rlcikgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGRlY29kZXIgPSB1dGlsX2N4bF9kZWNvZGVyX2ZpbHRlcihkZWNv
ZGVyLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBwYXJhbS5yb290X2RlY29kZXIpOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKCFkZWNvZGVyKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNvbnRpbnVlOwoKSG0s
IHRoaXMgaXMgYWN0dWFsbHkgd3JvbmcuIFdlIG5lZWQgdG8gc2F2ZSB0aGUgZmlsdGVyIHJlc3Vs
dHMgaW4gYSBuZXcKdmFyaWFibGUsIGFuZCBOVUxMIGNoZWNrIHRoYXQsIHdoaWxlIGtlZXBpbmcg
dGhlIG9yaWdpbmFsICdkZWNvZGVyJwp2YXJpYWJsZSBpbnRhY3QgZm9yIHRoZSBsb29wLiBJJ2xs
IHNlbmQgdjIuCgo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHJjID0gZGVjb2Rlcl9yZWdpb25fYWN0aW9uKHAsIGRlY29kZXIsIGFjdGlvbiwgY291bnQp
Owo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChy
YykKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgZXJyX3JjID0gcmM7Cgo=
