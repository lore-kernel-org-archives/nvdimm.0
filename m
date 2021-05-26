Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C0E2FAE
	for <nvdimm@lists.linux.dev>; Wed, 26 May 2021 19:31:29 +0000 (UTC)
IronPort-SDR: +wL1bOCcy7qO9kF5puiO1CacmKE5Vg4wzNDZo1cihAAtCMdkwueB3z+9D/N4DYVwHIZZnF5Zjh
 wgJfOMcBFWEw==
X-IronPort-AV: E=McAfee;i="6200,9189,9996"; a="202314296"
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="202314296"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 12:31:26 -0700
IronPort-SDR: NOzhNlOtmIiIJbG1DKuGZJ3ScYeeHZrd92u1AJJJa0S4qHfAJBWIJq/r1YcrFvMiMffOv3ZFKn
 Anc/Mz9NKMdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,331,1613462400"; 
   d="scan'208";a="477089463"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 26 May 2021 12:31:25 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 26 May 2021 12:31:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 26 May 2021 12:31:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 26 May 2021 12:31:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2P44/PbjYapPrHHoziyGQoP+RcSAJNd9v5YjqayQpErIDZvNWN9WY3HBodhv007+Id43JrShywV0YcpVXuuc8WYU+UKLDA+mhDbBrpGADRk8xvOdYNmpfRs9I6m01VpqTbKJUYIAaSFeDkxUa+AMqVjL7ZS+mnn2ZE/4dd5FiutriFD8qki3OFCaWPV2XoUfBACTx+KR/OEOC+JTtASppuEd179/GW3FDS00R0Y4ar6ZBvY9cwFr1Ls2S5Tyifx00eLU8ZR0wJiX5AdLAYVsYNjX08nQt7JWrSN1e28JP6IcShzFig3armgO8vtvdlD0NATwMtbtWhXCkrjRKsB0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dhfbC+nrQMOqTxXUt25ZLb3ZFxN8QXo07f1nj2w5wy4=;
 b=RUfeTR3PPRCL2JS+WNZYUkruvdDezFYTPXKVJi0AhhkSqdt2cV8ixnClA0+89hCXGJ4A1nKfWNVX5F69KO4V8zGzHn0v6n3g0d7bL+LB7E/0FLTB1j13d7xHSYpztmnd3GNHE9P27HIUhfd3My7tQZqsNzLVHCQMHViL/HudB0+aEMg8gxBiW8HpewtOL6Fi8No88fAxgnGvULaAiJfDXMMvM6vSAxsSCqIZcUwhbAR/3I1NiwRqclCePUG+hqN2ziN50fueEkG8z6txFNFoGOBaaA0634xnlFdmNs6E85ky/s++4H+F3b3MMx+pbGctOnXdYm2LCNJBKg27rDV/PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dhfbC+nrQMOqTxXUt25ZLb3ZFxN8QXo07f1nj2w5wy4=;
 b=Nq02laDrwERfTaKo3AGlupUYUS54UPy1us1Oeh1OCOblicquf9MiP1Szjko0EQCWw4Q1P17kO7ze6J4fVfm+gIukFv7UlKAJSpg9fF/tzoRl159cJ93RTq6S1djo6BKTGLCj39+k/vzOnAo+TecuIQjgdBQmP2PxY4AfPdnIiYo=
