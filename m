Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3315B70
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 00:21:44 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="206401963"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="206401963"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:21:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="645582719"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jul 2021 17:21:41 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 7 Jul 2021 17:21:41 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 7 Jul 2021 17:21:41 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 7 Jul 2021 17:21:41 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 7 Jul 2021 17:21:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcoluv+4nCiunlaGQntl/WosOY0YfSj5lU60lfjkkb4+ZO2Pq7YPM5CBwNaOu+EmB7cYIvnV+uwA6NtlPBKj8ZMV9E0l4qHHYdK98nG1CcmlcOtD3k5jITju4IfLMbSsL97yW8peWyjqRW/OyGDZzPwC9Y8cy257M+camC00a6f7ysmgTrgo/7/jJTLIUzaeY+IfIYrlLC+YMD9qUabma1A2rRl12lRwJ5i+H9ykZYPEuKWdPqyAZiIkXwZ3YcTo05ouy0hmF7SjktAC471eWolk3FA57ikCrIpA7IcSI3v+yqE7HUQY2rswPzi1df4T0OV9GDmQGeSxe4TJ0Cphbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xr/pN8uCcb+F6OMrH4kRGtlWZD4umHeu+THulYBs2U=;
 b=KrFlZNS8Jid/1R2LuxqQuE0pno0Ix2ovyotKEznu0Ryn0t7CilB19NOsB1PHKpDIUHJKqm28WPhVSvmn2GZsbQnrVKbAmFT29jNb/rZQmh6FuAGEaFquuLrcvqgnhbb/rlQldSigOQ5SqtU4OfVBL5wde+zvM8t4qvrgEuPLTGInLnz0tYwRy0b6jPMREQiQOlreo96PD5aUZEURR6O494iwBT20OnF7AGQNxY5AtcWUkaE9iJjojr67Dz2QSiVsZzxE5oGIbL0IPegeYCYaLhvJV4QdWMhZZBkLNcXyjr7WzuMZmvbsTbfPRMweAHInBi0mjMWc7cPME5vNJUUhSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xr/pN8uCcb+F6OMrH4kRGtlWZD4umHeu+THulYBs2U=;
 b=Hk/TMVakWFSjQZ7k7KohcCYzMU5PmJJ1xTvoADlBcl8z5jr+OJ6PkWg+AWU8jgKsXc+/kvV+TiGskzxk1HhPVMy4dWwDapMYm8j/1aUmZGaO++Q/55svKa53gWkObg8Fddu2QUJoQiUlwLdLuEZKLvsglmlR1qWB6BW9P2qKj4w=
Received: from BYAPR11MB3448.namprd11.prod.outlook.com (2603:10b6:a03:76::21)
 by BYAPR11MB3400.namprd11.prod.outlook.com (2603:10b6:a03:1a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.30; Thu, 8 Jul
 2021 00:21:37 +0000
Received: from BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::de7:9279:792c:4d75]) by BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::de7:9279:792c:4d75%3]) with mapi id 15.20.4287.033; Thu, 8 Jul 2021
 00:21:37 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "Liu, Jingqi" <jingqi.liu@intel.com>
