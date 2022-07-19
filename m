Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72BA7B
	for <nvdimm@lists.linux.dev>; Tue, 19 Jul 2022 07:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658216225; x=1689752225;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ae5o4l5tf65loN4UF1+oztDPnBrNb+K4D9SYQvNud80=;
  b=my9awyO7AMt9i5LbUbJBAT9WeMYpcUhE9jSApe7dgkYYP1XCeb4bl4dH
   /Isd6lTfOqYaaDqQrOGAUDjzHf66F4w7VTy6h7Ob2Y8vr04SOrE4ONxLy
   iYNMLFJzo7n0gd9rrz3lMH6FnRtmabOj6GmqKvshPhQLEmahHxZ3b9GWj
   tAnzGZJHvTT0oJtdihhAKIADrfpgIWP9dQsXhrVivIde/F0aN7s/yiTkm
   /khyuj8RGThKOFgssJi2PZ27eNGZOMlRF/xP32jAIJP5/z3xTshPZWXUs
   5RxppkIXaXpeWbYZg18n810h25cTdG24TssJVfzaFnz2o4zsnL6c69DCW
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10412"; a="285174789"
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="285174789"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 00:37:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,283,1650956400"; 
   d="scan'208";a="601497043"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 19 Jul 2022 00:37:01 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 19 Jul 2022 00:37:01 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 19 Jul 2022 00:37:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 19 Jul 2022 00:37:00 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 19 Jul 2022 00:37:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/XJGS6reSCbJsmRZyKhKA/SJlNH0kzvyTk49SyyeRbybCLXEpQGOA1ALmvJURnJS6XqmO8ZXd66EvUbU1s2FVUed/drVuFrd6H2JVkP1tz3rVnq7Uuy0C05GJ8RUU7tU1hbgWNJMpQ3Na8+ODZeQ3u3Zxq4Nfxw44MuOpcIsdpaOi7UenC+LqBLW35dfZv7Kr2MliWAclWGE/qIOekpPDYAUF9foSFtP3WraQH1H9+Y0qwTm8SigP8R22JDvozAzjGsvhp1MFwEVfTn+aapsv+lR4Qhc/sSpAhQ/mvTbIRv7Z3h6xl96AzPkSKSnalY+JR6tSdTEkhTp41EVRXXLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ae5o4l5tf65loN4UF1+oztDPnBrNb+K4D9SYQvNud80=;
 b=hdPilTmyOI12a7V+VOOaO64voLPCc30cubUiPJiTUmpVAzAbkZ564du/uiyzEhfjYnwW6lVxaozFSTf6ONPdwJB1uZcV7OWURwYAJCM3RUZ6jdLA/2dkS74t7Dd1pHuC/mc6TpJFwLT82IGa9HSrZB4PDzcjXyMi7Fn2RmCOS/uvcDOCvyWPeavqr5s2xvMR/O8MgZapp/I1HSO1bfT93Qr5TvQPJ53zxFLPQGRPQtNsVqv3m0wl+16uJmIRAa6QlNjBNzmjK87x8etxCUyW3itGZZ0XqD4ftrF6m2IqbtLBSrkQ/s6r52OYOfIhw7j7xYGHkMj+Gge7J/t4iV4JHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by DS7PR11MB6248.namprd11.prod.outlook.com (2603:10b6:8:97::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 07:36:59 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17%5]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 07:36:58 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "aneesh.kumar@linux.ibm.com"
	<aneesh.kumar@linux.ibm.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "vaibhav@linux.ibm.com" <vaibhav@linux.ibm.com>
