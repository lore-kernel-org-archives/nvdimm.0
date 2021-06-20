Received: from JPN01-OS2-obe.outbound.protection.outlook.com (mail-eopbgr1410085.outbound.protection.outlook.com [40.107.141.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD87871
	for <nvdimm@lists.linux.dev>; Sun, 20 Jun 2021 23:56:41 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h4O1FWFIF08N6d46CpxhVy2P5ncGwmE+Xi5iNMBmgcADCLm8qT1x71ic4mRynND/7YyzvHjuIJkhLiKDG0eG0QBcVbG4pkhL12ON3mBP7AYgkVub/hUOrBCLLxXoYvrmyE5ILm4vsMLsswmmFP4xZPBJ7HM/wxGqT2lftY1EjcjsCxvSDfL+wieRFPwXWJqEeCIbWm2aCXnD4mTxf3PUEq+jqkhlodHPF/Qhh4wgIP/nxp/YcoojBMBoLR6+aMq55d6t1hEUK4noIt8yGlURbMJD1MoWOusVtc/ak0EFcuoypXMK9b22AwFwVzObpzyGZJgv8wtckUxBPe5wg3wkaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PC7YrNmDWmDT48EE/aZcPpX7l/ITmbOy8enMlQnvph4=;
 b=RBZ7nKnQ+bMW0ibuOC6o0gu8WSm5jQDXgV/eYwomsViPBR64fleNt6tON78M5IBbuu1mjGP8/EI9sUVy3A3fHEBjaWYXKfMh4MtAjIq06vla5Tzf7i+mpluHP4JsIEdH3od8oBReDqm8taY9dv7D2INgNq37ybuhdNMmg9RmRlqaSnQIfbKBIkeF9HOX+bs7vcsNtFzkvB+HQmB2KJWiIyGEN1vKCRIzOoQc95X50ty3fLc3GiMFBOLhu5n2txV2KPWX06vylkQWYQzdMySIAMfXQ4Gkf/hqf8XObeqBIaOg/dgV+NGbrHcnRG2hOqbt2G48qtZY2A649NyYeMMWSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PC7YrNmDWmDT48EE/aZcPpX7l/ITmbOy8enMlQnvph4=;
 b=bwjR/g4R8dxrhRrMEtuvH571sUE9kY36Ga7YhIX8bEPmdevQ2vBIQbF8sK39cOeZ1Xy4mLvIcE8G/NsD8S/feQSeHbSFH2hxr687u8QllRCShk2VYh/gV1LD9nvukyFOM3PvhcRDPAvr31kxRRYtEu4Gmh3BhiUjbiqmzDpeYQ4=
Received: from TY1PR01MB1852.jpnprd01.prod.outlook.com (2603:1096:403:8::12)
 by TYCPR01MB5936.jpnprd01.prod.outlook.com (2603:1096:400:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16; Sun, 20 Jun
 2021 23:56:40 +0000
Received: from TY1PR01MB1852.jpnprd01.prod.outlook.com
 ([fe80::751b:afbb:95df:b563]) by TY1PR01MB1852.jpnprd01.prod.outlook.com
 ([fe80::751b:afbb:95df:b563%5]) with mapi id 15.20.4242.023; Sun, 20 Jun 2021
 23:56:40 +0000
From: =?utf-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPo+OAgOebtOS5nyk=?=
	<naoya.horiguchi@nec.com>
To: Joao Martins <joao.m.martins@oracle.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, Dan Williams
	<dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave
 Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jason
 Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Jane Chu
	<jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>, Mike Kravetz
	<mike.kravetz@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 01/14] memory-failure: fetch compound_head after
 pgmap_pfn_valid()
Thread-Topic: [PATCH v2 01/14] memory-failure: fetch compound_head after
 pgmap_pfn_valid()
Thread-Index: AQHXY6kOgb5KALe1DUigPyAAfQFQTKsdmH+A
Date: Sun, 20 Jun 2021 23:56:39 +0000
Message-ID: <20210620235639.GA2590787@hori.linux.bs1.fc.nec.co.jp>
References: <20210617184507.3662-1-joao.m.martins@oracle.com>
 <20210617184507.3662-2-joao.m.martins@oracle.com>
In-Reply-To: <20210617184507.3662-2-joao.m.martins@oracle.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nec.com;
x-originating-ip: [165.225.97.70]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8bf256a9-84be-4203-11c4-08d934470c1d
x-ms-traffictypediagnostic: TYCPR01MB5936:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs:
 <TYCPR01MB59365BCB4F99076451AB14AFE70B9@TYCPR01MB5936.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 tCs6LU9t6EfDruaw+O+HgkUg4px4tq6AwacQ9hK/e3hRjGLQtcLwT9s/MVxVKOfKO+oto1yi9CJ0ZOSg4xoQOhLxg/uB59NgjpBpennkdE6s4KeqveG1o5VesOPlvgqcS85Y6bhZHMucMmFwJgz8uLn+3AFK1fm9xDRKLtFxSOTQfTtI+hrzoWVNadZuoziEDHsPZsIL8nghAgoZKbTO5a2InV7D/3awealkrWKMgeyU2jMo/VEBf9ZPtljWVhY0CU5CJRpERMLOWRW1/a2L/ZQpm70NgxvpZtELxZbf8qL5tLcVN1Qxds2qorJgrNZoL2f4u+sy9uPfAlXBMGPh4yH7oZEk/H69+5WUU5D2D5QHevcpqGfcKOL5zNpcvaO1t+qFNtZNCJ9NS3DI1oHRnGEOStOpZqqeP5M88D5wf5KoHzw8vk/QJPYLtHN/Q4xO+dTDLiSY9R8oy7NOEGyVqv2fOjtlRxzwmWPP/8gn69Vu6YSjvGuwxEmu9+4dvs0LTs7+Vn4iypHXMg+45arPHv7buPf1eG9xRLxLpdr5bCA2h751ds05sPWK0Z0L1+1ZIahd0EW9MQ3owfmDY4RfcR8QgBe/1mdJZSPkcOitoTs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1852.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(122000001)(2906002)(186003)(71200400001)(8676002)(33656002)(1076003)(5660300002)(478600001)(26005)(6512007)(9686003)(66946007)(55236004)(54906003)(86362001)(76116006)(7416002)(38100700002)(66446008)(66476007)(83380400001)(6486002)(6506007)(6916009)(64756008)(66556008)(85182001)(316002)(8936002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SkVoQnNKRWxybXJrYWhhcWtORzBOU2tyNS9BaEhGclF0ZFoyZmhjUldlZHlE?=
 =?utf-8?B?UTZQMG9iTi9DQkNiTHZUbDBrVVdpb0MwNWxQQnAxeGlZczNEaDR6V05mcXJh?=
 =?utf-8?B?Sjc1ek5aN001aVBjem4zTU83U0lOekZIcE9UUXl2d0wrRTRIaW9EUDFkT2JO?=
 =?utf-8?B?SEdTcHhsTlk4bVkyRTlDZ0JwT2dsOWFmQ2tVVWh3N25Yc3FCMHRmSzhtazdh?=
 =?utf-8?B?Rk96aVBqL2VNZlNoYXhOcEhsWUJrUjcvT3NHU3ZaaFlXNXdqcDNWL3dMWXlm?=
 =?utf-8?B?NnloNGF0aHU0V09YY243ZmRtZDlBMjMwZkxJckRGWnJ6M1czUmsrallVUmEx?=
 =?utf-8?B?ckpLTk1seHJDWFBrdWR2bnN0SzRtT1hqOTRsNG1COW9MbW82eHJ6V2MwQjky?=
 =?utf-8?B?eW1RZ0l3b3VNWEtjbFBiYk01bmNVU09pcUI0c25ZdHA2RUUxaEt4dUQ2QnNR?=
 =?utf-8?B?bllJamFUNTlaYlc5QWxBNWRobWN0SHY4WFhRVmpLMUlZdlJQcEV1R2Y3S0tC?=
 =?utf-8?B?bkVpNTlpTnVWQzNiMnhNWjhTUFkzVWJzNXAvTGdvZFRPb01ua1ZNK3IxRFB6?=
 =?utf-8?B?UHZ0QWEreHgxZlNRRnd4R0NyRE9QaktUSVVZZUptRGFlaHNJZEdncENDYWtX?=
 =?utf-8?B?cXllQ29CSnh1SHVzVkxSR3NubkYxMDQ4ZTFvbjhOd0Y4dCtLc1Y2ZjU5d1lz?=
 =?utf-8?B?UnVKWDNFSHdSZjhIZVhnU0R0TjB6QXFZa3RETXVEMGNydzlkLzRWNHBOOEdi?=
 =?utf-8?B?MHViNGRvbGQrbmdZVkxKMitSV2JycytzSHpNeTc3Y1BSeTlubEV5bzczZEd0?=
 =?utf-8?B?VklQelBhaEZwWDNndnFXQi92aXMzNzNBVGRucXVKdEhXNmpmZE15YU8wa28r?=
 =?utf-8?B?Ym1jVUZ2aTdPdVg3eG5iUDd5cGNqUlRHTzBxbGdGNU5HVUVXMXlPc2toYW1j?=
 =?utf-8?B?NkVjODdpYUN4UE53dXJsejFIc1c4cDhrb0NiNGZHa1Y5WlQyU05oeFZPMnYr?=
 =?utf-8?B?bXlNTWY3Nzc5Q1U3L3dHeUNMRm1Iamx0RFREOXBzNjdhakN6Y3hvN0JCMVlB?=
 =?utf-8?B?R0JPbmRNSnVTT1BjVVpOWVFBTXR2N0ZnYUUyWFROcmt6MU1GK1RHNkFpUnIw?=
 =?utf-8?B?dDRLWW04SmpONVJDRGxKYk42RjQxa21iT3hFbThjSjg1MmlDcit1SUN2bTMv?=
 =?utf-8?B?aFMwQUg1SExiVkVseGFhbTFCWC96V01YeHFQN0N3cHAvYXVrN24wU1djTy82?=
 =?utf-8?B?cVZqcjRVYnQ0S0F5aFBHU2RSTnJVWllQdFYzQVlScjdOTG94MHdSVDY2YkxY?=
 =?utf-8?B?bGtHMWk5WkdwVWlsd2hTYkhxV0VCSFZ6ZXh1cFE5Z2pXTWVxSE5RdWY3dzhB?=
 =?utf-8?B?cjNZNmdIaHg1VnlwUVF3ZWU1WFlQY0luekg1S0dLYTAwNmNRckxBd2lXRFZv?=
 =?utf-8?B?TkExSFAzVE9uRUxtYkFDS1p5enZqTEIyNTY5aVhzT0ladDNBOHljRFl2T0sz?=
 =?utf-8?B?WXhWdHRXb05ORmowblJOcHJYR1dDUDRpbDRxdGlSR2E5RGlUdVZBWjZGd290?=
 =?utf-8?B?LzRhcmd4djJvbjVPdnN5WTFXaXhFL21MemxtcXJzUVdQdCsrR09MS3BBTU5u?=
 =?utf-8?B?UzNjN0t4UnNXYm1KdkdqZWpSaU55QnpqbFozV2Z5MTBCdWF3S2MreUlONWhn?=
 =?utf-8?B?ZmRaMEJOY3VRRVVrYURNWm5vdVNFdDdUUWVZalA4RjBVaWFpdm9mWUVRdUlE?=
 =?utf-8?Q?NtFLFIjNaz/7TrZ7umAjdkO6WKKr9bH3Hezh0YI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9403C49398D2B446B5A37C3E11416E27@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1852.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bf256a9-84be-4203-11c4-08d934470c1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2021 23:56:39.9300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MqWnyMHGYQk9ei6zyD0L9JGb7nFAlPsoKK4K8CQIt8cZOeYBtPaL4tAWtHXEy1xkXvrTh6Q90gPZneQG5Sxd2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB5936

T24gVGh1LCBKdW4gMTcsIDIwMjEgYXQgMDc6NDQ6NTRQTSArMDEwMCwgSm9hbyBNYXJ0aW5zIHdy
b3RlOg0KPiBtZW1vcnlfZmFpbHVyZV9kZXZfcGFnZW1hcCgpIGF0IHRoZSBtb21lbnQgYXNzdW1l
cyBiYXNlIHBhZ2VzIChlLmcuDQo+IGRheF9sb2NrX3BhZ2UoKSkuICBGb3IgcGFnZW1hcCB3aXRo
IGNvbXBvdW5kIHBhZ2VzIGZldGNoIHRoZQ0KPiBjb21wb3VuZF9oZWFkIGluIGNhc2UgYSB0YWls
IHBhZ2UgbWVtb3J5IGZhaWx1cmUgaXMgYmVpbmcgaGFuZGxlZC4NCj4gDQo+IEN1cnJlbnRseSB0
aGlzIGlzIGEgbm9wLCBidXQgaW4gdGhlIGFkdmVudCBvZiBjb21wb3VuZCBwYWdlcyBpbg0KPiBk
ZXZfcGFnZW1hcCBpdCBhbGxvd3MgbWVtb3J5X2ZhaWx1cmVfZGV2X3BhZ2VtYXAoKSB0byBrZWVw
IHdvcmtpbmcuDQo+IA0KPiBSZXBvcnRlZC1ieTogSmFuZSBDaHUgPGphbmUuY2h1QG9yYWNsZS5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IEpvYW8gTWFydGlucyA8am9hby5tLm1hcnRpbnNAb3JhY2xl
LmNvbT4NCg0KTG9va3MgZ29vZCB0byBtZS4NCg0KUmV2aWV3ZWQtYnk6IE5hb3lhIEhvcmlndWNo
aSA8bmFveWEuaG9yaWd1Y2hpQG5lYy5jb20+DQoNCj4gLS0tDQo+ICBtbS9tZW1vcnktZmFpbHVy
ZS5jIHwgNiArKysrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykNCj4gDQo+
IGRpZmYgLS1naXQgYS9tbS9tZW1vcnktZmFpbHVyZS5jIGIvbW0vbWVtb3J5LWZhaWx1cmUuYw0K
PiBpbmRleCBlNjg0YjNkNWM2YTYuLmYxYmU1NzhlNDg4ZiAxMDA2NDQNCj4gLS0tIGEvbW0vbWVt
b3J5LWZhaWx1cmUuYw0KPiArKysgYi9tbS9tZW1vcnktZmFpbHVyZS5jDQo+IEBAIC0xNTE5LDYg
KzE1MTksMTIgQEAgc3RhdGljIGludCBtZW1vcnlfZmFpbHVyZV9kZXZfcGFnZW1hcCh1bnNpZ25l
ZCBsb25nIHBmbiwgaW50IGZsYWdzLA0KPiAgCQlnb3RvIG91dDsNCj4gIAl9DQo+ICANCj4gKwkv
Kg0KPiArCSAqIFBhZ2VzIGluc3RhbnRpYXRlZCBieSBkZXZpY2UtZGF4IChub3QgZmlsZXN5c3Rl
bS1kYXgpDQo+ICsJICogbWF5IGJlIGNvbXBvdW5kIHBhZ2VzLg0KPiArCSAqLw0KPiArCXBhZ2Ug
PSBjb21wb3VuZF9oZWFkKHBhZ2UpOw0KPiArDQo+ICAJLyoNCj4gIAkgKiBQcmV2ZW50IHRoZSBp
bm9kZSBmcm9tIGJlaW5nIGZyZWVkIHdoaWxlIHdlIGFyZSBpbnRlcnJvZ2F0aW5nDQo+ICAJICog
dGhlIGFkZHJlc3Nfc3BhY2UsIHR5cGljYWxseSB0aGlzIHdvdWxkIGJlIGhhbmRsZWQgYnkNCj4g
LS0gDQo+IDIuMTcuMQ0KPiA=
