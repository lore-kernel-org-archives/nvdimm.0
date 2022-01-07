Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF01173
	for <nvdimm@lists.linux.dev>; Fri,  7 Jan 2022 20:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641585720; x=1673121720;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9Mrhco6z98asiNCARuU+63LMfqTI7k95id1/2UCwl40=;
  b=MOrS8IRpbnf/BsTZcl2XqXvTfxBP/iw8HIDNSsHw30yvjPZlMbTfHz1C
   GJpXEvyadypawkgsQ7/HrlvB4jezirxm8ayECkwqzSyMXFY5iAamAEJ7I
   Cu8tz88yk+31oRJjv5dEZZIkmqp9nzo6CGKmrKFdcP7P/1PUGajBA0PA+
   kVUSOuMXTgLI0zQbbSNp28SShy9M3/n8E5Z6qTEFWIVyiz9qjtrIvlnBG
   t8KpRJzlHNsaGP/D7WxJqFeV0LH2dBgh/IA29LfDD1x0TLnxFevg4uQmI
   bhdNgmLYNGDR0C97rfqTs9jEMNi1iFY84LVa2HXZL92gudj//J2pI+Zzh
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="229739642"
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="229739642"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 12:01:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,270,1635231600"; 
   d="scan'208";a="622046529"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 07 Jan 2022 12:01:59 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 7 Jan 2022 12:01:58 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 7 Jan 2022 12:01:58 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 7 Jan 2022 12:01:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkkBNiNzQGskCzj7FkIUWVUGhiAs+zQqSme2V6bW7ryEaEiN/4ysYCVGxjhUNG1SLEjNAQk9cDvIOUfxzDdfgCQ7O6AWtmhhRW5GqVVYZCeftZyxUZFEMB/cPHOFaiP0LLmM37+DVolKliA3tb2bWX0LNflP88aZTaf/1a8motsqLWhYZa3ii7SUkQL+CEibVPR/x/w4N7alR2ujpnB8J2f9PzJIAoUhe3HhlBM809tFQSTlY/m9iQ3RLI9uOz8r/2Xf29XFRPHk2Xj1/BMuierSxLHsokv+tZuABpz4sXhl7ZjwFjKkMvUsgD4ltmcOzAIrO2tDZuQeevIpmJtSOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Mrhco6z98asiNCARuU+63LMfqTI7k95id1/2UCwl40=;
 b=CZd4Cl00kNg7yPv7voFfNaaUdBB7qFiXkECSOEwtX2RysID2GK7S2ZwTT+OObKJ925dMTWxm8wizvdJiXC9bMS0DveT0XWlMDxOvmHr4++mO6NN//9QGBOFP2wxN29ufGiKffSgmhMCoAQWod6iLS0tUCs9rj9A3mPzRIalOMim4zfgs4lXLXabmM7jlS3t2fp5+lG+hT7cWgP8QPkKFyKmiI1ZIgd08DcHy9XuZVb1UBNwHRoDbdO2Cl8nQ/XunPw/AdVLhxnqtwlaZcQk/jx0uK77iZYR3uQNaqeKZgkgwVSw45vWW4mzEc/rjiMLOefU7EYCViCFPr0UdHJz9Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB4517.namprd11.prod.outlook.com (2603:10b6:208:24e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Fri, 7 Jan
 2022 20:01:56 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be%4]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 20:01:56 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Schofield, Alison" <alison.schofield@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Widawsky, Ben"
	<ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH 3/7] libcxl: apply CXL_CAPACITY_MULTIPLIER to
 partition alignment field
Thread-Topic: [ndctl PATCH 3/7] libcxl: apply CXL_CAPACITY_MULTIPLIER to
 partition alignment field
