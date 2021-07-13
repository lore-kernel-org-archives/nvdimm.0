Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E0072
	for <nvdimm@lists.linux.dev>; Tue, 13 Jul 2021 21:14:59 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="189927879"
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="189927879"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2021 14:14:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="465217185"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 13 Jul 2021 14:14:57 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 14:14:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 13 Jul 2021 14:14:56 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 13 Jul 2021 14:14:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 13 Jul 2021 14:14:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXpEyphspHQBLzasB7UHtRU9NjlG+d/XB0Cja84fu46qd2S3ViRK10307EJZjR2B3p2nnrO6XbfZHHXBmc6ObkQq4yjFTdOR8+kRr9pkJj5bbqLiluyjsYbXjnzoNnkjERJ3RL9gS/xoCCLTcKBIAzpwzVPxNdN8AoQtdkKcQIgbXr/seTXbvqggkKO0jKhHQ8r4IwxhbHIntR+f0JF1Y6vGNHO34Z7fMbOehnEWiotj998m1/DjvHEKEvezzuv5iVhoufkx/WO6p35hsYcBO7MO+xluughRcN3ZHPXZ/xy2AjDIWQ7pCpe8wdlg+jnlWBtA95qBfT4hpavX0rGUYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mik64daBVIcvQO1L6iRnhoc69ZS9QfuzHG+MhTjYZyA=;
 b=et08chR5twnsCsCJNr6sEH49hDnJQBCA3OWZRY14szTGcdc2Us6Ux8DTMJIAfmk8c5Xo/jy3iz0mXwhDh6CgjHAOHyeIhzrKAcVas8rpDdzTDydEvHzxYKd8jOsZb9LeO1BW8H3aY99uwP2ZYEc360EGQg8ljVTtsO2SxhVB03rXrQwS83uuSI+CJftPzLFx/VuluO9ykMJ6BrdqhZaS/A7P1gwBa/UbacQUd9LEwMqkI4h/Wbk+2oZd0JFF/pnG1AwTnhYcPBAJ60HqNs6xg5jqz6LXmObr0KRaKNxfwcm6tqBv7HjV7aNoe0m2aP2giCqlDLKqi7MxLAjFU9MikQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mik64daBVIcvQO1L6iRnhoc69ZS9QfuzHG+MhTjYZyA=;
 b=FQ2kGRb4OI5oKWaq4LzNlngCSWX/LL6wVlnRp+B6cEz2tPsHvPWhGkFlfITlDEi6IAKLiy4DsAhjXQEB8aE30VXaDowYAg0v7S589KTnE6hqeuQxun9BybLZuCZrJ3BB8+LnNlehuI/clG7fRl426/wU9siB6r6n1L27ibU64HA=
Received: from BYAPR11MB3448.namprd11.prod.outlook.com (2603:10b6:a03:76::21)
 by SJ0PR11MB4928.namprd11.prod.outlook.com (2603:10b6:a03:2d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Tue, 13 Jul
 2021 21:14:54 +0000
Received: from BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::de7:9279:792c:4d75]) by BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::de7:9279:792c:4d75%3]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 21:14:53 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Widawsky, Ben" <ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "Schofield, Alison" <alison.schofield@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH v3 02/21] cxl: add a cxl utility and libcxl library
Thread-Topic: [ndctl PATCH v3 02/21] cxl: add a cxl utility and libcxl library
Thread-Index: AQHXbrUeppuvzIXEnkWJLVdj7Aqi5Ks7c+IAgAYG8QA=
Date: Tue, 13 Jul 2021 21:14:53 +0000
Message-ID: <16e7814b0d3f1345dd59a38ccb8dc2f93a069f88.camel@intel.com>
References: <20210701201005.3065299-1-vishal.l.verma@intel.com>
	 <20210701201005.3065299-3-vishal.l.verma@intel.com>
	 <CAPcyv4guuNXZSUK6s3vT8a0e9M69kGxpu14dbBXZOeJvyF2S6Q@mail.gmail.com>
