Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5DD4F8B2
	for <nvdimm@lists.linux.dev>; Fri, 17 Nov 2023 23:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NLBKrQsj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700263263; x=1731799263;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4DXmTgNdQEqbQMAtaOpH1ml71V6ZwlRnpDyyCyKZcw0=;
  b=NLBKrQsj0S/KMSuukKjiSkmVDuav5+h+k4QwU/4hxRtmoBBeUbwY62Sh
   RkoetWq/VQecNgXA3QfNY2mtnLPqvw+7qmkU9hCWKkfqyyfcrIRnmxCXK
   CTg87whYG47vn0RZVQWjbjThVvoUrfbsFrMiTE/WlqfUTmgQYfLU1eZ44
   HjREE9KBx/VCdkQ6g+wPLjdIPkx0Pe/ZgzaMBveCTqmIBf8NB8YlO184e
   FRygvPq/x0+5abLJ9NJ1IvhEmhRsMNIHewkZ5zb/UcK07upopc8lgHE6l
   zoQtEiczyEMUwZx9gyU/GxlQXhpheQCKDiqvMvSzid7LR8FqGR91NpO9g
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="4537107"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="4537107"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2023 15:20:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10897"; a="883256903"
X-IronPort-AV: E=Sophos;i="6.04,206,1695711600"; 
   d="scan'208";a="883256903"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Nov 2023 15:20:51 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 17 Nov 2023 15:20:50 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 17 Nov 2023 15:20:50 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 17 Nov 2023 15:20:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uu3CnX7OauilwBxmHUpv5w94syUJPBFAIugIQsTDy9rUfFq2e+8zFldUxGcdV0LFIscXm+FwuNP16bbEUnPNU0/q9r1SW+YPdAFe/DBJpekdGTLfymkvMtLwOWsleijCTi+np3mWNCYG/RoipA93zEUNTy3ls9BUko3Au+etG+JoQydtZ9CNAkKJe/N8GJ6QESidFj7TrrbJ1jEPkRSge/kORO/ijTqaaYanvOlOhfNa3tJgyY76mh4Bm39slLzskTFhVK87Ex+yYPEaNayB9FTKA6yTlxmBbx7RKVdPc/RVLXv6g2QEgmkf4Uexc4iHgPykF2IZRxuILQQiGBj9Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4DXmTgNdQEqbQMAtaOpH1ml71V6ZwlRnpDyyCyKZcw0=;
 b=NqX0jzp1ixk5wuySWAV2Du7osHPkqynNVegxRUy6xhVytVdq51E8AjVMTaVi1UxdoxFR2rwXISJryWuOtdRwye/67q+r1YSsfXqQtDsK8U2WfeEHy5Hxag2CLZ2FhjQ5TsX6unwZ5B2tCoeUja3P0iddKlTxJKbGXJJY21TQDjSDzTB8t4q3EyguCgnhTffNg20eAWM1mYh/veT8wzc29osGfeEgNSHiBFbr+vYRY8R8nhbzdXBnTmQH0GpCxK0y1R7NSPAlBvp3Higg+boE2RBo1j6VG8p6yX0YEfR1Bpxl2kwTBRGpwBhmitcPGhHSY41UpvLAaO9EcuOVzWsLjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.21; Fri, 17 Nov
 2023 23:20:46 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694%7]) with mapi id 15.20.7002.021; Fri, 17 Nov 2023
 23:20:46 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v3 5/5] cxl/test: add cxl-poison.sh unit test
Thread-Topic: [ndctl PATCH v3 5/5] cxl/test: add cxl-poison.sh unit test
Thread-Index: AQHaGaZpayo2hatN70eAqdI49l0kj7B/JhSA
Date: Fri, 17 Nov 2023 23:20:46 +0000
Message-ID: <bb600f5ce13d2c6e16d069485f1f940159338508.camel@intel.com>
References: <cover.1700258145.git.alison.schofield@intel.com>
	 <2c7aa46e399738867b21bb35120196310ed2613d.1700258145.git.alison.schofield@intel.com>
