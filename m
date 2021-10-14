Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE182C81
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 22:25:03 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="228084573"
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="228084573"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 15:25:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="716317000"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 14 Oct 2021 15:25:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 15:25:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 15:25:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 15:25:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZq9UzR+tMjNgIfiJAWnGijSoonWWahnKbaTdQ0JzQ26UwpvqMXUTORf4wkz9pFwmH1qc60cidj4VeHYGoUp/jJ6j/2F8a2o+xzS14U/Ef1ZGLbY2B7z3pnY3l61rBXuikSfCHQHWMIDWPZdwr+NVHB9kUNC8qbxB8KjnXM6FmhkwhL9MvugHc95jPB8s4Ukbw4GTb8hM9HZ1TernNewTL12Sfu2wbsAFs4Vsozo+/moe4idzA8RU1nYgMyJTjUTKum0YoFr6wOMVKumIB2osx+jEEYy8HP5dLcES987cnn9DvlqTwvo8pw4U+cdESYBpn6lFTTUosbZUsDBXppzCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MYsXUcAd4VVOqCUNhoO5HvY/kdZmJ/hnF3F+chkPRys=;
 b=dzCmRO/+P9Ca21iyIjW3BTv/QI53vaZgTusgM8z1uqLZc5tAAyf/32wnveDJq522F3XEXzNY5AmnsYOByUiJ16/O25aMzBiEBoWjcweTVYEnysqjv5U161rVbrv1DJHkJ1TF8jVZfwxgrCClnrfiQPbNN8inYZ1VPmEGPq1Qg0xJFRB2gL4hrrWi4o5T6nQxboDWa3DhFXTQ0SOOM2hFmlGo6Ib5vHG7uPLhHl6cFHCAgTX/7IlWC5eO0M8TXMuiaSSf1CfPxEaWaW7t31aUA38JNVD66QNGDVjzygRYdVpcvCnbwesAYWJrY8NzTB4kMNAdgGwx/wRnVsLS08HjHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYsXUcAd4VVOqCUNhoO5HvY/kdZmJ/hnF3F+chkPRys=;
 b=fHbPp4/02A9UxFTM3YozbYpCoVjaZnoWdvUEVhVJp8rAVXP4BED3UvasJk/wrrScgIw/EipFoG/c1IQ50z+FaswcWqofMlCSMCcbIVWisIoSlCqZrVnse5hIIa7VGWVD/Zjm9bN8u7LfZr8vsE2YzuaAw45f4EobvdKjJbSkN44=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB3677.namprd11.prod.outlook.com (2603:10b6:208:f6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Thu, 14 Oct
 2021 22:24:58 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 22:24:58 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Widawsky, Ben" <ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v4 12/17] libcxl: add interfaces for label
 operations
Thread-Topic: [ndctl PATCH v4 12/17] libcxl: add interfaces for label
 operations
Thread-Index: AQHXu1Rq9q1X6I8ntkilD26l2D4w4qvTDdGAgAAQKYA=
Date: Thu, 14 Oct 2021 22:24:58 +0000
Message-ID: <6637d78d46c03296b7c31452becbeed6236a8c83.camel@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
	 <20211007082139.3088615-13-vishal.l.verma@intel.com>
	 <CAPcyv4h49Cei27qLAL8oUmcpa=Su_VArrAEzGwt3VSbpCoxYTw@mail.gmail.com>
In-Reply-To: <CAPcyv4h49Cei27qLAL8oUmcpa=Su_VArrAEzGwt3VSbpCoxYTw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8a16dc7-ef08-45fe-83ec-08d98f6174cf
x-ms-traffictypediagnostic: MN2PR11MB3677:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB367784CA0FF2FD721BF9FE45C7B89@MN2PR11MB3677.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tG0f0sE1j52Wruqs0uyXRbd/LFiAETwZ7IX5/WOyIxmapBjQ+fg+wsNwRPGu5RyDOuztRSGSaaafN3dwCgs9VxwEorkWv48BBQtqRdOa6qClc3wdR9LwJfEbGTfp9GUt3NGbUgO744BA7UDEZdPkzqzXpYTwoRI+nik3jjAQiD1cM4iUKS6kfB4qL8S41FQ/vOuHyiMGfSWd3mR2qwgHdJAgDx1hE8Z2EcbyAYKZUIi5aW+O2JNxzzr/4RKjzbToM5E+SFJE6F4dnV5tLAdvauqxxKPfljHCUUp5jZ2EgoRR4RMCseO0kouCflyJQ1b8guh5l06fLCF6S0Opq99iVn3dqptid+dLbu5gtnqCpeyU1ID6LB0pwZAF1gIAmrNElJgi34g5zL/Lb3MuKwmZ84rLjGpAmtI/8Mz+w8ptU19fSfrDyhVq1U8zWZl28C29Szncgcxzb6qbzUrhMuRzdQ0ImmWApLytO5Ifn/uoLwonsqiF3WwV9kRPuhfV1vfdWUiC+j7i4dalRBE7Bt9ygVjOarwfhccuQzeV5czq2ax8DEiBD4FleSh+5uskjQn89OyhflAnSzoHT1AucJl+PY/JlmC8+om4WJRhCdbJ0e4s/h6cRwX+QSFddDnWluMTpDTak6WPfcmcV85bHdHzPp3IC/E4ahic8tG3wB/8hZECTBc/Ym7SuvqoJNNOqQa10ug1w39m0Av4XfzUqxuQOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(8936002)(66946007)(186003)(316002)(66556008)(71200400001)(36756003)(2906002)(38100700002)(2616005)(4326008)(64756008)(66476007)(508600001)(38070700005)(6486002)(6636002)(4001150100001)(6862004)(6506007)(8676002)(76116006)(91956017)(6512007)(54906003)(5660300002)(37006003)(53546011)(122000001)(26005)(82960400001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TEdudFdhdFFTVktIdm1EVTd2SnFodjFhUjVsVXdWTnNlOUIzMEI5cVRoZmg3?=
 =?utf-8?B?M0U3Skg1Y2dSODJRSTJLUSs0ZnB6bWxZdjRjeHVUVGlVU3dNN3NOS0t2Kzc3?=
 =?utf-8?B?WHBpZE9NbnU0UjRBY09MZTd5UWpJZkFHVnEyaDdSZHVYbHdTSzR1QTlSdXlI?=
 =?utf-8?B?VkM0aVpqMTNuZFpjVDNmNktMMHltOWViQjhpMG5DYjhzT00vL0orcWtIb1kx?=
 =?utf-8?B?aUtYR2FlMnQ4NGdqZXBBUjlMY05pRnBxeDVTa241REhISlY4Rmd6L3ZHWmRv?=
 =?utf-8?B?L3Y3OVV3K3p5N2FDNHlzemdJSk1SSkpnUlBocnlTYmxkb1RtS1lKSEtvb2ZE?=
 =?utf-8?B?NC9jcktxZlNVUGFxN1A0bUgvLzZ1NTFLcmtJb2ZNcTlwUGwrNTdwV3lXODdE?=
 =?utf-8?B?aXdDR25xcjZYTE9LS25kaldxSXFnTVNoTWhLMlB5K2hQR1gyNXphK2dhVVpK?=
 =?utf-8?B?ZnFsYnVGcHZZa0ppSitCb0ZEK3cxaURGNFR1RFZmdzQ2ZFFQVnl6US81azJo?=
 =?utf-8?B?UE9WR3JvVmQ0Q253T0FwTjg2Q2NsSlFVZHErYmVkaFV2YXFVaUtadlZmaHM5?=
 =?utf-8?B?UmQ5ckNqRitXaExVRUhZeUUrKzY5UGRXT2Fab1hHTUt3Q1hYM29FdVJpeEZK?=
 =?utf-8?B?SGhuQVFGQ2pKNXB4eVg0YkdoUks3YjdYblNQeUtmSU0yUXZwalM5NXA5QUhO?=
 =?utf-8?B?YjdTNnhLV1V6Skc1YXhQRklZbisyd2V1eEdTUUFJbEJvT3ZZSUlDSUUzOGVU?=
 =?utf-8?B?UkM4OVp5aURtVVFMSUNkY0MwMFg0ZmF6K29EanFlaU5icjVNbFlhSEdkRjNk?=
 =?utf-8?B?RGFNL3duK0dPZEc5Yy9nNXMxenNmUUcvQldGRW5LWkdaUExtdE5sTlRNZHEz?=
 =?utf-8?B?cUw1d2l4WlNkZXF1MmgrV2tIbklFQTk3b1NZTzJZT2dYRFlrQzhXeWJGcGhZ?=
 =?utf-8?B?bTFaYnRxRlVSTU44NXVRanhhKzhhcnAzTERaa0VVczlXRDkvOC9wWnY3anlp?=
 =?utf-8?B?UlkyOEIrd0MzNG8rSjB0Rzc0ZkJwZ1lQYkJ2eUxqN01TczkreGF0dnY0UXdQ?=
 =?utf-8?B?cFRxZ3NZT1JYU2hKR3RxeWJGMHhsZGkrVWtMMytRcnlCZkJRRnNwSENKVTBj?=
 =?utf-8?B?bmtuVUZROGw2Z3o1a3VQdkNGSlo1ZFYxb2tNa3RZZ0UxNUhlM2dpMUdFUEh0?=
 =?utf-8?B?UUcwZ2ZuS0p1QkMyN1RhOHZIM0YvM2dYaTA4bW13dFNHYXd2Z0EzdENQUWNu?=
 =?utf-8?B?T0g4bVNxSVNrSTI1UGU3K3NabmpjS3JFVjRJZG13VGM3anBxMnR5aVZkcGlX?=
 =?utf-8?B?VWZQMU9qZlN5endFM0c0NU4wTkg3VkVTNktSN1N3UitEbS85VVdoT1lreUxr?=
 =?utf-8?B?bmo5TTMycUxJZUtpWWdjL2FuaC80MGl3b3FrUUk2ajRyUlFtWDJ3b3AzN3Uz?=
 =?utf-8?B?ZTlRTVNSZzhkQk5xN3FBV0YrdGVlSXRNdEdnM1p2WkVMVUozR2VjaStoOUkz?=
 =?utf-8?B?T3FiVDlHODAycmdaM0o5MHRMT1dta0hRRXJFRk5jckxZeStmMjNuZGIvWU8v?=
 =?utf-8?B?UjE2Q29rNUZ6alBrZ1NSWk5VNmpLTE5nek80SERSS2ViUStUQjhzSEtSUzdV?=
 =?utf-8?B?cFZkT0dwVFhIaS9tSGZjNFJ5L1ZBdzV1ejcvNUQ4ZWpTaFVwcTBPWmI2VStO?=
 =?utf-8?B?SWMwSUFxdllSR0dWdVg2bitYckE5YTR4eW9oRWxvYjEySWRncmtzd3lHM1FP?=
 =?utf-8?B?TVhaZDBET1o4VTlHd3pCTkF5VVp3NTJYUU5hTFlGUUNqTUh4cHl6Z3pNRGpw?=
 =?utf-8?B?M2dpRHJmTW1objZiVE4rdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB8558FDABA47647B52217758D762EFE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a16dc7-ef08-45fe-83ec-08d98f6174cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 22:24:58.3332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G99hAN+zet8j1rQVis802Y3P1Pybnrx+EQNb6KnWWCfrR9kqenTcSFJC5FaYByDNOfuuFJQUynA5S9jQIWAwocHKvtvgMiNVcglzF7evtxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3677
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTEwLTE0IGF0IDE0OjI3IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgT2N0IDcsIDIwMjEgYXQgMToyMiBBTSBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZl
cm1hQGludGVsLmNvbT4gd3JvdGU6DQo+IA0KDQpbLi5dDQoNCj4gPiArDQo+ID4gK0NYTF9FWFBP
UlQgc3RydWN0IGN4bF9jbWQgKmN4bF9jbWRfbmV3X3dyaXRlX2xhYmVsKHN0cnVjdCBjeGxfbWVt
ZGV2ICptZW1kZXYsDQo+ID4gKyAgICAgICAgICAgICAgIHZvaWQgKmxzYV9idWYsIHVuc2lnbmVk
IGludCBvZmZzZXQsIHVuc2lnbmVkIGludCBsZW5ndGgpDQo+ID4gK3sNCj4gPiArICAgICAgIHN0
cnVjdCBjeGxfY3R4ICpjdHggPSBjeGxfbWVtZGV2X2dldF9jdHgobWVtZGV2KTsNCj4gPiArICAg
ICAgIHN0cnVjdCBjeGxfY21kX3NldF9sc2EgKnNldF9sc2E7DQo+ID4gKyAgICAgICBzdHJ1Y3Qg
Y3hsX2NtZCAqY21kOw0KPiA+ICsgICAgICAgaW50IHJjOw0KPiA+ICsNCj4gPiArICAgICAgIGNt
ZCA9IGN4bF9jbWRfbmV3X2dlbmVyaWMobWVtZGV2LCBDWExfTUVNX0NPTU1BTkRfSURfU0VUX0xT
QSk7DQo+ID4gKyAgICAgICBpZiAoIWNtZCkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuIE5V
TEw7DQo+ID4gKw0KPiA+ICsgICAgICAgLyogdGhpcyB3aWxsIGFsbG9jYXRlICdpbi5wYXlsb2Fk
JyAqLw0KPiA+ICsgICAgICAgcmMgPSBjeGxfY21kX3NldF9pbnB1dF9wYXlsb2FkKGNtZCwgTlVM
TCwgc2l6ZW9mKCpzZXRfbHNhKSArIGxlbmd0aCk7DQo+ID4gKyAgICAgICBpZiAocmMpIHsNCj4g
PiArICAgICAgICAgICAgICAgZXJyKGN0eCwgIiVzOiBjbWQgc2V0dXAgZmFpbGVkOiAlc1xuIiwN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgICBjeGxfbWVtZGV2X2dldF9kZXZuYW1lKG1lbWRl
diksIHN0cmVycm9yKC1yYykpOw0KPiA+ICsgICAgICAgICAgICAgICBnb3RvIG91dF9mYWlsOw0K
PiA+ICsgICAgICAgfQ0KPiA+ICsgICAgICAgc2V0X2xzYSA9ICh2b2lkICopY21kLT5zZW5kX2Nt
ZC0+aW4ucGF5bG9hZDsNCj4gDQo+IC4uLnRoZSBjYXN0IGlzIHN0aWxsIG5hZ2dpbmcgYXQgbWUg
ZXNwZWNpYWxseSB3aGVuIHRoaXMga25vd3Mgd2hhdCB0aGUNCj4gcGF5bG9hZCBpcyBzdXBwb3Nl
ZCB0byBiZS4gV2hhdCBhYm91dCBhIGhlbHBlciBwZXIgY29tbWFuZCB0eXBlIG9mIHRoZQ0KPiBm
b3JtOg0KPiANCj4gc3RydWN0IGN4bF9jbWRfJG5hbWUgKnRvX2N4bF9jbWRfJG5hbWUoc3RydWN0
IGN4bF9jbWQgKmNtZCkNCj4gew0KPiAgICAgaWYgKGNtZC0+c2VuZF9jbWQtPmlkICE9IENYTF9N
RU1fQ09NTUFORF9JRF8kTkFNRSkNCj4gICAgICAgICByZXR1cm4gTlVMTDsNCj4gICAgIHJldHVy
biAoc3RydWN0IGN4bF9jbWRfJG5hbWUgKikgY21kLT5zZW5kX2NtZC0+aW4ucGF5bG9hZDsNCj4g
fQ0KPiANCklzIHRoZSBuYWcganVzdCBmcm9tIHVzaW5nIGEgdm9pZCBjYXN0LCBvciBoYXZpbmcg
dG8gY2FzdCBhdCBhbGw/IEkNCnRoaW5rIHRoZSB2b2lkIGNhc3Qgd2FzIGp1c3QgbGF6aW5lc3Mg
LSBpdCBzaG91bGQgYmUgY2FzdCB0b8KgDQooc3RydWN0IGN4bF9jbWRfJG5hbWUgKikgaW5zdGVh
ZCBvZiAodm9pZCAqKS4NCg0KSGF2aW5nIGEgaGVscGVyIGZvciB0b19jeGxfY21kXyRuYW1lKCkg
ZG9lcyBsb29rIGNsZWFuZXIsIGJ1dCBkbyB3ZQ0KbmVlZCB0aGUgdmFsaWRhdGlvbiBzdGVwIHRo
ZXJlPyBJbiBhbGwgdGhlc2UgY2FzZXMsIHRoZSBjbWQgd291bGQndmUNCmJlZW4gYWxsb2NhdGVk
IGp1c3QgYSBmZXcgbGluZXMgYWJvdmUsIHdpdGggY3hsX2NtZF9uZXdfZ2VuZXJpYyhtZW1kZXYs
DQpDWExfTUVNX0NPTU1BTkRfSURfJE5BTUUpIC0gc28gaXQgc2VlbXMgdW5uZWNlc3Nhcnk/DQo+
IA0K
