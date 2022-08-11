Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5487120E7
	for <nvdimm@lists.linux.dev>; Thu, 11 Aug 2022 04:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660190914; x=1691726914;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=imo4/oUpzf+PmTLFFat0by3S5Mi1z06p1ZLVDaoMw8Y=;
  b=GVy9keiPI5btPrXTsN3N9FSh/laxj/HED41GrfNtqe3TSFMkwczykoHE
   5a7PlMjhMnikY+O/01moCxp1zTfXZEICuDPi+XmDd9lup8ITBCfZ4qA7S
   ZOILCIEGqZj1QofeoeOx8TwyP/Vk1kncgVMMPrEGJc1/mDqKdbsNGwZXs
   I8w873I1EFb8JHiZ32nfJMCSbeAVw8hadKqzr2DIBb7mala1KM1EYscDd
   YY5Ziw76gkf0IyenxBoqkKTcMe3IvGcjAL0mOV30x3wWGMC7Ul8mGPeLW
   yWzN5Q+NBzUla6n3duurZTwCkIJdNNZz/Xj2gTvCJ6adGGzW2PVGap+V1
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="292509736"
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="292509736"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 21:08:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,228,1654585200"; 
   d="scan'208";a="781461490"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 10 Aug 2022 21:08:25 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 21:08:25 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 10 Aug 2022 21:08:24 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Wed, 10 Aug 2022 21:08:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Wed, 10 Aug 2022 21:08:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4y2BnzOXIa/Jg61dQmSuWevk9ibflmoMeJ/2Ds90DY+8mg4Plj4cyBHSbtyN5EpJXWD9+CAQeBf9Zyt2R5tp3xr1/RCrrw7C4atFKXnBbYJwYv3UZV3mOAK/TYoEokZ9RklK+IpS5Rwz1dl8hvxmCWmk6EvT0kNqFoZKHrRY7CEfC03sUhYdFIxjQ3uc7JskojZbBxM9XLfQkxBNHCDBvG1bs9GZiMf972JoHnRrQKQ6DOItZZUEyEEks2e06F9gG5G5GoEDw+PPm+115M0r7PolT646ISKJA27b/Bpa1xDMasj2pCB9yFNAeG3SgyV3hbbdUEk3/eYMuZXC56K8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imo4/oUpzf+PmTLFFat0by3S5Mi1z06p1ZLVDaoMw8Y=;
 b=Ry0Xb4vM0HcQV9oKfTCEApKjD8uwbDvmpojU7AZFJuAzAglAin+amwVZpamIFTuQfZ3u2Vshm3oGrTsvu9d6qI/4iskkLfx7WLRO7+UN0d3niP4t7Z0XbC9zsjtf4NMW49hdWZT8GdIJcOlDcc1YtgHPDQxo7+RJ6rQ67ai3I0gCpX7AOr/nAYp6q63mu5xgnW7lB+gYQRNm+wqwx1Tafh4ZQHJlv1imrh+C/MNn6PK5aeIP4J34em7Dm7n6Ua1cIk/uhzUnbR4JnbkI393QcojC9dVpdOXfD1mBkZwGK4KAIPihlXxB1cLgawa4gCFSQJylw787/wA2JUQ5IKnuzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MWHPR11MB1774.namprd11.prod.outlook.com (2603:10b6:300:10a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Thu, 11 Aug
 2022 04:08:21 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1c88:c1bd:6295:cba4]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1c88:c1bd:6295:cba4%7]) with mapi id 15.20.5504.020; Thu, 11 Aug 2022
 04:08:21 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
CC: "Schofield, Alison" <alison.schofield@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH v2 05/10] libcxl: add low level APIs for region
 creation
Thread-Topic: [ndctl PATCH v2 05/10] libcxl: add low level APIs for region
 creation
Thread-Index: AQHYrQ5EHVQdU5b0rU+k8kQyyiGMtK2pBFKAgAARjQA=
Date: Thu, 11 Aug 2022 04:08:21 +0000
Message-ID: <417003cc6a7acf80c5dcf9c1d6d0321ebc636a21.camel@intel.com>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
	 <20220810230914.549611-6-vishal.l.verma@intel.com>
	 <62f471fbd22a2_7168c29410@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <62f471fbd22a2_7168c29410@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9028d015-dc17-4d4d-6673-08da7b4f2138
