Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE40C5D8
	for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 19:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676489827; x=1708025827;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=urTEOinwUao50egFqwHY8ScPbLSAlvtSJ09o6rCWDU4=;
  b=czPmWNc4I3e02KE/5jgfzU5vcvhYEMd6/D+saJFkP2H2zfHAaR6Fj8dq
   BCruSRNYyN67FKeh1vgVWwaJOSss7PIsnzKf9aYFwrU9JMSmPNjALc5fP
   VSws8+xn66M5VGofacTKATRtnPSCN2zLfQNPR8m9h/OSHOLtQtHiZlD0V
   wViQJYaF/bAKSzp3LIhhih7+mf9DcCjNWy7zMwtSJ47Jv1ljza67LJXqu
   7uaU0Ca+4MXE2uN0MZqs6D3SM68XW/pqOXxlLTVy+BikB178Awe5uhjq4
   tl/leNXFJQMjAiK/AUh82ulajJ9xMhdNpXxGI8dpIwxFFwXWPOdkeXB1j
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="311153258"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="311153258"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 11:36:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="619683805"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="619683805"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 15 Feb 2023 11:36:51 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 11:36:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 11:36:50 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 11:36:50 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 11:36:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FHSTAa/FutbMmGjhtQk/7sahDpy18mt+cNyWg+f1PW/zHyzJzJ9RgBMGhvZz3yXmtGGB9YJDZv2EiCOncq335tE40gPzDVgFGPDCCzwYpo/8RIoz1udrE0y1j8GyQ11ORObkz0V5afbUw3sydbAzjKwMLQlixaianPc+KDDRFp5Zm/3EG92m2KFTxVBTt3TSebsjuQ5hlM2abRYlC0LJe7gJTyfx6IfA3zcCd5Rl4aOsojf2XwCkY+PyKdE0oqUSy3fi6JJTzpzxdjcPZ0opWG0Z0m0AoJiH+cyfc0vlZHS5qBnFj0bILZRs4IpmulD1VFzDJMh2g0n1+VgEfnAbkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=urTEOinwUao50egFqwHY8ScPbLSAlvtSJ09o6rCWDU4=;
 b=K+6340uItvQVM/dtQH2DuqpVcT0XtOr6fauFHyVBZJ+lXKDMND9XdQhaCpvQN94av9vVjtiH7Az1e4gbtwQ+IcL5OhJ0CUueqgSkp7OYseEvQSpTo6fCCFaIJkHiCOIYcwoJG8TBCFrwRaHSTQ+hiBBmfIRRK0mhVkhPUCTeaVI7ia/BWUhtH9GXtT9gBj2O7DzNgXjCnVErhTO8YssP8tESkx3JYOhcKkyUJzbJL60VtHbwED92/7uPg6CqkP1piMMl9Vu8VVGMzPMQSi94w28loDvQNdPk9n7rGn0am+ZrCNUaja7TwEDBRNUnV38i/D0ZLWjCGIGkwVq8eI0VUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by DM4PR11MB6215.namprd11.prod.outlook.com (2603:10b6:8:a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 19:36:48 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627%5]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 19:36:48 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "motin, alexander" <mav@ixsystems.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [ndctl PATCH 2/4 v3] libndctl/msft: Replace nonsense
 NDN_MSFT_CMD_SMART command
Thread-Topic: [ndctl PATCH 2/4 v3] libndctl/msft: Replace nonsense
 NDN_MSFT_CMD_SMART command
Thread-Index: AQHZQV3IJPev/BqJdkWSF7C+dd1rjq7QZuMA
Date: Wed, 15 Feb 2023 19:36:48 +0000
Message-ID: <261ba9c4bbe2321f7fb0a80097209ac3ff5c7544.camel@intel.com>
References: <20230215164930.707170-1-mav@ixsystems.com>
	 <20230215164930.707170-2-mav@ixsystems.com>
