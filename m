Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4BB44C9B
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 21:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bo49Vir/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701208239; x=1732744239;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8nuXQ/Ix788RKasb/MLduyaVbOdSrSfxK8PnqTNLfks=;
  b=bo49Vir/twsjLIqWKSqsTWrqe4rN/yP1T+geUKck4Lkp2XMuY8G5L09R
   hrvXd8VwAB+kw8n9/+SQVTIzIJlF2iU5R0USqQN+ar7BvDysRiX+PUS2+
   a7ggF0csgIUj8E88rbPHAezR6Lq+el1eIUAEGVwkigOi898gRGJvBi9Up
   0d20XN2MhrqVbSQn61uCTqVBCWA8v9Z9khJ8tTv82+dQoQJU81MrMys0O
   ik+wW2LoSLmaQjIA+eRL5l3OaoqLqKgPQ+R3aUgss2ew6XpRnzHzcdmax
   IXrrM2w/9/woXV/9xOkj+1pvPhrv7EcMCOYyryZrCe6JJCdWvZeNyxNvT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="457369540"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="457369540"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 13:50:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10908"; a="772447778"
X-IronPort-AV: E=Sophos;i="6.04,234,1695711600"; 
   d="scan'208";a="772447778"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Nov 2023 13:50:37 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 28 Nov 2023 13:50:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 28 Nov 2023 13:50:37 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 28 Nov 2023 13:50:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oN+nUWBO+T5H6R6TFTaMHMB5tt8N+witRVuPwOWT/cFPXOO8LjFZ4Zp/WaKtyydoE+2DuGb2ULE7Wq2UTlnN2b3Ku24UbcVbFlGnBuEzs1nPQVeQrQcEks9E6jH1nBr5vUqMUfaxe7LPUOIYFLaf7eDAJLwNcukI7xfFwSGugh0Ps+JIraMx6L7K+idqE5KXAIadwjfrtSeprgmvxQycxV6+X07gCpV7D3Yuj8L7uVyczXxzRVh5qxJy+3uCchc9M0Fg26kOvzfItQqORiUzwJR6ijTmy2W1YtA2Dw9y22des0M9qoep3t1yk/S7/v3rhSAdK+6IeBYXxNveecbodQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nuXQ/Ix788RKasb/MLduyaVbOdSrSfxK8PnqTNLfks=;
 b=jKg8gtkVFN+Uy14Q7oPugq92Gg8gtxhVJOUEgAupzmPfARbPURJXLVEaNCYtRrcrcsoP3zAEEkvjAoBbemmhAL6jYsmm1W8G8T3w7Xy3EIfcP5BWH5EAKIzDiwGpamSWQnYEc0Yhweq21DHiPh77DlpZ71jbwDCdsS4VutlzKTrjBD512NI7jbfZu50MMqHp9DRjBpiaWz3KRAMKb5AY5hbRXp0gBNBnSFgBY9ITsyo/F67EDoW/8M3TJFynyFoXIKc5U/8nfT4sfGx1RAXweDgn50H7amNUQiKRGkCt5TwOByIDSDrMjQKSK4hrvp87017JkV3eGVk2ExjfPFz5gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by DM4PR11MB5993.namprd11.prod.outlook.com (2603:10b6:8:5c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 21:50:34 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694%7]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 21:50:34 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 1/3] cxl/test: add and use cxl_common_[start|stop]
 helpers
Thread-Topic: [ndctl PATCH 1/3] cxl/test: add and use cxl_common_[start|stop]
 helpers
Thread-Index: AQHaIbEF9MNTS/29TUyEhY3BY0K49LCQRnCA
Date: Tue, 28 Nov 2023 21:50:34 +0000
Message-ID: <7c8f06dd66501d5bef0f26af907d1389af8e18e9.camel@intel.com>
References: <cover.1701143039.git.alison.schofield@intel.com>
	 <d76c005105b7612dc47ccd19e102d462c0f4fc1b.1701143039.git.alison.schofield@intel.com>
