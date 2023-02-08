Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C433366
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 06:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675838053; x=1707374053;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7VKfFU8Yy14ITMqlGu9NA7s2f/JkLuUQZnW3PCw15fE=;
  b=PEAxnu0Vey87hPH+aQPY9u0my/FAuum2zIwqY0xzxkknveRXDTV9EF8D
   Qj30i2+qJCecZgWrRFxclnWA+VjxMCfqzLPm89yy12YzOYcUztHWw8VXe
   u95TgVNdyy3qhF36kisdXxuMLExb/MKzQpF2Ke5p74F+M41Wkt8nZvw6f
   xWGOCAHa6+QDh8p/5rzWkRN0vnciEoGOaa4vkZYoV7hHAHD0454EhccBj
   U/DRUDzhVXJD3AqhVRDaPWPvsQzABWlAYSYLUuNUUauOLowV4eVj9Mel8
   IskLWROoJdcyZhteMbdUg+kPKA6K9xLjqAoKDk8ilNA8vzwG/x0Cp5tEZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="415945261"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="415945261"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 22:34:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="912625951"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="912625951"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 07 Feb 2023 22:34:12 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 22:34:11 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 22:34:11 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 22:34:11 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 22:34:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHjr5Fmb/VlHspOErPB/UitV6l0hRx4JaQaSLGTuobHlyMSZWO5a94ICnjkdynUM2Yvxt0EW0DfQeERoqVk8XE6UE+Qu7RyP+jRi9alZh+r4Ve7ePJYHWBmviByqpuYV2b51PmrTz4zyjGPk0cx2uqwPN5SxOIXLNjluoDIEbBOYXSuDvn0U6UPZAagpT+ZJruhxVk1JDQuypPldY+rtW5atwWTxTMDb7/q22W/73KofBReOHvWhi/Z0HCazjZrBuhd5yPKKNvInO/VKGh9Jyg9H0x8uq/BP33f1ohvMjx9RlXcxFgkoxvwYicu84gwuMNv5zCnsJsMmWMTZ/x0l1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7VKfFU8Yy14ITMqlGu9NA7s2f/JkLuUQZnW3PCw15fE=;
 b=CBhk80CMGrHxroR+leJnpRs+m5cK4UzRD7b7QdrzH54m2Ozp5vV58wpbvlh8xNyJOzLTnYjEaTZIUqhZ8BaQ1qxC+z3ialjgHLgm9UhMbXfFyYBqbpXIAVodAb/kXMjwZRhX3Do1lMOvNMatJjT+5/f6NUjGBfl8Ol5bN9Rdjy/eDhpRMv7yELJJXFgzeAlAjxYo7UQzs65jT9omrtoDh3t5pZdAsJVqvluV3FxeQ9NiZTp+5jP+aQ068bfoJhPmLR+lLtr2NHkeVGOCEUXuE+njTmqFIYS+v32+gwcMNkyqxrcbjR8o6CgDIsx0QwnZczbaqX2ldFglSc7/QIii9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB3988.namprd11.prod.outlook.com (2603:10b6:405:7c::23)
 by CY5PR11MB6390.namprd11.prod.outlook.com (2603:10b6:930:39::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Wed, 8 Feb
 2023 06:34:09 +0000
Received: from BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::16cf:5ab1:7f74:d1e5]) by BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::16cf:5ab1:7f74:d1e5%7]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 06:34:09 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "gregory.price@memverge.com"
	<gregory.price@memverge.com>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 5/7] cxl/region: determine region type based on root
 decoder capability
Thread-Topic: [PATCH ndctl 5/7] cxl/region: determine region type based on
 root decoder capability
Thread-Index: AQHZOyjCbpj9o+tVl0C8FxqU/nkUZa7Eb2cAgAAo94A=
Date: Wed, 8 Feb 2023 06:34:08 +0000
Message-ID: <15becd4bfab3935be3fd1cbb2f97618a9870dbc4.camel@intel.com>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
	 <20230120-vv-volatile-regions-v1-5-b42b21ee8d0b@intel.com>
	 <63e3200218c32_107e3f294ea@iweiny-mobl.notmuch>
