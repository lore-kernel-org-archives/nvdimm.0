Received: from mgamail.intel.com (unknown [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E371DDC4
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 20:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690836027; x=1722372027;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=3TceIoat2Bo4oQ1oqeEDjDU5TZ9O4m0W3fjk2Hjzf8A=;
  b=EDPv+9r3dRobgY8HPRqKmxORQW+LQhp1+5oET7G8CPi9nXjtpf1FPlue
   qzZNpJ05behkJfrxYcIG/IJUIBzOKfiI5pEx8YH7YQOvGl9EFn6L4m3Mu
   tT1SwNY4Hx7qBZ6SqEeoQNQEvydbwpyFn03Bx0Tgp31qGIs/gEdlLn7Iw
   180L6KrJvVNbIvPsqn8JqjfDnz0D5p+F0el2K/QDXCjfW8tmM8PSPQNxc
   5KLKWy8sUFGvOlDjgLW7je16EufPnoXaZn53YGeZeiF2NjATmNsaDXjN9
   /L9yzjJ5ndTBAbnwhOpEXT2jH11OGmk9I13DPwkz+0Ixz9oGjzsKaat/j
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="348717840"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="348717840"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 13:40:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="763508012"
X-IronPort-AV: E=Sophos;i="6.01,245,1684825200"; 
   d="scan'208";a="763508012"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 31 Jul 2023 13:40:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 13:40:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 31 Jul 2023 13:40:22 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 31 Jul 2023 13:40:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbM7cZlh0k3FZin0BtBWEtjkxQA52He/RUbj8DkUJIBHZv8JZFDw0JdB4DS0M3vwAHeo4ZtY0rv8+599zdJeuQ5eqZWPD94UQV4jeXZRoF2Zm97m7MJxXUYkuevj6/vY/8AiysqTdXNKfGOYKg2BkWJ+Cvikmvr3XGSV3paNl/WVRPkYEOYw77A2DiIt4+kNYBdRvU2pF8x6Nzdn3i4A+i35OZjBx5FX4C883Nj6bZa4r/pcJYDpa4KcEg9PuJx3jdVohuiLHy9HMKMXZqk6469qtuRrcAtUPADsPzAyX6kvZLa2QU/FdCfJBG9gcs34RPq04E/MQViyxpK+yYzbmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TceIoat2Bo4oQ1oqeEDjDU5TZ9O4m0W3fjk2Hjzf8A=;
 b=odidpJv2d773fbdHUnGr/Nud5yRNnqvZS9i6EsXFnROsgGJH640kpAnNn4h6FNTb6K9f7VTbBI+gAcelq2dLyZYtKrOE5EZ3Wb0ZB8x6BfWQ+vlY/RzCyoc47d5WYe88KKON1UO/o/YSSbJCTADucT7vSaGD+VfZSPmkK6EOYxHS/qZx9diLv39pR18Sb6xHL/zEzOrJQInAzSu5z05RPcv/ex4PGgvD6FKqi+j/2JhuGZA0kPTHLF8Er+sjGthO/5n3VkeQrQwu1CbwFEx5rgo+EEdML1C96TknNxu0FE+X11vf3BNnbelcnWn+pGs3/BlOrVbmccT8GK9PXru/FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by DS0PR11MB6398.namprd11.prod.outlook.com (2603:10b6:8:c9::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6631.42; Mon, 31 Jul 2023 20:40:15 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e527:d79c:2bb3:e370]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e527:d79c:2bb3:e370%2]) with mapi id 15.20.6631.026; Mon, 31 Jul 2023
 20:40:14 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl] cxl/memdev: initialize 'rc' in action_update_fw()