Thread-Index: AQHYAN4fgC50n+vu1EuA5UbCw00NoqxWeYCAgAGHmoA=
Date: Fri, 7 Jan 2022 20:01:56 +0000
Message-ID: <1e1bfb68e343801dd80c17a8fd8649da0f4a8eb7.camel@intel.com>
References: <cover.1641233076.git.alison.schofield@intel.com>
	 <a5ff95fd75d42c29a15d285caee81cb9ea4c05d8.1641233076.git.alison.schofield@intel.com>
	 <20220106204019.GD178135@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20220106204019.GD178135@iweiny-DESK2.sc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6268232e-09a9-43f9-ec2f-08d9d2188eef
x-ms-traffictypediagnostic: MN2PR11MB4517:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB4517D4FA6531D361D9E0F8D4C74D9@MN2PR11MB4517.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R8rODlK4f+VwJ2n99Mhbobd+Ym9W1tfoaoGaqo5ASKwLLLW/DsGi1LcTU/ps1WL8+brgD4jDW7w+miWxxXU9MqouBJQDrtFkBS3rJRShobdFxaPEsJIAGgq4v8ewTBhVCGqcT9LvDLLK3HbRbNsZKoR8hmNuq8ZBxgJhoVPAH6YyXdrhPPZAC/gmrJ8lRQeJsAEMeI8u6d6DuKqltqCp7dTLVQpdNoa6cKb+mmotrcvsUte67xwYUn8iktDyFRxWXVI8IVELXAj2CU5u/IfNMeQ+NqFaR70xq+raiMfKnRe4+yWDDf1zkabzuI277iezIo1LmdvZEA2rl/pSXRliQsxACt0aaZc43RgHXBDmpiFUAH8nG1/G8PClmS6IdzChgn7ajATJ33RCy+490LZjdpAZU5+aw3qhCAV6KTbhfEBIm3WTmuoIFXPidxcTVYjAIErc6uCNQAQbIZdZWbPHDfNyg/bdEmtyBzXLjR3jrb2rQeGpSvFlVhjRo9YoSziTGfcf8zI37cD/EvCiksY34F1cTfT2S6hIJeDuvTgqffrIUcNFZ3IVIoTcRckuGlNt2MDD+mOW4DhmAeKqpYFUsI27Af+xKHpalx/z2GkBkxaLjWaUthGEoTqTVZCWUkqQ5uThX4JE3zcQHZGtYC/cz1HhHr09V9C106HwgXf5eyV4P1qgpTUlx8MEBw9UcKKqXe/ZZR/pa37+llse0Qp1ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(76116006)(26005)(5660300002)(91956017)(38070700005)(64756008)(66556008)(66476007)(66446008)(508600001)(6636002)(2616005)(38100700002)(6486002)(66946007)(71200400001)(8936002)(110136005)(54906003)(8676002)(2906002)(6506007)(4326008)(316002)(186003)(36756003)(122000001)(86362001)(83380400001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkU2UE0xN0NzUkFVMmR5TjFpZFJ0ZnNEdFU2NDIrSytxTzh4RUZOOVVCaXJN?=
 =?utf-8?B?NzBsTjYzbGY2L3FmZXo0YXFNangzQWxPMXQ5QnQ3S0lIdTVSQnRVdFh3WkN6?=
 =?utf-8?B?R01KTGlibkRCaUFMd3VoK2h6eVROWGJTR1oxVGVia3NWZUZmeWJFMkRtdVhH?=
 =?utf-8?B?Y3N2UVdRNDZiUnZUKy85aEJ4RHYyMExVOUNCLzdwdms1SDZwN1oyemREOEt6?=
 =?utf-8?B?a0Q4STNUZUdPUlN1Uis3Y2tMMG02a1RleGduMFpHZHFuZ01nWldHa1BqckFw?=
 =?utf-8?B?ZkZPaUZzNUNrd21UbTlJUTZaM2Y1cEh4QW1wV1F1L0tMSGVlTVpmRHlFVjhL?=
 =?utf-8?B?Nm9aRUlXdUE2dmJncURuODNtL0s4d241VmNiZ0xtM0xwRmRkc2JXUUMvNDlG?=
 =?utf-8?B?L1liNWFuYTdSU1pQYmsvRDltRkRuSWdWdzE3a2VuU09ORlU2dU96MXdsNjRp?=
 =?utf-8?B?MHpzK0lxSlhuanJRdmlVcWl4NXprOGZ6cFUzeGhiQzBtUW9OU05UaVdGU24x?=
 =?utf-8?B?bDQ0OHZzSk5aS3hsdjJaSjF0UlpkTytxRmZsV3hmSlhQVEtGd3cxOTZzUG1n?=
 =?utf-8?B?Lzc2a2RtM0x3bHZtc1VFZWlsQlhVdGMwWVdtK0hkU3FGYlcxNGh1RDZQZzh5?=
 =?utf-8?B?ckRzb29XQXNDdzVEREJMaXpYWFpDbk5HekhlOHJTNDlMeEF1c2ZSc24rOSs4?=
 =?utf-8?B?SEJSSDZjbVdiajJxbTNtTXN2bnI5eHZRQ0UwaDNYcnVCS2h1dGV1QkUweDR3?=
 =?utf-8?B?SUMzclNVY1hHQ1E1aEFYQm5aS25ILzRGVkI1dWlVWXpIN0xEWklMS3pSd1lP?=
 =?utf-8?B?TTUxdlJCV0VmdytKK01jMHdHYTBxeERtVnNoM3FBZEh1cGtGSHFhYVMzclc0?=
 =?utf-8?B?V3JZWVp6SHd5ai9VVEVjWEY3SzNGYVcxcHRGSENoaHRibUlFWmc3Q2tGVllL?=
 =?utf-8?B?V3NTcXNMRHRPM2xiTGNrS1k2dE9meUJBRVlyWEpUWTBFQ2c0SmtPSXoxTGIy?=
 =?utf-8?B?aHRsZmtCamYxWFJ5MFMrT1hMMzlNc3B3R09qNXFzUWtERU51K01OOGpiVU12?=
 =?utf-8?B?S2FVc2hBMFcwcVRJOWVGSWcvdDJzWnEzTHg2TFpORUYzR0VpdHZOVDZBejVJ?=
 =?utf-8?B?bG85QXpIVzVRUG1JZ2JyU2xKSk1LV20ydnZtOVpCZHg3eVdBd1JQelp2ay9q?=
 =?utf-8?B?V0ViVkNDbFpzQ0c2dHJ4VWx1VzZDTk95WkFPQlVwL3RnNEJ0S1M0cUpTeHJO?=
 =?utf-8?B?RXJwQVl4L2pLdzJYYnFxZFNxb2RBcFhPbWdhMXZvSGZPSjlQVitQL3hwOVhK?=
 =?utf-8?B?emNMTjQvMkgrd3hPdVhjdHBDK0JNRG1mclk1THpPR3RtUHQ3WGl4NnFtNmNF?=
 =?utf-8?B?YjF5NFdEK05GYlVQd2ZXbjgrS2RablV1U1RJdUNVUGdKT0NvdTVqYitvazdM?=
 =?utf-8?B?ZDErRnBremZNaURMQzg1WUV0dUZEVmU0azlVRHhBUS9VNXhVeUFkWmpzeXZa?=
 =?utf-8?B?VDBlVkNzbzNjZW50ZEJFS0tqRDFQeGdwUmNtb25Icy9SY1gwZG9pU1g0OVZ6?=
 =?utf-8?B?YjRlZm9NOEhyVkEzN1BaNmNVZ0N3TElPKzQwRWVydDNtM1JKalBUNndGeDly?=
 =?utf-8?B?UkFWQmNaYWRWZjBFQXhMNXlQVUlmcStacHU4RmdLM2Z3UUxjK2hJTE5vVDJO?=
 =?utf-8?B?RTJUZGRSOWRWbGZiVzRkUEVyYkIyQ2M3MHBKT1lyaGQvZ2JrTWI5NUF6UXJG?=
 =?utf-8?B?WGhhc3pJT050Lzl0VVZBZFpaSnZnRW1icFk5d1JHaWFZRTB4SkVFSXNYUnlO?=
 =?utf-8?B?eWNhUC9nVjlaaEh4MFA1MzErU1JaNUVjVWJLS0RlK1FsWHhNVEsyb0JLQ1k5?=
 =?utf-8?B?ZVJqWnZnMWhSKzhOMndsYWpBTzk3ZUdiVDhkTWo1bzAvMVk5VUtoZnN5RVVQ?=
 =?utf-8?B?eFY5TjRTUlMwWTNyK2VLT1FtNGVXdjllbWF4bHBTV2hnSnc2N1YzM2hnd2JU?=
 =?utf-8?B?MTFMaFdzUStrNHNjQmRFY3dmV0NBWkFqdVNIbEVOdTBjd3dKUWEwNnBlNU9D?=
 =?utf-8?B?aGJCMURGeWxwSFYzemV5bHdBSGFRbU1TZmJiWnp3MkluSis0Y3BqTUhBODNa?=
 =?utf-8?B?NDh3RVlkTDZPZlJVZHIzTzc4cVlKeEEya1VDR2RmZzMyUmlTYUJibGR1M1BG?=
 =?utf-8?B?OUtjbldCTlpBbTZaNjZaVkJaSkp4WThvM0lxM1JNc3c4YVJRdllaejUzOEpD?=
 =?utf-8?Q?KvFKDi7yN/7mGkLZKGA1Re6FzCZqSaSG5NUCeaWtGk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39A09B6CDA57F24590F080DCA497ACD7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6268232e-09a9-43f9-ec2f-08d9d2188eef
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2022 20:01:56.7392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o/NPTSL940rTHh6FMcMRTMr4mAT9NBpmkEPqm93TRco0CJAvD944HdV6mLZdSLy0bVGQ1Ulsg3PAnyOUbXTTl12wyufe0afVhx4D1XH3J38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4517
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIyLTAxLTA2IGF0IDEyOjQwIC0wODAwLCBJcmEgV2Vpbnkgd3JvdGU6DQo+IE9u
IE1vbiwgSmFuIDAzLCAyMDIyIGF0IDEyOjE2OjE0UE0gLTA4MDAsIFNjaG9maWVsZCwgQWxpc29u
IHdyb3RlOg0KPiA+IEZyb206IEFsaXNvbiBTY2hvZmllbGQgPGFsaXNvbi5zY2hvZmllbGRAaW50
ZWwuY29tPg0KPiA+IA0KPiA+IFRoZSBJREVOVElGWSBtYWlsYm94IGNvbW1hbmQgcmV0dXJucyB0
aGUgcGFydGl0aW9uIGFsaWdubWVudCBmaWVsZA0KPiA+IGV4cHJlc3NlZCBpbiBtdWx0aXBsZXMg
b2YgMjU2IE1CLg0KPiANCj4gSW50ZXJlc3RpbmcuLi4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgYW55
b25lIGlzIHVzaW5nIHRoaXMgZnVuY3Rpb24ganVzdCB5ZXQgYnV0IHRoaXMgZG9lcyB0ZWNobmlj
YWxseQ0KPiBjaGFuZ2UgdGhlIGJlaGF2aW9yIG9mIHRoaXMgZnVuY3Rpb24uDQo+IA0KPiBXaWxs
IHRoYXQgYnJlYWsgYW55b25lIG9yIGN4bC1jbGk/DQo+IA0KPiA+IFVzZSBDWExfQ0FQQUNJVFlf
TVVMVElQTElFUiB3aGVuDQo+ID4gcmV0dXJuaW5nIHRoaXMgZmllbGQuDQo+ID4gDQo+ID4gVGhp
cyBpcyBpbiBzeW5jIHdpdGggYWxsIHRoZSBvdGhlciBwYXJ0aXRpb25pbmcgcmVsYXRlZCBmaWVs
ZHMgdXNpbmcNCj4gPiB0aGUgbXVsdGlwbGllci4NCj4gDQo+IFRvIG1lIHRoZSBmYWN0IHRoYXQg
dGhpcyB3YXMgbm90IGluIGJ5dGVzIGltcGxpZXMgdGhhdCB0aGUgb3JpZ2luYWwgQVBJIG9mDQo+
IGxpYmN4bCB3YXMgaW50ZW5kZWQgdG8gbm90IGNvbnZlcnQgdGhlc2UgdmFsdWVzLg0KPiANCj4g
VmlzaGFsIG1heSBoYXZlIGFuIG9waW5pb24uICBTaG91bGQgdGhlc2UgYmUgaW4gYnl0ZXMgb3Ig
J0NYTCBDYXBhY2l0eScgdW5pdHMNCj4gKGllIDI1Nk1CJ3MpPw0KPiANCj4gSSB0aGluayBJIHBy
ZWZlciBieXRlcyBhcyB3ZWxsLg0KDQpIbSB5ZWFoIHRoZXJlJ3Mgbm90IGFuIGludGVybmFsIChp
LmUuIGN4bC1jbGkpIHVzZXIgeWV0LiBJIHRoaW5rIGJ5dGVzDQptYWtlcyBzZW5zZS4gSXQgaXMg
Y29tbW9uIGZvciBsaWJjeGwgdG8gY29udmVydCBzcGVjLWlzbXMgdG8gd2hhdGV2ZXINCm1ha2Vz
IHNlbnNlIGF0IHRoZSBsaWJyYXJ5L2N4bC1jbGkgbGV2ZWwsIGFuZCBmb3IgdGhhdCBieXRlcyBt
YWtlcw0Kc2Vuc2UuDQoNCj4gDQo+IElyYQ0KPiANCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBB
bGlzb24gU2Nob2ZpZWxkIDxhbGlzb24uc2Nob2ZpZWxkQGludGVsLmNvbT4NCj4gPiAtLS0NCj4g
PiAgY3hsL2xpYi9saWJjeGwuYyB8IDIgKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0
aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2N4bC9saWIvbGli
Y3hsLmMgYi9jeGwvbGliL2xpYmN4bC5jDQo+ID4gaW5kZXggNzE1ZDhlNC4uODVhNmMwZSAxMDA2
NDQNCj4gPiAtLS0gYS9jeGwvbGliL2xpYmN4bC5jDQo+ID4gKysrIGIvY3hsL2xpYi9saWJjeGwu
Yw0KPiA+IEBAIC0xMDg2LDcgKzEwODYsNyBAQCBDWExfRVhQT1JUIHVuc2lnbmVkIGxvbmcgbG9u
ZyBjeGxfY21kX2lkZW50aWZ5X2dldF9wYXJ0aXRpb25fYWxpZ24oDQo+ID4gIAlpZiAoY21kLT5z
dGF0dXMgPCAwKQ0KPiA+ICAJCXJldHVybiBjbWQtPnN0YXR1czsNCj4gPiAgDQo+ID4gLQlyZXR1
cm4gbGU2NF90b19jcHUoaWQtPnBhcnRpdGlvbl9hbGlnbik7DQo+ID4gKwlyZXR1cm4gbGU2NF90
b19jcHUoaWQtPnBhcnRpdGlvbl9hbGlnbikgKiBDWExfQ0FQQUNJVFlfTVVMVElQTElFUjsNCj4g
PiAgfQ0KPiA+ICANCj4gPiAgQ1hMX0VYUE9SVCB1bnNpZ25lZCBpbnQgY3hsX2NtZF9pZGVudGlm
eV9nZXRfbGFiZWxfc2l6ZShzdHJ1Y3QgY3hsX2NtZCAqY21kKQ0KPiA+IC0tIA0KPiA+IDIuMzEu
MQ0KPiA+IA0KDQo=
