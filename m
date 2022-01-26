Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6EC168
	for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 17:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643219440; x=1674755440;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rV2+9UlgW9p5imkB2bydfbLWr47bCgy/Y2mivuedb+U=;
  b=TAsSeu1y/GqGZyExfG+yO6YLA8Fr1ek0Q/5TJ5wiIphcl+ahvf9pKGWW
   Zql0cGS42zIwIlslMH/nNProGfkMvlCyBJgfU6dkKSDIWLL2H63XPSX0E
   mm6ddJi2BKI/KWJjrMHaPgigw7SzhcF2PbHC3ieaq7K/fwyXENC4VYlMF
   E0w6OOWUAIxyUa+UZLPaWTndfHNGEV/NC2ugOQrdSkdBP7J+0T3JkeLH5
   +vZrJ5Z3BDRTgwmBxS/5kbBq3WHw/dLurSpWQJYWb3e3ZMcnBgr9evVEG
   MYrQZkgcmSEwaQnrXY312grgr3xPBkXfBvClSTew3Ts4iWnWOO1l0dbEz
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="233984642"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="233984642"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 09:50:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="520880163"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga007.jf.intel.com with ESMTP; 26 Jan 2022 09:50:33 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 09:50:33 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 26 Jan 2022 09:50:33 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 26 Jan 2022 09:50:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKJpWJjtwERfoOYXhNk/40PQ6AEGICrffIAitnyilKw4T8lHYpWNlYJ/Z8p30ThWUgzp4sHOIX5MOT0Pgqb3G8NWxSPiB7SE9mpoKtv/qFK7R4PjMiShMp8DTNPXCBlzC+hZqm5d9LYSxH/UkjzoWXjMhSyuNx8TipYwdPOpsLw5Zh0bPK98+/NxoFGaJ9YcnVueXtXb0F2y0m1zL+EIIGBkrlJxU/S1DOXs4oKIi5AHb3CYS6mBeR865frkhi/drTMKOHXJVYijYwQn9lAVaJfkC93krspqjQwKycOrYhL7nzN40+gWZoyfMflPGWjPaO5ShmNnsYu4Yd8yDhDFgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rV2+9UlgW9p5imkB2bydfbLWr47bCgy/Y2mivuedb+U=;
 b=aPxGxGHHJdojfkOGHbTiO3Ac7eFXvmEnoOfWZfhPsiPTrS8T88Xch8u+gKrmpux+kxUksYzQdgpDR2e8RpnM5lrXNti0tUcnDYRFRqLRYsytmcl2x9B/2qUCgxR4ZY4vEDw/WrnXfsCN+HJnZ8iNteqjtP6vMv0tJPQMrbcFGgj+cUlo45EEF9F6NrTAj8jDZwvaXvfTDeixIPwJAOronSwBE8Hg1OshHix9ottio3fgmaAX6JTNVy6JkI2onD5ZEnCcx97Nsd9Q+6axGXmQPXOMDLXT44FYQVzG6JLlnWCyQrTz8qIoyksbQO+4+4Aj18stYIhFp/46WQfQ3q3vyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BY5PR11MB3989.namprd11.prod.outlook.com (2603:10b6:a03:191::17)
 by BYAPR11MB3558.namprd11.prod.outlook.com (2603:10b6:a03:b3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Wed, 26 Jan
 2022 17:50:31 +0000
Received: from BY5PR11MB3989.namprd11.prod.outlook.com
 ([fe80::84ed:3779:6e11:e187]) by BY5PR11MB3989.namprd11.prod.outlook.com
 ([fe80::84ed:3779:6e11:e187%5]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 17:50:31 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>
CC: "Widawsky, Ben" <ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH v3 1/6] libcxl: add GET_PARTITION_INFO mailbox
 command and accessors
Thread-Topic: [ndctl PATCH v3 1/6] libcxl: add GET_PARTITION_INFO mailbox
 command and accessors
Thread-Index: AQHYDKjeK5KvLkG3lkKVCcj2hXBmGqx1hEKAgAAIkACAABRHAA==
Date: Wed, 26 Jan 2022 17:50:31 +0000
Message-ID: <a5e954fd6f116817af72816a92858166d265a23a.camel@intel.com>
References: <cover.1642535478.git.alison.schofield@intel.com>
	 <2072a34022dabcc92e3cc73b16c8008656e1084e.1642535478.git.alison.schofield@intel.com>
	 <CAPcyv4jde6kd1oT2ZEoGWDiB1E6QX2pYzSHWr=38jtY6XB5ATA@mail.gmail.com>
	 <20220126163756.GA887955@alison-desk>
In-Reply-To: <20220126163756.GA887955@alison-desk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.2 (3.42.2-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbb01135-a401-44c3-1035-08d9e0f458c7
x-ms-traffictypediagnostic: BYAPR11MB3558:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <BYAPR11MB3558DB07C8A7E805DB3423B4C7209@BYAPR11MB3558.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dJdEND6QzsRN00H9JEIJoOQWRApuhYk567vHr/Q/IS1r8cL9lEHn5NjHFIqwO6z/EvB6GyjZM9KlXzB/R7N7n94Oa2buDeeOfNumvdXY39lnASc+imYGTXBDhHk1AAOknnzAaU7vv/tTZAbnzz2pDf2bGlMMWlmQxWWB8y89IRK2EDeztRHdvKELiKaURuVG1tDjYIlBZiuYlpg3Y32ahjx10MhC/R97vntP92w6azDEqOUuzZSOlf666AKw6LQqwz/7XJHhqkONQFFCqlkKgUinhoDIQnvnapWL/iSrSg++0XPfsH0tMSh9rRwEOg66Cx0lr9Cw7b2p2iJVNLdrJ5xZNgXpTIAIxT5ZdwzLE4liN1QtrOr7x9r95KtNQdw5naVw+uIt1PZrKF6VVyt2VUTDAyQnVoltpQ6zcJolMcAh1IgdXFF3fxydh8kR3cn4kDQOIR4aPV18/D4Cvuvg9qAmMKgMEkJp+Mf6MkagsYMJ3GV+ETaQxVzhRv1DB0FE4MCvmCc2eQTJonvLCqPZQtReR4+pK4fUrzLxbRZ51uwR1aTdXJ//qFLgsBDhXOIHcaaMTV8rE0EPGqshnLihTjro08GsTMn0onK8NPvRZRhDnXJcPiAkeN3/2ZzrZfzNPo6abCBAhGxhmhMUb3jKFJO2QmG5ncSLK2VxDCGoXdcVdE3WLz8DWPhAUPy/og5Rv1CE9xMKbC9otkkoqxZlbwYfWa9k9qZ7QtyeFNfYIPPcLQqmVUV4WxLbt1jkjlnJkGmdLXqC9SUXJX8XpnYl8RU0ZVFrVHWxSjKxeh+GKHU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(26005)(6512007)(5660300002)(2616005)(86362001)(38100700002)(2906002)(53546011)(66476007)(66556008)(4326008)(71200400001)(82960400001)(83380400001)(186003)(66446008)(64756008)(66946007)(36756003)(38070700005)(6506007)(54906003)(110136005)(6486002)(8936002)(15650500001)(316002)(508600001)(76116006)(8676002)(966005)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzRXUkpkUFlYS1BGWTQ3ODhkUnZVcTBaUGZtVkZUZlIzcGNxaHBhak9iZmJT?=
 =?utf-8?B?bVZJSmtqLzNESHpOeEhzczFjeWJlQytJNGtCeE1vWCtjcHgrbVpaY0NWMXBJ?=
 =?utf-8?B?QXMzSlYvcS9nTWNObDNUMGVGQXZvQ3JhbVZWd2pWSDhDbThNYkZpZVc2TmNZ?=
 =?utf-8?B?WXRENllHSkw3YlA5YXZ3V2RGUWFxWUREMWxoYjJ6bUxNUkxUUDJFeHlCWjNt?=
 =?utf-8?B?WXJ4M3FYSEFuOUVQM2x2WlhZLzZ0dEV1clRHMmJMZWZxMUZUWXM5d2FIWjhO?=
 =?utf-8?B?U3NvMHE3bDFIZ0loTWIrcEFzODMyejVOeUNqOVJBcDVwMDZXK3NHdGQ1NjJ2?=
 =?utf-8?B?QzI5c3h3NDF0bkF5YzVaNEFuSDM3Y2YxMGt3MVBla1Q3U0t4ckJma0hCajJ2?=
 =?utf-8?B?VGZYTytGREwxS2FmcnIvUU94blB4cUpIZll5RWtadkNyYitKZnhMZVVpWGg5?=
 =?utf-8?B?YnlZUmJEYWdvam1MQjNKa2FOOVpTTnprNXpCMXUyL1lmTmptNGtESldlK3dt?=
 =?utf-8?B?bnZuY296M3NKQ08xMFA2S1dnSkhUVFkzOEZ1R2RuYVJJelZ5bkFJa2t3VCtu?=
 =?utf-8?B?OHgwU3UyV25HTGU0cnZOQUJjQ3ErUktZQUtBejZIN1V5RXVydlFyYmxjaFh5?=
 =?utf-8?B?K2ZVdVhxMFY5WVBUTHhvcGRyaThEbHY5TFZDUlRyT0N1SnFpb052TDVPbUFX?=
 =?utf-8?B?aTZVOXhRQUJ2eTlzQ2ZoZldGekY5TDl3dXZ0MjA0SzFPT2oyL0dBWGVpTUFy?=
 =?utf-8?B?V0dMZXM1cStsVEJONEVaWmFZSWQyRk02Mk9tdjdia2RCaFVJelJJT2piVGN4?=
 =?utf-8?B?OWpCamtYVGR6Y2tmV0pOQ3NWSFFWV3I0OVQ3a094L0NwdUd6RjVZVWUvN0lS?=
 =?utf-8?B?bjArK2RSZVp1akNZamdIVU0vQTZnQzB1RWUrQzYrOEtkcUdqSDFJVEZYQUlW?=
 =?utf-8?B?d1JDR2FyYWVLS0VWYWM2QVpxVVVRZWJaWlNwS2JqazdVSXhFOVp2MnZ5SVF1?=
 =?utf-8?B?VVJiOHMrdmZVdEk4VXNhMURNZzZPalBOUWFRLzZtQWRTd0s4UThieFFxbzZU?=
 =?utf-8?B?RmhCMG5xdjlGWm9YVHRIcWdHYmRHY2MwNEFBd0lwcDlVSnBTdC9aTUphL1FC?=
 =?utf-8?B?NnlBSnJyNVJTOXQxWVBIbXpabFExbi93SmFZb0wxSmE5a05VYmw0TTI3UExx?=
 =?utf-8?B?blJHbVVZUVN0ODlia1VhaU85ZWJqeU9lRko2N2w2WXk3YTAzMGdYTkF5RFFv?=
 =?utf-8?B?Nk5kc29NL2xqUWlFdE1Yb1VBMGZ4NHdZRERSdkprVlJxd1dzLzVRaG1xaDJp?=
 =?utf-8?B?bENERVJWWG14L2ViWHRtbXROM0NkYndPQmFPSndSakQ5Q2trbEZidmtjRlJH?=
 =?utf-8?B?aUh2M2ZMdmdlRkQ3ZGdScHFKcHA1eFR6QmpQR2FmRFhtd3FQV0hLeCs1ZCtB?=
 =?utf-8?B?cVNSblVNR1AyQWxuaWt2ZWNKYU9rUFpQSVo3VzIza0lMdmV3ajFZcmE2cmNq?=
 =?utf-8?B?SVR1bXExQXZSbVZlRWdQRDdkRSs5Vm9ZM3BSL3BJWG1IWDFVRFpzTlhsL2dZ?=
 =?utf-8?B?M2c5OVkxZ01OczEvWkxuRWRCNS9pbktnZEttZVJyUlkzUjU2b05RZ0RxMk1t?=
 =?utf-8?B?aWR1UzJJc0VaRWxtNnRxbnpkeHQ1YmxwZ01icFhVYjR0UUtKWUUxdG9VRXdW?=
 =?utf-8?B?alVrLzNERVN5Z2dRcHV2S2p0cDRGYnEzSXBRY1RBVFpCMmYvL0pXNG1TQVlG?=
 =?utf-8?B?L01DMFlMR05tVmRvVG1teCtqYkdjT2FpVmZOWk5jYnY2MTk3NVRSelV4M2Jx?=
 =?utf-8?B?NUM4YXZ4cWtEMUxyOFZmY0F0VjJEMWswcVRhQTdPMkxJK2RERmZOcXFQaTNM?=
 =?utf-8?B?TGJkenArQlkzSEFKN0tMRHdXWlB0MUpzMFhDVXMvVXNlYmFJS09vQWp4cUxv?=
 =?utf-8?B?Ym0waWliZXRMOUJmbC9sbmpJTnpkbityOHMyV1lCNUZSNnlRdG5qNjFyUGZ2?=
 =?utf-8?B?MWEwV1FQQkR0UkttQXFsTm9hRmVncDRLaXAvLzFRU0ZGeVhvYWE1S0NNekFE?=
 =?utf-8?B?VW9VQmFnL2hjZHplODU5c3JnNWpUeUtwT0R0YytJL2k3YjN6ck9HbkFzejRu?=
 =?utf-8?B?dkpndHRnRHY0Tno1SmtSN25Xc1h3dWVDL2N4aGE2dHpLeWNRRjJtL1ZYZTYy?=
 =?utf-8?B?dVk5eUlBM3NMQmRZVmlVcnFYajlTNjJ6S3NPdlpLS1V0ekdqeER3bmlNUjF2?=
 =?utf-8?Q?GcpJO0ZjueUZV9AcZy7ASsgA3qJcD+XiHd5hVHv19o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCBA7094BF0BAD4C84F3388AEDAE13CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbb01135-a401-44c3-1035-08d9e0f458c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2022 17:50:31.4156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sNSwLnQF1WASs3qII6FJ1bl7gaqmjfmT58jiHpucP98ZJqPL+06EY/Dq+6U9StgJM08dK4YmInrZA/SrIKFW3v3hWJ5HDMp5YFxxnVPpMYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3558
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIyLTAxLTI2IGF0IDA4OjM3IC0wODAwLCBBbGlzb24gU2Nob2ZpZWxkIHdyb3Rl
Og0KPiBPbiBXZWQsIEphbiAyNiwgMjAyMiBhdCAwODowNzoxN0FNIC0wODAwLCBEYW4gV2lsbGlh
bXMgd3JvdGU6DQo+ID4gT24gVHVlLCBKYW4gMTgsIDIwMjIgYXQgMTI6MjAgUE0gPGFsaXNvbi5z
Y2hvZmllbGRAaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+IA0KPiA+ID4gRnJvbTogQWxpc29uIFNj
aG9maWVsZCA8YWxpc29uLnNjaG9maWVsZEBpbnRlbC5jb20+DQo+ID4gPiANCj4gPiA+IFVzZXJz
IG5lZWQgYWNjZXNzIHRvIHRoZSBDWEwgR0VUX1BBUlRJVElPTl9JTkZPIG1haWxib3ggY29tbWFu
ZA0KPiA+ID4gdG8gaW5zcGVjdCBhbmQgY29uZmlybSBjaGFuZ2VzIHRvIHRoZSBwYXJ0aXRpb24g
bGF5b3V0IG9mIGEgbWVtb3J5DQo+ID4gPiBkZXZpY2UuDQo+ID4gPiANCj4gPiA+IEFkZCBsaWJj
eGwgQVBJcyB0byBjcmVhdGUgYSBuZXcgR0VUX1BBUlRJVElPTl9JTkZPIG1haWxib3ggY29tbWFu
ZCwNCj4gPiA+IHRoZSBjb21tYW5kIG91dHB1dCBkYXRhIHN0cnVjdHVyZSAocHJpdmF0ZWx5KSwg
YW5kIGFjY2Vzc29yIEFQSXMgdG8NCj4gPiA+IHJldHVybiB0aGUgZGlmZmVyZW50IGZpZWxkcyBp
biB0aGUgcGFydGl0aW9uIGluZm8gb3V0cHV0Lg0KPiA+ID4gDQo+ID4gPiBQZXIgdGhlIENYTCAy
LjAgc3BlY2lmaWNhdGlvbiwgZGV2aWNlcyByZXBvcnQgcGFydGl0aW9uIGNhcGFjaXRpZXMNCj4g
PiA+IGFzIG11bHRpcGxlcyBvZiAyNTZNQi4gRGVmaW5lIGFuZCB1c2UgYSBjYXBhY2l0eSBtdWx0
aXBsaWVyIHRvDQo+ID4gPiBjb252ZXJ0IHRoZSByYXcgZGF0YSBpbnRvIGJ5dGVzIGZvciB1c2Vy
IGNvbnN1bXB0aW9uLiBVc2UgYnl0ZQ0KPiA+ID4gZm9ybWF0IGFzIHRoZSBub3JtIGZvciBhbGwg
Y2FwYWNpdHkgdmFsdWVzIHByb2R1Y2VkIG9yIGNvbnN1bWVkDQo+ID4gPiB1c2luZyBDWEwgTWFp
bGJveCBjb21tYW5kcy4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQWxpc29uIFNjaG9m
aWVsZCA8YWxpc29uLnNjaG9maWVsZEBpbnRlbC5jb20+DQo+ID4gDQo+ID4gTG9va3MgZ29vZCB0
byBtZSwgeW91IG1pZ2h0IHdhbnQgdG8gYWxzbyBhZGQgYSBzaG9ydCBub3RlIGFib3V0IHRoZQ0K
PiA+ICJjeGxfY21kX25ld19nZXRfcGFydGl0aW9uX2luZm8oKSIgQVBJIGluIHRoZSAiPT09IE1F
TURFVjogQ29tbWFuZHMiDQo+ID4gc2VjdGlvbiBvZiBEb2N1bWVudGF0aW9uL2N4bC9saWIvbGli
Y3hsLnR4dCB0aGF0IEkgc3RhcnRlZCBoZXJlOg0KPiA+IA0KPiA+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL3IvMTY0Mjk4NTU3NzcxLjMwMjE2NDEuMTQ5MDQzMjQ4MzQ1Mjg3MDAyMDYuc3RnaXRA
ZHdpbGxpYTItZGVzazMuYW1yLmNvcnAuaW50ZWwuY29tDQo+IA0KPiBXaWxsIGRvLg0KPiANCj4g
PiANCj4gPiBOb3RlIHRoYXQgSSdtIG5vdCBhZGRpbmcgZXZlcnkgc2luZ2xlIEFQSSB0aGVyZSwg
YnV0IEkgdGhpbmsgZWFjaA0KPiA+IGN4bF9jbWRfbmV3Xzxjb21tYW5kX3R5cGU+KCkgQVBJIGNv
dWxkIHVzZSBhIHNob3J0IG5vdGUuDQo+ID4gDQo+ID4gVGhhdCBjYW4gYmUgYSBmb2xsb3cgb24g
ZGVwZW5kaW5nIG9uIHdoZXRoZXIgVmlzaGFsIG1lcmdlcyB0aGlzIGZpcnN0DQo+ID4gb3IgdGhl
IHRvcG9sb2d5IGVudW1lcmF0aW9uIHNlcmllcy4NCj4gDQo+IFZpc2hhbCAtIEkgdGhpbmsgdGhp
cyBzaG91bGQgZm9sbG93IHRoZSB0b3BvbG9neSBlbnVtZXJhdGlvbiBzZXJpZXMNCj4gYmVjYXVz
ZSBpdCB3YW50cyB0byB1c2UgdGhlIGN4bF9maWx0ZXJfd2FsaygpIHRoYXQgdGhlIHRvcG8gc2Vy
aWVzDQo+IGludHJvZHVjZXMuICh0byBzcGl0IG91dCB0aGUgdXBkYXRlZCBwYXJ0aXRpb24gaW5m
byB1cG9uIGNvbXBsZXRpb24NCj4gb2YgdGhlIHNldC1wYXJ0aXRpb24taW5mbyBjbWQuKQ0KPiAN
Cj4gU28sIGEgdjQgcG9zdGluZyB3aWxsIGFwcGx5IGFmdGVyIHRvcG8gc2VyaWVzLg0KDQpZZXAg
dGhhdCBzb3VuZHMgZ29vZCB0byBtZS4NCg0KPiANCj4gPiANCj4gPiBSZXZpZXdlZC1ieTogRGFu
IFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+IA0KPiANCj4gDQo+IA0KDQo=
