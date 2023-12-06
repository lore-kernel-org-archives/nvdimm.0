Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFDC63B3
	for <nvdimm@lists.linux.dev>; Wed,  6 Dec 2023 03:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VhnCOU02"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701831625; x=1733367625;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nHjP/elhnHmbMduU+KDOcnQayEs2f0yk/IoJ7qkaFag=;
  b=VhnCOU02Ecz56MLOm0KwFdSAlZ+XsamVMOjQekO4OaOWwQ71KiSDGW1F
   sx2ZDOuWNbqyiuSZgVQjTsKWesnHBKNGfiU3WvGoJLtoVkfCIkfjZwjK1
   TaDfijndiE/Q1v9OqTG6dI7K0NQINc5aX990munO58b2c2u6Kxfsq0r9T
   j18K7H4Wkkda3akurLiWHaOepcfB+ofPh4Lw02Nj44j+C4u/QfHwQu7m3
   9+aoIsQPaloXrFKzOEsQScDeEzRrR9qE/yXB47O7Fc254rbYwwdX15mm6
   ZX5FHaRCrvfHi1Ck8dTGpQyxudVmV4S1CIHt3AXiYDN8YA68ZaEQ+yxte
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="458319363"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="458319363"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 19:00:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10915"; a="774843316"
X-IronPort-AV: E=Sophos;i="6.04,254,1695711600"; 
   d="scan'208";a="774843316"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Dec 2023 19:00:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 5 Dec 2023 19:00:24 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 5 Dec 2023 19:00:24 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 5 Dec 2023 19:00:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kCFyINE+AGQXCzqAoFzdt6wDOm7Twt0SGkhcILupfMfij0mLFeUuYtFOB6iYSxd00xYllOlFvKVLD4wJKkLI4Pmx8rljvz2xzZh7wIFBKHY4JL297tQifMs5b1qrK3Ubs62/uBKE5VA/h2Ln/2NesYBI1RowL9c5gE7wW6YFBZ1eh1vCFPJM7Db82ump+6X0Wim9nwgICK1B6WAGSrzgpUTWaIMWpK7ugiC3DGDuNgbmNXwrRLE2x2gH7AJebASKXhDw7wtJo1kAiVyTAbiDcsqp6zuw05eKwpYz5X3gmk1VR7i+SCOk4N+hf56wq2tUMi4sumrrO5G+JvzncVgHCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nHjP/elhnHmbMduU+KDOcnQayEs2f0yk/IoJ7qkaFag=;
 b=CqCPpg/MtN2wiya5MxTiunpuL0SxcEF8sfQBxIfDAsp73iqBir/rwAISaZVbgNhRWwXljS5sG3iTUi/jkqLwYOCl1fNOZ2iWdj8BeFcJbQmcF+NKolPIKdQZfgGLYa+ky1u5vvVuxkAtsoDnCLQ3ckJT9GhtAULI1dXUqnDt0C+8O7y8AmwHON9DMRMVs39N2paVb3fFOmRsfsxzNO79R9c0DK+B9cxYxVzQQCVEW9YrDFyGWjtJN++g+yiRdGb3gGC/eGrLAb9AUhxGJCwOAUhM+0YWGo4/yE4LoYYJbRv34UV6Rd10ARQH2MoAGtEO88IwMzVyuCkrmea4KNLs2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by PH7PR11MB5957.namprd11.prod.outlook.com (2603:10b6:510:1e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Wed, 6 Dec
 2023 03:00:22 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694%7]) with mapi id 15.20.7025.022; Wed, 6 Dec 2023
 03:00:22 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl RESEND 1/2] ndctl/test: Add destroy region test
