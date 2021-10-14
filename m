Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249E02C83
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 23:42:17 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="251255494"
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="251255494"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 16:42:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="442317039"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga006.jf.intel.com with ESMTP; 14 Oct 2021 16:42:14 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 16:42:13 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 16:42:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 16:42:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZuTF9ml+E3nksO4bSUGwCgsjibGhBUWBAs2wWegeVaA42sBY16Cs1kM5O2ZfmQWgwnFbAh2dts4BLRrsn8n7sz/GVel/kvu3fiF6Vohxz9f5C/zZQhgTXg7KqA3aNVDH3GHjyQch5oHh23o4mAIS/umGdMcNKrgtsUXpoWi4Unkn4tILjrloenn9U0Rmcgs2I5n5Qys8ElGffa+d/dCvGb/mX9Go5maqlL3zQa5ezsD2Xk+0tIz71t+qoCZC3EUr/9nIjgpI5ki+LO/Rov+u0rgcDcPNKp57vYdhZ8l9/91IiZaB8NGykiIoOvZ1QdbIhoZ5rNhLUOzHAarKJlTTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UKEruJoh9zNz8rq5KdnQ/BDVMa0EIi4R6/FQPWtoHk=;
 b=NCTdVob9Zbjjsh4pewyGEiNCv7JJM5HQaoItdX3yhcICcx5yqFe16lnGiZINudwO7ckwCXpFp7Rfi5KriUhRUo8NQyb8fSTKtjIuTuiXaKjeAsFa5Ry8WvdzHnrmtql/sWcpBTZn0LHe5jW/z9dDLAtymI3MusJFNDzTKiJ1ZJ6Yd+UWN9zaaZEvEXxsGYzcdu1lL4EcN7731e5h1if7eUfTvcYynzpLB6DD/d9JiE1diFxLtJIkF+/S7SmqTdMiGmQ2mH0NDNmWzfaf24kRYS5YitWwL0XVJXUD7Mwbe+QMEB5/P5JFDLDnBUX6JtCvvxOkQ7UI7TFvmd0zQiWNWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UKEruJoh9zNz8rq5KdnQ/BDVMa0EIi4R6/FQPWtoHk=;
 b=uHzRQw0mC36LopPKLK8fyCcekgO0GNk3ncGuuPW/P+Lo3cf/fi+Lyr+B4gphqVbJo+aY/3/VqLKL9ZW45ohaIdL3wzmop2viZ1IEVjAbFbJI5W7dwR59O+ZKPY3A+7B2P+Jkm+y5STFfJf4o7/wynBTd3ZFh2Z2Fe5yf+oh3jRA=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB3661.namprd11.prod.outlook.com (2603:10b6:208:f0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 23:42:11 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 23:42:11 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Widawsky, Ben"
	<ben.widawsky@intel.com>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v4 17/17] cxl: add health information to cxl-list
Thread-Topic: [ndctl PATCH v4 17/17] cxl: add health information to cxl-list
Thread-Index: AQHXu1Rpl5ks0eSAW02s2S2kPdlO/qvTM4oA
Date: Thu, 14 Oct 2021 23:42:10 +0000
Message-ID: <d20b7fd17067aa49a5ccdd2c649f345ab17cb12e.camel@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
	 <20211007082139.3088615-18-vishal.l.verma@intel.com>
