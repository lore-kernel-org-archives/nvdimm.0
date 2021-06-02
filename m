Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6643E70
	for <nvdimm@lists.linux.dev>; Wed,  2 Jun 2021 06:33:12 +0000 (UTC)
IronPort-SDR: 6kxS5y61tM+7OfEczl0sYacj2KS+lNUMAqqxliadcbfDbkNNVpnyLE5iUqKSDmHJe9hH1eNFFB
 lucUVFaHDNwA==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="224999931"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="224999931"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 23:33:11 -0700
IronPort-SDR: gTIJg4/oCNQFshwTrQ7GpR5ViwS52RAuvQvpB9N9c8IIFkUX+WIkfCtTT22ujusWzi/s+ceOpi
 Y3AEGA/bI5cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="482882329"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 01 Jun 2021 23:33:10 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 1 Jun 2021 23:33:09 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Tue, 1 Jun 2021 23:33:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 1 Jun 2021 23:33:09 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 1 Jun 2021 23:33:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C2GkfZLTvfydD3cYcU/FqL4hW7q42R40PsX9gQaFAF641obXWDIrTuWBEgBVqA3d1aXDywlqRFFv2wFXhYYCt8ZHxQp5cDlqhCQtpiP+oZzvZZMH7wIy8soy9D1Sh0V9yZrhI4eCZ2RHYgA/+8IbAkr4HBvzRBjgXuQ1Ue8hZ/j2q+Nu+O2DwEmZGZ1P3jmSALjamvZX4nI+hK0AgWVoFi2DYBmhorQ6rxRGD7nU/RLU4kN68cbL++ZnoUy9aAvRJEUFHDBparnh9FL9GXp/Rxa+4ubo2g1eL3IVBvG+W9pPG5SdEIHFUg1BNZofiCsGNhiizRbJvlWoUvCGkrl2GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUVl4ibYn4hJdgVrgbGuE792gOpwJ2w6Qvi7wG8a20A=;
 b=JeZaZzsIhKgXTjDmA1pyxnouyF/xlWQ+L1U8CMVT7dwheKnXEkuN/Ec9WE7JD8SFlsLPRrGG7aCNW8W7G2nvzbNCj6HeTmJ1kMiw/DM3QiPIES6sWk0/SVqtldvtDh9J0+V7+57DbVpcdi45/fOPQjfhkOe/g5c3iLaH38fsYbNWeUt0A/nIFmxPRgylLLQVWvg5sOXaCmOWpyecsMS0btIKu80T7wHQfsDRK1yc1MxO52nQRU7cXxK2thejBtIPOzJ3ld9yPWQ4eivheCN88ypo2HF54H9Y13zQ4WLTw5gf/B6A6TTMdJ+jeg90P26AdmGaDa+faP0rzjGxl7Hcrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eUVl4ibYn4hJdgVrgbGuE792gOpwJ2w6Qvi7wG8a20A=;
 b=IMEW1s7+AXqTiJoRcPs/KljhYyAfNeu7cUw7XTO8To6mCBf5DnpNXwkzbfpF5gUn5PfD9S/evGR04cPvROp2g6ITGlu5RTalPp96g8YRjS/RiHc7kleReT6iZ/R5/6VauvWZN08aXAa7OusPrg6RmroAObk3LkfG2aVDXNgkQrU=
Received: from BYAPR11MB3448.namprd11.prod.outlook.com (2603:10b6:a03:76::21)
 by SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 06:33:08 +0000
Received: from BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::713c:a1f6:aae4:19fc]) by BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::713c:a1f6:aae4:19fc%5]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 06:33:08 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "fukuri.sai@gmail.com" <fukuri.sai@gmail.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
Subject: Re: [RFC ndctl PATCH 3/3] ndctl, rename monitor.conf to ndctl.conf
Thread-Topic: [RFC ndctl PATCH 3/3] ndctl, rename monitor.conf to ndctl.conf
Thread-Index: AQHXSqlNV92GbjKVhUanndcDwXJH6KsAXPmA
Date: Wed, 2 Jun 2021 06:33:08 +0000
Message-ID: <2274eb818d2dbd2df0ff51efb73241f22be98530.camel@intel.com>
References: <20210516231427.64162-1-qi.fuli@fujitsu.com>
	 <20210516231427.64162-4-qi.fuli@fujitsu.com>