In-Reply-To: <CAPcyv4guuNXZSUK6s3vT8a0e9M69kGxpu14dbBXZOeJvyF2S6Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.2 (3.40.2-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1762f406-f42e-4ff6-dd50-08d9464341db
x-ms-traffictypediagnostic: SJ0PR11MB4928:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB49285CB1323698F7FD5DB894C7149@SJ0PR11MB4928.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WqP+35FqPG7O2BLBfIhBYewl7ZGAtpdQSIcsva+0UDMV/O9nHDGsei17k5OxtAB/PPwLaPCAbkJs9dAsGo9XDGUSjkLRKjAkxxUjUVherJvNQXZMKH02poHfI85ziksuMG639+ylg0V0tMaXXOd1fxta+l+nLt1J4cCjGvJ65JGO6oGAqW+qEM6uYD+TlzUIkQGrjN2OpBM/Gd2tIh9nH/4/V3txG0mgZpYkqv3D7chPxrIyw/AazWkb6twAvaa9CO/5Wih4ko1QvVbo5F4ifO18RALrqyKhquO0zHRc+I7iJAqegCVsRkUAJnWox8sn7u/ZqnUQSfrLZZKAp+8rFIT9EeRCAH5zzgkpyi4VgvA9sWrXT57O4j7AK+foxJo+YNJR8PiATqn0JT3CBRqbHaCUZnSgIGitkabasdrwX7o/0liTSubKGPR7qMaGKaHGVB0t8VmgPhBmkJn4/K2WdhF5aXPhhukzhzu/0MS0JoyPQKX58eTWUnV30Wvg4ycrzmuY+pL+UQri+/5tI4a/dHpxzuV94f/k68uj9yhVlIDU0FQH3d5KVAm3hLGXoz15nDRG43+y6N+saEkWX+CvsxHmyffKfKCXUlQuMu7ItiK9uhIPiAEQ9zCGrLrQPj3jBA3iKctYVSszQq3CPGJAaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3448.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(376002)(39860400002)(346002)(6862004)(122000001)(2906002)(36756003)(54906003)(186003)(66946007)(38100700002)(66476007)(91956017)(83380400001)(478600001)(66556008)(66446008)(76116006)(5660300002)(64756008)(71200400001)(8936002)(6512007)(53546011)(316002)(26005)(37006003)(4326008)(6636002)(6506007)(6486002)(86362001)(8676002)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1ZDVjZBamtJVDIrR1pGS05wMng1Z3pWWC9RbU5PbUxaenh5QmtZWGNHNXBJ?=
 =?utf-8?B?RVN5dFByN3hPdnczajlBNDhWUkw2S1BWTTFqdXBuUVZFZ2JaWm1LTWIvVVRv?=
 =?utf-8?B?eEJ1OEJHLzR2ckUyLzlERGVWamhNNDM3SFpBampzR3VUWWFlWlFJdjFjaDVu?=
 =?utf-8?B?UW9lRWxSL0NnWE5aa3Y5QlpDMWlxMWdZUVIxWnE3UlMwSHRVM0E0TjcxNHRs?=
 =?utf-8?B?dHVRYncyT3JzLy9oUWZtd2VDSlBKVlBoVnJQcUtKL2FNUUR0RzZpL2FoNWU5?=
 =?utf-8?B?R2wrQmU1a2JoNkRkVUczSUlNZ0NKQ0dMQXdzcEhCOWVTcWxHeXJQMzBSNGRk?=
 =?utf-8?B?emZ2ZWhSVkxHcDhMenB1N281REZvUnU1QkkwTWtIRlhuMlVSbUJRajRGbW5x?=
 =?utf-8?B?L1RNdWlFNlBUcElOcWZiTjcrb0VDTUl5YnBZVnpuWDdzWlZKV0w3b2ljdmpZ?=
 =?utf-8?B?b1dnOGxKbGYwY0NTeEpNMzRPc3N6dmNYQ1A1OUw0VWVXcnNYMytTV0lleXVN?=
 =?utf-8?B?cFVEOU5CZ0ZkbDh6cmNYMU40MzR1cWhUNDlVTzlaNW5rL1UvSWpwZk5FTUIr?=
 =?utf-8?B?Q1hLY2lXSUNJaXlzOUxjbTZ1Vi9nT1A3Y3E4TjIyalZUdTZQUjAwaHE5Yjdl?=
 =?utf-8?B?clJ3akNxSUt1R3VzemppT0dhUlc4ZHNmZk5kK044Z3k2WXV0VFFTUnhEa09q?=
 =?utf-8?B?a0pybUFVdDRCcjlHQTFuOXJsRzNvSGRzRDM4NTNvVnVrVjM1cHB4L1YwRW1v?=
 =?utf-8?B?VmlVUHhSSjJBOXhaY1hQQjlGRkw5WG5vQ0NYNStEVHBnSjEvVG9mZUt1cXgz?=
 =?utf-8?B?WTgzTG1STzlJU0VWVmw4Nk04dHZ0c1JWOE9zc3RUbGxRTmhwclZrdkJlcTlv?=
 =?utf-8?B?MmhkWDN6d1djUWZBcVBjRkI5M0U3WEpJei9iYXQvTVRvY2QrY0RxWm13dGIx?=
 =?utf-8?B?bm1MOVJBa0gxaHRRWmFiQWR4SEZoR1JsZnc4WUVIczM4d2Z3dFZWVzVLVTRl?=
 =?utf-8?B?NDhHQ1RENWtjWFMzZjYrNTNDUHFDTTNnTDdhRE52U2puN05JU2kwSTMxOTRr?=
 =?utf-8?B?VzRsZnRBWWlRdTcwb3FEVUdVYnBkZEJyR1ZCeHBpYWJmd3pNc0ZVOHZJSERt?=
 =?utf-8?B?bFVKeEV0R1JGaVZuYTYvblFBdms2WURCUUV4dzlRSnRpQ0JheHA3TGhCc3Js?=
 =?utf-8?B?bzdXaldjOGpQWWpNemVVajJWQTNzc0pIcjAvL2ZXQVNsUFJMOEVibXBhaVBG?=
 =?utf-8?B?SGtyUFpTWVdZaVZUWDZaTVlTVEhMakdUNUF1Mm1yM0daY3luY1g5MmdoZSth?=
 =?utf-8?B?azJPYi9rR3RCOWo2NWFqU21WY2xBQk1CSlFSclF6aUp3T2tGa2RIaCtTL3Ba?=
 =?utf-8?B?dDNoV2NDU1c2ZnAxbmJDcm5uWmF6YnM4RHoxekE0SFFXSWFBZzZjb25oM0tL?=
 =?utf-8?B?MWpuS2dGNmJ3UkM3bi9ySEtiYkE2NWxSUDd4Z3d0WTI1cE1IeU9oY0FxTjB1?=
 =?utf-8?B?Ulh6azVYZ3RtNW5sU0NpN29KSW94T3JZTnNXMDFGYlE3dTd3Z1gwZ0FidW4x?=
 =?utf-8?B?YTZYR2hQN2QzYkUwclB3Sko1TEhIZENUZmFsVFhxWUtvNWFRT1lFMHpOY01n?=
 =?utf-8?B?enNpVkVFRmg4ck5sMkF1R0lCMTVKU016ZHFTY2FsSXJ1U1RkazFjVnBwUld1?=
 =?utf-8?B?TWhxRmFvSVl3ZGxLaVFWMHRUaGhMdVpvYWNHdzBRcWhzZGVIdExQM2hnS0Rw?=
 =?utf-8?Q?cZg08qnDO94Pf1sDaLsMHUvXL+ivRDAeUoLGWlP?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1964FEA670FB5C4F922688A23482CD41@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3448.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1762f406-f42e-4ff6-dd50-08d9464341db
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2021 21:14:53.0297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9qpOQJJUu0+BUz6nkyqpZ3wIIdnq/SniPUYLwPZj3tD9O9+Ih269moJ098JPrSxyI+XJPKEkZg/i58rgmp1q+ANc1KeHNkQTQdh6vFxAIp8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4928
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIxLTA3LTA5IGF0IDE4OjEyIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgSnVsIDEsIDIwMjEgYXQgMToxMCBQTSBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZl
cm1hQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gQ1hMIC0gb3IgQ29tcHV0ZSBlWHByZXNz
IExpbmsgLSBpcyBhIG5ldyBpbnRlcmNvbm5lY3QgdGhhdCBleHRlbmRzIFBDSWUNCj4gPiB0byBz
dXBwb3J0IGEgd2lkZSByYW5nZSBvZiBkZXZpY2VzLCBpbmNsdWRpbmcgY2FjaGUgY29oZXJlbnQg
bWVtb3J5DQo+ID4gZXhwYW5kZXJzLiBBcyBzdWNoLCB0aGVzZSBkZXZpY2VzIGNhbiBiZSBuZXcg
c291cmNlcyBvZiAncGVyc2lzdGVudA0KPiA+IG1lbW9yeScsIGFuZCB0aGUgJ25kY3RsJyB1bWJy
ZWxsYSBvZiB0b29scyBhbmQgbGlicmFyaWVzIG5lZWRzIHRvIGJlIGFibGUNCj4gPiB0byBpbnRl
cmFjdCB3aXRoIHRoZW0uDQo+ID4gDQo+ID4gQWRkIGEgbmV3IHV0aWxpdHkgYW5kIGxpYnJhcnkg
Zm9yIG1hbmFnaW5nIHRoZXNlIENYTCBtZW1vcnkgZGV2aWNlcy4gVGhpcw0KPiA+IGlzIGFuIGlu
aXRpYWwgYnJpbmctdXAgZm9yIGludGVyYWN0aW5nIHdpdGggQ1hMIGRldmljZXMsIGFuZCBvbmx5
IGluY2x1ZGVzDQo+ID4gYWRkaW5nIHRoZSB1dGlsaXR5IGFuZCBsaWJyYXJ5IGluZnJhc3RydWN0
dXJlLCBwYXJzaW5nIGRldmljZSBpbmZvcm1hdGlvbg0KPiA+IGZyb20gc3lzZnMgZm9yIENYTCBk
ZXZpY2VzLCBhbmQgcHJvdmlkaW5nIGEgJ2N4bC1saXN0JyBjb21tYW5kIHRvDQo+ID4gZGlzcGxh
eSB0aGlzIGluZm9ybWF0aW9uIGluIEpTT04gZm9ybWF0dGVkIG91dHB1dC4NCj4gPiANCj4gPiBD
YzogQmVuIFdpZGF3c2t5IDxiZW4ud2lkYXdza3lAaW50ZWwuY29tPg0KPiA+IENjOiBEYW4gV2ls
bGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBWaXNo
YWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCj4gDQo+IExvb2tzIGdvb2QsIGp1
c3QgYSBjb3VwbGUgbWlub3IgcXVpYmJsZXMgYmVsb3c6DQo+IA0KPiBSZXZpZXdlZC1ieTogRGFu
IFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQoNClRoYW5rcyBEYW4gLSBhZGRy
ZXNzZWQgYXMgYmVsb3cuDQoNCj4gDQo+ID4gLS0tDQo+ID4gIERvY3VtZW50YXRpb24vY3hsL2N4
bC1saXN0LnR4dCAgICAgICB8ICA2NCArKysrKw0KPiA+ICBEb2N1bWVudGF0aW9uL2N4bC9jeGwu
dHh0ICAgICAgICAgICAgfCAgMzQgKysrDQo+ID4gIERvY3VtZW50YXRpb24vY3hsL2h1bWFuLW9w
dGlvbi50eHQgICB8ICAgOCArDQo+ID4gIERvY3VtZW50YXRpb24vY3hsL3ZlcmJvc2Utb3B0aW9u
LnR4dCB8ICAgNSArDQo+ID4gIGNvbmZpZ3VyZS5hYyAgICAgICAgICAgICAgICAgICAgICAgICB8
ICAgMyArDQo+ID4gIE1ha2VmaWxlLmFtICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgOCAr
LQ0KPiA+ICBNYWtlZmlsZS5hbS5pbiAgICAgICAgICAgICAgICAgICAgICAgfCAgIDQgKw0KPiA+
ICBjeGwvbGliL3ByaXZhdGUuaCAgICAgICAgICAgICAgICAgICAgfCAgMjkgKysrDQo+ID4gIGN4
bC9saWIvbGliY3hsLmMgICAgICAgICAgICAgICAgICAgICB8IDM0NSArKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4gPiAgY3hsL2J1aWx0aW4uaCAgICAgICAgICAgICAgICAgICAgICAgIHwg
ICA4ICsNCj4gPiAgY3hsL2xpYmN4bC5oICAgICAgICAgICAgICAgICAgICAgICAgIHwgIDU1ICsr
KysrDQo+ID4gIHV0aWwvZmlsdGVyLmggICAgICAgICAgICAgICAgICAgICAgICB8ICAgMiArDQo+
ID4gIHV0aWwvanNvbi5oICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMyArDQo+ID4gIHV0
aWwvbWFpbi5oICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMyArDQo+ID4gIGN4bC9jeGwu
YyAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICA5NiArKysrKysrKw0KPiA+ICBjeGwvbGlz
dC5jICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAxMTMgKysrKysrKysrDQo+ID4gIHV0aWwv
ZmlsdGVyLmMgICAgICAgICAgICAgICAgICAgICAgICB8ICAyMCArKw0KPiA+ICB1dGlsL2pzb24u
YyAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgMjYgKysNCj4gPiAgLmNsYW5nLWZvcm1hdCAg
ICAgICAgICAgICAgICAgICAgICAgIHwgICAxICsNCj4gPiAgLmdpdGlnbm9yZSAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgICA0ICstDQo+ID4gIERvY3VtZW50YXRpb24vY3hsL01ha2VmaWxl
LmFtICAgICAgICB8ICA1OCArKysrKw0KPiA+ICBjeGwvTWFrZWZpbGUuYW0gICAgICAgICAgICAg
ICAgICAgICAgfCAgMjEgKysNCj4gPiAgY3hsL2xpYi9NYWtlZmlsZS5hbSAgICAgICAgICAgICAg
ICAgIHwgIDMyICsrKw0KPiA+ICBjeGwvbGliL2xpYmN4bC5wYy5pbiAgICAgICAgICAgICAgICAg
fCAgMTEgKw0KPiA+ICBjeGwvbGliL2xpYmN4bC5zeW0gICAgICAgICAgICAgICAgICAgfCAgMjkg
KysrDQo+ID4gIDI1IGZpbGVzIGNoYW5nZWQsIDk3OCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9u
cygtKQ0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9jeGwvY3hsLWxpc3Qu
dHh0DQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL2N4bC9jeGwudHh0DQo+
ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL2N4bC9odW1hbi1vcHRpb24udHh0
DQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL2N4bC92ZXJib3NlLW9wdGlv
bi50eHQNCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGN4bC9saWIvcHJpdmF0ZS5oDQo+ID4gIGNy
ZWF0ZSBtb2RlIDEwMDY0NCBjeGwvbGliL2xpYmN4bC5jDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0
NCBjeGwvYnVpbHRpbi5oDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBjeGwvbGliY3hsLmgNCj4g
PiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGN4bC9jeGwuYw0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQg
Y3hsL2xpc3QuYw0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9jeGwvTWFr
ZWZpbGUuYW0NCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGN4bC9NYWtlZmlsZS5hbQ0KPiA+ICBj
cmVhdGUgbW9kZSAxMDA2NDQgY3hsL2xpYi9NYWtlZmlsZS5hbQ0KPiA+ICBjcmVhdGUgbW9kZSAx
MDA2NDQgY3hsL2xpYi9saWJjeGwucGMuaW4NCj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGN4bC9s
aWIvbGliY3hsLnN5bQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2N4bC9j
eGwtbGlzdC50eHQgYi9Eb2N1bWVudGF0aW9uL2N4bC9jeGwtbGlzdC50eHQNCj4gPiBuZXcgZmls
ZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAuLjRlMmJlODcNCj4gPiAtLS0gL2Rldi9u
dWxsDQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9jeGwvY3hsLWxpc3QudHh0DQo+ID4gQEAgLTAs
MCArMSw2NCBAQA0KPiA+ICsvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiA+
ICsNCj4gPiArY3hsLWxpc3QoMSkNCj4gPiArPT09PT09PT09PT0NCj4gPiArDQo+ID4gK05BTUUN
Cj4gPiArLS0tLQ0KPiA+ICtjeGwtbGlzdCAtIExpc3QgQ1hMIGNhcGFibGUgbWVtb3J5IGRldmlj
ZXMsIGFuZCB0aGVpciBhdHRyaWJ1dGVzIGluIGpzb24uDQo+IA0KPiBUaGlzIHdpbGwgYWxzbyBz
aG93IENYTCBwb3J0IHRvcG9sb2d5IGluIHRoZSBmdXR1cmUuIEknbSBmaW5lIHRvIGZpeA0KPiB0
aGF0IHVwIGxhdGVyIHdoZW4gdGhhdCBzdXBwb3J0IGFycml2ZXMuDQoNClllcCBJIGFjdHVhbGx5
IHJlbW92ZWQgaXQgYmFzZWQgb24gZmVlZGJhY2sgZnJvbSBCZW4gc2F5aW5nIHdlIHNob3VsZA0K
YWRkIHRob3NlIHdoZW4gdGhlIGFjdHVhbCBzdXBwb3J0IGZvciB0aG9zZSBpcyBhZGRlZC4NCg0K
PiANCj4gPiArDQo+ID4gK1NZTk9QU0lTDQo+ID4gKy0tLS0tLS0tDQo+ID4gK1t2ZXJzZV0NCj4g
PiArJ2N4bCBsaXN0JyBbPG9wdGlvbnM+XQ0KPiA+ICsNCj4gPiArV2FsayB0aGUgQ1hMIGNhcGFi
bGUgZGV2aWNlIGhpZXJhcmNoeSBpbiB0aGUgc3lzdGVtIGFuZCBsaXN0IGFsbCBkZXZpY2UNCj4g
PiAraW5zdGFuY2VzIGFsb25nIHdpdGggc29tZSBvZiB0aGVpciBtYWpvciBhdHRyaWJ1dGVzLg0K
PiA+ICsNCj4gPiArT3B0aW9ucyBjYW4gYmUgc3BlY2lmaWVkIHRvIGxpbWl0IHRoZSBvdXRwdXQg
dG8gc3BlY2lmaWMgZGV2aWNlcy4NCj4gPiArQnkgZGVmYXVsdCwgJ2N4bCBsaXN0JyB3aXRoIG5v
IG9wdGlvbnMgaXMgZXF1aXZhbGVudCB0bzoNCj4gPiArW3ZlcnNlXQ0KPiA+ICtjeGwgbGlzdCAt
LWRldmljZXMNCj4gPiArDQo+ID4gK0VYQU1QTEUNCj4gPiArLS0tLS0tLQ0KPiA+ICstLS0tDQo+
ID4gKyMgY3hsIGxpc3QgLS1kZXZpY2VzDQo+IA0KPiBJcyB0aGlzIGZyb20gYW4gZWFybGllciB2
ZXJzaW9uLCBzaG91bGQgaXQgYmUgLS1tZW1kZXZzPw0KDQpZZXAgc3RhbGUsIGZpeGVkIGZvciB2
NC4NCg0KPiANCj4gPiArew0KPiA+ICsgICJtZW1kZXYiOiJtZW0wIiwNCj4gPiArICAicG1lbV9z
aXplIjoyNjg0MzU0NTYsDQo+ID4gKyAgInJhbV9zaXplIjowLA0KPiA+ICt9DQo+ID4gKy0tLS0N
Cj4gPiArDQo+ID4gK09QVElPTlMNCj4gPiArLS0tLS0tLQ0KPiA+ICstZDo6DQo+ID4gKy0tbWVt
ZGV2PTo6DQo+ID4gKyAgICAgICBTcGVjaWZ5IGEgY3hsIG1lbW9yeSBkZXZpY2UgbmFtZSB0byBm
aWx0ZXIgdGhlIGxpc3RpbmcuIEZvciBleGFtcGxlOg0KPiA+ICstLS0tDQo+ID4gKyMgY3hsIGxp
c3QgLS1tZW1kZXY9bWVtMA0KPiA+ICt7DQo+ID4gKyAgIm1lbWRldiI6Im1lbTAiLA0KPiA+ICsg
ICJwbWVtX3NpemUiOjI2ODQzNTQ1NiwNCj4gPiArICAicmFtX3NpemUiOjAsDQo+ID4gK30NCj4g
PiArLS0tLQ0KPiA+ICsNCj4gPiArLUQ6Og0KPiA+ICstLW1lbWRldnM6Og0KPiA+ICsgICAgICAg
SW5jbHVkZSBhbGwgQ1hMIG1lbW9yeSBkZXZpY2VzIGluIHRoZSBsaXN0aW5nDQo+ID4gKw0KPiA+
ICstaTo6DQo+ID4gKy0taWRsZTo6DQo+ID4gKyAgICAgICBJbmNsdWRlIGlkbGUgKG5vdCBlbmFi
bGVkIC8gemVyby1zaXplZCkgZGV2aWNlcyBpbiB0aGUgbGlzdGluZw0KPiA+ICsNCj4gPiAraW5j
bHVkZTo6aHVtYW4tb3B0aW9uLnR4dFtdDQo+ID4gKw0KPiA+ICtpbmNsdWRlOjp2ZXJib3NlLW9w
dGlvbi50eHRbXQ0KPiA+ICsNCj4gPiAraW5jbHVkZTo6Li4vY29weXJpZ2h0LnR4dFtdDQo+ID4g
Kw0KPiA+ICtTRUUgQUxTTw0KPiA+ICstLS0tLS0tLQ0KPiA+ICtsaW5rY3hsOm5kY3RsLWxpc3Rb
MV0NCj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9jeGwvY3hsLnR4dCBiL0RvY3VtZW50
YXRpb24vY3hsL2N4bC50eHQNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAw
MDAwMDAuLmU5OWU2MWINCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvRG9jdW1lbnRhdGlv
bi9jeGwvY3hsLnR4dA0KPiA+IEBAIC0wLDAgKzEsMzQgQEANCj4gPiArLy8gU1BEWC1MaWNlbnNl
LUlkZW50aWZpZXI6IEdQTC0yLjANCj4gPiArDQo+ID4gK2N4bCgxKQ0KPiA+ICs9PT09PT0NCj4g
PiArDQo+ID4gK05BTUUNCj4gPiArLS0tLQ0KPiA+ICtjeGwgLSBQcm92aWRlcyBlbnVtZXJhdGlv
biBhbmQgcHJvdmlzaW9uaW5nIGNvbW1hbmRzIGZvciBDWEwgZGV2aWNlcw0KPiANCj4gcy9kZXZp
Y2UvcGxhdGZvcm1zLyBzaW5jZSBpdCBzaG91bGQgZW51bWVyYXRlIGFuIGVudGlyZSB0b3BvbG9n
eS4NCg0KR29vZCBjYXRjaCwgZml4ZWQuDQoNCg==
