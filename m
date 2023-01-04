Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0243BA3D
	for <nvdimm@lists.linux.dev>; Wed,  4 Jan 2023 20:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672863364; x=1704399364;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nVg+88Hie9T3xmlLWf6GIrEzenJUW+yX1EqYlnnhKgo=;
  b=lPmYG9cDd6px1mD55IEN6KBaxUNrzyjz8AB6iOJ6vtG208WIyRDCkuFb
   OSWd8UNDWLyznP1qFyoQf9MWni2PxN9DhP242glVKR5bxmtyw5EZ6D72B
   2UmkIyKRCH8G1yxE0EFznjS9xUkjEuAWpwFwzEHCa7Fcii/m/K8AmGaTm
   pKMceLgQRgWSTJpP1TZXxomeKKBvw7UUJqN7V8zeXcSNmF+HdCGBOyp9H
   PJfOlwz1vKXRm9p6faCNgo3930WHC8RmbibisqvPdmCpRq3Qo00XeUImQ
   5Fm0JB8uPAP7kfkP6V2/87+buclOA0ajy1qcJbuEG1mmr91yxY2w2lRKs
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="302402054"
X-IronPort-AV: E=Sophos;i="5.96,300,1665471600"; 
   d="scan'208";a="302402054"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 12:15:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10580"; a="829269366"
X-IronPort-AV: E=Sophos;i="5.96,300,1665471600"; 
   d="scan'208";a="829269366"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 04 Jan 2023 12:15:56 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 4 Jan 2023 12:15:56 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 4 Jan 2023 12:15:56 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 4 Jan 2023 12:15:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7XlYkSaBGZrWVbD8+yAkO/LmzXSaCOArgoavF7yaX77gjW4/X5HBiu96ZFimiJuB64HwASsQWRzi5aSSWZ8GwDaS0Op/G11J22+beGeTiabQFrwTgrBLjrB6gd5al3J5jI5Pj9+J+JT+THVo1vfo0t9UDK+nqLs//lMCNZoVc5d1psee+XcWd9NdmzvJAuJWmG/Cdj+lmQEqvIOByh+KpAiSkB3lB961kqqv4GcbU89PiXR0nlZDlr8K2MwoljhwsOdFStL0YXYwQ8GTT+NjrrBKJTWMn6ssU+S+ZijMna6PkH/WLQC8MfGV6YE2mg+9mQI/CXhNsG3lXrH6ceAqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVg+88Hie9T3xmlLWf6GIrEzenJUW+yX1EqYlnnhKgo=;
 b=ECU7ZPAkbZfmwSj/WAusNR45QDAwE3/740Sj/KAI8G5VzELauu3xGoAVntjxQ2Gs2YNCZm8Pb3fCLBW0BOwsQSnK4LCvchCGH3RcGcdpPFWoxOttc+mZRRl1OL8wtCQF6N/Y0pp6hPEeI5VaJzjIe+U/vlybmX018Yrho9Rsu7BhZCeBfQjc9GH5TAEyl6dVMGWmK/c0votKdZI/FAWKPtE3jpHFLdyccOEwh5MYSGI3c3ZXmaI/G+iF4HbYYrtMp8UrX3LyCpUwOMdXDb3Q3UmBEgMVBfi3jb0J7wpSoP8jYYe/tP4Kpq+bo3Wy9tKRjcoU6DZRxh5liO9p2eEaxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by PH7PR11MB6908.namprd11.prod.outlook.com (2603:10b6:510:204::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 20:15:54 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1ad0:a5dd:2fec:399c]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1ad0:a5dd:2fec:399c%5]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 20:15:53 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
CC: "Schofield, Alison" <alison.schofield@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 07/18] cxl/list: Add parent_dport attribute to
 port listings
Thread-Topic: [ndctl PATCH v2 07/18] cxl/list: Add parent_dport attribute to
 port listings