In-Reply-To: <2c7aa46e399738867b21bb35120196310ed2613d.1700258145.git.alison.schofield@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|MN0PR11MB6088:EE_
x-ms-office365-filtering-correlation-id: 253bdbba-5ba4-40df-0a15-08dbe7c3d414
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: coQmgFFpZB3DM8a0C5jd9maACsB1fW0aOu7pzVsRgSMjjZqepWIamqZQPP0kBeWfqD4Vcn3aKB9O59eBJXSRt51BaBf9kMVopicG8MdiDuF69cVXuvISXJIeFJjHHq0xzgc1cVA8OTbonbm4UviNKELPgQ8Tz+biFHwPIs4m0SOInRjmpVYzmAZcHxHAH2jz1rTFosEAqnoqUxkX4vFPQGmGgdTd3ShB9BbNtNQ2Rw/YsSgOKygVkiBj5Ulr0CSGjHCQZ9dpSO1pgE3FU1golMiPBi6kikfh+pqZL/kHObNCGmNl/AVmqQzYQeSbtH5CJuLFWgkrQQe9DcEcQ3m5hhIDFU86DfyC4uaU2wv1TM1pH/B9UBd1Q7si5J/1XYmP5h2hi4BaFRciV9s83ezsGUWPPK4/DLS37RhamW1g7aqfvTIGqlEnef8JJiLfyKmSHiy6a25EenXoRBXbuihW2Uy0F9w3Wr6JP13MaSXXdoygDSmGR8QIdK04n0oTDyebxzKfoE87bfts+KgB0J0c2ckpTogtIDY9f4Zj4gVUaQ6o9GSbJhY+aK6SxZnaPDb33T72u5rqCCGAWfoquHLd0KCDRSMl+OuWouLaFIFZc2HUrdfA0IoEWNi5Z2EOX9rN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(366004)(396003)(346002)(376002)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(71200400001)(83380400001)(122000001)(2616005)(6512007)(6506007)(26005)(82960400001)(316002)(38100700002)(76116006)(6636002)(37006003)(66946007)(54906003)(66556008)(66476007)(66446008)(64756008)(38070700009)(2906002)(41300700001)(4001150100001)(86362001)(5660300002)(6862004)(4326008)(8676002)(36756003)(8936002)(478600001)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXc3MGxaeHVBK1IzcUU3K1pBaXJCRG1lZE9OT3lwV1c1SUk2WmFNTCtGNFYx?=
 =?utf-8?B?czgva1p6bW5ndmJXTjNMUTJIQ3hnd0dLeEJWMnNVb0xLSDZpUzJFMDhGSmY2?=
 =?utf-8?B?dmJIdXdwUTJuQjlyaGxkd29Ya2hqR2FxUWhRTUp3MjY5WTJzQVYzRVJmMVlP?=
 =?utf-8?B?RTg5eGJTNWtwc2dxK2pJYzhBckFmYklLa1lYZkZSZ3Rnc1ZRTUFSVmlIZGVa?=
 =?utf-8?B?dUVKNFhGak0wOXVxSkl1eXNXdzRFWEtreFNlNWNhcmhKd3NRZFRiOXcybGdD?=
 =?utf-8?B?YWc2UEUwbHdyb0dwRGsxSnZuK1dzUGhqVVMxU25oNktYOW0wRnFpdEFTa0I5?=
 =?utf-8?B?NW5mU2VXOTFPZHc2RXduUXhiaW9SbGhjamdaakxOdjI3MzBLSGZIeUo1RWpy?=
 =?utf-8?B?SnNHbEVxaVBkL0ZhbmZxQkN0NDFoS2loVXIvU25BMmRuQlRKYkxvWmFlbjQz?=
 =?utf-8?B?Nzlpd1BQb0x1T2czMlFtTEVHNUx0QjZIU08yYTdGZHl3U091ZWVaQktQTzNn?=
 =?utf-8?B?TlZVSDdHemdiUGpZZVlRdkhlU0Q3MmVHdHdXTTVlNFg5Z0phWVY0QjJtc1pK?=
 =?utf-8?B?RXZoQlNQOE9vRnJEOEQ5RVFUTGJXNTV6ZG9JOTdhUi9TYmJqQ1JPZVk5TXIx?=
 =?utf-8?B?WXhESlpRaWRZYU5XRlY2bCtLeXl1WkVKNzVlaEN1LzVxQVV2YVJuZDYrdTJ3?=
 =?utf-8?B?WXlBVExua0Z6NnAyd01BQnJia0p3Y29mc0tYcGkxN29XVHRSQ01McjYwTm8y?=
 =?utf-8?B?K0o5L01jeHl3YnpTenZodlFOc3p6TitjRjVMbi84amdHVjdiMlY5WmhVMkpJ?=
 =?utf-8?B?WUp4RE9YWS9COVZFVXZvdXd6U1VRTzJxbGZZbkxWK09reTdPc0IzVDRyU2tP?=
 =?utf-8?B?cFFiQWdyN0pkMUx4UzQzeW5UL1RvSXBIVERueWNVS2t6bjBMRmxuMVBhZ1Vq?=
 =?utf-8?B?VXNiQ3VnbFZIeGluM1VtdytDQTFlL1JNL2FqazNxR1NSSUVDWENQY2wwMlJk?=
 =?utf-8?B?cUE3dlF2YnJXMW9ZMFZVcTBnUUVkbEJjZnZjR2lXY3dKMHVHK3lncVVKcTZH?=
 =?utf-8?B?VlBETnRyTFZya0ZKNmNNNGZ5MXhkQzRrTE4vWjlUNkpWSlJxZFdBWDdDbytP?=
 =?utf-8?B?LzFsRU1mN281YVVnQzBaM3kxanUvKzU3L3Bmd1U3Z3dIWUIxbUNTWTc0NnRp?=
 =?utf-8?B?Q0Q1dGxUMHF6RVUyMnVDN0R3akpHbnlFa2hJbGc0eEhsUWFnZ3ZURU5ldXcy?=
 =?utf-8?B?UjIzZU9mam41bEc5R2cxTW4wd21JMnp2VjZWb3kxMWxuY3NqalBJbFB1am5z?=
 =?utf-8?B?VlhJbng2WnFqRTMwL0tkUUJaZXdkeU83RDFic3dQTGZYbkhuR1kydTQ1c3g4?=
 =?utf-8?B?MjRybTJSZVhzaWN2cVQ2bk1nRGFmZ1JwYWRHcFZWWHFkcGM4OVRybjRNcGZG?=
 =?utf-8?B?MS9VbDU3cTlraVdZSHJKV0NzL3dmNFU1L0RFc01iTHFXSEwyV1g1SXowMVlR?=
 =?utf-8?B?YzFsY2V1eXJoTTUyOG1xdnlYdklZeGloYlBsendvZjFTdjNpeGZXYzdpZTdr?=
 =?utf-8?B?WVhyejhiY3hZMHo5WVV1b3Vacy82VktVU09nWnlZakZHNzZGVzBJYkpoVnpX?=
 =?utf-8?B?OGhxcnRjM3RQY2cvYVdyaTJyenJuQnJPMmxiWHdZWXBtK1pBaEhsVndMWmhr?=
 =?utf-8?B?WFhqZnp3V2MxeFpRSGtnNjlmVG1wd3d1MjNhR2VmWjlzVmhJZUtSNXgrL2Zt?=
 =?utf-8?B?UmcxcXBQVWhSV3BVUWJjNVl5ZzZNejZmVjZPVmZPYUFWUHVtSGUxcEZnRHdN?=
 =?utf-8?B?NWsrc3ZTT3cvUFl6NjlwTjA5WjFRU2FoMUtST1hvYUVBV2xUemlCVnJiOTll?=
 =?utf-8?B?MFN6ckNQeXlwU1RselBhWGtHLzdXbUIwK0kxOTI2M1Y0R0p0djE1cEdETUU2?=
 =?utf-8?B?TWRHSkd5U2VrZUxPTjNSOFdFRGNCcTlMaURFN2I1NjR3NTYzSEpFbEJlZjRk?=
 =?utf-8?B?S29CZ0J3WjZkdjQreVNFREl2N3hXV3poS0Z3M0tQR1NvdWNsRTdOaGhDbGdF?=
 =?utf-8?B?V1pzajZPaEluZ2x3WVVSckkvKzdjOVFGOEluOGduUVFvQWZNakQyUzhCVmpB?=
 =?utf-8?B?TDg2K1pxaTlqcWFpaHg2MWhwQ29VUXhsYWdBajdHdDgxWDlmUUdvK0JKb0px?=
 =?utf-8?B?cnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF16DFB6E364974E8517D071D297828A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 253bdbba-5ba4-40df-0a15-08dbe7c3d414
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2023 23:20:46.5303
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cBB1ZcZh2L5oct5Ejg85wb+NVdV/9fnDMLDvB8aeLIYv3uth6PTO3wXiffih33otw4DeLhs99jiZFrx2WNqXTrIHrvfKAB8TR+WDSC/pABc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6088
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIzLTExLTE3IGF0IDE0OjM1IC0wODAwLCBhbGlzb24uc2Nob2ZpZWxkQGludGVs
LmNvbSB3cm90ZToNCj4gRnJvbTogQWxpc29uIFNjaG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBp
bnRlbC5jb20+DQo+IA0KWy4uXQ0KDQpSZXN0IG9mIHRoZSBzZXJpZXMgaXMgbG9va2luZyBnb29k
LCBqdXN0IGEgZmV3IG1pbm9yIHRoaW5ncyBiZWxvdy4NCg0KPiANCj4gKw0KPiArZmluZF9tZWRp
YV9lcnJvcnMoKQ0KPiArew0KPiArwqDCoMKgwqDCoMKgwqBsb2NhbCBqc29uPSIkMSINCj4gKw0K
PiArwqDCoMKgwqDCoMKgwqBucj0iJChqcSAtciAiLm5yX3JlY29yZHMiIDw8PCAiJGpzb24iKSIN
Cj4gK8KgwqDCoMKgwqDCoMKgaWYgW1sgJG5yICE9ICROUl9FUlJTIF1dOyB0aGVuDQoNCk1pbm9y
IHNoZWxsY2hlY2sgY29tcGxhaW50LCB0aGUgcmlnaHQgaGFuZCBzaWRlIG9mIGEgW1sgXV0gY2hl
Y2sgc2hvdWxkDQpiZSBxdW90ZWQsIHNvIFtbICRuciAhPSAiJE5SX0VSUlMiIF1dDQoNCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVjaG8gIiRtZW06ICROUl9FUlJTIHBvaXNvbiBy
ZWNvcmRzIGV4cGVjdGVkLCAkbnIgZm91bmQiDQoNCiRtZW0gaXMgbmV2ZXIgc2V0LCBtYXliZSBp
dCBuZWVkcyB0byBiZSBleHRyYWN0ZWQgZnJvbSB0aGUganNvbiBhYm92ZT8NCg0KPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyICIkTElORU5PIg0KPiArwqDCoMKgwqDCoMKgwqBm
aQ0KPiArfQ0KPiArDQo+ICsjIFR1cm4gdHJhY2luZyBvbi4gTm90ZSB0aGF0ICdjeGwgbGlzdCAt
LXBvaXNvbicgZG9lcyB0b2dnbGUgdGhlIHRyYWNpbmcuDQo+ICsjIFR1cm5pbmcgaXQgb24gaGVy
ZSBhbGxvd3MgdGhlIHRlc3QgdXNlciB0byBhbHNvIHZpZXcgaW5qZWN0IGFuZCBjbGVhcg0KPiAr
IyB0cmFjZSBldmVudHMuDQo+ICtlY2hvIDEgPiAvc3lzL2tlcm5lbC90cmFjaW5nL2V2ZW50cy9j
eGwvY3hsX3BvaXNvbi9lbmFibGUNCj4gKw0KPiArIyBQb2lzb24gYnkgbWVtZGV2DQo+ICsjIElu
amVjdCB0aGVuIGNsZWFyIGludG8gY3hsX3Rlc3Qga25vd24gcG1lbSBhbmQgcmFtIHBhcnRpdGlv
bnMNCj4gK2ZpbmRfbWVtZGV2DQo+ICtpbmplY3RfcG9pc29uX3N5c2ZzICIkbWVtZGV2IiAiMHg0
MDAwMDAwMCINCj4gK2luamVjdF9wb2lzb25fc3lzZnMgIiRtZW1kZXYiICIweDQwMDAxMDAwIg0K
PiAraW5qZWN0X3BvaXNvbl9zeXNmcyAiJG1lbWRldiIgIjB4NjAwIg0KPiAraW5qZWN0X3BvaXNv
bl9zeXNmcyAiJG1lbWRldiIgIjB4MCINCj4gK05SX0VSUlM9NA0KPiAranNvbj0kKCIkQ1hMIiBs
aXN0IC1tICIkbWVtZGV2IiAtLXBvaXNvbiB8IGpxIC1yICcuW10ucG9pc29uJykNCj4gK2ZpbmRf
bWVkaWFfZXJyb3JzICIkanNvbiINCg0KSW5zdGVhZCBvZiBzZXR0aW5nIE5SX0VSUlMgJ2dsb2Jh
bGx5JywganVzdCBwYXNzIGl0IHRvIHRoZQ0KZmluZF9tZWRpYV9lcnJvcnMgZnVuY3Rpb24gYXMg
d2VsbCBhbG9uZ3NpZGUgJGpzb24sIGFuZCBtYXliZSByZW5hbWUgaXQNCnRvIHZhbGlkYXRlX25y
X3JlY29yZHMoKSBvciBzb21ldGhpbmcuIE1vcmUgZ2VuZXJhbHksIG5vIG5lZWQgdG8NCmNhcGl0
YWxpemUgc29tZXRoaW5nIGxpa2UgTlJfRVJSUyAtIGFsbCBjYXBzIGlzIHVzdWFsbHkgb25seSBm
b3INCnZhcmlhYmxlcyBjb21pbmcgZnJvbSB0aGUgZW52Lg0KDQo+ICtjbGVhcl9wb2lzb25fc3lz
ZnMgIiRtZW1kZXYiICIweDQwMDAwMDAwIg0KPiArY2xlYXJfcG9pc29uX3N5c2ZzICIkbWVtZGV2
IiAiMHg0MDAwMTAwMCINCj4gK2NsZWFyX3BvaXNvbl9zeXNmcyAiJG1lbWRldiIgIjB4NjAwIg0K
PiArY2xlYXJfcG9pc29uX3N5c2ZzICIkbWVtZGV2IiAiMHgwIg0KPiArTlJfRVJSUz0wDQo+ICtq
c29uPSQoIiRDWEwiIGxpc3QgLW0gIiRtZW1kZXYiIC0tcG9pc29uIHwganEgLXIgJy5bXS5wb2lz
b24nKQ0KDQpGYWlybHkgbWlub3IgYnV0IHNoZWxsY2hlY2sgY29tcGxhaW5zIGFib3V0IHF1b3Rp
bmcgYWxsIHRoZSAiJCgpIg0KY29tbWFuZCBzdWJzdGl0dXRpb25zLg0KDQo+ICtmaW5kX21lZGlh
X2Vycm9ycyAiJGpzb24iDQo+ICsNCj4gKyMgUG9pc29uIGJ5IHJlZ2lvbg0KPiArIyBJbmplY3Qg
dGhlbiBjbGVhciBpbnRvIGN4bF90ZXN0IGtub3duIHBtZW0gZHBhIG1hcHBpbmdzDQo+ICtjcmVh
dGVfcmVnaW9uDQo+ICtpbmplY3RfcG9pc29uX3N5c2ZzICIkbWVtMCIgIjB4NDAwMDAwMDAiDQo+
ICtpbmplY3RfcG9pc29uX3N5c2ZzICIkbWVtMSIgIjB4NDAwMDAwMDAiDQo+ICtOUl9FUlJTPTIN
Cj4gK2pzb249JCgiJENYTCIgbGlzdCAtciAiJHJlZ2lvbiIgLS1wb2lzb24gfCBqcSAtciAnLltd
LnBvaXNvbicpDQo+ICtmaW5kX21lZGlhX2Vycm9ycyAiJGpzb24iDQo+ICtjbGVhcl9wb2lzb25f
c3lzZnMgIiRtZW0wIiAiMHg0MDAwMDAwMCINCj4gK2NsZWFyX3BvaXNvbl9zeXNmcyAiJG1lbTEi
ICIweDQwMDAwMDAwIg0KPiArTlJfRVJSUz0wDQo+ICtqc29uPSQoIiRDWEwiIGxpc3QgLXIgIiRy
ZWdpb24iIC0tcG9pc29uIHwganEgLXIgJy5bXS5wb2lzb24nKQ0KPiArZmluZF9tZWRpYV9lcnJv
cnMgIiRqc29uIg0KPiArDQo+ICtjaGVja19kbWVzZyAiJExJTkVOTyINCj4gKw0KPiArbW9kcHJv
YmUgLXIgY3hsLXRlc3QNCj4gZGlmZiAtLWdpdCBhL3Rlc3QvbWVzb24uYnVpbGQgYi90ZXN0L21l
c29uLmJ1aWxkDQo+IGluZGV4IDIyNGFkYWY0MWZjYy4uMjcwNmZhNWQ2MzNjIDEwMDY0NA0KPiAt
LS0gYS90ZXN0L21lc29uLmJ1aWxkDQo+ICsrKyBiL3Rlc3QvbWVzb24uYnVpbGQNCj4gQEAgLTE1
Nyw2ICsxNTcsNyBAQCBjeGxfY3JlYXRlX3JlZ2lvbiA9IGZpbmRfcHJvZ3JhbSgnY3hsLWNyZWF0
ZS1yZWdpb24uc2gnKQ0KPiDCoGN4bF94b3JfcmVnaW9uID0gZmluZF9wcm9ncmFtKCdjeGwteG9y
LXJlZ2lvbi5zaCcpDQo+IMKgY3hsX3VwZGF0ZV9maXJtd2FyZSA9IGZpbmRfcHJvZ3JhbSgnY3hs
LXVwZGF0ZS1maXJtd2FyZS5zaCcpDQo+IMKgY3hsX2V2ZW50cyA9IGZpbmRfcHJvZ3JhbSgnY3hs
LWV2ZW50cy5zaCcpDQo+ICtjeGxfcG9pc29uID0gZmluZF9wcm9ncmFtKCdjeGwtcG9pc29uLnNo
JykNCj4gwqANCj4gwqB0ZXN0cyA9IFsNCj4gwqDCoCBbICdsaWJuZGN0bCcswqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBsaWJuZGN0bCzCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgICduZGN0bCcgXSwNCj4gQEAgLTE4Niw2ICsxODcsNyBAQCB0ZXN0cyA9IFsNCj4gwqDCoCBb
ICdjeGwtY3JlYXRlLXJlZ2lvbi5zaCcswqDCoCBjeGxfY3JlYXRlX3JlZ2lvbizCoCAnY3hsJ8Kg
wqAgXSwNCj4gwqDCoCBbICdjeGwteG9yLXJlZ2lvbi5zaCcswqDCoMKgwqDCoCBjeGxfeG9yX3Jl
Z2lvbizCoMKgwqDCoCAnY3hsJ8KgwqAgXSwNCj4gwqDCoCBbICdjeGwtZXZlbnRzLnNoJyzCoMKg
wqDCoMKgwqDCoMKgwqAgY3hsX2V2ZW50cyzCoMKgwqDCoMKgwqDCoMKgICdjeGwnwqDCoCBdLA0K
PiArwqAgWyAnY3hsLXBvaXNvbi5zaCcswqDCoMKgwqDCoMKgwqDCoMKgIGN4bF9wb2lzb24swqDC
oMKgwqDCoMKgwqDCoCAnY3hsJ8KgwqAgXSwNCj4gwqBdDQo+IMKgDQo+IMKgaWYgZ2V0X29wdGlv
bignZGVzdHJ1Y3RpdmUnKS5lbmFibGVkKCkNCg0K
