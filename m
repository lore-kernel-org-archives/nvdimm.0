Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8250515250C
	for <nvdimm@lists.linux.dev>; Fri, 12 Apr 2024 21:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712958128; cv=fail; b=t/18lSRrvVeYLgUeLzDFHXVyjMMV7prpPB5RvYf8xJqP21tCQl/R8XbYFVbTuhYLvXeKrZCdHo99JhlnRJlI7ofTBk7RecDzK3vJ6bA6ivrDEoBPBBZjlzuSh8Zr7Zqu4AaS8TixG0VATlRORPs8vTsrFr/RvoiB8CI7iC7rU3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712958128; c=relaxed/simple;
	bh=kLTURXbC5rkgF5BnE8hWEgD6+JZ5ZMvb+vE1muQ+BWM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ljh6CwjWGg+dGPBxuourm061RPgtbmH7mZ2iiwWFBT3H6BLiTFGel1+dxAhrhev5GKmCPQEhrqkbQcrB1QEyVGLmS6ErcwcYyoehGRMT3EmkmfkMJRWh6mY68ToyX9agbmyQ67xJt6h1paLiQxHaEii4/dQqCb3O9HmIoYjJtkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K2a0JHRr; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K2a0JHRr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712958126; x=1744494126;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kLTURXbC5rkgF5BnE8hWEgD6+JZ5ZMvb+vE1muQ+BWM=;
  b=K2a0JHRrJlRcVeccZB7Ce/59kI0LxBzjYm0o1ahN2KGf7A2vn4L2SrqF
   Wpv/wMPDUUvNGjGIV9AnievmlwrcO+LMjn1ijrI/WIQmP8ipsNTEyxoYo
   22uE++CXntqwtk8bu8ZhU6gj43Lj0qHZqoeGt5zDvEf6wBvKRJRVKLhRI
   ROJVPiiElfY5qRYOgjOnV/IHquAvvgk296/CJoiUTrGMj+TCIyFzyBxOV
   ZCAkbax5nPI5LW7YH6ZBn9OfjZjdGSaJuT3sHM9rLRAqKczt6FtrPuHnq
   WuLjDQ1N2NH+dsQMOFbv17pqlA//TKoYJ93c3gT3WThmeSJic1ZtalxrW
   A==;
X-CSE-ConnectionGUID: C+oXjqyrQSKGpxwAM7W5Eg==
X-CSE-MsgGUID: BmlD9iDxQ3+9Efwf8h4KVQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8299876"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="8299876"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 14:42:06 -0700
X-CSE-ConnectionGUID: suKjwEgITJSiEeh2csAxag==
X-CSE-MsgGUID: CXXPJYCJTY+CmyoQdP9MYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="21917789"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Apr 2024 14:42:06 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 14:42:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 14:42:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Apr 2024 14:42:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 14:42:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gzGSd0Qr01uSGJSXe3Qh5UkoJFe8U1UhT6dSkgtvLP+QIeNcsVl9RVlrCdFXV2RTkLTxdpl9BBvsXf/ijMq10XtVxqjJlVR5JvIA25302L3w9sLlZ/c+dn/BajyX49Ws17AiXNMrgwjZmpxn21/wP2yC+YcFZGql/y6rpFuG12jF75WQSPH5CTkBnHfKKuApJePvwos1olXfOoe9aBkOfRMiZHj7h1DtoTsPRJ64U1LYXLP6Yu22u0N7VioFd9Zj+mtUJdXnjxL6Cu54VDfb9HocTud4EH+tfTTLUcj+aedr5/yUeQJQySkQZThbDRniDzKBkuKX5fE2nI6sRIimNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kLTURXbC5rkgF5BnE8hWEgD6+JZ5ZMvb+vE1muQ+BWM=;
 b=KwxxsCk8tavD71xoa1MPtvEPC+lJLKAACvwBIIQJb1SFjj5vxkh/IZIHmj2sbi817GQsUJNJxcbEgbyK3ZUfpdNF3gdLSBKoekyxtTh8kI62q7wh+klNT5ouSt/lzgsBoNgGBb1E7VCfIHFuKWxZlsnnOERE0OzLDEGHtkXrLRh34uX0w6nJ9w+OaBSfZNV/wl4TmusM7RusIXtVXbYvJ6ZVjtW77AVs/y2TVVZfhkTinwBlkLNrBUdiZIpctwW+NJECb/6HMhlv8Oo8pKqEzX6jox0j5eZXX3Kfmmv/7NfNzNU3J6VgoCvH6bkk5qmXhWFhB4OzmN8a/2cntOqV9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by LV3PR11MB8458.namprd11.prod.outlook.com (2603:10b6:408:1bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Fri, 12 Apr
 2024 21:42:00 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::28bc:28a9:78d3:8190]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::28bc:28a9:78d3:8190%4]) with mapi id 15.20.7409.031; Fri, 12 Apr 2024
 21:42:00 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Schofield, Alison" <alison.schofield@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH ndctl 2/2] daxctl/device.c: Fix error propagation in
 do_xaction_device()
