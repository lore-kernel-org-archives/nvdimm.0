Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B54423CC
	for <nvdimm@lists.linux.dev>; Tue, 15 Mar 2022 17:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647363953; x=1678899953;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=7PqbCBMP9Lk9Az+iJDdvHOrY1ewOYgOsGtvIZ3huPIQ=;
  b=iZa3h2WBxBMEsP1E7JTkHdgtpjABkgiY/t4ecEhMuzdjmGGX3qVxE9cQ
   Ox8WdTQHFgMv6a6mTKMmXwpf8IpD69WrQmtRK13Pr5Y0+fiXo3esPasoX
   Kx40RrPvwJdC0vJaqMpqpIaXX3si9csw4ThNchJLk8xzgV79CFlxIaXDJ
   ylyMXr/ywdBN75enD6YC+7wSiWPaVuXrCjg2oYtGTNvipuytnO5TXwm8Z
   qLefmB351ZZhL4vW3ymMyy5w8w2MUUATBZAACx34NqSgvcSNAZNVc+5jc
   KOwV2KUA3mhfXFIAtALyWlE3yk7tUkUYD3avA2LdxDVjiqriHhAATslnN
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="342790977"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="342790977"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 10:03:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="549669295"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 15 Mar 2022 10:03:35 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 10:03:35 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Tue, 15 Mar 2022 10:03:35 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Tue, 15 Mar 2022 10:03:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpv3+K7+EkhlnTUSggLKShSsI3CI2YYsH6XfMXNwdFLOmnCRFfvoHE6j788SxyrWQcdT5oBjCaea5yxNEws3EBiqxQOVBxjxxnHUo3RAYOorZcUE0ckJExRGZeQZ36ZIyX4b0c4RLxsnkrsiMQQkul9kYCw8Y+JyO0DdzZ3k61q0NtZdVr9UUmqoYbX23KeWm1WBxSQSIQdnZ9b6TkHIOZSNEHlorwZ1CMPqQetkTkPGRmzHoq/+UTBN/9fbeZD2x/fHZ7EFb9yZRtTZItg63cdSTmVCsxTKSOOE26EPZZuozi6D9s1KLyA1s92qmxFV0nydQJv3Wsq16lROG4tcnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7PqbCBMP9Lk9Az+iJDdvHOrY1ewOYgOsGtvIZ3huPIQ=;
 b=EDaOrxHcnLNhG3zxcpr5uo+rxFrePTwxsGFh80ld+oM+4j7WVUZmNJZCpVBDBpRBKd8kKmjoMnHjzD/p6mv2Gw/xNKlGETD6j1rOmcf4jeT2QEWn6PxnPYigEZt6yyzMd7TotVOQJMSmo5XHG+Zi2zf6XXP08CWlqVmZoqs+Gz3kWZOZkOFeGVGHKAwoPtcNJ8IOHX8iAKyDRVMVsy5lWLJJnvy5yrzRyvvv7h+xaDn5Y41ILlQf4dAu5gmfoMg5dv6Dkca56+Vs1Cq6o4ad2dl0sW349mmT/qL4+Z3Jsggh/H6sgEPX3ZNRXFjTTD8AX3tgs+qsIWjQHuR/6AbfQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BY5PR11MB4292.namprd11.prod.outlook.com (2603:10b6:a03:1cb::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 15 Mar
 2022 17:03:33 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d898:84ee:d6a:4eb1]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d898:84ee:d6a:4eb1%6]) with mapi id 15.20.5061.028; Tue, 15 Mar 2022
 17:03:32 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "vaibhav@linux.ibm.com" <vaibhav@linux.ibm.com>
Subject: Re: [PATCH] util/parse: Fix build error on ubuntu
Thread-Topic: [PATCH] util/parse: Fix build error on ubuntu
Thread-Index: AQHYODKX6ELT9KBswkK0WO1zn3E2E6zAJI0AgAAWYQCAAG05gIAABKWA
Date: Tue, 15 Mar 2022 17:03:32 +0000
Message-ID: <b03ba8900a24a58fa47139761f9bce400eadfdc3.camel@intel.com>
References: <20220315060426.140201-1-aneesh.kumar@linux.ibm.com>
	 <874k3zd27b.fsf@vajain21.in.ibm.com> <87v8wfcyht.fsf@linux.ibm.com>
	 <87zglrb1tu.fsf@vajain21.in.ibm.com>
