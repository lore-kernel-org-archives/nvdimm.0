Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498C82F5F
	for <nvdimm@lists.linux.dev>; Thu, 11 Aug 2022 21:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660253693; x=1691789693;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tDm6n4l1WQonT3N5RTW7l1ELkuSYFGotZYO6p06fy+s=;
  b=moTY11CHpYtNIMicksPw1dwimK3VHiyYc+E5PidtFPjalYPW0NyGtqMr
   XYE4Ait7CSScK6QRfpraODs6b6M1LTqChARhcm1L9D2seHCy5nS78HzXZ
   /cRB9YOQmvBylAIPfngdo44l4AVPYpI6vM7ckc6xRKFi6reW50LeZC/Ck
   y33d+SEMhk2cKOtMFxZeLXc0h1Z8NxpXZt4rAcY385guBUsx0KuL1tZVQ
   ix+dagORe0qHd6zLwO/5faGbEAnIeEGK/y9JMtZ1BkjKfqwYn5B9JOsBa
   v0qYGfFGQ7ECYQSYjC4gi4ofDZdIJHm8rlN6e2zkQDI15ytssb36Ec+wh
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10436"; a="271239718"
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="271239718"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2022 14:34:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,230,1654585200"; 
   d="scan'208";a="673854057"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 11 Aug 2022 14:34:52 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 14:34:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 11 Aug 2022 14:34:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Thu, 11 Aug 2022 14:34:51 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Thu, 11 Aug 2022 14:34:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jt4GNW791/G6iX7lgwBHftODNzpLnQHq1UcFU4YvORYRqIxPAZF1RhDB1YD9AwnDCMivBfCBjOyGaELAes65IHMfny9svpxs9+Bs8CnXp52BIlxJiUWJeWzeT54UWU8/1wMEieTkkYysehUbWMJ7vwoyaxHgSnNltbsro2GM099WdK0wCaOXrrJ+4fEGjQgWGmpeMSyMWjbs5HR9PdJxS4PL0YSKMfBtkUpB2b2t8ps1I5otOFWAgLT48ice6swP4ksZAoTeAvuJMDITLf3dnT9+WJDoUhxd272dbTwwlB1KV4TpCIbH3xMX0k30M1P9QR2h9MzgpLaCFwa/G+uSVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tDm6n4l1WQonT3N5RTW7l1ELkuSYFGotZYO6p06fy+s=;
 b=jtmrAR42BzVWzMJG+AZcovE691FnpQydB7qLYoSuBP9oyVEz9aNMTu15ZCozmn8EhozylFAvwtEvvI07LSHvDnkaF63/Jcn8t72eNR0U+upgld0RnkA1eVEk7Qxg0LX/U6p7QqXsT9inDyUDM6VLd1yecBYB20nQIozHI31sP2z2rnIVe8v10Zm3uYTEMUIPl2ufZJfxLirp4eKqDcqwEB4E8URVhJje2i8fnG7f2a/Q4G26A2BEuXG05i8Ibqlg5bdrDJgcVLlBsw9nqKFH1WmZwZCcPa7+1s2DdvJEL7Fw+w7rsEiOg4gaGzgx+0qshYxb2T+HnrS4bBuwCyLdjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by SA0PR11MB4719.namprd11.prod.outlook.com (2603:10b6:806:95::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Thu, 11 Aug
 2022 21:34:49 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1c88:c1bd:6295:cba4]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1c88:c1bd:6295:cba4%7]) with mapi id 15.20.5504.020; Thu, 11 Aug 2022
 21:34:49 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>
CC: "Schofield, Alison" <alison.schofield@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH v2 05/10] libcxl: add low level APIs for region
 creation
Thread-Topic: [ndctl PATCH v2 05/10] libcxl: add low level APIs for region
 creation
