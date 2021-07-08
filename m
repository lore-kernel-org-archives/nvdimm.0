Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ABB168
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 06:34:49 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="189132248"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="189132248"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 23:34:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="428229162"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 07 Jul 2021 23:34:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 7 Jul 2021 23:34:48 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 7 Jul 2021 23:34:48 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 7 Jul 2021 23:34:48 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 7 Jul 2021 23:34:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CoNQzMw9BuUy2d2MzGKcavOvq2LNJk/wvkrv+Zh3XUKSFti9ZgCCznGfODxeWinqXOuKjEfQTSKB8wyVsg6SITrWGLdnKakgd5oIcE1NRk8KoUpd8/J4sn66WD7C33XL8sazorX1gLytpC8SaOePrZIJwOdvM5mZVJg2818aURnyTTuJWPW0YREPJCE3UNcS84HyPPY7R1i3TIhOBm4QUKx1PIy+vh66Skpv+DR8MVURtWyjVSTwpW8Y9V31yhndRbGgwucuShpMX2kcRPvJ4rqM4KTx6vZCGXFzHj268HG+OxqdC0osVK/m29QMa6SBy2E25ofbbHdHOVP1oHDr+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbqMazzmYwuyfjm/seSdrx9eaX9MPORGVDAM9HXKKWU=;
 b=ZdYFMgjIxRaLZ4fuqMvL0ETVU28odFeGC3jto904f177I1xSJVOo5KS5jnF1G9qJxl9iIGSmUTudUREnSnVnN0rvr2yfEYc/LMNobKxwt8Fh/A6WgXFat2/+viZTsbJ4ze8I67jAnkvblNyffNNI53OJ5o4lx2BC4W02BG5+pfIcrj1ECUNbGPa8iE7wqZ/9KqogEWpe+f3AYseqvWxcpw96JTUhpuJBh356lmwk9zO0WM+sW9Cn/Zu/giVpL5Uy+nKQ2oQpqduUXNZGEcHYp3/fickYRo8w+lzLZ3N3N97/eR0iVddjZ4GbGiqPSkcGwO45Ew2Ioy92X4Abqzv83Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbqMazzmYwuyfjm/seSdrx9eaX9MPORGVDAM9HXKKWU=;
 b=gbiv/GqKwQmLP6VWNwNaMDny/QtyRz+bPlh7IhPZ5OSwIcpNcZfhMATQD/CSmlf4L47VDuabMba2YDo6hKprWE6FFpJLanfAqo2t5EpFec8NRlR4frtHV8wOtEEt/s3b/147QAnuUmXnaA52k6wIWQi/a6B9W0dcofQ6VgTesIQ=
Received: from BYAPR11MB3448.namprd11.prod.outlook.com (2603:10b6:a03:76::21)
 by BYAPR11MB3766.namprd11.prod.outlook.com (2603:10b6:a03:b5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Thu, 8 Jul
 2021 06:34:45 +0000
Received: from BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::de7:9279:792c:4d75]) by BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::de7:9279:792c:4d75%3]) with mapi id 15.20.4287.034; Thu, 8 Jul 2021
 06:34:45 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "qi.fuli@fujitsu.com"
	<qi.fuli@fujitsu.com>
CC: "fukuri.sai@gmail.com" <fukuri.sai@gmail.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [RFC ndctl PATCH 0/3] Rename monitor.conf to ndctl.conf as a
 ndctl global config file
Thread-Topic: [RFC ndctl PATCH 0/3] Rename monitor.conf to ndctl.conf as a
 ndctl global config file
Thread-Index: AQHXSqlKyo+afcskpkCQhHQX0SuPA6sAS6UAgAC82ACAAAgGgIAWeKgAgCFoLwA=
Date: Thu, 8 Jul 2021 06:34:45 +0000
Message-ID: <9a5bb205bca971f3f806bcbfa5bcf76bbdc3b306.camel@intel.com>
References: <20210516231427.64162-1-qi.fuli@fujitsu.com>
	 <0e2b6f25a3ba8d20604f8c3aa4d8854ade0835c4.camel@intel.com>
	 <CAPcyv4inknvApE1xZOiK8u2xPLejuqixf_XKbS05fPKvno+Yyg@mail.gmail.com>
	 <98516fb56623180b78bce2a6a15103023a59b884.camel@intel.com>
	 <TYCPR01MB6461A39B4E076F0921335904F70E9@TYCPR01MB6461.jpnprd01.prod.outlook.com>
