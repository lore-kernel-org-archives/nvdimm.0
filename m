Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279AC643
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 06:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675838893; x=1707374893;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QqBT8ejyC8M+G8PnOv1jmLEe4V77n7NT+oRl18PebOA=;
  b=WuCPbZhx6krFtXmGIeTJ+e35LSE3fA+Tu0eoZTE73v0PS3lKVPNUSR+K
   s2ITawCUe9lIRMBXsiS8aWSeAbQVLy7FIqdgxAEfMr6bE6eo8p4pJqDd6
   c7GCSWIVJMLtJR1Q3zbFr9TtFGzO/CesReiAWExIeu9FGhD/2/o4mwFQM
   DwjCbM/qEOtFQ/h4EjKE9A/RuabjagA/fERmigTIKvQnLvCtU1kzUjnEX
   xgKrpaRG++am+cCD+ZxsOdLV8G+sDsA2vu8Etz7x+LWjvJvOELGD/swxP
   rntCNX1DXe8chYLOp1d+phU8oJLHWaq9LaEcTHdK3FsKtt1iDhTA8zyjp
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="313369502"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="313369502"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 22:48:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="841071031"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="841071031"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 07 Feb 2023 22:48:05 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 22:48:04 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 22:48:04 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 22:48:04 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 22:48:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWNDCKk3VyKh3WVHzx4XWoOr+l86oAsaB0TDEVoPKbCWtee7PdsFNk6WGjCR5tm5lzq9MXf5kjkiIhuOlZIFPgmhxqtdCVqMS5nHQLutV4lPZ3n9CriUmLnqlV540UCEUyFJiYn7Dj2y+XFV52LyEfe+kdjaiOcGqd+xXABiK8xGxpQQcPYYdhTMKKJLPqqPaT12OKQrB7g0981DaEv5/SjLncogswGiCGA5higfOGKo5YYPxMOubO6vYHV7F4Md3ErsYsoGU7geyiUiz4fLBKdxDjxv5TMQiUTIhXaUQSL2NHDRQhNTIRF8C5GXgaLOnPj7FQ2gzQ/MZ0IPz5LO2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QqBT8ejyC8M+G8PnOv1jmLEe4V77n7NT+oRl18PebOA=;
 b=myfoBMW7gHBv9ktgzVnlPdJEPaqynveOlvC/kwwvchhWrFVznfdwf7OLi5yyAnKH10h9ILoyBMamz1IfdI9aTRf/4e1PKUAdjc4Y9def+A9+NLF5fGevAW5c/jShlbZgaS2MqDwqFUcVUJ38P+ryqB1nXJpvO4NykUVsmeRDPmF6dBGYi4LdcZLdFVP4Uxpjwn4ut30jauqsg40drHq0GT8m4prTvv2PPUQAKAxMelhUmfopgYPhWMm4T8CDYDa5JfYqllSvUroqUaF///K3zXUi5o6GG/Xjo/DpS7PialTWqCLCVlsIPeB6x3t7cyHOXsFoIi+AF9WHbvIY/c/xBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB3988.namprd11.prod.outlook.com (2603:10b6:405:7c::23)
 by MN2PR11MB4711.namprd11.prod.outlook.com (2603:10b6:208:24e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 06:48:02 +0000
Received: from BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::16cf:5ab1:7f74:d1e5]) by BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::16cf:5ab1:7f74:d1e5%7]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 06:48:02 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
CC: "gregory.price@memverge.com" <gregory.price@memverge.com>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"dave@stgolabs.net" <dave@stgolabs.net>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 7/7] cxl/list: Enumerate device-dax properties for
 regions
Thread-Topic: [PATCH ndctl 7/7] cxl/list: Enumerate device-dax properties for
 regions
