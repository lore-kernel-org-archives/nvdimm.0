Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62502C81
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 20:33:11 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="227680816"
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="227680816"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 13:33:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="564058000"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Oct 2021 13:33:10 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 13:33:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 13:33:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 13:33:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 13:33:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ddob9eUjCp2Z29giqakmg4hVpSSAY02pBfXHY0TTgerj0GeyJIXWpShWHIDqXj1DaVhO8uQo8zCCG5WtdQpoHlFdQKm7JohEqSdujnJOHe+1+b5mFth59b5yjreai+Z140JbDaw9X4dwedlB6H2N5JtTg2Ltm0dy9X/nY7NMVeMo8puVwsbS3DhtzmbxitJFQJgzWxog/I/RfY/sSg4WgxKeINdx7GHwtzKP/BeaotlofpwsphlwRggAkuoRJ9qAvDJgo6mHerNvXZ6UBizMn6LV3DWjywhBsCwQwNgWvLADWOfcpyPAIyqcVZrM/SBkYZ0WzTL5Sgn1THxXLjm5tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9IxVPD3yYJrYo4xwnlUq/y7Rp/cwPA5jVmw43xinp78=;
 b=VQ+FjbgM5np2C0hOindDOybCZmAb2QpSmeded6cVWi5tTMDS8Ryqyt6liOWvi1MoR1rYz8LS5lOGoMnw7T0z54VrZpoPBCYv77Q3dIWioyUaMKyWuT44uyTBZSxsl+lbD4i3gdVtmN9zdmVXp6m3vCuFsY32Gt1V1S2+dI7CReg/kN6fs42tMVNwfB/76fkCQcJCnVoWEyL+bDwWi0VeLJ38Baqy9LfStSPpUJhexXVt7eW2+k+YhDmmGEPvc73jYQh5xCmU2CKeIgyQtXoZpFS0tKqTcpl6zJ3/ipX/kTCAvpTVtguRoaP499pOse7ltAt/i9VsgKCnhBt+fKcJrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9IxVPD3yYJrYo4xwnlUq/y7Rp/cwPA5jVmw43xinp78=;
 b=JfDRJWVF6B5XyQ8P/DwDwRrap6pAMZtmJWQ4PXXcv2g+V0d6Gl/au7vamUnkCvGS+/iM5XFvGCEauYRUbgy9w8A04uELk99603UUgATuBGfla9DPp+zUAO77hYyUkzBJHNh1fEdG5w2EfAwKid2GbNh1hKwz8x/U3BXOxdjVjf8=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BL1PR11MB5302.namprd11.prod.outlook.com (2603:10b6:208:312::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Thu, 14 Oct
 2021 20:33:03 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 20:33:03 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Widawsky, Ben" <ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v4 09/17] util/hexdump: Add a util helper to print a
 buffer in hex
Thread-Topic: [ndctl PATCH v4 09/17] util/hexdump: Add a util helper to print
 a buffer in hex
Thread-Index: AQHXu1RoDaRcRksIkUWr7jA69EtRK6vSv+yAgAA+yQA=
Date: Thu, 14 Oct 2021 20:33:03 +0000
Message-ID: <39a3f49daff50d8065e95cf4cd5ef4268d3a1c18.camel@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
	 <20211007082139.3088615-10-vishal.l.verma@intel.com>
	 <CAPcyv4gRM_3UxQkKxLg_up-zNecyTjrvG1CAuJyF1Wd+9bwfUA@mail.gmail.com>
In-Reply-To: <CAPcyv4gRM_3UxQkKxLg_up-zNecyTjrvG1CAuJyF1Wd+9bwfUA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97c00794-0172-463f-9c63-08d98f51d295
x-ms-traffictypediagnostic: BL1PR11MB5302:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL1PR11MB5302E8B39F3E94D2D46EEF0FC7B89@BL1PR11MB5302.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YJWONeo0Yz/8t0+mQD21MlT1SbqlslWc5lw6cC/DjWGvJ/eaGrHAL+i//Ay5rfvZt+hht7G1XZs5MsnL1xrWTgXIv8ENF9TU/+1ZIBxjLMrILgW58Bc8YHp2LKXcGoaDbImNfs5T/WQm5uGfZinsQ1Feu+Huxu2XXdt6noabUF0PbjztJsmxBSfDcKFIsvi/9BNfoDQjD79+iNteiHOoy1ZX+MFWmc2vaSgDt3UNKBsJmGkOOvRM5Pb7nlFHEei6wC5QjIv1Vk0eprPgPOKUlKCRn9YPB3NNuMnPht/2NqBriEepIGdVKNfvQsoN4A1qpmW73HXDrXRQBNU4V69GXZxdS8W/hqvlPgpeT5Njc2w70we7iYNjEDiXLrbeR6/q5txzkzE6hlPlJljjj/eyC+nvsXS0RpDSqh8IkakgYlypZzNeqlp+ZhmOlSVKWo1EvD9Anp7pF0cSFvkvhAOTAt9nSgvYinXj8jSXrd57FFZssZeWYoDb75oYBnRlqA4WQIAG+/aIa0vyOBtD8xCsDOaW1fULakyuJl6XcJPNIjHr1tmfceECs4CxWMVyyTIaFtTaQiOG0zUw/pcg6LEo/wut4aaGD6LbMT4JyrIIIdSrp2GO1I8VlWtgiPPJwIgZO91veNIKkAy9xH/wx31w2FMnDqh81LmPUE88qxRU71NKoshblx9WzMY00OrAe+J2F4GyrcJq/4EIhasSEXhM2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(6862004)(6486002)(66556008)(66476007)(66946007)(66446008)(508600001)(5660300002)(38070700005)(64756008)(91956017)(6506007)(26005)(54906003)(71200400001)(36756003)(37006003)(86362001)(6512007)(53546011)(4326008)(6636002)(38100700002)(76116006)(8936002)(2906002)(2616005)(186003)(122000001)(316002)(4001150100001)(82960400001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWlpVStNZWZDSUlZckRZL0xnU09zcytFTlZaTVFIbjNvUkZNZm4yZjZYb0JE?=
 =?utf-8?B?WVR5clVnMkEzTVRNWUFCd3d5eWxHQVZ5Ky9YWEZxL0FVVjFCa0U4T3NOcko5?=
 =?utf-8?B?RFYwOHpHbFAzMmt1TWNZellKeUthcHEvanc5M0R3NDM4TFJqU1JrNHRnMnlV?=
 =?utf-8?B?amcxRjl5eGZNRFI5dHdHS3poa1VuLzRzSFZWRE5oTXEvck1kZkNCNWRnUW5W?=
 =?utf-8?B?L2lYbEJCZGd6QUg5bGRRYi85N2llQXhMcVU1ekNBY0taa1piV2NLeERMbWRE?=
 =?utf-8?B?MVY3MWE2RVZXSVp4UEhHTjluZkRNU1MvUDhjQ0lWci9ONjBvbk9GSjA3MVha?=
 =?utf-8?B?YW91SUlXdUJ2dnkzV3Z5UUhOaEN3UXdKVXYvVnFzcVQrTEtnWi9UL3ZUb3RF?=
 =?utf-8?B?N2tBL2QvSDUrRjdORndHRXplTCs5WmdVd2ZldkJlcS9Ta1ZKQjBRWkxXY2Mv?=
 =?utf-8?B?NlRBNFVRN0VsR1F6WlRhVTZqRG9OL2pXd1phS1ZLU01lb3UweDBka1ltMEIr?=
 =?utf-8?B?L0F3TGhSQ2NLanNKQ1Z2MFVGNHRKaG9mLy83dHFMQ2VscHY2bSsvV0FoUDFh?=
 =?utf-8?B?K1NobWY1MmIrb2lnOUM2TWxQOTBHMzB5dVhzQVlMdUU4dUl2Y08vd0ZTNFZO?=
 =?utf-8?B?aFlDUGFuU0pFdWxqbGxXK1BoSjQ5c3AvaSs1VjRIdGdxOGVxWlQ0dWZkbVdS?=
 =?utf-8?B?SDlxRmRpZ3RTUnp3Q2JHQWdQRlFuWDZuRzRIeUo2cnA4SFJXSHUvbmxhRURQ?=
 =?utf-8?B?ckduaytxZEV3azZYNVJpaUNSRnMyV1lsTlhmdlgrWHQ1ZTh4MEdCelJIb1Fw?=
 =?utf-8?B?RHBJWjBRakdSc3lxdWoyR1FWS0VQZEVUTHdDeVRMVE1ienNBci9XMVB3c3RS?=
 =?utf-8?B?d2dySGxhRkNUdm1hZ2lydzhPclJkNDdEdnhSa21KdFBGVE9hNHkvOFJpVEVY?=
 =?utf-8?B?bjF2d1ZZUlRwTHZyWXJMUWxmMVcvRWlaNS8wejJZaTh4RUVyclpuQ3JCSFln?=
 =?utf-8?B?czd0blJncE1OWTJFOWRmc1FKaUV1Ty93QURMK0xBV0lXT0c0dzZCSUc1cTJ0?=
 =?utf-8?B?MzRsRktBWXc4STVuMkdWUHo2ZG1CSzg3Q0hQWWcvem1HYzR4ZkZHbThNVHlX?=
 =?utf-8?B?bjlWbEhudlJUOEZTa1VDTWQxRkFLNGlGaTlEUFRlWXNXVlF6bGcrS2RtbHhl?=
 =?utf-8?B?VSttWlJTdG5JcHd6TVhsNkJsV3c3UlMvbG11cWdvbnliODlaUGh3MDZhSmdr?=
 =?utf-8?B?NUFVdkRhUkZuQUdlZUpGazUyM0VGWVdOL29ET3lkdloxMzI1ZVZlZDR3dVIv?=
 =?utf-8?B?ZGY1Q1hTVGRmUzJjNEdwcHc3bzU5Nnl5eWVaM3VONVowSGNZQmJqSmpuZXdq?=
 =?utf-8?B?K3o3UjI1N1hxaHZ3M1QxR3pDOEtUTHN5YVM1WFd2RUgzQUFYT25jK29kb3ZB?=
 =?utf-8?B?d0xGNE4xc3dHYmxIcCtsWGNFanpkZXFsNXE4RW5PWHI4Y1ZQVzZCRGQ2U01L?=
 =?utf-8?B?NmdmMUdkaFIzMDBOcnZxWWNyRk1RZzluY3Ntc0taQ1hwM2FWZENLTW9qZWF6?=
 =?utf-8?B?U3NtcjhTV0dQYVBSVlJTdWExaFpjSjVoN1dscXp2ZVhaOFd3NFROMjl3ek9C?=
 =?utf-8?B?TG80eDBMaFkxdWUwUXJWaHc3QkpxbStxSWtRQlMwNG5Iazh6M0tHb05zOVpq?=
 =?utf-8?B?VGR2dkM1YlljVkFUN05XWUlVY2liczhOcTVua01pdXhJTlp4WlllS1pLZXNt?=
 =?utf-8?B?ZURzTTVneXljdHI4ZlZhQi9oZm5XVFJWNWhzcmprckZ4OGJYR1hKdDBXT2lY?=
 =?utf-8?B?K0djcG5xMEFXU3Fwc2lxdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D96FC01BE7644B4291A82D5633ACD3D5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97c00794-0172-463f-9c63-08d98f51d295
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 20:33:03.6199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2bt+Tj/VZlGM9t3bltfbmpT97TyW6H95XzKB7GfQhyUs8jwrNg87c6HVzRFJHlatv7Br9wEwKMxbI5Pu/JwNfsMCAp/xVyR5dqm7NlxsXV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5302
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTEwLTE0IGF0IDA5OjQ4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgT2N0IDcsIDIwMjEgYXQgMToyMiBBTSBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZl
cm1hQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gSW4gcHJlcGFyYXRpb24gZm9yIHRlc3Rz
IHRoYXQgbWF5IG5lZWQgdG8gc2V0LCByZXRyaWV2ZSwgYW5kIGRpc3BsYXkNCj4gPiBvcGFxdWUg
ZGF0YSwgYWRkIGEgaGV4ZHVtcCBmdW5jdGlvbiBpbiB1dGlsLw0KPiA+IA0KPiA+IENjOiBCZW4g
V2lkYXdza3kgPGJlbi53aWRhd3NreUBpbnRlbC5jb20+DQo+ID4gQ2M6IERhbiBXaWxsaWFtcyA8
ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJt
YSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICB1dGlsL2hleGR1bXAu
aCB8ICA4ICsrKysrKysrDQo+ID4gIHV0aWwvaGV4ZHVtcC5jIHwgNTMgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gDQo+IElmIHRoaXMgaXMganVz
dCBmb3IgdGVzdHMgc2hvdWxkbid0IGl0IGdvIGluIHRlc3RzLyB3aXRoIHRoZSBvdGhlcg0KPiBj
b21tb24gdGVzdCBoZWxwZXJzPyBJZiBpdCBzdGF5cyBpbiB1dGlsLyBJIHdvdWxkIGtpbmQgb2Yg
ZXhwZWN0IGl0IHRvDQo+IHVzZSB0aGUgbG9nIGluZnJhc3RydWN0dXJlLCBubz8NCg0KQWdyZWVk
IG9uIHVzaW5nIHRoZSBsb2cgaW5mcmEuIEkgd2FzIG9yaWdpbmFsbHkgdXNpbmcgaXQgaW4gdGhl
IG9sZA0KdGVzdCBzdHVmZiwgYnV0IHJpZ2h0IG5vdyB0aGVyZSdzIG5vIHVzZXIgZm9yIGl0Li4g
SG93ZXZlciBoYXZpbmcNCnNvbWV0aGluZyBsaWtlIHRoaXMgd2FzIG5pY2Ugd2hlbiBkZXZlbG9w
aW5nIHRoZSBlYXJseSBjbWQgc3VibWlzc2lvbg0Kc3R1ZmYuIERvIHlvdSB0aGluayBpdCB3b3Vs
ZCBiZSBnb29kIHRvIGFsd2F5cyBkbyBhIGhleGR1bXAgd2l0aCBkYmcoKQ0Kd2hlbiB1bmRlciAt
LXZlcmJvc2UgZm9yIGV2ZXJ0IGN4bF9jbWRfc3VibWl0PyAoYW5kIG1heWJlIGV2ZW4gYWRkIGl0
DQpmb3IgbmRjdGxfY21kX3N1Ym1pdCBsYXRlciB0b28pIE9yIGlzIHRoYXQgdG9vIG5vaXN5Pw0K
DQpJZiB3ZSB3YW50IHRvIGRvIHRoYXQgdGhlbiBpdCBtYWtlcyBzZW5zZSB0byByZWRvIHdpdGgg
dGhlIGxvZ2dpbmcgYXBpLA0KZWxzZSBtYXliZSBqc3V0IGRyb3AgdGhpcyB1bnRpbCB3ZSBoYXZl
IGEgcmVhbCBpbi10cmVlIHVzZXI/DQoNCj4gDQo+IE90aGVyIHRoYW4gdGhhdCBsb29rcyBvayB0
byBtZToNCj4gDQo+IFJldmlld2VkLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGlu
dGVsLmNvbT4NCj4gDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgNjEgaW5zZXJ0aW9ucygrKQ0KPiA+
ICBjcmVhdGUgbW9kZSAxMDA2NDQgdXRpbC9oZXhkdW1wLmgNCj4gPiAgY3JlYXRlIG1vZGUgMTAw
NjQ0IHV0aWwvaGV4ZHVtcC5jDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL3V0aWwvaGV4ZHVtcC5o
IGIvdXRpbC9oZXhkdW1wLmgNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAw
MDAwMDAuLmQzMjJiNmENCj4gPiAtLS0gL2Rldi9udWxsDQo+ID4gKysrIGIvdXRpbC9oZXhkdW1w
LmgNCj4gPiBAQCAtMCwwICsxLDggQEANCj4gPiArLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6
IEdQTC0yLjAgKi8NCj4gPiArLyogQ29weXJpZ2h0IChDKSAyMDIxIEludGVsIENvcnBvcmF0aW9u
LiBBbGwgcmlnaHRzIHJlc2VydmVkLiAqLw0KPiA+ICsjaWZuZGVmIF9VVElMX0hFWERVTVBfSF8N
Cj4gPiArI2RlZmluZSBfVVRJTF9IRVhEVU1QX0hfDQo+ID4gKw0KPiA+ICt2b2lkIGhleF9kdW1w
X2J1Zih1bnNpZ25lZCBjaGFyICpidWYsIGludCBzaXplKTsNCj4gPiArDQo+ID4gKyNlbmRpZiAv
KiBfVVRJTF9IRVhEVU1QX0hfKi8NCj4gPiBkaWZmIC0tZ2l0IGEvdXRpbC9oZXhkdW1wLmMgYi91
dGlsL2hleGR1bXAuYw0KPiA+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+ID4gaW5kZXggMDAwMDAw
MC4uMWFiMDExOA0KPiA+IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi91dGlsL2hleGR1bXAuYw0K
PiA+IEBAIC0wLDAgKzEsNTMgQEANCj4gPiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQ
TC0yLjANCj4gPiArLyogQ29weXJpZ2h0IChDKSAyMDE1LTIwMjEgSW50ZWwgQ29ycG9yYXRpb24u
IEFsbCByaWdodHMgcmVzZXJ2ZWQuICovDQo+ID4gKyNpbmNsdWRlIDxzdGRpby5oPg0KPiA+ICsj
aW5jbHVkZSA8dXRpbC9oZXhkdW1wLmg+DQo+ID4gKw0KPiA+ICtzdGF0aWMgdm9pZCBwcmludF9z
ZXBhcmF0b3IoaW50IGxlbikNCj4gPiArew0KPiA+ICsgICAgICAgaW50IGk7DQo+ID4gKw0KPiA+
ICsgICAgICAgZm9yIChpID0gMDsgaSA8IGxlbjsgaSsrKQ0KPiA+ICsgICAgICAgICAgICAgICBm
cHJpbnRmKHN0ZGVyciwgIi0iKTsNCj4gPiArICAgICAgIGZwcmludGYoc3RkZXJyLCAiXG4iKTsN
Cj4gPiArfQ0KPiA+ICsNCj4gPiArdm9pZCBoZXhfZHVtcF9idWYodW5zaWduZWQgY2hhciAqYnVm
LCBpbnQgc2l6ZSkNCj4gPiArew0KPiA+ICsgICAgICAgaW50IGk7DQo+ID4gKyAgICAgICBjb25z
dCBpbnQgZ3JwID0gNDsgIC8qIE51bWJlciBvZiBieXRlcyBpbiBhIGdyb3VwICovDQo+ID4gKyAg
ICAgICBjb25zdCBpbnQgd2lkID0gMTY7IC8qIEJ5dGVzIHBlciBsaW5lLiBTaG91bGQgYmUgYSBt
dWx0aXBsZSBvZiBncnAgKi8NCj4gPiArICAgICAgIGNoYXIgYXNjaWlbd2lkICsgMV07DQo+ID4g
Kw0KPiA+ICsgICAgICAgLyogR2VuZXJhdGUgaGVhZGVyICovDQo+ID4gKyAgICAgICBwcmludF9z
ZXBhcmF0b3IoKHdpZCAqIDQpICsgKHdpZCAvIGdycCkgKyAxMik7DQo+ID4gKw0KPiA+ICsgICAg
ICAgZnByaW50ZihzdGRlcnIsICJPZmZzZXQgICAgIik7DQo+ID4gKyAgICAgICBmb3IgKGkgPSAw
OyBpIDwgd2lkOyBpKyspIHsNCj4gPiArICAgICAgICAgICAgICAgaWYgKGkgJSBncnAgPT0gMCkg
ZnByaW50ZihzdGRlcnIsICIgIik7DQo+ID4gKyAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJy
LCAiJTAyeCAiLCBpKTsNCj4gPiArICAgICAgIH0NCj4gPiArICAgICAgIGZwcmludGYoc3RkZXJy
LCAiICBBc2NpaVxuIik7DQo+ID4gKw0KPiA+ICsgICAgICAgcHJpbnRfc2VwYXJhdG9yKCh3aWQg
KiA0KSArICh3aWQgLyBncnApICsgMTIpOw0KPiA+ICsNCj4gPiArICAgICAgIC8qIEdlbmVyYXRl
IGhleCBkdW1wICovDQo+ID4gKyAgICAgICBmb3IgKGkgPSAwOyBpIDwgc2l6ZTsgaSsrKSB7DQo+
ID4gKyAgICAgICAgICAgICAgIGlmIChpICUgd2lkID09IDApIGZwcmludGYoc3RkZXJyLCAiJTA4
eCAgIiwgaSk7DQo+ID4gKyAgICAgICAgICAgICAgIGFzY2lpW2kgJSB3aWRdID0NCj4gPiArICAg
ICAgICAgICAgICAgICAgICgoYnVmW2ldID49ICcgJykgJiYgKGJ1ZltpXSA8PSAnficpKSA/IGJ1
ZltpXSA6ICcuJzsNCj4gPiArICAgICAgICAgICAgICAgaWYgKGkgJSBncnAgPT0gMCkgZnByaW50
ZihzdGRlcnIsICIgIik7DQo+ID4gKyAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAiJTAy
eCAiLCBidWZbaV0pOw0KPiA+ICsgICAgICAgICAgICAgICBpZiAoKGkgPT0gc2l6ZSAtIDEpICYm
IChzaXplICUgd2lkICE9IDApKSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgaW50IGo7
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgaW50IGRvbmUgPSBzaXplICUgd2lkOw0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgIGludCBncnBzX2RvbmUgPSAoZG9uZSAvIGdycCkgKyAo
KGRvbmUgJSBncnApID8gMSA6IDApOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGludCBz
cGFjZXMgPSB3aWQgLyBncnAgLSBncnBzX2RvbmUgKyAoKHdpZCAtIGRvbmUpICogMyk7DQo+ID4g
Kw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGZvciAoaiA9IDA7IGogPCBzcGFjZXM7IGor
KykgZnByaW50ZihzdGRlcnIsICIgIik7DQo+ID4gKyAgICAgICAgICAgICAgIH0NCj4gPiArICAg
ICAgICAgICAgICAgaWYgKChpICUgd2lkID09IHdpZCAtIDEpIHx8IChpID09IHNpemUgLSAxKSkN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgICBmcHJpbnRmKHN0ZGVyciwgIiAgJS4qc1xuIiwg
KGkgJSB3aWQpICsgMSwgYXNjaWkpOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsgICAgICAgcHJpbnRf
c2VwYXJhdG9yKCh3aWQgKiA0KSArICh3aWQgLyBncnApICsgMTIpOw0KPiA+ICt9DQo+ID4gLS0N
Cj4gPiAyLjMxLjENCj4gPiANCj4gDQoNCg==
