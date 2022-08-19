Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E177B
	for <nvdimm@lists.linux.dev>; Fri, 19 Aug 2022 06:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660890410; x=1692426410;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=AwaWwrK7H7aF/MFUrASk5rSx/o5s4lyyyOKE21O8yvA=;
  b=PG42WColAi+MrOj66l7Jnlv4S/RvMNUWUMefQgNnLR1mvf5mdLxVmpS/
   LkrK/reiIbmvvYzB8YnfpgKGVBn8GzD8+0krSVbRrdQj8ULGshu96Ujhn
   GRITAipMPdYcE2/pdcrZtUJPtPCNSiDF7qv4uMxif61gKwkaacD9OW8JE
   HC6sPgsF1fiS0x9BLHz7+Puk/KY8BQ7n3sYzcuPWCWSKGb0+i0wnvqmxN
   +MoPJcT3jNP6U1714e60bErFxiynm2ledIIHI5+gvXUlym5sJwSA6mmiM
   Z4sD8xvv6qyTTel8+lcZqZzWEdXaM40J5qU8np1B0eAlyjUSh5jF1Utga
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10443"; a="291703452"
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="291703452"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 23:26:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,247,1654585200"; 
   d="scan'208";a="734312256"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 18 Aug 2022 23:26:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 18 Aug 2022 23:26:49 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 18 Aug 2022 23:26:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 18 Aug 2022 23:26:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 18 Aug 2022 23:26:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RI36X8ZJ5JsunipYBiR7NYbGLMynjSwY+ot9rSv3wcU39DwvVAexq1fwdCPhapQ4FcjuUViQnSkh2zZe6w2KtRzJfKn0vyL7cUyFP/FOIWX6+aEVX3BJiccsLt4kOZ3aNRNBPa2PSf5z2f+vkEuX+kUMYSUPOyltCp0O7eMLHmCnD9YcPP4v2SSk6+5vgRNRtyi8QtTIbSHemYENPyUgP2hMbUxt+3enhESSBxsHfjfDiRNm0gq7jFBaSwbrisbTVgvW5Fu07vYdEOezCqAHu04GRr6Lep8Yxq/2R2DefzpGtlkFRP6553OydyL2/IpOVcGOtGWA9jfErO6sw3EaAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AwaWwrK7H7aF/MFUrASk5rSx/o5s4lyyyOKE21O8yvA=;
 b=VasUO0wysyAcYH6N05HhYrTIHWrCupVyfHTXLK5Ox/7xxM6CGBWdc1sTP9+bXy4fOlE8U9/srAgXb84is6SXyetKwrGFrr2LfcJEgC4YVCfqZhDrfqGwxg/SuLg5eWAtFNh71r1Lw0U/yhYZGcpbXsyVwrEt7KjMvBKrGk11m92i9BLOVtiD1OnsmiCTouIkc56MLW98JJDrGBvnGa3m4ALPIDB9ZniQ8S6fmPLUj3sC5A9F1pHmHIkFPoy2wOF90FxjWytp4hTt/hqNzzA8f0549zeSPFDnkL41Oi11O2qx3HClbABGngcAVoQHck3QrV2+THbaN+fA8pnL+Lsviw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BN6PR11MB1634.namprd11.prod.outlook.com (2603:10b6:405:c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Fri, 19 Aug
 2022 06:26:46 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1c88:c1bd:6295:cba4]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1c88:c1bd:6295:cba4%7]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 06:26:46 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"mcgrof@kernel.org" <mcgrof@kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH] meson.build: be specific for library path