Thread-Topic: [PATCH ndctl 2/2] daxctl/device.c: Fix error propagation in
 do_xaction_device()
Thread-Index: AQHajR1FjMRLSXQ08USVBaNHU5jbnLFlJu8AgAADVIA=
Date: Fri, 12 Apr 2024 21:42:00 +0000
Message-ID: <71977fdd416cd5ddfb896010ef56ecea0c23c26e.camel@intel.com>
References: <20240412-vv-daxctl-fixes-v1-0-6e808174e24f@intel.com>
	 <20240412-vv-daxctl-fixes-v1-2-6e808174e24f@intel.com>
	 <6619a7dcd1a18_24596294ec@dwillia2-mobl3.amr.corp.intel.com.notmuch>
In-Reply-To: <6619a7dcd1a18_24596294ec@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.4 (3.50.4-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|LV3PR11MB8458:EE_
x-ms-office365-filtering-correlation-id: cbbf27c7-69d7-40d7-4400-08dc5b3962b1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8FHcVfv+ObfWVdY4V0JO+/WN1QFOkEOXzy6dWMnC76pbdSQnmUkcIzfsAUYp9dDrmJ3e/QYgfphSjROtayuESjBPtd/b6TrrK1xNpgdtnPA+6/AZiQrNxEdD8O9JyxC62GIPPSGNXhC78lv/Wb1TdBmxKqzuEEF7bAVX2yTjObEMPHe7/HMHvzM+bRmQVWpc8NKd34Eb65q3HIeQJ8Z6PlYYWOYmQRT43SBk09bzMqGX0kWnm7dd9zWnirm7TBYcwl7o84eAChGQk5Fa7y19L8uWrXXI45X/96poPGdBIdlCGkinPFj45ZwYu/OjPZHjZakIETmAxDURFVJXxN6fxcam84IZViGdzWCTnlbHYW5p2WTyJXEti4QyWa7n7YAgmsE7NwUquHztVnlKPKrM8nx/DZXr3SsONCrqqDrOeF7mzecipzJdOVHqev/gPVXlYtjJDz+eFRQ7AauVOZk8D7eB2bXSlCD04i2Z0a78FXiWsV1+HdIRuKTupM8vo2IOdny4vkdHhqWdEySNKwEy682KrF+AIM28Zgv6MZlPkK8TQoKiJEuhTCRAGNzSwe+L1TMZSmsNmPNqYpLCRQuFnaH81tv173P+o7zlKLxnaUIiPUlYnWA5/ebHQAmOnxN/0sAp1TGcMbP3ZNQMgQY0mE88h4fXVO9n6xwTMjHS1KFuehKT9Xphh5VTIlSoUhf08gJaeRs3srnNHZ+EQgfrNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1BteVBLZHlCbU9WNjRIaDA2cExUMk92cWhURU9QMWRFNXZLZWg3YTl2eFRl?=
 =?utf-8?B?QU5KR05FRzJGQ0pjZXNUZWpaSmhseGdRcTRkcFR1ZXRQVHR5ODZibjloNjFL?=
 =?utf-8?B?K3dCanptV0ZrWFZ4MzlhTlpFM1BkY0JzR2RzTE1CcHZhZlNxR2JtSldFR0Fv?=
 =?utf-8?B?bWlPaHJiZHNhU2pQNXZ2d1FSOGhFQ2hxNFBQajJ0REdJM1NRbDNrQUNPWmFG?=
 =?utf-8?B?eXJwTHRJRHpXSVZaWUwzVlBxRFFMVDZzN3k3aFhTOERGbUswVVNlTXV1MjNy?=
 =?utf-8?B?OGVteW43NlhHYUdNYUJ1azlaY0RFN041cWp1Rm1YeWFyRnBLSTUzUXdPR0NP?=
 =?utf-8?B?R1pBa0p4am4reUhrc0VvdzdtbCt2OEtqUnNHMzg2dkk5ekI4b1JKanJWOW1p?=
 =?utf-8?B?ZEtzaEEyWmJUTWxlWE0zdEpCL2xyZVRwd1V5Vjdjdm5kYUJNR3hJeE5FMGJr?=
 =?utf-8?B?aVUvRHdVSUNST2I3aG1CekxCVHJRaVc1ZmM3M2FXd0R5NjVSSGlodlphbjV1?=
 =?utf-8?B?TDV1WVB3QTh0QUl6Rlc2YldlL0szZHViVm9oNWtGLzhzengzRnBkV3l0eFVm?=
 =?utf-8?B?cFl4RzNTYmI0T25uOEsyUWZZYlNhMlljeHR0WWdTcGdZOFRhYyt4REZ1QmFx?=
 =?utf-8?B?NVhwTXN0WVljdk5ncTBFR1RtelFYWDEzU3JSZ2pLUnZ3RitsdkJ4dG9XVWRY?=
 =?utf-8?B?NElCNjhmQVlnMTZSanZmSmYvM2tXMU9PQSt0bWk2cXc2alBWeW5lLy8yU0Jp?=
 =?utf-8?B?TW4waDVHQmFOUDZmTVdlMVJ3Zkx4SnNldFJ5SGhzTWpOek1RU0ZXS2w4REln?=
 =?utf-8?B?Yy84TFIxTGVJUEs1QzRRYkg0eE5YVHNpV1doMzNHNnVvMk8zNitDYm4rT1JS?=
 =?utf-8?B?bExieWZ0U21UYjNERXFtQVNESTJUaHpkV2VjWG5kNzg3RklxajVSMEo1a1FC?=
 =?utf-8?B?dGpvaXVkcE9mZEVhNHdIMG96SjE3YkR1RjFDRE82TXd1dE04WFFZTEdVOGpU?=
 =?utf-8?B?dXZTL3BYUURoTUZHRDFoT3ZpSDl2aHNMd0d3ZHZCb0tmb2RlT01GQ1Y0S0E4?=
 =?utf-8?B?M3BicFA2b3dkTVNDdVUxQ3d6TUsvV3Exa09QcWUxRjMzSUp2U0hmR09Ld3Z1?=
 =?utf-8?B?aFp3MjI5bW83aWllekcrVzhpd05UMC9TOGxOb3hoTnVaYlNsSVkxNkFjcnlq?=
 =?utf-8?B?R1drYkFadDhCcFhlWVBRZEp2dkF1Z1ZIa0xDVHExdTh4dnM3MVhnMDJPUUxW?=
 =?utf-8?B?dXkxQU90WU5yWHJZczZxVXJCemJaeitrOHJOQWUvVnVYS2NaOEE5TEttcndv?=
 =?utf-8?B?YTJrekpmL1Jvb0t4RmlQcjd6LzlEYjJ5QThIcDNMMVpkVCtmNjlMeGJuaGJF?=
 =?utf-8?B?dHlCc1BrNGQ1aWlsdzJlY0JwL2Q4MWxkTW5sUklWdkp1c3JnT05kdzJwZmE5?=
 =?utf-8?B?YUNUdUUrUUdndGxmWUdGZWc1NlNEZWJlRXBSZXlNaTBQak02RmhnVzVpc09q?=
 =?utf-8?B?eFZnRFVMbFVmS1EwYzZoaG10UWxTdEdkWXVTSG1PSkRDQkpKeDBtT2QyZmhW?=
 =?utf-8?B?NHZmcVowOWgyRWRTRW92YUJEZmszeFBlQlpMT3ZYVFBjRXphRXJIbEF6TnJL?=
 =?utf-8?B?ZjMzd0tQTEZ6bkhlNmZVSFg1SUI4WEROWWJzUytQeTZqcm16aS8yN29aZnp3?=
 =?utf-8?B?N0lzZmpNUkRVZUhNa3o3VjZVMGV3bjBoeVFPeitYWHJNOUwrTzJETXB6UUhh?=
 =?utf-8?B?NVRMdzJ6dXQ3V0orVzJIeGV3VDZvMm5oZWVsaG0xNmk5VFplbkhUVHQzZmZi?=
 =?utf-8?B?Ymoreno2V0M4ZkdIeHNxTGdQdm1sWG9Xeml4UGU4a3pobTJpZHVzMWt6ZnFL?=
 =?utf-8?B?YkJ0TjhTaldpY1dIdTJYM1lQN2V3ME5IUURNSElMVThPcGhPN0d1NGtqa2NR?=
 =?utf-8?B?VUJNem11NHordGZXcGRpbDRqY0NqTGZCb2xBTy9pREI4Y0VNMytINUZ0NFN3?=
 =?utf-8?B?Ym8xM05UaUdGb1B4Nm1kUE5kWHB5NXFVSDdhWEY0Ym42MFRYSkQrMXRzNlI4?=
 =?utf-8?B?YkJodW1QeGJHRXRqdHRzNXdxRGlNaTNBRnRHRGJ5MkRhWEFoM3Q5QVRGdUk5?=
 =?utf-8?B?aXF2VmZLcnRJWkJ1UEpkR0pveDFFM1gvSW5YS0ltRmI3VDZlYmFMQWZuaDB2?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <85D4A5EBFAC2D041A93F7A6536E39E35@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbbf27c7-69d7-40d7-4400-08dc5b3962b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2024 21:42:00.6213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hNuCEFn6QfKGZaU4Ar8dVNP9TKoJ3wG2yLiISUWIPF2okWWNV60C55SYlGIqT2wuBcakN7MphEre2juZX/AVpQbbFKfQdPE6LuE1L3WggVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8458
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA0LTEyIGF0IDE0OjMwIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFZpc2hhbCBWZXJtYSB3cm90ZToNCj4gPiBUaGUgbG9vcCB0aHJvdWdoIHRoZSBwcm92aWRlZCBs
aXN0IG9mIGRldmljZXMgaW4gZG9feGFjdGlvbl9kZXZpY2UoKQ0KPiA+IHJldHVybnMgdGhlIHN0
YXR1cyBiYXNlZCBvbiB3aGF0ZXZlciB0aGUgbGFzdCBkZXZpY2UgZGlkLiBTaW5jZSB0aGUNCj4g
PiBvcmRlciBvZiBwcm9jZXNzaW5nIGRldmljZXMsIGVzcGVjaWFsbHkgaW4gY2FzZXMgbGlrZSB0
aGUgJ2FsbCcga2V5d29yZCwNCj4gPiBjYW4gYmUgZWZmZWN0aXZlbHkgcmFuZG9tLCB0aGlzIGNh
biBsZWFkIHRvIHRoZSBzYW1lIGNvbW1hbmQsIGFuZCBzYW1lDQo+ID4gZWZmZWN0cywgZXhpdGlu
ZyB3aXRoIGEgZGlmZmVyZW50IGVycm9yIGNvZGUgYmFzZWQgb24gZGV2aWNlIG9yZGVyaW5nLg0K
PiA+IA0KPiA+IFRoaXMgd2FzIG5vdGljZWQgd2l0aCBmbGFraW5lc3MgaW4gdGhlIGRheGN0bC1j
cmVhdGUuc2ggdW5pdCB0ZXN0LiBJdHMNCj4gPiAnZGVzdHJveS1kZXZpY2UgYWxsJyBjb21tYW5k
IHdvdWxkIGVpdGhlciBwYXNzIG9yIGZhaWwgYmFzZWQgb24gdGhlDQo+ID4gb3JkZXIgaXQgdHJp
ZWQgdG8gZGVzdHJveSBkZXZpY2VzIGluLiAoUmVjYWxsIHRoYXQgdW50aWwgbm93LCBkZXN0cm95
aW5nDQo+ID4gYSBkYXhYLjAgZGV2aWNlIHdvdWxkIHJlc3VsdCBpbiBhIGZhaWx1cmUpLg0KPiA+
IA0KPiA+IE1ha2UgdGhpcyBzbGlnaHRseSBtb3JlIGNvbnNpc3RlbnQgYnkgc2F2aW5nIGEgZmFp
bGVkIHN0YXR1cyBpbg0KPiA+IGRvX3hhY3Rpb25fZGV2aWNlIGlmIGFueSBpdGVyYXRpb24gb2Yg
dGhlIGxvb3AgcHJvZHVjZXMgYSBmYWlsdXJlLg0KPiA+IFJldHVybiB0aGlzIHNhdmVkIHN0YXR1
cyBpbnN0ZWFkIG9mIHJldHVybmluZyB0aGUgc3RhdHVzIG9mIHRoZSBsYXN0DQo+ID4gZGV2aWNl
IHByb2Nlc3NlZC4NCj4gDQo+IEkgdGhpbmsgInRoaXMgaXMgdGhlIHdheSIsIGF0IGxlYXN0IGl0
IGZvbGxvd3Mgd2hhdCBjeGwvbWVtZGV2LmMgaXMNCj4gZG9pbmcuIEhvd2V2ZXIgd2UgaGF2ZSBl
bmRlZCB1cCB3aXRoIGFuIGVycm9yIHNjaGVtZSBwZXIgdG9vbCB3aGVuIGl0DQo+IGNvbWVzIHRv
IHJlcG9ydGluZyBlcnJvcnMgZm9yIG11bHRpLWRldmljZSBvcGVyYXRpb25zLg0KPiANCj4gY3hs
L21lbWRldi5jOiByZXBvcnQgdGhlIGZpcnN0IGVycm9yDQo+IA0KPiBkYXhjdGwvZGV2aWNlLmM6
IG5vdyBmaXhlZCB0byByZXBvcnQgdGhlIGZpcnN0IGVycm9yDQoNCldpdGggdGhpcyBwYXRjaCBp
dCdzIGFjdHVhbGx5IHJlcG9ydGluZyB0aGUgbGFzdCBlcnJvciwgbm90IGZpcnN0Lg0KDQo+IA0K
PiBuZGN0bC9uYW1lc3BhY2UuYzogcmVwb3J0cyBsYXN0IHJlc3VsdCAoc2FtZSBkYXhjdGwvZGV2
aWNlLmMgaXNzdWUpLCB1bmxlc3MgaW4gdGhlIGdyZWVkeS1jcmVhdGUgY2FzZQ0KPiANCj4gY3hs
L3JlZ2lvbi5jOiByZXBvcnRzIHRoZSBsYXN0IGVycm9yIGV2ZW4gaWYgdGhhdCBpcyBub3QgdGhl
IGxhc3QNCj4gcmVzdWx0LCBpbW11bmUgdG8gdGhlIGFib3ZlIGJ1ZywgYnV0IHdoeSBkaWZmZXJl
bnQ/DQoNCkkgZ3Vlc3MgSSBhbHdheXMgcHJlZmVycmVkIGxhc3QgZXJyb3IgaW5zdGVhZCBvZiBm
aXJzdCwgYnV0IGhhcHB5IHRvDQpjaGFuZ2UgdGhlc2UgdG8gbGFzdCB0byBtYXRjaCBjeGwvbWVt
ZGV2LmMuIEkgY2FuIHNlZSBob3cgZmlyc3QgZXJyb3INCmlzIHByb2JhYmx5IHNsaWdodGx5IGJl
dHRlciAod2UnZCBub3JtYWxseSB3YW50IHRvIGtub3cgYWJvdXQgdGhlIGZpcnN0DQp0aGluZyB0
aGF0IGZhaWxzKS4NCg0KPiANCj4gVGhlIHN0cnVnZ2xlIGhlcmUgaXMgdGhhdCBhbGwgb2YgdGhl
c2UgdG9vbHMgY29udGludWUgb24gZXJyb3IsIHNvIGl0DQo+IGhhcyBhbHdheXMgYmVlbiB0aGUg
Y2FzZSB0aGF0IHRoZSBvbmx5IHdheSB0byBnZXQgYSByZWxpYWJsZSBlcnJvciBjb2RlDQo+IHZz
IGFjdGlvbiBjYXJyaWVkIG91dCBpcyB0byBub3QgdXNlIHRoZSAiYWxsIiBvciAibXVsdGktZGV2
aWNlIiB3YXlzIHRvDQo+IHNwZWNpZnkgdGhlIGRldmljZXMgdG8gb3BlcmF0ZSB1cG9uLg0KPiAN
Cj4gSSBkb24ndCBoYXZlIGEgZ29vZCBhbnN3ZXIgYmVzaWRlcywgYmUgY2FyZWZ1bCB3aGVuIHVz
aW5nICJhbGwiLg0KPiANCj4gSXQgbWlnaHQgbWFrZSBzZW5zZSB0byBicmluZyBuZGN0bC9uYW1l
c3BhY2UuYyBpbiBsaW5lIHRvIGd1YXJhbnRlZQ0KPiAidW5sZXNzIDEwMCUgb2YgdGhlIGF0dGVt
cHRzIGFyZSBzdWNjZXNzZnVsIHRoZSBjb21tYW5kIHJlcG9ydHMNCj4gZmFpbHVyZSIuIEhvd2V2
ZXIsIGl0IG1pZ2h0IGJlIHRvbyBsYXRlIHRvIG1ha2UgdGhhdCBjaGFuZ2UgdGhlcmUgaWYgaXQN
Cj4gYnJlYWtzIHBlb3BsZSdzIHNjcmlwdHMuIG5kY3RsL25hbWVzcGFjZS5jIGRvZXMgbm90IHN1
ZmZlciBmcm9tIG5lZWRpbmcNCj4gdG8ga25vdyB0aGF0IG5hbXNwYWNlWC4wIGNhbiBub3QgYmUg
ZGVsZXRlZCBzaW5jZSB0aGUgZGVsZXRpb24gdGhlcmUgaXMNCj4gZXhjbHVzaXZlbHkgZG9uZSBi
eSBzZXR0aW5nIG5hbWVzcGFjZSBzaXplIHRvIHplcm8uDQoNCkFncmVlZCwgSSdtIG9uYm9hcmQg
d2l0aCBob2xkaW5nIG9mZiBjaGFuZ2VzIHRvIG5kY3RsL25hbWVzcGFjZS5jDQp1bmxlc3MgdGhl
cmUncyBhIHJlcG9ydGVkIHByb2JsZW0sIG9yIHdlIGhpdCBhIHRlc3Qgc3VpdGUgZmFpbHVyZSBv
cg0Kc29tZXRoaW5nIGRvd24gdGhlIGxpbmUuDQoNCj4gDQo+IEkgdGhpbmsgdGhpcyBkYXhjdGwg
Y2hhbmdlIGhhcyBhIGxvdyByaXNrIG9mIGJyZWFraW5nIGZvbGtzIGJlY2F1c2UgdGhlDQo+IHBy
aW1hcnkgZmFpbHVyZSBjYXNlIGlzIGZpeGVkIHRvIHN3YWxsb3cgdGhlIGVycm9yLg0KPiANCj4g
UmV2aWV3ZWQtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPg0KDQpU
aGFua3MgRGFuIQ0KDQo=
