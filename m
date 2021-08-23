Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F763FC0
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 19:41:37 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="204368519"
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="204368519"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2021 12:41:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,344,1620716400"; 
   d="scan'208";a="493134071"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga008.fm.intel.com with ESMTP; 23 Aug 2021 12:41:37 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 23 Aug 2021 12:41:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 23 Aug 2021 12:41:35 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 23 Aug 2021 12:41:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAoJzfNjGiOPrU8b0RqiOa7x62VOdyXBwCDxAebN7kdUcMoJg0wkMLEciS4x8vI4/Zs6xSztfbvsBgw7O7VfqkCvIZWJKBRaGh2iqNRePQHBOIRUe1fN0USfOC7WMj7lXmgHlEjq5tNa1vbjPdWhYf7HxN8oWkHLd6Yg3bFoQDMBbo9aXFGeuFpV2XCkmAYk8IWCMiDI6arFhtD5b5uaRUfpeQptsHXZEU16Uv+WC1g6DBvBnaiYRLjC1Ok53UpWzPXTu6nf9z6xd834W1VkwIXOtasXo4OG8aoJSWcLpMcFqsrcrirO40dpfMcYxaZ2WBnYZYGHPschQmgNvMym8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/T4AYVgfS3xElEtrLMsSsFoojF5E4Sm+LAIJLpjd73w=;
 b=GmFhBnXKzrriCSbrMOMuFKQlhu2GsQZmub/qckegyB8Xtnim7NjntNDsgeLE1ahgDcAXVD4TuSmBA6xwymg8K2yumW+dxxgYdtP2d449wVKChWcNLp5UqSFmWM7xWMZSP6OUXsk2ESRqTqX7+KVBF5q32FIv4g8uQPoBnQTLKglL3/CPvRSDQ1J8LS+m13LSfEvRE7F+vq9X5XgEGq5SMK0/zsI69AeKaEgt6XnO0Vd3or8vV4Pi6pA7MAKpydNwMSQo2RmHgA3dJafTpYBPmCGMXOJdLCJTvbeEAAWodVjXYOY17XCDug0Y8kbWbjRwFY2cWGelq126Sinh+oSBQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/T4AYVgfS3xElEtrLMsSsFoojF5E4Sm+LAIJLpjd73w=;
 b=mFJjjup4Wijp9lTricYprBJGvAOBeAOLa1ayAPX4OJXDZ7tGDFhT7/mGBvLYrII1MTfGyBhyfIkil+jvAQH2s0zCO/8lsvIfYhKzUpnZ0aIq2g8mxBSMHP2PAM3zfiaTf6zo9zt7LMMhQo6vcUr7X5dsgIQMdCA3hs+d5p+OcQM=
Received: from BYAPR11MB3448.namprd11.prod.outlook.com (2603:10b6:a03:76::21)
 by BYAPR11MB3111.namprd11.prod.outlook.com (2603:10b6:a03:90::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.23; Mon, 23 Aug
 2021 19:41:32 +0000
Received: from BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::1950:325f:ead2:db10]) by BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::1950:325f:ead2:db10%2]) with mapi id 15.20.4436.024; Mon, 23 Aug 2021
 19:41:32 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "fukuri.sai@gmail.com"
	<fukuri.sai@gmail.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "qi.fuli@fujitsu.com"
	<qi.fuli@fujitsu.com>
Subject: Re: [ndctl PATCH 1/5] ndctl, ccan: import ciniparser
Thread-Topic: [ndctl PATCH 1/5] ndctl, ccan: import ciniparser
Thread-Index: AQHXl5WRMyc78S5ilUqNDH0Giuo6fquBTj4AgAAwVYA=
Date: Mon, 23 Aug 2021 19:41:32 +0000
Message-ID: <4395bebebdfbdb17422bfc82368a33fb7048ee60.camel@intel.com>
References: <20210822203015.528438-1-qi.fuli@fujitsu.com>
	 <20210822203015.528438-2-qi.fuli@fujitsu.com>
	 <CAPcyv4imFbXW2_84QqmT+AmanXAtKXNQgKNEez3EX=o=XLiNjg@mail.gmail.com>