Thread-Index: AQHYrQ5EHVQdU5b0rU+k8kQyyiGMtK2pBFKAgAARjQCAAPRMgIAAMBUA
Date: Thu, 11 Aug 2022 21:34:49 +0000
Message-ID: <7dcfaa439df6cdd4f5019f4eea557011221cf617.camel@intel.com>
References: <20220810230914.549611-1-vishal.l.verma@intel.com>
	 <20220810230914.549611-6-vishal.l.verma@intel.com>
	 <62f471fbd22a2_7168c29410@dwillia2-xfh.jf.intel.com.notmuch>
	 <417003cc6a7acf80c5dcf9c1d6d0321ebc636a21.camel@intel.com>
	 <62f54da3f6bd_3ce68294d9@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <62f54da3f6bd_3ce68294d9@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4 (3.44.4-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 886337c2-ee97-4563-32d8-08da7be1517c
x-ms-traffictypediagnostic: SA0PR11MB4719:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y+6eL/kcUC5Kl9yPJnEMQ55VViBS31gtMXFH9ufmuS9Z2dwiA9DNm44WUjD/10ZA6zEqtWcOrsqp0UM5cl6Dx9FGeYBUWWOaHVXtX/Rp8Ezfr/HNJLJmZqY+9/nDPHbQKFdqkHETgNpZk5srFiUoH/hvgVTbk7WJr3Zec24gkXMVGnaGF3qJ5j1M+gjVXYTmnmwZcsplxqEChXZqynSM2GDfadXZ3CIz8RQRUrCqV4VL4MIX2AMm5p2lms3jY6xHRGcX8kebpWbSoMvTB046eBIsGBNIsvzjaF830CRp9Lc/Om8jqPyGbjZElhMA+fUXjgnDvQH3jOb5sb4MA22JLAIGTur+530AhBqCSd3z367Rb8ZPt16/89Fv5j3VwxePAlIvHXPRFNkx2r/Aoy5gxJP3GqYf/kL1+POxc2Gi5sUJdGfqw3DIAyYLHb4vdNBwrFNWwZXXKKU2uiWkogLeNyi173WAgNzRusPAsomQyFqIopyWLCzPf4Uv47L1X6rm4TWd8juxSlKKiNT/dwsYlfFj0y301P7goD7w+vtPmrS9WjWXvLr9lxbwGVO9YVU8JhsK4NVpvfs7EiPUGVOZ9OwSaPDI9F5o69KjI1zBMH5okgwLXGzJOId4j9KWmYQHVEw3k4O+ZbxF5xVsgv6m6XcLy0GushcDx3Me+3IqcPCVXjeU2LmJw3QTlMH4JNBtOX2HbAB7ywMv1T/VECDN0dA4C07AVZlN6erlaTYAxaOLIJpQywSGRanoeOGCdbDEVdzHRneBEwZevbU4iSB38JdjdAk2Q32IopIGERjIJ5WX47N03zMKfG9XjMY2CZAF
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(396003)(366004)(376002)(346002)(86362001)(41300700001)(6506007)(26005)(186003)(6512007)(38070700005)(38100700002)(6486002)(122000001)(82960400001)(107886003)(8936002)(2616005)(66476007)(91956017)(4326008)(66446008)(64756008)(2906002)(8676002)(5660300002)(66556008)(54906003)(110136005)(76116006)(66946007)(316002)(36756003)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1ZsYVpzL0NueVkvYm51MGJzaXlTdEtuc1dCUUV1VVpCTDNrcjVjUmV0MFd2?=
 =?utf-8?B?TkE1TktBWk5LSHUwME5XZitWK096WkpqVktmYU1lZnRYTW1sK2NNUXRDbDBO?=
 =?utf-8?B?VXNTQUd1cGVJOUdXUlI2TDhZRjZaNUlWWG96bkMwS1pyeVl5MytWVU5EUFJ5?=
 =?utf-8?B?ZmhVSTArWWpsbC9HTmwvNXd5aFlHVzk0OEZzR2xPaXhOcTdiSVNuNGZJMEtU?=
 =?utf-8?B?QW9yQTRMdDFmM1ZjUHVtYkl2bURaR21mYVAvVm9hVzZiR3BLZU44NWlVUnBU?=
 =?utf-8?B?MjVnZnRYa3B1WlZUM01rdE5TQi81TjhIblNXSFBNWXYxRWlBeVR1b2ZGR3Fh?=
 =?utf-8?B?aUwzam5OdjFoUXhiWUMyNVBKbEFtYUVLZnRsS1lJcTRwaXZaSGZJTFFNVDND?=
 =?utf-8?B?bHQ3MGcrNUdPUmZsNXpBYmljQ2o4SHdHUkZSb3Q4ZS9jYjJQL3hzZzhQZi9u?=
 =?utf-8?B?dGM4UUxjU0diTzltMWJPdDZRNjd2WXZVSnNvWCtlQ2Q4YzcyVXJSK2YxaFVV?=
 =?utf-8?B?elVrOGxzM0ZIRWpOZG9HMTd1eTczbUZVUlh5cmI5eENhMU9DaGlYTkcwQjBq?=
 =?utf-8?B?ZDdOTHVkL0o4SnduMjY4aytEVHJsT09rNW92UFhOcUk0Y2hRcFBpVTZTT0lh?=
 =?utf-8?B?NmtrS0YyaU9ocmxYcUg3RFBzYm5McW84NlQzdmZ4YzhieThnNlNNN3YwMUlz?=
 =?utf-8?B?SzZ0UzBZZjhadkRzbUVXQkdMU1RzNEhLbjRUQ1FwczV3R0d4eGNBWG1hTXRn?=
 =?utf-8?B?U0JrVjdKVG9iblZRTXhKNmhKUENyTG93ZWxwM294c1ZZQkVJUE5wZDV0VFQz?=
 =?utf-8?B?WHE3N3BWcCsxdHlsek9XS0RadStiRVYrMW5PMWZZMnc0ZURZc0hWWFJaZ29p?=
 =?utf-8?B?aEFqV2FJSW5zY2VER2tuQUZBNXVLUnY3eHU5MndkcTU3cC9nRU9URkwrMHZO?=
 =?utf-8?B?U3IrcUkvV1RQbENVR1BQWmNOYnhPNXZuQkROblI3MDJvNVNUUzZxREJQdUU3?=
 =?utf-8?B?Yk9jbFQ1NG85dGZxY3lhSEFDanZyR21yY3lzcmRzL3pPMEsvWU45UDQydy9W?=
 =?utf-8?B?OHB4QWRPQlh1a1JlcWR5U2pIM3FUS2NpMkdPQktsdmF4OXNlK2xnYnpjcVA0?=
 =?utf-8?B?K0ExajJMWWVnVk04TG84RVJmYkY3aFRrVjFsQzRiYnh3VjdrN1FZeHlsNW5t?=
 =?utf-8?B?dnJxQTNRYlVyNitQWjdsM0RFdUJ4SERaZVhqNlRvUVYzYWhwMkR4S2g0SWg0?=
 =?utf-8?B?d3JXVFJOZXdDRUYzRnRWMllvZExLTXNqemxrS0E4M1N5dGpvaWd0MkFxMnpn?=
 =?utf-8?B?eGczajdaV1lqbEIrKzFwamRmVjhMSjJ4bzJtUGs3NmJpdzRXeDA3Z094cjFs?=
 =?utf-8?B?L2svODVwQ0NuaGdNbXBUVXE3ei9HL2RiVVExSlVJdERNOWhRZU1VQ0tsdFZD?=
 =?utf-8?B?VHBNNFVRQ0g1UkRKYTE2MngvNVRONDVJUk43VFJpV3cyQlMzZXJYL1RDYW95?=
 =?utf-8?B?TjY4UHpWa285RSs5N3cxU0RMOTQxRFZMMUdFQ1pDaCttcjhOaUJFQ0RCaHMx?=
 =?utf-8?B?OEpXYUVFT1Y3K2xHOXVBK25PaUF3eGgxdG1iQmF5ZjNVWUxjZy9PNFQva3hK?=
 =?utf-8?B?K3QyYjc5TlhFQzA2UFJaY1FJMzJ0dVV4L3ZOZGVnK1d5T2MrUWsvUHJaTTRn?=
 =?utf-8?B?NlZXcHgyWElJa01DSTUvV0dHL0dGVlo1a0FoZG5uY2NkeGJKVXFwN0RBUkkw?=
 =?utf-8?B?OVdKMFFzdjZ5dlhNM3BLLzV1eWpLcjd5WUZmLzJzVkd4R0c1cHdPREJvdkJ4?=
 =?utf-8?B?UzZKNkVZZkFSejgwSWtUTGZBUEhScExKdnRpSWRobGkxK0hsekEwMkEwZEJC?=
 =?utf-8?B?TldZYitCcnIyRE5BUHBjMm5weFlzdVo2Y3NMa3dDaXlqT2NUNktaKzIyNjk2?=
 =?utf-8?B?am5sdVJudGJHdXl1RFJhV01oZ3VMRHBGUnZvdklkRXAydFRtUnpFTlJpV25K?=
 =?utf-8?B?Vi8zRzZsZVhxd08rVGwzSHhnTzFjRVpseE1ySDZJQ3Q4dnlyT2E5SVpYQkNo?=
 =?utf-8?B?c0Z2dWM5dERWVWZiUkJ0ZmljekVHOURxQVNVV3cyL2tqNjVXN1RQN0NWMStm?=
 =?utf-8?B?MHl5RU5YUndaZ0VnNmo4MkVyNmNzYXNyTSsyd1RaWEFibmxYZXVrUmdHL2dx?=
 =?utf-8?B?aVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4446E3BE91055544822C9370BAD3591E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 886337c2-ee97-4563-32d8-08da7be1517c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2022 21:34:49.1142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0p2PQTTID/7kQIbeYUTtfZf4Heo7uaZQk2DM1wZpCjr2yAgv2VywDbK1yJhoewUGeo2vtrbdlrcCvkUnOIhD2kg3JxZ2G/Jq2BSy5Zk2URY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4719
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIyLTA4LTExIGF0IDExOjQyIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFZlcm1hLCBWaXNoYWwgTCB3cm90ZToNCj4gPiBPbiBXZWQsIDIwMjItMDgtMTAgYXQgMjA6MDUg
LTA3MDAsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4gPiANCj4gPiANCj4gPiBbc25pcF0NCj4gPiAN
Cj4gPiA+IA0KPiA+ID4gPiArQ1hMX0VYUE9SVCBzdHJ1Y3QgY3hsX3JlZ2lvbiAqDQo+ID4gPiA+
ICtjeGxfZGVjb2Rlcl9jcmVhdGVfcG1lbV9yZWdpb24oc3RydWN0IGN4bF9kZWNvZGVyICpkZWNv
ZGVyKQ0KPiA+ID4gPiArew0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgY3hsX2N0eCAq
Y3R4ID0gY3hsX2RlY29kZXJfZ2V0X2N0eChkZWNvZGVyKTsNCj4gPiA+ID4gK8KgwqDCoMKgwqDC
oMKgY2hhciAqcGF0aCA9IGRlY29kZXItPmRldl9idWY7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDC
oGNoYXIgYnVmW1NZU0ZTX0FUVFJfU0laRV07DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVj
dCBjeGxfcmVnaW9uICpyZWdpb247DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoGludCByYzsNCj4g
PiA+ID4gKw0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqBzcHJpbnRmKHBhdGgsICIlcy9jcmVhdGVf
cG1lbV9yZWdpb24iLCBkZWNvZGVyLT5kZXZfcGF0aCk7DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDC
oHJjID0gc3lzZnNfcmVhZF9hdHRyKGN0eCwgcGF0aCwgYnVmKTsNCj4gPiA+ID4gK8KgwqDCoMKg
wqDCoMKgaWYgKHJjIDwgMCkgew0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZXJyKGN0eCwgImZhaWxlZCB0byByZWFkIG5ldyByZWdpb24gbmFtZTogJXNcbiIsDQo+ID4g
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RyZXJyb3IoLXJjKSk7
DQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gTlVMTDsNCj4g
PiA+ID4gK8KgwqDCoMKgwqDCoMKgfQ0KPiA+ID4gPiArDQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDC
oHJjID0gc3lzZnNfd3JpdGVfYXR0cihjdHgsIHBhdGgsIGJ1Zik7DQo+ID4gPiA+ICvCoMKgwqDC
oMKgwqDCoGlmIChyYyA8IDApIHsNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGVycihjdHgsICJmYWlsZWQgdG8gd3JpdGUgbmV3IHJlZ2lvbiBuYW1lOiAlc1xuIiwNCj4g
PiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJlcnJvcigtcmMp
KTsNCj4gPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBOVUxMOw0K
PiA+ID4gPiArwqDCoMKgwqDCoMKgwqB9DQo+ID4gPiANCj4gPiA+IEkgdGhpbmsgdGhlcmUgZWl0
aGVyIG5lZWRzIHRvIGJlIGEgImRlY29kZXItPnJlZ2lvbnNfaW5pdCA9IDAiIGhlcmUsIG9yDQo+
ID4gPiBhIGRpcmVjdCBjYWxsIHRvICJhZGRfY3hsX3JlZ2lvbihkZWNvZGVyLi4uKSIganVzdCBp
biBjYXNlIHRoaXMgY29udGV4dA0KPiA+ID4gaGFkIGFscmVhZHkgbGlzdGVkIHJlZ2lvbnMgYmVm
b3JlIGNyZWF0aW5nIGEgbmV3IG9uZS4NCj4gPiA+IA0KPiA+ID4gSSBsaWtlIHRoZSBwcmVjaXNp
b24gb2YgImFkZF9jeGxfcmVnaW9uKCkiLCBidXQgdGhhdCBuZWVkcyB0byBvcGVuIGNvZGUNCj4g
PiA+IHNvbWUgb2YgdGhlIGludGVybmFscyBvZiBzeXNmc19kZXZpY2VfcGFyc2UoKSwgc28gbWF5
YmUNCj4gPiA+ICJkZWNvZGVyLT5yZWdpb25zX2luaXQgPSAwIiBpcyBvayBmb3Igbm93Lg0KPiA+
IA0KPiA+IFllcywgSSBmb3VuZCB0aGF0IG91dCAtIGFuZCBhZGRlZCB0aGlzIC0gaW4gcGF0Y2gg
MTAgKEkgY2FuIGluc3RlYWQNCj4gPiBtb3ZlIGl0IGhlcmUgLSBpdCBtYWtlcyBzZW5zZSkuDQo+
ID4gDQo+ID4gVW50aWwgcGF0Y2ggMTAsIGR1cmluZyByZWdpb24gY3JlYXRpb24sIG5vdGhpbmcg
aGFkIGRvbmUgcmVnaW9uc19pbml0DQo+ID4gdW50aWwgdGhpcyBwb2ludCwgc28gdGhpcyBoYXBw
ZW5zIHRvIHdvcmsuIFBhdGNoIDEwIHdoZXJlIHdlIGRvIHdhbGsNCj4gPiB0aGUgcmVnaW9ucyBi
ZWZvcmUgdGhpcyBwb2ludCB0byBjYWxjdWxhdGUgdGhlIG1heCBhdmFpbGFibGUgc3BhY2UsDQo+
ID4gbmVjZXNzaXRhdGVzIHRoZSByZXNldCBoZXJlLg0KPiA+IA0KPiA+IFRoYXQgYmVpbmcgc2Fp
ZCwgcG90ZW50aWFsbHkgYWxsIG9mIHBhdGNoIDEwIGlzIHNxdWFzaC1hYmxlIGludG8NCj4gPiBk
aWZmZXJlbnQgYml0cyBvZiB0aGUgc2VyaWVzIC0gSSBsZWZ0IGl0IGF0IHRoZSBlbmQgc28gdGhl
DQo+ID4gbWF4X2F2YWlsYWJsZV9leHRlbnQgc3R1ZmYgY2FuIGJlIHJldmlld2VkIG9uIGl0cyBv
d24uDQo+ID4gDQo+ID4gSSdtIGhhcHB5IHRvIGdvIGVpdGhlciB3YXkgb24gc3F1YXNoaW5nIGl0
IG9yIGtlZXBpbmcgaXQgc3RhbmRhbG9uZS4NCj4gDQo+IElmIHRoaXMgd2FzIHRoZSBrZXJuZWwg
SSB3b3VsZCBzYXkgc3F1YXNoLCBzaW5jZSBiaXNlY3RpbmcgbWlnaHQgYmUNCj4gaW1wYWN0ZWQs
IGJ1dCBhcyBsb25nIGFzIHRoZSBmaXggaXMgdGhlcmUgbGF0ZXIgaW4gdGhlIHNlcmllcyBJIHRo
aW5rDQo+IHRoYXQncyBvay4NCj4gDQo+IE5vdGUsIEkgd2FzIGxlc3Mgd29ycmllZCBhYm91dCB0
aGUgY3hsLWNsaSB0b29sIHRyaXBwaW5nIG92ZXIgdGhpcywgYW5kDQo+IG1vcmUgYWJvdXQgM3Jk
IHBhcnR5IGFwcGxpY2F0aW9ucyB1c2luZyBsaWJjeGwsIGJ1dCB0aG9zZSBhcmUgZXZlbiBsZXNz
DQo+IGxpa2VseSB0byB1c2UgYSBtaWQtcmVsZWFzZSBjb21taXQuDQoNCg0KSSB0aGluayBtb3Zp
bmcganVzdCB0aGUgaW52YWxpZGF0aW9uIGhlcmUgdG8gcHJlc2VydmUgYmlzZWN0YWJpbGl0eSBm
b3INCm5vbiBjeGwtY2xpIHVzZXJzIG1ha2VzIHNlbnNlLiANCg==
