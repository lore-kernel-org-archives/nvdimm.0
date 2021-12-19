Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF6829CA
	for <nvdimm@lists.linux.dev>; Sun, 19 Dec 2021 03:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639884875; x=1671420875;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tDNAhZ5dKF6oULDmIoGs5nnzswgdUEi4t7uwKITi6AM=;
  b=VJV/EUnY7kExq6HmrDNlzQZYpNLWybSpOFoqawAAxJ5A5EXGX3XjTsw0
   r/ikBXrnBA52ns5Gr2HjBKIfstSI8ir6rk3/0nKD2aUlkvfPpjxclDGMX
   CZv2zzEKW2zCMJkVStMRQVbjrFED5JNn4GCdd/TsbaARR1TXc5wWOp/n0
   q7zCLDc4mG7WAPm0dpjyNUzX3Uqfm5gG/ono2QfUq1KU7yKV+dL5z50Fv
   +x0/n6m90+iXL7aZ4X1bNrWLtKFXBZTNwjxJ5dF2RvvCKz0dY936c9Glc
   IO9WEVcg52lqYI0518OQ8DqeKVTcvhYXEz+g9kGwLjwXbFJrH/F02oVaI
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10202"; a="226831128"
X-IronPort-AV: E=Sophos;i="5.88,217,1635231600"; 
   d="scan'208";a="226831128"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2021 19:34:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,217,1635231600"; 
   d="scan'208";a="507244466"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 18 Dec 2021 19:34:35 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 18 Dec 2021 19:34:34 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sat, 18 Dec 2021 19:34:34 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sat, 18 Dec 2021 19:34:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVkL4NJ6rXYhVB4MC7X5OfxfUTArCLSD0aF+8uYMsER15r3gm9kuUszBbNkF7Xxm3HnRPPiBEc5dnc1EQx0MHIy4filshrKZr67CrY5f+5PPetVNPPlB93UKIXiieJN7nKJOTmbpvhuVLywNnXqpfEEy5CvWD5VEGzUN1WM8RpP/mTNsqBH5LLiYcU4OrU+aq30DDwh3LfcQ1LHoUERb1VqXQrkQqRpuBcLh1ZirVwHApAZAJunH1KFasYR3il0lLYJ2+aSZr7asTkY0Gnbkf1GjJOXp/k2kuJEa3e7tRlKHoSs8eaQnHh1HJDazvB1e5fYnM/d+fi3JVf09P17fqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tDNAhZ5dKF6oULDmIoGs5nnzswgdUEi4t7uwKITi6AM=;
 b=VIZ6U5xgegEWBiRV4ixTXuIE3BM6egSl/uIfYB9aZ4HsG7v1cxhTfZ4tqwHfruHhy8SvSNf+Izm+ScnfiNynTjPqCe7YeyRDEkuQ47mWNUhBPAmJpjotEyJLPDludTj2EYdxLZ0G/Xyz6tWTkNbC2Wd4x6htvZMFPpTVxr+GY5di+r0D90sZZF6+mW+OAWG5Wi9AI+iGzlpmrpCGPQlgzB7vPAWj/e8J0cXiJTTnsJ34hIKI1NbuCfTwD8j/InuzDSUAQ/AXkV51iJjBLTnHUjLnDkMcEksfoK7zYFT0Fp3NhCzJSKWHNnJ8gQrVGFzXhPOy4AA5j1rkwmLwqjlx/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BL1PR11MB5397.namprd11.prod.outlook.com (2603:10b6:208:308::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Sun, 19 Dec
 2021 03:34:33 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be%4]) with mapi id 15.20.4801.020; Sun, 19 Dec 2021
 03:34:33 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "santosh@fossix.org"
	<santosh@fossix.org>
CC: "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>, "harish@linux.ibm.com"
	<harish@linux.ibm.com>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"vaibhav@linux.ibm.com" <vaibhav@linux.ibm.com>
Subject: Re: [PATCH v2 3/4] test/libndctl: skip SMART tests on non-nfit
 devices
Thread-Topic: [PATCH v2 3/4] test/libndctl: skip SMART tests on non-nfit
 devices
Thread-Index: AQHXCz1VwBp+UmNrVEO3k0tYuFrDuqw6OjqAgADB9wA=
Date: Sun, 19 Dec 2021 03:34:33 +0000
Message-ID: <7c7eb0388d4e4ed3d9acf02f46e92d2a518154e6.camel@intel.com>
References: <20210225061303.654267-1-santosh@fossix.org>
	 <20210225061303.654267-3-santosh@fossix.org>
	 <CAPcyv4jCUtuWG+Hwc-sndF=OFMXNK2hFDUkhUnEUzJUJTEL8zA@mail.gmail.com>