Thread-Topic: [ndctl PATCH] meson.build: be specific for library path
Thread-Index: AQHYsqEkVzafZoy+xk+Ej/dDI6Dz5621xAyA
Date: Fri, 19 Aug 2022 06:26:46 +0000
Message-ID: <d6139a6017284995cf1132934d3b61a47804d88d.camel@intel.com>
References: <Yv2UeCIcA00lJC5j@bombadil.infradead.org>
In-Reply-To: <Yv2UeCIcA00lJC5j@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bfd7fdd7-f7b3-42e2-f661-08da81abcaa3
x-ms-traffictypediagnostic: BN6PR11MB1634:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y5stkVl0nTKzN1d4LbmaW8tyPMpcMexycVHLFN/0geezbuFYYLN9vD2i5nuc0h9KLwqQ8tftmnVNqIAvLDBjR7e/iE5XlNjhAHSnMps67+nQsAQD2eh/qUNmb04DoinOQIzdlGILiSCBhq33L4zYEejYP1iFKcfaJof+aEmAkCVChIIsLYXl4XZhZ1S0fKlFXSvTTz3BNpSQ6kso3eyQp7+v94GzaYVDG8lu+HMfFT+AD8m3Lfx83H7Z0zG0DmmEtRnpR8jfS28sFievcFh6f9VA5IJJF3m++PeV6tPNPlvXS7Awawchr1kH0y9BjygL5txYDVhJflKHLygAiq1AXjyFz3M4b9NH2PZrAVcHdsT1pbPBO9FLSerxLlkkij9S7jpIkGDa6M5/xTVFUNIy+RbAidG0Q2eMfL0TlM158KBTBfZr7uyxAPIa14Ji/oqIeXfBUiK3HXM1fh+kkRXfbek/Mxgpt/RYf35LaiEktoXotFH2SflRmFJ4gh3w8dZoopFphrufGv27XNeglCKiuHMX/hpXOxg4snEDwLpE9qN0l7fQM4c+FT4NbiHMCAy8sACKHA59xdS+QmnAsLnGrcjYMqcWLN+sR1VV6CYfaDKK71pQd9JaN1G7v7o6v2qUYsWTgZzWDR4SW7Hq4eXHg9ZjBiYk/oR0e1aKUQUa2lL+VhmMFc5ZN+uP/wEVbfJc3lh7t06yOFuGtCySLuZeWtVlfjg89QBkjlgZ+udlWWgBoNY0frnD5NYELSNK6fEjkEsMaxbR6tF/BrR9rysm9brMwIhyLja3NNSZvylId3azdjm5IgZCPnvL/fnhF9Ty
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(366004)(136003)(396003)(376002)(38100700002)(86362001)(66556008)(76116006)(64756008)(6486002)(122000001)(2906002)(66446008)(71200400001)(8936002)(66476007)(5660300002)(91956017)(38070700005)(110136005)(66946007)(82960400001)(8676002)(6506007)(36756003)(186003)(316002)(41300700001)(2616005)(26005)(478600001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aUFZQ3REYS81V1B3TE14VEdqUkFUdUhZQjNQYWtjK1E2bDBrSlhKQ1ZPaHE2?=
 =?utf-8?B?THAzYk5ad1dYUG5ObjI5cytmU0YydWI0UzlrNHJxTjY4MndsdFRqUTcwMzBp?=
 =?utf-8?B?SC9scHVvSjIwOVM0eU1SYWtpNFlMSTR1RU9TWmdJL0NhdzhmclRjVmRtZUVm?=
 =?utf-8?B?WUFRMFBTUTFTWWlmSUVwbVlCTEZqYnBZVlladTNDYkcrV2VzUDJwRG91cW1K?=
 =?utf-8?B?Q2c3OWNxOGRCYVg0MmdhbHpOS3dqaGVydlJHcnRkbTlzdVNYOU5pMVNNTVhS?=
 =?utf-8?B?VlpWWGRDN1g5bnpOaE95eWJmMWVmTzJWMVAwcG5Ib3RNOENYUys3dlN1dTY0?=
 =?utf-8?B?WlIxak1nV0crc2doWUtzNTJ4K1hlemt2YnlyNTM2T1Fpaldwa0NjT0V1MENT?=
 =?utf-8?B?cnZEMjU4d0dNS0hDcUVXb01ZNC9HRTB2V2FIa2I1OGQwWDR5UXV5bGZYbWhS?=
 =?utf-8?B?eVBiYzRObC9XRVBWNEJDcnhkRVFVL2h3eXJrWUxWS25ZRWVyWmxSTVcvbmlS?=
 =?utf-8?B?emFwb1pGdjNVN09BeWF3TGFLbHc1QXhRT3RTK0xDZHNmRUg5dDI3Mm1DblRl?=
 =?utf-8?B?UEo3c282SW9mS1lJVFZWQTEzaWhtQmR2Mi9CL1hjNWM4L1U5ZElMR01yakZ0?=
 =?utf-8?B?N0o4d1owY3FKSURZbXBFdWlRMksveE9MdFJ4VkRIVDNseG9MUmptZDZvSjRr?=
 =?utf-8?B?eDE2OWRBSGpsQjNMSE84MHdrNTBvQTI0a0FpcThPNnhZSHR1d2RFNWVib0ov?=
 =?utf-8?B?RWY1NjFaQUVSS2pHdGY0MlhPNlV1Q204SForQ1RqajJjSHg1OTMxbHM3VEw3?=
 =?utf-8?B?VWVLR0JVMUIxUnJZcWZ4dVdrK0hiS09weEpITlBRSHdlYUdPTDgxbitmV0dH?=
 =?utf-8?B?K3p3Mm1YZE1Jblk2VzBmbG5JUW4yS241dXNBT3pPOVlRcnlIMG9OSTJVRU5x?=
 =?utf-8?B?WnRoUWMrRXZqZ3JZc0NQK3pVVEY3TGNOaTREMzBIUlVRR3lrSGYyMGFDdlVu?=
 =?utf-8?B?dCtzVFpaYWNEL0VNLzBFOUlEQk4zQkdKSitDWUtZdnJpYlFOY1BxNTRmRzcx?=
 =?utf-8?B?UVV6STdQM2Vra3RqekdDUSttMlpKM0ZGdXcrbmdDb20wMGZ2bmxjQzY0T1E0?=
 =?utf-8?B?U2RxcGF1cEI2N2NpYU1MTXVhbUorK0Ivb2NKUUR2R00yM1VzYVloK2dOaHdi?=
 =?utf-8?B?Wmt5Z1E1SXJ1Y1M5djNOcVJWUi84TXN2Q2NrTEQyYS9yNFhZNjViY0w1YUow?=
 =?utf-8?B?bGk5REVkcTUyZEVrcGlrYTNENFNscmUrOGNtNnlkbGdyRjV0WWtmdzhPYnVF?=
 =?utf-8?B?TVZTWmRtak5jNHdoejFEeUFjY3lIdXl6cjdmL1l0SkIwTnNocUI1VUJkdVVm?=
 =?utf-8?B?QitVNWJrU3RHYUgvQUJtUzFkZGFxVGR3dGNJWUE2MVNLSm5sdWpKcjc3eU81?=
 =?utf-8?B?RlNPdWJWQkgremEycm5TWVU0YjM2bmc0WnR2S2UvRlFjRU9HRmtKZnJqR01l?=
 =?utf-8?B?YXkreFJZT3Y0ZldWY2NQUnNGY2lCNzdsbkNOOHZGSDVxSE5EL0FYbEtPdjNF?=
 =?utf-8?B?Vnh3WmU4WFZPTy9uMEZCc1ZJbCtUN29kc25CNzBPbW04cHZHUmJMeFhmTnpZ?=
 =?utf-8?B?M1JxWHhjQUgyeDAyaDJNcG9MSjdBcmJKdW1UZy91M1BlU0k4NFZDZ3pDZjdJ?=
 =?utf-8?B?TVdrdWZXcVU3VUV1V3dqL2lUTmNqNncvNHhndi85VGhVenJGeHIvU1NoeU9N?=
 =?utf-8?B?RWdFSmtVNzlaQWpTSlVsamh0ZE8rSjAvcmZ5eE1YOVFic2xPUVVabFY1ZS9G?=
 =?utf-8?B?dy9ESzQ3OUZHTEt2VENsOFZmYWlleUFKWGZ4WUs2cTNVUnFYQ2tIa1NnM0gr?=
 =?utf-8?B?Wi81YjUxR3lsVXhUem4rek9FOXJXVUt4QmloZHY0dVRkWEVFQVNIdWxvbytr?=
 =?utf-8?B?Zlk2ZEVIS2ZrMkV4NDhsd21CWmpYbDdVTjNDZWN2bUsrdXB1UzVTc3dYbkYz?=
 =?utf-8?B?OS9pbFFvS3dGVGNoNzhmSnBMWjBDU2txbDZUSVlreldXN3MvaG9UUyt1K2xy?=
 =?utf-8?B?c042eUNuVmpxeVJ1QUhFUnZlOEVDL2FuYy9jenlqRmcxQmhwcG1pMjhEQndI?=
 =?utf-8?B?RjNUYjlzdVdiTWFFNFpXSWY0TktIQ0dWdCtMd2ptV0ZEOE5rUGlYVkNkWWRS?=
 =?utf-8?B?d0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE8400AF1D739443B940D4A80FF31E7F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd7fdd7-f7b3-42e2-f661-08da81abcaa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 06:26:46.5011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EAfhLhIzBfBfcthwMVOorbATzGOUZYV0L+h3grJkjljlR3FZ8SyBGVhk/wCQ8JqbkGzlkuKaQS5w0hia3l0SNyhJ8Rp1chZ84nmzz03JDLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1634
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIyLTA4LTE3IGF0IDE4OjIzIC0wNzAwLCBMdWlzIENoYW1iZXJsYWluIHdyb3Rl
Og0KPiBJZiB5b3UgcnVuIHRoZSB0eXBpY2FsIGNvbmZpZ3VyZSBzY3JpcHQgb24gYSB0eXBpY2Fs
IGxpbnV4IHNvZnR3YXJlDQo+IHByb2plY3Qgc2F5IHdpdGggLi9jb25maWd1cmUgLS1wcmVmaXg9
L3Vzci8gdGhlbiB0aGUgbGliZGlyIGRlZmF1bHRzDQo+IHRvIC91c3IvbGliLyBob3dldmVyIHRo
aXMgaXMgbm90IHRydWUgd2l0aCBtZXNvbi4NCj4gDQo+IFdpdGggbWVzb24gdGhlIGN1cnJlbnQg
bGliZGlyIHBhdGggZm9sbG93cyB0aGUgb25lIHNldCBieSB0aGUgcHJlZml4LA0KPiBhbmQgc28g
d2l0aCB0aGUgY3VycmVudCBzZXR1cCB3aXRoIHByZWZpeCBmb3JjZWQgYnkgZGVmYXVsdCB0byAv
dXNyLw0KPiB3ZSBlbmQgdXAgd2l0aCBsaWJkaXIgc2V0IHRvIC91c3IvIGFzIHdlbGwgYW5kIHNv
IGxpYnJhcmllcyBidWlsdA0KPiBhbmQgaW5zdGFsbGVkIGFsc28gcGxhY2VkIGludG8gL3Vzci8g
YXMgd2VsbCwgbm90IC91c3IvbGliLyBhcyB3ZQ0KPiB3b3VsZCB0eXBpY2FsbHkgZXhwZWN0Lg0K
PiANCj4gU28geW91IGlmIHlvdSB1c2UgdG9kYXkncyBkZWZhdWx0cyB5b3UgZW5kIHVwIHdpdGgg
dGhlIGxpYnJhcmllcw0KPiBwbGFjZWQNCj4gaW50byAvdXNyLyBhbmQgdGhlbiBhIHNpbXBsZSBl
cnJvciBzdWNoIGFzOg0KPiANCj4gY3hsOiBlcnJvciB3aGlsZSBsb2FkaW5nIHNoYXJlZCBsaWJy
YXJpZXM6IGxpYmN4bC5zby4xOiBjYW5ub3Qgb3Blbg0KPiBzaGFyZWQgb2JqZWN0IGZpbGU6IE5v
IHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkNCj4gDQo+IEZvbGtzIG1heSBoYXZlIG92ZXJsb29rZWQg
dGhpcyBhcyB0aGVpciBvbGQgbGlicmFyeSBpcyBzdGlsbCB1c2FibGUuDQo+IA0KPiBGaXggdGhp
cyBieSBmb3JjaW5nIHRoZSBkZWZhdWx0IGxpYnJhcnkgcGF0aCB0byAvdXNyL2xpYiwgYW5kIHNv
DQo+IHJlcXVpcmluZyB1c2VycyB0byBzZXQgYm90aCBwcmVmaXggYW5kIGxpYmRpciBpZiB0aGV5
IHdhbnQgdG8NCj4gY3VzdG9taXplIGJvdGguDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBMdWlzIENo
YW1iZXJsYWluIDxtY2dyb2ZAa2VybmVsLm9yZz4NCj4gLS0tDQo+IMKgbWVzb24uYnVpbGQgfCAx
ICsNCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCg0KSGkgTHVpcywNCg0KVGhp
cyBzb3VuZHMgcmVhc29uYWJsZSwgYnV0IEkndmUgbm90IG9ic2VydmVkIHRoZSBiZWhhdmlvciB5
b3UNCmRlc2NyaWJlZCB1bmxlc3MgSSdtIG1pc3Npbmcgc29tZXRoaW5nIGluIG15IHF1aWNrIHRl
c3QuDQoNCkJvdGggYmVmb3JlIGFuZCBhZnRlciB0aGlzIHBhdGNoLCB0aGUgZGVmYXVsdCBwYXRo
IGZvciB0aGUgbGlicmFyeSBmb3INCm1lIHdhcyAvdXNyL2xpYjY0LiBUaGlzIGlzIG9uIEZlZG9y
YSAzNiB3aXRoIG1lc29uIDAuNjIuMi4NCg0KPiANCj4gZGlmZiAtLWdpdCBhL21lc29uLmJ1aWxk
IGIvbWVzb24uYnVpbGQNCj4gaW5kZXggYWVjZjQ2MS4uODAyYjM4YyAxMDA2NDQNCj4gLS0tIGEv
bWVzb24uYnVpbGQNCj4gKysrIGIvbWVzb24uYnVpbGQNCj4gQEAgLTksNiArOSw3IEBAIHByb2pl
Y3QoJ25kY3RsJywgJ2MnLA0KPiDCoMKgIGRlZmF1bHRfb3B0aW9ucyA6IFsNCj4gwqDCoMKgwqAg
J2Nfc3RkPWdudTk5JywNCj4gwqDCoMKgwqAgJ3ByZWZpeD0vdXNyJywNCj4gK8KgwqDCoCAnbGli
ZGlyPS91c3IvbGliJywNCj4gwqDCoMKgwqAgJ3N5c2NvbmZkaXI9L2V0YycsDQo+IMKgwqDCoMKg
ICdsb2NhbHN0YXRlZGlyPS92YXInLA0KPiDCoMKgIF0sDQoNCg==
