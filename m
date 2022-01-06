Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D8C2C80
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 21:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641506284; x=1673042284;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=AM5Qii6+NonHG5z7a9sImBxZCuENqFc5qPgP3HAUBWc=;
  b=T3kV/OcuRBbbs2nqmEkPiP++QPx294hMjzp8x2QbYMAMjIl6Flqt4cYs
   SejlEmnsMx3BTKYhsCWlmT4/1OBavynpv0HMhM3XnImQA8Xm2OKv2IfD4
   r06XJZ7DsTQLrZ/5N57aa7v/g7DvGJE4AN0y86klwYGlrn8hvckgPv9MU
   0lRpRL/LWMOsLRfXZC6cscil34JQFmeOmkbri9OQrEKmgoISub0wG1cma
   J7ob9yxqDU4xULZxiScLeId+XK9J4s/SAKB7/70N/sQUDzk9900oS+2C+
   AHs5tkn09IOjmbG4CsyuvNSLtL6OyFTZue/uCn4NhD9QvPuEm7qyXU2Xx
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="222739873"
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="222739873"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 13:58:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,267,1635231600"; 
   d="scan'208";a="557062068"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 06 Jan 2022 13:58:03 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 6 Jan 2022 13:58:02 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 6 Jan 2022 13:58:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 6 Jan 2022 13:58:01 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 6 Jan 2022 13:58:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FaUbmxXpEYGyPZ+gPKc52D7zV/ezHvlx+nxE2bzkDuZZQ3ab2Y2x0PJb6aNjTWA0hqTFX2aDwiOsBrfa2fE74bPN7G8v1xfVs5Mn3yld4FejXkmF5VgwN8KSIBOIx6V9keKJ3waYmuVJCi5gii64Rpfebq02mJYEHHPdjlh3lt+GpTEh2vXA1+mVUDMdLENoqpCxOzMuxZOl9enDzhs5MBBE6RoVAr79xVBT09pei9xuJ2iojDJDqX4+tsq7kQoCY/21w6xDdHWFt++lQtJN9JDRuYY4AZwajELPttY4kBvXZWqeF5cr4AD0ind10g1sxeI5RQiGWKU9sYymXo0XMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AM5Qii6+NonHG5z7a9sImBxZCuENqFc5qPgP3HAUBWc=;
 b=HsvwTYTmzaCDNhy5v6N74UQ732gviWOyIC85loAbkLYZs5TtP0yc7+hcL92dxrF/rFqr9rGP+qGLgX177DIhlL7VIUkNS2/42nH7fzqpxu/aoLJi7wijuHXCWjWqO491ik0WNjCt+B6q2UE58BOhQPuOKDh+c88RwVG2pi+AzBnSWGNRVKHSVXsee7yfndD89m2YhB69nrJT2ySV5JNBxR4/zR75M8wENq+I1Lp4rDAdJjKmL6boxRqXA0VkXN86lDEBc08jiCkTiKGK19L988Ai2MaTtqO/UeZ+H0tiF0ICGuFYnHBH6tX+JM2I70Z+Uc/l8jRBXFOloHcW/TxAHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB3597.namprd11.prod.outlook.com (2603:10b6:208:ee::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 6 Jan
 2022 21:58:00 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::114d:f87:eeb5:b6be%4]) with mapi id 15.20.4844.017; Thu, 6 Jan 2022
 21:57:59 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>, "Widawsky, Ben" <ben.widawsky@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 1/7] libcxl: add GET_PARTITION_INFO mailbox command
 and accessors
Thread-Topic: [ndctl PATCH 1/7] libcxl: add GET_PARTITION_INFO mailbox command
 and accessors
Thread-Index: AQHYAN4f1aUGOFztOUus052ftf3FOqxWc5OAgAARgICAAAoIgA==
Date: Thu, 6 Jan 2022 21:57:59 +0000
Message-ID: <a964f28b2541168b94ed732f658980fc87954391.camel@intel.com>
References: <cover.1641233076.git.alison.schofield@intel.com>
	 <9d3c55cbd36efb6eabec075cc8596a6382f1f145.1641233076.git.alison.schofield@intel.com>
	 <20220106201907.GA178135@iweiny-DESK2.sc.intel.com>
	 <CAPcyv4h4_V+fugcbU0f_+ZJ9sALdDqAtgovoVhpjzd6cYiBHgA@mail.gmail.com>