Thread-Index: AQHZC0wRnDFLgCMYVU+dv6P3LKNsd65xWYOAgB2Ck4A=
Date: Wed, 4 Jan 2023 20:15:53 +0000
Message-ID: <b509af356cd2f18e3bf847d10e772a0ec701423a.camel@intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
	 <167053491908.582963.7783814693644991382.stgit@dwillia2-xfh.jf.intel.com>
	 <639d1d3bc99a_b41e32948@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <639d1d3bc99a_b41e32948@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.2 (3.46.2-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|PH7PR11MB6908:EE_
x-ms-office365-filtering-correlation-id: 49900366-8822-484d-b865-08daee907b30
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9vO5XsMleMwQ1qgW5Zf9hJp9sWdotnnphYnLYZ3fnK1MWKSDKij3Bk+efA0CYfckZWapDqdoBiDC42lhzLvxY/yJ8xlrSy5uGUa6DtVU8rcYAkCn1thENS5IuzZntaq4V5pO20l8TlGV9wb8eyvwFJeI8YeLKMBKRrkavUaewr4N0+YjTe1Nl7NPthKg3oe3EEUJwLh1ujg7CZeE5CQHVjV9Zq89Vqtcv4wBcxaCILZ/+njkA/N/VipYp9k2y9KHa0EWmVpdBYF1BY/1OEGGlZpjkDTOWwBoNGrQErEdvkhCDw3546LC4CZ8zrxRSux+POXCoMDyHO3Wyg4tBhvjgvAPJju759bPQeDhGL/8YwWchZbM95ibXyAKpqoZTKr+G/X1hvDHj0DHzEIhsVi6YDgUXBVDeBnjRY3ARMwiISPnRXfgJQUwiRaeq8S37fTzzpFo2YXFV32V3vxfUlWe1ac61u0RSQWEVKeRqC42e/g8Gto48/ZogHsf9BPOlQx0Y67bJ6j/howBEA9DsV4/6vJrXqMuGMIWgDLotGRcBG2CA6NP6rc80ahdgqtZrsVfkN3Kmh49iNYkMA6qzW7gRFbuKFI7m/T3qE7yRREVx4TWm7b7kZHSOzQgSwJQ4FDLGIkeAvnZjdx36BCO4XvqiKB08IJY21Mf4LUArs+3fpO5+I88w8m8v/vTfnANWrfYKfD8hUkHClyBTrRaNkJX8uxSzRngqNBirbViCXHc8mU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(39860400002)(376002)(366004)(451199015)(122000001)(82960400001)(38100700002)(41300700001)(4326008)(86362001)(8676002)(66476007)(66556008)(76116006)(66946007)(64756008)(66446008)(91956017)(110136005)(38070700005)(54906003)(316002)(4744005)(8936002)(2906002)(4001150100001)(2616005)(6512007)(5660300002)(478600001)(6486002)(71200400001)(6506007)(26005)(966005)(186003)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkxvYk1XU0xURm5hNmtPL1E4Y0JSSmM5MEpzZWx6SEhhNUpUTEs2d3lwVHFw?=
 =?utf-8?B?bDRRYXYyL1lLY21HUUtTbmZZak1OOUZuK2dtK2Rxa3BGZnF2YlN4SXVDQ3Jw?=
 =?utf-8?B?VTBOcmFJUThUMWZFR3lHR0VCb3FRVENzMHpCVFFsbjdMTlBCZ1JWVEpyTzJj?=
 =?utf-8?B?WkFxUzlURjBvQW5abVVwN3ZxWlplVjNpbmNCVklnM2l5cXBQUDYrTGNGVWw5?=
 =?utf-8?B?STFoODlmc1hQS3JoRytmRUdPVWYwUnhVcTdqMjlTK2NPVXQ3dmJrYXVQNFNX?=
 =?utf-8?B?eDFtS0dkamdBVnkyS2JUNnNuSGd2Zlh6TVc4UGE5RG5BL2I0c2VoUC9KdkpY?=
 =?utf-8?B?cDIyeWlvRUtCcnpVczRGMjA3SUFWbFpXMFAwUnd0OFhoMDhOckltQTcyUDkv?=
 =?utf-8?B?TEFpM3NuNjBTV1pIcUVtRU5Xd3orN0tZUUpVcG0wZjc2SXY0REtSSklhNGxG?=
 =?utf-8?B?WnRDbEZUVjcvMzdRM0svR2tiTUVuZ1ZrbDI5UkFjeWtnZUVtRFJ6cStLella?=
 =?utf-8?B?VkI1eC90VS83RFZpYnB4dXRack9WQUp2VnRHQllHamNFVDFsRURtSlVOa0VZ?=
 =?utf-8?B?Q3RyV0JScVBHUDV6amxPK0xvY0hTSFcrem1HK2FLdWY4bVZueDZEMWg0NWFN?=
 =?utf-8?B?bEs5ZkR4azdTNEo0RXduMm1HbmR6d1V2Q3lPUXNsQnlZWCtMeS9WWjZwWlNM?=
 =?utf-8?B?bzg4WWFoODZJM3BmV2YyelM5ckJmeXByQk9wWGNNMXdNMlIyUEVoaWNFTmt6?=
 =?utf-8?B?cVNTOTN6TkV1QS9HV25yemVCT2RtU1V1RytGVGJiMzJqN044Zno5bzdqek1n?=
 =?utf-8?B?T3crM0swOXBQd0x3NjFlenFpTTUrY0Q1UVBLVXYvTDZ1a2VyOHpjOThwdE1U?=
 =?utf-8?B?Y0VtK2FXa1g3UWl4THhFd0Ezc2Z4YVFyZTdSc2dVZXR2ODI0NE9QamUrbWxR?=
 =?utf-8?B?RXBhUHBZb1c2RU1qUEJQYjE0Y01CUlEzNllwMXQwWW53SEVLcENsS1llME84?=
 =?utf-8?B?ZTNuZHVKYUQ5K3NRaFk2eFd3SEV1TFdQOUlJMlFYZEkyNWg0cHFUczBBd3kr?=
 =?utf-8?B?VC9jNmdkb1RzOVZSRTk4OW9INXovZkgwbVNRQ2pYTXYzOGhqaFRJdFI5ZTE4?=
 =?utf-8?B?NWFKUkVHZUVjWGJUOWFmckJjSmx0WnpKRG1FYWgvb1l4Ukp0UFZEYXVaSHdh?=
 =?utf-8?B?TFJQenhNSXJYeEFLaE5HWi9ZbnpSdjN5ZWxsMmV6WUh0Wkh6c1VHcU1NSm5D?=
 =?utf-8?B?bmdpemRXbFpibVdZLzVqazRCYXNweGZ4eVRKUVEyNjY5bUpNQXVNOThPY3Ba?=
 =?utf-8?B?U3lHbWN4TWJMMFk5Sk1RRW9ZMnRhL2IrL1A0bG1YeVovK0tacTYvSTMwVDY2?=
 =?utf-8?B?WDBOU3RVZWNPN1paRmpTTFo2a3grMHVTdk1XK0NCc2RLZmh4RTFtUS83SStk?=
 =?utf-8?B?aEpoU2p4Vjh3c0hiNXZTYjNGRXVwQXZ4QlJ6aGlWMmp2M2U4aWtXd0MxcWFK?=
 =?utf-8?B?RHUxMXdMS3lUOWF1SlRpR3V4bm50QWlVWnpYYmhvc2dsL2FxMGxBUzdIMDNu?=
 =?utf-8?B?SEwrbG1NZjF3eEdnZWdCN1JqanFJWG1VL2lhOWc0WVVsdGs5MG5TdWNOd04w?=
 =?utf-8?B?d0l2UThueTBhMVdrVThITmdUUGN5aGZnbnN1Sis4a1BrZW91R3BiaUN3QzVM?=
 =?utf-8?B?WnFDU3ZTZmpMS2xoS0pMYjhXdSt3YWVPMGhUcklrYktwUDBEY1dqOVZ3QStj?=
 =?utf-8?B?ZE9XT0pSQm9ueTJPc0YwSDVhSXJYSmxNUlhlY3hQbFdqRUFVNVlBcXpxOXVS?=
 =?utf-8?B?ci90NzdQUU1hMlphU0hZQi96S212bkZnOEgvNWIzeGVoU2thZmNwcFlsdnBP?=
 =?utf-8?B?OWcwU3BXNkJhaThIcFl2Wm1nZXBoRWplQ0RNYUoxR1Y2NXVpU0xZYS9HRW9T?=
 =?utf-8?B?WllWMHllWGhCSGZPY0M2VENRRlpQMGxZaGY5OHF4YldrYTMyYmtQTVNPc3I1?=
 =?utf-8?B?VU45Umh1Sm1HbjMvNWJlRm8zakgzUmFZNWx5TjdZclJpWEFQdnEyQWlTc2E2?=
 =?utf-8?B?bTdUY2N4dE5tcEdqNU5XU3FDL21YOFdiTEp6a0xpSnFvTlRHcVMxL2ErVnda?=
 =?utf-8?B?aWZBSWdKOVhySTJmM1pncXZ1RUlvVnduNllDM1lYU3FyWVloZEd0czIybUZn?=
 =?utf-8?B?N0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D405C055B0B1946A2810A2EADBB6FF1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49900366-8822-484d-b865-08daee907b30
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2023 20:15:53.5369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u8wjALGxyG48UIOnUYqpUv5suh2AyklYQ5qpBHIChfcVq8j0CL/clNvehBUYnWepT47sC30yzkfVMg7vStOCqoLF4Zji4mmejBlCl8xQPC0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6908
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIyLTEyLTE2IGF0IDE3OjM2IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IERhbiBXaWxsaWFtcyB3cm90ZToNCj4gPiANCj4gPiAtLS0NCj4gPiDCoGN4bC9qc29uLmPCoMKg
wqDCoMKgwqDCoMKgIHzCoMKgwqAgOCArKysrKysrKw0KPiA+IMKgY3hsL2xpYi9saWJjeGwuY8Kg
wqAgfMKgwqAgMzggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiDC
oGN4bC9saWIvbGliY3hsLnN5bSB8wqDCoMKgIDEgKw0KPiA+IMKgY3hsL2xpYi9wcml2YXRlLmjC
oCB8wqDCoMKgIDIgKysNCj4gPiDCoGN4bC9saWJjeGwuaMKgwqDCoMKgwqDCoCB8wqDCoMKgIDEg
Kw0KPiA+IMKgNSBmaWxlcyBjaGFuZ2VkLCA1MCBpbnNlcnRpb25zKCspDQo+IA0KPiBJIHNob3Vs
ZCBub3QgaGF2ZSBzZW50IHRoaXMgb3V0LiBJdCB3YXMgc2l0dGluZyBpbiBteSBkZXZlbG9wbWVu
dA0KPiB0cmVlDQo+IGZvciBvdGhlciB3b3JrLCBidXQgc2hvdWxkIGhhdmUgYmVlbiBoZWxkIGJh
Y2sgdW50aWwgdGhlIGtlcm5lbA0KPiBzdXBwb3J0DQo+IGxhbmRlZC4NCj4gDQo+IERyb3AgdGhp
cyBmb3Igbm93IGFzIHRoZSBrZXJuZWwgc3VwcG9ydCB3aWxsIG5vdCBhcnJpdmUgdW50aWwgdjYu
MzoNCj4gDQo+IGh0dHA6Ly9sb3JlLmtlcm5lbC5vcmcvci8xNjcxMjQwODIzNzUuMTYyNjEwMy42
MDQ3MDAwMDAwMTIxMjk4NTYwLnN0Z2l0QGR3aWxsaWEyLXhmaC5qZi5pbnRlbC5jb20NCg0KQWgg
aXQgaGFzIG1hZGUgaXQgb3V0IHRvIHBlbmRpbmcgYWxyZWFkeS4uIHNoYWxsIEkganVzdCByZXZl
cnQgaXQ/DQo=
