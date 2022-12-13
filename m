Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383D2323B
	for <nvdimm@lists.linux.dev>; Tue, 13 Dec 2022 23:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670972868; x=1702508868;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=4t6T58gcFOQsdky8cvFbWd6F7AlLCAhYDHIiXfV+/ec=;
  b=DAlW6+vAzV1VV8yAXxIuoGy3wyn8fCGEqgm32ZH0MWgzo3gm+tYX0UrX
   MfVoyAx2z4VgNBIn0ekLghRBTOaFhabL5kxToTQ0fScv9nMKEbdtk4whO
   AVCa/u322UHdYYweaW7Y7tTiznCZ/Ufq0eAhrxyV6nr7mgAe6MuCE/YkV
   ywkGgywNXhLNw4wOZHYzOHwd/sNBwGfQ0X1G27PNRxHUm0u7zoyvuhoOs
   FNJE8/MFrYqte1kFc/Zw1wPyemupSapVsp0PmC/fLJi8Fmbw7MW4+ubv2
   HstKpt6ifPmoMMEk9/y6aR72tgf43Ba+HFuD8JkR4XvTRLbJwvm8CJxRa
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="404522819"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="404522819"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 15:07:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="679474281"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="679474281"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 13 Dec 2022 15:07:47 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 15:07:46 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 15:07:46 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 15:07:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGRdguIqykXTXCyc1o50ALM8CHPPzRSBRgYT0A5oKdTiw1d8Vm/AxZDmitDDmOhxr/bZtNpDSiKLSXCo/rMJmDuILfxW/MkYmtw8fi3zRCiBLM4DIXwupyLyw+dwi52Cf/mZ75NJMHlhjWtNlFgXFGyvD7REUT0jcAVTJbQWzdEdqzqyOyxaQipDh0V74t3ZkQY/YqRK4WgWCDyVPI0+JO0mN84c1szJah/FPPTB/29rBmINQzxeaV7gryiwBQXm9QRYbX06Jt1+JKJODg5VgGDmyKLmyZwvQPypVfj+IauZzy/DIWYegZmO5VSXbkUdMZsOp6C1/R2OY6QEIdm0Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4t6T58gcFOQsdky8cvFbWd6F7AlLCAhYDHIiXfV+/ec=;
 b=GyV+JztMGmkFNwrtuuzbUMIy7A5lf2wqpUquTID1aI1MArw4KmUyYuHeMtOS5OKiza/MPjLr39hI0JtXxJ8T9rk76r5np5GOQ2TXIu+Cn9Qit3TW1heUw0CUnSjVVcESm0PZoTuKH58F/bMGToEX81fsfEqNjaawwF/JeYNoG/7KGFqOofvtK+eTT3GinWivjYH7ORe22PljA+Y601oC019a2SDNeUtiKN8EgnetjUKWwFbnNjXlT+0oqjAmfwM9JAVFVMPZb3bHLLDPZz5ESWmCTZaUJwceSoOkDgZczqB6h50iPLc0uUdIoekU21vEv/3t729o+yXn1XffSDIWkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by SJ0PR11MB5645.namprd11.prod.outlook.com (2603:10b6:a03:3b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 23:07:44 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 23:07:44 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH 1/4] ndctl: add cxl bus detection