In-Reply-To: <63e3200218c32_107e3f294ea@iweiny-mobl.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB3988:EE_|CY5PR11MB6390:EE_
x-ms-office365-filtering-correlation-id: ae0ebee9-0aef-424b-05be-08db099e7b99
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5HcaFazLiOmWOe0vF04jN2RyQlpZXdv1+wObuVp3oHXOgBPSET75h73zoL67YOwB8Et1dqe7+iJaGR/jUvT1vszOAV2sT/aspH6IBPtlbx+wkod47nZvLa4B6HPheEnnkshFkayi1AhHQK9dLxOAClu/l6UzPtXZSYIgTc5yXIKa6dE0nww825b9/B01kT4o+Dv2TiRB2yl7a2IhzBeU5z4bpi1Jc0udqk+FnhnXtZVgpnG97Vl/5onf4kgY7HeAKp6lTc+fX0AquSPC8Gr7TT6PeZY9rIOvOMZpWdzP7vzAGCikj3FoWKF/GJiPIdruszEv8tRUo3Oz34OB1yGQH2H8g7i/r/SrpRDlWm96vdRM6qSR1mlzimks6mxrfk9YiXWMErGHHHfpVzAV6K59rtj6MV3iW5pTTNKjztpWYEu7cX2NqKABWpSD1nbxa8xxpnvEiVs8Rq0+I2K9Y3+EvD1pAd4wZUOxx6oHyDZS1xLRhQcUC0la4FbMXbtXSpdt1gM4tJuGNVQKmDpa0HIoqqpLAtAGHSeapf60yVRv18U+eN+jZAt0OWlX2R6zkCU5kEE50pY7mRAF89o4ELvsSTNCe1ELTKhb/H6B48QOi+rv48qNAV9RcvQpDoAv0WecZgB6Qy2cqB6W8BdWy7M28jm+0E7Az/0SpibJvcJCIKzCgXnwwawWPEM7JMSZApqXNk1kFAdUuUKwi+Dibam5kw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB3988.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199018)(2906002)(38070700005)(5660300002)(38100700002)(122000001)(82960400001)(36756003)(71200400001)(478600001)(6486002)(86362001)(2616005)(6506007)(186003)(26005)(83380400001)(6512007)(8676002)(66476007)(66556008)(64756008)(66446008)(91956017)(76116006)(66946007)(8936002)(41300700001)(4326008)(54906003)(6636002)(316002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NU8xR3JXQ05ZWFdsZGVZTi9zakR4b0hCRW9zUVZDcjNqOVI3cUtnaEY0U1F1?=
 =?utf-8?B?SXpGcjZNRFBuRUdhZjVoM1pSQzRwUW1VSG1TakZrOCtBVWVoUUFLU3lWcGZH?=
 =?utf-8?B?QjI4VDh0VTdCTjVrRUZOQnJuL3dGcGZ1cjNyYXArTUFKa1FhYm5DL2hCb1Fq?=
 =?utf-8?B?aHFNSTNDc2ZST3hndU1zL201aktXLzZTZEVSL2tSd3hIMENnWnpVeFdZTWJy?=
 =?utf-8?B?SjBEbDFmbDR6RElJK3N3aXJxWVlhZDhENTU4WVdZN0p1U3pleEJmenBKdFh2?=
 =?utf-8?B?c000NmRkd29hSHpXZnpKNWVOTko4OFJMM0wwT0ZsVFVpNjdyTVJ6QzQ0UlNP?=
 =?utf-8?B?aG40c2M5SzVFQ21kUERoU3E1ZEtmekh0TDVRUzd5U0w1RThDcU9Cb2Z5SGpK?=
 =?utf-8?B?d3NHTzVaT08xOWRyYy92MmtqdG1sblp3V1N0eisvMjRwUW9ta1dwdjNHRGE5?=
 =?utf-8?B?T1A2UmhiQ25Rc3FwS3dDaGVHNWFtYVYyQ1hJSWUwZU8rNlBlTEQ0RnNibTlR?=
 =?utf-8?B?aks3NEtnYncxSFBZZjNlYkMrZjdDU3c2clloWnJxUXVad0FRMlJHaEFka0Vw?=
 =?utf-8?B?NFUwRENiOW45RTgvOGlaTEFreDhKVVhxN3J4ZkhmMmFNSGM2b3dieUdlVnVC?=
 =?utf-8?B?aHh2QkU0Q3pzL3RCVjdwd241Z2g3RzRJMkczem1WektEWERqMHlrQmozTGI5?=
 =?utf-8?B?eHZWajd1eFdIZFFRTVZTamgzK0RYbEpvQXYySkdRbGkwNDg3SElWRmlZdWpP?=
 =?utf-8?B?NWxMVVVaTE9EUkRhUVVmSzVvUThhVUxIcC9mRStVdUc0aWhUL2RWZ1ZuSHBI?=
 =?utf-8?B?L3h1d0xzek1tYitwcUlRMVJTRisrZW91QmlaMTMxbDA1aXhWdXdtY3BoSVRZ?=
 =?utf-8?B?SVVGSnVEUlF2NzE4WnRQNmlSNk8yZ3lPQTVxSGgyVHRET0RrVWtVVFVXekUv?=
 =?utf-8?B?YmM3ejFLMTk2eE9xcEoyRzVBc2R1Zlc5Q3NWZDl6eVgwSHdhTTQyS3NjVnpl?=
 =?utf-8?B?K1dlelhPMHpRVW5zVHFnUndlNmlqMDIzQk5ubmp6cjAzbWdIa1pPb2ZoSHpy?=
 =?utf-8?B?VUlscHB3VVBmVVNaQTU1VDg0Zm9XTkRSdktRa2g4bDliNXh5QTlSejFBYjI3?=
 =?utf-8?B?TEpUZmlaUXN5WnBIa3JlQU93U2lhVU5CSzVCdVY4am1uUzJldUtVV2MzNWJn?=
 =?utf-8?B?dGErL0RldWk2RUFnZFBiMUhkRlBHQlNtTjFoemJIVUJRT21RbFZUWXcvOFJF?=
 =?utf-8?B?aFdYNGlHejNDWnhnc0IwMHJpVXdEbC9neUNCd1ZCdXE1SHdmeU5xL05UbXBJ?=
 =?utf-8?B?MUhPQ0laQStjK2hVd3p3QWdiWFdCTTJpR1Z2NkRmdXhTZlBPazVQZnl4S29p?=
 =?utf-8?B?VWJidm94MFYyVHNXd1VoQ2kxelRKSXB0eDVWdlJvVjhvMU9lYXJYdUQzUDdp?=
 =?utf-8?B?eEI0WWIvUC9yL3plN3NKazBaUUxWNzd5Ukpka1daSnZnWGJCWVRvU3BiOVRt?=
 =?utf-8?B?QzVPS2dOM0ZZNERrbGo5OWtWU1c3OCt2bU1admc2L3NoZFllMHJwWlhHS3BL?=
 =?utf-8?B?Y2c1VVpFemRKSUZ0WWtGWkIxVGVGTlhQSHdqcjNWaTF3N1FBQlp0eHVTNng0?=
 =?utf-8?B?Vm0rWFBmcitqczdlN3lsRnRBeE5FNmRFWEo1blFFQlQ5ekNhSnErdGZUcjZ2?=
 =?utf-8?B?eWRCbFp1SDJiTy9oUWxYdW1pSWFKbExkak82K2RNUE9jTnp6emZlRU40QW41?=
 =?utf-8?B?Q2U0cWVMSWdtNXc1R0RvRythVWtWbC8vWTU3VXhES1dlVGxRcDh0QkU5U1JU?=
 =?utf-8?B?MFBPdit2ZGY4b3k1SW80TDNZSVM1UTdXNnlUTS8zMUZWcFVUVGwwbjRJMHhZ?=
 =?utf-8?B?djRzY3JibTlhQVVRYzU0azVQUWl0Vk4zOUh3c0pHVVkrOHQ4RG9EU1VvUE9w?=
 =?utf-8?B?RWhyMVRLc3ZhU1liaVloOThIRnpKdm9DendheXFIallKWlFjUHdTVnhVS24x?=
 =?utf-8?B?SFJoYVAwcW5ZM1dIMUY5RXlUcWovcFhXVXBmWmF3aS90M3UvdXRMWXZRTGFz?=
 =?utf-8?B?MnRXNlNzd3ArdGR3Ui9aOG1uK21OOG5ITXdHTUZiMkhaZkVqNTNTZGJPa3l3?=
 =?utf-8?B?Uk0vQTUrakVXTzZnOGVFOFBQRmlVcHhwMUdFbjVNWUdKcGdCMUZwdi9sNStk?=
 =?utf-8?B?MHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC0DCECD34704541BF53F6BBADA63007@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB3988.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae0ebee9-0aef-424b-05be-08db099e7b99
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 06:34:08.6009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iVmhfJNcov/PDi0rU+DiGpVtwlHGlx7Vc9oCw5R+QrJZRyFXmI3thNGRcnIqhGkHVl4SAm/8N6H80m7omhwoBWsDhBJepvJCyTC0EFYQc90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6390
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTAyLTA3IGF0IDIwOjA3IC0wODAwLCBJcmEgV2Vpbnkgd3JvdGU6Cj4gVmlz
aGFsIFZlcm1hIHdyb3RlOgo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvY3hsL3JlZ2lvbi5jIGIvY3hs
L3JlZ2lvbi5jCj4gPiBpbmRleCA5MDc5YjJkLi4xYzhjY2M3IDEwMDY0NAo+ID4gLS0tIGEvY3hs
L3JlZ2lvbi5jCj4gPiArKysgYi9jeGwvcmVnaW9uLmMKPiA+IEBAIC00NDgsNiArNDQ4LDMxIEBA
IHN0YXRpYyBpbnQgdmFsaWRhdGVfZGVjb2RlcihzdHJ1Y3QgY3hsX2RlY29kZXIgKmRlY29kZXIs
Cj4gPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDA7Cj4gPiDCoH0KPiA+IMKgCj4gPiArc3RhdGlj
IHZvaWQgc2V0X3R5cGVfZnJvbV9kZWNvZGVyKHN0cnVjdCBjeGxfY3R4ICpjdHgsIHN0cnVjdCBw
YXJzZWRfcGFyYW1zICpwKQo+ID4gK3sKPiA+ICvCoMKgwqDCoMKgwqDCoGludCBudW1fY2FwID0g
MDsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoC8qIGlmIHBhcmFtLnR5cGUgd2FzIGV4cGxpY2l0
bHkgc3BlY2lmaWVkLCBub3RoaW5nIHRvIGRvIGhlcmUgKi8KPiA+ICvCoMKgwqDCoMKgwqDCoGlm
IChwYXJhbS50eXBlKQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybjsK
PiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoC8qCj4gPiArwqDCoMKgwqDCoMKgwqAgKiBpZiB0aGUg
cm9vdCBkZWNvZGVyIG9ubHkgaGFzIG9uZSB0eXBlIG9mIGNhcGFiaWxpdHksIGRlZmF1bHQKPiA+
ICvCoMKgwqDCoMKgwqDCoCAqIHRvIHRoYXQgbW9kZSBmb3IgdGhlIHJlZ2lvbi4KPiA+ICvCoMKg
wqDCoMKgwqDCoCAqLwo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKGN4bF9kZWNvZGVyX2lzX3BtZW1f
Y2FwYWJsZShwLT5yb290X2RlY29kZXIpKQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoG51bV9jYXArKzsKPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChjeGxfZGVjb2Rlcl9pc192b2xh
dGlsZV9jYXBhYmxlKHAtPnJvb3RfZGVjb2RlcikpCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgbnVtX2NhcCsrOwo+ID4gKwo+ID4gK8KgwqDCoMKgwqDCoMKgaWYgKG51bV9jYXAg
PT0gMSkgewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChjeGxfZGVjb2Rl
cl9pc192b2xhdGlsZV9jYXBhYmxlKHAtPnJvb3RfZGVjb2RlcikpCj4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHAtPm1vZGUgPSBDWExfREVDT0RFUl9N
T0RFX1JBTTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlbHNlIGlmIChjeGxf
ZGVjb2Rlcl9pc19wbWVtX2NhcGFibGUocC0+cm9vdF9kZWNvZGVyKSkKPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcC0+bW9kZSA9IENYTF9ERUNPREVS
X01PREVfUE1FTTsKPiA+ICvCoMKgwqDCoMKgwqDCoH0KPiAKPiBJIGZlZWwgbGlrZSB0aGUgZGVm
YXVsdCBmb3IgcC0+bW9kZSBzaG91bGQgYmUgbW92ZWQgaGVyZSBmcm9tCj4gcGFyc2VfY3JlYXRl
X29wdGlvbnMoKS7CoCBCdXQgSSdtIG5vdCBzdXJlIHdoYXQgdGhlIGZsb3dzIG1pZ2h0IGJlIGxp
a2UgaW4KPiB0aGF0IGNhc2UuwqAgVGhhdCBtZWFucyBwLT5tb2RlIHdvdWxkIGRlZmF1bHQgdG8g
Tk9ORSB1bnRpbCBoZXJlLgo+IAo+IFRoYXQgd291bGQgbWFrZSB0aGUgbWFuIHBhZ2UgYmVoYXZp
b3IgYW5kIHRoaXMgZnVuY3Rpb24gbWF0Y2ggdXAgbmljZWx5Cj4gZm9yIGZ1dHVyZSBtYWludGVu
YW5jZS4KCkhtLCBkbyB0aGV5IG5vdCBtYXRjaCBub3c/IEkgY2FuIHNlZSB0aGUgYXBwZWFsIGlu
IGNvbGxlY3RpbmcgdGhlCmRlZmF1bHQgbW9kZSBzZXR1cCBpbiBvbmUgcGxhY2UsIGJ1dCBpbiBt
eSBtaW5kIHRoZSBlYXJseSBjaGVja3MgLwpkZWZhdWx0cyBpbiBwYXJzZV9jcmVhdGVfb3B0aW9u
cygpIGFyZSBhIHNpbXBsZSwgaW5pdGlhbCBwYXNzIGZvcgpjYW5uZWQgZGVmYXVsdHMsIGFuZCBj
b25mbGljdGluZyBvcHRpb24gY2hlY2tzLiBUaGluZ3MgbGlrZQpzZXRfdHlwZV9mcm9tX2RlY29k
ZXIoKSBhcmUgbW9yZSBvZiBhICdzZWNvbmQgcGFzcycgdGhpbmcgd2hlcmUgd2UgbWF5CmRvIG1v
cmUgaW52b2x2ZWQgcG9yY2VsYWluIHR5cGUgZGVjaXNpb24gbWFraW5nIGJhc2VkIG9uIHRoZSBm
dWxsCnRvcG9sb2d5LgoKPiAKPiBCdXQgSSBkb24ndCB0aGluayB0aGlzIGlzIHdyb25nLsKgIFNv
Ogo+IAo+IFJldmlld2VkLWJ5OiBJcmEgV2VpbnkgPGlyYS53ZWlueUBpbnRlbC5jb20+Cgo=