In-Reply-To: <20211007082139.3088615-18-vishal.l.verma@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05f51502-1b76-4c88-c5f0-08d98f6c3e1f
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3661983DF5B62C00FFE6EDA1C7B89@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:561;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PPHxU0YJpiUghgFdzJv2b8oMfatZz3bYy0wkqdRB+0/rw5c/hoqnKig+GSerC5/SIGaIJhMQu4iMhghBFClPmhlfiq42yH+9/WvFxC+NCOPMexy6z8WV020M5TY7mqLsxMRCmeGpUsGdz96U/b+GcsTvsC9NgEfWntmJZHi7oqeYDPGK4CIZm0YAl3qa9STmU0IJQXbRiCA5kSvQbIqQasDezmTP+TIu3eWTvIbSPhnw8dJiMcuvsbrlxqYFpEaja8N5jAIFCl8ty0kdHtWJ9bWbMFFSezsh6fc23u3PlKhGyUt2v6c6ty546RUBIpyTBOMczvge0hbF1VU0MfsvZWCbb3Lg8EIz98LCJyvND6xbmeqF/PDgoUplgMDzJdRLkSoa1ULBFVAljl2/i9zp/0q3Qa5MhayvBMDKza53MLuR0bIv06WmkweiTvx2FeLXbzq8d4EV21MOyhCfXmz70qzEz3mn8usKJZlS6FCdq+j6uEWQhHk6eePpUT4P2uEFkieF3fAoNe39l5S10wnD0uz9rawXVUcgQ8zGyPHOCNl8i6HPUTlwovRKz8F8EFb9LaPo8lubMrJbmFReFE1yn93kFIoh5+gtKMHodas12LmgbHpcYI/2RKPvBXa0IdfhsagqsFeyb1k09i6nGzuMMe8glFjVF7MWt+gMH7qVLr384j0rnD/D7ctqSZnL+B+guHGh/B4Nj5RaAPgYrVK0Ow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(122000001)(83380400001)(6506007)(5660300002)(26005)(6512007)(6486002)(38070700005)(186003)(71200400001)(2616005)(8936002)(66946007)(2906002)(508600001)(8676002)(316002)(91956017)(66476007)(4326008)(66446008)(66556008)(54906003)(64756008)(76116006)(82960400001)(36756003)(6916009)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VnJEbXova2hpcGFGa3l1bWNzMEJBQ3EyMmJqSHJ6MHBYVjhNZmsrZDVFWmxu?=
 =?utf-8?B?ckxSdzVGcnFXZFk4SjhaWlIxbEwvUmJmSm9kTHNKbkliMTV5TURWUHdSREZq?=
 =?utf-8?B?QU11Zy9FVWdzRldpcSsyRU1OaHdOcDdXWm1PQ01VMFprM2hrWGljRVIzRFVY?=
 =?utf-8?B?MEdWajVHUXRwc2RJRkU0UHllSVZoU2t3N0pZWURTaXJ4Z0RLbmVOd3AzWmNS?=
 =?utf-8?B?cDJ5S1Njd0tUMkczVmRZRjY0bndMVENlS0IwTUYvZXI0ZjNaVWtXZG8xZ0xl?=
 =?utf-8?B?UGR5TzE1V2JKdmE1aW1WeUd0K0Nzb1RiRjdEMytTQ0loZGlNbE9lUE1PaVpl?=
 =?utf-8?B?bG83eVZYazZRL21ZSjFtV1RWeWY1TDQxcWtjRVc3RmVRc0ZCN2NVbWNJMXkr?=
 =?utf-8?B?QXY2THRQajBYeHJvdjJaM3lVcnZCcTNSWDduQUFKbGJmSjlaNnNWUmErZFIv?=
 =?utf-8?B?a1A4d05SZmlDZlc4SFNrdWVyNXRmSGNGMElZR0VwMGRWQnRNZWw1WUI2WUNI?=
 =?utf-8?B?V0E0OStDZ1RaUVpwRzVvTVBjVml6bXU0M2RkU0lnWGpnTloxOW00d1J1a3VL?=
 =?utf-8?B?RXBPOVdCWGRWczF0YkJyMFNKanRSN3o2UUtoRTRmUFo0cDIwNmQ5bG9OWGJ0?=
 =?utf-8?B?QTRpVlBaZ3RkZU1OdkNYSHlZcUM2YytVZ0hqVzJGKzBvTE1mOXZ3ZEhqdHdL?=
 =?utf-8?B?aXB2dWlmSnA5WEhXcHFxMWkzbTVkYXNaQy9mNjc3RkNsRGpuZTUyTVpLaWlm?=
 =?utf-8?B?V1I3Wnp6am5FVHk4eHd5bEFxSHBkRU5PNzlsNWZDN3l0TEUyYnFoMlJsZlRG?=
 =?utf-8?B?eWVDYlpQckVJdmgxVmd0RWFlVFBQV3B5RjB1TEdwV1RpZDg0cmN2UGY2MFhz?=
 =?utf-8?B?QTJET1JDeDNnRmRQNzZ1aS9XQkhEdVZUa2lTNDhzNnVBN25Ia0NLdThwa0xv?=
 =?utf-8?B?TXpzQzV1MHMyNEtJS09pbjdOcmVOMXM0YTFWZ05MODRDdVZmemhMY0VWZEFG?=
 =?utf-8?B?VHRGalJjdGJtNHFUVXMxeWNpYm5UTEd4R1ZJbFFjZXY5V1AwMmNtV09Ld1p4?=
 =?utf-8?B?amRXYnk3Q3RsU01hRmhtQWJsQXV1TFpIM1RNSHRUUEt0VDBOUVNJQjVmRnM2?=
 =?utf-8?B?NDZzYUdrQ2NlUmQ1RmRzNjBOTWtDcHlEZWZYNG53VmhMOE1oUmJmV1hJeEh1?=
 =?utf-8?B?SjZ6aXo4YUh6aWVZemN2WWJDakFhcU1SVUFEUFdtUlV5VjRjTDY5NHQ0emxF?=
 =?utf-8?B?c2tnZFRjZ3lDQ3dmc2d1VTE0T3RCbDJtM1V3blNpTnRtWTNRUVVra3gxd1Ev?=
 =?utf-8?B?cW4yMXBoSjM4YXIrVVdaeW41WUlrb3o3eStNdnU3TGwyVjI2UVNVUWhXYTg2?=
 =?utf-8?B?clIwSGhVR3VyWEZnUmJ6NENabXE2QW9SSlR0QlBoNVl2VzZGLy9XZHJSUlg2?=
 =?utf-8?B?UW9USXE1M1laV1VnZzF0YmR6UWgzalM5djRlemdZSjZRK1FuYkRsUHQ2Rmtw?=
 =?utf-8?B?STl2bE9wT3kzRzVNbnh5ZW5XZXF0elhrV1NQcjV3YTRtSDBJRmpOcHg1K0dT?=
 =?utf-8?B?MWhZVm0zVzZXZVVoclkybDlJTE55SUxTQndBWS9FUjd5TUNObDFxWFRVS1lY?=
 =?utf-8?B?S0srQmRJNmVMdDRCMFdWcS9XQVlMelR4RHhTN1V6S1FQNjJQaWlWN3RzTHB4?=
 =?utf-8?B?NENJNTJVRi9oVnhJdnhaS0JPV2N6b3FEUGh3dGRMQXNsdjRwM1IrVUlwQ094?=
 =?utf-8?B?Vm94UFdWVUZhZ20xTEEra2cvTSszOU0zNkNnWjBJTFhYSUwyYnREL2RoMEdO?=
 =?utf-8?B?OXBycElHMGdOMS92L1ovZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DDF23564FD08BC42B4FC4677F0400F4C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f51502-1b76-4c88-c5f0-08d98f6c3e1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 23:42:10.9986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1y5AeZl2Qb6fwed0/dDdEDvpJFD8xTs7oPe5FSztik9k9fayNRxEiPOrqoWyiGmla1Chhr5FvYkiOkQ1WRYp12qJ5lZMxZNuQ48aEaBUyw0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTEwLTA3IGF0IDAyOjIxIC0wNjAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
