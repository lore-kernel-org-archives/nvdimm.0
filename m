Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2013E7470
	for <nvdimm@lists.linux.dev>; Mon, 24 Apr 2023 23:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682378096; x=1713914096;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=85VEvYFl0Ffl0Pa28qDu6UkIR8GEIfQ0sco/BE5FBjA=;
  b=kKzYQBFUxfESCYW0fXEeI7CgE2QqzyQ1M2KhsCW6ruFSwuZra7WlR1cK
   vZlANcNfRvJfdIy9/AJL5E1ItT9ktOMRb7GWLn/B4uFLylgdP+NVxbexj
   EmFK2ErXRafeIWa+2FPubsCt8jv5xQprGbqqE5POCKJp7clfmjbB+OYn4
   y5XWe08M8vg1FbAi8NW6gD/FMlhhPOOjM1iJy8JwlzC0ftmToIBeSYp8p
   1OIK8PE5OR3trpwmanzfpLVbcTz0UqU0RuvuvapPC0fkiLTD/Wck0em1L
   4QhJNG/juF9c3HoQ7/IBaOnS+6Zbqlc8JnCaO3xDcdxYjCFa4bJ1B6yCm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="346606286"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="346606286"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 16:14:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="695934836"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="695934836"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 24 Apr 2023 16:14:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 16:14:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 24 Apr 2023 16:14:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 24 Apr 2023 16:14:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mssUFBJb9ZACsj7G5zvNfSqXWTCLTacanzjSFPh9VSWqz1w66MODdWY+89cMdygei0+Fdl50IR/LVueTF3fCX39PIblEoDle5RaLQLnFFFBOg1shnN+EdbIJTlvFiZVDm2j4oFQGsGzugr/QBk14Sk4JRvnPfTjtOdOMFzFRN1vcOPbomGn3cAAfY7T29ridttniZa6VJXKeeBIl4ccuv6I6UgP9Nw7vPk0aLFhvMIhzXg5rI/SpAx2eSogsUpTYT1QSMBaHA97plkCAO6ig8wbnUN5dFimBeAI3e3JTPMZNJ+oXD5aMK1rlr9H9sM6czyr5H8hh+zGonCw3q2APfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85VEvYFl0Ffl0Pa28qDu6UkIR8GEIfQ0sco/BE5FBjA=;
 b=BLMdqXIbHucJlFJj5SG6b0WKkpSFWVR1MDmE9jbr7PQ4AzhHsSQfDz6Hf1A3v4T2LKjXrnGGhnVfhdFVGDU7RKtOIEMdPi0piVi8aG9jQ2fbndWPgaoTiSWDTLtLhNEd7R+z9Q2v/MzwsGMYYJeRoP1oTONF9oKwzDQ8f9K8DU+lLX0HQj7zMA79sA36FhqYi8xPvvUaZimt45kArAho8676Wfwl/NiCpPXo+Y4zt/EVthBstwyT3ro6CiR7MwT3kVOenBoloD93GNNB2kp11APUC/WY0ifwq+iovRv3khfPss1nF9Y3uPbrd+gLLmSrYD4/Kecw0wGvLM4NmFhnLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by CH0PR11MB5442.namprd11.prod.outlook.com (2603:10b6:610:d1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 23:14:45 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::3403:36be:98a3:b532]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::3403:36be:98a3:b532%4]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 23:14:45 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [PATCH ndctl 4/5] cxl: add an update-firmware command
Thread-Topic: [PATCH ndctl 4/5] cxl: add an update-firmware command
Thread-Index: AQHZdMf4uwHhNsZWD0e8L8nvkYrU4687G4kA
Date: Mon, 24 Apr 2023 23:14:43 +0000
Message-ID: <2d2ddb4d0af46a97b6d7b4ee854976a0ebfc2c61.camel@intel.com>
References: <20230405-vv-fw_update-v1-0-722a7a5baea3@intel.com>
	 <20230405-vv-fw_update-v1-4-722a7a5baea3@intel.com>