In-Reply-To: <TYCPR01MB6461A39B4E076F0921335904F70E9@TYCPR01MB6461.jpnprd01.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.2 (3.40.2-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 351f48ae-db00-4057-f1e7-08d941da7a1c
x-ms-traffictypediagnostic: BYAPR11MB3766:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB376665397D62AF44ED85154FC7199@BYAPR11MB3766.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ncXit7lVM2QwPxoZqBRp4+2PfH5F+xS1Vx3/aLz8NGGFOvPF95M3Ia0cRQLg20Dd1qWGQUsn20y7SHjb5pWC/Zz58W/mDc0PY71e1VjZhpRqPS09MU7szM2+oM8RdHXzK1ahDuurWn+1AKk1AS8/Zg8PvL7hm968YqDIN7KhnnXaqvilYTgsk/+vtEhiU3KSUiRCkcSmjl7kz7i12rq8A9UmSpYej3qReOFVZc87jWZSsnOjYM7T/Yrq8KHS/0HcOJIZhUVNVtMtUyorUcmnsfQ629x7Z174kaT0bunGdToxDH8tmFzrRNHCPrpQGBiamOqH9A0QwgclBRwUikCFzgXzKBIJOfekeo/Ph7s6bqKJ8flkTolwM2KvBwTpdutLbIbBzycJWQrkfEg8Cc/E1ZlUepUPIz2xLYoS6AAqUJAo530qZZodbtDEqh+Av4DtYIl23ZwpRrFyyvSYac9x0ogGa1FVKF3QrL96hNTm56gL1g9BIZ/YIyxVs7/sl7RZ035Mp/EV/H8Voqxg8D7M5muJFwUitVL16qZAjmzlm5a1w9/eJZQ9B5EOKw3w/DC3/GoDrd0kyX1Myl/4/Dl1ZfCIAOW8y+gsdBv6VLHRXWg3Uw3tVgQqw9YRf+BrAdKAqdJtsHcrMOtqgvkpJf1JnA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3448.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(396003)(39860400002)(366004)(8676002)(53546011)(36756003)(5660300002)(66446008)(66476007)(76116006)(66946007)(66556008)(83380400001)(26005)(64756008)(316002)(4326008)(71200400001)(6486002)(8936002)(478600001)(2906002)(6506007)(2616005)(86362001)(38100700002)(110136005)(6512007)(54906003)(122000001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmxPTnRodWVXcmlWR2hLNThtOTlwa2xib1dlVWRwT2lZUHhHK0diRzBaL21Y?=
 =?utf-8?B?NlZmYlhaRkkwNnZXQ1d4T051Z09wbTVtQkcwYWY2NVZOdE1qTUNrU1J4SnZu?=
 =?utf-8?B?VkQyK25mdjJrMlpJSDlXL1duVU93R09WOFFjNTYwZUptcVpFYlhaQ3pSVWcx?=
 =?utf-8?B?bExPUWU3b3duT1VLaUl2VG5La1BSaDU3LzlBaU1ncXI2ZUNoWDlOWitBSDJZ?=
 =?utf-8?B?NFk1cnBPOWdqeHlDdkJGMzVXN2JYOFNDdUlaalBzUFM0Z0ZnVy81SGJEZjZE?=
 =?utf-8?B?ZWVRSjZtdVo4S2xDZFpJQXBaVVdoTFNtbG43ZjV0Sy85NWJHcGhIWS9OMkts?=
 =?utf-8?B?TlI3dWlHOG4xZ0NZQ0pGbUNZeHdIUkg5czdwbThVWmNaemFrc0VtRnpwT2cr?=
 =?utf-8?B?QXVSV1Bub1FBR1JnOFg0dEhCUldwaFlybjdXYmVRRFJHUE1RY2tNSmNsRzVV?=
 =?utf-8?B?WVdrd29tak91NmpsK3IxcTJQa1RhNWR0YkdFZnFRem9tbmdsSnR6ZENvOFB6?=
 =?utf-8?B?UVdsU2JNUWVtcUcrcEN0aWVzNUErbkhtcENsUy9rd0JYWXdGazh4cEZVcC9x?=
 =?utf-8?B?RjFOMnNmaVNCRWlhQ052Sno4dlcyWkVFQWpuNWpUUk8yNGFxMVd2MCt1eEwv?=
 =?utf-8?B?Q0dNNG83RnZXTW4ybFI5TVkvTUdKNXh3SEphcHhJRldJbkp5d2NOcUUrc0Qy?=
 =?utf-8?B?R2N4QVREQjVNOFp1L0pOQStWNjdoV3liVVlTNGpQYlo5eHhqSVhuWTgvOFVl?=
 =?utf-8?B?N1dVdk1RT0lLNDZaMHFuWlVLQ3NQdjhSVEJ4VVRuY1I2MmZVeWZVV214NXJs?=
 =?utf-8?B?QjRjQnFNZFZueXdtUU45TFB6czJ5V0NLdVBnbmdRZlMvMVJWWUU0RnU1T05r?=
 =?utf-8?B?UGlRN0NwVkhET3JEK0U0VVpQRG5WZFlLUkVmNTJIRk5kN3hHTGVBc1NFMFFC?=
 =?utf-8?B?R3IrdkdjMlp6T0d1eUF1NUkwNnhUdFdSOU1kWXhkYWhER0JoaTRudWw3ZEVu?=
 =?utf-8?B?blRqZzdOMm5OelNQZDJJcmRxeks0dXNkeTY1RDZMVGhoSzh2MmsyVHdwZGgz?=
 =?utf-8?B?bVZOeWtHYXFZbmRqcVdzQ21vYiszV2cxbW1JQkRQdTJLakd0c1d5YmZCZHk4?=
 =?utf-8?B?WGNDZUR0Z3kzSlZBc2hyUXJzYVhSMmZVb2VNSnFwV1JXVUJ4bHNZSjVtOS93?=
 =?utf-8?B?WDZKcjVLSm82c3RWKzVieHZrckhvSDlPQURhR1hyZE5UeXhDSlRlQnJ1Z2Nu?=
 =?utf-8?B?b2Q5NkY3M2thZmRGTmtheWhSZ053b3k1S2hzaDZtZis1NmNzdmI3ZVViSkk0?=
 =?utf-8?B?cFRabnhuYmEzTko2K0Y3MEVWWjZYWmN2dWpaNGNZejBLRlhaMjFDQXFvTS9H?=
 =?utf-8?B?Y3ZyOThpNlZ0UFYraktWdU1GZGNMcUJTQlVzZml2UkhCSW9OSzMrYnhxSTlR?=
 =?utf-8?B?NzNGMUNrN3FJY2QweXQ3S05HSkUrcEN2dm5pMHRVci9xRnJmOUF0UjIycS83?=
 =?utf-8?B?UzY3TGNzc3h2SU85NHFmZWpISjBod3ZGVlJKbTVtaTRjT1JHL3VsNkRCaTQy?=
 =?utf-8?B?eUJicUlKc2krcklvMWRmc0VodGxRbERzSlpjbjE4Ry9VdFB5a20zU2tKUitK?=
 =?utf-8?B?Z0FaYktoZzRpenExSnVmRXlEMk1zdkRNUW0vRjVwSmpHZkxZb1Q2NzJJUTNn?=
 =?utf-8?B?R09SaDI5VkVGZ3VlS2ViRnlrM3hVbFdpSVZMV3MyS2tzV0RtWmd4T0VmdzZq?=
 =?utf-8?B?RzZzaEptZVNGb3liUlRzSnlvM2RkU2RGc2U1KzdvSTlPeEZMNnFiWGlucnd3?=
 =?utf-8?B?V2tLMEtrYnNRdm14d2dGUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <727B6E89E5F84440A04929FE5116C7AB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3448.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 351f48ae-db00-4057-f1e7-08d941da7a1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 06:34:45.5539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NwNOw0FwlzxSwL0D7B/EbMV5WqFOLubsHpp3kIvcNdZungR2FZTd89Bw/ANoKB0vOClQjQxuIhEc8QIZtMhCOpMb45+U6t2+1GS8DRp78dE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3766
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTA2LTE3IGF0IDAwOjI1ICswMDAwLCBxaS5mdWxpQGZ1aml0c3UuY29tIHdy
b3RlOg0KPiA+IE9uIFdlZCwgMjAyMS0wNi0wMiBhdCAwOTo0NyAtMDcwMCwgRGFuIFdpbGxpYW1z
IHdyb3RlOg0KPiA+ID4gT24gVHVlLCBKdW4gMSwgMjAyMSBhdCAxMDozMSBQTSBWZXJtYSwgVmlz
aGFsIEwNCj4gPiA+IDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gPiAN
Cj4gPiA+ID4gW3N3aXRjaGluZyB0byB0aGUgbmV3IG1haWxpbmcgbGlzdF0NCj4gPiA+ID4gDQo+
ID4gPiA+IE9uIE1vbiwgMjAyMS0wNS0xNyBhdCAwODoxNCArMDkwMCwgUUkgRnVsaSB3cm90ZToN
Cj4gPiA+ID4gPiBGcm9tOiBRSSBGdWxpIDxxaS5mdWxpQGZ1aml0c3UuY29tPg0KPiA+ID4gPiA+
IA0KPiA+ID4gPiA+IFRoaXMgcGF0Y2ggc2V0IGlzIHRvIHJlbmFtZSBtb25pdG9yLmNvbmYgdG8g
bmRjdGwuY29uZiwgYW5kIG1ha2UNCj4gPiA+ID4gPiBpdCBhIGdsb2JhbCBuZGN0bCBjb25maWd1
cmF0aW9uIGZpbGUgdGhhdCBhbGwgbmRjdGwgY29tbWFuZHMgY2FuIHJlZmVyIHRvLg0KPiA+ID4g
PiA+IA0KPiA+ID4gPiA+IEFzIHRoaXMgcGF0Y2ggc2V0IGhhcyBiZWVuIHBlbmRpbmcgdW50aWwg
bm93LCBJIHdvdWxkIGxpa2UgdG8ga25vdw0KPiA+ID4gPiA+IGlmIGN1cnJlbnQgaWRlYSB3b3Jr
cyBvciBub3QuIElmIHllcywgSSB3aWxsIGZpbmlzaCB0aGUgZG9jdW1lbnRzIGFuZCB0ZXN0Lg0K
PiA+ID4gPiA+IA0KPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IFFJIEZ1bGkgPHFpLmZ1bGlAZnVq
aXRzdS5jb20+DQo+ID4gPiA+IA0KPiA+ID4gPiBIaSBRaSwNCj4gPiA+ID4gDQo+ID4gPiA+IFRo
YW5rcyBmb3IgcGlja2luZyB1cCBvbiB0aGlzISBUaGUgYXBwcm9hY2ggZ2VuZXJhbGx5IGxvb2tz
IGdvb2QgdG8NCj4gPiA+ID4gbWUsIEkgdGhpbmsgd2UgY2FuIGRlZmluaXRlbHkgbW92ZSBmb3J3
YXJkIHdpdGggdGhpcyBkaXJlY3Rpb24uDQo+ID4gPiA+IA0KPiA+ID4gPiBPbmUgdGhpbmcgdGhh
dCBzdGFuZHMgb3V0IGlzIC0gSSBkb24ndCB0aGluayB3ZSBjYW4gc2ltcGx5IHJlbmFtZQ0KPiA+
ID4gPiB0aGUgZXhpc3RpbmcgbW9uaXRvci5jb25mLiBXZSBoYXZlIHRvIGtlZXAgc3VwcG9ydGlu
ZyB0aGUgJ2xlZ2FjeScNCj4gPiA+ID4gbW9uaXRvci5jb25mIHNvIHRoYXQgd2UgZG9uJ3QgYnJl
YWsgYW55IGRlcGxveW1lbnRzLiBJJ2Qgc3VnZ2VzdA0KPiA+ID4gPiBrZWVwaW5nIHRoZSBvbGQg
bW9uaXRvci5jb25mIGFzIGlzLCBhbmQgY29udGludWluZyB0byBwYXJzZSBpdCBhcw0KPiA+ID4g
PiBpcywgYnV0IGFsc28gYWRkaW5nIGEgbmV3IG5kY3RsLmNvbmYgYXMgeW91IGhhdmUgZG9uZS4N
Cj4gPiA+ID4gDQo+ID4gPiA+IFdlIGNhbiBpbmRpY2F0ZSB0aGF0ICdtb25pdG9yLmNvbmYnIGlz
IGxlZ2FjeSwgYW5kIGFueSBuZXcgZmVhdHVyZXMNCj4gPiA+ID4gd2lsbCBvbmx5IGdldCBhZGRl
ZCB0byB0aGUgbmV3IGdsb2JhbCBjb25maWcgdG8gZW5jb3VyYWdlIG1pZ3JhdGlvbg0KPiA+ID4g
PiB0byB0aGUgbmV3IGNvbmZpZy4gUGVyaGFwcyB3ZSBjYW4gZXZlbiBwcm92aWRlIGEgaGVscGVy
IHNjcmlwdCB0bw0KPiA+ID4gPiBtaWdyYXRlIHRoZSBvbGQgY29uZmlnIHRvIG5ldyAtIGJ1dCBJ
IHRoaW5rIGl0IG5lZWRzIHRvIGJlIGEgdXNlcg0KPiA+ID4gPiB0cmlnZ2VyZWQgYWN0aW9uLg0K
PiA+ID4gPiANCj4gPiA+ID4gVGhpcyBpcyB0aW1lbHkgYXMgSSBhbHNvIG5lZWQgdG8gZ28gYWRk
IHNvbWUgY29uZmlnIHJlbGF0ZWQNCj4gPiA+ID4gZnVuY3Rpb25hbGl0eSB0byBkYXhjdGwsIGFu
ZCBiYXNpbmcgaXQgb24gdGhpcyB3b3VsZCBiZSBwZXJmZWN0LCBzbw0KPiA+ID4gPiBJJ2QgbG92
ZSB0byBnZXQgdGhpcyBzZXJpZXMgbWVyZ2VkIGluIHNvb24uDQo+ID4gPiANCj4gPiA+IEkgd29u
ZGVyIGlmIG5kY3RsIHNob3VsZCB0cmVhdCAvZXRjL25kY3RsIGxpa2UgYSBjb25mLmQgZGlyZWN0
b3J5IG9mDQo+ID4gPiB3aGljaCBhbGwgZmlsZXMgd2l0aCB0aGUgLmNvbmYgc3VmZml4IGFyZSBj
b25jYXRlbmF0ZWQgaW50byBvbmUNCj4gPiA+IGNvbWJpbmVkIGNvbmZpZ3VyYXRpb24gZmlsZS4g
SS5lLiBzb21ldGhpbmcgdGhhdCBtYWludGFpbnMgbGVnYWN5LCBidXQNCj4gPiA+IGFsc28gYWxs
b3dzIGZvciBjb25maWcgZnJhZ21lbnRzIHRvIGJlIGRlcGxveWVkIGluZGl2aWR1YWxseS4NCj4g
PiANCj4gPiBBZ3JlZWQsIHRoaXMgd291bGQgYmUgdGhlIG1vc3QgZmxleGlibGUuIGNpbmlwYXJz
ZXIgZG9lc24ndCBzZWVtIHRvIHN1cHBvcnQNCj4gPiBtdWx0aXBsZSBmaWxlcyBkaXJlY3RseSwg
YnV0IHBlcmhhcHMgbmRjdGwgY2FuLCBlYXJseSBvbiwgbG9hZCB1cCBtdWx0aXBsZQ0KPiA+IGZp
bGVzL2RpY3Rpb25hcmllcywgYW5kIHN0YXNoIHRoZW0gaW4gbmRjdGxfY3R4LiBUaGVuIHRoZXJl
IGNhbiBiZSBhY2Nlc3Nvcg0KPiA+IGZ1bmN0aW9ucyB0byByZXRyaWV2ZSBzcGVjaWZpYyBjb25m
IHN0cmluZ3MgZnJvbSB0aGF0IGFzIG5lZWRlZCBieSBkaWZmZXJlbnQNCj4gPiBjb21tYW5kcy4N
Cj4gDQo+IFRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHRoZSBjb21tZW50cy4NCj4gDQo+IEkgYWxz
byBhZ3JlZSwgYW5kIEkgYW0gd29ya2luZyBvbiB0aGUgdjIgcGF0Y2ggc2V0IG5vdy4NCj4gSSBm
b3VuZCB0aGF0IHRoZSBzdHlsZSBvZiBuZGN0bC5jb25mIGlzIGRpZmZlcmVudCBmcm9tIG1vbml0
b3IuY29uZiwNCj4gc2luY2UgdGhlcmUgaXMgbm8gc2VjdGlvbiBuYW1lIGluIG1vbml0b3IuY29u
Zi4NCj4gRG8gSSBuZWVkIHRvIGtlZXAgdGhlIGxlZ2FjeSBzdHlsZSBpbiBtb25pdG9yLmNvbmYs
IGkuZS4gQ2FuIEkgYWRkDQo+IHRoZSBzZWN0aW9uIG5hbWUgW21vbml0b3JdIHRvIG1vbml0b3Iu
Y29uZj8NCg0KU29ycnkgYWJvdXQgdGhlIGRlbGF5ZWQgcmVwbHksIEkgbWlzc2VkIHRoaXMgdGhy
ZWFkLiBJIHRoaW5rIGFkZGluZyBpdA0KdG8gdGhlIHNhbXBsZSBtb25pdG9yLmNvbmYgaXMgaGFy
bWxlc3MsIGJ1dCBJJ20gbm90IHN1cmUgdGhhdCBnZXRzIHVzDQphbnl0aGluZy4uIFRoZSBnb2Fs
IGlzIHRvIGNvbnRpbnVlIHRvIHN1cHBvcnQgYW55IG1vbml0b3IuY29uZnMgb2YgdGhlDQpvbGQg
c3R5bGUgdGhhdCBoYXZlIGFscmVhZHkgYmVlbiBkZXBsb3llZC4gVGhvc2Ugd291bGRuJ3QgaGF2
ZSBhDQpbbW9uaXRvcl0gc2VjdGlvbiBoZWFkZXIuDQoNCkkgdGhpbmsgd2UnZCBoYXZlIHRvIHRy
ZWF0IHRoZSBzcGVjaWZpYyBmaWxlIC9ldGMvbmRjdGwvbW9uaXRvci5jb25mIGFzDQphIHNwZWNp
YWwgY2FzZSwgYW5kIGp1c3QgcGFyc2UgaXQgdGhlIG9sZCB3YXkuIFdlIGNhbiBtYWtlIGl0IHNv
IHRoYXQgYQ0KbmV3IHN0eWxlIFttb25pdG9yXSBzZWN0aW9uIGlzIGluY29tcGF0aWJsZSB3aXRo
IHRoZSBvbGQgc3R5bGUNCm1vbml0b3IuY29uZiAoZXJyb3Igb3V0IGFuZCBmYWlsIGlmIHRoaXMg
aXMgZGV0ZWN0ZWQpLCBhbmQgd2Ugd29uJ3QNCmV2ZXIgYWRkIGFueSBuZXcgZnVuY3Rpb25hbGl0
eSB0byB0aGUgb2xkIG1vbml0b3IuY29uZiB0byBlbmNvdXJhZ2UNCnBlb3BsZSB0byBzd2l0Y2gu
IFdlIGNhbiBhZGRpdGlvbmFsbHkgcHJpbnQgYSB3YXJuaW5nIHRvIHN0ZGVyciBpZiB0aGUNCm9s
ZCBzdHlsZSBmaWxlIGlzIGJlaW5nIHVzZWQuDQoNCg==
