Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A971FCC
	for <nvdimm@lists.linux.dev>; Tue, 13 Sep 2022 03:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663039147; x=1694575147;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6SDrDGAMp8sCHXUx+lGa19WkvrE2fJGE7upW81Ai1Ac=;
  b=FEQq+2VpsH8WamXJJwvMlYWLnMdH1XpfPW4IG8CcOSolHJRauroz0svk
   jEa/6UnOTxpWeyzLGhWAZ1XDqEzrJecYjyUgGQ9OgoOXh7VS9V4WXSuA5
   vxj7BLaSsZOid38/ctO242oG9tdjTSRnn7TSqECJyQHfEwltgrJ4oC2CE
   U8+4H2pi6U8kDJJGm9cd9NF0g1sZGQWuIo+jIFJ2CgLG65PsZqhUkEyV/
   saQilUZklBHMwLIAm4rcjpz+P03vmz2D46Oz56oU39jnAQdaJc/O4VTk8
   eS503MNA/TCiVf8dUvMVwKzfAZi6DRk+p9SV5QI6xLEbwDZDsJNOyahk7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="278418202"
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="278418202"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 20:19:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="944882492"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 12 Sep 2022 20:19:06 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 20:19:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 12 Sep 2022 20:19:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 12 Sep 2022 20:19:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZ4Sgm1ltx87uZbj2j/0Ydq8K4/So8q3lqHrh+yPorg7C9JzVXbaCtEhAkNjO3mA79KhIk8qLtAB9vRkL057XE6ShbXSgtxT/sjjurPbcx8IVS85ULJCIkB9TTCOrshLYHlpFYw+msXPCMOkAiJNh8mJ0c1CjmUet6biJqfSkgYBphnn16oxZt/E/KA5jVrfRQqhFGNTeA6FS14HXgZGCnfWDb4C/PJVrNvATuLKiwI8m1AYHxJUd1b4g7ag2kRSwvaLCkWTteL3Q/LUizDBZsGQOshmb1aZvkzteLyAJUU5qqDQ6GiNe0NCdK3wjdMb2VLYXNjOBUGERYFvLtvwiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6SDrDGAMp8sCHXUx+lGa19WkvrE2fJGE7upW81Ai1Ac=;
 b=OyadSsFlOrVsLN564sG0JiCtkYBIXN0DPirmKEeThr5XJifYYQymWpuEkh4r/VfZwBop7M+06AA5afvrjFUC/oBL/8LD0lCFHC29DCQRBGct5rnnfw3WRUYV11c6BVZlS2kXIwvxtKs9n+X9SJGkKlYNFeXPW6vr16S75J/jvWHgZj2stxKm6TQEEXX7D6AQhA/xJV1/WLG+gincQO64HySgcswwscDtqhfcldau5tl4OWR+klOI/JWGGfi7EcoBuA3N8fhSeMa4hrKnvVAjh+zpVqFSLFeFXdvfYfadyu3zDOzrIcTb8u4b1EUSVjHVBqJtPenKGoE86xgjHELwuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by PH7PR11MB6953.namprd11.prod.outlook.com (2603:10b6:510:204::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Tue, 13 Sep
 2022 03:18:59 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::25be:c4fc:f59b:8dd9]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::25be:c4fc:f59b:8dd9%6]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 03:18:59 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "tsahu@linux.ibm.com" <tsahu@linux.ibm.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "aneesh.kumar@linux.ibm.com"
	<aneesh.kumar@linux.ibm.com>, "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>,
	"vaibhav@linux.ibm.com" <vaibhav@linux.ibm.com>
