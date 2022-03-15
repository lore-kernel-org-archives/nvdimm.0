Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F170423CC
	for <nvdimm@lists.linux.dev>; Tue, 15 Mar 2022 16:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647363299; x=1678899299;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rkAgEbpAA8tGUR55RfMkGih0NR2QW6KNlZx28IVUob0=;
  b=hKJQ01acjWrdEHBrh87KUSPm2zkggTlBiTI1SxJ1n9aaoEZcS0Ifzy80
   W36akmOqETnAvifuLGdq1opD6Wl3InjDx9+Bgn6qZD3nGQyuUxMs6FRrR
   Y2r3gQtoI/TQ57wWKSTp+I0zrUQcvkIy2RA6GIYHtqgSxDD4PJQLXl18k
   WPTEKCHdX9vcU4UTEtdtTzWWRj0hLQRd6/ZcDrWdIA0HW7OCVbo4+Csli
   v9SgQyvIw7fnIhHMUsLIZAie7iR5S59ZPR8B/toXStFPp5BU01J6fvvBS
   oh9yv2I/oVHQyappifoU/tzplKDtYVI+3FpG6zBcJ8tPO0PDLvhjw+QQM
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236963647"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="236963647"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 09:54:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="714241924"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga005.jf.intel.com with ESMTP; 15 Mar 2022 09:54:57 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 09:54:57 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 09:54:57 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 15 Mar 2022 09:54:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 15 Mar 2022 09:54:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjPS9+N0ljYwdrdmPEdVKrnebtK5enQq+a48hdt9gez8QsuVjD2joeLykd7sLbYlnQ0iFY9EZ1/tVmUt9Sw9BQk6BF4UC7GAi05/TVzZRVrMs8DgfiGu9Fl4WCGVCLDvicQIa0RCgjSG9SuY/c3q15I2rVyRrValRjHFr4bTxnq31meF4krooQwmV8Yk+VKe7PaQ1+hOx4ymoM61oHeshhHm391UNDP0YSiSv5X+y2sI/cLvi22gzHez+hsnRwegsSl48733ejAhqCXJWnKv82kIjOIIEUkNpnkwXWZa9eqAI0xcji0es8/jdIEtRjLhJ9LDh0WkyuNC7L7v5XR9dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkAgEbpAA8tGUR55RfMkGih0NR2QW6KNlZx28IVUob0=;
 b=lfBJ3ZntSL4SwHoVvQ/MtS5n+TskvhZc/8afaCHr/HaIqZNXXbO54ipnUTgW+jaPn8zfMhaua37GVW4EQxp3u1m6/vgsHt4pck+pGPEgRj8tjWk7gYQxmoQxbEi9r8NbJrCyBxw5dvkR6HNQOQV1La37J9TWpMd55Uhebkb0WXlCZhLbbAT6+pSKQ6sOLe3fUgWdjw6XRF0kAtB1Z7vFOKfQZo1G+nwTA/U/d7qGT+WcR3xVsfhZbMO4wHfeU5q+UkgYq2NKEhoP8/RdsT7mvCEbS/htoKIp8Jf2ka+huduouvBNt1rwPBAgcizU9j55SLgUP2oYZObJV+r6p/69Zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BN6PR1101MB2322.namprd11.prod.outlook.com (2603:10b6:404:9b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 16:54:47 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d898:84ee:d6a:4eb1]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d898:84ee:d6a:4eb1%6]) with mapi id 15.20.5061.028; Tue, 15 Mar 2022
 16:54:47 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "vaibhav@linux.ibm.com"
	<vaibhav@linux.ibm.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "aneesh.kumar@linux.ibm.com"
	<aneesh.kumar@linux.ibm.com>, "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH] ndctl,daxctl,util/build: Reconcile 'iniparser'
 dependency
Thread-Topic: [ndctl PATCH] ndctl,daxctl,util/build: Reconcile 'iniparser'
 dependency