x-ms-traffictypediagnostic: MWHPR11MB1774:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O+pSaA48w+dgHad7F2ouAyXLUL0tjrJZDTX3IXDHJDEKnsbyqV278WbBVh7fPKmB5g12vxREVKA3CpGZaT3nAIclYgJyfQL6Zs2qbeb0wcUy7Y1ttnQXorl1N49Byn7eO8+AVR4tvqrClHiE8WZUZbnmOB5iZKudN3cnBR/6QuiWUBn/8CxRCPv71PcYrz8V2Y2zFKDZtP63dWwKiCxFQCEXmbVfkbF3g9hEoYDa+cbBapeYA8fzL7e3QoSmC0nyDppOF5t1J7UEuXSsF36F2d3mfAU/aGUqvlKjd3PbKBr3knAik496blL/o/pKJYY7TuW0i6oMjXhm8+O2X6ztnmbyjKXn1JCN8xxvN36AW/+/0ZbOXfvTgpOSdB/7pmmy+n13kiFdVFf4dk96wS4Skydg0HLBW1ca7xRoiSomMHPKorL+4OyY7MwCATJ2yxLht6uJol2NNejaHw2pxzn4yUw5YeCSv7jx1KhL5psa8ZBolyUwt7gUlEb+bStICzdjXAqkIzZmp+x3lNoYOsft6D26LGKjUoeuJJJmuILVD8LpNP6FVxJMVphV8H53yoPPV4EdZ9CSwTG3hwGjFEEZE6XivFYqIZUtkibym+l2rW54altB7KV6NjMfDyBvBsOoc212o65Xv93k07w3cWEktljKsYR4VW/TknG1FEuhxkEdsukcNrVbgj/R41i142QKGAez0dkgSt1GMaUk/3LGUleFRYBJPoX7FTm1rLTJN8AiGnTXjG9PA/Q3c0TKoor0bmGkjynaZ+paYnNoWgRvWkf+iMdQ7m3lr3L0K60hDbBu4ajt6gKSWjpyg2vVkZW6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(376002)(346002)(136003)(39860400002)(366004)(186003)(38100700002)(107886003)(2616005)(82960400001)(38070700005)(122000001)(83380400001)(8936002)(66446008)(4326008)(66556008)(64756008)(76116006)(2906002)(66476007)(41300700001)(478600001)(5660300002)(26005)(6512007)(6506007)(8676002)(54906003)(110136005)(71200400001)(86362001)(6486002)(316002)(66946007)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amd4aTFBQ0tESzVKRnhKRUovMDMzT0p2aFdKb1Y0Yjd1cUZEdzFxMzBzK256?=
 =?utf-8?B?SVhzbHlwS0hGc0Q1MkdKdkxnK0hrZDVsQ0ZrRHdUTTZraFduc2NRR0g5Rldn?=
 =?utf-8?B?T2ozTys2ekcxUGFvUmZmRGNEU1dLZm4yb2g3R2xUOU5EOTZuWkhtRW4wRDh2?=
 =?utf-8?B?N3NiVnVmbThPYlhsdk10NE9LeGcwQ0R6SzlWRE1tWm1kZVFqbFQxMndlWmlm?=
 =?utf-8?B?RHlhdEgrOUE2L0VDQTFTRTU2WHhLaHp1bS8rajdyZ0kvRStuNVdmYm4rTlE0?=
 =?utf-8?B?aVN6MGR4Y21rZ252UFJJVW9uVDI0d2ZjSTVGbEhRcnBPK0ZDaWlPZ3M5TzRN?=
 =?utf-8?B?Uy9KV1BZcGUrZzBGckFxcXJhWGF3SmNBbjVMT1I1TERxT0pBS09JdnlIV1hF?=
 =?utf-8?B?ajJlSGNDajZDUnBpZGJLT3loaFpSbnY2NW93dUlES3RhMVZHZHdkNVBwemtX?=
 =?utf-8?B?WHNxa0lvdWFnWkJ1VjJKUjJaY3lEOUxlZFNMSXgrQ0svYWkvRnhWN29xQnBT?=
 =?utf-8?B?Z2Y5NVdzTnQ3L0o3UER1MXhRVWNWRmVyNjRXM3g2Y0JmOFZqUkdxemEzUHhr?=
 =?utf-8?B?Z2dOQlIraG54OHoxUmlBYWVrQTRhRnlPUFAvdnJ2WHMxVlFPYXduMjg0K2ky?=
 =?utf-8?B?NWJmNW90amM4S0pTR0VoK3VGVUlxdllTS0o0K2tSMkFxQ3FDVTgzcFlSRVly?=
 =?utf-8?B?SUludWR3cWxwTjZ6a1UyVXdNVHArbEp3Z05rV0lQN0xmRE5pR0FWR1ZTOUts?=
 =?utf-8?B?OHIwT09HVlZxY3pTZHpkYkkyTjY2VmVPS3BCS0UxSkxESmRaNks5WkRlRXNv?=
 =?utf-8?B?N2FucDR1akdjSWlzcUhjaEdxeStUQTRBNkJ4QytWcEN0S25odmZhOERGVnFx?=
 =?utf-8?B?VWhOdWhoSWZwQXNCR3Rsa3NvZmdhTVlka212cGVzYTR1ekp6aEZrdkxZTmVR?=
 =?utf-8?B?Wit3ajJTUllxek5tMnU4NXlDZENsYWZQMzdWWjBRTHlqemtLSnZHV3lHZm53?=
 =?utf-8?B?TUorQithaGR2V1VxZDZ4WWFhRDYvMlBZMDF6aHIxeDBmQVpYT2FlSEdXaEZV?=
 =?utf-8?B?SGhKN0s1a0d3VzVGeFBNS01MT0ZyZTZpUGRyL3h1QkxiOFFHSFVUNFJKUmhU?=
 =?utf-8?B?MzFJdkdlejdNVWRxSUN2QldxQ0dTWUJVL0hPQTFHWHNhK2JvYjMvSnozMUht?=
 =?utf-8?B?TW82eXJNNExSaWpPNWhTVnhETTJDL3JlM243ZHdLTTRTUEttb0t4cm1xWlBU?=
 =?utf-8?B?ekplanhJRGpyRmFQYVFIbTI4OVhncnRHQVBxZzhxMWM4SkgwcDJFNTdVR3pO?=
 =?utf-8?B?WS9kTDZpdmVWeTJLSXA4dGVUN1RneWd4V0pGdGxMMWFvaG10a3ZJNVc2eHpG?=
 =?utf-8?B?amxnRjhGZFlkQVVoZm16UjVTYmRCNm5rcDhtbDNpbmI4NHkvMnZyT2JqbEZr?=
 =?utf-8?B?V1dEbEdlNjVCY25abVN6UkROTmtyMHRjNC9NZkFubklXQ1d6aE1yeTU5UUxV?=
 =?utf-8?B?MmtGTlV4cm42YnU5R1pPY2oxT0dBSXNnQURvT1ZCbVNzNjlsZTdVb0Zka3Bj?=
 =?utf-8?B?YmJmMlZHYU9NVWpMQ2V5L01HbzhRdXdsZ2tneDl6eXkxcUNMUjBlTkJGakla?=
 =?utf-8?B?MW0vMW16b0J4bDNtTTJVamNlb1haaHlVS0VKZytSRDE2dEhQOHhGM1Nocm9W?=
 =?utf-8?B?LzZ5ZTBrTEV6Ym1LNTZFR1MrZEFpMm1yRUFoQk9kOVJ6TGxBMitnL01ZVGI3?=
 =?utf-8?B?aGFST1ViN0xiTWcxOTNpa29TZmtDSDNzaWxvYWVINEpKaCtBM0dISFVKbFJj?=
 =?utf-8?B?b1p3NUszZDVJV3ZjYS8xa2phbC85NTNzamtqZGV3VEs2YVZJcExoRHQ5QUIr?=
 =?utf-8?B?dUt5d2VSOU9hZHp0YTFUaHNNV0JGRmFpNEhFejBOR1pQelE5K2haUitYUEN3?=
 =?utf-8?B?M1FRSmFzdnJEQWovKzR4VlFUT3hFVXo5WEl5WnFWaWl0L0xnMERLdFhMRjVG?=
 =?utf-8?B?MHIzVWpmZGo4Y2FPa01hWm9WZFNMdGhiUlh0ZkJKbGdxcTZyUGRjUjNCTzAr?=
 =?utf-8?B?ay9tSDlMMHE2bDh2RVI2Nk14cHlDWWF1U1pSa0JTeXZEL2xPTklvKzJNV0dT?=
 =?utf-8?B?MmFFazJydUVGc1h6NmZFb24zV2F2NExZa21qcmM0MllleUhWVSt4dU0ySXRC?=
 =?utf-8?B?NHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35C0EB5D0E618546B4905885126189D1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9028d015-dc17-4d4d-6673-08da7b4f2138
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 04:08:21.5854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1DoApQIBavkq4818aeG6Qlefqj8C6yODOycY22Q4iSid3WOsf2cCI/U1eiTJuy0z233gFb1pCBtvh/tStWrS4G25a9na+IMh/yifgnp6Dr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1774
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIyLTA4LTEwIGF0IDIwOjA1IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFZpc2hhbCBWZXJtYSB3cm90ZToNCj4gPiBBZGQgbGliY3hsIEFQSXMgdG8gY3JlYXRlIGEgcmVn
aW9uIHVuZGVyIGEgZ2l2ZW4gcm9vdCBkZWNvZGVyLCBhbmQgdG8NCj4gPiBzZXQgZGlmZmVyZW50
IGF0dHJpYnV0ZXMgZm9yIHRoZSBuZXcgcmVnaW9uLiBUaGVzZSBhbGxvdyBzZXR0aW5nIHRoZQ0K
PiA+IHNpemUsIGludGVybGVhdmVfd2F5cywgaW50ZXJsZWF2ZV9ncmFudWxhcml0eSwgdXVpZCwg
YW5kIHRoZSB0YXJnZXQNCj4gPiBkZXZpY2VzIGZvciB0aGUgbmV3bHkgbWludGVkIGN4bF9yZWdp
b24gb2JqZWN0Lg0KPiA+IA0KPiA+IENjOiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGlu
dGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1h
QGludGVsLmNvbT4NCj4gPiAtLS0NCj4gPiDCoERvY3VtZW50YXRpb24vY3hsL2xpYi9saWJjeGwu
dHh0IHzCoCA2OSArKysrKysNCj4gPiDCoGN4bC9saWIvcHJpdmF0ZS5owqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHzCoMKgIDIgKw0KPiA+IMKgY3hsL2xpYi9saWJjeGwuY8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMzc3ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKy0NCj4gPiDCoGN4bC9saWJjeGwuaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgfMKgIDIzICstDQo+ID4gwqBjeGwvbGliL2xpYmN4bC5zeW3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHzCoCAxNiArKw0KPiA+IMKgNSBmaWxlcyBjaGFuZ2VkLCA0ODQgaW5z
ZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1l
bnRhdGlvbi9jeGwvbGliL2xpYmN4bC50eHQgYi9Eb2N1bWVudGF0aW9uL2N4bC9saWIvbGliY3hs
LnR4dA0KPiA+IGluZGV4IDdhMzhjZTQuLmMzYThmMzYgMTAwNjQ0DQo+ID4gLS0tIGEvRG9jdW1l
bnRhdGlvbi9jeGwvbGliL2xpYmN4bC50eHQNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2N4bC9s
aWIvbGliY3hsLnR4dA0KPiA+IEBAIC01MDgsNiArNTA4LDc1IEBAIGRldmljZSB0byByZXByZXNl
bnQgdGhlIHJvb3Qgb2YgYSBQQ0kgZGV2aWNlIGhpZXJhcmNoeS4gVGhlDQo+ID4gwqBjeGxfdGFy
Z2V0X2dldF9waHlzaWNhbF9ub2RlKCkgaGVscGVyIHJldHVybnMgdGhlIGRldmljZSBuYW1lIG9m
IHRoYXQNCj4gPiDCoGNvbXBhbmlvbiBvYmplY3QgaW4gdGhlIFBDSSBoaWVyYXJjaHkuDQo+ID4g
wqANCj4gPiArPT09PSBSRUdJT05TDQo+ID4gK0EgQ1hMIHJlZ2lvbiBpcyBjb21wb3NlZCBvZiBv
bmUgb3IgbW9yZSBzbGljZXMgb2YgQ1hMIG1lbWRldnMsIHdpdGggY29uZmlndXJhYmxlDQo+ID4g
K2ludGVybGVhdmUgc2V0dGluZ3MgLSBib3RoIHRoZSBudW1iZXIgb2YgaW50ZXJsZWF2ZSB3YXlz
LCBhbmQgdGhlIGludGVybGVhdmUNCj4gPiArZ3JhbnVsYXJpdHkuIEluIHRlcm1zIG9mIGhpZXJh
cmNoeSwgaXQgaXMgdGhlIGNoaWxkIG9mIGEgQ1hMIHJvb3QgZGVjb2Rlci4gQSByb290DQo+ID4g
K2RlY29kZXIgKHJlY2FsbCB0aGF0IHRoaXMgY29ycmVzcG9uZHMgdG8gYW4gQUNQSSBDRURULkNG
TVdTICd3aW5kb3cnKSwgbWF5IGhhdmUNCj4gPiArbXVsdGlwbGUgY2hpbGUgcmVnaW9ucywgYnV0
IGEgcmVnaW9uIGlzIHN0cmljdGx5IHRpZWQgdG8gb25lIHJvb3QgZGVjb2Rlci4NCj4gDQo+IE1t
bSwgdGhhdCdzIGEgc3BpY3kgcmVnaW9uLg0KPiANCj4gcy9jaGlsZS9jaGlsZC8NCg0KSGFoIHll
cCB3aWxsIGZpeC4NCg0KPiANCj4gPiArDQo+ID4gK0EgcmVnaW9uIGFsc28gZGVmaW5lcyBhIHNl
dCBvZiBtYXBwaW5ncyB3aGljaCBhcmUgc2xpY2VzIG9mIGNhcGFjaXR5IG9uIGEgbWVtZGV2LA0K
PiANCj4gU2luY2UgdGhlIGFib3ZlIGFscmVhZHkgZGVmaW5lZCB0aGF0IGEgcmVnaW9uIGlzIGNv
bXBvc2VkIG9mIG9uZSBvciBtb3JlDQo+IHNsaWNlcyBvZiBDWEwgbWVtZGV2cywgaG93IGFib3V0
Og0KPiANCj4gIlRoZSBzbGljZXMgdGhhdCBjb21wb3NlIGEgcmVnaW9uIGFyZSBjYWxsZWQgbWFw
cGluZ3MuIEEgbWFwcGluZyBpcyBhDQo+IHR1cGxlIG9mICdtZW1kZXYnLCAnZW5kcG9pbnQgZGVj
b2RlcicsIGFuZCB0aGUgJ3Bvc2l0aW9uJy4NCg0KWWVwIHNvdW5kcyBnb29kLg0KDQpbc25pcF0N
Cg0KPiANCj4gPiArQ1hMX0VYUE9SVCBzdHJ1Y3QgY3hsX3JlZ2lvbiAqDQo+ID4gK2N4bF9kZWNv
ZGVyX2NyZWF0ZV9wbWVtX3JlZ2lvbihzdHJ1Y3QgY3hsX2RlY29kZXIgKmRlY29kZXIpDQo+ID4g
K3sNCj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgY3hsX2N0eCAqY3R4ID0gY3hsX2RlY29kZXJf
Z2V0X2N0eChkZWNvZGVyKTsNCj4gPiArwqDCoMKgwqDCoMKgwqBjaGFyICpwYXRoID0gZGVjb2Rl
ci0+ZGV2X2J1ZjsNCj4gPiArwqDCoMKgwqDCoMKgwqBjaGFyIGJ1ZltTWVNGU19BVFRSX1NJWkVd
Ow0KPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBjeGxfcmVnaW9uICpyZWdpb247DQo+ID4gK8Kg
wqDCoMKgwqDCoMKgaW50IHJjOw0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgwqBzcHJpbnRmKHBh
dGgsICIlcy9jcmVhdGVfcG1lbV9yZWdpb24iLCBkZWNvZGVyLT5kZXZfcGF0aCk7DQo+ID4gK8Kg
wqDCoMKgwqDCoMKgcmMgPSBzeXNmc19yZWFkX2F0dHIoY3R4LCBwYXRoLCBidWYpOw0KPiA+ICvC
oMKgwqDCoMKgwqDCoGlmIChyYyA8IDApIHsNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgZXJyKGN0eCwgImZhaWxlZCB0byByZWFkIG5ldyByZWdpb24gbmFtZTogJXNcbiIsDQo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJlcnJvcigtcmMpKTsN
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIE5VTEw7DQo+ID4gK8Kg
wqDCoMKgwqDCoMKgfQ0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgwqByYyA9IHN5c2ZzX3dyaXRl
X2F0dHIoY3R4LCBwYXRoLCBidWYpOw0KPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChyYyA8IDApIHsN
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZXJyKGN0eCwgImZhaWxlZCB0byB3
cml0ZSBuZXcgcmVnaW9uIG5hbWU6ICVzXG4iLA0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgc3RyZXJyb3IoLXJjKSk7DQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHJldHVybiBOVUxMOw0KPiA+ICvCoMKgwqDCoMKgwqDCoH0NCj4gDQo+IEkgdGhp
bmsgdGhlcmUgZWl0aGVyIG5lZWRzIHRvIGJlIGEgImRlY29kZXItPnJlZ2lvbnNfaW5pdCA9IDAi
IGhlcmUsIG9yDQo+IGEgZGlyZWN0IGNhbGwgdG8gImFkZF9jeGxfcmVnaW9uKGRlY29kZXIuLi4p
IiBqdXN0IGluIGNhc2UgdGhpcyBjb250ZXh0DQo+IGhhZCBhbHJlYWR5IGxpc3RlZCByZWdpb25z
IGJlZm9yZSBjcmVhdGluZyBhIG5ldyBvbmUuDQo+IA0KPiBJIGxpa2UgdGhlIHByZWNpc2lvbiBv
ZiAiYWRkX2N4bF9yZWdpb24oKSIsIGJ1dCB0aGF0IG5lZWRzIHRvIG9wZW4gY29kZQ0KPiBzb21l
IG9mIHRoZSBpbnRlcm5hbHMgb2Ygc3lzZnNfZGV2aWNlX3BhcnNlKCksIHNvIG1heWJlDQo+ICJk
ZWNvZGVyLT5yZWdpb25zX2luaXQgPSAwIiBpcyBvayBmb3Igbm93Lg0KDQpZZXMsIEkgZm91bmQg
dGhhdCBvdXQgLSBhbmQgYWRkZWQgdGhpcyAtIGluIHBhdGNoIDEwIChJIGNhbiBpbnN0ZWFkDQpt
b3ZlIGl0IGhlcmUgLSBpdCBtYWtlcyBzZW5zZSkuDQoNClVudGlsIHBhdGNoIDEwLCBkdXJpbmcg
cmVnaW9uIGNyZWF0aW9uLCBub3RoaW5nIGhhZCBkb25lIHJlZ2lvbnNfaW5pdA0KdW50aWwgdGhp
cyBwb2ludCwgc28gdGhpcyBoYXBwZW5zIHRvIHdvcmsuIFBhdGNoIDEwIHdoZXJlIHdlIGRvIHdh
bGsNCnRoZSByZWdpb25zIGJlZm9yZSB0aGlzIHBvaW50IHRvIGNhbGN1bGF0ZSB0aGUgbWF4IGF2
YWlsYWJsZSBzcGFjZSwNCm5lY2Vzc2l0YXRlcyB0aGUgcmVzZXQgaGVyZS4NCg0KVGhhdCBiZWlu
ZyBzYWlkLCBwb3RlbnRpYWxseSBhbGwgb2YgcGF0Y2ggMTAgaXMgc3F1YXNoLWFibGUgaW50bw0K
ZGlmZmVyZW50IGJpdHMgb2YgdGhlIHNlcmllcyAtIEkgbGVmdCBpdCBhdCB0aGUgZW5kIHNvIHRo
ZQ0KbWF4X2F2YWlsYWJsZV9leHRlbnQgc3R1ZmYgY2FuIGJlIHJldmlld2VkIG9uIGl0cyBvd24u
DQoNCkknbSBoYXBweSB0byBnbyBlaXRoZXIgd2F5IG9uIHNxdWFzaGluZyBpdCBvciBrZWVwaW5n
IGl0IHN0YW5kYWxvbmUuDQoNCj4gDQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqDCoC8qIGNyZWF0
ZV9yZWdpb24gd2FzIHN1Y2Nlc3NmdWwsIHdhbGsgdG8gdGhlIG5ldyByZWdpb24gKi8NCj4gPiAr
wqDCoMKgwqDCoMKgwqBjeGxfcmVnaW9uX2ZvcmVhY2goZGVjb2RlciwgcmVnaW9uKSB7DQo+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNvbnN0IGNoYXIgKmRldm5hbWUgPSBjeGxf
cmVnaW9uX2dldF9kZXZuYW1lKHJlZ2lvbik7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBpZiAoc3RyY21wKGRldm5hbWUsIGJ1ZikgPT0gMCkNCj4gPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gZm91bmQ7DQo+ID4g
K8KgwqDCoMKgwqDCoMKgfQ0KPiA+ICsNCj4gPiArwqDCoMKgwqDCoMKgwqAvKg0KPiA+ICvCoMKg
wqDCoMKgwqDCoCAqIElmIHdhbGtpbmcgdG8gdGhlIHJlZ2lvbiB3ZSBqdXN0IGNyZWF0ZWQgZmFp
bGVkLCBzb21ldGhpbmcgaGFzIGdvbmUNCj4gPiArwqDCoMKgwqDCoMKgwqAgKiB2ZXJ5IHdyb25n
LiBBdHRlbXB0IHRvIGRlbGV0ZSBpdCB0byBhdm9pZCBsZWF2aW5nIGEgZGFuZ2xpbmcgcmVnaW9u
DQo+ID4gK8KgwqDCoMKgwqDCoMKgICogaWQgYmVoaW5kLg0KPiA+ICvCoMKgwqDCoMKgwqDCoCAq
Lw0KPiA+ICvCoMKgwqDCoMKgwqDCoGVycihjdHgsICJmYWlsZWQgdG8gYWRkIG5ldyByZWdpb24g
dG8gbGliY3hsXG4iKTsNCj4gPiArwqDCoMKgwqDCoMKgwqBjeGxfcmVnaW9uX2RlbGV0ZV9uYW1l
KGRlY29kZXIsIGJ1Zik7DQo+ID4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIE5VTEw7DQo+ID4gKw0K
PiA+ICsgZm91bmQ6DQo+ID4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIHJlZ2lvbjsNCj4gPiArfQ0K
PiA+ICsNCj4gPiDCoENYTF9FWFBPUlQgaW50IGN4bF9kZWNvZGVyX2dldF9ucl90YXJnZXRzKHN0
cnVjdCBjeGxfZGVjb2RlciAqZGVjb2RlcikNCj4gPiDCoHsNCj4gPiDCoMKgwqDCoMKgwqDCoMKg
cmV0dXJuIGRlY29kZXItPm5yX3RhcmdldHM7DQo+ID4gQEAgLTE3MjksNiArMjA4NCwyNCBAQCBD
WExfRVhQT1JUIGNvbnN0IGNoYXIgKmN4bF9kZWNvZGVyX2dldF9kZXZuYW1lKHN0cnVjdCBjeGxf
ZGVjb2RlciAqZGVjb2RlcikNCj4gPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGRldnBhdGhfdG9f
ZGV2bmFtZShkZWNvZGVyLT5kZXZfcGF0aCk7DQo+ID4gwqB9DQo+ID4gwqANCj4gPiArQ1hMX0VY
UE9SVCBzdHJ1Y3QgY3hsX21lbWRldiAqDQo+ID4gK2N4bF9lcF9kZWNvZGVyX2dldF9tZW1kZXYo
c3RydWN0IGN4bF9kZWNvZGVyICpkZWNvZGVyKQ0KPiANCj4gSG1tLCB0aGlzIGlzIHRoZSBvbmx5
IHBsYWNlIHdoZXJlIHRoZSBBUEkgYXNzdW1lcyB0aGUgdHlwZSBvZiB0aGUNCj4gZGVjb2Rlci4g
VGhlIG90aGVyIHJvb3Qtb25seSBvciBlbmRwb2ludC1vbmx5IGRlY29kZXIgYXR0cmlidXRlIGdl
dHRlcnMNCj4gYXJlIGp1c3QgY3hsX2RlY29kZXJfZ2V0XyooKSwgc28gSSB0aGluayBkcm9wIHRo
ZSAiX2VwIi4NCg0KQWdyZWVkLCB3aWxsIGRyb3AgdGhlIGVwXy4NCg0KPiANCj4gT3RoZXIgdGhh
biB0aGUgaXRlbXMgbGlzdGVkIGFib3ZlLCB0aGlzIGxvb2tzIGdvb2QuDQo+IA0KPiBSZXZpZXdl
ZC1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQoNClRoYW5rcyBE
YW4hDQo=
