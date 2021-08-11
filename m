Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57071177
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 21:18:31 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10073"; a="195492614"
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="195492614"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 14:18:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="676381786"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga005.fm.intel.com with ESMTP; 11 Aug 2021 14:18:30 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 11 Aug 2021 14:18:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 11 Aug 2021 14:18:29 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 11 Aug 2021 14:18:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPbVs1llIAN2f34KYzI5oEz0YVG1Lm9EItv5fL3XnSnUL6gbE9hr7Ruf0YpkQOlceFFz3cCDt3qRkx75OP9yi4yXJyO6Tn7AefChoOnUgJZG8QOB9JTj/zm7Vl3BlVQqQYC7Vi/WMwxQ8Z8jIz7LPE0RjqzEtQnabN3TSu1OZ6BI+N5Pq+KYlh4wiUa/IX+KGGqQfKSBa2Tc9FgTdBi3IjdjGaZ/aaYY6obuLOxAGwf33nsTZTKrVWHKblRx00q5pFZhnNmvI/NiGgtLYhQsOGjOBINlxntyQ+UJ5Wc1R3REngi71Ykvg7qAJUMTvFSDcmqkTMEE7oP3a/YrT2ANvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uu6VFMxhQVXVh28lq2Bev87mErW+jul2i0n+WpsbfNQ=;
 b=K1ZOO9CVT4h//L9vWoYtlffMmlGw1ltFBL5WT/Kt3nqBLfVhQbxbvfVzHouLcnEKB5UYxJ1lhQxMRP2cgrJ+BMmlBkdn1zmCkB/mhLTgqjh28Bjhd+ZACEfyucVx7WQwa/Vsp9IUX2eBx/ZYkkifNsElb1joI3M1tJ9IKGCucBfI0clzsVBe3khS66IKI6AnvH9IF67wre1RMfmn8zSbSlz5YRRWr/A0suTJO+SJWYQMB9mEp9iYHzTkbgwT9m0PAh80aVkqNPI6dxeO91wrJw4us1M/qO7Q7zfCL1U/HmcDY0C5iJF3SgRIemwbMCIvPHj8jLKiZbPRxvmkR3cdFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uu6VFMxhQVXVh28lq2Bev87mErW+jul2i0n+WpsbfNQ=;
 b=upwqBq7Zhd+ievBoLRQH4/dQp2Wp5WNVJkqDqq/swWyfW1t2XVdlLa2jsbriJEhaDlDcmC5GKDIgA8Bi2ejJOnbWuxFuPZ8kyN3Oh12xZFqAc4BLKN+NPhXnjwSBjOoZkfMmOSjXPRV/NFGZG/KISqgIR70+WgJT3IOAfDjDGFA=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SA2PR11MB4809.namprd11.prod.outlook.com (2603:10b6:806:112::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Wed, 11 Aug
 2021 21:18:26 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::4046:c957:f6a9:27db]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::4046:c957:f6a9:27db%5]) with mapi id 15.20.4394.023; Wed, 11 Aug 2021
 21:18:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "Lutomirski, Andy"
	<luto@kernel.org>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH V7 12/18] x86/pks: Add PKS fault callbacks
Thread-Topic: [PATCH V7 12/18] x86/pks: Add PKS fault callbacks
Thread-Index: AQHXiOnGGMlgqBGNSEWRm1GCvO+77Ktu2wOA
Date: Wed, 11 Aug 2021 21:18:26 +0000
Message-ID: <1bb543ebdf5458e90bff97698ee3a1cf69f89aa1.camel@intel.com>
References: <20210804043231.2655537-1-ira.weiny@intel.com>
	 <20210804043231.2655537-13-ira.weiny@intel.com>