Subject: Re: [PATCH v4 0/2]ndctl/namespace: Fix and improve write-infoblock
Thread-Topic: [PATCH v4 0/2]ndctl/namespace: Fix and improve write-infoblock
Thread-Index: AQHYcbTSPS01K+q/BUOL+h5QT7Hb9q3dW7YA
Date: Tue, 13 Sep 2022 03:18:59 +0000
Message-ID: <0ac88f93980f0da33939178abb16aab0a9d907cc.camel@intel.com>
References: <20220527103021.452651-1-tsahu@linux.ibm.com>
In-Reply-To: <20220527103021.452651-1-tsahu@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|PH7PR11MB6953:EE_
x-ms-office365-filtering-correlation-id: 3741b260-47b4-431e-35d7-08da9536b35f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iLsITX2JRys6Jc7QVW9mGhjYomHkLK0DuZ26KMtSFv8JflnhEgG1oYk+0O4AzIRJEDGOdY7jWZQLE8dkHhJjvvXWlQSwCyTVFi6+SVral8z56y7B2gCtLhTiPlT78xJJ8vtsnRA5aO+ITAHq+1MzrcXeVt0TmS3Ku6kMvMnZ7Vkxj8fd6SkB26Um5E4I8IbEeP4+y5KVKxzAjxpYIocGwL6muCIOpEUy0xH8B7xLf8A/13QtqHW+lTsIOU+VgZ4ILllbtUzx0PNo8op3OzhrzRu5rTklBqYdbk4zMAG3iR1m//S6+w7nedOA8E8QBnPeVOiW99scG7OwBnYIkp7iLAPqQ12ChML+PLtmpxmtEDGRu9M9Q7MRaWZ7Z60BQQDc4234EJm+yLBHFCJn4smsYuhf9ALHCKUg7lxDw6NCgMNkW0tStcpct/cDg9Y0AQw5p0zBAhjw0uqv7DtRXxgYZr2ivMpvYBsPjs0X2Ekn60WKnH6ZHtwik5ezNjMhSmF4no9ZvhU9IGSULuNuHPe/0R+mBwF/Wd7t565zgZ/krD3M2Ebm4xvX6pkz2lregYO1JuruVwV6anvX9ALZs/w+E/SGTnJyrgT6bvuwQtQTvpaCDdcoAliXYIkiAGZRVqt0bv+xWSGPe8gDsXeT4cBimKeEAlP5X5/HqSYUTcNg72JW0/5I/+D/E8J2n0JdowyPIz+BkjaORPt9CSHi8BlGoeKppCEk5kFPpcLJrpS7iRxq92TH8XkxYTS2vn8QkldZT521bcENLO9yScdD8AGxFA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199015)(36756003)(91956017)(76116006)(4326008)(6512007)(82960400001)(38070700005)(66946007)(5660300002)(6486002)(122000001)(478600001)(2616005)(64756008)(66556008)(54906003)(186003)(66446008)(71200400001)(83380400001)(66476007)(26005)(2906002)(6506007)(8676002)(86362001)(110136005)(38100700002)(8936002)(316002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3Bzb3BwdG9lRHdUcmR6SUNrMHRUVHJKQWxxSHhZaGFkZXBVZUd3U01zSXIr?=
 =?utf-8?B?azlrUEZFelJBcVM3RENNclVoNDhlWXdreVQ5RmZGeHkrYVQ5aXdUUGI2YXZE?=
 =?utf-8?B?ZGNRbmt1Qy9mbkpUbTgzTFNvTlovdG1oM3pVWVB2UVhYdHVaVkVwcHZpWWdD?=
 =?utf-8?B?Yk5nWXRzOGJjT3dsMm85YkY2SlV1emRaeStYbExISjBqWnNibVpNZVkralpL?=
 =?utf-8?B?ZFdhbjdVclR1U0dSUnNYSnBzL2lIcVNTU0kzcm5qUXM5eDd1R3BucldLVXo4?=
 =?utf-8?B?U2hwdHJKOUQvK2JNcEd3dDJZdTZTY2hGc1hGZDgvTklMME93aTZNM1ExWHBl?=
 =?utf-8?B?K2RNSFNaMC9yNGpjblVLTXZkVGVsRnFkb0lYZy9MZlpBdHRyZVphU09ma2tq?=
 =?utf-8?B?UWgyQnNYRERHdUs3UHZsSVc5d2I4dUtyQ1J1SzY0UlN5TlVqVjBhMEE5L1Y1?=
 =?utf-8?B?Z2MxL1dGa0Rmd05yajZsUW80QjArd3JkYTZ3TEFieVowQnc5Snp2dTl2YTc5?=
 =?utf-8?B?ZnJ5R3pBcGlhbHFYRjF0QU96RHU5NzFFNTE5bHdVV2QrWmhkWFNwNWNvK2Ur?=
 =?utf-8?B?WGxnL21xOWkxdkVPWGpNUGM1OGZnL2g4YmM3R2JUWmFISzR6cm1MRnFtSUlk?=
 =?utf-8?B?Vklza2lzTTBKYktpTEdTTldvRVFQbEhNRDVid1pyNHgwNXg1bnRVcEhsb1po?=
 =?utf-8?B?VTdwZFNkZTlWczdDWDVVOUFDQUZQdXpLcUJtR1R1d3QxMXczclNsOWIxMnJZ?=
 =?utf-8?B?R2ZDWGFRd3FjSTdvNFRrUE5SWHQzbmptM3JhWWdmQVByYmFWUmd2dEY0SjZl?=
 =?utf-8?B?NGpNZVZjTWJKMTI3UzUzR1p1OFJDTUVOcTRMaXJxK1NPRWJlTjdVTFdHb0Fj?=
 =?utf-8?B?L2VOdG4rRDBDSkNBMFVXKzd5czVIVG9NODZGQ2VxVC9xNGUxVFpGb2VqaHhv?=
 =?utf-8?B?TFpDSHVOWkRJc0VZNytRb1A0S3IrTEwyWVlwcFEwUXI3bWZuWE0zeTRBUllr?=
 =?utf-8?B?QXpGQ2pmUVMzWDEzU2hhWmYzaHBLYnptK1pUNUp1SWhaWFJNVHZYTnM5eUg5?=
 =?utf-8?B?WHhFYzFhVmgrc1FjZVNZTDRoNVFhcWdBN0lqY3lacldJQXB5QjVSVnFhS3B0?=
 =?utf-8?B?d2pORXg5clZ1WXlkbEprT0E4MnlVWDhjcHlOSy8zNEx0bzVGRWdJRXhnbUI5?=
 =?utf-8?B?ZzlRVlJIN3E5WSsxaTNKdEk3TnVTRXJUY1c5eElRUjdpdUorWnNwcUZPTE8x?=
 =?utf-8?B?c29RL2Y4YzRkVHh6OU8xK1BoOWJWSkdIaHV2K0dDeE9ncTE4NkFlZjRjdjlI?=
 =?utf-8?B?Q3E4clowYk9IYzhjTFBrZzgydHV3OVlsSVdzR2pFeVlTVGJqV2ZoZ1F3N2xZ?=
 =?utf-8?B?NVZqVlRmVFU4d2FSbzV1Q1pmeDFjUm03cXErbTRKUDVzVEMxbGNCbnphU3Qy?=
 =?utf-8?B?RkVUUUhEdGo4Q01yM1NJdFFaUXNJbmlEZ3FrSy8vRVNKYlVhTTJaMmVGQlRv?=
 =?utf-8?B?a0JsOXhoNGxDNTRSc250MU96eGhIWWJ4NlVGVVlmclpsR2dPV0U2Q3hoWDZJ?=
 =?utf-8?B?SzQrNE1CcGhva2RPZWk3UzZXNGhBcElUb2lvS25uU3VYL0NaQ1hNWnBjc2JS?=
 =?utf-8?B?NHF4V0N1U1dJWGtoeC9yaUNhT2ZUOWdLQlNDdVU0eldUZUJqTVltNXFlUjVF?=
 =?utf-8?B?WncxK3k3SFBaT1VKVjJUT2dtNkdPUVkxSDBib2NERUQ0bG9uS0FNVFVXam13?=
 =?utf-8?B?VE9kbFNQNnU0UFNCTVVuRmtCMlkwaWlSdmVFSXp4cDRkcGdGVWgxeTl2SGgv?=
 =?utf-8?B?ejR4LzdMblNUcnBneHZCL2g4ZmwxdzNtSUx4QXR5N3c3V0doUGhndmw3VTRB?=
 =?utf-8?B?NGF5Z1ppZUxFUmJaT1N1M29IdnIrbkx4U3laRm95S3ZYeDhxRGlxcFg1MkZW?=
 =?utf-8?B?YUxiSldyR3RDdG5ndk9wMXROektrSmp0STZLK1VDWWhFd2F2eHNFQXA5ZU5l?=
 =?utf-8?B?N1JxK0h1RDNDbUFJaU8vMnlyaGNNR0x6dkhIa29MM2ViWEdyNk1jL212YndP?=
 =?utf-8?B?RlAwSkpiWWx0Qk1kNGQ2TEJMNGFyS1FQQkEwZFlrdmhUUUVsM0JBV1I4SHRD?=
 =?utf-8?B?b1cxdGJqbG5PSm5vT0VuQ2Npb243cFpRVjhOTjYyMU5CbGlRbEI4NEY3Mm1X?=
 =?utf-8?B?TlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B6CFA5992FF47F4892918567076576BF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3741b260-47b4-431e-35d7-08da9536b35f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 03:18:59.6324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rpUNV50i+bGtXEF+ejDJxAF3gsGKm0p4D3inWeMujVEU3jR9FeA5HnVrqjGEVGp5aFdlsMmJ6FX3+FDUUaiPTwGZQGLkHsZhBLGpvCVQMYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6953
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIyLTA1LTI3IGF0IDE2OjAwICswNTMwLCBUYXJ1biBTYWh1IHdyb3RlOg0KPiBU
aGlzIHNlcmllcyByZXNvbHZlcyBzb21lIGlzc3VlcyB3aXRoIHdyaXRlLWluZm9ibG9jayANCj4g
Y29tbWFuZCBhbmQgcHJvdmlkZSBzdXBwb3J0IHRvIHdyaXRlLWluZm9ibG9jayBmb3Igc2VjdG9y
IA0KPiBtb2RlIG5hbWVzcGFjZQ0KPiANCj4gd3JpdGUtaW5mb2Jsb2NrIGNvbW1hbmQgaGFzIGlz
c3VlcyByZWdhcmRpbmcgdXBkYXRpbmcgdGhlIA0KPiBhbGlnbiwgdXVpZCwgcGFyZW50X3V1aWQu
IEluIGNhc2Ugb2Ygbm8gcGFyYW1ldGVyIHBhc3NlZCANCj4gZm9yIGl0LCB0aGlzIGNvbW1hbmQg
dXNlZCB0byBvdmVyd3JpdGUgdGhlIGV4aXN0aW5nIHZhbHVlcyANCj4gd2l0aCBkZWZhdWx0cy4N
Cj4gDQo+IEluIFBBVENIIDEvMiB0aGVzZSBwYXJhbWV0ZXJzIHdpbGwgYmUgc2V0IHRvIHRoZWly
IG9yaWdpbmFsIA0KPiB2YWx1ZXMsIGluY2FzZSwgdmFsdWVzIGhhc24ndCBiZWVuIHBhc3NlZCBp
biBjb21tYW5kIA0KPiBhcmd1bWVudHMNCj4gDQo+IHdyaXRlLWluZm9ibG9jayBjb21tYW5kIGRv
ZXNuJ3QgaGF2ZSBzdXBwb3J0IGZvciBzZWN0b3IvQlRUIA0KPiBtb2RlIG5hbWVzcGFjZXMuIFRo
ZXkgY2FuIGJlIGNvbnZlcnRlZCB0byBmc2RheCwgYnV0IGNhbiANCj4gbm90IGJlIHdyaXR0ZW4g
YmVpbmcgaW4gc2VjdG9yIG1vZGUuDQo+IA0KPiBJbiBQQVRDSCAyLzIsIEl0IGNyZWF0ZXMgYSBm
dW5jdGlvbmFsaXR5IHdoaWNoIHdyaXRlIA0KPiBpbmZvYmxvY2sgb2YgU2VjdG9yL0JUVCBuYW1l
c3BhY2UuIEN1cnJlbnRseSBvbmx5IHV1aWQsIA0KPiBwYXJlbnRfdXVpZCBjYW4gYmUgdXBkYXRl
ZC4gSW4gZnV0dXJlLCBTdXBwb3J0IGZvciBvdGhlciANCj4gcGFyYW1ldGVycyBjYW4gZWFzaWx5
IGJlIGludGVncmF0ZWQgaW4gdGhlDQo+IGZ1bmN0aW9uYWxpdHkuDQoNCkhpIFRhcnVuLA0KDQpT
b3JyeSBmb3IgdGhlIGRlbGF5IGluIHJldmlld2luZyB0aGVzZS4gRnJvbSBhIHF1aWNrIGxvb2ss
IGl0IGxvb2tzDQpsaWtlIHlvdSdyZSBhZGRpbmcgcmVhZC1tb2RpZnktd3JpdGUgZnVuY3Rpb25h
bGl0eSB0byB0aGUgd3JpdGUtDQppbmZvYmxvY2sgY29tbWFuZCAtIGlzIHRoYXQgY29ycmVjdD8N
Cg0KSSB0aGluayB0aGUgb3JpZ2luYWwgaW50ZW50IG9mIHRoZXNlIGNvbW1hbmRzIHdhcywgcHVy
ZWx5IGFzIGENCmRlYnVnL3Rlc3QgYWlkLCB0aGF0IHRoZSB1c2VyIHdvdWxkIGJlIHJlc3BvbnNp
YmxlIGZvciByZWFkaW5nIHRoZQ0KbmFtZXNwYWNlIGlmIG5lZWRlZCwgYW5kIHVzaW5nIHRoYXQg
YXMgYSBiYXNpcyBmb3Igd3JpdGluZyB0aGUNCmluZm9ibG9ja2wgaWYgYW4gUk1XIG9wZXJhdGlv
biBpcyBkZXNpcmVkLiBIb3dldmVyIGZvciB0aGUgbW9zdCBwYXJ0LA0Kd3JpdGUtaW5mb2Jsb2Nr
IGp1c3QgY3JlYXRlcyBpbmZvYmxvY2tzIG91dCBvZiB0aGluIGFpciwgYW5kIG9wdGlvbmFsbHkN
CndyaXRlcyBpdCB0byBhIG5hbWVwc3BhY2UuIEknbSBub3Qgc3VyZSBhZGRpbmcgYSByZWFkLW1v
ZGlmeS13cml0ZSBoZXJlDQppcyByZWFsbHkgdGhhdCB1c2VmdWwsIHVubGVzcyB5b3UgaGF2ZSBh
IHNwZWNpZmljIHVzZSBjYXNlIGZvciB0aGlzDQpzb3J0IG9mIHRoaW5nPw0KDQo+IA0KPiAtLS0N
Cj4gdjI6DQo+IMKgIFVwZGF0ZWQgdGhlIGNvbW1pdCBtZXNzYWdlIChyZXBocmFzaW5nKSBpbiBw
YXRjaCAxLzINCj4gwqAgTW92ZWQgdGhlIG5zX2luZm8gc3RydWN0IHRvIG5hbWVzcGFjZS5jIGZy
b20gbmFtZXNwYWNlLmgNCj4gwqAgcHV0IHRoZSByZXN1bHRzIGFmdGVyIC0tLSB0byBhdm9pZCBs
b25nIGNvbW1pdCBtZXNzYWdlDQo+IA0KPiB2MzoNCj4gwqAgcmVmb3JtYXQgdGhlIGNvbW1pdCBt
ZXNzYWdlIHRvIG1lZXQgMTAwIGNvbHVtbiBjb25kaXRpb24NCj4gDQo+IHY0Og0KPiDCoCAtIE1v
dmVkIHRoZSBzdHJ1Y3QgbnNfaW5mbyBkZWZpbml0aW9uIHRvIHRoZSBiZWdpbm5pbmcgb2YNCj4g
wqAgdGhlIGJsb2NrIA0KPiDCoCAtIEluaXRpYWxpemVkIHRoZSBidWYgb2YgbnNfaW5mbyBzdHJ1
Y3R1cmUgaW4gbnNfaW5mb19pbml0DQo+IMKgIC0gQ2hhbmdlIHRoZSBmb3JtYXQgb2YgY29tbWVu
dCBpbiBjb2RlIGZyb20gIi8vIiB0byAiLyoqLyINCj4gwqAgLSByZXdvcmQgdGhlIGNvbW1pdCBt
ZXNzYWdlIG9mIHBhdGNoIDIvMg0KPiANCj4gVGFydW4gU2FodSAoMik6DQo+IMKgIG5kY3RsL25h
bWVzcGFjZTogRml4IG11bHRpcGxlIGlzc3VlcyB3aXRoIHdyaXRlLWluZm9ibG9jaw0KPiDCoCBu
ZGN0bC9uYW1lc3BhY2U6IEltcGxlbWVudCB3cml0ZS1pbmZvYmxvY2sgZm9yIHNlY3RvciBtb2Rl
DQo+IG5hbWVzcGFjZXMNCj4gDQo+IMKgbmRjdGwvbmFtZXNwYWNlLmMgfCAzMTQgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0NCj4gLS0NCj4gwqAxIGZpbGUgY2hh
bmdlZCwgMjMxIGluc2VydGlvbnMoKyksIDgzIGRlbGV0aW9ucygtKQ0KPiANCg0K
