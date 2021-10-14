Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0222672
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 20:06:46 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="208581238"
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="208581238"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 13:06:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="626929270"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 14 Oct 2021 13:06:35 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 13:06:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 13:06:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 13:06:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G0FgwI6zc84oAEc14K4c4SoCmHM/HR5KaG60rCoZYq4hGtKPqrv9Inv40q8Jg8AMR15hysn5bTf37GZEGo/EvVec/X1rp89k9pYDH5hiA9p4h5bIwmKl/SZUk5hpUfghXr0ONpVjWebfrZqIqjOBdDDladQfV0qgztlKhT6EhqtC+6Gh7xsjHnS4TUPG+hUa8WSkHfkMz7FmmNV+oIkivuNryExe+F1fGA3PafUE52WojTTdbK6/3H2Uuw2FQaA48+MQIUghh5V4g8otTzo2T6HbCniogI47MDJZKXxwxzZV8XnuQRV6agDL0dGcfCJy9wDeeS82AKyFPJIEDzsYVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gf4rEUOqyR/Xzy6I9FLMG1FIIl4RqGeYBIdVAufB9J4=;
 b=ITn2mCaRwwl7XSchNR7UjJzGKUKukl0jliVoAFCyNEPRTZFRP2r7T2HKXVCpHfjQTXsCua/Nl6RuvT4mREC4BEcd8MOw4krl1yGxasDckNxjf4PDZKb44XoVaq0h8w+P/cRayvkKBw4sPo1qOBh4asPW+uW3y3SJyPDNDdwCN6kmcWcrP19Y+cNCjNI3FZcQeADL6Jg0/bSwg5CJyFbVXo9olVsaBAl/NlqzLALa2AUBYo/1LnqfHR90q17fVlrKl3YvJBEkWdcFx7p8nM1ZsC8SdmTDbUTw7m/O8bdbRQMfOliwmtZyUXcXpQT1lp0AtSzjuafiGegF4j86iYpnQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gf4rEUOqyR/Xzy6I9FLMG1FIIl4RqGeYBIdVAufB9J4=;
 b=E13YSX4IjlIkEN5tFq0QQYJfvUnR2Edm3nxSsVxKtm2zgT3Rc2FkunQ2EAwpvOikJM1VuuJpVcgOnFJ46GSSuAB4Fs4spKGFoxFQ3gnrrjbqwsEFhFVScOLym5aYtGabg16l8MI0Zg3AS/8NxWVWMpbkDrv6IixuDnr7+tXAslw=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB4061.namprd11.prod.outlook.com (2603:10b6:208:136::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Thu, 14 Oct
 2021 20:06:33 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 20:06:33 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Widawsky, Ben" <ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v4 08/17] libcxl: add support for the 'GET_LSA'
 command
Thread-Topic: [ndctl PATCH v4 08/17] libcxl: add support for the 'GET_LSA'
 command
Thread-Index: AQHXu1RrTTWDS7HRG0KxtGBPxmUAG6vSvF+AgAA67gA=
Date: Thu, 14 Oct 2021 20:06:33 +0000
Message-ID: <37ca5a878f72742bd85aba7989383a985e1666b2.camel@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
	 <20211007082139.3088615-9-vishal.l.verma@intel.com>
	 <CAPcyv4gMdTWPbLSo2+E6JzOzaf8soTwd+nzpBgcEZ-41BRJ63A@mail.gmail.com>
In-Reply-To: <CAPcyv4gMdTWPbLSo2+E6JzOzaf8soTwd+nzpBgcEZ-41BRJ63A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6fa65bf-ec6d-4858-f15c-08d98f4e1e88
x-ms-traffictypediagnostic: MN2PR11MB4061:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40615F519719684904E0D31EC7B89@MN2PR11MB4061.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W7HNqk84qtUZSlTtvbqFKxomKbd7mlcsIrKUh+QWCCMBOCk7ABcjltL+6lf3qkcjRXdSZk2mAOj96nvU4BORrY89R2Aso10hY2Qo/X3Vv4MRWu7fZRNxOGlWmcrqogYC8ItIvdlq0gHz0n8zvvrX5euWgVrJfwliiXYOg7N4T1hkOKS20GlZbtsUDBTDE8aFh47yD8z0rjvxdQivpta1vWxdeUCnMqdVRIGmoNDhshu12CmmKxPmuw1FHpH+WeWkOKBelrnU7DsKjmJOr0jDQfop4yvCE24RMQpPrUZVnWVnyoqqk8/jODhmsGyw5uHqaVXkjeDGx5cQgS5h/BM+lRu+aYw2LOrkQQMOhHx/PkYgywBS33FPFU+R32w2LCbUyC9+nbQPXSCsBxl8whg4Ok8b/Iu3yD71f9uVNs4K3rPQn/qGkPcuc6vxyoNaEMKPa4jiTjSNnkGjRW4uHtsTA8OQrenqbFNRQVdNanpMivqb8gl+ISLe9GLI8aXk06uAbYyeXupWhSuzqBSks01PS6Q+QycKXkgPWOGSs3IzJR4pDSgkbAOGJdDvEDVPyeRuBloddFUq8EEg/oiaTOWKfCDLxWlz8gJEViJBUISUF2KOIdsZHiIE2Ony/vqnxItrIja71n4otVdRYuP5dTxiVlA25ohJdFJtbpNi+X8mSHa4eDoaWeqalKG06NikfBQ8PUsQGnPJyf2El70mcys/mA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(2616005)(8676002)(4001150100001)(38100700002)(82960400001)(6486002)(38070700005)(36756003)(186003)(508600001)(6512007)(66946007)(6506007)(122000001)(53546011)(8936002)(5660300002)(64756008)(26005)(4326008)(6862004)(316002)(91956017)(37006003)(66556008)(76116006)(66446008)(66476007)(54906003)(2906002)(6636002)(83380400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bEpnZThLTEZBUTBaMkQ5d1BoQkM1SmRTaWo5OXllSVFOQ1Z6dHR4bk9UZG44?=
 =?utf-8?B?MEpHeUs0TmltTWNxVG11d2lYZnBMaXlyL3h6QXNUbjI0S09EcjJmRGJ5SXVz?=
 =?utf-8?B?NW5nbWdSLzVIUzVjSzcrUElGbGkzb3FMdVN1cmxrcTl5czdSbm9vMGRvd0ZX?=
 =?utf-8?B?V245MlY4R1YrZDJrTmpuT3lVYUcwNE1uNUNZV045LzBVZ3pqdkV3YS9UeHY4?=
 =?utf-8?B?TmlzU1VVR1BUdUFBYzMyWWpVVFEvckhQTHdxRVBSanFOWDBNZCtEbXA2RjJz?=
 =?utf-8?B?a0lGZ0VPdUVNT1poTW1QZ1Izb2VOcU1lWkpPZUJGOW5MN3BzOVRiRHpIbmZN?=
 =?utf-8?B?RzNmWm1HY0pFM2xReWpnakxXWmlCS2JFSFFhWjdhMGZyMEpibUttcnV3VlpW?=
 =?utf-8?B?ckdRUldSQ1lMMWtiUnNXYnpSUG9lMWZVbkxBL0c2dHBaR2ZFZEN5Y2pvODd0?=
 =?utf-8?B?QWFyUFQvK0cwRmRqUmx6cVBLK0RzeWtzQ3NSYlBkbmRQZTM3bUVNb0NjbHVu?=
 =?utf-8?B?R2FMeGhYMUhFWlYzajBwZTl3cHRrZ0ExNXpBZ0o5VEdzR3d3N0s0TzdnQm8y?=
 =?utf-8?B?UytEdEwwYURySTdRWmhmVmlSM2JhcWk3ZnNGVmxKRndVV3UzUDIvbDYxdk0r?=
 =?utf-8?B?QUs5eVpHWmxhTFJjQWRCN1JrQktONkV6MFFFUndxRVJ6M2tUckRrNXFIaHdo?=
 =?utf-8?B?dzlWMzlLRXV2dkk5S0JZYzZESlVmNVk1NGtUREY3OXpBQmJaN3JBS0RaK0tT?=
 =?utf-8?B?OXpMN1lIUUdYdEh0Tm13OENXSnhvWStHQVlGTFRUdU9pYkZzcU1OSTh0QnU4?=
 =?utf-8?B?UDlIYmdwaHJwdERVNHprYXh1MEVqMkd4UzlnWXhRMmRTbnpmZ3ZZVEs1MDl2?=
 =?utf-8?B?MTBGYlFvcUpDemhvN0N5aUlkRHFJZ3BjU1RzRnBxc1lFQTNLY2x6enZ3RDA2?=
 =?utf-8?B?WHpxbjFsR29sSWQ5K0FJRDZOUVlWa3ltbnJNZmRIVkEvQkw4RituOFJ2RVJV?=
 =?utf-8?B?NkJyeEdabUdmbGd3K1NqSnBwSS9POXk1Y3BzeVhrNzZyVnkzakQ3VGVZV005?=
 =?utf-8?B?ejRDMk5RRTlPbFhwQnhGZXN6Q25weVRwczFWOUUwaFN0RkkvbkdaQXVFejJq?=
 =?utf-8?B?STQzVmF2Tk1tdUJjN016R2RueXRzanlHYTNmTC9QTmRvWDJNai9SV1MyT0Z5?=
 =?utf-8?B?STNqNEhrYUdWaENMTjZpUnJaZWJ1UE1rZ1pnSmtIeGhCODExeTJBK1RVcUhF?=
 =?utf-8?B?MEsyaThrQW5TbTNsK3pnMjhhaWt1M2tNdE1xc2hIY2dtdXRFRVBJWk5mSG4w?=
 =?utf-8?B?ZkM5QmVaMWprT2E5UnRreUFFK1huank3NlhCcloyV0ZsQ01oNGtVd3JQRlhI?=
 =?utf-8?B?MDV4YUYySXY4MXRyeThpOFRVR0x1QmJObzBsSFhoNm5pZmZSMXRxR0xGRVBM?=
 =?utf-8?B?VldiaFp3N3d4QjlqbWxvL1NrdFBwdlhEdFNNeHE0OVhlNExKMnNWdGk3M3Ru?=
 =?utf-8?B?ckljbmdicU5xZGs3d0l3VHA5V3NCT1Njcm8zNEc0UWFtNkE3bG80ZjhoUHJD?=
 =?utf-8?B?RjVUVXAzRFdQNXFwVGYvL2tGcGtGNDA1K1ltNHRkTXdMcHZia0U3MStvOTFY?=
 =?utf-8?B?di9ZVlorWkEyeHRJMFFaeHJSTmx6NklUcE9sdGlhNVJZSkxROVcyeEJqUnVT?=
 =?utf-8?B?bFIwc1RibExjY3lLU293VDBFOEZvWWZWZTBBYjNVd2g5QjJ5SlYrUGxzZU93?=
 =?utf-8?B?THhRRDFxaCtqRzVvbHJZTE1SOGk1a0V5S1MydzJQWGlNU2t0Z011NjE1clFW?=
 =?utf-8?B?N1JoZUJVTFQzOFQxWksydz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0955417DEDEBCC439C4334196A0CE6E3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6fa65bf-ec6d-4858-f15c-08d98f4e1e88
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 20:06:33.0449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lMqDdtyI1SjTk00vS0f8CMsOIXsdsCYlELqnaiqay4/wOOkN4Tj5xPgKiRr1jY33ieCy92wuF+dwug4oQTa4SOyviAYnEMH/H0CNsEjmkmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4061
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTEwLTE0IGF0IDA5OjM1IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgT2N0IDcsIDIwMjEgYXQgMToyMiBBTSBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZl
cm1hQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gQWRkIGEgY29tbWFuZCBhbGxvY2F0b3Ig
YW5kIGFjY2Vzc29yIEFQSXMgZm9yIHRoZSAnR0VUX0xTQScgbWFpbGJveA0KPiA+IGNvbW1hbmQu
DQo+ID4gDQo+ID4gQ2M6IEJlbiBXaWRhd3NreSA8YmVuLndpZGF3c2t5QGludGVsLmNvbT4NCj4g
PiBDYzogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+ID4gU2lnbmVk
LW9mZi1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQo+ID4gLS0t
DQo+ID4gIGN4bC9saWIvcHJpdmF0ZS5oICB8ICA1ICsrKysrDQo+ID4gIGN4bC9saWIvbGliY3hs
LmMgICB8IDM2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICBjeGwv
bGliY3hsLmggICAgICAgfCAgNyArKystLS0tDQo+ID4gIGN4bC9saWIvbGliY3hsLnN5bSB8ICA0
ICsrLS0NCj4gPiAgNCBmaWxlcyBjaGFuZ2VkLCA0NiBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9u
cygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9jeGwvbGliL3ByaXZhdGUuaCBiL2N4bC9saWIv
cHJpdmF0ZS5oDQo+ID4gaW5kZXggZjc2YjUxOC4uOWM2MzE3YiAxMDA2NDQNCj4gPiAtLS0gYS9j
eGwvbGliL3ByaXZhdGUuaA0KPiA+ICsrKyBiL2N4bC9saWIvcHJpdmF0ZS5oDQo+ID4gQEAgLTcz
LDYgKzczLDExIEBAIHN0cnVjdCBjeGxfY21kX2lkZW50aWZ5IHsNCj4gPiAgICAgICAgIHU4IHFv
c190ZWxlbWV0cnlfY2FwczsNCj4gPiAgfSBfX2F0dHJpYnV0ZV9fKChwYWNrZWQpKTsNCj4gPiAN
Cj4gPiArc3RydWN0IGN4bF9jbWRfZ2V0X2xzYV9pbiB7DQo+ID4gKyAgICAgICBsZTMyIG9mZnNl
dDsNCj4gPiArICAgICAgIGxlMzIgbGVuZ3RoOw0KPiA+ICt9IF9fYXR0cmlidXRlX18oKHBhY2tl
ZCkpOw0KPiA+ICsNCj4gPiAgc3RydWN0IGN4bF9jbWRfZ2V0X2hlYWx0aF9pbmZvIHsNCj4gPiAg
ICAgICAgIHU4IGhlYWx0aF9zdGF0dXM7DQo+ID4gICAgICAgICB1OCBtZWRpYV9zdGF0dXM7DQo+
ID4gZGlmZiAtLWdpdCBhL2N4bC9saWIvbGliY3hsLmMgYi9jeGwvbGliL2xpYmN4bC5jDQo+ID4g
aW5kZXggNDEzYmU5Yy4uMzNjYzQ2MiAxMDA2NDQNCj4gPiAtLS0gYS9jeGwvbGliL2xpYmN4bC5j
DQo+ID4gKysrIGIvY3hsL2xpYi9saWJjeGwuYw0KPiA+IEBAIC0xMDI4LDYgKzEwMjgsNDIgQEAg
Q1hMX0VYUE9SVCBzdHJ1Y3QgY3hsX2NtZCAqY3hsX2NtZF9uZXdfcmF3KHN0cnVjdCBjeGxfbWVt
ZGV2ICptZW1kZXYsDQo+ID4gICAgICAgICByZXR1cm4gY21kOw0KPiA+ICB9DQo+ID4gDQo+ID4g
K0NYTF9FWFBPUlQgc3RydWN0IGN4bF9jbWQgKmN4bF9jbWRfbmV3X3JlYWRfbGFiZWwoc3RydWN0
IGN4bF9tZW1kZXYgKm1lbWRldiwNCj4gPiArICAgICAgICAgICAgICAgdW5zaWduZWQgaW50IG9m
ZnNldCwgdW5zaWduZWQgaW50IGxlbmd0aCkNCj4gPiArew0KPiA+ICsgICAgICAgc3RydWN0IGN4
bF9jbWRfZ2V0X2xzYV9pbiAqZ2V0X2xzYTsNCj4gPiArICAgICAgIHN0cnVjdCBjeGxfY21kICpj
bWQ7DQo+ID4gKw0KPiA+ICsgICAgICAgY21kID0gY3hsX2NtZF9uZXdfZ2VuZXJpYyhtZW1kZXYs
IENYTF9NRU1fQ09NTUFORF9JRF9HRVRfTFNBKTsNCj4gPiArICAgICAgIGlmICghY21kKQ0KPiA+
ICsgICAgICAgICAgICAgICByZXR1cm4gTlVMTDsNCj4gPiArDQo+ID4gKyAgICAgICBnZXRfbHNh
ID0gKHZvaWQgKiljbWQtPnNlbmRfY21kLT5pbi5wYXlsb2FkOw0KPiANCj4gQW55IHJlYXNvbiB0
aGF0IEBwYXlsb2FkIGlzIG5vdCBhbHJlYWR5IGEgJ3ZvaWQgKicgdG8gYXZvaWQgdGhpcyBjYXN0
aW5nPw0KDQpUaGUgc2VuZF9jbWQgaXMgcGFydCBvZiB0aGUgdWFwaSB3aGljaCBkZWZpbmVkIGl0
IGFzIF9fdTY0Lg0KDQo+IA0KPiBPdGhlciB0aGFuIHRoYXQgdGhpcyBsb29rcyBnb29kIHRvIG1l
Lg0KPiANCj4gWW91IGNhbiBhZGQ6DQo+IA0KPiBSZXZpZXdlZC1ieTogRGFuIFdpbGxpYW1zIDxk
YW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQoNCg==