In-Reply-To: <d76c005105b7612dc47ccd19e102d462c0f4fc1b.1701143039.git.alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|DM4PR11MB5993:EE_
x-ms-office365-filtering-correlation-id: b1d28678-21ed-4e77-5270-08dbf05c0ca5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s8rQg8d3OysuPCFpUDuJ1WYY6HZBFGgEieFzZ6vjwTV1HaRwoTOEp6fh/YO33AMr2bynf8ye6ZlEuhSoitmV3ym26CCRVCMT8fVlJ+JUVDKZrCWac/DbXq78SCiCUQ+ZLxC1kf40Urqx4BgWAi/peD2wWnjnzDenWLSbkIbIOYE+n+iO2t2HuJR9+iPB8lWo10YuV7QYIn4NEvMvyEPubm/RK8kZoXvu1INOUN9zGuxDN44nFnO/EaP0gO4Y65BRv5Q1HfGB4WTFZi/HyEtyekMRWZEMmNR4LXNr9s1z6pZ8WJcb6u76Sc/zuDCGMWlvbxIDN2T6sHzc1ioox1+W6M/n5yzJE4AfhkC/Ds6W0yzbMyYjZ+4yAaaEfoOpk4ApganrRUhj/Pq47ffAs0UEMo2Ky69CIuUOpQ/kPGGigxwgPNKWrLz1CiyMBhB7S27XsLe/XmHs9inYj0d17SRXmhYvy7fKIctdkewH9bk4R+UbCCT+4pcpuIlLXuieIOZqE1Qa0zggnEYMIn4DF8jx8IrLYwUCIa4x+Dk/gTQFW8bkT2onkYFamItOMfhroqniyZ7WL7WWbmkgWMpJYhiSnSVXhjE/HYLTfJeLx4mm89II6fB2sFfYkrDxURksfeut
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(376002)(396003)(39860400002)(366004)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(38100700002)(83380400001)(122000001)(8936002)(5660300002)(71200400001)(4326008)(82960400001)(6862004)(66476007)(6636002)(76116006)(316002)(64756008)(66556008)(8676002)(37006003)(54906003)(66946007)(66446008)(478600001)(6486002)(86362001)(41300700001)(2906002)(4001150100001)(6512007)(36756003)(38070700009)(6506007)(26005)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDU2WFVlbjZuS2xCUVcvZEdFYld3K0VsK1hlY0pwbEVpa3RWTVl6NG1zODN4?=
 =?utf-8?B?TFlyN0xXNk5aMHAxSSszQkZNNTNsMW40QTFzR3VNd1Zqc1k2QjZuNkQySysw?=
 =?utf-8?B?aFBhZjNvNmZZVGNNQ1dkcEVQUzZRaURvRDFCdVZTSkFUaGZOTUk5cWVBdit5?=
 =?utf-8?B?WlMwWFp0RHVQeC83OTBGc0UyVXljK0dWazRLaC9nbk53UU1pTW5qNW5SYmVF?=
 =?utf-8?B?R1RGRjAyc0szWU14NjNxQXhtRHlOQndoaWVGdnI1Y1R0QndvY1ltek1ySGs1?=
 =?utf-8?B?Q3JHRkpqd3BqNnozVXl5c0pLM1N5NzFyUkpVZjhNV1pqb3M1QkFVN0ZqRWVJ?=
 =?utf-8?B?ZVFzOURsdE9xaERjQXVtRlRYWnUyMkhDQjdRKzBpQTRmaVVBU1ZjWDZtazZ2?=
 =?utf-8?B?UERqeGZvYzhlZ3krdDF6MGJvKzYrcjV5UUlOdU1TMzVPRS9nbUVIUmozMHJJ?=
 =?utf-8?B?VWZGZjVtcUwwQ2d2ekZ2Q3Jhb3ZJbTBlWGd5MzFkUmlPQk4xV1hxVml1QkRP?=
 =?utf-8?B?MERLcGs1SnU1S1JEek8rTDRJYndveGlrK1VBZWJUM0dpQ0V2cG8raGFFWU1H?=
 =?utf-8?B?TC9XZmdseFl5Zi9kSU92eWJDNWljeG5rRWlTZmFCZ3RTRjhCNnpKSHg0L2tE?=
 =?utf-8?B?Y3BUbzhuYjUxMXR0TDNzRkVsaG1rbkpyVG5vbXdvbU1WaURVY252Q2UwMkxY?=
 =?utf-8?B?cVBKeWk5VGJiTGVnSE5rbmRyRmJUQ2hYSnB6N3AzcFlZSUdnYk1Pa2gxNkFZ?=
 =?utf-8?B?YzI5QVIveDhoVFN1cjBLY05wT1J4Sk8rYnZvZDhFcXM4MDE5OTFPNTFwSEY0?=
 =?utf-8?B?b0xHOU5abnZ0a2k3eW9tWk5MUzRmbU90YUc5UGtxQStJU3FPWm1JWkpPU0hU?=
 =?utf-8?B?ZHBzMnJNVEM3amZGWUZQdTNhTk9VeldhUjA1V09WcGdycTRLc3BsNkdDMzF5?=
 =?utf-8?B?LzZtTGM3azRJK0NZWk9tODNpZDBRVGc1ODlZeVZtU2E5QlJsSnZXS1NDSkc3?=
 =?utf-8?B?aTZ0KzdrbjFrQlpma3VkV1MzbnlOTSt4T3BYZThKNGxVSWk5Q0pKQXpqWU9a?=
 =?utf-8?B?SVlQeXdHcllPY3ZyMVlFb2hqMCtCNk5XVC91ck56eWppQW5TS3d0dllRVUJL?=
 =?utf-8?B?NnJQcmRsRnhGU3ZtNVZlem5DYzFYcHpJaVYvdDBka2R4c21PeUJIK2tMK2hk?=
 =?utf-8?B?LzVuS1JqcDdzalgwa1FNdTdqZ05jdnUwUVkvNVZybGlCckNaRHMxdmdIVnFx?=
 =?utf-8?B?QlJqUVBiUEdTREdwdW1MYm9QL1FjVGM4Y1dsME5yZkdEenVhZWZIL2R3NzFR?=
 =?utf-8?B?RmkvcHZLamMzS0dveXVtODJHMHpLNzV0ZWErcERJRW9FNVpaYldqVVpXc0lu?=
 =?utf-8?B?YklVYlpuVWJIOVhGdU5BSnhzdTdTTUxiS1pSM2lZRGZVQ0p6MGRuNmJCTytU?=
 =?utf-8?B?SGJiTENLNWxIZkM5cVU2blllRUlFdm9IUGh4RHRTdkhBbldZeG9YS25BRjh1?=
 =?utf-8?B?SVIrdVljVlRkRDNUdkE5OGlaaEtiVzBoU3lva3ZHUS82OTNPazV4M1dmWkNk?=
 =?utf-8?B?WDB4WVhMMnk0Z0g5QklLVFVIWEJSRVdpOU9hWUZEazY3amY1M3Fnc0twNHNp?=
 =?utf-8?B?Rm5XYkpWTmkyVDJtd01LLzFIbUpWT1h1b2ZHeWE3am5OOFN5cHpWV0NOb0VF?=
 =?utf-8?B?VFYyRS9MZUU1N2gvSVl5M2hrMnM3SHdGWmoyOTRxcWNDWUVkeVcwRUhpTldz?=
 =?utf-8?B?L1QyYkIyeElrbFp0N0J3L0FXRFRkVjNlTnlVZU5qRzVEWjRrZUw2amhyZnhE?=
 =?utf-8?B?a1VJcnJsSzdHbFYvcVJRdTdUYjlWQTlRRHQ1NXBpUkQ4MDFOY0Rmd0k3dFpY?=
 =?utf-8?B?Z0Z3UWNnTFBZSG5nc2dJR2tPSEVDVVQxeENpTEZGUkt2bHJiWHU5ckFwZjFU?=
 =?utf-8?B?MEFDL2RGc3IraC9vUDNVejJmd3djMmI0QXgzRXRaTVJFbGpxY0dPNzZTeGNF?=
 =?utf-8?B?MnFTb3d5bHBNTlpOUkViREdRNml4Qk5TK1VyMENURHk1UW5YNkJsRUlDSXdT?=
 =?utf-8?B?WkFZMUpZaUd0eTJqQ2E1YlJ6Nk05YnEyazJRVGNhWktjSDRCSWMzMVZuL1pX?=
 =?utf-8?B?eEQ0YklsZ2FDd2VPekNjSUxXbFhVanQrcWVmRlVVZGd0NWJhZ0JCdEhId0N4?=
 =?utf-8?B?Y0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B4CDF8D8509C5944AFBD454ADD8467F4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1d28678-21ed-4e77-5270-08dbf05c0ca5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 21:50:34.2753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m6NOWpWybCI68gWgy2wkdJ0l60igLxQ/bcVn1v+WbQ9+CDwduB/rDoRV2nSS9PBUR4Xuf8DUbvliQmootCXJPtTTdpkEYjtU1/j5pa+Obvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5993
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTExLTI3IGF0IDIwOjExIC0wODAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KPiBDWEwgdW5pdCB0ZXN0cyB1c2UgYSBtb3N0bHkgY29tbW9uIHNldCBv
ZiBjb21tYW5kcyB0byBzZXR1cCBhbmQgdGVhciBkb3duDQo+IHRoZWlyIHRlc3QgZW52aXJvbm1l
bnRzLiBTdGFuZGFyZGl6ZSBvbiBhIGNvbW1vbiBzZXQgYW5kIG1ha2UgYWxsIHVuaXQNCj4gdGVz
dHMgdGhhdCBydW4gYXMgcGFydCBvZiB0aGUgQ1hMIHN1aXRlIHVzZSB0aGUgaGVscGVycy4NCj4g
DQo+IFRoaXMgYXNzdXJlcyB0aGF0IGVhY2ggdGVzdCBpcyBmb2xsb3dpbmcgdGhlIGJlc3Qga25v
d24gcHJhY3RpY2Ugb2YNCj4gc2V0IHVwIGFuZCB0ZWFyIGRvd24sIGFuZCB0aGF0IGVhY2ggaXMg
dXNpbmcgdGhlIGV4aXN0aW5nIGNvbW1vbg0KPiBoZWxwZXIgLSBjaGVja19kbWVzZygpLiBJdCBh
bHNvIGFsbG93cyBmb3IgZXhwYW5zaW9uIG9mIHRoZSBjb21tb24NCj4gaGVscGVycyB3aXRob3V0
IHRoZSBuZWVkIHRvIHRvdWNoIGV2ZXJ5IHVuaXQgdGVzdC4NCj4gDQo+IE5vdGUgdGhhdCB0aGlz
IG1ha2VzIGFsbCB0ZXN0cyBoYXZlIHRoZSBzYW1lIGV4ZWN1dGlvbiBwcmVyZXF1aXNpdGVzLA0K
PiBzbyBhbGwgdGVzdHMgd2lsbCBza2lwIGlmIGEgcHJlcmVxdWlzaXRlIGZvciBhbnkgdGVzdCBp
cyBub3QgcHJlc2VudC4NCj4gQXQgdGhlIG1vbWVudCwgdGhlIGV4dHJhIHByZXJlcXMgYXJlIHNo
YTI1NnN1bSBhbmQgZGQsIGJvdGggdXNlZCBieQ0KPiBjeGwtdXBkYXRlLWZpcm13YXJlLnNoLiBU
aGUgYnJvYWQgcmVxdWlyZW1lbnQgaXMgYSBnb29kIHRoaW5nLCBpbiB0aGF0DQo+IGl0IGVuZm9y
Y2VzIGNvcnJlY3Qgc2V0dXAgYW5kIGNvbXBsZXRlIHJ1bnMgb2YgdGhlIGVudGlyZSBDWEwgc3Vp
dGUuDQo+IA0KPiBjeGwtc2VjdXJpdHkuc2ggd2FzIGV4Y2x1ZGVkIGZyb20gdGhpcyBtaWdyYXRp
b24gYXMgaXRzIHNldHVwIGhhcyBtb3JlDQo+IGluIGNvbW1vbiB3aXRoIHRoZSBuZml0X3Rlc3Qg
YW5kIGxlZ2FjeSBzZWN1cml0eSB0ZXN0IHRoYW4gd2l0aCB0aGUNCj4gb3RoZXIgQ1hMIHVuaXQg
dGVzdHMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbGlzb24gU2Nob2ZpZWxkIDxhbGlzb24uc2No
b2ZpZWxkQGludGVsLmNvbT4NCj4gLS0tDQo+IMKgdGVzdC9jb21tb27CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCB8IDIzICsrKysrKysrKysrKysrKysrKysrKysrDQo+IMKgdGVzdC9j
eGwtY3JlYXRlLXJlZ2lvbi5zaMKgwqAgfCAxNiArKy0tLS0tLS0tLS0tLS0tDQo+IMKgdGVzdC9j
eGwtZXZlbnRzLnNowqDCoMKgwqDCoMKgwqDCoMKgIHwgMTggKysrLS0tLS0tLS0tLS0tLS0tDQo+
IMKgdGVzdC9jeGwtbGFiZWxzLnNowqDCoMKgwqDCoMKgwqDCoMKgIHwgMTYgKystLS0tLS0tLS0t
LS0tLQ0KPiDCoHRlc3QvY3hsLXBvaXNvbi5zaMKgwqDCoMKgwqDCoMKgwqDCoCB8IDE3ICsrLS0t
LS0tLS0tLS0tLS0tDQo+IMKgdGVzdC9jeGwtcmVnaW9uLXN5c2ZzLnNowqDCoMKgIHwgMTYgKyst
LS0tLS0tLS0tLS0tLQ0KPiDCoHRlc3QvY3hsLXRvcG9sb2d5LnNowqDCoMKgwqDCoMKgwqAgfCAx
NiArKy0tLS0tLS0tLS0tLS0tDQo+IMKgdGVzdC9jeGwtdXBkYXRlLWZpcm13YXJlLnNoIHwgMTcg
KystLS0tLS0tLS0tLS0tLS0NCj4gwqB0ZXN0L2N4bC14b3ItcmVnaW9uLnNowqDCoMKgwqDCoCB8
IDE1ICsrLS0tLS0tLS0tLS0tLQ0KPiDCoDkgZmlsZXMgY2hhbmdlZCwgNDAgaW5zZXJ0aW9ucygr
KSwgMTE0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3Rlc3QvY29tbW9uIGIvdGVz
dC9jb21tb24NCj4gaW5kZXggZjEwMjNlZjIwZjdlLi43YTQ3MTE1OTM2MjQgMTAwNjQ0DQo+IC0t
LSBhL3Rlc3QvY29tbW9uDQo+ICsrKyBiL3Rlc3QvY29tbW9uDQo+IEBAIC0xNTAsMyArMTUwLDI2
IEBAIGNoZWNrX2RtZXNnKCkNCj4gwqDCoMKgwqDCoMKgwqDCoGdyZXAgLXEgIkNhbGwgVHJhY2Ui
IDw8PCAkbG9nICYmIGVyciAkMQ0KPiDCoMKgwqDCoMKgwqDCoMKgdHJ1ZQ0KPiDCoH0NCj4gKw0K
PiArIyBjeGxfY29tbW9uX3N0YXJ0DQo+ICsjICQxOiBvcHRpb25hbCBtb2R1bGUgcGFyYW1ldGVy
KHMpIGZvciBjeGwtdGVzdA0KPiArY3hsX2NvbW1vbl9zdGFydCgpDQo+ICt7DQo+ICvCoMKgwqDC
oMKgwqDCoHJjPTc3DQo+ICvCoMKgwqDCoMKgwqDCoHNldCAtZXgNCj4gK8KgwqDCoMKgwqDCoMKg
dHJhcCAnZXJyICRMSU5FTk8nIEVSUg0KPiArwqDCoMKgwqDCoMKgwqBjaGVja19wcmVyZXEgImpx
Ig0KPiArwqDCoMKgwqDCoMKgwqBjaGVja19wcmVyZXEgImRkIg0KPiArwqDCoMKgwqDCoMKgwqBj
aGVja19wcmVyZXEgInNoYTI1NnN1bSINCj4gK8KgwqDCoMKgwqDCoMKgbW9kcHJvYmUgLXIgY3hs
X3Rlc3QNCj4gK8KgwqDCoMKgwqDCoMKgbW9kcHJvYmUgY3hsX3Rlc3QgIiQxIg0KDQpUaGlzIHNo
b3VsZCB1c2UgIiRAIi4gJDEgd2lsbCBicmVhayBpZiBtdWx0aXBsZSBwYXJhbWV0ZXJzIG5lZWQg
dG8gYmUNCnBhc3NlZCAoY3VycmVudGx5IHdlIG9ubHkgZXZlciBwYXNzIG9uZSwgc28gaXQgaGFw
cGVucyB0byB3b3JrLCBidXQgaWYNCmEgc2Vjb25kIHBhcmFtIGV2ZXIgZ2V0cyBhZGRlZCB0aGlz
IHdpbGwgYmUgc3VycHJpc2luZykuDQoNClJlc3Qgb2YgdGhpcyBsb29rcyBnb29kLCB0aGFua3Mg
Zm9yIGRvaW5nIHRoaXMgY2xlYW51cCENCg0KDQoNCg==