Subject: Re: [PATCH] ndctl/dimm: Fix to dump namespace indexs and labels
Thread-Topic: [PATCH] ndctl/dimm: Fix to dump namespace indexs and labels
Thread-Index: AQHXXN3on4dBmZFFKE+nf1QtJqtwjqs4ZLAA
Date: Thu, 8 Jul 2021 00:21:37 +0000
Message-ID: <8110e80df98fb57fd20d0bf73dc7d266fef5ab84.camel@intel.com>
References: <20210609030642.66204-1-jingqi.liu@intel.com>
In-Reply-To: <20210609030642.66204-1-jingqi.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.2 (3.40.2-1.fc34) 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89dbdb46-5062-4f5d-8ac6-08d941a659ee
x-ms-traffictypediagnostic: BYAPR11MB3400:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB34007669F414A82FF662EDD5C7199@BYAPR11MB3400.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:262;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wN9BE6JIhZgMDFKC5f3pFqI7HsbB2mxxlS8afbHIP44VKlgb/yWP7ilhOtdnGPVXZWwtoUzOII9cN4oahWAzHIjKUqXsBR7HD+vnzyP4mvOONCDE1zXqvcXQ2TIROBHHiAUpPA0iQDkOcCkO26ZfVMKg27M18SvLtf2OZB7lv2ThJ/2/MRF0xGYtYOVLkKnNG8L249s3s3SOtRvBBPK0xL6l8T1Dc++8G/FO+LEj1rUU/6K8i4n+/soD3FGHxmoI76TDZYQBOLIZG+9vZOWzj3eUELLL2dJx9KTi954k3n7v5i3QOSDoxbvNoEXupXnXHJ0JNi8e6lcONbE0KDBFG9ivhqtKQcAvFf4tXB7fFQUet2xv9WzXErZrL0sADPRdCU2lOVn+49z9IjqUmXGyNZ8I4/RSdcBSKqf8f4lDctvloAxw+VlRSbuiW2eZkvNXaYhhRERv7C8ebb+3VAy6pETnz21zMrTHTcL/gvM5DFzrjEz1xFeDxeEMAUTuvt6+KMoeVgVbspkEXEtIrHjeV2V+RQGHLTUhXKKEbLwm1JlyJby5THS9kN/iapFCjvpZR5yNFp9SHWgfVkbkZNpqIdWoasvsgQttbWSoUY6U+dAsHIL0+I0h4rs1Ldop5dKdrV2fEZ925hZyJVl/6tMigw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3448.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(346002)(39860400002)(136003)(478600001)(71200400001)(5660300002)(186003)(76116006)(36756003)(6512007)(110136005)(8936002)(2906002)(316002)(2616005)(8676002)(122000001)(38100700002)(6486002)(66476007)(66556008)(64756008)(66446008)(66946007)(86362001)(83380400001)(6506007)(6636002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MjkxSVdNZVZ2YUFpSVVhdnJ2SEZkNEJVU0I3Skd4dm8xYWJyQUUrMVh3V1BB?=
 =?utf-8?B?Rm9NN1R6MEVXVVB4Q0gwYlkzVGVldzQ0aHhTOUFJZ01RTlRqd2syUSttRXhk?=
 =?utf-8?B?ZDBsbE93L1U2Sm5zOStsSFJhc3FBY2NsRlBpbFdZNFIwcldkek5xTDJVd0R0?=
 =?utf-8?B?eFlCK3MraS85dG5lQnhXQTh4S1VOMmtTSTRtbk9STENmWElsRkp4Z2huK0ZZ?=
 =?utf-8?B?bUVKaE1vVlRFOUN0YWNNR0puZ2NWNUlWM00xb0ltVm1BL0doRS9zSzN3RjhQ?=
 =?utf-8?B?UkVBRVJBU3BKUEsrM25rVzk5UXhaank2djRGeDJnaHJSR3BsanM2dVRTVG0w?=
 =?utf-8?B?N0h3NHVBSUZKWmhjMTB6TVVHRy9YZFpnZ09DQ3dUTzdPb1ZxNW1EbWovdjRE?=
 =?utf-8?B?M3dHaFppL1JMajhnOG9NZjdyTkt1aTRHL0NsMU1xS2NGYkszTnJzMUlzMnUw?=
 =?utf-8?B?YXhtNGNrYzNhdnVtTlIxL2xEa2I4MUxGcXBhZkZRcXhZZm1keGZiUDNJSWZp?=
 =?utf-8?B?Z2oxa1g2VkJYUFhSM2pnMTdHQk1KZHNKQkF5OWFkNmJmTlg0NDk3UUJvaDFn?=
 =?utf-8?B?ZDhaTDlnL2htUnRxSlQxR2ZBd3c0YXVNSk5xRW41aHRvdStGNC85azBqM0Jm?=
 =?utf-8?B?Si9DVldoWUYxNHVmcDhtQ2g3bmtqZm5xMVhDV3V5ejNaZWF3dW41NVV4Ry9W?=
 =?utf-8?B?Z1pWb0haNXdkU3BYbys1TzAxdEVZN0w0U01wbyt6ekowUktnVW1RT3gzMitp?=
 =?utf-8?B?a21aNFprTnpTSm00d3IyTkxyRUJhWU9DRWcvdUhmQllwVlozczVqMGQrelRn?=
 =?utf-8?B?UHhDbWlOd3cwTWMvZVJMTUpBdG9lZDU2YUk1TnVMWWFJNXhsRm1ZZS9teXMx?=
 =?utf-8?B?aksvR3l1M3dFMWtRRFpHME9JWm1GditCVG04azJITmRQWU1iRkphTnJzeUZq?=
 =?utf-8?B?djl5STJ2TGVQTDJlZzUrQVB6eVA1ekk3UFdkZ0ZlN0lnS3UrRDlNUmFSQmhS?=
 =?utf-8?B?QUpIek9WanFzWi9xK3V4cDgxWUZoYkFIcnQ4VitXRVkyaG1zTlBTQWVMcWZj?=
 =?utf-8?B?aXZucWMwZmFxK2svN2YvWGpUb25JVklvWGNvdC9FbStuZVRzN1hCTjJjMHIw?=
 =?utf-8?B?SmUzcnJZWkNUbFMrZHlJTzVGSThHWWJmQzRsbmFMMFI5YzZueXJDcWlkVHhX?=
 =?utf-8?B?d1VnL3M2OTg5dDNqSGFacnZpK2RKN3lORGZCV0paR2pqK3NzQmVIc0cxMGJl?=
 =?utf-8?B?UG9uV2tSTTY5YlpKaWNnU0JnS3ZkZTJoaG5COHBCWVdibHZvRStnVURDZStE?=
 =?utf-8?B?cy9hNnFMTzJJNGx4RWFIVStBcWVDZzJtbm5HMWZSQkV1N01sQmdhUTRDQVZh?=
 =?utf-8?B?SVQyaFovZE5pNHV3ZVE3eXNBSngvU01hbkpMa0dXSXV5OTBrV21wUmo5RnFr?=
 =?utf-8?B?U25kQXFJRlM5cWRXMGZYVEFubHI0dkxGVUpQelF1WHFvM204ZzEzTDgxTVhy?=
 =?utf-8?B?L0tiK0toVEZVb1lHcnQ3QzFzQUVXN3RzZjdTbDFiYjBucXAvYlE1b3AxNHlw?=
 =?utf-8?B?NGVBTlF0bVNKb3NvUkNIUkRreXBOcFN1NkhaMndBaGJNZWhIY0FpRW1tNFZu?=
 =?utf-8?B?MGlkVm9LUExYUHJNcmUxL1V1TlhJeG9rMVkrbTFaWWFReXdVZzRCcU9BUXh2?=
 =?utf-8?B?S3czTjNFaXVhUnc2MDBzcUJ5MGhrellNOGJydnpXazNnTGczRWdVZUJhdTNv?=
 =?utf-8?Q?RgK0HE7r0nS1hwzf3x/FTmjtLolousN83Z2Ei6i?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04307165A9EE5F499D842A7B92D5EF98@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3448.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89dbdb46-5062-4f5d-8ac6-08d941a659ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 00:21:37.7618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CuJxjd96KTK0ngDvvUWluloP2xZJHF/8LD3BBrzyhxKYaoNhPpN7w1ZEM3DaknIwWoR8lijHeYPHc+3hm1+4/CoDpsSuS7r0pxJePLAgAvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3400
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIxLTA2LTA5IGF0IDExOjA2ICswODAwLCBKaW5ncWkgTGl1IHdyb3RlOg0KPiBU
aGUgZm9sbG93aW5nIGJ1ZyBpcyBjYXVzZWQgYnkgc2V0dGluZyB0aGUgc2l6ZSBvZiBMYWJlbCBJ
bmRleCBCbG9jaw0KPiB0byBhIGZpeGVkIDI1NiBieXRlcy4NCj4gDQo+IFVzZSB0aGUgZm9sbG93
aW5nIFFlbXUgY29tbWFuZCB0byBzdGFydCBhIEd1ZXN0IHdpdGggMk1CIGxhYmVsLXNpemU6DQo+
IAktb2JqZWN0IG1lbW9yeS1iYWNrZW5kLWZpbGUsaWQ9bWVtMSxzaGFyZT1vbixtZW0tcGF0aD0v
ZGV2L2RheDEuMSxzaXplPTE0RyxhbGlnbj0yTQ0KPiAJLWRldmljZSBudmRpbW0sbWVtZGV2PW1l
bTEsaWQ9bnYxLGxhYmVsLXNpemU9Mk0NCj4gDQo+IFRoZXJlIGlzIGEgbmFtZXNwYWNlIGluIHRo
ZSBHdWVzdCBhcyBmb2xsb3dzOg0KPiAJJCBuZGN0bCBsaXN0DQo+IAlbDQo+IAkgIHsNCj4gCSAg
ICAiZGV2IjoibmFtZXNwYWNlMC4wIiwNCj4gCSAgICAibW9kZSI6ImRldmRheCIsDQo+IAkgICAg
Im1hcCI6ImRldiIsDQo+IAkgICAgInNpemUiOjE0NzgwNzI3Mjk2LA0KPiAJICAgICJ1dWlkIjoi
NThhZDUyODItNWExNi00MDRmLWI4ZWUtZTI4YjRjNzg0ZWI4IiwNCj4gCSAgICAiY2hhcmRldiI6
ImRheDAuMCIsDQo+IAkgICAgImFsaWduIjoyMDk3MTUyLA0KPiAJICAgICJuYW1lIjoibmFtZXNw
YWNlMC4wIg0KPiAJICB9DQo+IAldDQo+IA0KPiBGYWlsIHRvIHJlYWQgbGFiZWxzLiBUaGUgcmVz
dWx0IGlzIGFzIGZvbGxvd3M6DQo+IAkkIG5kY3RsIHJlYWQtbGFiZWxzIC11IG5tZW0wDQo+IAlb
DQo+IAldDQo+IAlyZWFkIDAgbm1lbQ0KPiANCj4gSWYgdXNpbmcgdGhlIGZvbGxvd2luZyBRZW11
IGNvbW1hbmQgdG8gc3RhcnQgdGhlIEd1ZXN0IHdpdGggMTI4Sw0KPiBsYWJlbC1zaXplLCB0aGlz
IGxhYmVsIGNhbiBiZSByZWFkIGNvcnJlY3RseS4NCj4gCS1vYmplY3QgbWVtb3J5LWJhY2tlbmQt
ZmlsZSxpZD1tZW0xLHNoYXJlPW9uLG1lbS1wYXRoPS9kZXYvZGF4MS4xLHNpemU9MTRHLGFsaWdu
PTJNDQo+IAktZGV2aWNlIG52ZGltbSxtZW1kZXY9bWVtMSxpZD1udjEsbGFiZWwtc2l6ZT0xMjhL
DQo+IA0KPiBUaGUgc2l6ZSBvZiBhIExhYmVsIEluZGV4IEJsb2NrIGRlcGVuZHMgb24gaG93IG1h
bnkgbGFiZWwgc2xvdHMgZml0IGludG8NCj4gdGhlIGxhYmVsIHN0b3JhZ2UgYXJlYS4gVGhlIG1p
bmltdW0gc2l6ZSBvZiBhbiBpbmRleCBibG9jayBpcyAyNTYgYnl0ZXMNCj4gYW5kIHRoZSBzaXpl
IG11c3QgYmUgYSBtdWx0aXBsZSBvZiAyNTYgYnl0ZXMuIEZvciBhIHN0b3JhZ2UgYXJlYSBvZiAx
MjhLQiwNCj4gdGhlIGNvcnJlc3BvbmRpbmcgTGFiZWwgSW5kZXggQmxvY2sgc2l6ZSBpcyAyNTYg
Ynl0ZXMuIEJ1dCBpZiB0aGUgbGFiZWwNCj4gc3RvcmFnZSBhcmVhIGlzIG5vdCAxMjhLQiwgdGhl
IExhYmVsIEluZGV4IEJsb2NrIHNpemUgc2hvdWxkIG5vdCBiZSAyNTYgYnl0ZXMuDQo+IA0KPiBO
YW1lc3BhY2UgTGFiZWwgSW5kZXggQmxvY2sgYXBwZWFycyB0d2ljZSBhdCB0aGUgdG9wIG9mIHRo
ZSBsYWJlbCBzdG9yYWdlIGFyZWEuDQo+IEZvbGxvd2luZyB0aGUgdHdvIGluZGV4IGJsb2Nrcywg
YW4gYXJyYXkgZm9yIHN0b3JpbmcgbGFiZWxzIHRha2VzIHVwIHRoZQ0KPiByZW1haW5kZXIgb2Yg
dGhlIGxhYmVsIHN0b3JhZ2UgYXJlYS4NCj4gDQo+IEZvciBvYnRhaW5pbmcgdGhlIHNpemUgb2Yg
TmFtZXNwYWNlIEluZGV4IEJsb2NrLCB3ZSBhbHNvIGNhbm5vdCByZWx5IG9uDQo+IHRoZSBmaWVs
ZCBvZiAnbXlzaXplJyBpbiB0aGlzIGluZGV4IGJsb2NrIHNpbmNlIGl0IG1pZ2h0IGJlIGNvcnJ1
cHRlZC4NCj4gU2ltaWxhciB0byB0aGUgbGludXgga2VybmVsLCB3ZSB1c2Ugc2l6ZW9mX25hbWVz
cGFjZV9pbmRleCgpIHRvIGdldCB0aGUgc2l6ZQ0KPiBvZiBOYW1lc3BhY2UgSW5kZXggQmxvY2su
IFRoZW4gd2UgY2FuIGFsc28gY29ycmVjdGx5IGNhbGN1bGF0ZSB0aGUgc3RhcnRpbmcNCj4gb2Zm
c2V0IG9mIHRoZSBmb2xsb3dpbmcgbmFtZXNwYWNlIGxhYmVscy4NCj4gDQo+IFN1Z2dlc3RlZC1i
eTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYt
Ynk6IEppbmdxaSBMaXUgPGppbmdxaS5saXVAaW50ZWwuY29tPg0KPiAtLS0NCj4gIG5kY3RsL2Rp
bW0uYyAgICAgICAgICAgfCAxOSArKysrKysrKysrKysrKystLS0tDQo+ICBuZGN0bC9saWIvZGlt
bS5jICAgICAgIHwgIDUgKysrKysNCj4gIG5kY3RsL2xpYi9saWJuZGN0bC5zeW0gfCAgMSArDQo+
ICBuZGN0bC9saWJuZGN0bC5oICAgICAgIHwgIDEgKw0KPiAgNCBmaWxlcyBjaGFuZ2VkLCAyMiBp
bnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KDQpIaSBKaW5ncWksDQoNClRoaXMgbG9va3Mg
ZmluZSwgb25lIGNvbW1lbnQgYmVsb3cuDQoNClsuLl0NCj4gDQo+IGRpZmYgLS1naXQgYS9uZGN0
bC9saWIvbGlibmRjdGwuc3ltIGIvbmRjdGwvbGliL2xpYm5kY3RsLnN5bQ0KPiBpbmRleCAwYTgy
NjE2Li4wY2UyYmI5IDEwMDY0NA0KPiAtLS0gYS9uZGN0bC9saWIvbGlibmRjdGwuc3ltDQo+ICsr
KyBiL25kY3RsL2xpYi9saWJuZGN0bC5zeW0NCj4gQEAgLTI5MCw2ICsyOTAsNyBAQCBnbG9iYWw6
DQo+ICAJbmRjdGxfZGltbV92YWxpZGF0ZV9sYWJlbHM7DQo+ICAJbmRjdGxfZGltbV9pbml0X2xh
YmVsczsNCj4gIAluZGN0bF9kaW1tX3NpemVvZl9uYW1lc3BhY2VfbGFiZWw7DQo+ICsJbmRjdGxf
ZGltbV9zaXplb2ZfbmFtZXNwYWNlX2luZGV4Ow0KDQpUaGlzIGNhbid0IGdvIGludG8gYW4gJ29s
ZCcgc2VjdGlvbiBvZiB0aGUgc3ltYm9sIHZlcnNpb24gc2NyaXB0IC0gaWYNCnlvdSBiYXNlIG9m
ZiB0aGUgY3VycmVudCAncGVuZGluZycgYnJhbmNoLCB5b3Ugc2hvdWxkIHNlZSBhIExJQk5EQ1RM
XzI2DQpzZWN0aW9uIGF0IHRoZSBib3R0b20uIFlvdSBjYW4gYWRkIHRoaXMgdGhlcmUuDQoNCj4g
IAluZGN0bF9tYXBwaW5nX2dldF9wb3NpdGlvbjsNCj4gIAluZGN0bF9uYW1lc3BhY2Vfc2V0X2Vu
Zm9yY2VfbW9kZTsNCj4gIAluZGN0bF9uYW1lc3BhY2VfZ2V0X2VuZm9yY2VfbW9kZTsNCj4gZGlm
ZiAtLWdpdCBhL25kY3RsL2xpYm5kY3RsLmggYi9uZGN0bC9saWJuZGN0bC5oDQo+IGluZGV4IDYw
ZTEyODguLjlhMWE3OTkgMTAwNjQ0DQo+IC0tLSBhL25kY3RsL2xpYm5kY3RsLmgNCj4gKysrIGIv
bmRjdGwvbGlibmRjdGwuaA0KPiBAQCAtMzM1LDYgKzMzNSw3IEBAIGludCBuZGN0bF9kaW1tX2lu
aXRfbGFiZWxzKHN0cnVjdCBuZGN0bF9kaW1tICpkaW1tLA0KPiAgCQllbnVtIG5kY3RsX25hbWVz
cGFjZV92ZXJzaW9uIHYpOw0KPiAgdW5zaWduZWQgbG9uZyBuZGN0bF9kaW1tX2dldF9hdmFpbGFi
bGVfbGFiZWxzKHN0cnVjdCBuZGN0bF9kaW1tICpkaW1tKTsNCj4gIHVuc2lnbmVkIGludCBuZGN0
bF9kaW1tX3NpemVvZl9uYW1lc3BhY2VfbGFiZWwoc3RydWN0IG5kY3RsX2RpbW0gKmRpbW0pOw0K
PiArdW5zaWduZWQgaW50IG5kY3RsX2RpbW1fc2l6ZW9mX25hbWVzcGFjZV9pbmRleChzdHJ1Y3Qg
bmRjdGxfZGltbSAqZGltbSk7DQo+ICB1bnNpZ25lZCBpbnQgbmRjdGxfY21kX2NmZ19zaXplX2dl
dF9zaXplKHN0cnVjdCBuZGN0bF9jbWQgKmNmZ19zaXplKTsNCj4gIHNzaXplX3QgbmRjdGxfY21k
X2NmZ19yZWFkX2dldF9kYXRhKHN0cnVjdCBuZGN0bF9jbWQgKmNmZ19yZWFkLCB2b2lkICpidWYs
DQo+ICAJCXVuc2lnbmVkIGludCBsZW4sIHVuc2lnbmVkIGludCBvZmZzZXQpOw0KDQo=
