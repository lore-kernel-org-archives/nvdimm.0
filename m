Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A6A160
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 00:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675815554; x=1707351554;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bnTljiZEbeChaBynscPDkr6GkQex3+ZtSFKU18aGGhY=;
  b=eKsDpttJdUUXC/uw/r7pGtbEDdWcT29sAzBZnUhp3/LS4Vx2hUjaFBu0
   anG7dPY6W4OIzbR+as1xZho61HwfodahbTf/mLlOsAsPLrL0cGbW4Xdla
   SXXHeNJEu3yMvfQWDK5pSrA8yL5OeUm2WlBiDBNkhM966jYkeoRnO3ly3
   90Yl5aRzYSXG/xzd7oSRI+6tRoxPZ0d+UBgIS6TWqQ1OfqBsTRxY4tVQf
   CaMgDQ4mUQ7T/y82bqUd7OLezY5I0YPkvUqIZsf0xFyfieAAU8/+62zR9
   EyrWDtGdgqU3Z3v7Acxysb8Kbc60HNFJ0kntCIjMAoH8J02i5lRndB+nn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="357046895"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="357046895"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 16:19:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="995933174"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="995933174"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 07 Feb 2023 16:19:13 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 16:19:12 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 16:19:12 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 16:19:12 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 16:19:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VmuPpphvxCNO9naeTDuY7hKBDMtzhzYJjupSupaw/33TN6jSjrXajnQ/3m4uE5jazqYoZdos34hP0B30fO9QxkGGd93FzLazPj2LVEbJZwEjHCUIu76ZOOIOfRiGiz3TQJpE0vTl1UpHaH/crgC4Ktab8tmFFwgOmyZWRyd9XlIXSDqV8RcZCjtoeXAPiEN/FgEPYCLq6DvFmycrth/r+JotTZZRldL0KsUTCT2W4Hsi81rgtbTGffZAjOjrFlzWqd1nT4PQZYasZqKUJqRo5BnvEleD74PEMhNVrx7eFh1pBQNT2EgnjhSfg/76hhG11sXzBPUpaUmtMgDO8AQ7OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bnTljiZEbeChaBynscPDkr6GkQex3+ZtSFKU18aGGhY=;
 b=GWb88gEXbkPeVzwp2NfJuzpTWxiBKpMverACWw+fHXmcub2eEuJaQ/w3Bh6Flkz3XqrGdy0UuAwA87frnYxeh2rUt6pn8mBHwt93DF/fEYi5fHnoRNlaSosZ6SAjU6VD+Y9s2r6wqw3zo8O6KQ/amtBvjGFdVPom/n7M2Ql5uO78WhfFl80++T2krWa09CHmifpVSzt2aFBrNP3/PPTt8TgmDZIj49JQUVvkGazF7qPP6M2tymxt10scVnDTulvxPZbwDP2gTiVpE5FiexVP/gqJTpP8hpo6yZxPTpmYwl/Yv8BNDEF4Kw2Xhzf8plZHhyiubE5DZ0zIqY5RJ4TRdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by PH8PR11MB6975.namprd11.prod.outlook.com (2603:10b6:510:224::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 00:19:09 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1ad0:a5dd:2fec:399c]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1ad0:a5dd:2fec:399c%5]) with mapi id 15.20.6064.036; Wed, 8 Feb 2023
 00:19:09 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "fan.ni@samsung.com" <fan.ni@samsung.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "gregory.price@memverge.com"
	<gregory.price@memverge.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "Jonathan.Cameron@Huawei.com"
	<Jonathan.Cameron@Huawei.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 1/7] cxl/region: skip region_actions for region
 creation
Thread-Topic: [PATCH ndctl 1/7] cxl/region: skip region_actions for region
 creation