In-Reply-To: <20230405-vv-fw_update-v1-4-722a7a5baea3@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.0 (3.48.0-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|CH0PR11MB5442:EE_
x-ms-office365-filtering-correlation-id: 31dd5c86-8dbb-4f55-5fc2-08db4519b080
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3uQ8DZ2A8QRq0Yv6PHAhPxQkxMWWVNJiGg1t3AUCZsBOIH2LhzodYTXfolBOhkbPtP8lcIdVh7hotPu/GoLIUG4sPWVO2QlTK8Clq0006cREO82+4NFg8eISbWziMZ68/iXxaz+3Puq5Ls/+Sw3w0frHE3xUQMx1vTM2L2YpaoNyr66q72rcmUSzSM75O2EISFlgIPRkjpO3qUIFYQbgzVRzfWGwq7v2wrNpOVqftw6FapB2zWlpl/UHngjCk5Q0fruHaKFZATxkRQGyVrueDHlXAD7T/YEGJr6s+wJzOOBHTn+8fK3gWj8gHVkVD6iwjK64kXx/w81Fg+rL/zaY8l/JvJhpT7v762Wj7McuhiNU1Zu8tq/e9kY1nm1OqPq5lEBW1f86aGLxS4sdknKWCIWHxHkc1xXKPp6bn16ssgbHMjKoG+7LXa43KsijqS2dK45SYFuq2PrlmFmVbJVUPCX0/Yi1olc4gxwrmPwfysgcIpV5BATGmPVJ/jtjO1a/npeyOYsfK5z2GW2ixRxVjSrd3T9sP/iZ8/JDPEY2+Qj3r40HAutQCDiyR54U+lqVLA7ezh1h2nK9CV7XsqIJeN8GNnYlupZgO5bLJgUJ5kww7RQxMx7RoPD85VFeiE95
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(396003)(376002)(366004)(346002)(451199021)(76116006)(91956017)(83380400001)(66946007)(2906002)(6506007)(6512007)(26005)(316002)(64756008)(66446008)(66476007)(66556008)(82960400001)(71200400001)(4326008)(6916009)(2616005)(8676002)(122000001)(41300700001)(15650500001)(38100700002)(5660300002)(8936002)(38070700005)(54906003)(86362001)(478600001)(107886003)(36756003)(186003)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHVKNzFBMmhuTVhNQi9yWFZCQk11a0NjL3ZxbGNBaG41aTdyK0xnT0lPZzgx?=
 =?utf-8?B?eVhWK3hnNVQrNGs3dzNJZjE4WVV2cTZDU0F5d3o0dUJidFFTNEdNNUFPRlBs?=
 =?utf-8?B?emRuWjl4ckJUQ1RScEdpaGlCOFlJZnpTZUgwK2tiWlRwd2N6ajhXYTVwQ3Fq?=
 =?utf-8?B?L3VmcnpwSWUxSVJHRHJkc3ByWjNPSklGaklxbmgxN2hXbVRNV29LZFVjaC9v?=
 =?utf-8?B?VFlXUXlpMXJJaitjL2ZWajNPMW4xcmk4b2VUdTY3a0taVWRXSGo1ZStOOGdn?=
 =?utf-8?B?WmZrc0p0Rkk4UjNIeUlXY0tmUWI1blJVc0VtOWVFV1puZVN0TERZRHVFZUhT?=
 =?utf-8?B?QjhXYnRoemhLbWlOMmFacVhFaThlSXJwb0VCTUZDOCtId3Nyb0pGZlhmMXRG?=
 =?utf-8?B?aHNnK2dUUk1POU5odWEwd0dMMzdTZ3AvaVAycGROb2c0cHgwNWovUzQrUFpk?=
 =?utf-8?B?OHRtb3JWNHRWbktxVVQ3eDBzL1BCZTVpbys5TTFsT0ZoOExLR3lVbldVbGJw?=
 =?utf-8?B?R3Z1NjBnR2NKb0kzTXBVWXJiZHdZeE85QVJPWGdOdlJTaEhQamd0TWhJZzhP?=
 =?utf-8?B?YzhLeDgrd2YyM2NQYlFobm9QVFdPcDZlOWhjSkFsU1VVd1FKT01DWkNreE1z?=
 =?utf-8?B?c3FFenpVRm95dW1tb2w1Z3h6b0g2Y2c3dmFNYkxOejVIVW9lSkNOVUJURlVZ?=
 =?utf-8?B?Rzhaa3A2QUZwaTFOaUxPbmx0S1ZtNkpkeFg4d08zaEt2ZklmNHI1TkxnSE1v?=
 =?utf-8?B?L0M2eG5pMlJTVVM2SVpaLzVJTlk5V2dURnMwSC9YSHlBbEcrR0JuT3NSZjlW?=
 =?utf-8?B?N2FoQW9yb0hZWmVJMFlDaHRFWlN2NW5VOFRDejJsbWFrci9CRU52ZGpQSCtl?=
 =?utf-8?B?alhORUFFYnh4dGlHMjh5ZDVjZ2lKb2YrL1AvWHBmalMzWlV0UGRNSUg1U0tl?=
 =?utf-8?B?SFUvR01kNWJYRXFWQitxTHhjR09hZERuajMwOG5BcXNKeHFzUUdyQ2xlb2JV?=
 =?utf-8?B?QlUwTkViOXBzU1JsVy9RRDN1dFYrTERuUTl3T2N0bm9xdm40RUF3N1lZTnB2?=
 =?utf-8?B?UXFEOHpXSnZGa0tmc3phcE5NUFpVK0F3aEFUZDJEaS92dkNyWUM3NHAvbVdt?=
 =?utf-8?B?bnorMXhVS3JJcGh0b3FHQ3NtbXVzMk04SU5sODlrQnhOb3pkWE1ETVRxNWxK?=
 =?utf-8?B?ekpHYVIyS0gwSXFzb3ovbVZTRE1SUTEySE1CM2dFZ0F1OVE0YTFMS0tFUEw1?=
 =?utf-8?B?YWJyVEVzbVJGU3lId0ZQd3lwOExCc1B3MkFCRi8zanpBMVhDcE8relo5dm1Y?=
 =?utf-8?B?aUU2SXlLbGNsUzBXaWVDeVo3SC9jeWxmdCtGSVFscDhabFZWdmZtZW43OVl0?=
 =?utf-8?B?VEdwMGs0a21iWkVDZmlWeEY1NkxyM2lnOVVaaWhZQ3Q3dS90Rk5IMXVSV0xV?=
 =?utf-8?B?Q24rOU45SE04VStUSDFwdTBUa243K1Fqd2hBNXhKU0MzVkdIaVBQTGxrcElv?=
 =?utf-8?B?R29OY0dyRCthSWgrQ1Yzc2g3MVBCbUFPMnhMMTNscXk0amNOb1FkcEtqZzd5?=
 =?utf-8?B?MGd4c1VtNS9xcmxUaFlLNktlZHJtNFlCVCtkR21zMW0zU3VwTWdDUVRINitL?=
 =?utf-8?B?dkpvS2dJUjRyMDRpZ2VlNjJUbkZPUGdzOElkVVdGNGZaR2ZPYStMa0JhY21z?=
 =?utf-8?B?c2RLN2lJc0pzZ0xHcmRkMCtsSmpzVkVWSnJLa2dLVzVyNmRnMFZpR0NkSU41?=
 =?utf-8?B?ekl3UDcwTFpjVHEyRVJGKytEMStHUlZhQWpQVFRKZlFudHpFVUI2TTdGS1Vq?=
 =?utf-8?B?UFAzTnA1V2x0WEVYaG9BajdNTFNFRWUxZElodWpyQi9mSVQyb0NrLzN5RHRP?=
 =?utf-8?B?ZlQrSVFxd2cxa2RBU3ZCSmNXZllvdDNuOU5kdkNRMllBTjZnQVZ3dHlPRVhF?=
 =?utf-8?B?TGtETVFGV0lFU2VJTThvV081MHRCS0ZqTXFFTjZIaEVOdDlUS29veDh0L1Vt?=
 =?utf-8?B?dFNYdDdRbkU0cDJWZk9SV0pDQit1Ym5jZis4TXh6K0h5YXczd0FVb0p5YTZM?=
 =?utf-8?B?YjFIbGh5MGY5ajJuYjA0Qzd6eUdKWENxTGpPRFBwejA2L21wOXo0amxPMlY2?=
 =?utf-8?B?RXhvODZTRUFoZCs5TytoSTdlNTBva0Z0bUdxc2x5QTFHOC9PYVNyM2E1YzVI?=
 =?utf-8?B?Umc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <097B98076DFE2648BBE373908CC78CFE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31dd5c86-8dbb-4f55-5fc2-08db4519b080
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2023 23:14:44.0625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gdnbcarlpiB0dT+wsj0xQSnamic1eLc4FzGcHD/VcKHRoK4ddWF03HGl15PNCh7HFX2HxwAPq6o+8mpGB/3HtV5YZelrYTO5QwLF5WGRrM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5442
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDIzLTA0LTIxIGF0IDIxOjEwIC0wNjAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
IEFkZCBhIG5ldyBjeGwtdXBkYXRlLWZpcm13YXJlIGNvbW1hbmQgdG8gaW5pdGlhdGUgYSBmaXJt
d2FyZSB1cGRhdGUgb24gYQ0KPiBnaXZlbiBtZW1kZXYuIFRoaXMgYWxsb3dzIHVzaW5nIGEgc3Bl
Y2lmaWVkIGZpbGUgdG8gcGFzcyBpbiBhcyB0aGUNCj4gZmlybXdhcmUgYmluYXJ5IGZvciBvbmUg
b3IgbW9yZSBtZW1kZXZzLCBhbGxvd3MgZm9yIGEgYmxvY2tpbmcgbW9kZSwNCj4gd2hlcmUgdGhl
IGNvbW1hbmQgb25seSBleGl0cyBhZnRlciB0aGUgdXBkYXRlIGlzIGNvbXBsZXRlIGZvciBldmVy
eQ0KPiBzcGVjaWZpZWQgbWVtZGV2LCBhbmQgaW5jbHVkZXMgYW4gb3B0aW9uIHRvIGNhbmNlbCBh
biBpbi1wcm9ncmVzcw0KPiB1cGRhdGUuIEFkZCB0aGUgc3VwcG9ydGluZyBsaWJjeGwgQVBJcyBm
b3IgdGhlIGFib3ZlIGZ1bmN0aW9ucyBhcyB3ZWxsLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVmlz
aGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+DQo+IC0tLQ0KPiDCoGN4bC9saWIv
cHJpdmF0ZS5owqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgIDUgKysNCj4gwqBjeGwvbGli
L2xpYmN4bC5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfCAxMTQgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+IMKgY3hsL2J1aWx0aW4uaMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgIDEgKw0KPiDCoGN4bC9saWJjeGwuaMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAgMiArDQo+IMKgY3hsL2N4bC5jwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqDCoCAxICsNCj4gwqBjeGwvbWVt
ZGV2LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCA3MyArKysrKysrKysr
KysrKysrKysrKysrKysrKy0NCj4gwqBEb2N1bWVudGF0aW9uL2N4bC9tZXNvbi5idWlsZCB8wqDC
oCAxICsNCj4gwqBjeGwvbGliL2xpYmN4bC5zeW3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKg
IDIgKw0KPiDCoDggZmlsZXMgY2hhbmdlZCwgMTk4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkNCj4gDQpMb29rcyBsaWtlIEkgZm9yZ290IHRvICdnaXQgYWRkIERvY3VtZW50YXRpb24vY3hs
L2N4bC11cGRhdGUtZmlybXdhcmUudHh0Jy4NCkknbGwgZml4IGl0IGZvciB2MiwgYnV0IGluIHRo
ZSBtZWFud2hpbGUgaGVyZSdzIHdoYXQgdGhhdCBsb29rcyBsaWtlOg0KDQoNCi8vIFNQRFgtTGlj
ZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wDQoNCmN4bC11cGRhdGUtZmlybXdhcmUoMSkNCj09PT09
PT09PT09PT09PT09PT09PT0NCg0KTkFNRQ0KLS0tLQ0KY3hsLXVwZGF0ZS1maXJtd2FyZSAtIHVw
ZGF0ZSB0aGUgZmlybXdhcmUgb24gYSBDWEwgbWVtZGV2DQoNClNZTk9QU0lTDQotLS0tLS0tLQ0K
W3ZlcnNlXQ0KJ2N4bCB1cGRhdGUtZmlybXdhcmUgPG1lbTA+IFs8bWVtMT4uLjxtZW1OPl0gWzxv
cHRpb25zPl0nDQoNCkRFU0NSSVBUSU9ODQotLS0tLS0tLS0tLQ0KDQpVcGRhdGUgdGhlIGZpcm13
YXJlIG9uIG9uZSBvciBtb3JlIENYTCBtZW0gZGV2aWNlcy4gVGhlIG1lbSBkZXZpY2VzDQptdXN0
IHN1cHBvcnQgdGhlIHNldCBvZiBmaXJtd2FyZSByZWxhdGVkIG1haWxib3ggY29tbWFuZHMuDQoN
ClRoaXMgY29tbWFuZCBkb2Vzbid0IGRpcmVjdGx5IGlzc3VlIHRoZSB0cmFuc2ZlciAvIGFjdGl2
YXRlIGZpcm13YXJlDQptYWlsYm94IGNvbW1hbmRzLiBJbnN0ZWFkLCB0aGUga2VybmVsJ3MgZmly
bXdhcmUgbG9hZGVyIGZhY2lsaXR5IGlzDQp1c2VkIHRvIHByb3ZpZGUgdGhlIGtlcm5lbCB3aXRo
IHRoZSBkYXRhLCBhbmQgdGhlIGtlcm5lbCBoYW5kbGVzDQpwZXJmb3JtaW5nIHRoZSBhY3R1YWwg
dXBkYXRlIHdoaWxlIGFsc28gbWFuYWdpbmcgdGltZSBzbGljaW5nIHRoZQ0KdHJhbnNmZXIgdy5y
LnQuIG90aGVyIGJhY2tncm91bmQgY29tbWFuZHMuDQoNCkVYQU1QTEUNCi0tLS0tLS0NCi0tLS0N
CiMgY3hsIHVwZGF0ZS1maXJtd2FyZSBtZW0wIC1GIGZpcm13YXJlLmJpbiAtdw0KWw0KICB7DQog
ICAgIm1lbWRldiI6Im1lbTAiLA0KICAgICJwbWVtX3NpemUiOjEwNzM3NDE4MjQsDQogICAgInJh
bV9zaXplIjoxMDczNzQxODI0LA0KICAgICJzZXJpYWwiOjAsDQogICAgIm51bWFfbm9kZSI6MCwN
CiAgICAiaG9zdCI6ImN4bF9tZW0uMCIsDQogICAgImZpcm13YXJlIjp7DQogICAgICAibnVtX3Ns
b3RzIjozLA0KICAgICAgImFjdGl2ZV9zbG90IjoyLA0KICAgICAgIm9ubGluZV9hY3RpdmF0ZV9j
YXBhYmxlIjpmYWxzZSwNCiAgICAgICJzbG90XzFfdmVyc2lvbiI6ImN4bF90ZXN0X2Z3XzAwMSIs
DQogICAgICAic2xvdF8yX3ZlcnNpb24iOiJjeGxfdGVzdF9md18wMDIiLA0KICAgICAgInNsb3Rf
M192ZXJzaW9uIjoiY3hsX3Rlc3RfbmV3X2Z3IiwNCiAgICAgICJmd191cGRhdGVfaW5fcHJvZ3Jl
c3MiOmZhbHNlDQogICAgfQ0KICB9DQpdDQpmaXJtd2FyZSB1cGRhdGUgY29tcGxldGVkIG9uIDEg
bWVtIGRldmljZQ0KLS0tLQ0KDQpPUFRJT05TDQotLS0tLS0tDQoNCmluY2x1ZGU6OmJ1cy1vcHRp
b24udHh0W10NCg0KLUY6Og0KLS1maXJtd2FyZS1maWxlOjoNCglGaXJtd2FyZSBpbWFnZSBmaWxl
IHRvIHVzZSBmb3IgdGhlIHVwZGF0ZS4NCg0KLWM6Og0KLS1jYW5jZWw6Og0KCUF0dGVtcHQgdG8g
YWJvcnQgYW4gaW4tcHJvZ3Jlc3MgZmlybXdhcmUgdXBkYXRlLiBUaGlzIG1heQ0KCWZhaWwgZGVw
ZW5kaW5nIG9uIHdoYXQgc3RhZ2UgdGhlIHVwZGF0ZSBwcm9jZXNzIGlzIGluLg0KDQotdzo6DQot
LXdhaXQ6Og0KCUJ5IGRlZmF1bHQsIHRoZSB1cGRhdGUtZmlybXdhcmUgY29tbWFuZCBvbmx5IGlu
aXRpYXRlcyB0aGUNCglmaXJtd2FyZSB1cGRhdGUsIGFuZCByZXR1cm5zLCB3aGlsZSB0aGUgdXBk
YXRlIG9wZXJhdGlvbg0KCWhhcHBlbnMgYXN5bmNocm9ub3VzbHkgaW4gdGhlIGJhY2tncm91bmQu
IFRoaXMgb3B0aW9uIG1ha2VzDQoJdGhlIGZpcm13YXJlIHVwZGF0ZSBjb21tYW5kIHN5bmNocm9u
b3VzIGJ5IHdhaXRpbmcgZm9yIGl0IHRvDQoJY29tcGxldGUgYmVmb3JlIHJldHVybmluZy4NCg0K
CUlmIC0td2FpdCBpcyBwYXNzZWQgaW4gd2l0aG91dCBhbiBhY2NvbXBhbnlpbmcgZmlybXdhcmUt
ZmlsZSwNCglpdCB3aWxsIGluaXRpYXRlIGEgd2FpdCBvbiBhbnkgY3VycmVudCBpbi1wcm9ncmVz
cyBmaXJtd2FyZQ0KCXVwZGF0ZXMsIGFuZCB0aGVuIHJldHVybi4NCg0KaW5jbHVkZTo6dmVyYm9z
ZS1vcHRpb24udHh0W10NCg0KaW5jbHVkZTo6Li4vY29weXJpZ2h0LnR4dFtdDQoNClNFRSBBTFNP
DQotLS0tLS0tLQ0KbGlua2N4bDpjeGwtbGlzdFsxXSwNCg==