Thread-Topic: [PATCH 1/4] ndctl: add cxl bus detection
Thread-Index: AQHYzf2B4D2r5sGCu0u1ya9vWITtSq5s826A
Date: Tue, 13 Dec 2022 23:07:44 +0000
Message-ID: <0670a19ef37731a2717eb6cb5e631dcaa8f3b24a.camel@intel.com>
References: <166379397620.433612.13099557870939895846.stgit@djiang5-desk3.ch.intel.com>
	 <166379416245.433612.3109623615684575549.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <166379416245.433612.3109623615684575549.stgit@djiang5-desk3.ch.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.2 (3.46.2-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|SJ0PR11MB5645:EE_
x-ms-office365-filtering-correlation-id: 85cbca64-1b9f-4007-dd54-08dadd5ed7ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R7RM+4bTa7oIOy+ocg/duJI4cXFVQCvWMadU6U0LrWAXpZ8EXKLi1S2KvIfZLouT190RDLkKsoJ63o1DHK3gXly6Z/CuCyNFsgaEW/HpVMdOSicLv/Dxq4nYYrj/f4vTDX6QTrjFSY01vDHTtoXRcXMCkvlEY5XeZ3rQGUiDmDN7OXgWgQsoLrV+kFrnK7+NNCIWdSlij6b2C7GkTVRRWNsCMnZOVU4Igh9tzf3XamEk6aa6cLWDp2YZ8Iaph5NkXdLk+ledlvP83ZgTb+Q90JuYrcUJnZRCoiqqHBXh8dWQciI5Zq5OF0QYQrLxSTTnu5Q0JdP8ayO0VEF1E2iw4B94a0O4LtZJoxi3CL4dPS2ABUNEN1MULvxRgmOPtDkwz0lrFkoq6FYHE7rZrfXIwv4XeRHK4RGUpz+OgDlcWQQGh/onxQW/JI/uczkRHJ5GhctTr0Wu69Z76qlDE7WxAPikN5skzDNtJvHnBR3JbfOwochFu0Iav6zvzQwJQLvqZSTFozeLs8uYlQGiBGtGJoBcDZyf5VytE2IXJJnNEMuQjR0BRyE97aCAZcdFd4KkNK1A5POBJHlzZhKqPf2YSRL85ZcPCFVFYFqO+Z6+GNC2dlLRnvrIETJzdry71BBAB108S2S9UdMMQcWZgUdEOO+E/n+cuPydxvs9PTw2BpTiRiFGIMttBYg7z9kREo849Xn7fADQoTprodVlS36Vuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199015)(86362001)(2616005)(2906002)(110136005)(83380400001)(36756003)(64756008)(76116006)(38070700005)(66556008)(66446008)(5660300002)(8676002)(8936002)(66476007)(316002)(186003)(91956017)(122000001)(478600001)(71200400001)(6512007)(66946007)(26005)(41300700001)(6486002)(82960400001)(38100700002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MW1hUkNxTEZoeEdXcUxjU05EaDBWOEx1UEtoenN0MXE2WGI2aUd5dCs4OTNJ?=
 =?utf-8?B?NjBnUDBmT0JOdkoxTlFJUHMxSjI2WTYrWkV2clA3NlNwa0xnMFZoYm9Rd2VG?=
 =?utf-8?B?a0xJL0VKVm5jOWRVSGdlSnExbmI1cjg3TmdpT1A5SW5abG9VWUx2QkFwTHd4?=
 =?utf-8?B?S2NmWXE1T0JRTitEQ2oxSEhoOW1vZ0JPMFBiSTRQOVNxaUZVTnRBTTVkUWE2?=
 =?utf-8?B?WjMyRElTTGZDR05vSEUxMHpUS2tyUld5ak9RZlg0emtYVE12cmpKeWdFSE4w?=
 =?utf-8?B?eUxoOFVacWZ3UzNKNEEwZk1JVzlLTzZMZXZTWlV5TmhqcDdTV2ZCOHI4bDVM?=
 =?utf-8?B?ZW9jZkd5VzdNbHh2S1hWcHFwMDNMV1ZKYjZteStVQXRpNURLY1ZIaWFwOHdM?=
 =?utf-8?B?VnJ5ZGlnMWN1ZytXRzU3QVlTUGh1UC9zT2NqbGJLTnJVSTM2dUthSEdOQzNx?=
 =?utf-8?B?TnhFZ3hVckllSlV1aUVlNEk5VTZFYVFqbStidHEyUVJodjF4cDk3eCtENEl4?=
 =?utf-8?B?TGZJZEpFNzFKQ2NFamlYRmg5M1o1TlY1TmlRanM1TTRpdDhDS0N4eFA2bHlj?=
 =?utf-8?B?Uk1RNDBnZjRNekV4Zis5ZUdDUEdoQkdNUmRsbXVnNXNkcEVRUDhFRXZRT0Jr?=
 =?utf-8?B?WHFWYm1RS3dONnpCZnpvTGszdUErMDNmTDIvejh3dUl3U3IxaG54cCt1Z3lW?=
 =?utf-8?B?aDk4MGswdjhuSklOeWhyQlRDQVh6RVVXOTVCSEhNSEw0Yi9ScVBYT05sWDRF?=
 =?utf-8?B?a0F6NzViZHl3d3VkR0l4TlFyRWpqUEVvZWMxdUhJTDdsWmtDMzRMSFV3U1Bs?=
 =?utf-8?B?WjBuWFZqT05MOEVqWDlyNzh2YzZTay82SFZwY1crVW5ud1Y1eUlUeFNNbXR4?=
 =?utf-8?B?Z1ppcC9uMEV1K01tT2RFRFZodmxWUzVLSDNPL09vQTRJTEYwVmFGTDQ0YTFQ?=
 =?utf-8?B?S05neTk4ejh2UzNETHUxdmZpL3EwZk1PMy9kTkZIS051bzdBMjJRYjh3Ykt4?=
 =?utf-8?B?UEJuTXJTVTAyLzhXRmJQTkx4c21aRzJSUGJueGt0aHVITW5EdmpBbnBJZEdY?=
 =?utf-8?B?anJWTXk0VXhYckl5RW1GQVhYaFVYNTY0NW1FMTNzTjd3V3BNbzhKczJCbENp?=
 =?utf-8?B?ODArcWZ5KzVSSkhIUUcrVzdUM0VweUl4eVIrY0xBU1lZb2hBNXdyd2lBN29Y?=
 =?utf-8?B?T3FSbGRBMnZ1NjVQNXQ5T3JUUDN5U2Qwd3phWUtaMnpPTWlDMjFwN3hsdDNV?=
 =?utf-8?B?VFRjL29laVFGMFl4N3k3Q2c1RDhIN0FJQWRzYWovVklGQTI2aVFvdkhWYVF0?=
 =?utf-8?B?QzkxU3puOHp0ZDNicGVZVXVJTDc4S2hOeGk5VldsTElRZGtTRjFBcEVta1Z5?=
 =?utf-8?B?VGlwNUl6Uno4V1VtOTVmN0d3V3FjbWFXM2c4Rll5eXBZZ2VTdDFqNk5TejFN?=
 =?utf-8?B?bDBMdWNnOXFGaG1DRHYyUXZnQWVPRnhEZE1GYnQwMWRyeWhVZzgzYkVGNnhh?=
 =?utf-8?B?R3k5NFgrOCtqMGZkSTA1ejZGTVNSZ0hFc3NxOWlRNlF4S25oVGJuN3VVbnYy?=
 =?utf-8?B?cVl4SlBEVk00anRpSE1iRlNsRndnbEg4TC9jZlpmME5yV3RwRktwYmNyWVk5?=
 =?utf-8?B?OEJDUGJLVmtUMmswTitrL1JKeENQeENjU0xnV2JrelR2Ni9WQk94TFF4akQ4?=
 =?utf-8?B?bzJCdERtazRlSDl1S1IzMTBxaHdWbDhMWTk1bE1CbGtkUytiYjVDbTVrbHBm?=
 =?utf-8?B?T25QY2NZSFFHOTAvK0dHYzJtQ2E3RDhqRjNqNzlncmRjVzZlQ0tadVo5T0N5?=
 =?utf-8?B?M3U4Wnp0RXlzcFRGMzUyWEFycDJWWGV5TGx4SmRNYUY2V2c0VWdJN1ZudVRQ?=
 =?utf-8?B?cXlwL3RPcE1jWUNRTUQyMEF4VmRqVUJLc1lnQmpRRmM0WW1QUkhGRkNWeTlT?=
 =?utf-8?B?QjRSV2RNV1hLOWdzOHplTlZpc1A3ZDl5Y28zMmRQU3Z3S0dUS01hRkJWVFhL?=
 =?utf-8?B?cDVuNGpzZm5MSzR6U2w5NE5BbThSMGJjZDZRZmZJSXVtbnNmRmVDdnhWRWlR?=
 =?utf-8?B?Z0VKeW5ZbE9lUk5xMENNc0hNd3VlcWNTYWdORjBUZnVXWml0Vk9vR3pEUGJL?=
 =?utf-8?B?WGYwbWVzemxYY3d5azRMWXpsbUtKZU1HS3MzQkFkdXBydnV5R3ZwZnBSOWR4?=
 =?utf-8?B?S3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6C344A11B2D6E488D2682099DBFEBAE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85cbca64-1b9f-4007-dd54-08dadd5ed7ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 23:07:44.6255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G1J4rw1T24Zc3nLbWcPGuPClX2z4BWAxUARIhwr1mCJZOtUWp405BUNI7yiYklefELnbeDdtlH5aeKm5rOm2xrMVOqQSI9hCmAI3zbEkapY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5645
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIyLTA5LTIxIGF0IDE0OjAyIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOgo+IEFk
ZCBoZWxwZXIgZnVuY3Rpb24gdG8gZGV0ZWN0IHRoYXQgdGhlIGJ1cyBpcyBjeGwgYmFzZWQuCgpD
YXBpdGFsaXplIENYTCBpbiBzdWJqZWN0IGFuZCBoZXJlLiBUaGlzIGNhbiBwcm9iYWJseSBiZSAi
QWRkIGEgQ1hMIGJ1cwp0eXBlLCBhbmQgZGV0ZWN0IHdoZXRoZXIgYSAnZGltbScgaXMgYmFja2Vk
IGJ5IHRoZSBDWEwgc3Vic3lzdGVtIgoKT3RoZXJ3aXNlIGxvb2tzIGdvb2QuCgo+IAo+IFNpZ25l
ZC1vZmYtYnk6IERhdmUgSmlhbmcgPGRhdmUuamlhbmdAaW50ZWwuY29tPgo+IC0tLQo+IMKgbmRj
dGwvbGliL2xpYm5kY3RsLmPCoMKgIHzCoMKgIDUzICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKwo+IMKgbmRjdGwvbGliL2xpYm5kY3RsLnN5bSB8wqDCoMKg
IDEgKwo+IMKgbmRjdGwvbGliL3ByaXZhdGUuaMKgwqDCoCB8wqDCoMKgIDEgKwo+IMKgbmRjdGwv
bGlibmRjdGwuaMKgwqDCoMKgwqDCoCB8wqDCoMKgIDEgKwo+IMKgNCBmaWxlcyBjaGFuZ2VkLCA1
NiBpbnNlcnRpb25zKCspCj4gCj4gZGlmZiAtLWdpdCBhL25kY3RsL2xpYi9saWJuZGN0bC5jIGIv
bmRjdGwvbGliL2xpYm5kY3RsLmMKPiBpbmRleCBhZDU0ZjA2MjY1MTAuLjEwNDIyZTI0ZDM4YiAx
MDA2NDQKPiAtLS0gYS9uZGN0bC9saWIvbGlibmRjdGwuYwo+ICsrKyBiL25kY3RsL2xpYi9saWJu
ZGN0bC5jCj4gQEAgLTEyLDYgKzEyLDcgQEAKPiDCoCNpbmNsdWRlIDxjdHlwZS5oPgo+IMKgI2lu
Y2x1ZGUgPGZjbnRsLmg+Cj4gwqAjaW5jbHVkZSA8ZGlyZW50Lmg+Cj4gKyNpbmNsdWRlIDxsaWJn
ZW4uaD4KPiDCoCNpbmNsdWRlIDxzeXMvc3RhdC5oPgo+IMKgI2luY2x1ZGUgPHN5cy90eXBlcy5o
Pgo+IMKgI2luY2x1ZGUgPHN5cy9pb2N0bC5oPgo+IEBAIC04NzYsNiArODc3LDQ4IEBAIHN0YXRp
YyBlbnVtIG5kY3RsX2Z3YV9tZXRob2QgZndhX21ldGhvZF90b19tZXRob2QoY29uc3QgY2hhciAq
ZndhX21ldGhvZCkKPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIE5EQ1RMX0ZXQV9NRVRIT0RfUkVT
RVQ7Cj4gwqB9Cj4gwqAKPiArc3RhdGljIGludCBpc19uZGJ1c19jeGwoY29uc3QgY2hhciAqY3Rs
X2Jhc2UpCj4gK3sKPiArwqDCoMKgwqDCoMKgwqBjaGFyICpwYXRoLCAqcHBhdGgsICpzdWJzeXM7
Cj4gK8KgwqDCoMKgwqDCoMKgY2hhciB0bXBfcGF0aFtQQVRIX01BWF07Cj4gK8KgwqDCoMKgwqDC
oMKgaW50IHJjOwo+ICsKPiArwqDCoMKgwqDCoMKgwqAvKiBnZXQgdGhlIHJlYWwgcGF0aCBvZiBj
dGxfYmFzZSAqLwo+ICvCoMKgwqDCoMKgwqDCoHBhdGggPSByZWFscGF0aChjdGxfYmFzZSwgTlVM
TCk7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKCFwYXRoKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gLWVycm5vOwo+ICsKPiArwqDCoMKgwqDCoMKgwqAvKiBzZXR1cCB0byBn
ZXQgdGhlIG5kIGJyaWRnZSBkZXZpY2UgYmFja2luZyB0aGUgY3RsICovCj4gK8KgwqDCoMKgwqDC
oMKgc3ByaW50Zih0bXBfcGF0aCwgIiVzL2RldmljZSIsIHBhdGgpOwo+ICvCoMKgwqDCoMKgwqDC
oGZyZWUocGF0aCk7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHBhdGggPSByZWFscGF0aCh0bXBfcGF0
aCwgTlVMTCk7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKCFwYXRoKQo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqByZXR1cm4gLWVycm5vOwo+ICsKPiArwqDCoMKgwqDCoMKgwqAvKiBnZXQg
dGhlIHBhcmVudCBkaXIgb2YgdGhlIG5kYnVzLCB3aGljaCBzaG91bGQgYmUgdGhlIG52ZGltbS1i
cmlkZ2UgKi8KPiArwqDCoMKgwqDCoMKgwqBwcGF0aCA9IGRpcm5hbWUocGF0aCk7Cj4gKwo+ICvC
oMKgwqDCoMKgwqDCoC8qIHNldHVwIHRvIGdldCB0aGUgc3Vic3lzdGVtIG9mIHRoZSBudmRpbW0t
YnJpZGdlICovCj4gK8KgwqDCoMKgwqDCoMKgc3ByaW50Zih0bXBfcGF0aCwgIiVzLyVzIiwgcHBh
dGgsICJzdWJzeXN0ZW0iKTsKPiArwqDCoMKgwqDCoMKgwqBmcmVlKHBhdGgpOwo+ICsKPiArwqDC
oMKgwqDCoMKgwqBwYXRoID0gcmVhbHBhdGgodG1wX3BhdGgsIE5VTEwpOwo+ICvCoMKgwqDCoMKg
wqDCoGlmICghcGF0aCkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1l
cnJubzsKPiArCj4gK8KgwqDCoMKgwqDCoMKgc3Vic3lzID0gYmFzZW5hbWUocGF0aCk7Cj4gKwo+
ICvCoMKgwqDCoMKgwqDCoC8qIGNoZWNrIGlmIHN1YnN5c3RlbSBpcyBjeGwgKi8KPiArwqDCoMKg
wqDCoMKgwqBpZiAoIXN0cmNtcChzdWJzeXMsICJjeGwiKSkKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmMgPSAxOwo+ICvCoMKgwqDCoMKgwqDCoGVsc2UKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmMgPSAwOwo+ICsKPiArwqDCoMKgwqDCoMKgwqBmcmVlKHBhdGgp
Owo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiByYzsKPiArfQo+ICsKPiDCoHN0YXRpYyB2b2lkICph
ZGRfYnVzKHZvaWQgKnBhcmVudCwgaW50IGlkLCBjb25zdCBjaGFyICpjdGxfYmFzZSkKPiDCoHsK
PiDCoMKgwqDCoMKgwqDCoMKgY2hhciBidWZbU1lTRlNfQVRUUl9TSVpFXTsKPiBAQCAtOTE5LDYg
Kzk2MiwxMSBAQCBzdGF0aWMgdm9pZCAqYWRkX2J1cyh2b2lkICpwYXJlbnQsIGludCBpZCwgY29u
c3QgY2hhciAqY3RsX2Jhc2UpCj4gwqDCoMKgwqDCoMKgwqDCoGVsc2UKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGJ1cy0+aGFzX29mX25vZGUgPSAxOwo+IMKgCj4gK8KgwqDCoMKg
wqDCoMKgaWYgKGlzX25kYnVzX2N4bChjdGxfYmFzZSkpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGJ1cy0+aGFzX2N4bCA9IDE7Cj4gK8KgwqDCoMKgwqDCoMKgZWxzZQo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBidXMtPmhhc19jeGwgPSAwOwo+ICsKPiDCoMKgwqDC
oMKgwqDCoMKgc3ByaW50ZihwYXRoLCAiJXMvZGV2aWNlL25maXQvZHNtX21hc2siLCBjdGxfYmFz
ZSk7Cj4gwqDCoMKgwqDCoMKgwqDCoGlmIChzeXNmc19yZWFkX2F0dHIoY3R4LCBwYXRoLCBidWYp
IDwgMCkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJ1cy0+bmZpdF9kc21fbWFz
ayA9IDA7Cj4gQEAgLTEwNTAsNiArMTA5OCwxMSBAQCBORENUTF9FWFBPUlQgaW50IG5kY3RsX2J1
c19oYXNfb2Zfbm9kZShzdHJ1Y3QgbmRjdGxfYnVzICpidXMpCj4gwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiBidXMtPmhhc19vZl9ub2RlOwo+IMKgfQo+IMKgCj4gK05EQ1RMX0VYUE9SVCBpbnQgbmRj
dGxfYnVzX2hhc19jeGwoc3RydWN0IG5kY3RsX2J1cyAqYnVzKQo+ICt7Cj4gK8KgwqDCoMKgwqDC
oMKgcmV0dXJuIGJ1cy0+aGFzX2N4bDsKPiArfQo+ICsKPiDCoE5EQ1RMX0VYUE9SVCBpbnQgbmRj
dGxfYnVzX2lzX3BhcHJfc2NtKHN0cnVjdCBuZGN0bF9idXMgKmJ1cykKPiDCoHsKPiDCoMKgwqDC
oMKgwqDCoMKgY2hhciBidWZbU1lTRlNfQVRUUl9TSVpFXTsKPiBkaWZmIC0tZ2l0IGEvbmRjdGwv
bGliL2xpYm5kY3RsLnN5bSBiL25kY3RsL2xpYi9saWJuZGN0bC5zeW0KPiBpbmRleCBjOTMzMTYz
YzAzODAuLjNhM2U4YmJkNjNlZiAxMDA2NDQKPiAtLS0gYS9uZGN0bC9saWIvbGlibmRjdGwuc3lt
Cj4gKysrIGIvbmRjdGwvbGliL2xpYm5kY3RsLnN5bQo+IEBAIC00NjUsNCArNDY1LDUgQEAgTElC
TkRDVExfMjcgewo+IMKgCj4gwqBMSUJORENUTF8yOCB7Cj4gwqDCoMKgwqDCoMKgwqDCoG5kY3Rs
X2RpbW1fZGlzYWJsZV9tYXN0ZXJfcGFzc3BocmFzZTsKPiArwqDCoMKgwqDCoMKgwqBuZGN0bF9i
dXNfaGFzX2N4bDsKPiDCoH0gTElCTkRDVExfMjc7Cj4gZGlmZiAtLWdpdCBhL25kY3RsL2xpYi9w
cml2YXRlLmggYi9uZGN0bC9saWIvcHJpdmF0ZS5oCj4gaW5kZXggZTVjNTYyOTU1NTZkLi40NmJj
ODkwOGJkOTAgMTAwNjQ0Cj4gLS0tIGEvbmRjdGwvbGliL3ByaXZhdGUuaAo+ICsrKyBiL25kY3Rs
L2xpYi9wcml2YXRlLmgKPiBAQCAtMTYzLDYgKzE2Myw3IEBAIHN0cnVjdCBuZGN0bF9idXMgewo+
IMKgwqDCoMKgwqDCoMKgwqBpbnQgcmVnaW9uc19pbml0Owo+IMKgwqDCoMKgwqDCoMKgwqBpbnQg
aGFzX25maXQ7Cj4gwqDCoMKgwqDCoMKgwqDCoGludCBoYXNfb2Zfbm9kZTsKPiArwqDCoMKgwqDC
oMKgwqBpbnQgaGFzX2N4bDsKPiDCoMKgwqDCoMKgwqDCoMKgY2hhciAqYnVzX3BhdGg7Cj4gwqDC
oMKgwqDCoMKgwqDCoGNoYXIgKmJ1c19idWY7Cj4gwqDCoMKgwqDCoMKgwqDCoHNpemVfdCBidWZf
bGVuOwo+IGRpZmYgLS1naXQgYS9uZGN0bC9saWJuZGN0bC5oIGIvbmRjdGwvbGlibmRjdGwuaAo+
IGluZGV4IGM1MmU4MmE2ZjgyNi4uOTFlZjBmNDJmNjU0IDEwMDY0NAo+IC0tLSBhL25kY3RsL2xp
Ym5kY3RsLmgKPiArKysgYi9uZGN0bC9saWJuZGN0bC5oCj4gQEAgLTEzMyw2ICsxMzMsNyBAQCBz
dHJ1Y3QgbmRjdGxfYnVzICpuZGN0bF9idXNfZ2V0X25leHQoc3RydWN0IG5kY3RsX2J1cyAqYnVz
KTsKPiDCoHN0cnVjdCBuZGN0bF9jdHggKm5kY3RsX2J1c19nZXRfY3R4KHN0cnVjdCBuZGN0bF9i
dXMgKmJ1cyk7Cj4gwqBpbnQgbmRjdGxfYnVzX2hhc19uZml0KHN0cnVjdCBuZGN0bF9idXMgKmJ1
cyk7Cj4gwqBpbnQgbmRjdGxfYnVzX2hhc19vZl9ub2RlKHN0cnVjdCBuZGN0bF9idXMgKmJ1cyk7
Cj4gK2ludCBuZGN0bF9idXNfaGFzX2N4bChzdHJ1Y3QgbmRjdGxfYnVzICpidXMpOwo+IMKgaW50
IG5kY3RsX2J1c19pc19wYXByX3NjbShzdHJ1Y3QgbmRjdGxfYnVzICpidXMpOwo+IMKgdW5zaWdu
ZWQgaW50IG5kY3RsX2J1c19nZXRfbWFqb3Ioc3RydWN0IG5kY3RsX2J1cyAqYnVzKTsKPiDCoHVu
c2lnbmVkIGludCBuZGN0bF9idXNfZ2V0X21pbm9yKHN0cnVjdCBuZGN0bF9idXMgKmJ1cyk7Cj4g
Cj4gCgo=
