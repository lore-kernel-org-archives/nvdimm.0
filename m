Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459CA7E
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 21:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657833984; x=1689369984;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=j/PAjhEc1Z3wULzt7nM7TKdI6hCJevlf6rU9kWhOgzc=;
  b=B+zqB3leVw4KLYGy9yNCj5if/3g94f0cyI5ENubbZvEFOsx8NIKN9m9M
   4Y4p+peb3naoYSj6jtZSgNjXzMfQF5FRXZ1f3g1HLbzgjBPopCvmUOY7w
   +vd3BZIihuzywMZzKiqXkK8Cry2TUtLMY83W6ZQA36KEdnxnuFaI/hoJX
   TKmnCmSvZPp0qWqrC91EhqTX64Ek2ZyEwSZusc9LVDCpn6UVJmCvya7CJ
   19GMtxj1rYoeSdjbSMX0LSAWJiFIPn7fZRSmH4YscTXZJmCFqdCj6Iz7O
   Gr6szBwFMTp/EA7ux4dqhOSEi+rrJrzfu1bacleo+AOvvdFdYvoqkBRX0
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="286373320"
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="286373320"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 14:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,272,1650956400"; 
   d="scan'208";a="663938988"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 14 Jul 2022 14:26:23 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Jul 2022 14:26:22 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Jul 2022 14:26:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Jul 2022 14:26:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Jul 2022 14:26:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7WJjLTe1cmGIcSesoty0mhKOaQ8EVOprALhOEM3CqWKds7L8vmWOipM8oSR9HGigfrE8aoxJEtFA3MAT8Fb7j4jq+Uh2RizeJqtVy9RPc7khPqS1wXIznsLgPzSvCjizt2/XhO3pMOvvyCXo1/eBWN58C/COS58mzspygFRUsdQkRbu9+0ZvxM5k97ae2Z58otelsQvbDleevqheIDnbx2eACPAEgoCAGR1VjUYICVasIZgei6QzNsc+og6zflsSWhG9EV2uaJyaLcs2hHMOOdorxiskTva2kwIdmUSbyt7vOsBDRWHVJ66gwYPPsZboXW7NaI5kkmDNaTzREKy3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j/PAjhEc1Z3wULzt7nM7TKdI6hCJevlf6rU9kWhOgzc=;
 b=iSHGESpMfeFkfdzq1eFoaDZkmb9BmoZBrSyzPS4BEm6HY0nbukl8G1jLwtJSPnGWGk/liOsG8HrU5JGZKtUtJbwOB3t7IP9Oyb5ILS5M0736K/HmBYhXbDkWV+v/vmulOvsB8bsOsaUPNQMHHQK9WFVfxnWTh9cgf2WmpEKlttTqUFb6r2K69QtymCAFk/BN/5zZbPK/K8zGy3oEhY57bFS+RbB90P1q2a1J5lnwCXdwjVUikBXfMWJ+OoO1YY0yZ7NrrFb4hTLNRYCE6OsTEncjfTF3AlHbAvUUHqoybonnbFpzTJmzU1SauxaV3LDsRK1HTyuzbun5V3o/PJBmZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by DM5PR1101MB2250.namprd11.prod.outlook.com (2603:10b6:4:4d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Thu, 14 Jul
 2022 21:26:20 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::61f9:fcc7:c6cb:7e17%5]) with mapi id 15.20.5438.014; Thu, 14 Jul 2022
 21:26:19 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Schofield, Alison" <alison.schofield@intel.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [ndctl PATCH v2 12/12] cxl/test: Checkout region setup/teardown