In-Reply-To: <87zglrb1tu.fsf@vajain21.in.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.4 (3.42.4-1.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6c031e7-9fd0-4845-9e73-08da06a5bc97
x-ms-traffictypediagnostic: BY5PR11MB4292:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <BY5PR11MB4292A25993C6392F77C43B48C7109@BY5PR11MB4292.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5fUVldMWIAajrx4Q7J1kwzMZuz/Y0yrXMjA7ka3W8CRrbNtqrN6Kzg5/MY3+vLXj85d7BcwpLQVhH6rPtwJKD/HlygFveLWIkgm7SeGUNRj2GEUdm03jW24fSNLz9qd1iwTJEEDQDt9MgW1L19k5Qn5C0UeVzJlZixetQgK7Xq+83J0Tll9DFYebhcGE0KFeXxiKqjZF8fucsO4NMWqz5RONEdctMChmr9Uwg2wc3ijELiGWgZNDC6lB1GKEhcF3S1qoptQtL4KO4nGoqTsgoDWZEiMyeWf2G2e8Yva8EUATQMcBt95jkFU2QqncAfH1ohP/j60TrOBARjXw/P4/QDR3RAl5DiO2d33FGTsam3aagdaaH++u34JVa8uQImnbBvlcwYeJONd0rZ35mym/6ER31ixAjuUEk6Bg3ImTIVAGDrgq4CiZGuW0geCNSJF3mMGdOIZuywe20cs9FOlAX4JpS9Z5ho6gT3ycpdFiZv+AeDkMuJYdG2HNc/UyiZ8u9DypDRzvG5+fJkLBrT2d4hI3IaUbwxdzN3AMHPIcQTYf8UswCzUJa9uY7s98Po7cGIi7DrX3cPP/iF2ZPwcVIKFlIzpQUsRExj3b0ygkkUGWgK/p8pXRlJ0++axdAU+EnKQ7y7TmM+hKoPR9pwp63BvVTZGEkb03g1IUUVdwtDk5iHIO3ktFldq04RIDejol/bdq2lx202prFIOaWWTV1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(5660300002)(6512007)(2906002)(186003)(26005)(2616005)(122000001)(82960400001)(38070700005)(86362001)(38100700002)(64756008)(91956017)(36756003)(316002)(6486002)(66946007)(110136005)(6506007)(66556008)(8676002)(508600001)(76116006)(66446008)(71200400001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVh6U3A0K2NRYmJ5dWQyTmU5eGxLMDJNWlVnVUE1aC85b1lpRkU1aEFxTXNr?=
 =?utf-8?B?a2F0eFhZUGRMOW9WT1Radi84MTBFYUlZN1A0VXhqRUN6a3VNRjIrVkxMNW1G?=
 =?utf-8?B?MHMrSXNMT1JuMS9ydGJFcFlWZ3Y0OW55d3MrRUxFWTdBWUFsRlgzaHk1NDVr?=
 =?utf-8?B?K0lTOGo2MjVnVGw1cUlvQTlOYzFreHBHaWo1V3dJWXBxYWg4ak9BM1lsZ3FR?=
 =?utf-8?B?UlVGclIrYVpoUnF4MGtGNk52T08vYU1nMXF0V3hDZUoyNjFhVjBLbldSamxX?=
 =?utf-8?B?R2R5Nm1GNG96YVhBTG03VWNYUzRQbGk1OVlDYlpCM1RwdEV2ZFFyNTAxM1Iz?=
 =?utf-8?B?elZuYnBlQm01V2w1eVI0TldnbmVuYzZzNTV0b2phZ1FuOHlod091UytlRjdY?=
 =?utf-8?B?YURWSVlsVzMzeWcxRHpmSE5mcUlQbzMvczdwd1B5NWh1VEpBVE1uZTN1aktC?=
 =?utf-8?B?TU1hQkJkZmI2MkIzSTc3eTJ6TXNJWGtJZDRSYlJEaVZCV0tlYlkvTmRWc0dO?=
 =?utf-8?B?TzQvUmtZWDFrdXBLQXowQnJPQzFrd2pnZ0NieUJCcHk0c0RBbE1iSVVUY2NN?=
 =?utf-8?B?ZUhwQTFSVGxnUGQzRVprNnVkZUp4REpHQ0hySlRVQWV6dDJuN1BjZE9SWTNI?=
 =?utf-8?B?dFRLMGNRbFYzbFA0NUdWZkw5cFJwUFBrZnRaNGI3MHV1Zi90Qk9uRzUzUHJI?=
 =?utf-8?B?LzZGUjV0aVVWV0kzMnZDbDZRbG9mbkNWbTg5dXNucjJ2cjBLVDdMMDRrcmZ3?=
 =?utf-8?B?bTVsSkZhcUp2OTN4dWxqVElHZFloQjNFMEhES0c5bG84QXRIdU4vNStJZXpO?=
 =?utf-8?B?WnE2MndNd3NGQ1VpOEkrdmRPK1VFd2dYWlJEMWx1N09GM3pMM3hLbE1WVENI?=
 =?utf-8?B?L3lDSXF3QXVMV3pVTjA5S2lvUVpUMlBRWk1PaUN5ak9xT2hBdzZiU2xudjRy?=
 =?utf-8?B?MDFGRFVHZklxUVo2L2xoTVJFNnN6QmZ5QzA3T2FJZmY2WkJBdFZHcFJrL0VZ?=
 =?utf-8?B?ZGtVWFBZN2prNTdGUFhFbGFNdWlqV2llNlZvbFRCR2Ntc0haSmVBZDhGdmdw?=
 =?utf-8?B?a2IvaVRwL082TmpVblhHM0YxcTYzL01lQUNpa0hIVVR6VW1NUEtHb1RqSzJr?=
 =?utf-8?B?L3Jpb3lneG5FSjAxVGpBVGNpS0xLNEg4Y0VweEJnVWxpbGxPNHlMSXAyRVpu?=
 =?utf-8?B?OVplcWRUc3EyUUV4ZjZpd29lMUJ4VjdzR2Y0bUNkT3JpN0xoVGIxRGtKYk1M?=
 =?utf-8?B?MFhYeUs4dW5UblEyZENOcXo2Wk1NcU5HdjBDMVBENmdOd0w2NU9rSEdWVTg1?=
 =?utf-8?B?YXhCNmlINVQ5V1NERElSbjFMV2ROSTNkOWtuUU5HUitmV0RaeFN6UE9nVUps?=
 =?utf-8?B?TFpTRFBtaE9NSXd3NnF4WG5EYkdaVXBET3Z6NFFqMHQwZ1VQSUN5UmhDRktP?=
 =?utf-8?B?Z29OWHdMZS92U29oZ2FmMjFreFM1eTAwakQ3d0ZtSjRKbnhXVEd6TytJb1dY?=
 =?utf-8?B?NWVMS0dZSWJNWmdnMW5DcEk0YTZKTUplUU52U3BLTzc3anFOeEdmTkJDZUFq?=
 =?utf-8?B?T1BwQ1NXTG5NSUtBRjZNcFcrWFNYRjFkNVArb1hrci9YOERxSXZFSnBTaHRu?=
 =?utf-8?B?b3RsejlZMnF3STdtL291NTc1Q3VLSGc0WVJqdjBCN2xzZW5pdHVodHpxdjJo?=
 =?utf-8?B?TnRjOGlENmwxNEQ2dWI2UUNCL25tQXBBTzFuVW12aW8wdlJnendFU0F4MTc0?=
 =?utf-8?B?TitBa1QvRWtWS01HQi9vVUd2Smk2NGtOWEJNMDFhS0Q1RldjTnh0dHBEYi8v?=
 =?utf-8?B?VEZnQTBKSW0vcVZiUEY2amI4OXo0WnlOQjlqb3JVdUpEa3lPWk5zT2h5VVY1?=
 =?utf-8?B?b1JvdzRpTEZjZmNRRTM5dGRDWWNja2l0Z21hNzRZUG1yNkFJYVFNcTJ0Mkpq?=
 =?utf-8?B?dWo5RmRMNXc1UlNTaWRkL2Y3V3Z0NThDS25WUFc1Y2FXZlI3Y2RndStlL0p3?=
 =?utf-8?B?NzU2ajMvYStnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2CACB7E61A7A14EA1F839B849C6407A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c031e7-9fd0-4845-9e73-08da06a5bc97
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2022 17:03:32.8520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SBe5bPnDmD4yvWaGiKqI1cs/kRGLAg1vlJmN0lNu233Pz9EFFZoXQQpQIUNygx5umj7YbY4hStbvq5mZumv5E1Ixsba36AMaRzdF/MtC6aM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4292
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIyLTAzLTE1IGF0IDIyOjE2ICswNTMwLCBWYWliaGF2IEphaW4gd3JvdGU6DQo+
ICJBbmVlc2ggS3VtYXIgSy5WIiA8YW5lZXNoLmt1bWFyQGxpbnV4LmlibS5jb20+IHdyaXRlczoN
Cj4gDQo+ID4gVmFpYmhhdiBKYWluIDx2YWliaGF2QGxpbnV4LmlibS5jb20+IHdyaXRlczoNCj4g
PiANCj4gPiA+IFNlY29uZCBodW5rIG9mIHRoaXMgZGlmZiBzZWVtcyB0byBiZSBhIHJldmVydCBv
ZiBbMV3CoCB3aGljaCBtaWdodA0KPiA+ID4gYnJlYWsgdGhlIG5kY3RsIGJ1aWxkIG9uIEFyY2gg
TGludXguDQo+ID4gPiANCj4gPiA+IEFGQUlTIGZvciBDZW50b3MvRmVkb3JhL1JIRUwgZXRjIHRo
ZSBpbmlwYXJzZXIuaCBmaWxlIGlzIHByZXNlbnQgaW4gdGhlDQo+ID4gPiBkZWZhdWx0IGluY2x1
ZGUgcGF0aCgnL3Vzci9pbmNsdWRlJykgYXMgYSBzb2Z0bGluayB0bw0KPiA+ID4gJy91c3IvaW5j
bHVkZS9pbmlwYXJzZXIvaW5pcGFyc2VyLmgnIC4gVWJ1bnR1L0RlYmlhbiBzZWVtcyB0byBhbg0K
PiA+ID4gZXhjZXB0aW9uIHdoZXJlIHBhdGggJy91c3IvaW5jbHVkZS9pbmlwYXJzZXIuaCcgaXMg
bm90IHByZXNlbnQuDQo+ID4gDQoNClNpZ2gsIHllYWgsIHRoYXQncyBhbiB1bmZvcnR1bmF0ZSBz
aXR1YXRpb24uDQoNCj4gPiANCj4gDQo+IEFncmVlLCBhYm92ZSBwYXRjaCBjYW4gZml4IHRoaXMg
aXNzdWUuIFRob3VnaCBJIHJlYWxseSB3YW50ZWQgdG8gYXZvaWQNCj4gdHJpY2tsaW5nIGNoYW5n
ZXMgdG8gdGhlIHBhcnNlLWNvbmZpZ3MuYyBzaW5jZSB0aGUgcmVhbCBwcm9ibGVtIGlzIHdpdGgN
Cj4gbm9uIGNvbnNpc3RlbnQgbG9jYXRpb24gZm9yIGluaXBhcnNlci5oIGhlYWRlciBhY3Jvc3Mg
ZGlzdHJvcy4NCj4gDQo+IEkgZ2F2ZSBpdCBzb21lIHRob3VnaHQgYW5kIGNhbWUgdXAgd2l0aCB0
aGlzIHBhdGNoIHRvIG1lc29uLmJ1aWxkIHRoYXQgY2FuDQo+IHBpY2sgdXAgYXBwcm9wcmlhdGUg
Jy91c3IvaW5jbHVkZScgb3IgJy91c3IvaW5jbHVkZS9pbmlwYXJzZXInIGRpcmVjdG9yeQ0KPiBh
cyBpbmNsdWRlIHBhdGggdG8gdGhlIGNvbXBpbGVyLg0KPiANCj4gQWxzbyBzaW5jZSB0aGVyZSBz
ZWVtcyB0byBiZSBubyBzdGFuZGFyZCBsb2NhdGlvbiBmb3IgdGhpcyBoZWFkZXIgZmlsZQ0KPiBJ
IGhhdmUgaW5jbHVkZWQgYSBtZXNvbiBidWlsZCBvcHRpb24gbmFtZWQgJ2luaXBhcnNlci1pbmNs
dWRlZGlyJyB0aGF0DQo+IGNhbiBwb2ludCB0byB0aGUgZGlyIHdoZXJlICdpbmlwYXJzZXIuaCcg
Y2FuIGJlIGZvdW5kLg0KDQpUaGlzIGFwcHJvYWNoIHNvdW5kcyBmaW5lLCBkbyB5b3Ugd2FudCB0
byBzZW5kIGl0IGFzIGEgcHJvcGVyIHBhdGNoLg0KDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbWVzb24u
YnVpbGQgYi9tZXNvbi5idWlsZA0KPiBpbmRleCA0MmUxMWFhMjVjYmEuLjhjMzQ3ZTY0Y2EyZCAx
MDA2NDQNCj4gLS0tIGEvbWVzb24uYnVpbGQNCj4gKysrIGIvbWVzb24uYnVpbGQNCj4gQEAgLTE1
OCw5ICsxNTgsMjcgQEAgZW5kaWYNCj4gwqANCj4gwqBjYyA9IG1lc29uLmdldF9jb21waWxlcign
YycpDQo+IMKgDQo+IC0jIGtleXV0aWxzIGFuZCBpbmlwYXJzZXIgbGFjayBwa2djb25maWcNCj4g
KyMga2V5dXRpbHMgbGFjayBwa2djb25maWcNCg0Kcy9sYWNrL2xhY2tzLw0KDQo+IMKga2V5dXRp
bHMgPSBjYy5maW5kX2xpYnJhcnkoJ2tleXV0aWxzJywgcmVxdWlyZWQgOiBnZXRfb3B0aW9uKCdr
ZXl1dGlscycpKQ0KPiAtaW5pcGFyc2VyID0gY2MuZmluZF9saWJyYXJ5KCdpbmlwYXJzZXInLCBy
ZXF1aXJlZCA6IHRydWUpDQo+ICsNCj4gKyMgaW5pcGFyc2VyIGxhY2tzIHBrZ2NvbmZpZyBhbmQg
aXRzIGhlYWRlciBmaWxlcyBhcmUgZWl0aGVyIGF0ICcvdXNyL2luY2x1ZGUnIG9yICcvdXNyL2lu
Y2x1ZGUvaW5pcGFyc2VyJw0KPiArIyBGaXJzdCB1c2UgdGhlIHBhdGggcHJvdmlkZWQgYnkgdXNl
ciB2aWEgbWVzb24gY29uZmlndXJlIC1EaW5pcGFyc2VyLWluY2x1ZGVkaXI9PHNvbWVwYXRoPg0K
PiArIyBpZiB0aGF0cyBub3QgcHJvdmlkZWQgdGhhbiB0cnkgc2VhcmNoaW5nIGZvciAnaW5pcGFy
c2VyLmgnIGluIGRlZmF1bHQgc3lzdGVtIGluY2x1ZGUgcGF0aA0KPiArIyBhbmQgaWYgdGhhdCBu
b3QgZm91bmQgdGhhbiBhcyBhIGxhc3QgcmVzb3J0IHRyeSBsb29raW5nIGF0ICcvdXNyL2luY2x1
ZGUvaW5pcGFyc2VyJw0KPiArDQo+ICtpZiBnZXRfb3B0aW9uKCdpbmlwYXJzZXItaW5jbHVkZWRp
cicpID09ICcnDQo+ICvCoCBpbmlwYXJzZXIgPSBjYy5maW5kX2xpYnJhcnkoJ2luaXBhcnNlcics
IHJlcXVpcmVkIDogZmFsc2UsIGhhc19oZWFkZXJzIDogJ2luaXBhcnNlci5oJykNCj4gK8KgICMg
aWYgbm90IGF2YWlsYWJsZSBhdCB0aGUgZGVmYXVsdCBwYXRoIHRyeSAnL3Vzci9pbmNsdWRlL2lu
aXBhcnNlcicNCj4gK8KgIGlmIG5vdCBpbmlwYXJzZXIuZm91bmQoKQ0KPiArwqDCoMKgIGluaXBh
cnNlciA9IGNjLmZpbmRfbGlicmFyeSgnaW5pcGFyc2VyJywgcmVxdWlyZWQgOiB0cnVlLCBoYXNf
aGVhZGVycyA6ICdpbmlwYXJzZXIvaW5pcGFyc2VyLmgnKQ0KPiArwqDCoMKgIGluaXBhcnNlciA9
IGRlY2xhcmVfZGVwZW5kZW5jeShpbmNsdWRlX2RpcmVjdG9yaWVzOicvdXNyL2luY2x1ZGUvaW5p
cGFyc2VyJywgZGVwZW5kZW5jaWVzOmluaXBhcnNlcikNCj4gK8KgIGVuZGlmDQo+ICtlbHNlDQo+
ICvCoCBpbmlwYXJzZXJfaW5jZGlyID0gaW5jbHVkZV9kaXJlY3RvcmllcyhnZXRfb3B0aW9uKCdp
bmlwYXJzZXItaW5jbHVkZWRpcicpKQ0KPiArwqAgaW5pcGFyc2VyID0gY2MuZmluZF9saWJyYXJ5
KCdpbmlwYXJzZXInLCByZXF1aXJlZCA6IHRydWUsIGhhc19oZWFkZXJzIDogJ2luaXBhcnNlci5o
JywNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGhlYWRlcl9pbmNsdWRlX2RpcmVj
dG9yaWVzOmluaXBhcnNlcl9pbmNkaXIpDQo+ICvCoCBpbmlwYXJzZXIgPSBkZWNsYXJlX2RlcGVu
ZGVuY3koaW5jbHVkZV9kaXJlY3RvcmllczppbmlwYXJzZXJfaW5jZGlyLCBkZXBlbmRlbmNpZXM6
aW5pcGFyc2VyKQ0KPiArZW5kaWYNCj4gwqANCj4gwqBjb25mID0gY29uZmlndXJhdGlvbl9kYXRh
KCkNCj4gwqBjaGVja19oZWFkZXJzID0gWw0KPiBkaWZmIC0tZ2l0IGEvbWVzb25fb3B0aW9ucy50
eHQgYi9tZXNvbl9vcHRpb25zLnR4dA0KPiBpbmRleCBhYTRhNmRjOGUxMmEuLmQwODE1MTY5MTU1
MyAxMDA2NDQNCj4gLS0tIGEvbWVzb25fb3B0aW9ucy50eHQNCj4gKysrIGIvbWVzb25fb3B0aW9u
cy50eHQNCj4gQEAgLTIzLDMgKzIzLDUgQEAgb3B0aW9uKCdwa2djb25maWdsaWJkaXInLCB0eXBl
IDogJ3N0cmluZycsIHZhbHVlIDogJycsDQo+IMKgwqDCoMKgwqDCoMKgIGRlc2NyaXB0aW9uIDog
J2RpcmVjdG9yeSBmb3Igc3RhbmRhcmQgcGtnLWNvbmZpZyBmaWxlcycpDQo+IMKgb3B0aW9uKCdi
YXNoY29tcGxldGlvbmRpcicsIHR5cGUgOiAnc3RyaW5nJywNCj4gwqDCoMKgwqDCoMKgwqAgZGVz
Y3JpcHRpb24gOiAnJycke2RhdGFkaXJ9L2Jhc2gtY29tcGxldGlvbi9jb21wbGV0aW9ucycnJykN
Cj4gK29wdGlvbignaW5pcGFyc2VyLWluY2x1ZGVkaXInLCB0eXBlIDogJ3N0cmluZycsDQo+ICvC
oMKgwqDCoMKgwqAgZGVzY3JpcHRpb24gOiAnJydQYXRoIGNvbnRhaW5pbmcgdGhlIGluaXBhcnNl
ciBoZWFkZXIgZmlsZXMnJycpDQo+IA0KPiANCg0K