In-Reply-To: <CAPcyv4h4_V+fugcbU0f_+ZJ9sALdDqAtgovoVhpjzd6cYiBHgA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6807765-0088-44c8-6005-08d9d15f9ad2
x-ms-traffictypediagnostic: MN2PR11MB3597:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB35978C12B6782F02A6F99055C74C9@MN2PR11MB3597.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lBjpiaWBNivH6iFFUBlegIlzORVLhd/5lpqNmRmwMOuQtANRGTM4Ki9kRbEEX3na70b+Wc1t/vkMnEaoMrkAUgo238lWeIDQ8fh45MOOIWpf3wnu7bXnFCsPGmviPPPYgTsfhHYkeIyYKxmig/+FWBU8oKufTFizra8EQfyXTHRvyTSg6GjRyvKVHleHSxxYRsZGkkZZfHgObzhrA1ILFA30m2xTw8UmINz1QcI1dMIfYGtuyOZojSf5PiHL4cNrcKj8uQtOI7X+b/mrHXCrd41BL6Od/iEUmA7xq55uw31D0x5KkhXJHDkPMyLPhhkSO85454TgKCxZtcPKb8j96K5BWBE12fpouRhFEzFxh2sGhKkvZ2j7W8IWopV4ncpTwOORxS5zq/exrzX1pJvDD+O2cMs0HcpG6jlbCQlJKsdCnRRF0xY+v0mknAHiXNMSv5ue3h66/H10ZFeSKmm/2Y48Gpeg/TH6WTKMLpklrY90gySh7BJJ9GywsiEmXreFNObHTm3Q4VfMgEBbGoyHZs+C6WaZ5mx0I/BjKND1jh6J4vOCFf3G5wY4r4FhuTgHucoDJN9rZH+e0VucUmDn1iz5w7sdafBkGpCUfXmSR6rrQXcnEneMKp5G81UqnlTJRrlidHrMSGgW0F8Xyvepayhv5AC1nWrIH5/RnjCk5nSP35g0K0IQBQc8zM5tj1jJCo+K+OgieZVJ8tyCPWFMaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(82960400001)(2906002)(38070700005)(6486002)(6512007)(122000001)(86362001)(6506007)(5660300002)(53546011)(316002)(110136005)(8676002)(71200400001)(38100700002)(508600001)(64756008)(66476007)(66556008)(66446008)(26005)(36756003)(76116006)(2616005)(91956017)(66946007)(8936002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmxvOTVhTDV3NUxVTkI3NlRtTFhrTlB1SXZ2NEtrb2UzdWxBSmZ5RndzNHp1?=
 =?utf-8?B?Wk5IOXNFamNNK0JiTDZ6R0huWWNlMjFlcFBydFRnUklKakx0L0tKZmllQ25l?=
 =?utf-8?B?ZHNtS2NoQThlQ2ZhWG4vaTNpOUUyLzMzVzFNQ2twNGZ6MHFKT3liZnNvd1Bh?=
 =?utf-8?B?TFpENW5wcDQ5aWZEai9jZHRIL2tFbjY1Q2dqYldkZGVDV3VVai91cWtFRXBp?=
 =?utf-8?B?WmxPdUxPNUZYYXRxbVJ0ZllxVjlzby9VV2lpSmlsTGxGVXJlbVA4MXAxQVYy?=
 =?utf-8?B?RVNkMUh0Umh5TVVHV09Rc2x3bUVlVjJadjlLN0dvbVE2eExoUEhHK1VlZ1lN?=
 =?utf-8?B?SnA2U2RXb05EQkoxNHIvU0ZrYUJqN0p2aS9UaXN5SGtrZlM2QUczdEExVHZv?=
 =?utf-8?B?SlZUWXdXNEJrUDNCSjA1M0dZOEJZN0ZaSUhtcjlPK3RzVFUzQnhFZmVmNjQr?=
 =?utf-8?B?bFBPcUEzMk9Jb05NMU02NUpDNlMyazhDcWE1OFBBTS91L1pESFNxdkRDSkRN?=
 =?utf-8?B?aEl4R1VXWFAreW1IMVhFTGNKQjVENVU1bHRUK21HZk55L3pIa1VEamdwQXZS?=
 =?utf-8?B?My9QSGlWOGRFN3F5ZnhOTm10WEJ2ZkxHMzhwM3dMTVpnSklNUFlmdHhMc3du?=
 =?utf-8?B?SjVNRnUxN0x0cWF1QzJzNnZwNWQ0SUZSemNOd0hMR2M2U1d1RkZ2Ni81RW9s?=
 =?utf-8?B?Y1dvSklpak9YUjg4Y0lWbEpROURzUkRKdzZoWm85d0dkdjhtZXlTVjBjNnRJ?=
 =?utf-8?B?bS9ZcEUzUTVxeXhGWjVJc2w3eVFBTFk2bnBQZExwci94Nkpqcmg1dlVWK1Jh?=
 =?utf-8?B?Q3c2S0plaWM4MkJuZHFuL1gwSy8ydFpTeXF2dUJJTUdOc0hKQ1czZGlWSDVr?=
 =?utf-8?B?OG1oc2ZMakt3djhjSStuYTREMFBLbS9peG5rMFBJVWJ0dHcreVpTVVZuMllw?=
 =?utf-8?B?TkhFdDd1SU1qNzBkUU5Nc2M5RFlyY3pWUlRMY2ZOODlKZVR4SElaRk1aU0Fu?=
 =?utf-8?B?eHg5MnEyWkNLc2xkUE5ocElRNXRzbU9DdnkwaGVZSE9UMmx6c3VxQ1p4Zmt4?=
 =?utf-8?B?NU9LbEZkbXhnWXBGZzN6eXFoNmZsRjk5NWxRSVlxQ1p5TDlvUXlqKzBydVM0?=
 =?utf-8?B?dVk2NGdmdlhuUXNDNXh5STMvOEF0WlFMekR5K0QxNzF5bW5rZ0dSekNXbStm?=
 =?utf-8?B?M2Z3L29za3FzVUUrZ0lRZm83dENNSXJIMkRuKy8wdE5PUDVTMS9TOUYvb3hH?=
 =?utf-8?B?Vk00RkpYcXNKWUNDQXJpbHVNVGhmajVpMytmQ3FsbHpIZGszU2xESTUzR0JS?=
 =?utf-8?B?UldsRTFJYTFaYkVINVB5NlBoV1VBQkh3V2M0RTBpUjRkdC9uVnBBRmkzcEpx?=
 =?utf-8?B?ZjJNS1RIcVk0RWkrZ3Fzd2R4SDAxNzlKQ2RMeUFReVVGQTFBdkp4N011Nk5p?=
 =?utf-8?B?MnA2TXg0R1BKOEkyVS8vK1FFUUpYYkdsL0NRMG5VVXF4aFBoaGd5c2lCSE1p?=
 =?utf-8?B?cVBhakYxTDJyVEkyWjJTd0wwdjVvVUdOamlITEZZTjVnYzVmaHRQNDJFSENC?=
 =?utf-8?B?QVJFQXhxWExWdlB0SzhvbnVzN3RWWXBCM0Z1REN1T0g4SkdKNjZtVjhDbHA4?=
 =?utf-8?B?OFdPNDZ3SmdhVFRDVGpZOCtxSGsxbFhTS0c3aWVkY1hDSm1mN21qMGpMeFRR?=
 =?utf-8?B?OVBMdGhRdWY2cEpyUmZ0em5ORy9udDMxQmZLYTRhQ3VvRmM3UXNGL3pmUWZ6?=
 =?utf-8?B?SFdYcDRyOTR3cXk0ZEFkdm5GVGFldXhVUXVoRXNXS2NNL0ltWUhxUGJaQ0pp?=
 =?utf-8?B?bEM1aGo4ZE9TSWNpTG5GQnJFSUluZkpwTXNJMWlBc2ZZVzdTTDlzd05Qa2Zp?=
 =?utf-8?B?YkRsWGJ6UTNtNEJwd3FvdWhsUVozWTNEeHBGKy9NaFNBMDE3RTQwdjBEN2h5?=
 =?utf-8?B?c1hHanpGc05qSnBTenJNbHE5ZzRPNFk1Q1htdTEwWkNEKysvR2Q4NlNuU2Uz?=
 =?utf-8?B?dTJlOGJGVjVzZDN5UEFIc3RyNjRpNWhIQ3B4VVFCOVBEMmx6YzF0V1QyMTZO?=
 =?utf-8?B?RkZwdG0vUm9TcEJ4ck1KMmxPaDZEek1zSnhtNVVDTzg2OEpkTUdlVnljd29T?=
 =?utf-8?B?YWVkSlZrWjNlV2s5RjhqVjBJbnR5WlJ5Wm9uVXFwSGtpaGM2S0ZxRFZscVF4?=
 =?utf-8?B?enJ6UTE4QUJhbEtqVUxETTl4R3dleHFLTWFXZitEa3JYNXRsNzNJeU1SK2J3?=
 =?utf-8?Q?TpjhU64oW9vyl2/9sRtJWfr+VIHRX+7YFAescU5Q1I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53545AC18823C046944D97D13EEF222F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6807765-0088-44c8-6005-08d9d15f9ad2
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2022 21:57:59.7963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QmsN+BiDOppiemB0GNfW7oVpt23hCJFjrkB4LZLkEwFmFbdESWHdajeKXhJhEhzr/7+CcU8RgwxgxOcYrsYjbLaq8F0/qBgP0cLPk7/HKoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3597
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIyLTAxLTA2IGF0IDEzOjIxIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgSmFuIDYsIDIwMjIgYXQgMTI6MTkgUE0gSXJhIFdlaW55IDxpcmEud2VpbnlAaW50
ZWwuY29tPiB3cm90ZToNCj4gPiANCg0KWy4uXQ0KDQo+ID4gPiArc3RydWN0IGN4bF9jbWQgKmN4
bF9jbWRfbmV3X2dldF9wYXJ0aXRpb25faW5mbyhzdHJ1Y3QgY3hsX21lbWRldiAqbWVtZGV2KTsN
Cj4gPiANCj4gPiB3aHkgJ25ldyc/ICBXaHkgbm90Og0KPiA+IA0KPiA+IGN4bF9jbWRfZ2V0X3Bh
cnRpdGlvbl9pbmZvKCkNCj4gPiANCj4gPiA/DQo+IA0KPiBUaGUgIm5ldyIgaXMgdGhlIG5hbWlu
ZyBjb252ZW50aW9uIGluaGVyaXRlZCBmcm9tIG5kY3RsIGluZGljYXRpbmcgdGhlDQo+IGFsbG9j
YXRpb24gb2YgYSBuZXcgY29tbWFuZCBvYmplY3QuIFRoZSBtb3RpdmF0aW9uIGlzIHRvIGhhdmUg
YSB2ZXJiIC8NCj4gYWN0aW9uIGluIGFsbCBvZiB0aGUgQVBJcy4NCj4gDQo+ID4gDQo+ID4gPiAr
dW5zaWduZWQgbG9uZyBsb25nIGN4bF9jbWRfZ2V0X3BhcnRpdGlvbl9pbmZvX2dldF9hY3RpdmVf
dm9sYXRpbGVfY2FwKHN0cnVjdCBjeGxfY21kICpjbWQpOw0KPiA+ID4gK3Vuc2lnbmVkIGxvbmcg
bG9uZyBjeGxfY21kX2dldF9wYXJ0aXRpb25faW5mb19nZXRfYWN0aXZlX3BlcnNpc3RlbnRfY2Fw
KHN0cnVjdCBjeGxfY21kICpjbWQpOw0KPiA+ID4gK3Vuc2lnbmVkIGxvbmcgbG9uZyBjeGxfY21k
X2dldF9wYXJ0aXRpb25faW5mb19nZXRfbmV4dF92b2xhdGlsZV9jYXAoc3RydWN0IGN4bF9jbWQg
KmNtZCk7DQo+ID4gPiArdW5zaWduZWQgbG9uZyBsb25nIGN4bF9jbWRfZ2V0X3BhcnRpdGlvbl9p
bmZvX2dldF9uZXh0X3BlcnNpc3RlbnRfY2FwKHN0cnVjdCBjeGxfY21kICpjbWQpOw0KDQpKdXN0
IG9uZSBuaXQgaGVyZSBhYm91dCB0aGUgZG91YmxlIHZlcmIgJ2dldCcuIEluIHN1Y2ggY2FzZXMs
DQpnZXRfcGFydGl0aW9uX2luZm8gY2FuIGp1c3QgYmVjb21lICdwYXJ0aXRpb25faW5mbycNCg0K
ZS5nLjogY3hsX2NtZF9wYXJ0aXRpb25faW5mb19nZXRfYWN0aXZlX3ZvbGF0aWxlX2NhcCguLi4N
Cg0KPiANCg0K