Thread-Index: AQHZOyjILzMqjh5HkkWlTojIe7Rffq7ECtOAgAAkxYA=
Date: Wed, 8 Feb 2023 00:19:09 +0000
Message-ID: <5c8659811878addf570549c31419b9e458306418.camel@intel.com>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
	 <20230120-vv-volatile-regions-v1-1-b42b21ee8d0b@intel.com>
	 <CGME20230207220732uscas1p28eab99f743962581e50c2657b2e2132e@uscas1p2.samsung.com>
	 <20230207220723.GA702843@bgt-140510-bm03>
In-Reply-To: <20230207220723.GA702843@bgt-140510-bm03>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|PH8PR11MB6975:EE_
x-ms-office365-filtering-correlation-id: ee0b10f9-c50d-4f1d-7f49-08db096a1903
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8D+ty9EEev0AHzB/ITEj/oAJZooj82NPmIuLPrIZN0Jco/+NSglzIihQTwHVn6wo/KvLgapdsbFsp0+z4Suwy+vRhw1KzLNibcfJ27Li9vxOlttiJAcnk9kafP83Aw7hFP/y3y+UNehG8VvkbxoKDEPuHR8hLN6T6aBVxMjd/o77SxXG+wsmQO4RzzuvjIN5CYSabejKN9q4ItuhghjF1QcYpfLM52oeF+dSdl3rPmmeAyxW2LxAP7CLdiLvNqwbnAXT8LNJtH80/+NMPEevugF/T2GvfajQUAjkokv5Vbo1VWaAlyvaD/Xg95jVFhiCAZv0K06gcSErvlVXKyD+786Kn970y4j+nRrW9LHNVFg/WulKsmbjJXDZXlHA4XNg+gW1ztYqlknSWrhUwLdsRDCfVU0shrDJltOLH/kg3btHv2UU25avH1GpZaeX4dD3X8Rxs4AbCqJQsJivwdhYHTua7LYLreI3ca/NYBImzi2hDcN8OyeuWqKsAjDta/BupTrBtjpeRmueyCsoZ84Xb7B+9/+6VzFLIO3kqWL3LUZ3TzHYG5/8VDWI4VpqtcSaLei38O+XUnOTAdZp1B+K6UyeYavBypNoaDhDDtRnvbAfJTvE5BaTmO7hEDNbfwPx/X0Q/rmSjBy36OAQNauZCapVLi3vvbFXnKVpAIcXtbzmOxC+azNPvSXAXCKj5AH9RxVAv0EdgreFaHSCckrOcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199018)(54906003)(316002)(36756003)(86362001)(71200400001)(26005)(6512007)(186003)(6506007)(2906002)(66446008)(5660300002)(2616005)(8936002)(4326008)(41300700001)(8676002)(6486002)(6916009)(478600001)(66556008)(64756008)(91956017)(38100700002)(76116006)(66476007)(83380400001)(66946007)(38070700005)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b05rYTF4d3hXVFhQMzhHaWVpYldiZTVUanExblNWVlY0bDd3eEJ3ck1MMmtp?=
 =?utf-8?B?R2JvbkFOaG82NXZGMDlWVWxPaEl2TUpaRmFUalBOc2o1TzFWZWdIR085ZjdO?=
 =?utf-8?B?SHFTZHVtcHA3ZklHTGFoZy9qZjZJRllIS29uWkVMdXdRNHQzMWhYSmxHNllw?=
 =?utf-8?B?bVR3NkhWT0ppL1NPZS9Odmp0Rkpic0V3Y0dsT3ZsMzMvN0JURG9BQW00U25x?=
 =?utf-8?B?aEhFSUwyR2hZUnp0L3RGb1UwSWhOb1YvM3pMbTZKUFBGRlgrQm56S2Q2K1Iv?=
 =?utf-8?B?UzlLNm1hdkM2ZnhtZHFqMDI4YldaYk9aVWFzWDkwbkZ4QTdnSTFVMytzY1pr?=
 =?utf-8?B?bmZYbmx5czVnZVNudjYweFI5MGVEK0FJOTlGN2tGVk8ySEdtUktkOWY3RUY0?=
 =?utf-8?B?VEdlT2xUN2ZmMjErQXpmQUU5ZFlXdDc2RjhtMllKcERqL1lVRkppdksxbXZH?=
 =?utf-8?B?RHQwQlJINHJyR1RqZFgrd1hudFYvWkk3bjh2KzhlOGViUU9TSzFJKzlGNlJD?=
 =?utf-8?B?R0F0UUdIVVp1a2NyTktGek9HZVhZOGU1VGRya1NkNmJ3aVhKY3h6S0phQTQz?=
 =?utf-8?B?VTl2MjIvNE52TFhpMDE1Z3lxTStYeEhFbXgvdjdIUTJHMVV0bXBzMEc1ZDh1?=
 =?utf-8?B?MVJ5Q3RmVkF0RWFBM1gzclVDQjV0WjBhdGR5cHRGZFhDMVBDc3Juaks0N1Rl?=
 =?utf-8?B?UTFwOFRFcTVzdnVUSzVFclJRVFY2a1pJcXFkZjdRZEdtWFk1Q3cvUlVZS1JI?=
 =?utf-8?B?amxqc1hPTlc0YlcyZDNKUkxPNnBPcUlNWWk0TGhKdTNld3lkc1JLdWh5MWNj?=
 =?utf-8?B?K3NCSE9FKzhiZ3ZKbk1JbW9tZVd6NzZmbjJvK3c4Z0ZYYnE4dGJUNzhSNGVx?=
 =?utf-8?B?Y3hWbGVnWFVoc3B0dSt3bTc0bG90VituaDNBbnV0MVVnRy8xMWVIdUx3M3Ju?=
 =?utf-8?B?Q2dTbzRSZGUzNzRGdWdpK0JvdExnc0VUdDRab0NvM3NtT2pGTkFJOGxZZ1FD?=
 =?utf-8?B?MGdPMlA0SjM4bHd6cGFUTDNIcENjTmhlZXFnYTZSRG5udEpVUFh6K0ZkNlhv?=
 =?utf-8?B?RnlMaHk3dk1hNkJObEhLVzZPZFBMOVlnS1ROOTlkL0pTZjIrNFRlMG1kZXRD?=
 =?utf-8?B?S1J2eWJtZi9mZk5FODdnRUdLNlYzNzl6T0twQUZPdkVIMWluYk5mckhibmRW?=
 =?utf-8?B?cUdpTkZrNEIyWXdsb1EremNKOXlmeEZqaU9UWDVLaEw2Y0dDSEIxbEFLRmZN?=
 =?utf-8?B?KzcwRC9TcllCdmw0ajNzUWttVCs4REpuL1dBQkRnS1Z6RDJUWEJYZ1Nqdks0?=
 =?utf-8?B?RmdQZkFhSTBJcTdXTkVscjN6VzZBNW9yc3hheTlLZWdwN0VmbUhHTElOeTg3?=
 =?utf-8?B?ejh2Z01JcC9hUGdqRWZGbzFVSkJUNi9IMElTdU9GMXJ4bE9WSGsrUThPOFg0?=
 =?utf-8?B?L09WNGZGVkVEdHFBdDVhWnZ6OUpoRlEwWVRDamY1VHVzVlpnTmxhSk5qc3FF?=
 =?utf-8?B?M250U3FFOWgrbUw0dzJkU2xFWHp1eEhhRytlWmJXbUxtamxnSll3OXJaS29B?=
 =?utf-8?B?dWkweVRwR25ZSTUyUlB6YXRzYkdYVlhsQ1YvTjdiaGZTRTg3Y05lVEhLNGpV?=
 =?utf-8?B?UDlCTlUvUGcvaWhpbHZsalhLM0I0QVA2dXJRWmlId3N3S2tTTitvM2o2L1VB?=
 =?utf-8?B?QXFOdjVvQ0xGVzlrbG1oZ2hmNWlLRzFSQitDWTNRWUhCcjUwR0ZCamxBQmJ4?=
 =?utf-8?B?TXNsNkpKT0ZtaDZHdDZxeXNiODAyZzVtTUQyNUF5em05a2JWVC9tb3FZQW85?=
 =?utf-8?B?Wkp3eXpjMUowNlJsRGNtZzZrcWhSU0Q3dmY2WERVeG1uL3NnOFRaRXF0TURk?=
 =?utf-8?B?OGh0Wlp0cHp1ODJ6bldoSkdBWnF6aGtaclpLUDN4YmlSakJ2STBVMTA4Tk02?=
 =?utf-8?B?QmJqWGdPM21HNG5Mcm1JYW9veVdjSzNCTVhDSXhFNkpJNlJFQXdhamg1TkY1?=
 =?utf-8?B?UGl0Qmd4SWxSVGpzMmdZQXB5aGc0d2VzaHlnTzBtdG1qZ25zVWo3eVhmblpG?=
 =?utf-8?B?UTA5em1HVnBLem8vekZUdGY3QmQ5RzFzYmRoVjlONWhaTi9IaXBrOWlJeC90?=
 =?utf-8?B?UUpZQzhpdnVrUVpkRnZPQ2RoazFyeWtNZTFweHN1aEtNdXIxek5MVzIxYTYx?=
 =?utf-8?B?NkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <56EFE0387A1ABF4195DD80621F6F15CC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee0b10f9-c50d-4f1d-7f49-08db096a1903
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 00:19:09.3587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UjL/aYAdIiNSqYizIgMkUO1CBY5KkqAhZ6TRgokH3ifwP7cy1HcApbgz/vkq/KgzRGlCQOHF0KywuHfp0X6owjEBTieUNemLM2kwa9xO9qo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6975
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTAyLTA3IGF0IDIyOjA3ICswMDAwLCBGYW4gTmkgd3JvdGU6DQo+IE9uIFR1
ZSwgRmViIDA3LCAyMDIzIGF0IDEyOjE2OjI3UE0gLTA3MDAsIFZpc2hhbCBWZXJtYSB3cm90ZToN
Cj4gPiBDb21taXQgM2Q2Y2Q4MjllYzA4ICgiY3hsL3JlZ2lvbjogVXNlIGN4bF9maWx0ZXJfd2Fs
aygpIHRvIGdhdGhlciBjcmVhdGUtcmVnaW9uIHRhcmdldHMiKQ0KPiA+IHJlbW92ZWQgdGhlIGVh
cmx5IHJldHVybiBmb3IgY3JlYXRlLXJlZ2lvbiwgYW5kIHRoaXMgY2F1c2VkIGENCj4gPiBjcmVh
dGUtcmVnaW9uIG9wZXJhdGlvbiB0byB1bm5lY2Vzc2FyaWx5IGxvb3AgdGhyb3VnaCBidXNlcyBh
bmQgcm9vdA0KPiA+IGRlY29kZXJzIG9ubHkgdG8gRUlOVkFMIG91dCBiZWNhdXNlIEFDVElPTl9D
UkVBVEUgaXMgaGFuZGxlZCBvdXRzaWRlIG9mDQo+ID4gdGhlIG90aGVyIGFjdGlvbnMuIFRoaXMg
cmVzdWx0cyBpbiBjb25maXNpbmcgbWVzc2FnZXMgc3VjaCBhczoNCj4gcy9jb25maXNpbmcvY29u
ZnVzaW5nLw0KPiA+IA0KPiA+IMKgICMgY3hsIGNyZWF0ZS1yZWdpb24gLXQgcmFtIC1kIDAuMCAt
bSAwLDQNCj4gPiDCoCB7DQo+ID4gwqDCoMKgICJyZWdpb24iOiJyZWdpb243IiwNCj4gPiDCoMKg
wqAgInJlc291cmNlIjoiMHhmMDMwMDAwMDAwIiwNCj4gPiDCoMKgwqAgInNpemUiOiI1MTIuMDAg
TWlCICg1MzYuODcgTUIpIiwNCj4gPiDCoMKgwqAgLi4uDQo+ID4gwqAgfQ0KPiA+IMKgIGN4bCBy
ZWdpb246IGRlY29kZXJfcmVnaW9uX2FjdGlvbjogcmVnaW9uMDogZmFpbGVkOiBJbnZhbGlkIGFy
Z3VtZW50DQo+ID4gwqAgY3hsIHJlZ2lvbjogcmVnaW9uX2FjdGlvbjogb25lIG9yIG1vcmUgZmFp
bHVyZXMsIGxhc3QgZmFpbHVyZTogSW52YWxpZCBhcmd1bWVudA0KPiA+IMKgIGN4bCByZWdpb246
IGNtZF9jcmVhdGVfcmVnaW9uOiBjcmVhdGVkIDEgcmVnaW9uDQo+ID4gDQo+ID4gU2luY2UgdGhl
cmUncyBubyBuZWVkIHRvIHdhbGsgdGhyb3VnaCB0aGUgdG9wb2xvZ3kgYWZ0ZXIgY3JlYXRpbmcg
YQ0KPiA+IHJlZ2lvbiwgYW5kIGVzcGVjaWFsbHkgbm90IHRvIHBlcmZvcm0gYW4gaW52YWxpZCAn
YWN0aW9uJywgc3dpdGNoDQo+ID4gYmFjayB0byByZXR1ZW5pbmcgZWFybHkgZm9yIGNyZWF0ZS1y
ZWdpb24uDQo+IHMvcmV0dWVuaW5nL3JldHVybmluZy8NCg0KVGhhbmtzIEZhbiEgRml4ZWQgZm9y
IHYyLg0KDQo+ID4gDQo+ID4gRml4ZXM6IDNkNmNkODI5ZWMwOCAoImN4bC9yZWdpb246IFVzZSBj
eGxfZmlsdGVyX3dhbGsoKSB0byBnYXRoZXIgY3JlYXRlLXJlZ2lvbiB0YXJnZXRzIikNCj4gPiBD
YzogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9m
Zi1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+
ID4gwqBjeGwvcmVnaW9uLmMgfCAyICstDQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRp
b24oKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvY3hsL3JlZ2lvbi5j
IGIvY3hsL3JlZ2lvbi5jDQo+ID4gaW5kZXggZWZlMDVhYS4uMzhhYTE0MiAxMDA2NDQNCj4gPiAt
LS0gYS9jeGwvcmVnaW9uLmMNCj4gPiArKysgYi9jeGwvcmVnaW9uLmMNCj4gPiBAQCAtNzg5LDcg
Kzc4OSw3IEBAIHN0YXRpYyBpbnQgcmVnaW9uX2FjdGlvbihpbnQgYXJnYywgY29uc3QgY2hhciAq
KmFyZ3YsIHN0cnVjdCBjeGxfY3R4ICpjdHgsDQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gcmM7DQo+ID4gwqANCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKGFjdGlv
biA9PSBBQ1RJT05fQ1JFQVRFKQ0KPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBy
YyA9IGNyZWF0ZV9yZWdpb24oY3R4LCBjb3VudCwgcCk7DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHJldHVybiBjcmVhdGVfcmVnaW9uKGN0eCwgY291bnQsIHApOw0KPiA+IMKg
DQo+ID4gwqDCoMKgwqDCoMKgwqDCoGN4bF9idXNfZm9yZWFjaChjdHgsIGJ1cykgew0KPiA+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IGN4bF9kZWNvZGVyICpkZWNvZGVy
Ow0KPiA+IA0KPiA+IC0tIA0KPiA+IDIuMzkuMQ0KPiA+IA0KDQo=