In-Reply-To: <20210516231427.64162-4-qi.fuli@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.1 (3.40.1-1.fc34) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.137.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71e28816-7c10-46f3-253f-08d92590494e
x-ms-traffictypediagnostic: SJ0PR11MB5008:
x-microsoft-antispam-prvs: <SJ0PR11MB50087646B43E082E419AB117C73D9@SJ0PR11MB5008.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0joZOzpc5URMbOMiX8N9PKmQ1qyrgBAa+HMFO6sgauKz/1RXKsa6OcrMhw1HuvmNqt0hot2PZuKB4BgKfu6eVXK16AxiBqve1vzqYvGByRNVS8TPmbT8IzHq4ZF0ep9uZBnEgfgXPRYnMRIfhqFJht9dEb5ks4VxP3QkiBHTiY4J7fSquc94mw8e7NCOKR5Ma36ypit78iVydB1IZ57SyPp1TQt66TSbITlRDA2JcEU58Jiffxp4LNMKRK2QEAMGSJjTlXg0JM/m4OKxU+bUhJF7plKxrtfHaCoAzI2rs8BFK5byOJRcUuiX3TjlJOa+yjVk2qx0KSmieMQzi7Bmim5yj/B+weGUmA3U6GvYx+heOEZ7ve7rux6krG4xBJ9RfeFrDEuyCiDNF+RvLiOlZuB3joxZQxO/2duAedrhg4ZLLPccvveAGZonYdu2dmy4ZRy1+OyCvbbjRIJQwta8aCCS8m9lkHqVhOvj6P7ZrMqwuso0GwR7zXogb0gslIEeYBefQYwivRonxX91+RFYEG+Y+AcZB6UGD+gw6NAkQjRB28IzckKmIkBq1tMT87qoPmU9FjT6yvOzOw6XdWUvWKnZqH0RB+7Xvz7122lX2rw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3448.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(136003)(366004)(316002)(26005)(110136005)(86362001)(478600001)(64756008)(4326008)(76116006)(83380400001)(186003)(6506007)(36756003)(38100700002)(66556008)(122000001)(6512007)(2616005)(6486002)(66476007)(66446008)(8936002)(2906002)(66946007)(8676002)(5660300002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bmxTOWp3cE1WcVpud280TXRjdER3NlU5Wmx3MThncFpSZlI3K1QxRS9YbExD?=
 =?utf-8?B?RG5wN1FCci9jb25PMnRqMC8wbG5CWVRGYXZBVjg2T1M0aGoyN29MUWZtZmtK?=
 =?utf-8?B?UnhhZ0t4OWdSN3dhZjdyaUs4VzExTWtxS3JibWYvNVV4aDNPYXdtZ2tpZHkz?=
 =?utf-8?B?aDJRVDRpbWt2V1R2UVNMSWdOWUt1S3ZpSmk4SGNmcnRFUlZWVm9OVWFtMnpo?=
 =?utf-8?B?YWd5M3RDeU9YMDNqTTIzZkNqRkxCaTNXWkNCMEllMjB0UXEzQTY3c2IxWWVy?=
 =?utf-8?B?L1lIU1dzTHdFWGNUREtPMUhMV2xCbVZ4QVZiRTNPUnVORlAwUStNUFlEMFlI?=
 =?utf-8?B?WHFveUVqTmh2OUJFa0JiSXhySktnR2lBRTdiZmVVWUFpV3RjVmtvV25jYXVZ?=
 =?utf-8?B?RFhIUjRJT1ZaU2xyL1hNeVlyODNMeXNyaG5uK2xrQ0lwd1dOQ2txNFpZZ044?=
 =?utf-8?B?eUtQZlN1TGtoM3FPQlkrNkcxUlRaUXF1bTR3YnZ0OUVnWWtieWM0UWpmbTdY?=
 =?utf-8?B?bC93MzZRZk5lUzZnYll0NEdEeW43NDRaWVVFVkpJenU1ZzYrTmM3TjloNEd6?=
 =?utf-8?B?Y3JZdDlKVUtHNkVFWlFEM2hubHIvSDM1VXpQU0xUS21vNVpxbTlIQWtCRzVx?=
 =?utf-8?B?WjlVTDVnOERDVEZkbGRJZk9xc1hrT3BwUldyKzdqWGJXVEwydGc4bEJmczJQ?=
 =?utf-8?B?NWpKM2lUY0RoSXE5R3hZN3o4RFFPMXZBcjB4TjZYTUtaWGFLamFOcTJQNmsz?=
 =?utf-8?B?NGNIYStuMys2MHZmdXYyT3A2c3lEM1NuMlU4NGN3RmJ0d0NVNFhHMDhsekRw?=
 =?utf-8?B?Q3BsVko5THFuL3hRVTZNVEorUGFBNklhakpxWTJqRmRNV1VZZjJHTEhBZ0pN?=
 =?utf-8?B?RzlBME1BQU5pYzNWNzRvay9pRnB0bXVvWjZKU3lYRnlPSS9rejZiRHRvSUUz?=
 =?utf-8?B?U3ZzVUZsV0tFRjBLOXh2ZklSVllDSzBwTGUxQkF6bW5aOGM2UDNLZEpTbTUv?=
 =?utf-8?B?cHV1UzMyQkRpOUs0aUc3bG1XZkZqMVlGVE0xUTUzUWtBaWJVV3RQWStsRFhV?=
 =?utf-8?B?RjFWN1F2N2k3bDB6b3dDbTRxTjlLbDFFVTN1akpEeDcwRGZlOTM3TVpZTU9r?=
 =?utf-8?B?NmhPTWZqUWVzR3I0cFFlWlc1aVZvN0FjTU1OK3VHRWNPQVFnN1cxREk0Y3lP?=
 =?utf-8?B?dFBnNmRzcHo4OEdPVUExRlJzUndxOHZraGN4NnJTdXA2THhnVVlFM29md3Nx?=
 =?utf-8?B?S3ZyRUlvaHJRbm5WenlRZENEdEhHTjJIN1Bad2JBblUyZk9HeG9XeGFTN1RB?=
 =?utf-8?B?K2gyODZwT1ZHTEhHT09wQnV5UHpacTlWcDFGM2xsSWtvaHYxOU9tMTBoSWVq?=
 =?utf-8?B?aDhrN1JuaE04VEU0TEJXbzg5MmQ4QXREZ0syTGp5aGRBZDRFMVdWTlhjSkpq?=
 =?utf-8?B?UG1HUzU4bmhkdWl3WDkvNFBpY2NXNG9ybzczNUtncHZndi9YUyt5L3d1bHZV?=
 =?utf-8?B?OHVyRzRJUVdRcVJid2VHeHpEYVF6NG44UDMvZXJ5WlNLRDB0SFgrNWxtYzdB?=
 =?utf-8?B?RkY1YWRvT1JTSUVkZEg5KzkzMXMwcUFYK0E5WlBTVGNSU3JjN1lvZWI3SE1Y?=
 =?utf-8?B?WFJ1UzM3cy9Ralc1aGtqRG1Lb080cVdDVFd2Y0ZmbXNKdDYyTlJXaHRlVmNk?=
 =?utf-8?B?U01hM0U0bjZYbVFBUklnZkw3SFlCQnJBNFFSMjZQV3k1SVYwN0hKTlBNNFRR?=
 =?utf-8?B?M1ZRK2ZzVTIyTEdhMFJHb3lyM3B1TXNaR3l1SWZTeVphRXVOd1BhMGtlQkl3?=
 =?utf-8?B?azJoSVhNcjdybmdZbzBaUT09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <91691C0386BE294BA295B58E344AEEFC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3448.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71e28816-7c10-46f3-253f-08d92590494e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 06:33:08.3510
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nYCXlYzSGFBxBvtdUFCXTAWBEpvhLyk+KQ08NQHRGZAU6SYEskhWGCXW9Dz9dTO4ictlDTLX6lKvRJeZD8LU6cgB4/RqIwjU8jwQOXziAyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5008
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIxLTA1LTE3IGF0IDA4OjE0ICswOTAwLCBRSSBGdWxpIHdyb3RlOg0KPiBGcm9t
OiBRSSBGdWxpIDxxaS5mdWxpQGZ1aml0c3UuY29tPg0KPiANCj4gUmVuYW1lIG1vbml0b3IuY29u
ZiB0byBuZGN0bC5jb25mLCBhbmQgbWFrZSBpdCBhIG5kY2x0IGdsb2JhbA0KPiBjb25maWd1cmF0
aW9uIGZpbGUgdGhhdCBhbGwgY29tbWFuZHMgY2FuIHJlZmVyIHRvLg0KPiBSZWZhY3RvciBtb25p
dG9yIHRvIG1ha2UgaXQgd29yayB3aXRoIG5kY3RsLmNvbmYuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBRSSBGdWxpIDxxaS5mdWxpQGZ1aml0c3UuY29tPg0KPiAtLS0NCj4gIGNvbmZpZ3VyZS5hYyAg
ICAgICAgICAgICAgICAgICAgICAgfCAgIDggKy0NCj4gIG5kY3RsL01ha2VmaWxlLmFtICAgICAg
ICAgICAgICAgICAgfCAgIDkgKy0NCj4gIG5kY3RsL21vbml0b3IuYyAgICAgICAgICAgICAgICAg
ICAgfCAxMjcgKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gIG5kY3RsL3ttb25pdG9y
LmNvbmYgPT4gbmRjdGwuY29uZn0gfCAgMTYgKysrLQ0KPiAgNCBmaWxlcyBjaGFuZ2VkLCA0MCBp
bnNlcnRpb25zKCspLCAxMjAgZGVsZXRpb25zKC0pDQo+ICByZW5hbWUgbmRjdGwve21vbml0b3Iu
Y29uZiA9PiBuZGN0bC5jb25mfSAoODIlKQ0KPiANCg0KW3NuaXBdDQoNCj4gQEAgLTYwMSw2ICs0
OTYsMTkgQEAgaW50IGNtZF9tb25pdG9yKGludCBhcmdjLCBjb25zdCBjaGFyICoqYXJndiwgc3Ry
dWN0IG5kY3RsX2N0eCAqY3R4KQ0KPiAgCQkibmRjdGwgbW9uaXRvciBbPG9wdGlvbnM+XSIsDQo+
ICAJCU5VTEwNCj4gIAl9Ow0KPiArCWNvbnN0IHN0cnVjdCBjb25maWcgY29uZmlnc1tdID0gew0K
PiArCQlDT05GX1NUUigiY29yZTpidXMiLCAmcGFyYW0uYnVzLCBOVUxMKSwNCj4gKwkJQ09ORl9T
VFIoImNvcmU6cmVnaW9uIiwgJnBhcmFtLnJlZ2lvbiwgTlVMTCksDQo+ICsJCUNPTkZfU1RSKCJj
b3JlOmRpbW0iLCAmcGFyYW0uZGltbSwgTlVMTCksDQo+ICsJCUNPTkZfU1RSKCJjb3JlOm5hbWVz
cGFjZSIsICZwYXJhbS5uYW1lc3BhY2UsIE5VTEwpLA0KPiArCQlDT05GX1NUUigibW9uaXRvcjpi
dXMiLCAmcGFyYW0uYnVzLCBOVUxMKSwNCj4gKwkJQ09ORl9TVFIoIm1vbml0b3I6cmVnaW9uIiwg
JnBhcmFtLnJlZ2lvbiwgTlVMTCksDQo+ICsJCUNPTkZfU1RSKCJtb25pdG9yOmRpbW0iLCAmcGFy
YW0uZGltbSwgTlVMTCksDQo+ICsJCUNPTkZfU1RSKCJtb25pdG9yOm5hbWVzcGFjZSIsICZwYXJh
bS5uYW1lc3BhY2UsIE5VTEwpLA0KPiArCQlDT05GX1NUUigibW9uaXRvcjpkaW1tLWV2ZW50Iiwg
Jm1vbml0b3IuZGltbV9ldmVudCwgTlVMTCksDQo+ICsJCS8vQ09ORl9GSUxFKCJtb25pdG9yOmxv
ZyIsICZtb25pdG9yLmxvZywgTlVMTCksDQo+ICsJCUNPTkZfRU5EKCksDQo+ICsJfTsNCj4gIAlj
b25zdCBjaGFyICpwcmVmaXggPSAiLi8iOw0KPiAgCXN0cnVjdCB1dGlsX2ZpbHRlcl9jdHggZmN0
eCA9IHsgMCB9Ow0KPiAgCXN0cnVjdCBtb25pdG9yX2ZpbHRlcl9hcmcgbWZhID0geyAwIH07DQo+
IEBAIC02MjEsNyArNTI5LDEwIEBAIGludCBjbWRfbW9uaXRvcihpbnQgYXJnYywgY29uc3QgY2hh
ciAqKmFyZ3YsIHN0cnVjdCBuZGN0bF9jdHggKmN0eCkNCj4gIAllbHNlDQo+ICAJCW1vbml0b3Iu
Y3R4LmxvZ19wcmlvcml0eSA9IExPR19JTkZPOw0KPiAgDQo+IC0JcmMgPSByZWFkX2NvbmZpZ19m
aWxlKGN0eCwgJm1vbml0b3IsICZwYXJhbSk7DQo+ICsJaWYgKG1vbml0b3IuY29uZmlnX2ZpbGUp
DQo+ICsJCXJjID0gcGFyc2VfY29uZmlncyhtb25pdG9yLmNvbmZpZ19maWxlLCBjb25maWdzKTsN
Cj4gKwllbHNlDQo+ICsJCXJjID0gcGFyc2VfY29uZmlncyhORENUTF9DT05GX0ZJTEUsIGNvbmZp
Z3MpOw0KPiAgCWlmIChyYykNCj4gIAkJZ290byBvdXQ7DQoNCklmIEknbSByZWFkaW5nIHRoaXMg
cmlnaHQsIGl0IGxvb2tzIGxpa2UgdGhpcyBpcyBzZXQgdXAgc28gdGhhdCBwYXJhbXMNCmZyb20g
dGhlIGNvbmZpZyBmaWxlIHdpbGwgb3ZlcnJpZGUgYW55IHBhcmFtcyBmcm9tIHRoZSBjb21tYW5k
IGxpbmUsDQp3aGljaCBJIHRoaW5rIGNhbiBiZSBzdXJwcmlzaW5nIGJlaGF2aW9yLiBUaGUgY29t
bWFuZCBsaW5lIHNob3VsZA0KYWx3YXlzIG92ZXJyaWRlIGFueXRoaW5nIGluIHRoZSBjb25maWcg
ZmlsZS4NCg0KSSBzdXNwZWN0IHdlJ2xsIG5lZWQgdG8gY29sbGVjdCBDTEkgcGFyYW1zIGluIGEg
J3BhcmFtX2NsaScgc3RydWN0dXJlLA0KY29uZmlnIHBhcmFtcyBpbiBhICdwYXJhbV9jb25maWcn
IHN0cnVjdHVyZSwgYW5kIHRoZW4gY29uc29saWRhdGUgdGhlbQ0KdG8gY3JlYXRlIHRoZSBmaW5h
bCAncGFyYW0nIHN0cnVjdHVyZSB0aGF0IGdldHMgcGFzc2VkIHRvDQp1dGlsX2ZpbHRlcl93YWxr
IGV0Yy4NCg0K
