Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C2A2C81
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 21:50:40 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="227692147"
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="227692147"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 14:50:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,373,1624345200"; 
   d="scan'208";a="660151146"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 14 Oct 2021 14:50:37 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 14:50:35 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 14:50:35 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 14:50:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfnWgXclATqUddFMFyAZ9PD6cimuRxz9WUEly/xmB+4JUDPRaM3EXAXyCF3HadInpv2V2MeVN88+WDvLK+tzAEd6b4TLodxGw1VwBoGSfepIUDjM5+0xWvnHyHvzZlIBE0jL2c9+dPGF42Opc9QWaXeEtDrfTXQMDPUI3Y5NdjecZqskID48qPuIvMytMd2YwGivxGruSC+KzFKDl6wJo9CznBZ8gyjRhn/+zznUqnrOFyil41rqdY/t65AS+9ctvc4AvIjYmcxKHNUwP/e6rxOqJK6vkckBK65gz2mosAp8fUoMYBS9hSDjCbsopDhCX6SGv5FT9Walt3VkN5b5rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rWOYgqHVp1epHl37w7QZvu059CmwOyM7fw/ugaXl4Ss=;
 b=erS7wLXbrTEdcHvFk8TyXAzaWC5NlDSIE7yTLeWEaQTDcLnpTqEiI6dWXS6dm6kXrq0wlSGAB3lJEKH9GeJbuvLrMdl247JBXxkM5HpvD3nFmEXCU/AjyA9Y3YZqohqNyGLUQ7vksZRHKtXtlXAikvurGlyGKIfDLAYl8FWzGLx+1zGHaPOYeBh5FcNo0PHo8PKJB6EVF4cgQGgBLXdJOSao+dg3AySwZt8akiClsHxNPqbeyGzUw+3g7wDJ1VLLoRjYa2HRP6N1vKkz7k3geQbkx7sar1BumkBs7Se0kA6g6XeFjGxPlfq3JRRwLAEnXxBg7H1NKeAXwUdtAeW7kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rWOYgqHVp1epHl37w7QZvu059CmwOyM7fw/ugaXl4Ss=;
 b=iBrWLZ6XZXJ5kArQ2spqfYchNTrO+kQvChx/kcVpXyWHQCe+DbKxhydgjix/jYBSYDDIYTamcDwURIqQZVgSECQe1Oh9EFAyB+Ad0vcat6tGniAPhwQBUbuZPp8SpLboy5lQvdA7o4ncNtCbCbgnnpXNU3cUc34MiCBpRqdgmSo=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BL1PR11MB5511.namprd11.prod.outlook.com (2603:10b6:208:317::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Thu, 14 Oct
 2021 21:50:33 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4587.030; Thu, 14 Oct 2021
 21:50:33 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Widawsky, Ben" <ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v4 10/17] libcxl: add label_size to cxl_memdev, and
 an API to retrieve it
Thread-Topic: [ndctl PATCH v4 10/17] libcxl: add label_size to cxl_memdev, and
 an API to retrieve it
Thread-Index: AQHXu1RqgPcT/gQklkCQOH+Rv63cOKvS2uYAgAA5dgA=
Date: Thu, 14 Oct 2021 21:50:33 +0000
Message-ID: <b0f00df84d60806c8a67be2163880ee64dcdf34b.camel@intel.com>
References: <20211007082139.3088615-1-vishal.l.verma@intel.com>
	 <20211007082139.3088615-11-vishal.l.verma@intel.com>
	 <CAPcyv4h64LkFS1T_YqoRDz-7jDfkycNxBEkSzRxs-eUe4Y=LVg@mail.gmail.com>
In-Reply-To: <CAPcyv4h64LkFS1T_YqoRDz-7jDfkycNxBEkSzRxs-eUe4Y=LVg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7620cbb7-d7dc-437b-3879-08d98f5ca620
x-ms-traffictypediagnostic: BL1PR11MB5511:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL1PR11MB55110AEAC437B87BEF2F342BC7B89@BL1PR11MB5511.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LgSLb9o2huALL9B95o/hC3mrOGWj8mdxOK3+R7tL+GG54rz+MFbB8svfSBXZ4btI4tzFcHjqlp+0uAWbPICCFatZqCyCEgryttwfvdL2D5xYNwEDrEBY/BHBIlkIDE2NuWeU2F+f0fTeozm6MxBjINtQRKg2ly6ixMjI38Rha+JEkISJNOIaYBJkSBcuZ466HcFn38gCVB2SkTfwFd7iGrUPao6AyhMwkaVWhU+5f0p3d32QZsymtox9QKMP74NlMNb6NdU8i0CAujIvMuxDn7trWhuJ6Oxt2eInBMgT1yRwUE8xGfUX43LXWeIf2tPkvgBZKzjnd9L17KrEEdM0kFVT5/BxFXhIzsGnZo8ksmGAhsd+IjQN11Gq0ZoZCeHf7FDGN3GjyJEDQdY38VhZR5hBdpAXFi9evQJNeugxqKG6qa7lZ2SlooJp7LLfmfM+OVRgmjBLKJaf11yzyarnKHk58PJGX1DcbvzRy8pDFCFa5/fe65ZCWa5RHehkWuMTRsKZL6+2x98CBV030ZGxenVofLDHOnUjueZ81w2EjPJfCIcB90Iqz5mTTYmmMLWi0tuohNdyFtPjQLZxf3WtzY1uTjqGPqTbQuOHaWcKO/OKsed6R37Mczpvp1FpIFyg/3XO0ixSJLyB1/BNQaWFAosBx4Nn+gvq1UcG4PgoJpMr99WiXCYn8voOAM2wp6O8WU5CSiJQ2ea9EEq2WlO/BQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(53546011)(66946007)(26005)(37006003)(316002)(54906003)(6862004)(5660300002)(508600001)(2616005)(6636002)(6512007)(91956017)(186003)(122000001)(2906002)(76116006)(71200400001)(4001150100001)(66556008)(36756003)(66476007)(38100700002)(64756008)(8676002)(8936002)(4326008)(38070700005)(66446008)(86362001)(6486002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R1B0Mm9VYTc4TFZPOEdldFdCK0ZsWnJlMndoZXM4RFU2bTRiV0NZMG90YVZZ?=
 =?utf-8?B?Vk55aWlPZ3p4dklSRTd6ZXNNWkFPNEtUdnJFR0hKRllzc0JXMGFQS1haeFNC?=
 =?utf-8?B?OGRnNkE4UmJkNFlFc0VxY2dXaWg4dUZ1R3IwdmxPaUkvTW5aV2FnQjlrWHJV?=
 =?utf-8?B?aHRPWHlKRDRFWDFwU2dkN1lyLzkrenJ2ZDhocFFjT3V6Qmh3WVJGU0ZxWnFZ?=
 =?utf-8?B?b3lIV0lxS25GTElrOWdZSGdCT3BQN2liME55Y1k2OEpjd2pBSnB5cjVDT1JI?=
 =?utf-8?B?OENBc3l0T2xCdUFqY2d2bURsc1NBKzNPUzJJOUFCQVRBVk5jMjBrL2Q5QTNN?=
 =?utf-8?B?MnZXd0NxY3V3Sm1hQldJQkFOc2RxUkh0VWhyOXVpRDIzdGczMytzeEFaSTdL?=
 =?utf-8?B?L1BsUCtVMjNEOHB5ZzVXNnllWldPVGZLRGpSRFVNWllWZ1lSMmFmZFYwUzdl?=
 =?utf-8?B?RjFkMjBkaVNsdWNhSlhTSTNQQWZ3VVBOL3NZTkVpVTdSMHgvclg1VkVQbDJ5?=
 =?utf-8?B?MXFZSmZaVjZwUUtHM04ydjhHZTRGWFRxT0NIS3pQMHMrRGxBbFR2dXJDNFND?=
 =?utf-8?B?ZVBZUjMzL0N4RWJRYldrVWUxUlhHemMrWmR3aE8wbWE1TmIxdnowcC9vcXo4?=
 =?utf-8?B?ZXM3UjhRTGNUVUFDT2ZvUFdoWWVsNzEzQXJFMEZKSjk0OWtsSkdCZkk0czNa?=
 =?utf-8?B?YVVoSUtsb2xLZ2VEemtoQzVnSENTVHhNYTJIZ3p0YzEyWWk3d0M0VWdIRUxx?=
 =?utf-8?B?dzJRTDdRS3VYKzFoano0eGFlZDVLQzFDejNlOU9qSlRPUUtNS1hndFF4Z2xB?=
 =?utf-8?B?c0haV21Rejd3ZEdaaXJqTWFCMURmeFFEY3I5TW9vMHM3MmhDZXk5b05WNDlT?=
 =?utf-8?B?eG9qaDVFUVE0b3R2MkUrbm9TdEJhOG96K3VCOW5XanJzeWljMmI1NldVejJj?=
 =?utf-8?B?MHlLZ2VtL0NtUUJlTGltWVBGdEFHSWY3NlJXMGdoZklyZlF3b3NlcGs2QTQ2?=
 =?utf-8?B?aTFlQU00K0E5ZFB4QUh6dUlYeUw2VHMvSVdXWU1KdS8rVVNJOFp2T0tPbno4?=
 =?utf-8?B?eDdwRFJVY3BCRndwa1R5VUpKTWw0a2FRNkgwYi8vTUFwRjQvNzh3czl2a29z?=
 =?utf-8?B?VGdvVkh6N0JaWVpLSndTTGtydERiWHJ1ZUR2UG9Lc01ETmpFSERzb2pNd2JD?=
 =?utf-8?B?dWFOL28vZC9uWHJoVEJ2VzJOQzBGL0VxUG5lZE0zbXdnTWtWRVk4QmtnTnhT?=
 =?utf-8?B?Z1hXdHNqdE5pZlhOeTFGbmMxc3J5bis3L2pnMUl1ZnRhRmRPRWNmOWZnQlpU?=
 =?utf-8?B?c1g3clA2c296bzdiTnowZWZhd2V5b0NpVWtHVDhXM2hDVTdVY1Q1U3VtQ1U0?=
 =?utf-8?B?Yk9CN2lOUFBwOExNcHQ2aHUzc255amkra0FhSzF1UHZOajFKZGdUaEtFb29Z?=
 =?utf-8?B?S3AxTGpzWldmSVpDYmhEKzU4YjlZUTAxanBLeEJPTXh4Q0MwTUtWbWxwdURs?=
 =?utf-8?B?bFFLeEtZNFJobUxkaStveHhzbnB5Z05raHJCc1J4Mklxd0g0MkhvY1lnY2Vq?=
 =?utf-8?B?SjZSeWRiQ3hHOTRuTFlleGE5UVBIWnNGVk5wTURWTjIyL1dXZWFYTzdmNGVF?=
 =?utf-8?B?dFE0ZGVSd00yeC9oaitNNXBtNlZoYllqQW8rbGU5WW5DeTdjWjl2T2JxMDdw?=
 =?utf-8?B?YkdJaU5HY1lXUUVJQzk1R3kwajM2SDJLQ0ZpWVFzUW1GNGNBdVR3Q1d3eFpO?=
 =?utf-8?B?MnE2NHdhdVhtWWo2VE5Za3RCaFc4TXJjcnM1Qjl1UWdnSHMyOWtqcG0vN1lE?=
 =?utf-8?B?OElEMEtpVU1seG9yT1FrQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48CA5FE0F951834F93749E80BA1C2E26@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7620cbb7-d7dc-437b-3879-08d98f5ca620
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 21:50:33.5379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qyF8xeDpeUkIlLyM8IvvjWcBL7CWZsjPTRgFF6KHWcl4mDpoCoaehnigrmw7l8AIj9vAulHxtGbLWyhxgX8Z30oK0q3Uync+jzrimZj1lh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5511
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTEwLTE0IGF0IDExOjI0IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgT2N0IDcsIDIwMjEgYXQgMToyMiBBTSBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZl
cm1hQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gU2l6ZSBvZiB0aGUgTGFiZWwgU3RvcmFn
ZSBBcmVhIChMU0EpIGlzIGF2YWlsYWJsZSBhcyBhIHN5c2ZzIGF0dHJpYnV0ZQ0KPiA+IGNhbGxl
ZCAnbGFiZWxfc3RvcmFnZV9zaXplJy4gQWRkIHRoYXQgdG8gbGliY3hsJ3MgbWVtZGV2IHNvIHRo
YXQgaXQgaXMgYXZhaWxhYmxlDQo+ID4gZm9yIGxhYmVsIHJlbGF0ZWQgY29tbWFuZHMuDQo+ID4g
DQo+ID4gU2lnbmVkLW9mZi1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5j
b20+DQo+ID4gLS0tDQo+ID4gIGN4bC9saWIvcHJpdmF0ZS5oICB8ICAxICsNCj4gPiAgY3hsL2xp
Yi9saWJjeGwuYyAgIHwgMTIgKysrKysrKysrKysrDQo+ID4gIGN4bC9saWJjeGwuaCAgICAgICB8
ICAxICsNCj4gPiAgY3hsL2xpYi9saWJjeGwuc3ltIHwgIDUgKysrKysNCj4gPiAgNCBmaWxlcyBj
aGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2N4bC9saWIv
cHJpdmF0ZS5oIGIvY3hsL2xpYi9wcml2YXRlLmgNCj4gPiBpbmRleCA5YzYzMTdiLi42NzFmMTJm
IDEwMDY0NA0KPiA+IC0tLSBhL2N4bC9saWIvcHJpdmF0ZS5oDQo+ID4gKysrIGIvY3hsL2xpYi9w
cml2YXRlLmgNCj4gPiBAQCAtMjEsNiArMjEsNyBAQCBzdHJ1Y3QgY3hsX21lbWRldiB7DQo+ID4g
ICAgICAgICB1bnNpZ25lZCBsb25nIGxvbmcgcG1lbV9zaXplOw0KPiA+ICAgICAgICAgdW5zaWdu
ZWQgbG9uZyBsb25nIHJhbV9zaXplOw0KPiA+ICAgICAgICAgaW50IHBheWxvYWRfbWF4Ow0KPiA+
ICsgICAgICAgc2l6ZV90IGxzYV9zaXplOw0KPiA+ICAgICAgICAgc3RydWN0IGttb2RfbW9kdWxl
ICptb2R1bGU7DQo+ID4gIH07DQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2N4bC9saWIvbGliY3hs
LmMgYi9jeGwvbGliL2xpYmN4bC5jDQo+ID4gaW5kZXggMzNjYzQ2Mi4uZGUzYThmNyAxMDA2NDQN
Cj4gPiAtLS0gYS9jeGwvbGliL2xpYmN4bC5jDQo+ID4gKysrIGIvY3hsL2xpYi9saWJjeGwuYw0K
PiA+IEBAIC0yNDcsNiArMjQ3LDEzIEBAIHN0YXRpYyB2b2lkICphZGRfY3hsX21lbWRldih2b2lk
ICpwYXJlbnQsIGludCBpZCwgY29uc3QgY2hhciAqY3hsbWVtX2Jhc2UpDQo+ID4gICAgICAgICBp
ZiAobWVtZGV2LT5wYXlsb2FkX21heCA8IDApDQo+ID4gICAgICAgICAgICAgICAgIGdvdG8gZXJy
X3JlYWQ7DQo+ID4gDQo+ID4gKyAgICAgICBzcHJpbnRmKHBhdGgsICIlcy9sYWJlbF9zdG9yYWdl
X3NpemUiLCBjeGxtZW1fYmFzZSk7DQo+ID4gKyAgICAgICBpZiAoc3lzZnNfcmVhZF9hdHRyKGN0
eCwgcGF0aCwgYnVmKSA8IDApDQo+ID4gKyAgICAgICAgICAgICAgIGdvdG8gZXJyX3JlYWQ7DQo+
ID4gKyAgICAgICBtZW1kZXYtPmxzYV9zaXplID0gc3RydG91bGwoYnVmLCBOVUxMLCAwKTsNCj4g
PiArICAgICAgIGlmIChtZW1kZXYtPmxzYV9zaXplID09IFVMTE9OR19NQVgpDQo+ID4gKyAgICAg
ICAgICAgICAgIGdvdG8gZXJyX3JlYWQ7DQo+ID4gKw0KPiA+ICAgICAgICAgbWVtZGV2LT5kZXZf
cGF0aCA9IHN0cmR1cChjeGxtZW1fYmFzZSk7DQo+ID4gICAgICAgICBpZiAoIW1lbWRldi0+ZGV2
X3BhdGgpDQo+ID4gICAgICAgICAgICAgICAgIGdvdG8gZXJyX3JlYWQ7DQo+ID4gQEAgLTM1MCw2
ICszNTcsMTEgQEAgQ1hMX0VYUE9SVCBjb25zdCBjaGFyICpjeGxfbWVtZGV2X2dldF9maXJtd2Fy
ZV92ZXJpc29uKHN0cnVjdCBjeGxfbWVtZGV2ICptZW1kZXYNCj4gPiAgICAgICAgIHJldHVybiBt
ZW1kZXYtPmZpcm13YXJlX3ZlcnNpb247DQo+ID4gIH0NCj4gPiANCj4gPiArQ1hMX0VYUE9SVCBz
aXplX3QgY3hsX21lbWRldl9nZXRfbGFiZWxfc2l6ZShzdHJ1Y3QgY3hsX21lbWRldiAqbWVtZGV2
KQ0KPiA+ICt7DQo+ID4gKyAgICAgICByZXR1cm4gbWVtZGV2LT5sc2Ffc2l6ZTsNCj4gPiArfQ0K
PiA+ICsNCj4gPiAgQ1hMX0VYUE9SVCB2b2lkIGN4bF9jbWRfdW5yZWYoc3RydWN0IGN4bF9jbWQg
KmNtZCkNCj4gPiAgew0KPiA+ICAgICAgICAgaWYgKCFjbWQpDQo+ID4gZGlmZiAtLWdpdCBhL2N4
bC9saWJjeGwuaCBiL2N4bC9saWJjeGwuaA0KPiA+IGluZGV4IDc0MDg3NDUuLmQzYjk3YTEgMTAw
NjQ0DQo+ID4gLS0tIGEvY3hsL2xpYmN4bC5oDQo+ID4gKysrIGIvY3hsL2xpYmN4bC5oDQo+ID4g
QEAgLTQyLDYgKzQyLDcgQEAgc3RydWN0IGN4bF9jdHggKmN4bF9tZW1kZXZfZ2V0X2N0eChzdHJ1
Y3QgY3hsX21lbWRldiAqbWVtZGV2KTsNCj4gPiAgdW5zaWduZWQgbG9uZyBsb25nIGN4bF9tZW1k
ZXZfZ2V0X3BtZW1fc2l6ZShzdHJ1Y3QgY3hsX21lbWRldiAqbWVtZGV2KTsNCj4gPiAgdW5zaWdu
ZWQgbG9uZyBsb25nIGN4bF9tZW1kZXZfZ2V0X3JhbV9zaXplKHN0cnVjdCBjeGxfbWVtZGV2ICpt
ZW1kZXYpOw0KPiA+ICBjb25zdCBjaGFyICpjeGxfbWVtZGV2X2dldF9maXJtd2FyZV92ZXJpc29u
KHN0cnVjdCBjeGxfbWVtZGV2ICptZW1kZXYpOw0KPiA+ICtzaXplX3QgY3hsX21lbWRldl9nZXRf
bGFiZWxfc2l6ZShzdHJ1Y3QgY3hsX21lbWRldiAqbWVtZGV2KTsNCj4gPiANCj4gPiAgI2RlZmlu
ZSBjeGxfbWVtZGV2X2ZvcmVhY2goY3R4LCBtZW1kZXYpIFwNCj4gPiAgICAgICAgICBmb3IgKG1l
bWRldiA9IGN4bF9tZW1kZXZfZ2V0X2ZpcnN0KGN0eCk7IFwNCj4gPiBkaWZmIC0tZ2l0IGEvY3hs
L2xpYi9saWJjeGwuc3ltIGIvY3hsL2xpYi9saWJjeGwuc3ltDQo+ID4gaW5kZXggMWI2MDhkOC4u
YjlmZWI5MyAxMDA2NDQNCj4gPiAtLS0gYS9jeGwvbGliL2xpYmN4bC5zeW0NCj4gPiArKysgYi9j
eGwvbGliL2xpYmN4bC5zeW0NCj4gPiBAQCAtNzUsMyArNzUsOCBAQCBnbG9iYWw6DQo+ID4gICAg
ICAgICBjeGxfY21kX25ld19yZWFkX2xhYmVsOw0KPiA+ICAgICAgICAgY3hsX2NtZF9yZWFkX2xh
YmVsX2dldF9wYXlsb2FkOw0KPiA+ICB9IExJQkNYTF8yOw0KPiA+ICsNCj4gPiArTElCQ1hMXzQg
ew0KPiA+ICtnbG9iYWw6DQo+ID4gKyAgICAgICBjeGxfbWVtZGV2X2dldF9sYWJlbF9zaXplOw0K
PiANCj4gU2luY2Ugd2UgbmV2ZXIgbWFkZSBhIHJlbGVhc2Ugd2l0aCB0aGUgdjIgc3ltYm9scywg
d2h5IGRvIHdlIG5lZWQgYSBuZXcgdjMgc2V0Pw0KDQpIbSwgeWVhaCAtIEkgdGhpbmsgSSBqdXN0
IGxvZ2ljYWxseSBzZXBhcmF0ZWQgdGhlbSwgYnV0IGZyb20gYSBsaWJ0b29sDQp2ZXJzaW9uaW5n
IHN0YW5kcG9pbnQsIEkgYWdyZWUgdGhlcmUgaXMgbm8gbmVlZC4gSSdsbCBwdXQgdGhlbSBhbGwg
aW50bw0KdGhlIHYxIGdyb3VwLg0KDQo+IA0KPiBPdGhlciB0aGFuIHRoYXQsIGxvb2tzIGdvb2Qg
dG8gbWU6DQo+IA0KPiBSZXZpZXdlZC1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0Bp
bnRlbC5jb20+DQo+IA0KDQo=