In-Reply-To: <CAPcyv4jCUtuWG+Hwc-sndF=OFMXNK2hFDUkhUnEUzJUJTEL8zA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 79898ecc-be54-491d-0523-08d9c2a07961
x-ms-traffictypediagnostic: BL1PR11MB5397:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <BL1PR11MB53974DE331187D6BB0E74FA2C77A9@BL1PR11MB5397.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZFvYr8xTVKG9C68QUbKkNhSjef0Gx7edx4RAaQ1IyQIq/6/AuYE+mmTFzDCjx5+TulbDsJLp3ouCx/yTK3pMBHhHsutIioz3PGvBi76UMLdnHPYx3R2fQXaA7Q3xVG/AyAKO4bogC35MIbcygiQcIbq6HVKlrEmeIQqdImIwhxjeOfgg1br5eON1g3VaNYVSh75vyoamSLQjiqc6594GONS/0ktVDufKFxNposcL6RrI9a6J74C+SHO8+E4p/pFO6uBZ6hmnlaSytlT1pqxdyLnBFXrvb68E86SyHCQGFMs5BeE0K7jph7sS0hjOGHkpRov9RFoGBW6lCXp+tOtnXTRdhJmzMTjLp/SSiO2BRfC/vfvnln01uLUL19KaywlHIooUVaePlZAUTrsllMKXdd4yLgaH1r5eRMiSzz13c1O8NzsgYrUKoZ5oYC+QKJ8T0SlJk7iTmDHLe62ReRJR8uo3WkC65d9A+rmRAe10GadACgBx9kRcxjS3W6NL7iB/EaE5D8+ODuzt8wltk7GyqHdFiEpUhUW7op7ZxF0eOijtFsdSm9iYuH29WyCiw/bOXl6+3nqLromDAc6qvwPi9I3H3SEFcPXUpngHq+EKKUd0GY4M/gO3LBKb6q8+pFccTn6bx7qkGQZ4EWEJazGkDvZ3wWGK2cf5h97MzPw8ufuaV88nUD/QbFIpcrEv0dSNuXZt9tSf+GaVdxMrSN47+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(64756008)(508600001)(6512007)(66446008)(66476007)(66556008)(38100700002)(54906003)(4001150100001)(66946007)(82960400001)(110136005)(122000001)(8936002)(6486002)(2616005)(38070700005)(36756003)(91956017)(76116006)(186003)(26005)(71200400001)(5660300002)(86362001)(4326008)(6506007)(83380400001)(53546011)(316002)(8676002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDJtUElqSThlby8vSncyeVVjMXBWMnd4SDR0clRsY1pvb0MrdmRmcHBMYkox?=
 =?utf-8?B?MFk5ZytGNll3M2E1cWIzK3ZMNStGalVOeWxoZVdlSnVoZzlvTzBJdkg4ZjlU?=
 =?utf-8?B?TVh2SDU3MGxNZ2d4YTMwdXVTVlBMZzNpQjd2WWpWd3lyK0VDTGFOZG1hVnJM?=
 =?utf-8?B?d1Yyb0k0NXpMa3krNGE5SURvb3NTUzFQSHV6YUFBall2eUZQM09palBzQ2Vm?=
 =?utf-8?B?VlZac0Jsa3dBRnZsRWZtQkNtcksxdXV0OG1YT0hYQURxQlJGc2pjbytHamFq?=
 =?utf-8?B?SnFOU2x0NFJ6YXE0ZHZCVkM4SDdWckRVV04zMXRDVTBPMndISWRiY05xZlFH?=
 =?utf-8?B?empKbWt1ZkRQaVp6TUY5QUVYaGJjaGZSSXd0NFB5NWU0eVpKN0pVNkxhbGYr?=
 =?utf-8?B?TzVSbFBlUW1vdTI2cEhjajgvTVdzQnlsYmMwTDVVN3pHRVJGM0VKenBSalQv?=
 =?utf-8?B?SVU3UEdLQUlQcHU4TVoxYlMwbWV0TmMwbDR3T2I2QUcrc2w3UmM4TkdETFNh?=
 =?utf-8?B?ZHQ4amR3NmdJTVVOYi9PKzF2ckNQQmYvZjgzd0I4dmdmQmowdmk4S3NScTl5?=
 =?utf-8?B?RitIOU9nKy9CMjRsWFRtcDhTNmwvZ2Q2WDNCU3JhMzVEdlBNd3JLZkx3T09D?=
 =?utf-8?B?TXNGU011czhZQ1BhcllKNUxvSEV5QVlhU2JGa2JURmZnQTJEdUJZamNkam5F?=
 =?utf-8?B?VGNXcXNqY3J6ZVFWMi9ndjQ0UmpvSG5CSkdtRXNsWE1qa3R0ajR6N01XK1hJ?=
 =?utf-8?B?cmQ4V2c5U1BPRk5wZi9YcFVBOUpoUDVRWU5XYTNnOWtESjViUlJGU2ZFVXdS?=
 =?utf-8?B?cXE4Vmk5T1NZRTEwMm5PUXJUNGE2ZmQ0N3QxNGliUXlSRGF4OFFuQ0VONEJP?=
 =?utf-8?B?Ym4rK1ZvSXYyVHpsNG91bnVJQ3VTU1ZmZEdzbkZseVV3bWlmbHQwY3VmUjRj?=
 =?utf-8?B?ekZZcnZWSmtrR1RWcU5KRkVnN1ZOZnZNVmFYM1crck1Kb1VxU3hkYnBOcnB4?=
 =?utf-8?B?QjA2K3VYMFZjY1hOTkxZSTcwVlI5cHd3SlZmcXkzWWFieUpnTk9ZbEt4VDBG?=
 =?utf-8?B?NUhXUS9hNWRISWI2bzlZZTE3b3lmZ25ZR2NSQWUrb0xMUlppRWZ6TTJwRHpw?=
 =?utf-8?B?ZW1WK0NuQmh3THJUc2p5THA0QjU0enRZaGhMQWJySUVRZzJBUndjSTQxOG9Q?=
 =?utf-8?B?RVp1MGt1Z05tUXBLUDNGRFkrN0t5dWRqU1JsUEQ4VlgybG5XeldMMW9EdWVV?=
 =?utf-8?B?b2JoQjhLbTB5d2RzZEVRUE5ha2hLRkZ1dnF6L0VvRFhHVVZmbUJtK3picmZE?=
 =?utf-8?B?djhlTTBxY3V2V1RjSlBaV3VSSm42S1ZtTGJGMi9CZnBUSDhNenV5QWFwN0hy?=
 =?utf-8?B?UUdJS0owTVZVRmcxSHNpanl0VTlyVkF2UUJyQzBMZXZPamNwNWp2M2xYcGlm?=
 =?utf-8?B?Rk5CeTZIY0UxUzFXOEFPUmpoSFhndTZsSXc2azkxejRzU3VwVEx5c1YwZkQy?=
 =?utf-8?B?VFR0SzlWWSt0YkZzaDUwamhmSVFySWpFMnAydmREZ3ZuS2xyU0lrNzdPTXZi?=
 =?utf-8?B?T2ZmTkFvcUwvcXhYNHZKd2p3RmF1c3ZLYUwxd0hCWjlaeFNhSlhPTU93LzVL?=
 =?utf-8?B?ZlpsWHdIcVQrUDlDSHZsZlhWMTdTWURtUTF4dHVJSENkN0xXUE5GaVVFQy85?=
 =?utf-8?B?NkVVeGtKNXhld1d6OGU3VlhJWWRpT01HSHVmY2lkSHY5L2s4REEwYkZaa1ox?=
 =?utf-8?B?Z0E1eUJRYStLWk9rZFU4N3VxcXBVMTdBMkYrMCtRR0JyT1h3ZGVMQVpNb1cz?=
 =?utf-8?B?MUE5N2NPWkJNcCt1cWFnRU50azVubVRKT3o1aFVSV2gvUHE3dEVnVThUakIv?=
 =?utf-8?B?TW51REYzc2FVMjlEVmVkZ0tqS3RTNTNlakRZVVdlS2ZyL3FRTkppVGU2Tzlx?=
 =?utf-8?B?amQ5d09lWUNPS1dsNW1Zdnp2alkzbzIyS2RPbjVKT3hsa29VQUFNUThuY1E3?=
 =?utf-8?B?amxxWmphLzZrSXBqMmJMYmlCMGZ6WTFUQ3FTclJrbXoramV4TWp2RFJDMWJk?=
 =?utf-8?B?dzRxZFBEMnJGZk9nZ0JQdzNpZ1lsbXo0Q3pBUS9YM0hwVm9TWVAxUkhYRUFp?=
 =?utf-8?B?M0dmS0lCNTdvYzBJR0tWcHRWRU43VW52dGNhVXMrck1vbll1a3IyM0RtclF0?=
 =?utf-8?B?S0pkc3VJcERmLzhjNjVhcm4wWUFRTE9sSlFkenJCZWxPYTE1MEpMRXZnQWtT?=
 =?utf-8?Q?UrgJj/IMOqnTyByUbKSm1HbXof9V0LW6zC5dH72Flg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <090C63E4E37C354C9D9C79B6EEBB81E1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79898ecc-be54-491d-0523-08d9c2a07961
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2021 03:34:33.6103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZuikJvXv/3UIrKHGammJ4c34jWyVPrXDZNQPYLavWZi5wMgYe3SHhx/9Pa2ld80T3QvCiO/sLCz5SebIxMR/RagO2cOkc1PvgaiBYi7KQ38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5397
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDIxLTEyLTE4IGF0IDA4OjAwIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFdlZCwgRmViIDI0LCAyMDIxIGF0IDEwOjEzIFBNIFNhbnRvc2ggU2l2YXJhaiA8c2FudG9z
aEBmb3NzaXgub3JnPiB3cm90ZToNCj4gPiANCj4gPiBUaGlzIGlzIGp1c3QgYSB0ZW1wb3Jhcnkg
Y2hlY2sgdGlsbCB0aGUgbmV3IG1vZHVsZSBoYXMgU01BUlQgY2FwYWJpbGl0aWVzDQo+ID4gZW11
bGF0ZWQuDQo+ID4gDQo+IA0KPiBIZXkgVmlzaGFsLCBvbmUgZm9yIHRoZSB2NzMgcXVldWUuLi4N
Cj4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU2FudG9zaCBTaXZhcmFqIDxzYW50b3NoQGZvc3NpeC5v
cmc+DQo+ID4gLS0tDQo+ID4gIHRlc3QvbGlibmRjdGwuYyB8IDMgKystDQo+ID4gIDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCg0KSGkgU2FudG9zaCAtIHdv
dWxkIHlvdSBtaW5kIHJlLXNlbmRpbmcgYSByZWJhc2VkIHZlcnNpb24gb2YgdGhlc2U/IChhbmQN
CmFueXRoaW5nIGVsc2UgaW4geW91ciBxdWV1ZSBJIG1heSBoYXZlIG1pc3NlZCkuIEFwb2xvZ2ll
cyBmb3IgdGhlDQpkZWxheXMgaW4gcGlja2luZyB0aGVzZSB1cCwgYnV0IEkgY2FuIHN0YXJ0IHBp
Y2tpbmcgdXAgd2hhdGV2ZXIgd2FzDQptaXNzZWQgbm93Lg0KDQpUaGFua3MsDQotVmlzaGFsDQoN
Cj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvdGVzdC9saWJuZGN0bC5jIGIvdGVzdC9saWJuZGN0bC5j
DQo+ID4gaW5kZXggNTA0M2FlMC4uMDAxZjc4YSAxMDA2NDQNCj4gPiAtLS0gYS90ZXN0L2xpYm5k
Y3RsLmMNCj4gPiArKysgYi90ZXN0L2xpYm5kY3RsLmMNCj4gPiBAQCAtMjQyNyw3ICsyNDI3LDgg
QEAgc3RhdGljIGludCBjaGVja19jb21tYW5kcyhzdHJ1Y3QgbmRjdGxfYnVzICpidXMsIHN0cnVj
dCBuZGN0bF9kaW1tICpkaW1tLA0KPiA+ICAgICAgICAgICogVGhlIGtlcm5lbCBkaWQgbm90IHN0
YXJ0IGVtdWxhdGluZyB2MS4yIG5hbWVzcGFjZSBzcGVjIHNtYXJ0IGRhdGENCj4gPiAgICAgICAg
ICAqIHVudGlsIDQuOS4NCj4gPiAgICAgICAgICAqLw0KPiA+IC0gICAgICAgaWYgKCFuZGN0bF90
ZXN0X2F0dGVtcHQodGVzdCwgS0VSTkVMX1ZFUlNJT04oNCwgOSwgMCkpKQ0KPiA+ICsgICAgICAg
aWYgKCFuZGN0bF90ZXN0X2F0dGVtcHQodGVzdCwgS0VSTkVMX1ZFUlNJT04oNCwgOSwgMCkpDQo+
ID4gKyAgICAgICAgICAgfHwgIW5kY3RsX2J1c19oYXNfbmZpdChidXMpKQ0KPiA+ICAgICAgICAg
ICAgICAgICBkaW1tX2NvbW1hbmRzICY9IH4oKDEgPDwgTkRfQ01EX1NNQVJUKQ0KPiA+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAoMSA8PCBORF9DTURfU01BUlRfVEhSRVNIT0xE
KSk7DQo+ID4gDQo+ID4gLS0NCj4gPiAyLjI5LjINCj4gPiANCj4gDQoNCg==