In-Reply-To: <20210804043231.2655537-13-ira.weiny@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25c22c30-4e7e-4e2f-8c91-08d95d0d8ece
x-ms-traffictypediagnostic: SA2PR11MB4809:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB480957A4A358BF1B190DEB89C9F89@SA2PR11MB4809.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k/xWLO5tGtplzp6MCY0J3bxuMRNRgH41wExQfb4UNCAz/dsKOySi1Q+3lXwiBK9gCtG0LnwrRhEgZwJIk3AkUykSxl2nnVUB1ydgLcAJwIlmuhS22kQ/OX88N1lwsW92uXQlG8u1Bxt/layjrEhRwMlexMAeVBk5GePFBRIiSlQvmtIJUJkiV7Jgj74TyAPesyRyK9qXAZvTXXSJF+bBynaBak1FhU+eHc03MCCh2aH4w5BDeqS71L9mXxvNvubU7y0VEA/aPZoTlqh+fpvZHwEn1BQXAPhdQmbGixt/399nvR4PCaNDP9NgM1wlbILdRxg/HOzGEoIAbvg1aLMWTMigmfZoAebGus/E2DW0sTGHI2Xxo4Y5DYsa4ThF67faGOwKaJ5fsNIIpSfoDEsPbKOxV7maCUqcV/nZIYQ0OtrX2VbTLRW44oNoQo4p8WQ4SuFZHL9nGoeO+hoXVcl87dUWqUWlfbaVHqVpzBV2FTq+xfMcqXmnnjpQPHkaPa1K7D+2Zjq3ajLPR4SuzJx2nKnXEQc7Hx9PIpdgvGTj+knmlmAiaF2SwO3YyM+GCIzxC3CGfHdKJPixFKIEPGqTnG/QJW53s4BMI7TPg6RsiLFYRU5+dFOArQG22zYfbOy1Jnt2Lak3nDQOeNRuHR/wcHcsvPGsK1FiWbidMT+Rh0KvPF0FdRck1dYeV2t71Pz11DDvOEJIX0rmyefVPGgDb8E9vZge6hyHMJAXMAKRQ0k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(110136005)(2616005)(8676002)(2906002)(4744005)(122000001)(66946007)(316002)(6486002)(5660300002)(7416002)(66556008)(54906003)(86362001)(6512007)(38100700002)(66446008)(64756008)(66476007)(71200400001)(91956017)(76116006)(26005)(38070700005)(186003)(4326008)(36756003)(6506007)(8936002)(478600001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWJFdXNUclMreitSZ2NZeWFwenZUWkVla2NPTWR5TkdNcnkrSHQwcWtXUzcz?=
 =?utf-8?B?SFYrUUI0c1Y3L1hMWjRhb3hhKzNNUE5UcGJPdnpZamFBQWNUU2ZWZFFmaW1a?=
 =?utf-8?B?MFMzbUY1eEJOQ1ZSeEVQTldORG05WUludzJYdmFybDIxU0V5MDJGNlhLbWlY?=
 =?utf-8?B?V1VyMlJaVS9kdTlDODRJOENwVmVSL0lWdHJQakFPN3dGOHpzNy9ONzFPc3l0?=
 =?utf-8?B?RFlTd0VzWXRtQTFydEZ0MEhVQ2JIWmJQY3F2RzdpTWt2TTJLSjZMUVFMSjJk?=
 =?utf-8?B?TTd2MHhzcDRqUzhYQ0gweG40ZVJRRE5aZzgxTUpNZGJhQlVyelIzNjdndnYz?=
 =?utf-8?B?c0ZkZEFyT1l3ZDdNL3hPRlB3KzJCL001SUQyVDVMZnRDZW01a3FWd2RWTEZh?=
 =?utf-8?B?N0JMQXFzTTVwYXhUeVZ4M2lYTDhKc1AxOVd4R1JIa1NQdW9qNXhPWlZPU0N2?=
 =?utf-8?B?MHV1TmF0WlFmTTlZRmRIU0FZay9hK2hmN1QzQjFxRnVyT1ZHTlhrS2hhcmlp?=
 =?utf-8?B?SVBkREFzWXp0Q0U1U2d2UDlPWDdSNWwrUXpRTElSUmxUcW9xUXRkTmZFYit1?=
 =?utf-8?B?S0tCdDVMdEZDYVBMSDZ0b3Y2bEVEL3lpenoyWjJPUnZQWDZ4QU5jS0ZRV3ZS?=
 =?utf-8?B?QlV0bFc3d0tDRTJ3YUJMWEZ2ZmxVSUJWd1gzK2JzSk40UmVJOGgyN1RpOUtv?=
 =?utf-8?B?NnRCTkVyRW8wR0JXWkdOOFhsSG9KUlpGeUg1U0xpaS9DcnEvVUdyUlp0dFdr?=
 =?utf-8?B?ZkkwZ25QV2IxWTA3ZHQrR05NT3EwN3FiVUhtSFdHUlhuVFk1RXJqUy9BR3dD?=
 =?utf-8?B?czh1MDVxMGFWZnlqeDZhaVRCQSs2dSt4RWlvUHAxYkFSektTOVhSL1M3d3ZP?=
 =?utf-8?B?ZmRDSjR4R1ZIRlhLYTBLeDdYdC9HM052aHcza2N0bys4V1JnUUY4dVNUWTZu?=
 =?utf-8?B?UWNGWmJYTTBQdy9nSFRyeEZGZlo4UFNyRDBTNnBVK2U3bDU2UDdEOG1ua050?=
 =?utf-8?B?ZlBDRFRuZXpDTDVjOUpkNCtCblhjWkF6Ukh2K0h0K3JoWWhGV2FQUE15b1RL?=
 =?utf-8?B?dk1VbXJjQjdaZ2tKVVB1Y0N6dm52OHV5M3J5S016MTY5VDJGVzJRcENRSkVq?=
 =?utf-8?B?WHVyVWs5d1ZHRzN4dzlKdmtuZW9VVVVYV25pQmtFSGpjS2dXV0p1VElKSGhI?=
 =?utf-8?B?b3BpdXF2OGhDUTg5akM4eVlJU1pad1VWRVlJU3MyRnhGcFJzTy9LcExJQjg3?=
 =?utf-8?B?dXRNL1J2SVF4aGtMMTdvSEVoWndJMktVZlB6bGlwaFRBdjB0cHliSk00dlJ6?=
 =?utf-8?B?cVJEKzk0c0RaNUNhcWQ0WENmVU81a1R4RnUvdUN2VUVFbTJ6Y2JkSmhJK2hq?=
 =?utf-8?B?M1VPZks4T3RmVE8rdkwreWowMlRhMmc0My9aeTZJeEczSDJpYXlaejV5d3Jj?=
 =?utf-8?B?RFJHeE1nVEhNWFdkUnh0K1U0Q0xVRkVBYzQ0ZlhRd1VvYXlEL1hQcU02c0Iv?=
 =?utf-8?B?RkFLVzZNblZZTHpIVnJYeHFzVlBKMG5lMkpta2g5U0hDTGcrUkdJZWs4b1Br?=
 =?utf-8?B?dnN6NXlTSGhCZmxhMmU0ZkZwRXJ5cXhNaUxDUlBLeWJaWVR6NE5IMVk5Y3dm?=
 =?utf-8?B?eGhvT3N3YmZ5T1kvbXRoclN1Z3FPaTFLMjQ4KzRNSkZIVktsYXlEK2NuSWZP?=
 =?utf-8?B?RDNJcGlwTzd0OTYwTGIwWnhNTDBZY28yQUVSZlIrTzhSUGlzalhpSVRSWFZ2?=
 =?utf-8?B?MG45QUlqdk1qbzB1c2dBeFdjZ3NkQ1hZaS9EbmVpNnRPUFNycTVyMjJROTBy?=
 =?utf-8?B?TW5CU0JuL0lOU0lBVFBvZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <38F6F337E0B0D14091C654ED122A116C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25c22c30-4e7e-4e2f-8c91-08d95d0d8ece
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2021 21:18:26.0405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h4WyNPpe6FX6Rx7bTsjrrn1XgOKNS1w4QfTZfoWijFAP3Uo8ZJ2AQD1IyXt2ubo5pXyznRRAXBUkWWyb9jlXD3I0y6cJxokSO13/vYOw6lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4809
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIxLTA4LTAzIGF0IDIxOjMyIC0wNzAwLCBpcmEud2VpbnlAaW50ZWwuY29tIHdy
b3RlOg0KPiArc3RhdGljIGNvbnN0IHBrc19rZXlfY2FsbGJhY2sNCj4gcGtzX2tleV9jYWxsYmFj
a3NbUEtTX0tFWV9OUl9DT05TVU1FUlNdID0geyAwIH07DQo+ICsNCj4gK2Jvb2wgaGFuZGxlX3Br
c19rZXlfY2FsbGJhY2sodW5zaWduZWQgbG9uZyBhZGRyZXNzLCBib29sIHdyaXRlLCB1MTYNCj4g
a2V5KQ0KPiArew0KPiArICAgICAgIGlmIChrZXkgPiBQS1NfS0VZX05SX0NPTlNVTUVSUykNCj4g
KyAgICAgICAgICAgICAgIHJldHVybiBmYWxzZTsNCkdvb2QgaWRlYSwgc2hvdWxkIGJlID49IHRo
b3VnaD8NCg0KPiArDQo+ICsgICAgICAgaWYgKHBrc19rZXlfY2FsbGJhY2tzW2tleV0pDQo+ICsg
ICAgICAgICAgICAgICByZXR1cm4gcGtzX2tleV9jYWxsYmFja3Nba2V5XShhZGRyZXNzLCB3cml0
ZSk7DQo+ICsNCj4gKyAgICAgICByZXR1cm4gZmFsc2U7DQo+ICt9DQo+ICsNCg0KT3RoZXJ3aXNl
LCBJJ3ZlIHJlYmFzZWQgb24gdGhpcyBzZXJpZXMgYW5kIGRpZG4ndCBoaXQgYW55IHByb2JsZW1z
Lg0KVGhhbmtzLg0K
