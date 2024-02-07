Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227D4127B40
	for <nvdimm@lists.linux.dev>; Wed,  7 Feb 2024 20:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707337486; cv=fail; b=fPGf0CfeNjJWVxmKWDI4CrK934sJD8JnoGfIC/YssDeijjVabEV+xtUtHUmJHarDFzpWNLWbGZvzr2VMbk70gQyoL5Wbn4OOS6jzBwqvEp5Vd+JELD0sjmfLKAAhU6b4PhL219NLO6VvLJVVW8WqgbPGn7bNZVsmSlFy2DtMJrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707337486; c=relaxed/simple;
	bh=rvI+l3DQdJ9PPqCbWJ9MeQInT6keGkSok4fAhrDviUA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oMONbHcHpNYz1HYfPJC+hady4dG4a3e0lDkcIY6T2k0Iqj+7mgBJ9MSqQ8nNDq7wJW5WGM+3sFEJ6UmnGQ4o3nHO8inY0neeUVX3WsHRRBHxAGIVe7npnmtsREYk5reUQa9hLGDfOB7JFJwIaat9Cvx1pjtQEugs04nQHw228CM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LGFZNZI4; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LGFZNZI4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707337484; x=1738873484;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rvI+l3DQdJ9PPqCbWJ9MeQInT6keGkSok4fAhrDviUA=;
  b=LGFZNZI49hx3SAeTLw/2ihWvLDX1CPp/tZV/OIo0IWb2OY+joy/g94kq
   bt9lYo6Tber2qZQsom69deb3UkH4UvK9eFNFZjgYwJx/yDTkMcmypsjA9
   dHeeQY6RpU9XEMr3b92KYnXeyrHe9RcH1L/DaAUg1ao7v0xT8aiG0DTI4
   cBIV0gAgoxXgSsyZVnRyTrT9dvIVZ/D7pfrCpMeKxAWN4iIQvEe1CpYGi
   utly7bvCYe0szS5GgGsVEwe21Au2vERLyo08RldkeQ7IP1gNsUH9gYEsJ
   L7mYAIVZ1Xt8XvKgA397AimekYn9H8ZsML3N42VtUcIj1lgFbehNC/87I
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="4855743"
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="4855743"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2024 12:24:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10977"; a="910096123"
X-IronPort-AV: E=Sophos;i="6.05,251,1701158400"; 
   d="scan'208";a="910096123"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Feb 2024 12:24:43 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 7 Feb 2024 12:24:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 7 Feb 2024 12:24:42 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 7 Feb 2024 12:24:42 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 7 Feb 2024 12:24:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Izb9jQLI7iY68U2DbbjSwi2hutu5Jdc+Sz9rjlx8w5/D4ojKffXg50wRkSUIcJa9YJ/wmyD/+r+oRXKb+2MgnfhhAlY+RGn59Blvl31KCvot029N7xwGFhC4diO9vd02Cd4Fj2F1cOwdP2jK9OE2nyAX4y2pw5njeHw0OVxaVNlZFcUa1mp5fsBdVxm6aiw/bzGIMVdNdpHYCda85z9oWowldA1ZMIkqrD3jSLz5DQwaGpRS2wmq2Bzh0DXEkPGBNU/uPb0omC9HXI8W446jKtCLfHW4xlwUVq36Uo9K0tPT+ZuprhFnpOLZFJtWYDHRjVeJydgcormaSNZ5+5GBew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvI+l3DQdJ9PPqCbWJ9MeQInT6keGkSok4fAhrDviUA=;
 b=ljFvEeAGm4lveVdIfu14eE1xoE/52wVaieNcnERU5ntGSomsT8rHXDx5WCywTdaXxWuigdo//A0dk3YMssTniX9GaOBEBCsMEoZjxlEPBnaYeiISVfhbw7LzpI3BgbxSlK27zsMAiAPk7ccNg/Xk/CWrhtQ6ZB39Nmfq1yjqUHW0rJ9bPkBVzKNEiKuyAg/b7YgxvWVT8sU/KXJXyGadiOxCBRJ11K0QmbGc9ykU1gjhmPoRT2i+YDJr67ovmi+DCL/YpnX3fWq09Q49t5xOEyed0KnT/yXsPMhUrZFZww0R+wVBE6wq7gn2nOmAeRAAOqdFvWBiJ+koupUM/3ZV9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Wed, 7 Feb
 2024 20:24:38 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e28a:f124:d986:c1d0%5]) with mapi id 15.20.7249.038; Wed, 7 Feb 2024
 20:24:38 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH v6 1/4] ndctl: cxl: Add QoS class retrieval for the
 root decoder