Thread-Index: AQHYOImF323nQFa540WokIGKKS28vKzAqauA
Date: Tue, 15 Mar 2022 16:54:47 +0000
Message-ID: <967a55fb5098e61abc697d00123f7aedc9ef7333.camel@intel.com>
References: <20220315162641.2778960-1-vaibhav@linux.ibm.com>
In-Reply-To: <20220315162641.2778960-1-vaibhav@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.4 (3.42.4-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef300810-2ea4-428d-91e6-08da06a48331
x-ms-traffictypediagnostic: BN6PR1101MB2322:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <BN6PR1101MB23220CDEF69055B0844E097EC7109@BN6PR1101MB2322.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m7YqcKsEMaq8dTf4XeM6YrIvf0uGhx0CK2ELNtjwkU8Vt0wIqUSyjq6n4ex6mRVTUmxyOXOKXaKRNcrKyOu91yze6JvD9DKvB9oBk346jxeU5NAzIwps+9bDneSj9zs9TcKJGC74Ftow/GocQFsk6OF4hbap7NNvVBOBezQBFlH2qWifOT12hbos3Y8T4bxhgT9/zMTuOunmEP17shm/5cYLwwQ6NDN/FnZuFXX5+IBG/gPQJgbqDj2Vsd3SaQyjFm2tL9y/NeopayPeTIP/P7Z4aaHuCX9DzMchNJSKmlDBJseFst9V6Sc7pxYeaMh7KOQIoimNh2cDhGYvErSaBvbxqfMWtLjpvUvHlkNeBnHGJp9ZXMYnRDVTXarg2hkncHy+gUp+eoEEKRcS/pIhbZ+9KS+kw3HcAH9Li3Z/6rovr+DrGxC1sBlSXLxCxaav5G03PGNJ+++j0MxhGWwpbC5u7E6cfpBS0kIpFrIG91pYhVQBzgcLIjSg2g1QVY3Q1GCtHcWPIkVbJn/GXpZTUYDX6unbYLpUcAzKR/Dtw13cAVog8SKpy5PLGecNgocYJvfB5gU3Pw6cXeZxglLS3tY1XM7Fnn4nEyu4FytiyZL6uekkttEt49ueX1++I4oFnm0DWr8bx+1Fuz/L3B1pM+AChUhRBP5ap3ppoe/TUE5eWnEWQXooFIhPkceRNBx3fdf/sfKI6B8zAY9a+Z8JGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(6486002)(186003)(26005)(5660300002)(36756003)(8936002)(71200400001)(508600001)(2616005)(38070700005)(91956017)(4326008)(86362001)(82960400001)(6506007)(122000001)(54906003)(110136005)(316002)(6512007)(64756008)(66446008)(66476007)(66556008)(66946007)(8676002)(76116006)(83380400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmd3Ly9COXpDNjYrdHI3NEVqTFdkcUo3Qkd6Qzl1cC85enVOSFJna3ZxYzFm?=
 =?utf-8?B?Nk5zeE5WSDhpb0dRWEh6UFFTODlUaHhHT3hubnVlQXN2T1MrM0pJelpyeEpV?=
 =?utf-8?B?cWxIQnZ3dFFrc3pibWhCK2d1bFg5YlJBWTZnZUNadHVFN0s3cUEvaHZ5WUxw?=
 =?utf-8?B?WVpKcFpPUXZrZVlRU0hrOUR2S2FLZWg2ZEpQRHRLVENBc1hLM0ZaZGp0OXpG?=
 =?utf-8?B?T3AxdGMvWnNrVVpVWEVCczZwdlZ4cGtRa1kwakgzSXZBNEhKdUFaY0lPL1ZU?=
 =?utf-8?B?aE55eFNmb3JxdTZudHMreU42VnhFTC80SjYvYlp2Z0pSaUJENmRWSzBNSXJ2?=
 =?utf-8?B?TlNETHpnSmtmNVFPL1VsSFlYT2d6emtuRjVueFhERElVRDVTWTJGd3V4ZGFV?=
 =?utf-8?B?VVVUaEF1T0tBSXFrelZ0aFE1dTdaaFV1dGNtSmtQeEZhQUhTMkpkRE1HdldN?=
 =?utf-8?B?Y2xwbURkbW5qU2pTNXkzV2RoR0lBNHVwZWUxandQbFBNK2ZPQkNYV2liRjVm?=
 =?utf-8?B?RGU5N09Pa2d5L0g2Zi9ySXE3dWNjMUM2ZnAxanAyUTJYTXdId0IzTWtiWm8r?=
 =?utf-8?B?ZVNuWXorM2pjaGg5bmVaRTByYUE3VHVUMEo2T2dBVjd2cmJVNmFBZzVLY1Q4?=
 =?utf-8?B?SWNvbGNFc3VYUzFib0JpRHJtd0N3YVh4b2ZqbkxFRk10Vml5UDZ6SHEvdytU?=
 =?utf-8?B?SExoaXQyQ3R0eEozbFNIVjl4Vm51SlNnWlRKYy9aY2s1M0tzQXF2OW9UVzVE?=
 =?utf-8?B?WTRFN3J4dzlZcVBLM1gzUTNXVDhLNnVWTzl4TkV1TlUranU4bm9sdmgzSFpj?=
 =?utf-8?B?SWtEZ0J5cG41UmplK1VvWUUxdEN1U0g1MXhneTVLTVBSZE5WNVJpcHJuM3Z1?=
 =?utf-8?B?YmM2ZlZCekJHQ3FPOThZUkFHMUp0cWROcmZGelVrR1NnaDB5dXdoNUNhV1Zy?=
 =?utf-8?B?aHlEN1d1T0ExVGpmTlJDK05zd0pSeU5jY002MGs4L0F6Y3BQd21OYVBaMUlr?=
 =?utf-8?B?dVU4eVMra0ZtOFRWalV3Wi9uNTZiT0x3bm81WWtWYmp1VFh1dHN1UjVCT1Rz?=
 =?utf-8?B?NzE3UUxCTjFFZmVzODhxNWN4V1VDNFM0ZG1HMXpnekhZN0tMUndPSWZqYk5O?=
 =?utf-8?B?R3FWRmtsejByelYwYTlGajMzVVQ4Y1ltQ1YzSUR0VlhicytaYml2MGZVUXFG?=
 =?utf-8?B?d21DeStmT3Y1ZmlibndyL0FnTzdseE9HNEc2bDVLdmFOWFVpd0x3bDgyNENl?=
 =?utf-8?B?UHU1TkhwMlVPK0tlRGhPeUg3c25mMVo2Z2FnTTg0c2VubGhDclpZRCtXaTl4?=
 =?utf-8?B?d0xnRUY5b25vNkRUM1BKSDQ5Nk1BeGxpaXo3M01uQnU2ZVZhSVo2R2dhSlZW?=
 =?utf-8?B?U3M3eEc3QTduYko5Y3pIWFI1TE83Qm4vZlhPMnRDazI3b1h4U0gyb09vcmNJ?=
 =?utf-8?B?UFp5YnF4RjZHd3VNc1d0YkRrQitHWWtwSEVCTEF1a0NCYmdTUlBqYVkrNk92?=
 =?utf-8?B?NzNOcWpHdS9vUUJTYkptaUNTajJKd29ldHJHeVQzMzlRVEVTYzc0UTZkL0Uy?=
 =?utf-8?B?azZ0ZDhoSnJHZXRBQi9KVmhoU0VQU1N1NEhkMFBNRlZTL2ZLeDR4dTNLMk8x?=
 =?utf-8?B?dzFHS20wdGJJOGRJeXhGeWI3Z0tTaXlMMHVoaWJkQ1VwY3NXWlB3bzUzdXJ6?=
 =?utf-8?B?N2p4YUl5QUFLcnVQcS8rcWl4QmxhK2FVTVZkQ0ZmNEc1K3U1K25ic1VLZ1pW?=
 =?utf-8?B?Z3llRTNrRS9ZaVh3dUlTRG1OcitMMDFkSVAyWi9ZZGhQZ0J1aHp4U1JFeXRS?=
 =?utf-8?B?WFRWREdXMXgwOUI3a2hWWjNPVlcxR216UGNRNk5xb0F0VGFOVHN6OW5tTWlv?=
 =?utf-8?B?Wi9JaG9zL2JrdmdDd0tLSWk1a2NsUzhHck9PS2JzSVArUGpYWGdMVzBpeDAx?=
 =?utf-8?B?cVVsSVRwYlFremVDejVEZkR1OEtmQm13UHJKR1A5L20xODZocU56aFZ2aGV2?=
 =?utf-8?B?OFczUXNvSDVRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58F13DAD2F6AC54BB8752C7C916BBC72@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef300810-2ea4-428d-91e6-08da06a48331
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2022 16:54:47.0563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rnpp2D68xgyDMKukZ2cyPBuTicYCsh34C7Ut3osZ9O3YRXFgzEas9ra3zhfzbJF8mu4VwrriKawBW4bPf1ralBQTtx6cmAQomrYtThC1O4o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2322
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIyLTAzLTE1IGF0IDIxOjU2ICswNTMwLCBWYWliaGF2IEphaW4gd3JvdGU6DQo+
IFRoaXMgdHJpdmlhbCBwYXRjaCB1cGRhdGVzICdtZXNvbi5idWlsZCcgZmlsZXMgZm9yIGRheGN0
bCwgbmRjdGwgdG8NCj4gcmVtb3ZlDQo+IGV4cGxpY2l0IGRlcGVuZGVuY3kgb24gJ2luaXBhcnNl
cicuIEluc3RlYWQgdXRpbC9tZXNvbi5idWlsZCBpcw0KPiB1cGRhdGVkIHRvIGFkZCBhDQo+IGRl
cGVuZGVuY3kgdG8gJ2luaXBhcnNlcicgd2hpY2ggdGhhbiBnZXQgdHJpY2tlZCB0byBkYXhjdGws
IG5kY3RsIHZpYQ0KDQpzL3RyaWNrZWQvdHJpY2tsZWQvDQoNCk90aGVyd2lzZSBsb29rcyBnb29k
IHRvIG1lLg0KDQo+ICd1dGlsX2RlcCcNCj4gZGVwZW5kZW5jeS4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IFZhaWJoYXYgSmFpbiA8dmFpYmhhdkBsaW51eC5pYm0uY29tPg0KPiAtLS0NCj4gwqBkYXhj
dGwvbWVzb24uYnVpbGQgfCAxIC0NCj4gwqBuZGN0bC9tZXNvbi5idWlsZMKgIHwgMSAtDQo+IMKg
dXRpbC9tZXNvbi5idWlsZMKgwqAgfCAxICsNCj4gwqAzIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RheGN0bC9tZXNvbi5i
dWlsZCBiL2RheGN0bC9tZXNvbi5idWlsZA0KPiBpbmRleCBlYzJlMmI2NDhkNDAuLjg0NzRkMDJm
MmMwZCAxMDA2NDQNCj4gLS0tIGEvZGF4Y3RsL21lc29uLmJ1aWxkDQo+ICsrKyBiL2RheGN0bC9t
ZXNvbi5idWlsZA0KPiBAQCAtMTUsNyArMTUsNiBAQCBkYXhjdGxfdG9vbCA9IGV4ZWN1dGFibGUo
J2RheGN0bCcsDQo+IMKgwqAgZGVwZW5kZW5jaWVzIDogWw0KPiDCoMKgwqDCoCBkYXhjdGxfZGVw
LA0KPiDCoMKgwqDCoCBuZGN0bF9kZXAsDQo+IC3CoMKgwqAgaW5pcGFyc2VyLA0KPiDCoMKgwqDC
oCB1dGlsX2RlcCwNCj4gwqDCoMKgwqAgdXVpZCwNCj4gwqDCoMKgwqAga21vZCwNCj4gZGlmZiAt
LWdpdCBhL25kY3RsL21lc29uLmJ1aWxkIGIvbmRjdGwvbWVzb24uYnVpbGQNCj4gaW5kZXggNmEz
ZDBlNTM0OGMyLi5jNzg4OWFmMzYwODQgMTAwNjQ0DQo+IC0tLSBhL25kY3RsL21lc29uLmJ1aWxk
DQo+ICsrKyBiL25kY3RsL21lc29uLmJ1aWxkDQo+IEBAIC0yNyw3ICsyNyw2IEBAIGRlcHMgPSBb
DQo+IMKgwqAgdXVpZCwNCj4gwqDCoCBrbW9kLA0KPiDCoMKgIGpzb24sDQo+IC3CoCBpbmlwYXJz
ZXIsDQo+IMKgwqAgdmVyc2lvbmRlcCwNCj4gwqBdDQo+IMKgDQo+IGRpZmYgLS1naXQgYS91dGls
L21lc29uLmJ1aWxkIGIvdXRpbC9tZXNvbi5idWlsZA0KPiBpbmRleCA3ODRiMjc5MTU2NDkuLjY5
NTAzN2E5MjRiOSAxMDA2NDQNCj4gLS0tIGEvdXRpbC9tZXNvbi5idWlsZA0KPiArKysgYi91dGls
L21lc29uLmJ1aWxkDQo+IEBAIC0xMSw2ICsxMSw3IEBAIHV0aWwgPSBzdGF0aWNfbGlicmFyeSgn
dXRpbCcsIFsNCj4gwqDCoCAnYWJzcGF0aC5jJywNCj4gwqDCoCAnaW9tZW0uYycsDQo+IMKgwqAg
XSwNCj4gK8KgIGRlcGVuZGVuY2llczogaW5pcGFyc2VyLA0KPiDCoMKgIGluY2x1ZGVfZGlyZWN0
b3JpZXMgOiByb290X2luYywNCj4gwqApDQo+IMKgdXRpbF9kZXAgPSBkZWNsYXJlX2RlcGVuZGVu
Y3kobGlua193aXRoIDogdXRpbCkNCj4gDQo+IGJhc2UtY29tbWl0OiBkZDU4ZDQzNDU4OTQzZDIw
ZmYwNjM4NTA2NzBiZjU0YTUyNDJjOWM1DQoNCg==