Thread-Topic: [PATCH ndctl RESEND 1/2] ndctl/test: Add destroy region test
Thread-Index: AQHaJAu/YxXs4aYmgECKHsrWa5h+gbCU1CuAgASclwCAACv7gIABnXGAgABebAA=
Date: Wed, 6 Dec 2023 03:00:21 +0000
Message-ID: <081a326aaa95d2b5dc355381f1f4c4895767a9c0.camel@intel.com>
References: <20231130-fix-region-destroy-v1-0-7f916d2bd379@intel.com>
	 <20231130-fix-region-destroy-v1-1-7f916d2bd379@intel.com>
	 <ZWo2f2eWVtsJrYD9@aschofie-mobl2>
	 <656e14d8285f7_16287c29422@iweiny-mobl.notmuch>
	 <000bba54c1a3cde1aa63bc8052c01e745835468d.camel@intel.com>
	 <656f948febeb0_182977294ec@iweiny-mobl.notmuch>
In-Reply-To: <656f948febeb0_182977294ec@iweiny-mobl.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|PH7PR11MB5957:EE_
x-ms-office365-filtering-correlation-id: e1247150-69e7-4545-b283-08dbf6077c77
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bKjcZ0o4xl9vVtqj0irWffUB+z2KTKtEEGBKMHB/E+VklQlmUO4SYDBO3IWpd4ZsWgpJU9q/iibfD35TPFis2jziuEh+S7m4wj/k2oUnvId5KKKwQHf+wKVFXtYOIK9Ncj+2ueR/ZrtLeeNJefYFHdsCcrar0aN+MyOr+y46AXbOEyobzbXsfvB/hsp3NOFG52nnsEKZwM+0T6YLFWZEZCnYaEOTn9Ygwh3a/VmQ5fQaDTrI94r2P8iiCCBaooT9CjKAkHIeTdr2Yn3Odpo+x1q93Z8GuiTrthYDZi8p76E96r+CqY4RCjJ1dUN+bcTjrlnV6nvLJiGS5tSewRvFbc5RWcXsLx5e6XYlvImv6fNh69moUZmLqTOTL7Blyz9GJXdsyy1b2CKY6DrX6XaR6Mih4EhsYRuUxhdEqOZaZcYmGpHRZr1idVvMVFs5FJuiLZnP1mh7Yo2wHVKE6qQTdYcQLu1ne128EHN+2ICoG/Tw2izOFJ2qObL5YX4v2dYunoTKi1gcY5ufX2vT+Hm1UprtmUHI6e3caWbbluoeTAyVOlZDqiTEvCgQ9gFX/OjxECyHxYYPTC+qUaxy3KdMKxUTCyQL7Ufmq5xgCy89AhgdqucZ9hls6lxKLY+zT/9t
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(346002)(39860400002)(376002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(478600001)(71200400001)(6486002)(122000001)(38100700002)(82960400001)(26005)(6512007)(6506007)(2616005)(4744005)(8936002)(8676002)(4326008)(2906002)(5660300002)(86362001)(36756003)(41300700001)(38070700009)(54906003)(64756008)(66446008)(66556008)(76116006)(6636002)(66946007)(66476007)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UXJTMjRIbW16MG5OVFFXbXEzME1LaFhXWDhxS0NLSDlEK250cFFHSUV5SDhq?=
 =?utf-8?B?L0JXaFNLeW9wbjZrOHBqczRVTXo4WVI4S0VGWVdXSGtLL2tBTWc1UDhpYWhV?=
 =?utf-8?B?ZlVKRmZhOTUzSUlBb29mTWtEcGlxd1hHM1Z2akV6SHJGNmxYWm1CR2lBN2Zp?=
 =?utf-8?B?YVJlOVFkd29SOW84clcrMjNCODF2blBTVnlkcVpCRDVYajVqUTVkT2VzZmt3?=
 =?utf-8?B?QXNPaWplR0hkRk0wSU5CZ2U4SnBVd2RkM1FMRDFlMDlYTDJ6UFNZRnFrMnBn?=
 =?utf-8?B?eWxMeWxsT3BBT1FSTDkzWmkxT0E2WUh2NmF3WmphUVV4NVNJb2lJZGsvbHFP?=
 =?utf-8?B?QlVNL3FJMW1LWldCbTYvZlNKaG9nU0VKWXVIZDBrbkE5THRMMnBWYklZQ3Rw?=
 =?utf-8?B?ZXl3T1N3NldnV29jdWQvOWxCd3RyZ2tQdWFBcXZQZDJqSXVzeG1RTmNoRXRE?=
 =?utf-8?B?L1ErR0lQLzFGZy9nTzhoWXlmYVpDUTJYQWdPVU5uSHVSY0pxMlVydGgvSXk4?=
 =?utf-8?B?TVJwZmwvbEQ0ZExPZXJpdWJCNU1UMTJ1WnpQUW5raGVKQVRPT2hNclUvWXZu?=
 =?utf-8?B?R2ZqeHdTUElZMlc3b1IyeURpa3R4MlVuVzVFUTYyaHVpQmZyVmpUR3VCOHJ2?=
 =?utf-8?B?WXY0ejJMME5WcW4zQUhtdW5PRVBRODdyVGpRazJJaktPeVZXMjE5YnpleGY4?=
 =?utf-8?B?VUFJYTl2ZnhpYmVtbjNxY1ZHc2ZjSm43RXZ0ZlhaRVgyYTZvRnlhYnRGZzJD?=
 =?utf-8?B?RU95V1pUM05kOEl1NnpuWXU2Ymk4K0pjSDRZeHlXWk9GemhxdlN1cTV0Snds?=
 =?utf-8?B?NmpoblNzM0VQMFFWSGUzUlBoZ2w3TGxsNHBid1E3U1JFaDBCakVKYmxHZUZB?=
 =?utf-8?B?OElaWU9GS2ZBTzlRMmI2Q1RqcFpKT3R2WmZ5akc3NmdaRjNCeFh6Z1l4bEJO?=
 =?utf-8?B?eXdwWElDZE9XVktWZm1GWTJqaG5tYTZ4c2R4MHZMaE1PODVSTVQwb3ZybUF5?=
 =?utf-8?B?eHp1WmNubm1kS0FzQkJ4SkZza2xHa1BiUXo2cHJyRm1YSXNES29WZUFmZFVE?=
 =?utf-8?B?ZUxuYVlLR1hoa0hxeXZKYzNXNWdTSHZrQk5lQTd1Ly9pNk85OUhaTWdKenEy?=
 =?utf-8?B?R0UxVmV2T1dkckZnblVkN1NabXhxUzlaLzJYdFdwSGNPbWpCL2NJV2djWEV0?=
 =?utf-8?B?bHI2Sy9meFE1NkdHRFZUWVZpY1FjOWFZbHh2eDVRTUk4cWRsUC93K0JnNGRO?=
 =?utf-8?B?T1VDUXpwOXA0amZkeUg5RFRPWnFVamdpMzVNaHdUUlRuYkFQVHZjOElwWHdR?=
 =?utf-8?B?N0JuN1UzU2pPQ3FyTTk2Ty9Sa1Bpb0ZOeFJ6UmlNR09ETS9keXVHcWcvTGZH?=
 =?utf-8?B?dlIrNXJ6QVFBMG0rSUs2NVZEOEZsamNUR1FUUGN2WjR1NXVYL2RFTE1wODRC?=
 =?utf-8?B?bFU2a2w2bVF5bExTMElCamdJcEF4SlVodEJHZk1mbEYxWDVGRjFncHlSR2Ra?=
 =?utf-8?B?ajBvN0tucjcyRGVHYmNBNjVPU3ZHKzY0dTBlWmJKU0xZWUtnT0pWTFBaajhB?=
 =?utf-8?B?aWdiRlMzbmM0NnFabjBhakd0NUhlUlVwSEJzWjZldDVrRmZaaitDRWJRbjFq?=
 =?utf-8?B?ekhjc2V0V1BNM2dQVzI5SVVXKzVRLzdOaWZVa21xblhwYkpBTE5aTTFlTVRN?=
 =?utf-8?B?SEg2NFBjNUJxWDdDcTJCME1kZHdPVzVxS2JxRTFPVEJLWk5jUUdwMS93VlVP?=
 =?utf-8?B?NmdHWVVreHNpVE5zdkdPQXM4b2NOb0JIZUpaL1lvUlJaTFZ5K3ZZZ3RMWjFh?=
 =?utf-8?B?RXRycm56ZjRDT2NuS3U5N3g5dG95OEVQWkc5OHdlb2xCYjJVVFZzR1VSZm5h?=
 =?utf-8?B?VFR1QW1kblBKOXpIaThOc1luMWc4MXZaN1VVQ2h0WVVHbTlXamV2MXl5TEUv?=
 =?utf-8?B?ZTUvbGdEVlQxaHE0Y2svSCtxTUgySXl3aTQ5UXVCOXZJOGt1YmhxbUlSeGgr?=
 =?utf-8?B?WWhPVWdpMURDRWdzU3JDYWdOUkFVRktLM05kOWJzZzdSYlREakdHVjR3Y3dK?=
 =?utf-8?B?dk55UTlyMTNEQkxrR0dyV2ZIWFFBR2pIZE85SmtaT1R0R0pPemJXQ3ZNM1RQ?=
 =?utf-8?B?MUlCWTJBMkF0bGRIZVZzczVIL3Rsb01xenJkdkNDZU5kczlPeVcvdXVFUFpB?=
 =?utf-8?B?TlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E2457DF75BAFA49986CCD6C915291AB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1247150-69e7-4545-b283-08dbf6077c77
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2023 03:00:21.6221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EUcTo/dxix4tkt8+E793Jv5KI1ht4vjI/glt9Q0gvuc5i3vmDfjAw8t98EqP0Y7ISzCBgaCShaLzJU2ouSG/jI46Ybhf0fr5eVIL8XNgmZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5957
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTEyLTA1IGF0IDEzOjIyIC0wODAwLCBJcmEgV2Vpbnkgd3JvdGU6DQo+IFZl
cm1hLCBWaXNoYWwgTCB3cm90ZToNCj4gDQo+IFtzbmlwXQ0KPiANCj4gPiA+ID4gDQo+ID4gPiAN
Cj4gPiBDb3JyZWN0LCB0aGUgc2V0IC1lIHdpbGwgY2F1c2UgdGhlIHNjcmlwdCB0byBhYm9ydCB3
aXRoIGFuIGVycm9yIGV4aXQNCj4gPiBjb2RlIHdoZW5ldmVyIGEgY29tbWFuZCBmYWlscy4NCj4g
PiANCj4gPiBJIGRvIHdvbmRlciBpZiB3ZSBuZWVkIHRoaXMgbmV3IHRlc3QgLSB3aXRoIERhdmUn
cyBwYXRjaCBoZXJlWzFdLA0KPiANCj4gSSdtIG5vdCBzdXJlLg0KPiANCj4gPiBkZXN0cm95LXJl
Z2lvbiBhbmQgZGlzYWJsZS1yZWdpb24gYm90aCB1c2UgdGhlIHNhbWUgaGVscGVyIHRoYXQNCj4g
PiBwZXJmb3JtcyB0aGUgbGliZGF4Y3RsIGNoZWNrcy4NCj4gPiANCj4gPiBjeGwtY3JlYXRlLXJl
Z2lvbi5zaCBhbHJlYWR5IGhhcyBmbG93cyB0aGF0IGNyZWF0ZSBhIHJlZ2lvbiBhbmQgdGhlbg0K
PiA+IGRlc3Ryb3kgaXQuIFRob3NlIHNob3VsZCBub3cgY292ZXIgdGhpcyBjYXNlIGFzIHdlbGwg
eWVhaD8NCj4gDQo+IEkgdGhvdWdodCBpdCB3b3VsZCBoYXZlIGJ1dCBJIGRvbid0IHRoaW5rIGl0
IGNvdmVycyB0aGUgY2FzZSB3aGVyZSB0aGUgZGF4DQo+IGRldmljZSBpcyBub3Qgc3lzdGVtIHJh
bSAodGhlIGRlZmF1bHQgd2hlbiBjcmVhdGluZyBhIHJlZ2lvbikuDQoNCk9oLCB5b3UncmUgcmln
aHQsIHRoZSBkZXZkYXggY2FzZSBpc24ndCBjb3ZlcmVkIGJ5IHRoZSBvdGhlciB0ZXN0LiBJJ2xs
DQprZWVwIHRoaXMgdGhlbiwgdGhhbmtzIQ0KDQo=
