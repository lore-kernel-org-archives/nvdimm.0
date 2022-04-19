Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBA6EA1
	for <nvdimm@lists.linux.dev>; Tue, 19 Apr 2022 05:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650344577; x=1681880577;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VEVZ5prAzOk5SeRRG6PamIfiQpDDDzLXQUhY9Sr+LxA=;
  b=btAG05T2qfqFCd8Sc3M3UaC1tPJz4PJ0qaj0IquKqB/bmLk730c+yb8x
   LB0JGUWY8gPXLvdqn4hiv7lw2vedom1TvRAFPiL/794uSkz/gwoqDgEIT
   e/+5JsjWE32/BMZwWT6nNCfh+QZ0nzBQYg6IfiTChgOysO9wUCxbLmxk2
   9MaAFGqvN/ggGHMhTE0nQ3rmNtScfzwItIB71rjrEoXwt8Y0D5VTyUtaL
   xirIAHVq3OWk/BmOjxjF+vrGAiDZ6tr5nwOVDzBretGlAs7C3A8ECgJ8j
   UXoaJ10gk1AGpj9jo9/H/URObdl6lCjQxZQ5MB0EqSkWITy7fG4JpE5aC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10321"; a="263137344"
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="263137344"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2022 22:02:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,271,1643702400"; 
   d="scan'208";a="665779963"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 18 Apr 2022 22:02:56 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Apr 2022 22:02:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 18 Apr 2022 22:02:56 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 18 Apr 2022 22:02:56 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 18 Apr 2022 22:02:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtMXChFirEW/4X6cDMXaG8P0E6vJeXT1BZfVgI55d7xY6gOj+LQoVyokF4g7jvyl18iU7N7NtTaDWzB/dqmPDLoYFJm9Voxld05m0Jc9FvX8n/0k+hnHAQpnsk7FSn2BcKgoeCAA+i3Hvr84g4Waup3tdYHMp4XqTK5lebBwwPEV8kbCIN7R6ZjNc4SvZDVwM6po+H8CiR7lOfFkjJm5BPVJIfQIYpO0Ol6BNVFy0psYSAOZb6Fb7KvINH/IlEgkOCKSDBC8U3pweIV21QkmgByPIUQQbZJXd6q8gLyluyNh02GLvxPhW4vtSVYio6KEHOVZz5yot/CSy33qUQnaBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VEVZ5prAzOk5SeRRG6PamIfiQpDDDzLXQUhY9Sr+LxA=;
 b=WfmkZP1iUafTnTjmeWcs/0WQ6iB8uVEXks+NjeOJSGLxO4zuy1Ba/ITKrOWS4zNrUQfJPM4ycsJEoFrghwqSxmPnc2bMnGAAYs11dm5u7X1+MmMYR+9BQoNxA5YEyePP+wRGGiKouIDyNqVi7Qkhu1o2zbKOoeX53NOwhPoVzX5sc/WwY1yDum3tLks+kFeBG5PzR/TsXogYLpi6jbJJJaLqIFK5ry6KDR0MT0QlIKZgP04oLTbYjEGsJdp/bgwSSbDU2Kt4//rSBh2ngK5+R5axxMVMmP8ytSiJzgDtFmSO6JWmea84h+lhxqyhLtuvAMFJTEU+lR0cxx9ZFy33eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3015.namprd11.prod.outlook.com (2603:10b6:a03:86::14)
 by MN2PR11MB4519.namprd11.prod.outlook.com (2603:10b6:208:26c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 05:02:54 +0000
Received: from BYAPR11MB3015.namprd11.prod.outlook.com
 ([fe80::992f:255:1b05:4244]) by BYAPR11MB3015.namprd11.prod.outlook.com
 ([fe80::992f:255:1b05:4244%7]) with mapi id 15.20.5164.026; Tue, 19 Apr 2022
 05:02:54 +0000
From: "Mao, Chunhong" <chunhong.mao@intel.com>
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: RE: [ndctl PATCH] daxctl: fix systemd escaping for
 90-daxctl-device.rules
Thread-Topic: [ndctl PATCH] daxctl: fix systemd escaping for
 90-daxctl-device.rules
Thread-Index: AQHYU1WouFMBR1pWjU29Id0bh1Kswaz2CpcAgAAJJgCAAJnpoA==
Date: Tue, 19 Apr 2022 05:02:54 +0000
Message-ID: <BYAPR11MB3015F5B348B0CB558B1D8FAB9CF29@BYAPR11MB3015.namprd11.prod.outlook.com>
References: <20220418185336.1192330-1-vishal.l.verma@intel.com>
	 <CAPcyv4h+r4Oq=y+B9H+E6AASbj8=V+NcdU+5S88-i-yfOUy8_g@mail.gmail.com>
 <ba4de425d48d36b9bb116e0ff0c30e9fc1b70d69.camel@intel.com>
In-Reply-To: <ba4de425d48d36b9bb116e0ff0c30e9fc1b70d69.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: acca3b25-543c-4248-6425-08da21c1dcb9
x-ms-traffictypediagnostic: MN2PR11MB4519:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB451906D69A9753C7B2A540319CF29@MN2PR11MB4519.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YTrQdIkeJdI3wILc587AtSYP3JH2HofoRdTV8aR3CuSMZsDRxTZ6sCoZDNZ5J9pThr8eX9mdCg+DWeFe/babAfwlndqjt7FCMzrh1PSsE7UsObDpXhLfpf/nxTo/p+5JK1eSs1GTg0MphNJxOxYGXAsBQ9vIZcWAhW9SNJKVzA6Rf0zsQPO5cx7wP1FirfNSnq0yGiyIhYEKcMAaUbTK7p6darMrlOnuSFMYUOG88cZovRBetc1fQbVJ8INSo+/Ou/2lf+kDMZq5Ly2nRLVXRxgXvSMa/Lvq7UYvnsKZ+EW/2B/ymh69ht6eLB4/q1EvvAdtBUrwG33I6FBS27QlD3no0BbAiN5eHVppjblwAstZBnTcnT/lBnidDXntTFDNIPu1sqXlHv+zeUda2cg/0/mmXKi5aQDp4hD+gVKh3q2kkWhpxw2ppqBTlYd5eta7BQFR1ArUtyyntMvHJWHXN56x6r4oOJKPO5lzDaH2V1AOcELp5Ah/W791gV9GTj5ZFji24O6Ws6k579WBDL6Qcp7nwXP2YknpFUL1diKgfTSVxNaoC+toWIYg3uwrTrlO+I9QP7EzauKZI23w/SgrfQHJV1Ll84ImDOoEzMY7EJm/fjl82QBsITRZVK1Jfkcbr2Yah2ZPjAzVfb8LxMtB8T0/d7sA6jsOYcL9rGj3Wn25uAP+gindlj3GccVTRWXZQbHB7fLkyix3QTNmux84/50fPowWYZPstXptVzG2wfLy2XVIL/fUZp0SHV1N4jnFWRi55YcWEiWG9g20upW0VOOL5Sy0hEPTV7rOtXMnPpM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3015.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(122000001)(9686003)(966005)(52536014)(33656002)(8936002)(186003)(26005)(83380400001)(5660300002)(316002)(2906002)(66476007)(66556008)(8676002)(66946007)(71200400001)(76116006)(66446008)(508600001)(64756008)(82960400001)(6636002)(55016003)(38100700002)(110136005)(6506007)(7696005)(38070700005)(86362001)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3ZHMW1oaVFOSHNwUjdmazVwQnhMS3BJTi93cG94dmZ1NHpQRVlmRXRHSit4?=
 =?utf-8?B?dDBrRjlWWVRTbzRmY2JHc2pBVDVJT3NENHB6RmdMRE4xMHRvZExKVXcvcUZB?=
 =?utf-8?B?NkI0YVBxY0xqdlBUY21RbG1PZFNra1oybm53a1paSkVORWg1cHFtaWN4MzNX?=
 =?utf-8?B?NmsyRno0ckh0cVA0MFp2aEJkWnBDTmIzN2w0R1ErUVQ1TVlIRUpwWkIwVG9L?=
 =?utf-8?B?YXRaazdVd3BCcFNUcjV2bHp4RFFPazVrMDRQSnAxejFVNWNSeFNmTjFmNHgx?=
 =?utf-8?B?OS9oOXRYT1ZvdnhXbDVlcTZTeHJObVYrYXEvdjdQT1RBZlNFMWhpQkE5Tno3?=
 =?utf-8?B?aWxyeGV6YklLNklNcHBFbEJkTGRISVo2WVpIdnkzT2tEYWJ4WnpTZ0ZDclNE?=
 =?utf-8?B?T21HNTZrN09nR3Vwd3hHOHVmemd2RWRRRnZCOXJ1dVFSZEd2VnpqV3ZxQnM0?=
 =?utf-8?B?cjhBc2hhdHhPZHpCdk1Hdnk4ck1ackN0ZndBS25SRlZpYk9qK016TW1iRWpN?=
 =?utf-8?B?bjRyeHpiZE9Zdy9tMTN0OGFUbUJZMTIyTUtwZGFDYm5mZldNL0d5cWZxSDVx?=
 =?utf-8?B?NisxQVFMcXcvWmVvM2huTGxnOUR3Y3RIeCtNR1RBL2xpMStRQlliUzlWTjk4?=
 =?utf-8?B?M0g5M1FrcS9CYUVUN0dKMjVhRXlHdkxSTGZITW1WanJPYW1UMldhc21abFFJ?=
 =?utf-8?B?Z1Y5VlowZllIT0lPa1p1TndGaUNHR1J1L2s5WkZHQk9Ra2pMeFNRY2g3MXA4?=
 =?utf-8?B?dHdkZEpLRFd5UUs1bXJkOVZVb1ZYOVlUaS9ydkE4cW1Xa1p5QmpPbXFsWStp?=
 =?utf-8?B?a2RMSzJLN29RVEwrZytSWHNNZ3VQSE1TcnlMUTU4NzFPbTAyWGFFM2xhcGVz?=
 =?utf-8?B?NUozby9JWitKaTJ5eThCaHFGTG1Oa0NyRk12Umx1WFpiMjlQZ0pFNWZMZWxD?=
 =?utf-8?B?R2hzaTlpakFPWStaSGZqaE9OejNaR3BwL3d0Q1dxUDNhQTdGZGZTb2VJVE93?=
 =?utf-8?B?ckFXQ0prQnJjeE92Z21lemRUc3hWcWpVeGNsTWRrak5JQkE5cVYzeVBxb1V2?=
 =?utf-8?B?QyswNVY3VnhndjE0VkZLRE1qYTdsOVZwSmpiNnpvaFBEWVJWTjNjRzluTk9t?=
 =?utf-8?B?a0FHZVhsTjV1RzdMbFhlYXdERG11R1ZIdU5RcnF5NW4xR0wxb3Z4RzZWaXhU?=
 =?utf-8?B?QTBVWUJFcmpDWUZqOEMxdThBQUxUYlNSMHRXcmFhNExzQzJWdlkxbmpIVUo2?=
 =?utf-8?B?SW1WSXEvQlFPbGhRMUQxbytTbmthQmFPYnBvakNtMnF3OXNna2FZbmtUaWJh?=
 =?utf-8?B?ZXVJQkVOZjVrMisyaGxTWWpadzJibDVDWjJJUXdjTWFKZStpOW90L1ZoNm1E?=
 =?utf-8?B?aWJ2amREUWNjWXptZnN3OGcrTWdqaERLU1djZGR3L09wa3Bkalp0RTNBbEdt?=
 =?utf-8?B?Y0d1dkFINlErQ2ZOd1BmdVNoOStBUzdrb2dZZXhkTE9qYVlLb1ltZlJNM1Qz?=
 =?utf-8?B?SDlSTWkweUlSRDdBaDl6eWcwUkVpSHFhZmZ4Q1pxRDZiQjFwWDQxNzNCbUhU?=
 =?utf-8?B?UmJLU3FpZzlhbHdpeFgyZE41VmQ0OGFhRGhoQzJpU0NMVTZRTWlpdlVGUnNi?=
 =?utf-8?B?SzBVZTkzUEhiZkFQVkpvRUN6RzFGanI2ZUxNSzZMWkpNc0ZHeDh1a1lLNGNH?=
 =?utf-8?B?NXZmeFRrV2oyMHZwMzNMbzFhalluODk5a2ZteldDVHN0RmFybVNocHJJanJy?=
 =?utf-8?B?bmtvTEhPa2JUcy93V0pKV1l5bHVWakZEeG5FcjNyKytUVEFXQm41bk8vTnNh?=
 =?utf-8?B?OHlrWUxSWHFVWVE1TnZmU3FDdzQ1NWxNbW1xWjBwUkt6VmQ5Z09RMGREOWxr?=
 =?utf-8?B?ZHB5RHlSMkMwMTBmU0dDZWRIcDlIK2FXbk1nOVJEWUwvZlV5ZFZVd25SWjF3?=
 =?utf-8?B?NlMrY0ZiUHkxZ3o3OFE2enVDSEc5ajBITHV1M3BsNU03WHE1MGF0VmVjOTFu?=
 =?utf-8?B?d0JSWlFnazVwclk0TnZnYm0xelZKeHlORVRCemNpRUhRRUtUa05LSVh1QjhX?=
 =?utf-8?B?WkM5WGdUVkh5MExPZklwcDFBMGlCNm9KdkJESzVhYkp0R0NmUVgxem1tTk5y?=
 =?utf-8?B?WWhuWWNNcTBrZmhHdW1HVjJvR2xMWTNrbjN3MUhNcm5wK09UaXA4RXhLdm5a?=
 =?utf-8?B?Z3dPaTVQOFlVVis4RzlLNnA0NjFLVGp6ZHppUEc1b2pvTy85WXJzRzM2QVls?=
 =?utf-8?B?bHprMEZyWHZvVlpzZDlTS1MvdG0zd3FUa0lUYWFncklDSHA3SExxSmE3Z1h2?=
 =?utf-8?B?TWUra0lVT3NFdDJyUEYycjlUYi9EdVRhVEMxdE05c29kTmxRQWxrdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3015.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acca3b25-543c-4248-6425-08da21c1dcb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 05:02:54.1107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /lpL+9jVUblLY0Vnow39WitiNMVpM16FfOnzWXqsaaVIV/YF+k5GLV4W9+2ngBsjH2PrGHjbWg/NNT2ld5n95A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4519
X-OriginatorOrg: intel.com

SGkgVmlzaGFsLA0KDQpKdXN0IHRvIGNvbmZpcm0gdGhhdCB0aGUgcGF0Y2ggaGFzIGJlZW4gVGVz
dGVkLWJ5OiBDaHVuaG9uZyBNYW8gPGNodW5ob25nLm1hb0BpbnRlbC5jb20+IG9uIG15IHN5c3Rl
bSB3aGVyZSB0aGUgcHJvYmxlbSB3YXMgcmVwb3J0ZWQgaW5pdGlhbGx5IGFuZCBpdCBkb2VzIGZp
eCB0aGUgcHJvYmxlbSwgcmVhbGx5IGFwcHJlY2lhdGUgeW91ciBoZWxwIQ0KDQpUaGFua3MsDQpD
aHVuaG9uZw0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogVmVybWEsIFZpc2hh
bCBMIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+IA0KU2VudDogTW9uZGF5LCBBcHJpbCAxOCwg
MjAyMiAxMjo0OCBQTQ0KVG86IFdpbGxpYW1zLCBEYW4gSiA8ZGFuLmoud2lsbGlhbXNAaW50ZWwu
Y29tPg0KQ2M6IG52ZGltbUBsaXN0cy5saW51eC5kZXY7IE1hbywgQ2h1bmhvbmcgPGNodW5ob25n
Lm1hb0BpbnRlbC5jb20+DQpTdWJqZWN0OiBSZTogW25kY3RsIFBBVENIXSBkYXhjdGw6IGZpeCBz
eXN0ZW1kIGVzY2FwaW5nIGZvciA5MC1kYXhjdGwtZGV2aWNlLnJ1bGVzDQoNCk9uIE1vbiwgMjAy
Mi0wNC0xOCBhdCAxMjoxNSAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOg0KPiBPbiBNb24sIEFw
ciAxOCwgMjAyMiBhdCAxMTo1NCBBTSBWaXNoYWwgVmVybWEgDQo+IDx2aXNoYWwubC52ZXJtYUBp
bnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9sZGVyIHN5c3RlbWQgd2FzIG1vcmUgdG9sZXJh
bnQgb2YgaG93IHVuaXQgbmFtZXMgYXJlIHBhc3NlZCBpbiBmb3IgDQo+ID4gaW5zdGFudGlhdGVk
IHNlcnZpY2VzIHZpYSBhIHVkZXYgcnVsZSwgYnV0IG9mIGxhdGUsIHN5c3RlbWQgZmxhZ3MgDQo+
ID4gdW5lc2NhcGVkIHVuaXQgbmFtZXMsIHdpdGggYW4gZXJyb3Igc3VjaCBhczoNCj4gPiANCj4g
PiDCoCBmZWRvcmEgc3lzdGVtZFsxXTogSW52YWxpZCB1bml0IG5hbWUgImRheGRldi0gDQo+ID4g
cmVjb25maWd1cmVAL2Rldi9kYXgwLjAuc2VydmljZSINCj4gPiDCoCBlc2NhcGVkIGFzICJkYXhk
ZXYtcmVjb25maWd1cmVALWRldi1kYXgwLjAuc2VydmljZSIgKG1heWJlIHlvdSANCj4gPiBzaG91
bGQgdXNlDQo+ID4gwqAgc3lzdGVtZC1lc2NhcGU/KS4NCj4gPiANCj4gDQo+IERvZXMgc3lzdGVt
ZC1lc2NhcGUgZXhpc3Qgb24gb2xkZXIgc3lzdGVtZCBkZXBsb3ltZW50cz8gSXMgc29tZSBuZXcg
DQo+IHN5c3RlbWQgdmVyc2lvbiBkZXRlY3Rpb24gb3IgJ3N5c3RlbWQtZXNjYXBlJyBkZXRlY3Rp
b24gbmVlZGVkIGluIHRoZSANCj4gYnVpbGQgY29uZmlndXJhdGlvbiB0byBzZWxlY3QgdGhlIGZv
cm1hdCBvZiA5MC1kYXhjdGwtZGV2aWNlLnJ1bGVzPw0KDQpHb29kIHBvaW50IC0gSSB0aGluayB3
ZSdyZSBva2F5LiBzeXN0ZW1kLWVzY2FwZSB3YXMgaW50cm9kdWNlZCBpbiB2MjE2IGJhY2sgaW4g
MjAxNCBbMV0sIGFuZCBmcm9tIGEgcXVpY2sgZ2xhbmNlIGF0IHJlcG9sb2d5LCBldmVuIHRoZSBv
bGRlc3QgZGlzdHJvcyBhcmUgYXQgbGVhc3Qgb24gdjIxOSBbMl0uDQoNClsxXTrCoGh0dHBzOi8v
Z2l0aHViLmNvbS9zeXN0ZW1kL3N5c3RlbWQvYmxvYi9tYWluL05FV1MjTDEwMzcwDQpbMl06IGh0
dHBzOi8vcmVwb2xvZ3kub3JnL3Byb2plY3Qvc3lzdGVtZC92ZXJzaW9ucw0KDQo+IA0KPiANCj4g
PiBVcGRhdGUgdGhlIHVkZXYgcnVsZSB0byBwYXNzIHRoZSAnREVWTkFNRScgZnJvbSBlbnYgdGhy
b3VnaCBhbiANCj4gPiBhcHByb3ByaWF0ZSBzeXN0ZW1kLWVzY2FwZSB0ZW1wbGF0ZSBzbyB0aGF0
IGl0IGdlbmVyYXRlcyB0aGUgDQo+ID4gY29ycmVjdGx5IGVzY2FwZWQgc3RyaW5nLg0KPiA+IA0K
PiA+IENjOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gPiBSZXBv
cnRlZC1ieTogQ2h1bmhvbmcgTWFvIDxjaHVuaG9uZy5tYW9AaW50ZWwuY29tPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KPiA+IC0t
LQ0KPiA+IMKgZGF4Y3RsLzkwLWRheGN0bC1kZXZpY2UucnVsZXMgfCA0ICsrKy0NCj4gPiDCoDEg
ZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBk
aWZmIC0tZ2l0IGEvZGF4Y3RsLzkwLWRheGN0bC1kZXZpY2UucnVsZXMgYi9kYXhjdGwvOTAtZGF4
Y3RsLSANCj4gPiBkZXZpY2UucnVsZXMgaW5kZXggZWUwNjcwZi4uZTAyZTdlYyAxMDA2NDQNCj4g
PiAtLS0gYS9kYXhjdGwvOTAtZGF4Y3RsLWRldmljZS5ydWxlcw0KPiA+ICsrKyBiL2RheGN0bC85
MC1kYXhjdGwtZGV2aWNlLnJ1bGVzDQo+ID4gQEAgLTEgKzEsMyBAQA0KPiA+IC1BQ1RJT049PSJh
ZGQiLCBTVUJTWVNURU09PSJkYXgiLCBUQUcrPSJzeXN0ZW1kIiwgDQo+ID4gRU5We1NZU1RFTURf
V0FOVFN9PSJkYXhkZXYtcmVjb25maWd1cmVAJGVudntERVZOQU1FfS5zZXJ2aWNlIg0KPiA+ICtB
Q1RJT049PSJhZGQiLCBTVUJTWVNURU09PSJkYXgiLCBUQUcrPSJzeXN0ZW1kIixcDQo+ID4gK8Kg
IFBST0dSQU09Ii91c3IvYmluL3N5c3RlbWQtZXNjYXBlIC1wIC0tdGVtcGxhdGU9ZGF4ZGV2LQ0K
PiA+IHJlY29uZmlndXJlQC5zZXJ2aWNlICRlbnZ7REVWTkFNRX0iLFwNCj4gPiArwqAgRU5We1NZ
U1RFTURfV0FOVFN9PSIlYyINCj4gPiANCj4gPiBiYXNlLWNvbW1pdDogOTcwMzFkYjkzMDA2NTQy
NjBiYzJhZmI0NWIzNjAwYWMwMWJlYWViYQ0KPiA+IC0tDQo+ID4gMi4zNS4xDQo+ID4gDQoNCg==
