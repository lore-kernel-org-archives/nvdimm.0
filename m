Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8D9174DB
	for <nvdimm@lists.linux.dev>; Tue,  9 May 2023 19:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683660232; x=1715196232;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=gMkCU2TN6euAw1wlAh+Xwgd1IqZWebbnW44NB4nfijQ=;
  b=Sx6rm1X3eQ9gpC4hNx0lhdOmT91QCkQ8BHL8vZ9PHBIzGFwkuy34uXMk
   Srm5hTFClrienKM3LgoGudWlbZktYxJg9qTKQ1HDNSQ+9twWjZQT5EzyN
   Vx3NbFpzzjOb+Tbkrrz7bYFSfUeR0yN3nvdq4hagwN1SvVnYdKfvQn+gO
   +Q0YjCzrXT4WDv87JawMUQrMleGat++ylPmsNGMS/lXbvyjISmerVVd+M
   d71CBotF6nI6xT3l6zOSwxQeQzRu9zR5HpDbHnC03ThgBsF+K72yoih8G
   1if4dme/iyi8zNiE8nhDlzIRJsNNOFo050/ZlQ2a4kbWXXUo+GEz6Q/sh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="347496708"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="347496708"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 12:23:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="873307750"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="873307750"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 09 May 2023 12:23:50 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 12:23:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 12:23:48 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 12:23:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8xru3QKWvT0LEFHu89KZ78KnGwr8VNFKNN4qiDSr/L92oMw3AhhhPrDmnwAsMaZo3bBJc6dx9jHnB1Lq8JeVCWDL39W3/L4XeL4kFBiEjlDwdUffjdAT9ra5HR4phzLoFyN/fGGZRGJNtO4Y6cyKRmoSrbBgNfS7LaHctUllgD8rX+1G3PiSMiJoYWnxGXT7gzCe1J/JsBSe55NQn3EZ9HOyul2C9e/RDs8Q6Ew+Na35aSPyWsGH7ewE62AX7lD6l+pSNja4WbWnzOd6wX7uJKa0YTemOsrcfujr1w8vWMy2plGCf+KMepCECmGcQ1053VzMjAO8yj2EJWq/rRyEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gMkCU2TN6euAw1wlAh+Xwgd1IqZWebbnW44NB4nfijQ=;
 b=hy3fq5c4gUhdPfmWzBaGU5hQzWQ8/wYi2O8L1Px0X0BGTP24NJyQtTEpeiVRh1v2oBLG3bSemwxsQWJt4MYmdGiDxVpCLSAuOCOj8UjGKcCPMwgHDn5aQ7ruqeyMEEqvgfiQgRXQaVV1skAEpp+2amaGaYy/Cvvtv7cue0MAOgLyNIirVWM2U7vvOyjmJAnRPvwbGtZGk9fDYPdD7IO54OS3MpLjB4MPL7puYjTbas+ulksiPlEV52FbGd/Sq97Q5ZtODRVRShE3lyKLj6RrgoOmgnb0UPwHZauQGWeBECpHXBnQoDl1zwjNGmrKisK3LsPC059izgdSrC3TiF5Ehw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SJ0PR11MB5661.namprd11.prod.outlook.com (2603:10b6:a03:3b9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Tue, 9 May
 2023 19:23:47 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::c1d2:a32a:f7ef:1803]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::c1d2:a32a:f7ef:1803%7]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 19:23:47 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "minwoo.im.dev@gmail.com" <minwoo.im.dev@gmail.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: ndctl-v77: LIBCXL_5 not found