In-Reply-To: <CAPcyv4imFbXW2_84QqmT+AmanXAtKXNQgKNEez3EX=o=XLiNjg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.3 (3.40.3-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e04825c4-7880-448d-b14c-08d9666e0287
x-ms-traffictypediagnostic: BYAPR11MB3111:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB31119172A5A9726413115B4DC7C49@BYAPR11MB3111.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dXfXwRjHM7z5Nf/9HaiQeRGtTIEnaGpFbxd2sipbPFkRACA2bTLVJmzIv3UvNoQHwYfzyBwgUh/hscNdNkA7AOLxLBbEmpbPOWEbMlvc+66U8VmGgQNnKdQvRhk+CWmHWrsoyKV3qcTL1UigXFDIbllXXusAjARlY5/T38jBI+2jqlpvyQN6kcEaoG3ccg76kDIkgaoo8kf2oKsIxPoX0onx3Gc2umxFA3kpB3ZJcALVVAjY26kFZFv45/qksI6nkbcYB/yL6PtrnIyQF/YTUd8rbJ+JsVod5bdkTy5hkehRS4T4O/6nlufMKZWRQtoC3LWWUvEDz/dV0viYNFk2FVigphsHNDNVAqd6NHRqSEoWzSJBIf7fTnQvoAi0Ip8jH93jNz1cg/G4neYApndiolHrdqgJIFNI3L9JBkvihN9Q61Ym0V8nTiRG3iZSy29UwGl8bqI0m9IFWpTQ8GX4bIlv7ruzEtZMl2vJak+Pocc+pFAYhouk0SpxFc0hn7tZeZdbMCGv5ypdxgxIf/vrvkBP+nJVOBsS+bhWNuUQA8o5zie94Dub2VB3RonQUZD1WAH/tOXCooUhx42y0gS8wzb3Yyev3bqt1qBftd4iKmzT6mordxDwi0OBAVmcFsWkAMapB4HsaPeKFaeNnheFweHuueo1WNNprbE/inW8obSCV4Dwt9/KdC/fotvuoyjpjzEPgrMglLWIbgPjJ9z016v81+9nqURlkTkA1EjwahxVrYlMot93a0GyMJgxdZdC1PRDVrC8lv7uStMsohZ1ujidGYZN0tXHkCq/fFnC94Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3448.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(966005)(6506007)(508600001)(316002)(8676002)(5660300002)(2906002)(76116006)(186003)(66946007)(8936002)(64756008)(66446008)(71200400001)(83380400001)(26005)(38070700005)(6512007)(4326008)(2616005)(6486002)(110136005)(122000001)(86362001)(54906003)(66556008)(36756003)(38100700002)(4744005)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OE1ENEthQWp6SVE1SDlXdStjZjZTdUZzTkxxWnZQY1NCWHR1djN0cE5kZDRz?=
 =?utf-8?B?aDRDSzJHODgyQnBqcUZOYmNPNmpzeEs3NTFURGlmL0prNkNvazJkTGZjRFAw?=
 =?utf-8?B?RnBSWUw0UENEc3grUi9paXZMWm9aRU5ONVYwaGZZQlFKcS8rbVIzeUcxNDZn?=
 =?utf-8?B?TGRaKzF6di9MWGNBcmJEVHFETG04UkZrUXpjMTIzRHdnZnRHUEdLTnArMkxv?=
 =?utf-8?B?azA2TzdHZklCTE02RkhlaGt1MUx2UVVWL2hsUWVSVUsvZy9BS3ZSdk12QmIz?=
 =?utf-8?B?NkhJcVZNb0ZqSENpOTBEb0VTampYMVlNbmRUK3VoNUVDNStWN085d25URi95?=
 =?utf-8?B?Tm9zU2NiWGNnR0FGdnJ1elQvLzBXaU9LN3ArSkdwSDBrelNIMy9MOXNROG5w?=
 =?utf-8?B?YnBVdTByMU5hNHE1UWJwM1JWeEN2dXVoOEtFUytPaG9ncFFFSEZMblBTcTds?=
 =?utf-8?B?NWZkQVU3QlZCNmt2cVlpSW0zV3Z0Tng5WGFQZVBnN3MwRTQyY09HcE1ZQXZC?=
 =?utf-8?B?VS9kM0xFa2NsSHBBYk52TUtPOFhZV1VtVXhGTXpxcXBpdm80V3RsRHBtTjNC?=
 =?utf-8?B?Q3pnL2tPSVlTLzdaTE04bTZWZldmTU9xYmluSDJOZ0NTclNPSnpqZ0pLQlZN?=
 =?utf-8?B?QUtPTy9HTm8vbWhOc1B5UUZvY2JKOGhOSXBPazVHMi94K1crb1lRK1owU3FX?=
 =?utf-8?B?WXRjUTM0NEJ5M0R3aVdYb0NIRFFyRUVYQTQyM3VYSGQ4cDd0b3pmSk5uWkZU?=
 =?utf-8?B?S1BwRU5MR2htTWt5dUdlRnIyVmJ3T3J4SktUTFBlQ2k4dk0rdW1JSDhZRDFU?=
 =?utf-8?B?c29pZnhpZWF4YkJ5UXBhcjlBcEVCY1o2b0V2NWVuTG50dENMcmoxRTA5ZjBD?=
 =?utf-8?B?OU5lNnNJenRBSkllM0I4U01Id0xHeUlPd1lJZzd4SFc0L05SRUo0VHlyTi9P?=
 =?utf-8?B?UDBFSXUwRVROOFo3VWVZODY5SlJQUkp5d1NzcWdGdTU5Wlg2bDUxT3JSUE9i?=
 =?utf-8?B?Vm8ybUpRS0VVaHVybWpkRlAxakFoUWlOSVhxWk9FeEhuaS9WWUlxWkpZaGxT?=
 =?utf-8?B?S1FxTWpFZW1TVzNWWVh3ZHgycGZVVy9ETWxUTFV0L1lYSzFXNzV2YTR3YlBy?=
 =?utf-8?B?dk9iUTFpSFVyc0p4dUpOcnlHcW9Kd1N1cE5mY3IwOTkyL2dPaGZzMVFualJr?=
 =?utf-8?B?bTFuc011eHAxUlJ5RVV5Qms0Mk5HUHdjblpyMU5lMjAranh2Rmk0QnhVV0VL?=
 =?utf-8?B?TEZrZ1Nka3JqWkRPTUMvR2xJM2lKSmJ1V0V5dUUxalZpQU1NbjAwQVRidVZQ?=
 =?utf-8?B?c3A2Ry9ocm9NNzAycjE4TXZ4SEdyeU9aOGdrNEIxQytuTW5QVW94TW92d3lD?=
 =?utf-8?B?blRrbEFmb1BxdmE4TDRkYWI1clQzdU9SWEQ2TlVpZit4bDI3djNrMnJFa0gy?=
 =?utf-8?B?WkZHQ3FQS3lNcWI5RGZuY3VjVzF0STdhUDlRU3Jvb3RpS0J3b3dpRnRtU2Fl?=
 =?utf-8?B?c1Joa25tNU52Slk3MnVnNHpvTUtnL3pwY0VWZFljcHlWanlGcWZGMWQ3b1Fn?=
 =?utf-8?B?UTVJK2w5N2tKakdnaUFaNU5lSUJYQWNQNGoydWNPTDIrTG5PVDQyL3BRRmRm?=
 =?utf-8?B?SmJNNzlZamthSVA1K0xJcHAzdmFyU3ZGZEN4a2J6QVZhWHFLVFI1emRESVFh?=
 =?utf-8?B?ZjluRnpiUWhnbmViSTMxV0dNcVZxSFJGUnNtTUpBbWdPUXc2eStPeTFNcG5H?=
 =?utf-8?B?T2tpcmtpNXVCN010M1k2MlllT1pvVlAyRHV2V1h0TE11VEZ5bUsrQ0Y5WC9F?=
 =?utf-8?B?WFdKZHdZM1pDSlRGNWZDZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D824B89B822BE4C91FD73FB33B81CAF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3448.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e04825c4-7880-448d-b14c-08d9666e0287
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2021 19:41:32.3349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aJyw8FofQz2/5y/1YpgKrG5eEu/LavnKNwPlSamrwRqULt8kxxB7Ak8K1xmrmQKaUUOvY2n2PqmYUfJ2syjB8CMBikUf0gXouladIeHn/do=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3111
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIxLTA4LTIzIGF0IDA5OjQ4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFN1biwgQXVnIDIyLCAyMDIxIGF0IDE6MzYgUE0gUUkgRnVsaSA8ZnVrdXJpLnNhaUBnbWFp
bC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEltcG9ydCBjaW5pcGFyc2VyIGZyb20gY2NhblsxXS4N
Cj4gPiBbMV0gaHR0cHM6Ly9jY29kZWFyY2hpdmUubmV0L2luZm8vY2luaXBhcnNlci5odG1sDQo+
IA0KPiBIaSBRaSwNCj4gDQo+IFZpc2hhbCBwb2ludHMgb3V0IHRoYXQgYW4gdXBkYXRlZCB2ZXJz
aW9uIG9mIHRoaXMgY29kZSBpcyBub3cNCj4gYXZhaWxhYmxlIGFzIGEgcHJvcGVyIGxpYnJhcnkg
dGhhdCBzaGlwcyBpbiBkaXN0cmlidXRpb25zIGNhbGxlZA0KPiAiaW5pcGFyc2VyIi4NCj4gDQpI
ZXJlIGlzIHRoZSBsaW5rIHRvIHRoZSBwcm9qZWN0IC0gaXQgc2VlbXMgbGlrZSBpdCBpcyBtYWlu
dGFpbmVkIGJ5IHRoZQ0Kc2FtZSBwZXJzb24sIGp1c3Qgb3V0c2lkZSBvZiBjY2FuLCBhbmQgYXMg
YSBzdGFuZGFsb25lIHByb2plY3Q6DQoNCmh0dHBzOi8vZ2l0aHViLmNvbS9uZGV2aWxsYS9pbmlw
YXJzZXINCg==