Subject: Re: [PATCH] libcxl: Fix memory leakage in cxl_port_init()
Thread-Topic: [PATCH] libcxl: Fix memory leakage in cxl_port_init()
Thread-Index: AQHYmn+2jsd/udrg+k+cXUTv2td2za2FT6aA
Date: Tue, 19 Jul 2022 07:36:58 +0000
Message-ID: <e53d71edb94c38b67b53f12b7e6f1b7068c2b3ea.camel@intel.com>
References: <165813258358.95191.6678871197554236554.stgit@LAPTOP-TBQTPII8>
In-Reply-To: <165813258358.95191.6678871197554236554.stgit@LAPTOP-TBQTPII8>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b8083a2-5517-48d2-f02c-08da6959766a
x-ms-traffictypediagnostic: DS7PR11MB6248:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fya/zBVXL5qyYDtxu6FEOBDyZTLKqmDB5T6xvY51lzRymp52pw0YPux5DLZXxmhz+QoTGw8H4y5/V8piYFeHMN8sR/LN65TLBITxWm0YTYv8+iowJcbhwxI5W5I2KsvlvN5CNMXXEuqsBmGhMOdR6n2RKHsr2SRaL5znXLnOlM2ZcVuufUM6GNrJ/IuOxyDZifngzq+c4Z7rPtE3kvhP6ZpCON1neAA2NyuvshHuHboUYbAzJiGDB5FFMYeXJG5FffIGV+dJEMl2ctAadtWP62gfUB2a4zlYoqF3Y9LzNxO3wnGCFC3f8/7nataHVj+pA7zyF1VVsRjtAkt6fROgn3O8fklEFF8wIsovGcC/H00vz8iWvbEUEqOBZp+ArkSWJmwl6AA4168LPv9W4+v9ej6+ScX4TCiiroBhQ93U3C10h7EYLjkyWphmNu1Ie+UFvfzX4rzrz1nENcw515cI+H6yxyfVeUN0p7wvdlyy0oJY+d0+V1DS92n/kyOe8dekmLdWlANuzzTiEXLey5i8VtbadjhncluY5y2c+HodjLGDfBa2+M/3D33neXPhTsmLtBoK05gGZEz4ui2U3YulY5+oCzqWm2dbzICVKXqnlCDGqfvIJcllBAJJJD9nB0qDO/Y+QlauiGJTcCpwipFXZVGmV3wKLwaQ+kgcHZNNbJaKjHWM+l2N60cHrx4/J7NtscoRB6veBvKJViWxf7ywJfMsfNrvVzyLb+cJb4AOApUBdV1764cvZDeUqYM5pOF60lNpMe/JaWWsFaugHYoDMRSSbitjAR+OFPyvg7GV8l3dgq8AJ5uxSwecLs6T4tJb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(396003)(136003)(366004)(346002)(316002)(91956017)(38100700002)(8936002)(86362001)(4744005)(64756008)(66946007)(66556008)(66476007)(5660300002)(6506007)(4326008)(82960400001)(66446008)(8676002)(38070700005)(2906002)(122000001)(76116006)(2616005)(186003)(110136005)(6512007)(26005)(54906003)(478600001)(41300700001)(71200400001)(6486002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFJqeWhHYmtSU0lTaHBIUTQ3NzR5V2RHakc2RGE2TlVvQU5Sd0JVVFdPNU5V?=
 =?utf-8?B?TUgwbHVMZ2lHeG45dG1lUlFhSmhvZDlQS3Z1L2FiSStxaE90cGVxb3VPZ1ZL?=
 =?utf-8?B?WTk5c2pCeUw2MUE3eUN3RmRqcVNidjh4eDVwb3ZXcktjSFowN3kzSzJYT21x?=
 =?utf-8?B?bkR2RmNPeFNVeFJJd3laN2I0VG4zUm9DQ1dlNk45Zk53VnQ0Z1IyR1RxdWdu?=
 =?utf-8?B?QnRmeFZJaGx6eUJtQmpCK0M3V2FvZHhaU3pTOFpXOVYzMUM3NVQxbit0d0Y2?=
 =?utf-8?B?end6SVdCMTVGUWNLZUNZSVVjckdib1JhTGJ0Z2pxTGNSd0V0VzNuL3ZHTmJu?=
 =?utf-8?B?eVJwaHY0bmE4VXA3aXpwVkxJbURvVkx6Mkt5RHJrancyUDNKNlVScXFnQkVo?=
 =?utf-8?B?ZDRnYjltV3BTSjF2amppeUFOd1hNR21KdUxocFZoSTNMdEVJVGNlTThub0ZJ?=
 =?utf-8?B?OXZEQ0dGSWRyclBkVHFrdS8yUDV5MXRJeUJac1RKMGJldzdGZDNuWlJVaXlX?=
 =?utf-8?B?Y0FWdnV1eTNSQzQwTDE2SlpucUliR01tUWcyVml1Yk5IUzQ5Ni9oUTR3R2dp?=
 =?utf-8?B?cDRCT1pMakdiWDZLWkJDU0UxYnU3bjkvSXRPc1did0ZJS21VK1NWV1F3Tkxa?=
 =?utf-8?B?Z25kUmVZenE3NThRZS9JeU9vVTF0Yk9xSEtYcWJXSDRNY25BM2tGanNvR0c1?=
 =?utf-8?B?WkI1MjBCbmluZUcxMEorZWVOdzluZHhpZks2bU9jSVoxWmNYRWtPL2JKZHRK?=
 =?utf-8?B?Ulp6M1ExSWdGVnJaU0lDUzBtV0htUWtzWkJhb1YrVGNydU9VMjFIenVWOGpx?=
 =?utf-8?B?K2Z0L0hQeVE5QUp3VFYrSDBURHl4elRkTEpQV1ZuMzFVby9MZjhlN0wvMUxj?=
 =?utf-8?B?N20xQWZyMzQvV2ozNHJGZE9Ld3FrVktBTkRkbVkvbDZRUG0zRjhtdHo3L3JW?=
 =?utf-8?B?Sis5a2hZVlc4Y3JXZDFBZ2R4alBDTG50UmswV2pBUXJzeXh4N0FEMTIrbkxS?=
 =?utf-8?B?N0c2bHU1UDRIVXJCMVVsQjF4MGVJdXRpYmJMd3hnemV2RWp3M1czcDRveE5Z?=
 =?utf-8?B?ckF2eFgrYUxGRDdEOUI5MlBJY3NtcG45V2dCM2J3UlVaS0xvU0NjSzFWRk1Y?=
 =?utf-8?B?WS9QYmRSMkRFaTR3WU5tMExTc0NncGRubGhLSVNNaEhCZmtmZmZUVXFsbW9x?=
 =?utf-8?B?VHFNa1FtcTJUbVkxNmZsZVU5ZmdtT1pSaFVZeHhoZUtkY1pubVI4OU82OGVX?=
 =?utf-8?B?ZVVHZE9lNy9FcS9ES2JIa0c5SERmUFVTL09YL0JoZXBFSmpXMG5qdWxOcko1?=
 =?utf-8?B?WkNYazUzanBCZ0xYTUZDSElBUy9CcnVzWHVFajRicDRCNVZQaUJHaGcxdldN?=
 =?utf-8?B?RzFQMG1vek83THdLZ29hSGdCWGJkVXpZK0pHeHhqYk5HVkJwYXNoU294d0Fu?=
 =?utf-8?B?WmEvQnlld2Y2Z3BoT3M1OXVvUUtwV2NOcUVDU2RPcjh2K3RTRnRWMnFocmYy?=
 =?utf-8?B?TmxvT1dKNk1NTmFqdHZzK1FjTWpITWozT292WWJWcHpVVmE4YTRmTGhoQ1dh?=
 =?utf-8?B?UmdoUEM0SklOT3JSRmc3d3BiUWFDL2I4QlY2WUg3N2dNa0xEWUZaOU54S2wr?=
 =?utf-8?B?VkxNOTNuUUI5V3N4SnlKeElud0MvZHNSQ2NHQjZKai8vSFprdENNNVp2d3JF?=
 =?utf-8?B?QURDaU8zR0grL2RuL1M2NlVYandyRndMSHVoVHVxRi9RMGY1OU9Neml4Y0xT?=
 =?utf-8?B?SThxQS8wWVVoa3BNSDJoUWV2L1Z1b2VmMG9nUTJoL1pUTGxuRXZteU9FYjFN?=
 =?utf-8?B?bjVLYWVrT1lNWkgxcW9oUndKZzJxS2V2ZW9mRGtBcnlDRjB3cytyaVBlZytj?=
 =?utf-8?B?WCt6K2NONkQxb0Q1aHNySUU5V29TdGs5ZElxS2dDV2owb3dZVzkxeUdENTJI?=
 =?utf-8?B?MW9mNUkrQ25pSm9HQ09zeHp5b1pvWm1oN0xwNHRsMEJTVThLcytWTGYvWE9O?=
 =?utf-8?B?clRtYVYwOFI0dUE4eCs2dm93aGxSUHYrdTFxeHNxQk1BTXB6cm9YRDZEQ3BD?=
 =?utf-8?B?ZnpGOTl5cjBrT1I1cHhLekhlUGZReVlqQ0V0a0pGQ3BZTEhkUkNXMkhnYng2?=
 =?utf-8?B?L2Q2ZnFqV2dEUFEzYk9HZHpISk81NEEyVXhUdldyK05SOG4vcnFob3dTaGFU?=
 =?utf-8?B?cWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <57A09F74D59E784DB0BA6AF7B2BFE5C3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b8083a2-5517-48d2-f02c-08da6959766a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 07:36:58.5759
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bFoyF2lPP4EBdFstyppc8XLH29VlbvTWc9bjB1Zefef3yjdlQqlXH51lPA6JNeRM9CpMo6ibcQVdrLDUJLiPZPJFY+gC/RsSnKeoerJ5UIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6248
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIyLTA3LTE4IGF0IDEzOjUzICswNTMwLCBTaGl2YXByYXNhZCBHIEJoYXQgd3Jv
dGU6DQo+IFRoZSBsb2NhbCB2YXJpYWJsZSAncGF0aCcgaXMgbm90IGZyZWVkIGluIGN4bF9wb3J0
X2luaXQoKSBmb3Igc3VjY2Vzcw0KPiBjYXNlLg0KPiBUaGUgcGF0Y2ggZml4ZXMgdGhhdC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IFNoaXZhcHJhc2FkIEcgQmhhdCA8c2JoYXRAbGludXguaWJtLmNv
bT4NCj4gLS0tDQo+IMKgY3hsL2xpYi9saWJjeGwuYyB8wqDCoMKgIDEgKw0KPiDCoDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2N4bC9saWIvbGliY3hs
LmMgYi9jeGwvbGliL2xpYmN4bC5jDQo+IGluZGV4IGJlNmJjMmMuLmU1Mjg5NmYgMTAwNjQ0DQo+
IC0tLSBhL2N4bC9saWIvbGliY3hsLmMNCj4gKysrIGIvY3hsL2xpYi9saWJjeGwuYw0KPiBAQCAt
NzcwLDYgKzc3MCw3IEBAIHN0YXRpYyBpbnQgY3hsX3BvcnRfaW5pdChzdHJ1Y3QgY3hsX3BvcnQg
KnBvcnQsDQo+IHN0cnVjdCBjeGxfcG9ydCAqcGFyZW50X3BvcnQsDQo+IMKgwqDCoMKgwqDCoMKg
wqBpZiAoc3lzZnNfcmVhZF9hdHRyKGN0eCwgcGF0aCwgYnVmKSA9PSAwKQ0KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBvcnQtPm1vZHVsZSA9IHV0aWxfbW9kYWxpYXNfdG9fbW9k
dWxlKGN0eCwgYnVmKTsNCj4gwqANCj4gK8KgwqDCoMKgwqDCoMKgZnJlZShwYXRoKTsNCj4gwqDC
oMKgwqDCoMKgwqDCoHJldHVybiAwOw0KPiDCoGVycjoNCj4gwqDCoMKgwqDCoMKgwqDCoGZyZWUo
cG9ydC0+ZGV2X3BhdGgpOw0KPiANCj4gDQoNClRoYW5rcywgYXBwbGllZC4NCkp1c3QgYSBxdWlj
ayBub3RlIHRvIENDIGxpbnV4LWN4bEB2Z2VyLmtlcm5lbC5vcmcgZm9yIENYTCByZWxhdGVkDQpw
YXRjaGVzLCBhbmQgdXNlICJuZGN0bCBQQVRDSCIgYXMgdGhlIHN1YmplY3QgcHJlZml4Lg0K
