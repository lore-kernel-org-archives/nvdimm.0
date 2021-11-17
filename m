Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC122C80
	for <nvdimm@lists.linux.dev>; Wed, 17 Nov 2021 23:02:05 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="294885835"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="294885835"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 15:02:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="455072977"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 17 Nov 2021 15:02:04 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 17 Nov 2021 15:02:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 17 Nov 2021 15:02:04 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 17 Nov 2021 15:02:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgO3PsqdGrRlzqEs9xMhyMc2d+0X15CNfHdHWUsvQE+noo90axQvirK77I6oTZqY9CfKqosaspZajZRAEt3DTHKA3sIh6t2b2KQsYhBHXpHiNjm7qDuUGLEXYMvJXEPiE9ybNgjoCWRbE+0mK8fYG4W4a78tqXlsJkQnWf/hTIpIQd+6LsxLZrHQySoR/wKHQ+iJxjPbmXSEPMg8eAOVIXzbH/be0C+z9jG5UGWeNPRW0WtWSBNJIi1sgXWc8ppKvPzdV5dPOukRvfDNPI2j4Xcuq96pMJqZ6sRZWGmXzVWfLYrnECVajb83hTOtYSuhXMWZslqG7LcXO+9oQb0KnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AShzNPtolbKMjp1ByVCLDEQmeKEdiAll3qP6IpXd470=;
 b=N5qaHvfXeZ/Zn3Rmt4FTfBob3VS432FWDGTJvvuHHGCUVywqGbrCuUoPis0n3l6ORuoG5+lQLd6celvRY0puLYbmlorccXqSUHtsEa1iv45cU/M+j/ObShFpxbh/kvsxtpehD6HjIfiUb2TJyPbdz3PWRlS8+RgmYkjkHKykL2Ji9YC66HsBXMBBr96JJeFmMPSqm21gxs6MTFoUpqZbe5WdX1DJoLHvoOtn6+PgN7a0wTCz5ZxXgb2NT6wpdoXgGGAEUcSRlDwyeP7XG9t2E0CrtNB6vB2uxessf2iRe2Ss1K3v0gqhmKhUsHAIimU5jwn19omvAxn3FXyq/GqCPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AShzNPtolbKMjp1ByVCLDEQmeKEdiAll3qP6IpXd470=;
 b=dSJZh/brAjZSpEmpMwWfPDua4HmlkXFjggio12BjOZDD5u5ADCVA67fkL20o1dP/7adJE4X38vBZzDG1nAjaU8Qk5JylF/g9foiwQZujntM6uM1rnRARJvWTENJCf20/p6qk7cb2xlWoIuI8jMW9aDbwxm8FVB401hKQNRx+gns=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BL3PR11MB5746.namprd11.prod.outlook.com (2603:10b6:208:353::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16; Wed, 17 Nov
 2021 23:02:02 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4690.027; Wed, 17 Nov 2021
 23:02:02 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Hu, Fenghua"
	<fenghua.hu@intel.com>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Subject: Re: [ndctl PATCH 2/7] daxctl: Documentation updates for persistent
 reconfiguration
Thread-Topic: [ndctl PATCH 2/7] daxctl: Documentation updates for persistent
 reconfiguration
Thread-Index: AQHXnkdRMhlv8wbbQUm643qGXKM0O6unXQcAgGF0rIA=
Date: Wed, 17 Nov 2021 23:02:02 +0000
Message-ID: <540697470a8d50b2a60862dc4c0dd79031ddb4c8.camel@intel.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
	 <20210831090459.2306727-3-vishal.l.verma@intel.com>
	 <CAPcyv4iACg+5v=T5sqarNEfR0qChMOG0y64gzY22mtaNZVJYWg@mail.gmail.com>
In-Reply-To: <CAPcyv4iACg+5v=T5sqarNEfR0qChMOG0y64gzY22mtaNZVJYWg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f1d441e-c541-418c-9e47-08d9aa1e44a5
x-ms-traffictypediagnostic: BL3PR11MB5746:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <BL3PR11MB574619645954037162E8A9D5C79A9@BL3PR11MB5746.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HyRsxVcULr6srrI2vsoZVkogfA0c26L029eXWx8v0YBlD3ETU+fguWFvwl/ZWR0YxjoKNoxb6QbeIMPIaQMWCVbVDKQUVL45GRL3GNyoObaEyRKqXibvV2qZ42tgWb8OhxgHn5ZXFgln491mbQUP7medkdy6DiroWNIgpF1w6J55BaC0VwEJD2fMfngu9MPZaI8Ue0I9WAk+HmWWFgngGjJoSJbYu0+OSfx90OB2boAtKQWTvzOKPfxU2UzgjfGvW4UL9FlN4caiaEZ7aVAjk2Em7I/slFs5zFpdeoYOShCSJUVeaJZHCsOlVqvbX2iVEaSC8dVOXLhDO2DWrdQJqABBRlW0Ubk2YY9NRsU5tk3lk+3MuMN9HUft5zDhVN1m3A9PMTBbpJhqZuH+t9XK2yOYoZSKr7C1FyHmh2ycupo9tACZSudnhlbtWXDOokArARgK3IQ7qKj4xNlsvX3j4+zDw3sdHOu37xFU2cVy1xfnUDP7BifOelqNFxi+L86OES6QVAwskr2J09tbPgQD3VhX0cdZ+JLwNR6VbKZV7MoD/NFG7usxqsW4ILDSxBB8biCDdPVmhK8cvpAZ5481lDEQvKXciw/kpN6yuTwQZdInyd+ydDK6xyjOmWceKQRQ9vVF7ekwjstFaBQRDpVSiORuLuPrV8KI94tXzQBSfJApj8+lVYmsYipxWuZMHGNj6zIokE5eBrSkyXl9N79yAIDIOff4LmO5fl034oyuaLM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(15650500001)(66476007)(37006003)(2616005)(83380400001)(76116006)(122000001)(53546011)(66556008)(4326008)(316002)(38100700002)(5660300002)(64756008)(26005)(186003)(508600001)(2906002)(6506007)(8936002)(66446008)(66946007)(6486002)(36756003)(8676002)(38070700005)(86362001)(6862004)(6512007)(82960400001)(6636002)(91956017)(71200400001)(87944003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3VyK1NoY09hLyt5SlAzYTVYeWdVWVgwUEFlejVhQXUvMFpvczNjYmw4dzNt?=
 =?utf-8?B?aE5kV1hnQjJIWlVjVW9iQlczUkpPMHhCZ1dnSnhDK0NGKzFSQldwMG1DRzZE?=
 =?utf-8?B?aXhmK2pXZGJKUzFDbTZWNTVKMXYvMHpQQ2MvVHNvWWRoRk5SMU13ZDVSSVRS?=
 =?utf-8?B?aWY3ekt1OFlyd1NkVElhc21ZOUlOeC9LazZRWmhON0RSdVdteHozM1VmWVlO?=
 =?utf-8?B?eEU1dThubTdTdjh0S0phMndBdVk4djJsOG51VVdVYXNEVDliY2J2MWJPVmcr?=
 =?utf-8?B?b2lFc0hUbmtDNUE4eXVmNVFYN3F1WjJaL1Nxc3lxUU9YRms4T1BOZ2ZLT1Rp?=
 =?utf-8?B?dU5wSm9yRzlWZ25kR04wbDArVW5YODRHV0RUcFVzc21ZbEwzakNrbTlmWnZs?=
 =?utf-8?B?Y0tXSktqZnJBemVMeGZLWmtEeUx1MTZnMGpDRkNBRGxxUThxRnRybldrMlVM?=
 =?utf-8?B?VGxGaVIxWjFTT0ZaNXZPSHRMQjNrZE9mbFZRQy9HWXF0L1pHSHptMVJ3R2ox?=
 =?utf-8?B?aUtnY0VHdG5OWkhEVlo2NEd5cGdLWEFVVXYxUWdsN2I5T3NObkYvN3A5M29j?=
 =?utf-8?B?ZlE2WUFZOXJHVWEya0tSanVGejZTRnFlVEVHNWJLOVZjYXZnYU11dlFmMEdV?=
 =?utf-8?B?TzJBOEdRc09QblAyNXk3aktZM1lSeVk4Y1BGemlPWUl4Q2Jab2ZBSGFZMG8w?=
 =?utf-8?B?TUNtVlNuc3JaSzNncUVDc3krSU1nc2NxdjNUZVNlWldJK3N6b2pjREd3ZkRs?=
 =?utf-8?B?dFR4bU9WKy9hMlYwdStueWRHb2NObE1WVjBYUDB6VEwzMGVWY2FsdkwreWNF?=
 =?utf-8?B?VnI0SUZCS1ZXMjJRNEhXOFlIQldOVEc5WWdyQmwvRTRJSVNLd0NlUE9mUmUx?=
 =?utf-8?B?ODhqa0gzbmlZbDFjd29aQmdKQmhPR0JZblNtMGppcUJrWFFzeDl4UklrVkRz?=
 =?utf-8?B?aE9VblIwbkdEQkE0UEw1WVRNZTladGtXN2lCaEZJR1l5Q1lwZ2FTQkVtRXRM?=
 =?utf-8?B?V2V4YklzMlBHTmw4RFk5aFVYMW11RzNFMkxscWNtWlRyMzROM3JFUnljTzJ5?=
 =?utf-8?B?VDR4NnVDYTNHMHRLZ2FOWnJJVjBST3d0WWtmYWtuUURlYzc1UzJmcXZ1WVdx?=
 =?utf-8?B?VTFDS0Q1NytuSUQ1ZnJBaXZVZDlMNGxjZ0NwVURyVGFzcldQdk4wMEp6MzRI?=
 =?utf-8?B?b0xqMXNlU1lKeFM5RzJXaWNobkNBNmgxMk14MHdnRDc4czRtdUZZZWZCTEha?=
 =?utf-8?B?Nm53UUFZUElZcWV2V2l3VW1FVlVUc0tRaVZvbTdUdGFTZEFpOFRZL0E0TkFl?=
 =?utf-8?B?b0krVkJFTklIMjR6MWZia1dXMnZNWFNHeW1YVlhXUFJYNXdINUY0WGFaZGpB?=
 =?utf-8?B?eVhad01mbXNRUmRWYmFKZEtBc0plT0UxOUlDUlhDamw3bTJCNFlHQUdZdHlW?=
 =?utf-8?B?c3FMMU1ZUGNBMFR1cWdQY3dnS1Z6NytFT2lHRWRUd1MwUHMwa2tOMFFNQ2N4?=
 =?utf-8?B?WEJsbnhyZ0ZxakNSY2FSS3dERXVGamtwa0lVR1FoRTJZbk1WYy9DcnpiR0Nr?=
 =?utf-8?B?WXFzQy9IWDV6dmZpeUM0SFgwUndWbUhrcElQMmVPeTI2dnZhU3RMVWF4Nmsx?=
 =?utf-8?B?b25ZK1hHUkw5SGF0SUgwOGRuSnJEcHMxYi8zbEVsS29wUk9sampsQnNtN0xs?=
 =?utf-8?B?M3hreC9uRjRnZ1FIQ1B5Mjk1Szl6ejhZRFJnYXlFV2lXdVdJNUNNb00wSjNF?=
 =?utf-8?B?TUlKR3F4S0tmQ1ZkMGU3RkFIcTNyZU9yQXRRVWIxUERCY1ZMYXBWaFZCaUQv?=
 =?utf-8?B?d2lKa1ZTTDF3OUJsL2JmNTNVT3FTZS9NTStmZTdTb0NvYTNsU1pPeG02dmhV?=
 =?utf-8?B?Wk5RYU11SEFCRlIrWTBTUU1vSEZNRFpTenI3aUNQd1RLalBrQmFhOXVIeCtC?=
 =?utf-8?B?NksrT1FFVDg4RHJrRWlrVGI4d1dBc1VYUk9IbGlZa0ZMSVcvVGlJT01ORzRu?=
 =?utf-8?B?N0g2YUV4VVJ0amd4b1dhM2ZxR3JtQ1V2dVlqVERjcDBWVEJxdjFFUWtXdFNG?=
 =?utf-8?B?MlhoQ01WWUFLeThaWFJ1bi91R2VvSU5wWjlydmxnWUIxTENVdjU2OWoyT3RF?=
 =?utf-8?B?ZGxpWWx5blFmbmVzQmhHaVZBQVBDdmFsemFJTUZBbTNURXBwZy9NTTM3dkl2?=
 =?utf-8?B?Y3U3ZFdHME9jbHVMZlN2K1VkeFZJbXhRYzltMHVkUis5Tys3VHdtakdGUnB6?=
 =?utf-8?Q?Ty09ody3J0fAnpfYAYAyrbyd3V3aIUzE8Ev+YZjVSc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <330FE2EA8DA18341B5A35F64B909E9A5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f1d441e-c541-418c-9e47-08d9aa1e44a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 23:02:02.5512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oCwwkf0zG20JLuBgx1rL3Ip75vUmNb70SzSlbLtrrHoA8vlBytg0eedAGu0snsaDerSE8KndPu7nNbJGVeXMR/nYQU+nOYPpGv8He7sRDkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB5746
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTA5LTE2IGF0IDE1OjQ3IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgQXVnIDMxLCAyMDIxIGF0IDI6MDUgQU0gVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52
ZXJtYUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEFkZCBhIG1hbiBwYWdlIHVwZGF0ZSBk
ZXNjcmliaW5nIGhvdyBkYXhjdGwtcmVjb25maWd1cmUtZGV2aWNlKDEpIGNhbg0KPiA+IGJlIHVz
ZWQgZm9yIHBlcnNpc3RlbnQgcmVjb25maWd1cmF0aW9uIG9mIGEgZGF4Y3RsIGRldmljZSB1c2lu
ZyBhDQo+ID4gY29uZmlnIGZpbGUuDQo+ID4gDQo+ID4gQ2M6IERhbiBXaWxsaWFtcyA8ZGFuLmou
d2lsbGlhbXNAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlz
aGFsLmwudmVybWFAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICAuLi4vZGF4Y3RsL2RheGN0bC1y
ZWNvbmZpZ3VyZS1kZXZpY2UudHh0ICAgICAgfCA2NyArKysrKysrKysrKysrKysrKysrDQo+ID4g
IDEgZmlsZSBjaGFuZ2VkLCA2NyBpbnNlcnRpb25zKCspDQo+ID4gDQoNCltzbmlwXQ0KKEkndmUg
bWFkZSBhbGwgdGhlIG90aGVyIGRvY3VtZW50YXRpb24gY2hhbmdlcyBzdWdnZXN0ZWQpLg0KDQo+
ID4gDQo+ID4gKw0KPiA+ICtbYXV0by1vbmxpbmUgZGF4Ml0NCj4gPiArdXVpZCA9IGYzNmQwMmZm
LTFkOWYtNGZiOS1hNWI5LThjZWIxMGEwMGZlMw0KPiA+ICttb2RlID0gc3lzdGVtLXJhbQ0KPiA+
ICtvbmxpbmUgPSB0cnVlDQo+ID4gK21vdmFibGUgPSBmYWxzZQ0KPiANCj4gT25lIG9mIHRoZSB0
YXNrcyBJIGVudmlzaW9uZWQgd2l0aCBwZXJzaXN0ZW50IGNvbmZpZ3VyYXRpb25zIHdhcw0KPiBy
ZWNhbGxpbmcgcmVzaXplIGFuZCBjcmVhdGUgZGV2aWNlIG9wZXJhdGlvbnMuIE5vdCBzYXlpbmcg
dGhhdCBuZWVkcw0KPiB0byBiZSBpbmNsdWRlZCBub3csIGJ1dCBJIGNhbiBhc3N1bWUgdGhhdCB0
aGVzZSByZWNvbmZpZ3VyYXRpb24gc3RlcHMNCj4gYXJlIHBlcmZvcm1lZCBpbiBvcmRlci4uLiBI
bW0sIGFzIEkgYXNrIHRoYXQgSSByZWFsaXplIGl0IG1heSBkZXBlbmQNCj4gb24gZGV2aWNlIGFy
cml2YWwuIE9rLCBhc3N1bWluZyB0aGUgZGV2aWNlcyBoYXZlIGFsbCBhcnJpdmVkIGJ5IHRoZQ0K
PiB0aW1lIHRoaXMgcnVucyBpcyB0aGVyZSBhIGd1YXJhbnRlZSB0aGF0IHRoZXNlIGFyZSBwcm9j
ZXNzZWQgaW4gb3JkZXI/DQoNCkhtLCBJIGRvbid0IHF1aXRlIGZvbGxvdyB3aGF0IHlvdSBtZWFu
IGJ5IHByb2Nlc3NpbmcgaW4gb3JkZXIuIFRoZQ0KbG9naWMgaGVyZSBpcyB0aGF0IHRoZXJlIGFy
ZSB0d28gJ2NsYXNzZXMnIG9mIGNvbmZpZyBpdGVtcyBpbiB0aGlzDQpzZWN0aW9uIC0gJ2lkZW50
aWZpY2F0aW9uJyBhbmQgJ2FjdGlvbicgVGhlIHV1aWQgaXMgdGhlIG9ubHkNCmlkZW50aWZpY2F0
aW9uIGl0ZW0gLSBpdCBpcyB1c2VkIHRvIG1hdGNoIHRoZSByaWdodCBkZXZpY2UuIFRoZSBvdGhl
cnMNCi0gJ2FjdGlvbicgaXRlbXMsIGRpY3RhdGUgd2hhdCB3aWxsIGJlIGRvbmUgdG8gdGhhdCBk
ZXZpY2UuIFRoZSBvcmRlcg0KaGVyZSBkb2Vzbid0IChzaG91bGRuJ3Q/KSBtYXR0ZXIgYXMgdGhl
c2UganVzdCBzZXQgdGhlIHBhcmFtLmZvbyBmaWVsZHMNCmluIGRheGN0bC9kZXZpY2UuYywgYW5k
IGxldCBkb19yZWNvbmZpZygpIHJ1biB3aWxkIHdpdGggdGhlbSwganVzdCBhcw0KaWYgdGhlIHBh
cmFtcyB3ZXJlIHNwZWNpZmllZCBvbiB0aGUgY29tbWFuZCBsaW5lLg0KDQoNCg==