In-Reply-To: <20230215164930.707170-2-mav@ixsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|DM4PR11MB6215:EE_
x-ms-office365-filtering-correlation-id: 7d78b1b5-94a6-4e81-28ec-08db0f8bfaaf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0jLmK8ST/JxPBPw5h0b5yQsUuUQ12cdWTi6SDpwx27qKPisuU0e9v6EgJe37wDzHvaYtjUSjCN9/nsUMt6hI36f2DCe1vooxqbQkONIy4xLaKTXtJrCXNnE8bi/KiqkFta7IzEm3/Kl0y9xF9b1+RCMfJRLi3C5eZ0Vjac5O0iXPfCTC/p9tFHOM/j5VRQyxfGwLEoI96pEfeFTni/IeZBp4LzI2dJfreiC7lE7VrhtPlxaTtyQeQ12SBgebc4ZuPGfcRsUNe6DXj+MaHBlMUGsC7wy3Odz3ZVg+QDHNm3T3FDZXg2+9hsWStv5WIR6xjcGtx4tFRvY8Vy8re4Z9EvMS+OSgrqK6+43NQ4m0i/tXDLuN+EZUZkq/qFAKWiDb9sfut1Ih9TZKJN8woScw+L5Vp2GjApSxLs9/S8Fh5qJIlAKQCHGTrBtIibkkVuhIs7LxvZG/QUKQrox04jbO35OrxZZeCWqNHEh4L3nCwhj+1TcoshNhHvOsm26ikHvdGGXtfAT1Mp1TkSjzqfGzN9xai+RzXMfWbZ1JpHszDHJGjYsZe+1Zjj37EOMHLU8pELsRYX4kcqqG3JkRv/U3YSaWjFiFgKvwuHQZy06oJ0RFAng3Fo3762NgzDJnr01rPklhaFITMP0yBIgvoO3n7No0G6GLhgR52u41na2k180hAmA6K/Ff87luKv7mhC4dvYIOuLaRlp4MnJ2VXbwdhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199018)(2906002)(86362001)(36756003)(107886003)(2616005)(83380400001)(110136005)(478600001)(6486002)(91956017)(6506007)(26005)(186003)(6512007)(316002)(71200400001)(38070700005)(4326008)(82960400001)(41300700001)(66446008)(5660300002)(76116006)(122000001)(8676002)(64756008)(38100700002)(66476007)(66556008)(66946007)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGErbmxaR3JBcHc5aFM4ak9YY05mMzN4SkRXb3Y5VDZaSnFPbGV6YUE2ZklL?=
 =?utf-8?B?RGd3U01YQlRYQ0xhbEVCZDRDUHNScTZGY1R0SmVwZXBnN1U3WWUwMTF3UE5G?=
 =?utf-8?B?MTh6QzBYOVhPajhSZW9ZNWd0dEhpdmRrMzJtNVk4SmdJaFd0SzZKSlZDZWxa?=
 =?utf-8?B?SGFTeVNaZkxPbUlldVdOdy9DUzQwS2I3YlJLd3hrdFZmNUc2NWRkK2FkSDlh?=
 =?utf-8?B?K2JaaVMyRWxOQ2svMjR1d2pJNitjcFA5RXBNc3FGejV4TUxxTnZXYVBRTnVH?=
 =?utf-8?B?TEdpaEJnVmJHa1RmS1RkVzFSSmpBY1JYWGp1NTdnY0o1cFNHVDlwMTVhQlVI?=
 =?utf-8?B?bEEzbmgzVDViM3RwdmlEakdYUE1QWDJuajh2ZkhmWEc1ZDd0MXJBMmxkc1lz?=
 =?utf-8?B?cm1xOUlTVXZWLzEyakVZNS8yWWNPajl1ajhVQ3hJZHducEJnWGx2czFHdWt3?=
 =?utf-8?B?YW4wUnl1Qm1QZVcrSW1jdFF1REZtbHlEanFTSyttZTdEL0k1OVY4cDhmK2t1?=
 =?utf-8?B?Z25XMDhFU2xjUkNXQkZubThtTktPWERKSWdoSVV4Zk9DS2hUbEJiTE5QSGFJ?=
 =?utf-8?B?b3hQZUZnbjdkbVJIVW5waHhOQkdVN29qQytpOC91TGpWNXBwUGh3cEZxRVdV?=
 =?utf-8?B?TzREbWJxYnY2MFV5NEJoQjVKQ3VLcUFNQlUvVk8wT3Zkdys2dmJXdG41WnFH?=
 =?utf-8?B?YjV4QUtIY21FK0VqSWdvc1BTeEM1YWd5UVFnVDE5TDFRV3NJemNBZm13UE5S?=
 =?utf-8?B?dHV5T3NFaTkxVU1zVjQ5RTB4MjViSkI2ckVIcWc5cHJNWlYzSStDSkFyb3VP?=
 =?utf-8?B?T3duU3ZTM2E4Qm1NMHFzNUk2ZTcvYm1RVVBTc3VsQ0RMelloSVE2Z3loMXlX?=
 =?utf-8?B?Zm9scGpja0pzSysyY3VXQi9Za09tVHBWR3NOZmRucUQrUm9aemF4U3ZRem5D?=
 =?utf-8?B?T2dlNitXckdXR0xGM0xKUFhmVnRXSE8wTzdYaUJRT1NUays1TlhJUHR6SVhT?=
 =?utf-8?B?Rys5cVpkTGZEK1dvVGRVTDFONHBTeTZMMS83UWt1L2tzZ0VhNk00NFE4Um0v?=
 =?utf-8?B?cWcySDl6TjhDb2JjTHYvRG1YWXFjbG9rOVQ2UkdqMllvTWRYUTZCQ2NRcUJh?=
 =?utf-8?B?Y1NiZjhMcTBkSTcvNERiQ0Z3NEt4eXBmcytRdENPUUg2Q244YjFVWjBGQVNw?=
 =?utf-8?B?QkFkT0Rhc2tiUC9GdHBMYldmbzRENGFxRzFvWTNhS3VQdTl2bnIzZUt0bWtu?=
 =?utf-8?B?L0V3a1NqMjdTTWxTYmgyd2lwZUt4MENEeWlCZTFtWWcyWjFNVkhiR3d4cEV6?=
 =?utf-8?B?NVlqSGdEMThxVGZKMDhTUDZQcUQ3M1VBUXZXQUZZWmdQUEZ0ZVg4ZTJ2Z1p3?=
 =?utf-8?B?RTg5MlNVWEhPVXM5NGlKMGhRWjJxbndROStiNFlPZG0vZHlsRkNrNUtScVJt?=
 =?utf-8?B?aFRxUFF1R1dodjFKU29aMWNYWmE0OHc5bVBEN0FVZCtRdG1Qd2p4ZlBhYjJ3?=
 =?utf-8?B?SU1ZeWFaWWZVenNlVEVkZUhlbVJJclA3cFRUREZRSFJGdDFvWGlIZ3B6MmNn?=
 =?utf-8?B?TFdoUndleDI5LzIwcjJ4MXhlOWcrbG5MRFdaeGduQjRuQzIzbitOQm02NE1m?=
 =?utf-8?B?Sk5OZU02L1NIRjI5UXZURHhuVGQ5a0puNlFwUTF3VU55Q3YyakUzb0FFMTJP?=
 =?utf-8?B?UTlGTzA4SU1PUkZnRUhiQUwzR3ZZbU1iMFROQXFKbk5oT3E4REZzT3FEUmIx?=
 =?utf-8?B?dEEzd3F4SFRsbkxiUjNpUm9nZVFRb3V0MTZ6UE5USzdhNWZJQ1o5UUpzOXVx?=
 =?utf-8?B?UDV5QzVYb2JhUlIzeGJmQXlKd0pEMGpROGVaQldXK0RZKzR1dXNpQWNwbC92?=
 =?utf-8?B?amF6aG8rVmtMbHBsV1k3S05mUG1acHJXT2dlMyt4WXZFSFFYT0JLQlZSSXVL?=
 =?utf-8?B?VFpVSlFOZzNlK2kzamphNmt4T1o5cTNrVTJQT1JzQUdZME9wT1NvZjEyY2VH?=
 =?utf-8?B?YUZJR2RjOTJVS3NLdzJ6Rjh6Q3k5aVlvb2FPeVFycXBGQXFwK0VqSXVsVnZE?=
 =?utf-8?B?TmRoSVRZZDd4TDBaRWNrQTcwRGIwUHhyMElnSXVYcDV3bU1URTNoSHY1UUx2?=
 =?utf-8?B?THRaUTZvVytQSjVpRzZORWlPend2Uk5heEhOaVlDRHpRVThyM3lTOUN5YnJ3?=
 =?utf-8?B?cVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CBFCCDA9A9CE004B92D3C2A85C95453B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d78b1b5-94a6-4e81-28ec-08db0f8bfaaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 19:36:48.3554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BscU3SnwTDnAAbB1wVSycRmAIeNuj8vOoj+6LKBNcHhZNec1Hk6unP1Y623+pxa/RP+EU6ltnQHeTkOJntyDZwOgRAZ/1A7mnIinYjhbyN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6215
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIzLTAyLTE1IGF0IDExOjQ5IC0wNTAwLCBBbGV4YW5kZXIgTW90aW4gd3JvdGU6
DQo+IFRoZXJlIGlzIG5vIE5ETl9NU0ZUX0NNRF9TTUFSVCBjb21tYW5kLsKgIFRoZXJlIGFyZSAz
IHJlbGV2YW50IG9uZXMsDQo+IHJlcG9ydGluZyBkaWZmZXJlbnQgYXNwZWN0cyBvZiB0aGUgbW9k
dWxlIGhlYWx0aC7CoCBEZWZpbmUgdGhvc2UgYW5kDQo+IHVzZSBORE5fTVNGVF9DTURfTkhFQUxU
SCwgd2hpbGUgbWFraW5nIHRoZSBjb2RlIG1vcmUgdW5pdmVyc2FsIHRvDQo+IGFsbG93IHVzZSBv
ZiBvdGhlcnMgbGF0ZXIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OsKgwqBBbGV4YW5kZXIgTW90aW4g
PG1hdkBpeHN5c3RlbXMuY29tPg0KPiAtLS0NCj4gwqBuZGN0bC9saWIvbXNmdC5jIHwgNDEgKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0NCj4gwqBuZGN0bC9saWIvbXNm
dC5oIHzCoCA4ICsrKystLS0tDQo+IMKgMiBmaWxlcyBjaGFuZ2VkLCAzNyBpbnNlcnRpb25zKCsp
LCAxMiBkZWxldGlvbnMoLSkNCg0KSnVzdCBvbmUgcXVlc3Rpb24gYmVsb3csIHRoZSByZXN0IGxv
b2tzIGdvb2QuIFRoYW5rcyBmb3IgdGhlIHJlLXNwaW4uDQo8Li4+DQo+IA0KPiArDQo+IMKgc3Rh
dGljIGludCBtc2Z0X3NtYXJ0X3ZhbGlkKHN0cnVjdCBuZGN0bF9jbWQgKmNtZCkNCj4gwqB7DQo+
IMKgwqDCoMKgwqDCoMKgwqBpZiAoY21kLT50eXBlICE9IE5EX0NNRF9DQUxMIHx8DQo+IC3CoMKg
wqDCoMKgwqDCoMKgwqDCoCBjbWQtPnNpemUgIT0gc2l6ZW9mKCpjbWQpICsgc2l6ZW9mKHN0cnVj
dCBuZG5fcGtnX21zZnQpIHx8DQoNCldoeSBpcyB0aGlzIHNpemUgY2hlY2sgZHJvcHBlZD8NCg0K
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIENNRF9NU0ZUKGNtZCktPmdlbi5uZF9mYW1pbHkgIT0g
TlZESU1NX0ZBTUlMWV9NU0ZUIHx8DQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoCBDTURfTVNGVChj
bWQpLT5nZW4ubmRfY29tbWFuZCAhPSBORE5fTVNGVF9DTURfU01BUlQgfHwNCj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgIENNRF9NU0ZUKGNtZCktPmdlbi5uZF9jb21tYW5kICE9IE5ETl9NU0ZUX0NN
RF9OSEVBTFRIIHx8DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY21kLT5zdGF0dXMgIT0gMCkN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gY21kLT5zdGF0dXMgPCAw
ID8gY21kLT5zdGF0dXMgOiAtRUlOVkFMOw0KPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDA7DQo+
IEBAIC0xNzAsNiArMTk0LDcgQEAgc3RhdGljIGludCBtc2Z0X2NtZF94bGF0X2Zpcm13YXJlX3N0
YXR1cyhzdHJ1Y3QgbmRjdGxfY21kICpjbWQpDQo+IMKgfQ0KPiDCoA0KPiDCoHN0cnVjdCBuZGN0
bF9kaW1tX29wcyAqIGNvbnN0IG1zZnRfZGltbV9vcHMgPSAmKHN0cnVjdCBuZGN0bF9kaW1tX29w
cykgew0KPiArwqDCoMKgwqDCoMKgwqAuY21kX2Rlc2MgPSBtc2Z0X2NtZF9kZXNjLA0KPiDCoMKg
wqDCoMKgwqDCoMKgLm5ld19zbWFydCA9IG1zZnRfZGltbV9jbWRfbmV3X3NtYXJ0LA0KPiDCoMKg
wqDCoMKgwqDCoMKgLnNtYXJ0X2dldF9mbGFncyA9IG1zZnRfY21kX3NtYXJ0X2dldF9mbGFncywN
Cj4gwqDCoMKgwqDCoMKgwqDCoC5zbWFydF9nZXRfaGVhbHRoID0gbXNmdF9jbWRfc21hcnRfZ2V0
X2hlYWx0aCwNCj4gZGlmZiAtLWdpdCBhL25kY3RsL2xpYi9tc2Z0LmggYi9uZGN0bC9saWIvbXNm
dC5oDQo+IGluZGV4IGM0NjI2MTIuLjhkMjQ2YTUgMTAwNjQ0DQo+IC0tLSBhL25kY3RsL2xpYi9t
c2Z0LmgNCj4gKysrIGIvbmRjdGwvbGliL21zZnQuaA0KPiBAQCAtMiwxNCArMiwxNCBAQA0KPiDC
oC8qIENvcHlyaWdodCAoQykgMjAxNi0yMDE3IERlbGwsIEluYy4gKi8NCj4gwqAvKiBDb3B5cmln
aHQgKEMpIDIwMTYgSGV3bGV0dCBQYWNrYXJkIEVudGVycHJpc2UgRGV2ZWxvcG1lbnQgTFAgKi8N
Cj4gwqAvKiBDb3B5cmlnaHQgKEMpIDIwMTQtMjAyMCwgSW50ZWwgQ29ycG9yYXRpb24uICovDQo+
ICsvKiBDb3B5cmlnaHQgKEMpIDIwMjIgaVhzeXN0ZW1zLCBJbmMuICovDQo+IMKgI2lmbmRlZiBf
X05EQ1RMX01TRlRfSF9fDQo+IMKgI2RlZmluZSBfX05EQ1RMX01TRlRfSF9fDQo+IMKgDQo+IMKg
ZW51bSB7DQo+IC3CoMKgwqDCoMKgwqDCoE5ETl9NU0ZUX0NNRF9RVUVSWSA9IDAsDQo+IC0NCj4g
LcKgwqDCoMKgwqDCoMKgLyogbm9uLXJvb3QgY29tbWFuZHMgKi8NCj4gLcKgwqDCoMKgwqDCoMKg
TkROX01TRlRfQ01EX1NNQVJUID0gMTEsDQo+ICvCoMKgwqDCoMKgwqDCoE5ETl9NU0ZUX0NNRF9D
SEVBTFRIID0gMTAsDQo+ICvCoMKgwqDCoMKgwqDCoE5ETl9NU0ZUX0NNRF9OSEVBTFRIID0gMTEs
DQo+ICvCoMKgwqDCoMKgwqDCoE5ETl9NU0ZUX0NNRF9FSEVBTFRIID0gMTIsDQo+IMKgfTsNCj4g
wqANCj4gwqAvKg0KDQo=
