Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6172270
	for <nvdimm@lists.linux.dev>; Fri, 21 May 2021 19:29:29 +0000 (UTC)
IronPort-SDR: wNDW4pAzLLnNO78C16IUInYllt8KYsV4AkrEjGjWB8EmIWKymT0eJRgrv6ym0K4zFnhN4c39Cz
 1K8J35sZeRrw==
X-IronPort-AV: E=McAfee;i="6200,9189,9991"; a="262776794"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="262776794"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 12:29:27 -0700
IronPort-SDR: 3a6fWUzf7lvD02B5SnEf5G+Lpu1w6Uo9Jet3GhUscuiNSMUrRWosq/oTc7LFRbh+CbtP3QNp4b
 rdfVFn2AfEag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="462608889"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2021 12:29:26 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 21 May 2021 12:29:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 21 May 2021 12:29:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 21 May 2021 12:29:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0Z+jtoIe+H+qoidB8cMYSfE0ZVd7sfNTYcEO/8DuKBFgA2Dv829w/KvVDxHmm9i8A2EhOHgJoXjRnsKqd6V7WJgNyxnCFQeOhh/kincbSej8/OvTQlMUYgCGq+zpxdIh6KK8Cte9tMwASw1Tl3d+NOwXV1LG5PAWODdVkctGp71WwGgKcDo1oD+djuWPYRFBtvtKRXkVCxzhYOfxixI/nYzhZQk3a9aWd5ICl3ZF3KGUR5JHeQscT6fd1mNzia7UkQOSeeVS0fTbWDVnwKYTIymIMBWJ7qUznFEMuVIAZxuUVxKOllDUn3T7ql7kVH9GqlrBYB/nqv8OkAVKiLsgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIi75erXlw8FsVh4GqElqbOND/muInkDfR5qSrwZ9OM=;
 b=i/YWECN4xjNof2+eiCDnj6ATe9mxIrWOsJC3sWUNjshmZzzHYJRlMagOW6xuIB0OQSQRN/MxwcFc/wyx3hMiDIn2aFju8FPg5poxo5G2qbK6UFHcYmoxMUBSJe7gDo/vvJN0AnrEqrKtf9TM9JJfkgZUGzRZlMmwygaUgSQCtgbFlxvj04CLVV9ZOzS2CE9isekRzvUOuLsKAataNEi6a1pT5qIujJgBN/WqG5qXQMvE7ABxwbyybqutadypASdkwYEiK6d3DfWTFNyFT2SjYvQnYXiTeptz3QsmGu+V6tB+xKKen7z9st3w+Lkvyw2ZUwPu/p8DqxtmLh8MTR7wKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIi75erXlw8FsVh4GqElqbOND/muInkDfR5qSrwZ9OM=;
 b=Vz+UCFA5o6Xh8PZ8oAieGhGe73QYwuXjRMyKupgffJRUxG2rPmORfverZuAbTzNabXQ59XX94YFp3sxyiPGiXWDJ2WK5vGmcHMoOfuLx7Tvfp0k0LO1ePkuPcvo5C42sR8EAoEqjvBIyh/cD6I6ZGaAYmfdEcpTxv2ClaeMb1l0=
Received: from BYAPR11MB3448.namprd11.prod.outlook.com (2603:10b6:a03:76::21)
 by BY5PR11MB4183.namprd11.prod.outlook.com (2603:10b6:a03:18e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 19:29:16 +0000
Received: from BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::713c:a1f6:aae4:19fc]) by BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::713c:a1f6:aae4:19fc%5]) with mapi id 15.20.4129.035; Fri, 21 May 2021
 19:29:16 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "vaibhav@linux.ibm.com"
	<vaibhav@linux.ibm.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "aneesh.kumar@linux.ibm.com"
	<aneesh.kumar@linux.ibm.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH] libndctl/papr: Add support for reporting
 shutdown-count
Thread-Topic: [ndctl PATCH] libndctl/papr: Add support for reporting
 shutdown-count