Thread-Topic: ndctl-v77: LIBCXL_5 not found
Thread-Index: AQHZgotJmOL92zSXcEyfc3i38LOaka9SUnSA
Date: Tue, 9 May 2023 19:23:46 +0000
Message-ID: <0009d65b83ba5bfdfc022aee5fc900b14657f816.camel@intel.com>
References: <ZFpnIICkh3Wpqmn/@minwoo-desktop>
In-Reply-To: <ZFpnIICkh3Wpqmn/@minwoo-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SJ0PR11MB5661:EE_
x-ms-office365-filtering-correlation-id: 4ac0ff30-b7bd-495c-717e-08db50c2e933
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kPhNfjn4mh3JPKbKOCQzDhJdeV4Pc6J5ularNL9UQydQHm5VQr3uQjttNGgdTZAXVQvH+xeu3Yu5WzztUHhqZ8kKQOBY8r8AGBAblLx/34h37n28NtHau8Ti4jK/UIiVJmZcV2290a9s+HUbRIta79jjQgq1uKobY4Bh8RMjiH7I4Sxemt1ldSR9M8n97PfL5mt4TyIArM8ni1xa9pxLfYiOBRwTeMpGJizz0a9zFoy7rL3UKt6aY2aFHTe+KgLnrreVWD1rd7JY5aIQIjoo4/UgsG5OoZYbOEot9Aw/8xaGS1HCVu8wZewld90yvfezxCjkpz555LugulN1Q28i8NeTN1gVI7vg2AiyAJwQREP9P0JUXMUbBCG5W5Yn+BfNzybwX05eKdyZEs/xMbIB5FGu228gt/LRMWPybgkRD9wkqA+iLuRZn1YFYrvuOwDmIN8THHkgJt2+5GL8qX9Uu7XM9WMBU3jucQKgpGaZanE7iKNHm3Q2xhCiUE9ncFhRTR5uSeC05qq371f61sJK409f7W05avsQyjcGDADuEo9BrmQq8Rug5pnk+UVtwLX2ZOM3hzG1Gt+LDHN1z9EKLcY4WhTKEKW3deODmUbqcNk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199021)(966005)(91956017)(71200400001)(2616005)(110136005)(6486002)(478600001)(6506007)(6512007)(26005)(186003)(36756003)(38100700002)(66556008)(122000001)(41300700001)(66476007)(38070700005)(2906002)(82960400001)(66946007)(64756008)(66446008)(76116006)(5660300002)(8936002)(8676002)(316002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWxVcU1YWWY2Z25uWUk3dmFJS2N4NDlWM25BYjJtRVluOEhvSEtsbGpWZW13?=
 =?utf-8?B?cDB2THp6OGFSM0lJeitRZ3JOZTVTYzlabTBVNU1ETEdhZE9vd2lhVm9URmtZ?=
 =?utf-8?B?UmtHUzMzZklCTklxRGZZOStxNXp1NFZ4SHV4cW9CdmptaUJieFFlb0lqSnFi?=
 =?utf-8?B?MDRaUlcyOWVRMXJZVStuWGpCb2RYUFlrRzN2NnpJMzFhUDgwb1ViOGZXZTVS?=
 =?utf-8?B?MklreEhTYjJhRGc3c3FSY1ZTVkExRm1MaGVBVjVjQkxPdVE5NENOcFZ0b0gr?=
 =?utf-8?B?elBUcXIzTjZsMzMwMGRTQWd5RXFNcWREdGxvR0dMRTVaNHF6VW0wRXdLaG9M?=
 =?utf-8?B?UE5ZWlYrUVhXaVBHNDZQNGtQMTBuTFp6NGpIbE1TNDVMbkxOanBoWVJHNGcw?=
 =?utf-8?B?c0xVQjhwZTAyUUlGenl0VnNJMWRnOUpxR29CdzdNOU9KRUNMRSs0R2J1ajlj?=
 =?utf-8?B?TjA3WnBLZXJQRWcwR1J6UW94SEFOZFRRMXVZODRTdVlaMVBpa0kvOXJmNVlx?=
 =?utf-8?B?NkRzZ0ZOSng5SHd1T3ptUzlZMUI1NitOSWlJajBhdnowMjlQVmMrS1RBenpE?=
 =?utf-8?B?dko5ZEZLa0U4R2M1Z1NkSUVKdHNJYXNGZGQ1dEVYcHRpTGJoYXo5LzN6aThG?=
 =?utf-8?B?ZFFjejU3eHBCUFBqZXJnOTJFdldtYUZYL1NaOEZhbkhySXZqL3ZrczhEekJK?=
 =?utf-8?B?WC9kc3pmS0hUdTlaVzRXV2M5VFAxQ2M5MDc1K1R2Y08wQ0gwTFA1OTIyOTE5?=
 =?utf-8?B?VGFCTmZESTF6U1RQTGhTSGdIN05MWHduUEZhblRxYnJiS2lqNnhjYXdkUS9w?=
 =?utf-8?B?VzNqS0J0NjVYMGJ3RGMrTWFza0tEaFhCazJrUkRPcENhb0FZa1NIS2Z5MHEx?=
 =?utf-8?B?cnpZakNPTWdjR3Ixem5Qb1I0dis3d2NNWklLWDV0blpvUDFWcUw1Z1lXS05H?=
 =?utf-8?B?OWF0bXZpVHpicXF4YkM3ZFhneFNjckdBUXkvTERlV2owR3VpNTQyYVhzT050?=
 =?utf-8?B?b0VRcjZZQXFyR2Y1QkhvVmhvRmJQaHpFcy9UeEZueDVFcm10YkkxVWYxQUFp?=
 =?utf-8?B?SzBVVjBIQVVyNVAyb085S3gzS0NXcWNMWlptSXhuYTFScy9YYnZYS1VpYXFK?=
 =?utf-8?B?ZXZ2T1NVdFZFeU1ib29hNWovNXR3MjZ1MXlYanNCYW1yRkVZWFJtb3lYaElR?=
 =?utf-8?B?TjVCT0U1R0Y5WGRyeUExTHRGdGZ0WnZxcnlUb1o4VngrQnF5a1RUOXZWWFVy?=
 =?utf-8?B?WDFDd1hmeXpFMHpveVNneHNBUnBvMDdsSmlhMldZV25MQm1lYnZUMWc2bGty?=
 =?utf-8?B?N3VVOVRzdDdLdk02WW1wYjF6L0dVUFh1Z1hWalJTL0t4Wk9lMHBXcVZFOWcr?=
 =?utf-8?B?N1NtcHo4dXBrcU9YNkNwUDZzOVl4TURVZ2R1UFBSci8zNzJQazI5dUQ0YVh5?=
 =?utf-8?B?Ykx0bStXS0JtWjlZL0E3YnBTVTgzdGxkVFRucHh4d1djTmlYWmtJVnNYZlcw?=
 =?utf-8?B?K0xNZ0RNQTJrRDdiRDd4R2JkTGNaUVVrdTlKbkdreWpqK3l2SjhIQ2JRdXRX?=
 =?utf-8?B?RDhwUDZJNCtWUG1pT3BCSEt3VTVTWFJLNWJqYmcxMVRWUVVxd2tseHR0SlJG?=
 =?utf-8?B?OHVIYWVpb3YvaXhDa1VQRVJORWNERXIwWHZqMEtSa1Z5MkMyNzZOc2lRRmNy?=
 =?utf-8?B?R0dtaEl4K3Z6U2pnNGFkY2FieEFhUThWS2RGaU83NFRveEEwWTFVWkJKUTIx?=
 =?utf-8?B?TnAxOC9NZDdQdVV0WkJienhyaWo1bGZtZ3NBbGwwekwyUXloUW9uYTJyb0xu?=
 =?utf-8?B?eDZDZW5KZS8rRm1aZnNFTEFEMFZWOWNKQ3BOTHM3VEhNb3ZWZnRVYlVkQ1FP?=
 =?utf-8?B?ZGRscGxTcEpCanhIaEJHWTFCcGdlTkRxTkdGazN5aU0yOXdqT0JqTjR2SnNN?=
 =?utf-8?B?VWYzY3VkQkcrNENCVUR2OEVkYTRhUmowTkhVb0xSWlRUZjdlbGN0SlY2dUtM?=
 =?utf-8?B?OVRZRVRnMkR1Y0o2MFdrL1dodW9vK1JGdmY4U3pRd3gwTHVjTW9ZSUR2N3Fi?=
 =?utf-8?B?RDdYaXlwUnJpajkvWFlOY3RzcngyaU1BbXRCbHBuRWJudnVNbktiUUYvVXNi?=
 =?utf-8?B?Z0VUd0h0SW9QWGR1bCtiT2hvT1ovU1lsQ2pvRmczQ1VHdGZEYkFDZWgwa3VH?=
 =?utf-8?B?YVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52A36DE7A9B8BB4A98F946AC58BA4799@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac0ff30-b7bd-495c-717e-08db50c2e933
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2023 19:23:46.9116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mmNE5tU9Y8/LPNvdgGFW68adzN0YibF2b4CDiNOCHFc7zrahofuEw5egKAxlibq6ppgxqUqgXlAymsd5UJb72rD1rSvJTPHGyjWbRYQLkMI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5661
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIzLTA1LTEwIGF0IDAwOjMwICswOTAwLCBNaW53b28gSW0gd3JvdGU6DQo+IEhl
bGxvIG5kY3RsLA0KPiANCj4gV2l0aCB0aGUgcmVjZW50IHRhZyAodjc3KSwgYWZ0ZXIgYnVpbGRp
bmcgaXQgd2l0aCB0aGUgZm9sbG93aW5nDQo+IGNvbW1hbmRzLCBgY3hsYCBjb21tYW5kIGlzIG5v
dCBhbGJlIHRvIGZpbmQgYExJQkNYTF81YCB2ZXJzaW9uIGZyb20gdGhlDQo+IC9saWIvbGliY3hs
LnNvLjEgaW5zdGFsbGVkLg0KPiANCj4gwqDCoMKgwqDCoMKgwqDCoG1lc29uIGJ1aWxkDQo+IMKg
wqDCoMKgwqDCoMKgwqBuaW5qYSAtQyBidWlsZA0KPiDCoMKgwqDCoMKgwqDCoMKgbWVzb24gaW5z
dGFsbCAtQyBidWlsZA0KPiANCj4gwqDCoMKgwqDCoMKgwqDCoHJvb3RAdm06fi93b3JrL25kY3Rs
LmdpdCMgY3hsDQo+IMKgwqDCoMKgwqDCoMKgwqBjeGw6IC9saWIvbGliY3hsLnNvLjE6IHZlcnNp
b24gYExJQkNYTF81JyBub3QgZm91bmQgKHJlcXVpcmVkIGJ5IGN4bCkNCj4gwqDCoMKgwqDCoMKg
wqDCoHJvb3RAdm06fi93b3JrL25kY3RsLmdpdCMgbHMgLWwgL2xpYi9saWJjeGwuc28uMQ0KPiDC
oMKgwqDCoMKgwqDCoMKgbHJ3eHJ3eHJ3eCAxIHJvb3Qgcm9vdCAxNSBNYXnCoCA5IDE1OjI4IC9s
aWIvbGliY3hsLnNvLjEgLT4gbGliY3hsLnNvLjEuMS4zDQo+IA0KPiBJJ20gbm90IHByZXR0eSBj
ZXJ0YWluIGhvdyB0byBnbyB0aHJvdWdoIHdpdGggdGhpcywgYnV0IEknbSB1c2luZyB2NzcNCj4g
d2l0aCB0aGUgZm9sbG93aW5nIHBhdGNoIHdoaWNoIG1pZ2h0IG5vdCBiZSBhIGdvb2Qgb25lIHRv
IHNvbHZlIGl0Lg0KPiANCj4gDQo+IC0tLQ0KPiBkaWZmIC0tZ2l0IGEvbWVzb24uYnVpbGQgYi9t
ZXNvbi5idWlsZA0KPiBpbmRleCA1MGU4M2NmNzcwYTIuLjY2NWI4ZTk1ODE3OCAxMDA2NDQNCj4g
LS0tIGEvbWVzb24uYnVpbGQNCj4gKysrIGIvbWVzb24uYnVpbGQNCj4gQEAgLTMwNyw3ICszMDcs
NyBAQCBMSUJEQVhDVExfQUdFPTUNCj4gDQo+IMKgTElCQ1hMX0NVUlJFTlQ9NQ0KPiDCoExJQkNY
TF9SRVZJU0lPTj0wDQo+IC1MSUJDWExfQUdFPTQNCj4gK0xJQkNYTF9BR0U9NQ0KPiANCj4gwqBy
b290X2luYyA9IGluY2x1ZGVfZGlyZWN0b3JpZXMoWycuJywgJ25kY3RsJywgXSkNCg0KTm8sIHRo
aXMgcGF0Y2ggd291bGQgdmlvbGF0ZSBsaWJ0b29sIHZlcnNpb25pbmcgcnVsZXNbMV0uDQoNCkxJ
QkNYTF81IHNob3VsZCBiZSBhdmFpbGFibGUgaWYgdGhlIGxpYnJhcnkgaGFzIGJlZW4gcmVidWls
dCwgaXQgc2VlbXMNCmxpa2UgeW91ciBjeGwgdG9vbCBpcyBwaWNraW5nIHVwIGFuIG9sZGVyIHZl
cnNpb24gb2YgdGhlIGxpYnJhcnksIG1heWJlDQppbnN0YWxsZWQgdmlhIHRoZSBwYWNrYWdlIG1h
bmFnZXIgb3Igc29tZXRoaW5nPw0KDQpDYW4geW91IHRyeSBhIGZ1bGwgY2xlYW4gcmVidWlsZD8N
Cg0KWzFdOiBodHRwczovL3d3dy5nbnUub3JnL3NvZnR3YXJlL2xpYnRvb2wvbWFudWFsL2h0bWxf
bm9kZS9VcGRhdGluZy12ZXJzaW9uLWluZm8uaHRtbA0KPiANCj4gDQo+IA0KPiBJdCB3b3VsZCBi
ZSBncmVhdCBpZiBhbnkgZm9sa3MgaGVyZSBjYW4gcHJvdmlkZSBhZHZpY2VzIG9uIHRoaXMuDQo+
IA0KPiBUaGFua3MsDQoNCg==