Received: from BYAPR11MB3448.namprd11.prod.outlook.com (2603:10b6:a03:76::21)
 by SJ0PR11MB4815.namprd11.prod.outlook.com (2603:10b6:a03:2dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 26 May
 2021 19:31:24 +0000
Received: from BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::713c:a1f6:aae4:19fc]) by BYAPR11MB3448.namprd11.prod.outlook.com
 ([fe80::713c:a1f6:aae4:19fc%5]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 19:31:24 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "santosh@fossix.org"
	<santosh@fossix.org>
CC: "sbhat@linux.ibm.com" <sbhat@linux.ibm.com>, "harish@linux.ibm.com"
	<harish@linux.ibm.com>, "aneesh.kumar@linux.ibm.com"
	<aneesh.kumar@linux.ibm.com>
Subject: Re: [ndctl V5 4/4] Use page size as alignment value
Thread-Topic: [ndctl V5 4/4] Use page size as alignment value
Thread-Index: AQHXR78dliwb0fNPv0qbbfUYRWQK7qrhuPoAgBSC84A=
Date: Wed, 26 May 2021 19:31:24 +0000
Message-ID: <6708790151b3f627bafb2eedd21dca000372a4e9.camel@intel.com>
References: <20210513061218.760322-1-santosh@fossix.org>
	 <20210513061218.760322-4-santosh@fossix.org>
	 <27307f1aceeda53154b9985f065fdada71cf1fd4.camel@intel.com>
In-Reply-To: <27307f1aceeda53154b9985f065fdada71cf1fd4.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.1 (3.40.1-1.fc34) 
authentication-results: lists.linux.dev; dkim=none (message not signed)
 header.d=none;lists.linux.dev; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.137.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1359a140-a791-495b-7c6b-08d9207cd949
x-ms-traffictypediagnostic: SJ0PR11MB4815:
x-microsoft-antispam-prvs: <SJ0PR11MB4815FC134D89CAF0EC5D5F50C7249@SJ0PR11MB4815.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PoPlmWU/8ODFCMDKgDCHe8F3kxY3KBz5E1rbb4rjQovn564jxs0VHu9BIEt32rqCC99tpu6iA8TiFPlsVWivwJdsBvARgmYIx6HnmeBmSi8t2MCmVGpUg6Tr5866KXNpj+9q9n8U9HUQ0QQchf/Z+XIdmKlOyBDYti6w+GcIJt6ujvRCruNSWoNh3tmeqQ/LAz58QzbfXngWzI8Wgzr6bqk1Kt3j0dEnrJpkPFoeiswtVjlRDy181a11Jqa46CqtqQtkCMjN9J0/KhW3Nx4kiZUEh7HFHsLtdPR+BMvb/6gOL7mm5eyBD9eIMJWJwL3b6DZ5mrPh2bKalIMqEp+5oG1BTohk923RHVNoBNPbJ2n7/wHwDI0qYttU7ULdRCcKYRK4AWI5S0iP2Bos+8HMLB0cmVIfO6ng66Xr/QMik0Pvdf7P2+2nC5G0pjmsg2UTTEUVb8X2s1bD1g91AmMQb85LLXQPujti6pbsvQQRnPHqlExiELJ/IVxAHNAysC1+JBMz6wpYjHT8aKEm+lo7awx56270+qw4zVlW9dYPwk3lGd75cJGUyd8OxM1x21Rws6fOeSLrN+hhepodVx+WZGnYgHpp21ObPyOxFpRuW/s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3448.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(136003)(396003)(346002)(5660300002)(2616005)(2906002)(71200400001)(4326008)(64756008)(66446008)(4744005)(66556008)(86362001)(6512007)(8676002)(186003)(8936002)(66476007)(6486002)(122000001)(6506007)(83380400001)(110136005)(26005)(54906003)(478600001)(76116006)(91956017)(66946007)(38100700002)(36756003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TnRNSXdpbXlUd20yUGdnZkxpNW1DRUcwcWczU2l1K2pPSTJoQXM1VGNDOTVx?=
 =?utf-8?B?T1RORldtTWd4QmRnN1JTendmL3lCdTFBRWl4MHk1RlZlV0FBSHl2RkxjOFNQ?=
 =?utf-8?B?My9OSEljQ0pRSFdZUHN2NnozY0NwU0FkUjR0RXgrV2NNVW1DWUxPQldpWmhF?=
 =?utf-8?B?SFc3ZkJXSmhBMnhEd2JFT1J0bDhub2dQVExmYUx5ZDNlZ2lLVXZnY1MvQUhH?=
 =?utf-8?B?R1c0Y0pBcDdhVEV5TFNsUzVVS042ZVFkdFNxZU50MStBT0lVN0dPMS96L1hv?=
 =?utf-8?B?OEV1d0t0TndQRldZTWFKdkMvcW5KMHlTendtc0tJeE9ISGlOUlFkTDRsejJt?=
 =?utf-8?B?YkNScWpZR0xCZmZDUnNyRzFCWm5weE1ZQWxWbWlFMlc3RTlFczNCLzFHRVNR?=
 =?utf-8?B?c0tySE9XNzZuV01vV1hmVWJia1NUTEZyYVFpRWZzOFN2cktJNHNVbGVieE5J?=
 =?utf-8?B?OFlINXFSWGV0RE01by9BeFc3N3hmZ0NoVERwa1lhSDVzRW9URXlvbjdka3ZN?=
 =?utf-8?B?Q0RvUlBzWjhYWEpGeVB3VW84QTlSN2ZweHRpN3BSSkZid3RoU1JsSTV3Q0lQ?=
 =?utf-8?B?am1yMFR4eW5FenFMSTRDNDRyYnZYUUN0Z1h6VTMyeVRnYzBLK0M2cFBzQ3B5?=
 =?utf-8?B?cXlQMTAzZmRQaGlrRVZxSHM4QU5zNHdVNnhlSlVObEVvcG92TXFLT1BEWjBD?=
 =?utf-8?B?cE1MeXR6MzF4dTdHV3gvT2NPdE83b3ZVYTJZZDEyR2hqSCt5SUhGdU91REVm?=
 =?utf-8?B?ZXljcFVzbUROeHJteEhmWnhIZ2lQNU5UOHh1RGJLVzJNMUkvdlJYR1c5SnpR?=
 =?utf-8?B?VERMVjYxWDJWa1dWa0ZlYVZOSnVKREpmRlY5UlczN1hWVDVvTHg1ZWVqUzdM?=
 =?utf-8?B?bk8zd0VhcjVqS2J0TGVlNi9YSUswaDJQbU9ocWY5WEV2endNS1lsUFNEQlFq?=
 =?utf-8?B?VE5ibTIrS1JSVkViek9hU0RuRTYyWmpZeGRIcmlqK3lid1NqMi8ramN2NFJs?=
 =?utf-8?B?aXhrM3dzZUdFeXdRN1lSR3JTaGxaV2F6V292MWM5NXJWZW9zdmNYR1VCazFm?=
 =?utf-8?B?d0lyc2poWGE1czN3OHc2UVdHNXBUUCtMZGdVaERGM3dEVkp4MytJcGNZZ3hX?=
 =?utf-8?B?b2ZyUjNudUxSTnBOMVZBNmtDR2luQzFYLzM1U1ZqNHdZMzV4d2lXYXR5di9T?=
 =?utf-8?B?RUZFekRFVFBVbnpRN2FMWCtEMzNwSmRlOGJTSGROa0tTby9kQk1JcTU1T1Jl?=
 =?utf-8?B?azd1RkI2NTVIUytLTVQvSS82VkFvZzRodkxUZ3B6eGd4WVN4RjdxQkZtMFk0?=
 =?utf-8?B?UTdqN1pyMytKK2YzRm5VS2lMNWNRTEdudGhpRjAydnQxcjZobUxWbWRBQXV2?=
 =?utf-8?B?UUgwRTU0MnpTMG1TSitHMUtZclJKT0dqNTlNTkxkKy8wajN3VU9yNVU1SXh1?=
 =?utf-8?B?QndxQjlZaUdkUGI0U1h3aEJPdkkzeTdUdHJNdUVITUlZVWFPUkFCM0FWR2w0?=
 =?utf-8?B?ZHRYN2lzWUhNRTN6U0V2NFh1Z3JuL3VTN3NNVDZHWEZBelU3Umd2eFE1Q1Js?=
 =?utf-8?B?UnZUcTV6UUtGWHk0Z1hHaHdpNWx6YVhRYURNc29XSjQzYnloYk9HcmhlZm9M?=
 =?utf-8?B?MHJMYzI2R3BqemNVbGNGSGRQNWZPaDhsQ3ZUUHBIT0IrYTRWejFQSnVnQkFX?=
 =?utf-8?B?RERVZnRoTVBIWW9udkh2NlpVOGhZVWoxZFVqaE1TSDRETzY5ZVpUbmVIVGRS?=
 =?utf-8?B?YktDQ0k1NVlIYUxoeUt0NDJnaEZzazAreUZSTmw2V043a0tUTFEweVlTT1dQ?=
 =?utf-8?B?MGRjcG5jNU82akJPVHVkZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E6E3A7AC929D54E833FA98132D632B9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3448.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1359a140-a791-495b-7c6b-08d9207cd949
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2021 19:31:24.2101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WE8LI85DQWaj5B939V+YqW8isVXWyvwrV0Cx55qKfUm0qoob4eBjOFmEqnVsUrRuWGphWPoTbf27MtradEAARK8uOyO0E5xSzp3D5r3dfQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4815
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTA1LTEzIGF0IDE4OjE3ICswMDAwLCBWZXJtYSwgVmlzaGFsIEwgd3JvdGU6
DQo+IE9uIFRodSwgMjAyMS0wNS0xMyBhdCAxMTo0MiArMDUzMCwgU2FudG9zaCBTaXZhcmFqIHdy
b3RlOg0KPiA+IFRoZSBhbGlnbm1lbnQgc2l6ZXMgcGFzc2VkIHRvIG5kY3RsIGluIHRoZSB0ZXN0
cyBhcmUgYWxsIGhhcmRjb2RlZCB0byA0aywNCj4gPiB0aGUgZGVmYXVsdCBwYWdlIHNpemUgb24g
eDg2LiBDaGFuZ2UgdGhvc2UgdG8gdGhlIGRlZmF1bHQgcGFnZSBzaXplIG9uIHRoYXQNCj4gPiBh
cmNoaXRlY3R1cmUgKHN5c2NvbmYvZ2V0Y29uZikuIE5vIGZ1bmN0aW9uYWwgY2hhbmdlcyBvdGhl
cndpc2UuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU2FudG9zaCBTaXZhcmFqIDxzYW50b3No
QGZvc3NpeC5vcmc+DQo+ID4gLS0tDQo+ID4gIHRlc3QvZHBhLWFsbG9jLmMgICAgfCAxNSArKysr
KysrKy0tLS0tLS0NCj4gPiAgdGVzdC9tdWx0aS1kYXguc2ggICB8ICA2ICsrKystLQ0KPiA+ICB0
ZXN0L3NlY3Rvci1tb2RlLnNoIHwgIDQgKysrLQ0KPiA+ICAzIGZpbGVzIGNoYW5nZWQsIDE1IGlu
c2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPiANCj4gVGhhbmtzIGZvciB0aGUgdXBkYXRl
cywgdGhlc2UgbG9vayBnb29kIC0gSSd2ZSBhcHBsaWVkIHRoZW0gYW5kIHB1c2hlZA0KPiBvdXQg
b24gJ3BlbmRpbmcnLg0KPiANCj4gDQpIaSBTYW50b3NoLA0KDQpEYW4gbm90aWNlZCB0aGF0IHRo
aXMgcGF0Y2hbMV0gZ290IGRyb3BwZWQgZnJvbSB0aGUgc2VyaWVzIC0ganVzdA0KbWFraW5nIHN1
cmUgdGhhdCB3YXMgaW50ZW50aW9uYWw/DQoNClRoYW5rcywNCi1WaXNoYWwNCg==