Thread-Topic: [ndctl PATCH v2 12/12] cxl/test: Checkout region setup/teardown
Thread-Index: AQHYl6OW3WC/cACDGk64hZ3vjjgGka1+WNSAgAAFKACAAANyAA==
Date: Thu, 14 Jul 2022 21:26:19 +0000
Message-ID: <df6582c3ab8dbdc8796e2e94725c161c31bc01ff.camel@intel.com>
References: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
	 <165781817516.1555691.3557156570639615515.stgit@dwillia2-xfh.jf.intel.com>
	 <43e12941e3ca6310f18ce8c336a7ad038a1a0a5e.camel@intel.com>
	 <62d08716674ca_1643dc29436@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <62d08716674ca_1643dc29436@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.3 (3.44.3-1.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d02054ad-b4ad-4255-e800-08da65df7e54
x-ms-traffictypediagnostic: DM5PR1101MB2250:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IFLBSHjV2wCyNZzzsRkjNesHegBp/gFzwWQ/s4phFm10oz+PchMPONcRUe6YGfsOa/uejSYYbU0p7YQKhk0z5awSKJs045Q0p86YUAVgAEk7BHP+fx+8AQtq5nEFrguiJLaZ3HqoeZ8aL2qf/xF6G6cTaqHOiDvN6zKaS38hS6gbKctvNw4n3bQ8Lbs4lvX/hFYn9KVRyY6iPO9FzYOn/GL4rmRXk/jIsU/PrcRykyV7f+RiRN1rpZ0djuH1mjB39ff8nWQk5UW5kvGyAqsfGdfcchx/ynokQ+zgwhlrtAIWwYZytXzGctR0rb5xN6YPWhvLopRnfCc8477M/9AxRlXWolNBkfakWXH7BWtYnFnlhNNweNojnfr4wxA93+CRMH7cedlQTWoCYS7hTACKslyhp1efAUGlBqHQdxZUCxWBvrH6MNODfRk9are3af8VuJPk4UrO+oPufMs79rl+xMb6wtRTCqPObkXiP5472HCC03mHQT1NBVpdcjueWvw8PzEknSCyTmYhzb6NDoGiAZX6rZFvM/EJuVn5v3a7pmjhHBYzRzoXoSe7jO5Hb7PgGwdGFE8MPQkqzz8sEwtTc3pR71z6b9MtfLYSKUim4vvzeEE7c/QFFvaRkU/kEn0DhIjaNGKb9JD6T23Ei8DGDaj4SfcZ/IpQoJKdMUIA0C2VbYW7Ct2bbDo4b8sJwSUHElm7TR33HUmvtB+ForNi/4pIWO307WSg2vCkgTO6pCbN3SxY54L3meDHUgX3Lv2TqGYLRiYBEOo4ILjpSH5CHHJaEj6EON/kS15WG2m515eb9jxdBVqQEVySlRbjofvJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(376002)(366004)(39860400002)(396003)(6862004)(2906002)(4326008)(8936002)(8676002)(5660300002)(64756008)(122000001)(83380400001)(86362001)(36756003)(71200400001)(38070700005)(478600001)(38100700002)(6486002)(76116006)(37006003)(66446008)(6636002)(316002)(82960400001)(54906003)(66946007)(91956017)(2616005)(66556008)(66476007)(6506007)(41300700001)(6512007)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dE5zOHJoUWVHb3NlZk9qZEhlL3FlY2oxSk1pblEvcWVFNG5WT1N2eC92QWM0?=
 =?utf-8?B?NGRJU1dncXVQZGE4OWdTYkNKS0ozZFg5UVM0elRwUk1Oak82eUp3QnZGUnYw?=
 =?utf-8?B?RmxOdWh6MEtpd3B2S0l0ODZFQy9Dcm1UcklrRnBLai9JRHNUb25vdzNQOW1t?=
 =?utf-8?B?NzByQzF0N1JIc2E3OFUxbGJTTkJsWnIvYzR4dEI4STNLL1hNaW1qMVk4VWIx?=
 =?utf-8?B?a0ltQnVLa3lpaU9jOStOQnhHZGlTbVJabXQ2WWV3N0dmTktzejhzejRyakRQ?=
 =?utf-8?B?L1NUdHQ1dFNLYU9MYUlXaDQzM2xZcmR0ZkYrY25meHdlL3AzWXgwaUU4aGhz?=
 =?utf-8?B?TUQ4WjZJV1N1WENpU0RHKzE4cWJTOFhSVm42dWUyVlhoUVphdVUyUmpXeWNO?=
 =?utf-8?B?cExkc21XSXpGRUN6c3NpMGo3TUZ4TXl0NEsrYnNqT3lUSHpVY0pZQ3lMUis2?=
 =?utf-8?B?TEVkb2VZUU93cElWOENOSnhuUVdISWxaNm0wZjYvM1JvelRnRmpidXYxaTVL?=
 =?utf-8?B?OXYwM0JzaU1URHZ2aWt1Y00zcExIc29aeEU5dll0a0VZMUI4dTB3cVhCWS9u?=
 =?utf-8?B?aDllemxNRHkxcDVRS1RGQ25KaWZzT3cvcm5MWU1HZUZsUVpyV0ZLOHhHczNh?=
 =?utf-8?B?VEJnUEdnSUpqVkthS1Bwc1BKUHlaMnhzY1Q0d3VpeXg1Q2s0WVdyQ0xlMzdm?=
 =?utf-8?B?bms5aWRza2p2VXI3eS9SeWcwR1crVnJPMEZFSmN4UXpyTGtmVUdYeE4ramxq?=
 =?utf-8?B?dFlBWlphSzhrcTdEc1RMQXJvNDdhZ21RRkJQUnhxV1FqQmRSTDN2K08zRlpU?=
 =?utf-8?B?alVubDhGcWFJNUt2aTNwaWZmVU0xNm1DaEF0UVhGZlFsclViaStKR3BEY0tV?=
 =?utf-8?B?bUtkTnprK2cvYjBHRFU3bXo5SHZoYS9wcWprZ2pNN2czNi9WYUlIMzJ1NFRi?=
 =?utf-8?B?ODVIUCtqS1VyNkdPSG9aUGlMV2F3b1BwM3JWMlNmdkFUQXI1T0hMZHZjYlFr?=
 =?utf-8?B?T1NkK3VqS0hIWExldXN3SUZRVXFKY0RYczlYajRUaDVXY1R0YS9NUWNqVmg0?=
 =?utf-8?B?Rmpsc296N3drZnkyMlk0VG8xSWU2eWZybTJON2JZWmkyUURqSkN3aTJLZ1Uv?=
 =?utf-8?B?K1NDcVcwbjh4ak1zbm0vSXI4YjdvSDRxbTVpL1VNZENQTElNS0JVK3FyWWNh?=
 =?utf-8?B?dEVzM1VjN2FIVUlvV0JVV3RRWkhKTWUxVnk5a1pKYjdkaTRwZmJzYXR4SEFp?=
 =?utf-8?B?ZkxDMUw3MmpRZzBOdE1Lbk5RcEpwTkRCekZubThPYjE1VUFCRFF0SExaRkR4?=
 =?utf-8?B?UWxaeXkwMDBReXd1WE9oWHhLSUxldWMvQUtpL1NVVFdtN29ZWTA0NW9pdjJt?=
 =?utf-8?B?VFFUVndaNmREaC9BeFhYREFjNFVxeXAxQXRBdjVTd24wc2JWUWNJSUFxcVZ6?=
 =?utf-8?B?MFpsVkhhWWI0NCtKN1ZWMmthT1ZFcWlrQlUxN2QvSkVIQVc3V2tndmd6clU5?=
 =?utf-8?B?RkM5U29ZTUVGQm5pNUNJMHRKY3hTN0t1VSsxdFM3NG1kZ2dPdzNnajZoeGRv?=
 =?utf-8?B?MVFaTmhEbGdlc1hWUEhsRWNXUE5tN3hxRGg3UnBOdTNHUmg4NlU3cjR4MTl2?=
 =?utf-8?B?aS9QdjZuTG5iOUYraXBQcWVrOThSdlZxc0Zjd0s2ZDRRYlQ2ZjNxV0lqclox?=
 =?utf-8?B?V3VvV3ZYbWJBanZIMzZHSEZwVXpiY1lGVHFuRVR3NlNQS2Nwa1MwYmN1WUJZ?=
 =?utf-8?B?SjRIaDB4TElBNUlTcU9oL2JhSTUxaVY5SzlUUHROdGcvbWh3WjhsdURCWENa?=
 =?utf-8?B?TzVERzNyU0xDamh3enkwbDRabkFVemc4cXk3TlN3Y3pDN1krc3FMSE1qNGZC?=
 =?utf-8?B?Q2NjM0J4SENLQ3ZnQytxazNkRGxlQXNkNkpMSy9oNUlMc3Y2Z1FzQXIzdHNK?=
 =?utf-8?B?SjVsWmVFWTlmQVRJZFppY0sxaXplaC80Q3o4R2l2M3J5NWZjN0RvN1JleUFI?=
 =?utf-8?B?djhqemJRbFJhbXRwYUNCQmoxMzFXZkpBVFZDZlhURjdodndPTG9YbWxjS0gz?=
 =?utf-8?B?bXgzUUJjUEJ6RHZtK3dKSllrenRndzA5UzV3R1Y3NS9LRjk1U0Vjay9XbHR5?=
 =?utf-8?B?TVJDU2E3SDhzMWJiVnNoVC9PaVBzQ1BGdlBpQk9YV2Y4RWpsNTRNdi9TVTdW?=
 =?utf-8?B?UFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <302996125B2D404B95E5E6383388178A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d02054ad-b4ad-4255-e800-08da65df7e54
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 21:26:19.7327
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1CxWyxHHKSkVnp962qDDcGquPgx/5MVQ6KlojiPsB1ZdGKtxEV2SoWyfp+48P+MkOxZ+SvhjBo61otFpSTclGH0QXGV38tHH7XptvCYHfM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2250
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIyLTA3LTE0IGF0IDE0OjEzIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFZlcm1hLCBWaXNoYWwgTCB3cm90ZToNCj4gPiA+IA0KPiA+ID4gKyMgZ3JhYiB0aGUgbGlzdCBv
ZiBtZW1kZXZzIGdyb3VwZWQgYnkgaG9zdC1icmlkZ2UgaW50ZXJsZWF2ZSBwb3NpdGlvbg0KPiA+
ID4gK3BvcnRfZGV2MD0kKCRDWEwgbGlzdCAtVCAtZCAkZGVjb2RlciB8IGpxIC1yICIuW10gfA0K
PiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgIC50YXJnZXRzIHwgLltdIHwgc2VsZWN0KC5wb3Np
dGlvbiA9PSAwKSB8IC50YXJnZXQiKQ0KPiA+ID4gK3BvcnRfZGV2MT0kKCRDWEwgbGlzdCAtVCAt
ZCAkZGVjb2RlciB8IGpxIC1yICIuW10gfA0KPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgIC50
YXJnZXRzIHwgLltdIHwgc2VsZWN0KC5wb3NpdGlvbiA9PSAxKSB8IC50YXJnZXQiKQ0KPiA+IA0K
PiA+IFdpdGggbXkgcGVuZGluZyB1cGRhdGUgdG8gbWFrZSBtZW1kZXZzIGFuZCByZWdpb25zIHRo
ZSBkZWZhdWx0IGxpc3RpbmcNCj4gPiBpZiBubyBvdGhlciB0b3AgbGV2ZWwgb2JqZWN0IHNwZWNp
ZmllZCwgdGhlIGFib3ZlIGxpc3RpbmcgYnJlYWtzIGFzIGl0DQo+ID4gY2FuJ3QgZGVhbCB3aXRo
IHRoZSBleHRyYSBtZW1kZXZzIG5vdyBsaXN0ZWQuDQo+ID4gDQo+ID4gSSB0aGluayBpdCBtYXkg
bWFrZSBzZW5zZSB0byBmaW5lIHR1bmUgdGhlIGRlZmF1bHRzIGEgYml0IC0gaS5lLiBpZg0KPiA+
IGEgLWQgaXMgc3VwcGxpZWQsIGFzc3VtZSAtRCwgYnV0IG5vIG90aGVyIGRlZmF1bHQgdG9wLWxl
dmVsIG9iamVjdHMuDQo+IA0KPiBZZXMsIHRoaXMgaXMgd2hhdCBJIHdvdWxkIGV4cGVjdC4NCj4g
DQo+ID4gSG93ZXZlciBJIHRoaW5rIHRoaXMgd291bGQgYmUgbW9yZSByZXNpbGllbnQgcmVnYXJk
bGVzcywgaWYgaXQNCj4gPiBleHBsaWNpdGx5IHNwZWNpZmllZCBhIC1EOg0KPiANCj4gVHJ1ZSwg
YnV0IGl0J3MgYSBiaXQgcmVkdW5kYW50Lg0KPiANCj4gV2h5IGRvZXMgdGhlIC1STSBkZWZhdWx0
IGJyZWFrOg0KPiANCj4gwqDCoCBjeGwgbGlzdCBbLVRdIC1kICRkZWNvZGVyDQo+IA0KPiAuLi4/
IERvZXNuJ3QgdGhlIGZpbmFsICJudW1fbGlzdF9mbGFncygpID09IDAiIGNoZWNrIGNvbWUgYWZ0
ZXI6DQo+IA0KPiDCoMKgIGlmIChwYXJhbS5kZWNvZGVyX2ZpbHRlcikNCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqAgcGFyYW0uZGVjb2RlcnMgPSB0cnVlOw0KPiANCj4gLi4uaGFzIHByZXZlbnRlZCB0
aGUgZGVmYXVsdD8NCg0KQWggeWVzIEkgc2VlIHRoZSBwcm9ibGVtIC0gSSBhZGRlZCB0aGUgbmV3
IGRlZmF1bHQgdW5jb25kaXRpb25hbGx5IGluDQp0aGUgZmlyc3QgcGFzcyBvZiBudW1fbGlzdF9m
bGFncygpID09IDAsIHdoaWNoIHdhcyBhbHNvIGNoZWNraW5nIHRoZQ0KYWJvdmUgY29uZGl0aW9u
Lg0KDQpJIGJhc2ljYWxseSBuZWVkIHRvIGxldCBpdCBydW4gdGhyb3VnaCB0aGUgbGlzdCBvZiAn
aWYgLWQgdGhlbiAtRCcgdHlwZQ0Kc3R1ZmYsIHRoZW4gY2hlY2sgbnVtX2xpc3RfZmxhZ3MoKSBh
Z2FpbiwgYW5kIGlmIDAsIG9ubHkgdGhlbiBlbmFibGUNCi1SIGFuZCAtTS4NCg0KV2lsbCBmaXgg
dGhpcyBpbiBteSBwYXRjaCwgbm8gbmVlZCBmb3IgdGhlIC1EIGNoYW5nZSBhYm92ZS4NCg0K