Thread-Index: AQHXTjRAfbi+I7rwGEakBWNwkTzR46ruUsKA
Date: Fri, 21 May 2021 19:29:16 +0000
Message-ID: <b7aa19188447306e649bb05f04fb4deeaee3e92d.camel@intel.com>
References: <20210521112649.417210-1-vaibhav@linux.ibm.com>
In-Reply-To: <20210521112649.417210-1-vaibhav@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.1 (3.40.1-1.fc34) 
authentication-results: lists.linux.dev; dkim=none (message not signed)
 header.d=none;lists.linux.dev; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.139.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6519a4d3-0318-46d4-9558-08d91c8eb92d
x-ms-traffictypediagnostic: BY5PR11MB4183:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB41832C8912EA84266523F251C7299@BY5PR11MB4183.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sn3iozWe/9Y9CdQvgekvAcxUpbsN1BWvZNJOJ0tDfysdHUO8REy7lWR26IWOwkArQ93oheUM8jas82WYQOOfZF21yuREK9Z5EO5HDjDpe4eiGqDmQzzT9YLoPpt0jEI1e0i3Qgh7KHQ7dpZiu1RqpQonbriOJecpSi4FWtSp4eyRWJ5pWafGzUYJmZTsa5NVxaEnPT9oKPr/aJHH4Vg0zKiJv31+u8n35n+i4bZXEPTP83/a8/5pdV9WY7wS1laQVWBGO2VosS1qdrWdEDKLVkWx+4n3QtCXyyVRpOFuMH9XUmPbgL79AXvVBYB9ShtXC3CfiYlp4y6ezVXMHQOQaklQq3yGHw4y1VC+eVOfr0lY4x8p31DtE68tc7ewOQo1nhI2g17ImCsQDXFWLtCGkCPbXzDLenjABOxb1McHLaPaTYnSc0TqPOgNVofOy+TsdxJU+SAOZbsxe6sTx1WE56jdG3TgSsu0uEigg7Bmh2XI9r1yshDxyAmx+9IJ5XeoXuTJvtOiDQklPJMRPGmm5/8kU9paxPSUWUNWOIUb8RoE7T/5i4gamw2Dyz92fUA4hhfUDaT5vqmcDIQypNc/vYtZhiCgR6AsxDhWXcRBsJ6p2W2PEgubHFwdtM4yXBRNWk5r5Z6sxMZ7oO2b8Q9y1kMSdulIOKKf6swhPqVtVnXcev8LBpoxKE++MhQ16dwdXDkZqnMx01i6B1NorHQDeVX35uFU8f6AvU9rXg0ChXs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3448.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38100700002)(110136005)(498600001)(5660300002)(36756003)(4326008)(86362001)(71200400001)(64756008)(122000001)(8936002)(2906002)(8676002)(6506007)(76116006)(91956017)(966005)(6512007)(66946007)(186003)(54906003)(26005)(66446008)(66476007)(6486002)(66556008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Z1dDL3dLeVZxZjZZUHRGSTVaYnNlRy83TkovR3ZVZ3Y2LzlnMzFPWWVrOTV1?=
 =?utf-8?B?OXNURXZoUkNSRmJDMTZCL0IyZ3IxVzVqOHNpMWw4WFhEcXgwWWhJK2dieE0z?=
 =?utf-8?B?Yk1tbC9tNDV6S3ZxbGZuczgwWXhFdGhzSjNWZTAxakljaG9iTzRGbUpGY0hx?=
 =?utf-8?B?cGlqVDhadmZBTk1WRnZZaXQvRE43YU9YcDF6QXNtZTdhWFEzcGJvbmVGWlpR?=
 =?utf-8?B?WG9QOVpiRG5SMWU1TS9nRnF6VW43VndWR2o0VG95MTR1V3RtbExrWS9RZzBx?=
 =?utf-8?B?d2IwZW5iMGVPNEtucVFFamkrOHArbFZVb1YwNXk4Z0gwclVuV1M2VDFDYjIy?=
 =?utf-8?B?UG1IbXE4aWRWdFlwMWpZb0lXNHdMVDhUbGsyb3plL1NXSFdQMm5VRFlBMVBx?=
 =?utf-8?B?Vm9hZ3o2YlJXN2FBVk1BRnlUOHFPVTZoNGhFU0p5OUdQRFg0ZFo3NzBtQXI0?=
 =?utf-8?B?cFB3VVZtZnJBQWZsb0oxU2hzNWxUOXgvZmcram1hMFVXWUVPY2pJV1hrK08y?=
 =?utf-8?B?bndaU01XOHNydGNTdUhyUDJaSVlITzVqTzJTTnk3c0pQdVFZTTNZdEZFdlEy?=
 =?utf-8?B?MEhqKy9WYTlidEZSa3ZSZUc0WkRwZEVrYjU3bUJ3cnlqUHhpc1E5TmhteGJI?=
 =?utf-8?B?Tm1ZUkQvaXlpMDR4NXBGUTQ2UXFaaUt0Q2EzZWFBZmxRdHFBWjZzLy91RGto?=
 =?utf-8?B?dVBVZ2YxSW1zcGRsV0h4N2RSUU4wWEhzRStrZHV1dFF5WEJUT01HMmlxZ25T?=
 =?utf-8?B?NUpsbGowMmlORitKSm0zbFRmMVdNbWpQVXBIN3NxNDM5c3NIMW9VY2JDVFYy?=
 =?utf-8?B?SkI2K1JNNWRuQzY1ZFFNYWwzQmZsMWo4M1BSRGJSNmxnK1E3UWdUU3ZqdWFa?=
 =?utf-8?B?TVZHbGp6TTRidytod2ZXOGF6VDZoNlBTOFNkbTVwVXl5NE83Zldocm9uU3Za?=
 =?utf-8?B?NENLTnk0L0FweGZ5T29kQTc1VW5oWTEwL29WdzJTK0hBQnBmaFZwRHlSN2xY?=
 =?utf-8?B?OUVRenhlVkYyQ3NTMnlJaTZScTlIL1Y0Nmg4dWZNV3JNaU9mTVlvUzEwKzdQ?=
 =?utf-8?B?Zlp5L3FWZXFqaXEwcXlSejJZNHB0TUdUakpEcHlRNGp6bWo0aEFKaU80blRY?=
 =?utf-8?B?OEFmNGZPMHZQYWVZYjVEcGU1UFg2MVpQRzFLS05Edi9maFE2dVZtT2ZQc1ZL?=
 =?utf-8?B?NjBEWlZtTmQvSUwrY0pyU2RJeTVTcHRzUldKVVZVVmVEYzFieWVoUkd4Ynhk?=
 =?utf-8?B?ZHQ0R3ZFWkVsUWZHOWlmVG5MSXArWHZ1UDJhallvS3NVN0VrbEd4TEs5ZWcz?=
 =?utf-8?B?S0MwcXZBSDByOG90WUplM2haOEIvL3RVeHFvRmtnZTloK0lnbFMwbzNlKyth?=
 =?utf-8?B?elFCUGhmSXNHZmxkVkNIWFdvRmZmU0lzYmd0aXdFb0ZMYWdUL2ZSMmpUL1Jz?=
 =?utf-8?B?Q216QkJVeFU5WmhWZURIemNGWTBaMVVEVUx1VFIrUFYvdzgxMkYzMHN1YW1K?=
 =?utf-8?B?RzZkdkt1UHhhT0QwZXBBQmVjb1kzTFJMMGVFUTJYdVorRURKOEx5dWRrODhP?=
 =?utf-8?B?MmVPcW9wYUJXU2t6TDVlVlVxbnFoZVQ1WkFCR29vQlZKRzQyZWV2d2g1NGFq?=
 =?utf-8?B?V3YrVzFjZkJCNmJIYWxReE1GL2JlNjlVOGJJbVJTa1RDZWgrVURtcjVINXR3?=
 =?utf-8?B?aUF5L1RLaCtid1l6cTJEbEkvM2t1TUIyWm5nV20zdXhSbm1VOW5lajB5ZUNw?=
 =?utf-8?B?TTNSY1dqTXFTVmUraEh4Q3FwcFUwd0VMRVZqRHU1SGVySnRIbGpjczNJZ1N0?=
 =?utf-8?B?cVl6V0k1N2Z0THBEWFV6QT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3EBB82E505875E4DA15AF9E60C4C2C4B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3448.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6519a4d3-0318-46d4-9558-08d91c8eb92d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2021 19:29:16.6192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +0uctM3+gwxGf/EzE8eL7bp3uhrfSX+M5ODVnlMLvlSJySexNLsn4+Vv0EvFh3jH/NzMu4LIfs+U+j3bKyv7d5QQwsl9ozIJfTScJtyn7co=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4183
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIxLTA1LTIxIGF0IDE2OjU2ICswNTMwLCBWYWliaGF2IEphaW4gd3JvdGU6DQo+
IEFkZCBzdXBwb3J0IGZvciByZXBvcnRpbmcgZGlydHktc2h1dGRvd24tY291bnQgKERTQykgZm9y
IFBBUFIgYmFzZWQNCj4gTlZESU1Ncy4gVGhlIHN5c2ZzIGF0dHJpYnV0ZSBleHBvc2luZyB0aGlz
IHZhbHVlIGlzIGxvY2F0ZWQgYXQNCj4gbm1lbVgvcGFwci9kaXJ0eV9zaHV0ZG93bi4NCj4gDQo+
IFRoaXMgY291bnRlciBpcyBhbHNvIHJldHVybmVkIGluIHBheWxvYWQgZm9yIFBBUFJfUERTTV9I
RUFMVEggYXMgbmV3bHkNCj4gaW50cm9kdWNlZCBtZW1iZXIgJ2RpbW1fZHNjJyBpbiAnc3RydWN0
IG5kX3BhcHJfcGRzbV9oZWFsdGgnLiBQcmVzZW5jZQ0KPiBvZiAnRFNDJyBpcyBpbmRpY2F0ZWQg
YnkgdGhlIFBEU01fRElNTV9EU0NfVkFMSUQgZXh0ZW5zaW9uIGZsYWcuDQo+IA0KPiBUaGUgcGF0
Y2ggaW1wbGVtZW50cyAnbmRjdGxfZGltbV9vcHMuc21hcnRfZ2V0X3NodXRkb3duX2NvdW50Jw0K
PiBjYWxsYmFjayBpbiBpbXBsZW1lbnRlZCBhcyBwYXByX3NtYXJ0X2dldF9zaHV0ZG93bl9jb3Vu
dCgpLg0KPiANCj4gS2VybmVsIHNpZGUgY2hhbmdlcyB0byBzdXBwb3J0IHJlcG9ydGluZyBEU0Mg
aGF2ZSBiZWVuIHByb3Bvc2VkIGF0DQo+IFsxXS4gV2l0aCB1cGRhdGVkIGtlcm5lbCAnbmRjdGwg
bGlzdCAtREgnIHJlcG9ydHMgZm9sbG93aW5nIG91dHB1dCBvbg0KPiBQUEM2NDoNCj4gDQo+ICQg
c3VkbyBuZGN0bCBsaXN0IC1ESA0KPiBbDQo+ICAgew0KPiAgICAgImRldiI6Im5tZW0wIiwNCj4g
ICAgICJoZWFsdGgiOnsNCj4gICAgICAgImhlYWx0aF9zdGF0ZSI6Im9rIiwNCj4gICAgICAgImxp
ZmVfdXNlZF9wZXJjZW50YWdlIjo1MCwNCj4gICAgICAgInNodXRkb3duX3N0YXRlIjoiY2xlYW4i
LA0KPiAgICAgICAic2h1dGRvd25fY291bnQiOjEwDQo+ICAgICB9DQo+ICAgfQ0KPiBdDQo+IA0K
PiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9udmRpbW0vMjAyMTA1MjExMTEwMjMuNDEz
NzMyLTEtdmFpYmhhdkBsaW51eC5pYm0uY29tDQoNCkknZCBzdWdnZXN0IGp1c3QgdXNpbmcgJ1sx
XTogPGh0dHBzOi8vbG9yZS4uLi4nICBmb3IgdGhpcy4gVGhlIExpbms6DQp0cmFpbGVyIGlzIGFk
ZGVkIGJ5ICdiNCcgd2hlbiBJIGFwcGx5IHRoaXMgcGF0Y2gsIGFuZCBwb2ludHMgdG8gdGhpcw0K
cGF0Y2ggb24gbG9yZS4gSXQgd291bGQgYmUgY29uZnVzaW5nIHRvIGhhdmUgdHdvIExpbms6IHRy
YWlsZXJzDQpwb2ludGluZyB0byBkaWZmZXJlbnQgdGhpbmdzLg0KDQo+IFNpZ25lZC1vZmYtYnk6
IFZhaWJoYXYgSmFpbiA8dmFpYmhhdkBsaW51eC5pYm0uY29tPg0KPiAtLS0NCj4gIG5kY3RsL2xp
Yi9saWJuZGN0bC5jICB8ICA2ICsrKysrLQ0KPiAgbmRjdGwvbGliL3BhcHIuYyAgICAgIHwgMjMg
KysrKysrKysrKysrKysrKysrKysrKysNCj4gIG5kY3RsL2xpYi9wYXByX3Bkc20uaCB8ICA2ICsr
KysrKw0KPiAgMyBmaWxlcyBjaGFuZ2VkLCAzNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
DQoNClRoZSBwYXRjaCBsb29rcyBva2F5IHRvIG1lIC0gYnV0IEkgYXNzdW1lIGl0IGRlcGVuZHMg
b24gdGhlIGtlcm5lbA0KaW50ZXJmYWNlcyBub3QgY2hhbmdpbmcgaW4gdGhlIHBhdGNoIHJlZmVy
ZW5jZWQgYWJvdmUuIFNob3VsZCBJIHB1dA0KdGhpcyBvbiBob2xkIHVudGlsIHRoZSBrZXJuZWwg
c2lkZSBpcyBhY2NlcHRlZD8NCg0KPiANCj4gZGlmZiAtLWdpdCBhL25kY3RsL2xpYi9saWJuZGN0
bC5jIGIvbmRjdGwvbGliL2xpYm5kY3RsLmMNCj4gaW5kZXggYWEzNmEzYzg3YzU3Li42ZWU0MjZh
ZTMwZTEgMTAwNjQ0DQo+IC0tLSBhL25kY3RsL2xpYi9saWJuZGN0bC5jDQo+ICsrKyBiL25kY3Rs
L2xpYi9saWJuZGN0bC5jDQo+IEBAIC0xNzk1LDggKzE3OTUsMTIgQEAgc3RhdGljIGludCBhZGRf
cGFwcl9kaW1tKHN0cnVjdCBuZGN0bF9kaW1tICpkaW1tLCBjb25zdCBjaGFyICpkaW1tX2Jhc2Up
DQo+ICANCj4gIAkJLyogQWxsb2NhdGUgbW9uaXRvciBtb2RlIGZkICovDQo+ICAJCWRpbW0tPmhl
YWx0aF9ldmVudGZkID0gb3BlbihwYXRoLCBPX1JET05MWXxPX0NMT0VYRUMpOw0KPiAtCQlyYyA9
IDA7DQo+ICsJCS8qIEdldCB0aGUgZGlydHkgc2h1dGRvd24gY291bnRlciB2YWx1ZSAqLw0KPiAr
CQlzcHJpbnRmKHBhdGgsICIlcy9wYXByL2RpcnR5X3NodXRkb3duIiwgZGltbV9iYXNlKTsNCj4g
KwkJaWYgKHN5c2ZzX3JlYWRfYXR0cihjdHgsIHBhdGgsIGJ1ZikgPT0gMCkNCj4gKwkJCWRpbW0t
PmRpcnR5X3NodXRkb3duID0gc3RydG9sbChidWYsIE5VTEwsIDApOw0KPiAgDQo+ICsJCXJjID0g
MDsNCj4gIAl9IGVsc2UgaWYgKHN0cmNtcChidWYsICJudmRpbW1fdGVzdCIpID09IDApIHsNCj4g
IAkJLyogcHJvYmUgdmlhIGNvbW1vbiBwb3B1bGF0ZV9kaW1tX2F0dHJpYnV0ZXMoKSAqLw0KPiAg
CQlyYyA9IHBvcHVsYXRlX2RpbW1fYXR0cmlidXRlcyhkaW1tLCBkaW1tX2Jhc2UsICJwYXByIik7
DQo+IGRpZmYgLS1naXQgYS9uZGN0bC9saWIvcGFwci5jIGIvbmRjdGwvbGliL3BhcHIuYw0KPiBp
bmRleCA5YzZmMmYwNDVmYzIuLjQyZmYyMDBkYzU4OCAxMDA2NDQNCj4gLS0tIGEvbmRjdGwvbGli
L3BhcHIuYw0KPiArKysgYi9uZGN0bC9saWIvcGFwci5jDQo+IEBAIC0xNjUsNiArMTY1LDkgQEAg
c3RhdGljIHVuc2lnbmVkIGludCBwYXByX3NtYXJ0X2dldF9mbGFncyhzdHJ1Y3QgbmRjdGxfY21k
ICpjbWQpDQo+ICAJCWlmIChoZWFsdGguZXh0ZW5zaW9uX2ZsYWdzICYgUERTTV9ESU1NX0hFQUxU
SF9SVU5fR0FVR0VfVkFMSUQpDQo+ICAJCQlmbGFncyB8PSBORF9TTUFSVF9VU0VEX1ZBTElEOw0K
PiAgDQo+ICsJCWlmIChoZWFsdGguZXh0ZW5zaW9uX2ZsYWdzICYgIFBEU01fRElNTV9EU0NfVkFM
SUQpDQo+ICsJCQlmbGFncyB8PSBORF9TTUFSVF9TSFVURE9XTl9DT1VOVF9WQUxJRDsNCj4gKw0K
PiAgCQlyZXR1cm4gZmxhZ3M7DQo+ICAJfQ0KPiAgDQo+IEBAIC0yMzYsNiArMjM5LDI1IEBAIHN0
YXRpYyB1bnNpZ25lZCBpbnQgcGFwcl9zbWFydF9nZXRfbGlmZV91c2VkKHN0cnVjdCBuZGN0bF9j
bWQgKmNtZCkNCj4gIAkJKDEwMCAtIGhlYWx0aC5kaW1tX2Z1ZWxfZ2F1Z2UpIDogMDsNCj4gIH0N
Cj4gIA0KPiArc3RhdGljIHVuc2lnbmVkIGludCBwYXByX3NtYXJ0X2dldF9zaHV0ZG93bl9jb3Vu
dChzdHJ1Y3QgbmRjdGxfY21kICpjbWQpDQo+ICt7DQo+ICsNCj4gKwlzdHJ1Y3QgbmRfcGFwcl9w
ZHNtX2hlYWx0aCBoZWFsdGg7DQo+ICsNCj4gKwkvKiBJZ25vcmUgaW4gY2FzZSBvZiBlcnJvciBv
ciBpbnZhbGlkIHBkc20gKi8NCj4gKwlpZiAoIWNtZF9pc192YWxpZChjbWQpIHx8DQo+ICsJICAg
IHRvX3Bkc20oY21kKS0+Y21kX3N0YXR1cyAhPSAwIHx8DQo+ICsJICAgIHRvX3Bkc21fY21kKGNt
ZCkgIT0gUEFQUl9QRFNNX0hFQUxUSCkNCj4gKwkJcmV0dXJuIDA7DQo+ICsNCj4gKwkvKiBnZXQg
dGhlIHBheWxvYWQgZnJvbSBjb21tYW5kICovDQo+ICsJaGVhbHRoID0gdG9fcGF5bG9hZChjbWQp
LT5oZWFsdGg7DQo+ICsNCj4gKwlyZXR1cm4gKGhlYWx0aC5leHRlbnNpb25fZmxhZ3MgJiBQRFNN
X0RJTU1fRFNDX1ZBTElEKSA/DQo+ICsJCShoZWFsdGguZGltbV9kc2MpIDogMDsNCj4gKw0KPiAr
fQ0KPiArDQo+ICBzdHJ1Y3QgbmRjdGxfZGltbV9vcHMgKiBjb25zdCBwYXByX2RpbW1fb3BzID0g
JihzdHJ1Y3QgbmRjdGxfZGltbV9vcHMpIHsNCj4gIAkuY21kX2lzX3N1cHBvcnRlZCA9IHBhcHJf
Y21kX2lzX3N1cHBvcnRlZCwNCj4gIAkuc21hcnRfZ2V0X2ZsYWdzID0gcGFwcl9zbWFydF9nZXRf
ZmxhZ3MsDQo+IEBAIC0yNDUsNCArMjY3LDUgQEAgc3RydWN0IG5kY3RsX2RpbW1fb3BzICogY29u
c3QgcGFwcl9kaW1tX29wcyA9ICYoc3RydWN0IG5kY3RsX2RpbW1fb3BzKSB7DQo+ICAJLnNtYXJ0
X2dldF9oZWFsdGggPSBwYXByX3NtYXJ0X2dldF9oZWFsdGgsDQo+ICAJLnNtYXJ0X2dldF9zaHV0
ZG93bl9zdGF0ZSA9IHBhcHJfc21hcnRfZ2V0X3NodXRkb3duX3N0YXRlLA0KPiAgCS5zbWFydF9n
ZXRfbGlmZV91c2VkID0gcGFwcl9zbWFydF9nZXRfbGlmZV91c2VkLA0KPiArCS5zbWFydF9nZXRf
c2h1dGRvd25fY291bnQgPSBwYXByX3NtYXJ0X2dldF9zaHV0ZG93bl9jb3VudCwNCj4gIH07DQo+
IGRpZmYgLS1naXQgYS9uZGN0bC9saWIvcGFwcl9wZHNtLmggYi9uZGN0bC9saWIvcGFwcl9wZHNt
LmgNCj4gaW5kZXggMWJhYzhhN2ZjOTMzLi5mNDViMWU0MGMwNzUgMTAwNjQ0DQo+IC0tLSBhL25k
Y3RsL2xpYi9wYXByX3Bkc20uaA0KPiArKysgYi9uZGN0bC9saWIvcGFwcl9wZHNtLmgNCj4gQEAg
LTc1LDYgKzc1LDkgQEANCj4gIC8qIEluZGljYXRlIHRoYXQgdGhlICdkaW1tX2Z1ZWxfZ2F1Z2Un
IGZpZWxkIGlzIHZhbGlkICovDQo+ICAjZGVmaW5lIFBEU01fRElNTV9IRUFMVEhfUlVOX0dBVUdF
X1ZBTElEIDENCj4gIA0KPiArLyogSW5kaWNhdGUgdGhhdCB0aGUgJ2RpbW1fZHNjJyBmaWVsZCBp
cyB2YWxpZCAqLw0KPiArI2RlZmluZSBQRFNNX0RJTU1fRFNDX1ZBTElEIDINCj4gKw0KPiAgLyoN
Cj4gICAqIFN0cnVjdCBleGNoYW5nZWQgYmV0d2VlbiBrZXJuZWwgJiBuZGN0bCBpbiBmb3IgUEFQ
Ul9QRFNNX0hFQUxUSA0KPiAgICogVmFyaW91cyBmbGFncyBpbmRpY2F0ZSB0aGUgaGVhbHRoIHN0
YXR1cyBvZiB0aGUgZGltbS4NCj4gQEAgLTEwMyw2ICsxMDYsOSBAQCBzdHJ1Y3QgbmRfcGFwcl9w
ZHNtX2hlYWx0aCB7DQo+ICANCj4gIAkJCS8qIEV4dGVuc2lvbiBmbGFnIFBEU01fRElNTV9IRUFM
VEhfUlVOX0dBVUdFX1ZBTElEICovDQo+ICAJCQlfX3UxNiBkaW1tX2Z1ZWxfZ2F1Z2U7DQo+ICsN
Cj4gKwkJCS8qIEV4dGVuc2lvbiBmbGFnIFBEU01fRElNTV9EU0NfVkFMSUQgKi8NCj4gKwkJCV9f
dTY0IGRpbW1fZHNjOw0KPiAgCQl9Ow0KPiAgCQlfX3U4IGJ1ZltORF9QRFNNX1BBWUxPQURfTUFY
X1NJWkVdOw0KPiAgCX07DQoNCg==