IEFkZCBKU09OIG91dHB1dCBmb3IgZmllbGRzIGZyb20gdGhlICdHRVRfSEVBTFRIX0lORk8nIG1h
aWxib3ggY29tbWFuZA0KPiB0byBtZW1vcnkgZGV2aWNlIGxpc3RpbmdzLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQo+IC0tLQ0K
PiAgRG9jdW1lbnRhdGlvbi9jeGwvY3hsLWxpc3QudHh0IHwgICA0ICsNCj4gIHV0aWwvanNvbi5o
ICAgICAgICAgICAgICAgICAgICB8ICAgMSArDQo+ICBjeGwvbGlzdC5jICAgICAgICAgICAgICAg
ICAgICAgfCAgIDUgKw0KPiAgdXRpbC9qc29uLmMgICAgICAgICAgICAgICAgICAgIHwgMTg5ICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgNCBmaWxlcyBjaGFuZ2VkLCAxOTkg
aW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vY3hsL2N4bC1s
aXN0LnR4dCBiL0RvY3VtZW50YXRpb24vY3hsL2N4bC1saXN0LnR4dA0KPiBpbmRleCBiZDM3N2Iz
Li5kYzg2NjUxIDEwMDY0NA0KPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2N4bC9jeGwtbGlzdC50eHQN
Cj4gKysrIGIvRG9jdW1lbnRhdGlvbi9jeGwvY3hsLWxpc3QudHh0DQo+IEBAIC01Myw2ICs1Mywx
MCBAQCBPUFRJT05TDQo+ICAtLWlkbGU6Og0KPiAgCUluY2x1ZGUgaWRsZSAobm90IGVuYWJsZWQg
LyB6ZXJvLXNpemVkKSBkZXZpY2VzIGluIHRoZSBsaXN0aW5nDQo+ICANCj4gKy1IOjoNCj4gKy0t
aGVhbHRoOjoNCj4gKwlJbmNsdWRlIGhlYWx0aCBpbmZvcm1hdGlvbiBpbiB0aGUgbWVtZGV2IGxp
c3RpbmcNCj4gKw0KPiAgaW5jbHVkZTo6aHVtYW4tb3B0aW9uLnR4dFtdDQo+ICANCj4gIGluY2x1
ZGU6OnZlcmJvc2Utb3B0aW9uLnR4dFtdDQo+IGRpZmYgLS1naXQgYS91dGlsL2pzb24uaCBiL3V0
aWwvanNvbi5oDQo+IGluZGV4IDkxOTE4YzguLmNlNTc1ZTYgMTAwNjQ0DQo+IC0tLSBhL3V0aWwv
anNvbi5oDQo+ICsrKyBiL3V0aWwvanNvbi5oDQo+IEBAIC0xOSw2ICsxOSw3IEBAIGVudW0gdXRp
bF9qc29uX2ZsYWdzIHsNCj4gIAlVVElMX0pTT05fQ09ORklHVVJFRAk9ICgxIDw8IDcpLA0KPiAg
CVVUSUxfSlNPTl9GSVJNV0FSRQk9ICgxIDw8IDgpLA0KPiAgCVVUSUxfSlNPTl9EQVhfTUFQUElO
R1MJPSAoMSA8PCA5KSwNCj4gKwlVVElMX0pTT05fSEVBTFRICT0gKDEgPDwgMTApLA0KPiAgfTsN
Cj4gIA0KPiAgc3RydWN0IGpzb25fb2JqZWN0Ow0KPiBkaWZmIC0tZ2l0IGEvY3hsL2xpc3QuYyBi
L2N4bC9saXN0LmMNCj4gaW5kZXggM2RlYTczZi4uMmZhMTU1YSAxMDA2NDQNCj4gLS0tIGEvY3hs
L2xpc3QuYw0KPiArKysgYi9jeGwvbGlzdC5jDQo+IEBAIC0xNiw2ICsxNiw3IEBAIHN0YXRpYyBz
dHJ1Y3Qgew0KPiAgCWJvb2wgbWVtZGV2czsNCj4gIAlib29sIGlkbGU7DQo+ICAJYm9vbCBodW1h
bjsNCj4gKwlib29sIGhlYWx0aDsNCj4gIH0gbGlzdDsNCj4gIA0KPiAgc3RhdGljIHVuc2lnbmVk
IGxvbmcgbGlzdG9wdHNfdG9fZmxhZ3Modm9pZCkNCj4gQEAgLTI2LDYgKzI3LDggQEAgc3RhdGlj
IHVuc2lnbmVkIGxvbmcgbGlzdG9wdHNfdG9fZmxhZ3Modm9pZCkNCj4gIAkJZmxhZ3MgfD0gVVRJ
TF9KU09OX0lETEU7DQo+ICAJaWYgKGxpc3QuaHVtYW4pDQo+ICAJCWZsYWdzIHw9IFVUSUxfSlNP
Tl9IVU1BTjsNCj4gKwlpZiAobGlzdC5oZWFsdGgpDQo+ICsJCWZsYWdzIHw9IFVUSUxfSlNPTl9I
RUFMVEg7DQo+ICAJcmV0dXJuIGZsYWdzOw0KPiAgfQ0KPiAgDQo+IEBAIC01Nyw2ICs2MCw4IEBA
IGludCBjbWRfbGlzdChpbnQgYXJnYywgY29uc3QgY2hhciAqKmFyZ3YsIHN0cnVjdCBjeGxfY3R4
ICpjdHgpDQo+ICAJCU9QVF9CT09MRUFOKCdpJywgImlkbGUiLCAmbGlzdC5pZGxlLCAiaW5jbHVk
ZSBpZGxlIGRldmljZXMiKSwNCj4gIAkJT1BUX0JPT0xFQU4oJ3UnLCAiaHVtYW4iLCAmbGlzdC5o
dW1hbiwNCj4gIAkJCQkidXNlIGh1bWFuIGZyaWVuZGx5IG51bWJlciBmb3JtYXRzICIpLA0KPiAr
CQlPUFRfQk9PTEVBTignSCcsICJoZWFsdGgiLCAmbGlzdC5oZWFsdGgsDQo+ICsJCQkJImluY2x1
ZGUgbWVtb3J5IGRldmljZSBoZWFsdGggaW5mb3JtYXRpb24gIiksDQo+ICAJCU9QVF9FTkQoKSwN
Cj4gIAl9Ow0KPiAgCWNvbnN0IGNoYXIgKiBjb25zdCB1W10gPSB7DQo+IGRpZmYgLS1naXQgYS91
dGlsL2pzb24uYyBiL3V0aWwvanNvbi5jDQo+IGluZGV4IDNiZTNhOTIuLmRmYzdiOGUgMTAwNjQ0
DQo+IC0tLSBhL3V0aWwvanNvbi5jDQo+ICsrKyBiL3V0aWwvanNvbi5jDQo+IEBAIC0xNDQyLDYg
KzE0NDIsMTkwIEBAIHN0cnVjdCBqc29uX29iamVjdCAqdXRpbF9iYWRibG9ja19yZWNfdG9fanNv
bih1NjQgYmxvY2ssIHU2NCBjb3VudCwNCj4gIAlyZXR1cm4gTlVMTDsNCj4gIH0NCj4gIA0KPiAr
c3RhdGljIHN0cnVjdCBqc29uX29iamVjdCAqdXRpbF9jeGxfbWVtZGV2X2hlYWx0aF90b19qc29u
KA0KPiArCQlzdHJ1Y3QgY3hsX21lbWRldiAqbWVtZGV2LCB1bnNpZ25lZCBsb25nIGZsYWdzKQ0K
PiArew0KPiArCWNvbnN0IGNoYXIgKmRldm5hbWUgPSBjeGxfbWVtZGV2X2dldF9kZXZuYW1lKG1l
bWRldik7DQo+ICsJc3RydWN0IGpzb25fb2JqZWN0ICpqaGVhbHRoOw0KPiArCXN0cnVjdCBqc29u
X29iamVjdCAqam9iajsNCj4gKwlzdHJ1Y3QgY3hsX2NtZCAqY21kOw0KPiArCXUzMiBmaWVsZDsN
Cj4gKwlpbnQgcmM7DQo+ICsNCj4gKwlqaGVhbHRoID0ganNvbl9vYmplY3RfbmV3X29iamVjdCgp
Ow0KPiArCWlmICghamhlYWx0aCkNCj4gKwkJcmV0dXJuIE5VTEw7DQo+ICsJaWYgKCFtZW1kZXYp
DQo+ICsJCWdvdG8gZXJyX2pvYmo7DQo+ICsNCj4gKwljbWQgPSBjeGxfY21kX25ld19nZXRfaGVh
bHRoX2luZm8obWVtZGV2KTsNCj4gKwlpZiAoIWNtZCkNCj4gKwkJZ290byBlcnJfam9iajsNCj4g
Kw0KPiArCXJjID0gY3hsX2NtZF9zdWJtaXQoY21kKTsNCj4gKwkvKiBFTk9UVFkgLSBjb21tYW5k
IG5vdCBzdXBwb3J0ZWQgYnkgdGhlIG1lbWRldiAqLw0KPiArCWlmIChyYyA9PSAtRU5PVFRZKQ0K
PiArCQlnb3RvIGVycl9jbWQ7DQoNCkknbGwgcmVtb3ZlIHRoaXMgc3BlY2lhbCBjYXNlLCBhcyB3
ZWxsIGFzIHRoZSBlcnJvciBwcmludHMgYmVsb3cuIFRoZQ0KY21kIHN1Ym1pc3Npb24gY291bGQg
ZmFpbCBmb3IgYW55IG51bWJlciBvZiByZWFzb25zLCBpbmNsdWRpbmcNCnVuc3VwcG9ydGVkIGJ5
IGhhcmR3YXJlIC0gSSB0aGluayBmb3IgYW55IG9mIHRob3NlIGNhc2VzLCB3ZSBjYW4ganVzdA0K
c2lsZW50bHkgc2tpcCBwcmludGluZyB0aGUganNvbiBmaWVsZHMgaGVyZS4NCg0KPiArCWlmIChy
YyA8IDApIHsNCj4gKwkJZnByaW50ZihzdGRlcnIsICIlczogY21kIHN1Ym1pc3Npb24gZmFpbGVk
OiAlc1xuIiwgZGV2bmFtZSwNCj4gKwkJICAgIHN0cmVycm9yKC1yYykpOw0KPiArCQlnb3RvIGVy
cl9jbWQ7DQo+ICsJfQ0KPiArCXJjID0gY3hsX2NtZF9nZXRfbWJveF9zdGF0dXMoY21kKTsNCj4g
KwlpZiAocmMgIT0gMCkgew0KPiArCQlmcHJpbnRmKHN0ZGVyciwgIiVzOiBmaXJtd2FyZSBzdGF0
dXM6ICVkXG4iLCBkZXZuYW1lLCByYyk7DQo+ICsJCXJjID0gLUVOWElPOw0KPiArCQlnb3RvIGVy
cl9jbWQ7DQo+ICsJfQ0KPiArDQo+IA0K