Thread-Topic: [NDCTL PATCH v6 1/4] ndctl: cxl: Add QoS class retrieval for the
 root decoder
Thread-Index: AQHaWeoTIzchSlUrWkCL/YrcGXNJqLD/ThyAgAACMoCAAAD7gIAAAjgA
Date: Wed, 7 Feb 2024 20:24:37 +0000
Message-ID: <e3a64a23308aa70fd680729475cdbddc21bd2c8e.camel@intel.com>
References: <20240207172055.1882900-1-dave.jiang@intel.com>
	 <20240207172055.1882900-2-dave.jiang@intel.com>
	 <ZcPiffSmUyGWC6kB@aschofie-mobl2> <ZcPkVQjK2tXbrvYt@aschofie-mobl2>
	 <c24b91df-f94b-4455-9086-2cad26fc3400@intel.com>
In-Reply-To: <c24b91df-f94b-4455-9086-2cad26fc3400@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|MN0PR11MB6059:EE_
x-ms-office365-filtering-correlation-id: 06933d20-2e87-4c0a-ed20-08dc281ace94
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XpGZjeO0x2ocwEIOjv52hSQsZynhL6PJXafei8MdGUB2LUJ12ZRPgN4lSStLPjFVTMw2kKsEPnSuRjijYo7H3MWW5SWgydh/krB7oml1YNO7jfjQSXYH05Lc0ahgc0c6On2uoIFkGKc/h3EXofdWWTSsePsI/J3ZGMRGATXUMFHNxjGg00chc+ujh4Fe2vOec10tELNph5cs59LxusrVtyBKe3JY9ERyKG9SaUjepI1LCExEiDDgyYpKcayRn9rQb+musg2fpsJRjVFLWQ5D0Ro7cZ30WlRJDtGn5NTBKeDrSHZGGbz5JnZFuMMM7VoOdMrzkFQUaMA/HaKYQZtM4lGAlgvCbyXUiEdqlEm6LE9KzQkEpU4+YU6+EbD2l9Chz9GAJ8es8uH3Xa66R8t8XsV7AelJJWoWYmVVVG6U/xQcnmZjhW0+9k3DiskCQ3sOU9Zi4pJcm6bAI7O2Hv/I4z1OGv40ScMCqm842tWK8OZQiPIVIJDOm5+m+3cNbGXQOQ4GJXuhqmAM65FFx4Z9jegC5jAJfAX5WyEbJLAn7OnPakKNMYkfPsPSE24OfwSLHaqSITHUZeNfi2zGvvqcaQ3J2no/3OSX3hgrqmYnJlPs3EmwtOcOl/VsiQeOfaqj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(366004)(136003)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(82960400001)(38100700002)(122000001)(54906003)(478600001)(66556008)(71200400001)(6506007)(110136005)(6512007)(76116006)(66476007)(66946007)(6486002)(2616005)(26005)(66446008)(53546011)(86362001)(38070700009)(41300700001)(36756003)(4326008)(5660300002)(8936002)(6636002)(316002)(8676002)(2906002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TExnZjcxbTdqeGl0TVlxNnpxS2dLd1FNbnpoK1NXNjdva1U3aGF0aVVkRlZC?=
 =?utf-8?B?R0ZFbHhjWU9SdVNHdWF0UHhBdzZqdVJRY3RmcFlXeXdRMDY0M3o0ai9nYUw2?=
 =?utf-8?B?UjRKbThLYnNuQm9aeERwZVlGRlh4SnVSWWc4OXBHaGo0alBDMTUwZHFGck96?=
 =?utf-8?B?dmQ2VE9TclhZQnd3ck1FTEY0M2FCU0xSUFpiVVNGYkkyczYyV20wTDl3YkNv?=
 =?utf-8?B?ZURiUnNERklwREJhSnFBOUJXcmVaOVZlQ2lmV05BMktMeTFqVjU0T2tneThC?=
 =?utf-8?B?eUJmQllCbU1EbWsySHJGYi9sOWJQVFZxd29MbWx3b2hnNFU1UnJyeW1PRlN5?=
 =?utf-8?B?T2puRW5UcHdtMit3ZkpjYnE3NWF1QzRNWi9USzgyckx3WnNqa3MvTkt0SE5T?=
 =?utf-8?B?T01RWnNaWjd3VGJRTkR2Mk4wLzNra1RhVnFkcm9ETmkwbVhLcHNUUS9jVG5K?=
 =?utf-8?B?ZEN5R0hRekpoRmgyNFJEMW10YlhSWk9pUFBTM1E0aUlRUG9lWnV3QlNRZm0r?=
 =?utf-8?B?OWFtZnREUVQzNnoyTkpWcTR3cndMSnlXQUErYTdHd05XUWtxLzVLZGZRMUQx?=
 =?utf-8?B?S3FUV2pSWlRkUk9pL3d5V3NuZlkzdlI3THpBbWttQ3JYY2dEUTRMT0QwOGp4?=
 =?utf-8?B?RTNyYjBoQ0wxUVlTSWlydlpZVVZFM05JT3JEcnNxVTc0V2J6MS9vcGhsTnlx?=
 =?utf-8?B?UmtTTFIyVmJFdlp4eEVrWW9IbzExbkpGa0pXbUhobGQzVE0zTGY0aHg2NVd6?=
 =?utf-8?B?L21IU2laQk02V1dybHF5a2FPSkZYeDdzeU9TdUQvSkoyYVcwUjlQd24waEFu?=
 =?utf-8?B?NXQ1UG05L1o5T0JEVDN6ZzZPV0M3QmRaMzNRU0tLd2NiVnUwOE81RGZwVzFw?=
 =?utf-8?B?T1A4MVJRTHZybjB6ZGRvYUZWM3VwRXAydkNZYlFDT3E4QmY1V3Y4QjFKTUZF?=
 =?utf-8?B?VUI1VmpiN0YwZ3FFSXNIaDZibWt6ZVY1TkxMQ0FVaC9ZZmtTSXF1RFc5c0Fx?=
 =?utf-8?B?ZWN5WlNua1FSVE1td1NaNkJTV2M5d0JSNVVGTmtHQzlrMWpBVnFuS1V3T0F1?=
 =?utf-8?B?RDkwcVF1dm0rQ0NEczNaOXB0blV4T2hJK0ViQU10RnlueEcwZ2JQelhzRWUx?=
 =?utf-8?B?YkJ4Z1o4b3NRWVJGWUZNbUQ4cE1IUGQzc09JRi82YkNRaXhTMmNZM1kwN09N?=
 =?utf-8?B?Qk5pRDBtTGFXZHhiSGZBanc2WDJxeU1RakgyNEZuT0hSVDVMVDFlOFUrSk1t?=
 =?utf-8?B?ZGtiY1RzZ2VtQ0pUTDl6emNzclNUdndESG13c2xlYnRoWjlJeERNZzF6c3pX?=
 =?utf-8?B?ck82bWJTSTZBQWZxb2dhOEI5UGpwM0RZTmxadyt0U0tVa1JVRnBERFlodEI1?=
 =?utf-8?B?aTl1dEE1ZnV1K1hNeC9yQklzMTlDN0MzaVFiVHJvK0FnY3I0K25ucnc2S29J?=
 =?utf-8?B?aU93ZUIraCtMOUVyNDlydzNsMm4yWExEU0liVUlleEVoaGhzMDhaL2hmb2ZB?=
 =?utf-8?B?eWxJZUJCQlRMUWpGVjFhOXJ3MzlhYlR1VnlJUVVVV3RtVytJeW44Qlh2cHlj?=
 =?utf-8?B?eG9oQVR0TW9ZRjVEZUd6QUV4Q1h2UW0raDBEbjQrcU1xVGlMNUJVZlU3MElE?=
 =?utf-8?B?L0FaakRvTllTZUMzOFNlZkp5elRPYUR5c0FDTWJhSGlGRXZCLzIwVzJOeUI1?=
 =?utf-8?B?YWlmaWdqTWpndWZJakwvQXFsN0FkS3hiMURVM3VpV0xMVXpHV3ByMGVsNndi?=
 =?utf-8?B?QzB5STNhYmhTbTlGUW1VcFlodXVTTUJRQkUxZTBqSUpCWUNFWlVJTFBjanFv?=
 =?utf-8?B?MExiR2wzTWtGRVE1TjY3a2orZGlPdnVFNHFPdEFtRFRPWFRRUk1vMHJWTGo5?=
 =?utf-8?B?c3Q1RzgrTWRLRE9VcUx0aXdMOWhSYjhiVEdaaU44WVlqYUoxNmtYWTlOVjd6?=
 =?utf-8?B?OGMzNzM3alROU1pqUW1ycDBlL3lDRERqRCtkSThzOGo4YUtxb1BCK21pME5S?=
 =?utf-8?B?QW92NFRWQTFJbStYSmZhTUpHK1FURHFHaFVDamUvbFgzOC81VFB6QVhHdjYx?=
 =?utf-8?B?V3FYZXlmbWkxeVovNjVVeGpRblNBMnNGS3Nhb2dMVnZOU2U4TmJYOURPWm50?=
 =?utf-8?B?SmpVaHlQYytsMnczTm43ZEN1eWNDdGZpTzBWZ3hyaFV6WVk0NkpjVEVCNkh0?=
 =?utf-8?B?ZFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D002E3AF56ACBF48A35752E89C21DFD4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06933d20-2e87-4c0a-ed20-08dc281ace94
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2024 20:24:37.9721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MSzxzx4BWAjyinaN8AYAFg1mQKP3y9yh5CTM4lSo5xzG2U6MC+SLW7ty9SfCe3lqv7ItBXvMmRd+7QDgHfwC+q1D0H5KnkkGkzfVG6zsf6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6059
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAyLTA3IGF0IDEzOjE2IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiAN
Cj4gDQo+IE9uIDIvNy8yNCAxOjEzIFBNLCBBbGlzb24gU2Nob2ZpZWxkIHdyb3RlOg0KPiA+IE9u
IFdlZCwgRmViIDA3LCAyMDI0IGF0IDEyOjA1OjE3UE0gLTA4MDAsIEFsaXNvbiBTY2hvZmllbGQg
d3JvdGU6DQo+ID4gPiBPbiBXZWQsIEZlYiAwNywgMjAyNCBhdCAxMDoxOTozNkFNIC0wNzAwLCBE
YXZlIEppYW5nIHdyb3RlOg0KPiA+ID4gPiBBZGQgbGliY3hsIEFQSSB0byByZXRyaWV2ZSB0aGUg
UW9TIGNsYXNzIGZvciB0aGUgcm9vdCBkZWNvZGVyLiBBbHNvIGFkZA0KPiA+ID4gPiBzdXBwb3J0
IHRvIGRpc3BsYXkgdGhlIFFvUyBjbGFzcyBmb3IgdGhlIHJvb3QgZGVjb2RlciB0aHJvdWdoIHRo
ZSAnY3hsDQo+ID4gPiA+IGxpc3QnIGNvbW1hbmQuIFRoZSBxb3NfY2xhc3MgaXMgdGhlIFFURyBJ
RCBvZiB0aGUgQ0ZNV1Mgd2luZG93IHRoYXQNCj4gPiA+ID4gcmVwcmVzZW50cyB0aGUgcm9vdCBk
ZWNvZGVyLg0KPiA+ID4gPiANCj4gPiA+ID4gUmV2aWV3ZWQtYnk6IEFsaXNvbiBTY2hvZmllbGQg
PGFsaXNvbi5zY2hvZmllbGRAaW50ZWwuY29tPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBEYXZl
IEppYW5nIDxkYXZlLmppYW5nQGludGVsLmNvbT4NCj4gPiA+ID4gLS0tDQo+ID4gPiANCj4gPiA+
IC1zbmlwLQ0KPiA+ID4gDQo+ID4gPiA+IEBAIC0xMzYsNiArMTM2LDcgQEAgaW50IGNtZF9saXN0
KGludCBhcmdjLCBjb25zdCBjaGFyICoqYXJndiwgc3RydWN0IGN4bF9jdHggKmN0eCkNCj4gPiA+
ID4gwqAJCXBhcmFtLnJlZ2lvbnMgPSB0cnVlOw0KPiA+ID4gPiDCoAkJLypmYWxsdGhyb3VnaCov
DQo+ID4gPiA+IMKgCWNhc2UgMDoNCj4gPiA+ID4gKwkJcGFyYW0ucW9zID0gdHJ1ZTsNCj4gPiA+
ID4gwqAJCWJyZWFrOw0KPiA+ID4gPiDCoAl9DQo+ID4gPiANCj4gPiA+IEFkZCBxb3MgdG8gdGhl
IC12dnYgZXhwbGFpbmVyIGluIERvY3VtZW50YXRpb24vY3hsL2N4bC1saXN0LnR4dCANCj4gPiAN
Cj4gPiBNeSBjb21tZW50IGlzIHdyb25nLCBzaW5jZSBpdCBpcyBub3cgYW4gJ2Fsd2F5cyBkaXNw
bGF5ZWQnLCBub3QgYSAtdnZ2Lg0KPiA+IFdoeSBwdXQgaXQgaGVyZSBhdCBhbGwgdGhlbj8gSSdt
IGNvbmZ1c2VkIQ0KPiANCj4gSnVzdCByZW1vdmUgcGFyYW0ucW9zIGVudGlyZWx5Pw0KDQpZZXAg
YWdyZWUsIGlmIGl0IGlzIGFsd2F5cyB0aGVyZSBieSBkZWZhdWx0LCBubyBuZWVkIGZvciBhIHBh
cmFtLg0KDQo+IA0KDQo=