Thread-Index: AQHZOyjFsQVUR7wz2kGCIQNHftbkBK7EjuGAgAANXgA=
Date: Wed, 8 Feb 2023 06:48:02 +0000
Message-ID: <4891ce911502d467bcf05612559a1d5f16022a1a.camel@intel.com>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
	 <20230120-vv-volatile-regions-v1-7-b42b21ee8d0b@intel.com>
	 <63e33a69e1369_e3dae294c8@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <63e33a69e1369_e3dae294c8@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB3988:EE_|MN2PR11MB4711:EE_
x-ms-office365-filtering-correlation-id: d52c6be1-9fdf-49d8-2355-08db09a06cb3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tB9cZ3KocVwhAePGb4EoiKZrC1Ueuu3KAOhDunDZz92hZ0Fdw/PIQHUm0kPZVK5evXAhBBwA7ytIWHr4M3eYR/Lsj3Engr0c10mjIK2bR0VVncchwBogAb7KlAiqY7DlicEx4WC9+gwohckIqk/zR+dMbzGWzL4szXg7QCDzUYxBJvRDERTZ9R8w0jNutGDmI3GrHHh8bldEEXRfsKPNFIsk9qeMYGl0Nby4Mi+2FbkANf5tYzvVvTa5QNIkD0pcdOzTF3aBYMZIlGUuU8ImaB/ZOXqvRcjiDEsMnxM/6X85TuzeZT0j1WDMwbKv4yLu6kCxJNdgBCHPYN1qYA6rDWR8B/MtQrkPVtsc4gT5GOzjlyCECmQ1TURPu9lJMFeXVlrYW3Ht/KSP9SpgH47mLRt031Mkjr/SMUkas18B1q8gi710IhxfNwPEXeyIshdSAPPl907lnKTQB2l0dhirBZepbd+zxI9SOzLjJqvZN39jyERzgeLsi4ndvIH5i3ISiC7aPmzdwIESCKqm4cilqoxkMo8/RwdF7Z68HgLEccJIttUl8/xGc6UElvcCVPymx6eLZGrSm4gMk6wK45gJS7wRE2u2WQFuB7f/JPck5EzKiw6BgpbXe2iXCaAnczfyJzZctouHc1KLie0sBzdrtltQswPdItcpc/iooRQqukFF/WeTBInd0wQvWC92o/FQGI8aEikxuFVxjapwjoPbZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB3988.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199018)(4744005)(5660300002)(8936002)(2906002)(82960400001)(36756003)(41300700001)(4326008)(8676002)(66556008)(64756008)(6512007)(66476007)(66446008)(478600001)(6506007)(26005)(2616005)(110136005)(54906003)(83380400001)(91956017)(316002)(76116006)(186003)(66946007)(86362001)(38070700005)(122000001)(38100700002)(71200400001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnBPTzBoR1Y5S2Rrbi82QVFRWUw4bDVHVEpLNmRVRW9QVmFOU1kwWXFxRTRE?=
 =?utf-8?B?VitvMWRXL0owNlRSRGFLdjhJTjZhZFlSUjBhTjZBU1ZWbFVtaGJ1eWE1bGM3?=
 =?utf-8?B?OXMyZmI5T29yK2h6UWFIWncvampjNGNVeVc2MkF6RDAzUFR2dzZFSUNUdFN5?=
 =?utf-8?B?VHN5RGdzelNCSGM4MGkwYkp4aUxmbmttMmRyU1A4ZXZCeEZZQUlSazZhRUc1?=
 =?utf-8?B?bDIvMGlaR3pBeVlwSXNCK0l6VlgwVHk3Qm96UFZyWi9PSkx3aWRGVXJHWHJT?=
 =?utf-8?B?MHBKMTl1QXNOTEJaVVNkOEM5RnhxY1BHcTNjOGpwYTd2RU1BMjlXVGdOc0RJ?=
 =?utf-8?B?R3FNeHVVWjZBWVIrZ1dVYm9mT0VlbXJZeUVtS3kyaEtUR3kxVnNJMVVlSkJL?=
 =?utf-8?B?a3NRN29TUXlQbFo4RHA3eVVUSzZHMm9BZmJvNnYrVlo3RUV1SVltM1NBT3V6?=
 =?utf-8?B?aW9Gb0IzdG5OSXV6MnBTOS9GNjk5ZHcrcHIzSG5xR1FyNFAxOExWeHRFWlVK?=
 =?utf-8?B?bWZkbXExKytCdGxKVW5TT3VXUW80YkZRa25sa2FnQ0F1V2tWNXdpVk42cC8w?=
 =?utf-8?B?NjMxRUZXZDBnSG1CN29hUmdHVHRCNXp2STZuWGxwSFFBOGd5Q0tXTDZjV1Y1?=
 =?utf-8?B?VWlJMVQzT05FNDgwQUNLNkNpOWZXcjRFSTVac3YyMFJUdHZvSXp6dnlBOStn?=
 =?utf-8?B?Z0wrOEhmblY3QVZidWhsRjEyb3d5Z3E5MFlvRWk1RjRXWE54OUoxWGI1N21i?=
 =?utf-8?B?RUUwTklwQXRVRGxxY2haNkVFWHVOS2xIVFV5WS9vc0JGY0pqS0FxMmtJNzk5?=
 =?utf-8?B?azN3VWpUSWt5ZFArQXljM0FGbm4yZCs2YnZSUHRGK3dQR3Rwcm8wNlhIRkJG?=
 =?utf-8?B?dzBIcWVlYzBSbWh3Q0p4RlJ6cVZKekU3WG9TRFRHbUsyK1RiSXdFQm1EUENX?=
 =?utf-8?B?eWdCdkVFSGhQUXNsY0JWMEZ4YXVTNUJwcUU3bVNBbWhyV0R5QkdvbFpzcjB5?=
 =?utf-8?B?c0krVTM4OEowYkpPa05OMWZwc3RFbnJFd0ticFhoNWQ4MVpNTW93OE5LNmQ0?=
 =?utf-8?B?THRqT1VDR2xRb3NxejUxbnVZNTAwOCsvRCtMQjkzc3dibjFYOUNyVkhQSFd1?=
 =?utf-8?B?VFJIMlFscmVMZmFNM3laK1JDRmMwN0tnRG5uQ0gzYTFUZGVxTkQyY2RvMjJ5?=
 =?utf-8?B?UU5zbFJyeUEvWjRlMFFkbjAvMG1vME8yeDE1czhINHpWTTdMU2F3QkpkcDJV?=
 =?utf-8?B?OE1ZUlBZeWtGeUxua3NIS3NvRitmOEJqaDdsSXFyeVVta05VL1VOM3BUb2RB?=
 =?utf-8?B?WU9yWVNWRGF2Uk9ySVJiaGd3VngzMEpKd3Q3YzhDL2JaWjNtRnJjQm9STTdy?=
 =?utf-8?B?bDJKK1Z4TTAvT3dOY3pseDJMb1RsbkJMY0JyWjYrSFRFL1hPYU9qRFNvUEtP?=
 =?utf-8?B?aURMcllPenJRWkpGNXMxTjA5SGJRY3h4NmNoelpKdzZFSjZkNjlUQnpmUE9E?=
 =?utf-8?B?amJjS1BBL25wWHE0ejhtY2pad1NDc285OWZFTHlVcStjajN2Y1FvODBRbExr?=
 =?utf-8?B?aC9rN1ViazRsd1JudTVRTHZ3U244RnFFUm9TR1Rld2JRdGpNNWI5Zm91UkRw?=
 =?utf-8?B?emNkdEp0Q1JvU2YwdVZteUR0enRTQldsd2JqNzNJWnZrWGlwYjl5SlZPN2ZS?=
 =?utf-8?B?aGV2Q251QzIyTDJYc0pBQm9taTk5eU0yZ2IvVnk0emhIUUNYMHdKV0R0VDda?=
 =?utf-8?B?V3J4K2c2SExDdHUraENVa2drL3JwTWxLMU5TUDVyb0lvcXVuUjRRN2dZRk5E?=
 =?utf-8?B?UERsT3VhRWZFVHJpVGw3Z0JpbEN4NzlOR3hKL25NL3dMa3FvMEN6TjNhMXBW?=
 =?utf-8?B?S1g1S2ttT3B3cU9YYS8rQmtWSjRibjhNY1lramJFVXV3a1hzM1orNmF4eU14?=
 =?utf-8?B?bDgzWWh3cFFCVHVJd3lQK0l0MXJrRkpyWDVCOVBYOWtyYW1YSzMrZlY1M24w?=
 =?utf-8?B?ak9pVm14MyszcEJJNnozbk9PZ3hMVFc2YStCRkNpYlJIOFdJWnRlNWI2QzlY?=
 =?utf-8?B?Z1N4Q1N2RTd1RzlsOHV1UU9WbWN0REVLSTBXVU5FbzVmZGp2T3pmRjF1VDNI?=
 =?utf-8?B?SG9jbzlHUzhKYlpBL0lieVFzd3RVRUQxT0RjMnJWUk1jU09KZHZ2dnNDSzVJ?=
 =?utf-8?B?WkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E60AB8C04F5C57458747938B2A04EE24@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB3988.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d52c6be1-9fdf-49d8-2355-08db09a06cb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 06:48:02.5685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SNOnmEpdofKBQ719KvAzmDWsAEoVbuZJtRznaTC6adTSVBX3+ofiO/fAe6amNM/PaOOyZu9VRQS04WCVl+R7U9IzTBs1MEqPzAYSTTQv2Ok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4711
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTAyLTA3IGF0IDIyOjAwIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFZpc2hhbCBWZXJtYSB3cm90ZToNCj4gPiBGcm9tOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxp
YW1zQGludGVsLmNvbT4NCj4gPiANCj4gPiBSZWNlbnRseSB0aGUga2VybmVsIGFkZGVkIHN1cHBv
cnQgZm9yIHJvdXRpbmcgbmV3bHkgbWFwcGVkIENYTCByZWdpb25zIHRvDQo+ID4gZGV2aWNlLWRh
eC4gSW5jbHVkZSB0aGUganNvbiByZXByZXNlbnRhdGlvbiBvZiBhIERBWCByZWdpb24gYmVuZWF0
aCBpdHMNCj4gPiBob3N0IENYTCByZWdpb24uDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogRGFu
IFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+ID4gW3Zpc2hhbDogZml4IG1p
c3NpbmcgZHN4Y3RsL2pzb24uaCBpbmNsdWRlIGluIGN4bC9qc29uLmNdDQo+IA0KPiBzL2RzeGN0
bC9kYXhjdGwvDQo+IA0KPiAuLi5kZWZpbml0ZWx5IG5lZWRlZCwgd29uZGVyIHdoeSBteSBidWls
ZCBkaWRuJ3QgZmFpbD8NCg0KSUlSQyBpdCB3YXMgYSB3YXJuaW5nLCBub3QgYW4gZXJyb3IgLSBp
dCBhc3N1bWVkIGEgZGVmYXVsdCBpbnQgcmV0dXJuDQp0eXBlLCBhbmQgd2FybmVkIGFib3V0IHRo
YXQuDQoNCj4gDQo+IERvZXMgY3hsL2ZpbHRlci5jIG5lZWQgaXQ/IExvb2tzIGxpa2UgSSBhZGRl
ZCBpdCB0aGVyZSBpbnN0ZWFkIG9mIHdoZXJlDQo+IGl0IHdhcyBuZWVkZWQuDQoNCkFoIHRydWUs
IGN4bC9maWx0ZXIuYyBkb2Vzbid0IG5lZWQgaXQuIEknbGwgcmVtb3ZlIGl0IGZyb20gdGhlcmUu
DQoNCg0K