Thread-Topic: [PATCH ndctl] cxl/memdev: initialize 'rc' in action_update_fw()
Thread-Index: AQHZw+w1vnoxT8S6kE+N5K/lS9GWQq/UVpCA
Date: Mon, 31 Jul 2023 20:40:14 +0000
Message-ID: <d75cc75a58249bcb5b93a1640d6e3068d8098f2d.camel@intel.com>
References: <20230731-coverity-fix-v1-1-9b70ff6aa388@intel.com>
In-Reply-To: <20230731-coverity-fix-v1-1-9b70ff6aa388@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|DS0PR11MB6398:EE_
x-ms-office365-filtering-correlation-id: cf32a9b0-1ef6-4fca-3765-08db9206582c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: phEqvlEhekaozINyPgI23r/1vCzD2PK9N3MleyiO8rUqRGlcI6e6Ie88+rTJhCvS9+T0yBkbpB7lzEBzY5dH0CFAcgaIo+HK0bnc0QA560jCT8dXDrjRKKMwPa1LkCoeHTr7W+T6tnP5K5KJA8XSymweIq8g8mp0ydeje8HoH8hsin8D4toZme630EdaG6/sbr6/ndAl3WY42lve0jtuy921ZUy4NM8DH4HVNgWFKBQgvE8tw1luWeRYpVk40zUXn/63VDkfKJUOpdVo7UqqAH1zA5JIAHjIDcFc7W78Y40NLRxhcq3+t3seCPQl1Sl4o1ZtBmKrfxVkl6W7bmX7WSdIry/f9n1YdfXD1//Bga+PLVGvdSPE+ZaOsu2oj/C38p2K0+cZl2dZECYINqDs0cU9MmTj2T7sz0oIP3oXKK8lADS7oKvMBD1xtqMHcCkZPyY2ua7A8ZDrvXz/xGoSlUCyb6FHArM9H3JFpz2t5jYTB8aI3XbWoPZrLECnLi/YzjOkVcXjYCGx6IK+qWgtq047jZ+dc8Au3rEoWD9xQ9rFYIMtY0oQ6qsI1j7B1vPy3B18mCphGUGqwmzZ/FX/zJdZ0Ckne+1/bDsv/bfVzKiU/vp6LhzWskrV/tAt49o4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(346002)(366004)(451199021)(5660300002)(66556008)(66476007)(66946007)(2906002)(66446008)(76116006)(64756008)(4744005)(316002)(41300700001)(110136005)(6486002)(2616005)(71200400001)(8676002)(6506007)(8936002)(186003)(26005)(83380400001)(478600001)(82960400001)(122000001)(36756003)(38100700002)(38070700005)(6512007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SE01TkRlbjZwN25EMHFtTXRrU0N1SXhTNmJyVEF0bG0yaDV6bSt2TnI1bXdz?=
 =?utf-8?B?TFBPRVZKdmZ6UUZvQXdObDJxREkyYmZOTFkxcWl1WEFnVTZ1U000blp2WTN5?=
 =?utf-8?B?Y1R5endlQ2d1MEN0U0pySUlUL1pTSjBRSG9lb0xsMzJjcmJOSy9na3pLMjZ2?=
 =?utf-8?B?WHJFZGxhTFh0L3lpeUl5ck9KRWZGY3ZFVGlBbzhnamhNL3VHSlExWDUyQVNG?=
 =?utf-8?B?Rks3ZjVXK1hyOE56eFA1NFVycUFUSFRUbHhSaUdNVk80OFVWOGJFSnN2V2Vo?=
 =?utf-8?B?UGxQR3VndkhyM29mVnNYd2JpMXBHVStnaVpqNEFZQjZNc0Z0V0NxOWJaTitC?=
 =?utf-8?B?c0NUUzFjeVk1V1ExZDM3cjJOcUJHc002QUNtY3NzWVJaeTFVbWMvck9CRlBi?=
 =?utf-8?B?Q0Q5YUI3RC9mSzZaZHU0L2JkLzlUdHdBdHE1Z3k4dnFUaCtSSHl2Qk1wSlEy?=
 =?utf-8?B?SXdwTnJwWGVHeXpjTlY2WXlNVzh6ZFNCb2tjUVFMcXJEZXJ6b0djQ1NCemFj?=
 =?utf-8?B?bnBnY29YdjVkVmJYMXMxakZNRTJ5TWJrdXl6T251Q3ErZ2NjNlE1N2lka09Y?=
 =?utf-8?B?b3RxbEVkdzBJZE1mdnF5LzNBb1BQTkZJV1RSRjVWc0NHYUY2ZEJzbkdmYUVv?=
 =?utf-8?B?ZGVQYks0MDF3UEFaeWFGM2ZjeDN1Wm1lTTEyWE15OEFRdWlWeDVmdS94WFNi?=
 =?utf-8?B?UFdVcUlNQTdiTVNKd3ZhNUVLVExrbndVc0JEYzQ5Sms0RndQOU1uQVBJOWdy?=
 =?utf-8?B?RnF6N05IYjFzNXhCRzk5UVJQZk1ndVl6aUx5eWNMYUZFUXBDa1NJaSszbWpm?=
 =?utf-8?B?M05JQ2Qzc1lFUlVQdHJtaEgxS3FyMHlOOEdwUjEyOEpMUEpZZGFxdkxzOG95?=
 =?utf-8?B?TFYvbVpPeHE3SThsWWtLcnVPSzJKem1PcXRldUEvSmVWeUpaQjQwZ1M5RXVa?=
 =?utf-8?B?bEhaRDAwTWg2SitQSndTaG1pQUNOY3BTN0xnbTdTTGlCK1RROVFLbytjTnA1?=
 =?utf-8?B?RzlFSSthZWQrNGFVaVk2SHZLbHcvL0h1T254d0xMYUo1aVNSa05OT3E4R0l5?=
 =?utf-8?B?UmVaV1owTmVzcUNwNVBIU2w2b3F6THRNM1lOTVRoOWlPWjBMeHhHRTliejBz?=
 =?utf-8?B?L3lNQTN4VmV2bTJHS1hWUndNcVVDMkxUZUJYcjh3TTgyR3B1b05OK0JleXht?=
 =?utf-8?B?UU0wS3JMMUJheDAxbGc0aGFaN1RIeDdXdEhpZEw1bVdXRkhiUzg0NXhUMmZo?=
 =?utf-8?B?UTJkVyt1K1JvQXl5V1FCeVZxZkVQQ0pnQlIzcXBrTGxRVDkvcTllSksrTFky?=
 =?utf-8?B?eW8yUlh5ekF3bzBMcUdCallIRXFWQlBldVVJZWVQb0NmQTZwMjBGNUR5Vith?=
 =?utf-8?B?RzQ5Y3lvM1VIcUhBemxCenBqSjUwNGxxMWdmMzVYM3dwMi9WVVBZY0djQVhr?=
 =?utf-8?B?bC9vOWhjREw2aEdFUGQxT1E0TTdXdERONkt4eUx3eFZ5RnZ1c3QxSkZkRjMz?=
 =?utf-8?B?aWZVMWNaVzRaL0NTSW0zYlNMYmo3MHRSdDdiN2RBNmNPS2FJdDVlYjVTZENz?=
 =?utf-8?B?dm4xRmtaU3k2Z2oxZnlvekxUaThpeGgxbTNhZk8vcFZSOXdaOFpkRmxzcm5Q?=
 =?utf-8?B?a3FTSEJHd2RMS1FxM2xiMUIvVERjVEFpMlZpeTZ5RDhVNms2TGlBNElKNmRU?=
 =?utf-8?B?K1BVRExFL2tHV3k3MVhtU0RnMGtoMTJTTzRvOWtZOVUrQ01CYWFhK1hkdktj?=
 =?utf-8?B?MnBxM0lVZEJtb2ZDakdBQlB0UkJXRmoyV1Fic2hmMTBqWUdYMmlqOGVwc3Vl?=
 =?utf-8?B?VDgrTkJaWElEL25zYmozK0V5ZnNSNG12Qjg5Y0JtenZidC9tbkNoNGJ1UVhq?=
 =?utf-8?B?cVpwdjRGY3lCS0tnWjBwYmgwS2pXNTVCOEZ5Z1FvcHh2WjduUHBqaVlJOHB2?=
 =?utf-8?B?TGJrV0pSUnNJQSs1eURRRHZhM1FKVHJhK1c1cTRNZmI0NWdMV24vYmE1Z3RI?=
 =?utf-8?B?RnFiWE9qSUovOWV2d0lJMHBlYm5oOHpOb2NLNWtVZkRZa2x0OXdEaWV6UEVM?=
 =?utf-8?B?UDFCM0twbzNiR2Q4UkJFaGZYeHFKeFo3QS9WMk5OSllyb2RDdG50Qm5wYkkr?=
 =?utf-8?B?MzVXdDVVMmNVc1c0bzZXYlAza0NILzVXRkdKVndKTllOSGVhZ2NpajlzUmVj?=
 =?utf-8?B?K2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CAAA526AD92F34A9B6C870C18FF27CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf32a9b0-1ef6-4fca-3765-08db9206582c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2023 20:40:14.9206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m2dzxNhw9W7lMcBK0iM3NYWYGnY2+RCETP8THDO6LE/za+dLlNyM01k/38kSfPiR/H5Wvg6vaxAwA9ihxCzD7AlfK4uEkjsDI1Z2n4EXJhg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6398
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTA3LTMxIGF0IDE0OjE4IC0wNjAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
IFN0YXRpYyBhbmFseXNpcyBjb21wbGFpbnMgdGhhdCBpbiBzb21lIGNhc2VzLCBhbiB1bmluaXRp
YWxpemVkICdyYycgY2FuDQo+IGdldCByZXR1cm5lZCBmcm9tIGFjdGlvbl91cGRhdGVfZncoKS4g
U2luY2UgdGhpcyBjYW4gb25seSBoYXBwZW4gaW4gYQ0KPiAnbm8tb3AnIGNhc2UsIGluaXRpYWxp
emUgcmMgdG8gMC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwu
dmVybWFAaW50ZWwuY29tPg0KDQpUaGlzIHNob3VsZCd2ZSBpbmNsdWRlZCBhDQoNCiAgRml4ZXM6
IDY0YWQ0NmI0YTE0NyAoImN4bDogYWRkIGFuIHVwZGF0ZS1maXJtd2FyZSBjb21tYW5kIikNCg0K
dGFnLiBJJ2xsIGFkZCBpdCB3aGVuIGFwcGx5aW5nLg0KDQo+IC0tLQ0KPiDCoGN4bC9tZW1kZXYu
YyB8IDIgKy0NCj4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24o
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9jeGwvbWVtZGV2LmMgYi9jeGwvbWVtZGV2LmMNCj4gaW5k
ZXggMWFkODcxYS4uZjZhMmQzZiAxMDA2NDQNCj4gLS0tIGEvY3hsL21lbWRldi5jDQo+ICsrKyBi
L2N4bC9tZW1kZXYuYw0KPiBAQCAtNjc5LDcgKzY3OSw3IEBAIHN0YXRpYyBpbnQgYWN0aW9uX3Vw
ZGF0ZV9mdyhzdHJ1Y3QgY3hsX21lbWRldiAqbWVtZGV2LA0KPiDCoMKgwqDCoMKgwqDCoMKgY29u
c3QgY2hhciAqZGV2bmFtZSA9IGN4bF9tZW1kZXZfZ2V0X2Rldm5hbWUobWVtZGV2KTsNCj4gwqDC
oMKgwqDCoMKgwqDCoHN0cnVjdCBqc29uX29iamVjdCAqam1lbWRldjsNCj4gwqDCoMKgwqDCoMKg
wqDCoHVuc2lnbmVkIGxvbmcgZmxhZ3M7DQo+IC3CoMKgwqDCoMKgwqDCoGludCByYzsNCj4gK8Kg
wqDCoMKgwqDCoMKgaW50IHJjID0gMDsNCj4gwqANCj4gwqDCoMKgwqDCoMKgwqDCoGlmIChwYXJh
bS5jYW5jZWwpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGN4bF9t
ZW1kZXZfY2FuY2VsX2Z3X3VwZGF0ZShtZW1kZXYpOw0KPiANCj4gLS0tDQo+IGJhc2UtY29tbWl0
OiAzMmNlYzBjNWNmZTY2OTk0MDEwN2NlMDMwYmVlYjFlMDJlNWE3NjdiDQo+IGNoYW5nZS1pZDog
MjAyMzA3MzEtY292ZXJpdHktZml4LWVkYzI4ZmQ2ZTBmZQ0KPiANCj4gQmVzdCByZWdhcmRzLA0K
DQo=
