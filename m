Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0219D26AC0
	for <nvdimm@lists.linux.dev>; Tue, 14 Nov 2023 22:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d3yZniOO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700001835; x=1731537835;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hvELhPnTQ4y/Vv/JgqwruG/Gpujp9+CrsB1gqlVA8tw=;
  b=d3yZniOOn8jMwhONl+o4YeDU1NtMWhHl1jotHZMgGLx4KNFHs70mvE7g
   7tRYRycHpRAlF6Ec0Q9oYbgBGrg6TWXizdINiDQ9N3COauFHI6qIlRmOO
   z2Cdu1pVy4u7BBfioGO4d/ofJrSF0gVQEc5+pzkm/Te3DUVnIcEoBcXo3
   1750CLm4EIkz2se19IEqVZ5MzBdVQ41fConk3GC6G2JeYylcEmQdbQTz6
   eLENkUhIMCi/aPFyw/nro8RI65mrPSMIllbbQFwijIzObPVmatUiZo62g
   VLLY33mDvIvyCM+EkUBzraijmdL8ylrZItuirj6a/BLIJcDzIGe4O2YaS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="421860897"
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="421860897"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 14:43:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="741234078"
X-IronPort-AV: E=Sophos;i="6.03,303,1694761200"; 
   d="scan'208";a="741234078"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Nov 2023 14:43:53 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 14 Nov 2023 14:43:53 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 14 Nov 2023 14:43:53 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 14 Nov 2023 14:43:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCmIshyHo9T4u2W2ldbYZkOSLnOwxq+oOsGDeM/mv+eVW2tyaXg6EPkNKmk/huPsuCSz9DpowulduHI+lTn4d7CFgA/aSQUlqjbfZN0AmFMAoVnJO5X0+AHLeAan7dp2ohAkk6J8SSmilyCokhnscvPUWRjTPSLM1BEykYuCHb5CE7EK9npGXj8Fu8naK/nvqWS6zS16FK1LSPxxLdTtqyfkIq/CKun2/X7Rye96HBJUrn5ZfwqXa9+SRrPJ9GGt7KhXMal0B+OpvpmPezOvmwsttq4jSCHMiIAyEMbACSeA2S4dPpm4ZsTeO5lE/J26aKbfC/PLoSNq6ZCeAWi/Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hvELhPnTQ4y/Vv/JgqwruG/Gpujp9+CrsB1gqlVA8tw=;
 b=MVOTud1PEo5kvigwHeIPtFvFg8+vZ+HQQFWtLdWPxibe6uWP1M84W2ZPJY9jhNJEzckWjU2dnfTHWkjq2roYAVsT/72Ur7cfnQGdYK1DqPg0dY+8vamGFyqcnWkqWtJWLP5ZhogDqWH6cF+2CMbTlZVT+yhjTk0eoDegGoIvAVxigaPAwQIsTt0NtlliB4AZrlB82W70l+aDrGDQR6Y9MWDCMYjimUii9f+IzEyVxePnTBxER+j8lL92o+7iYVNHYNoEYNJTBo0EtIwV1okqLoEeUgMXyOlzHWfNQscf5seA3mzPoIHMiDIELQlkB9Hdre249thf1KJggOdpl5Z6ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by PH7PR11MB7122.namprd11.prod.outlook.com (2603:10b6:510:20d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.25; Tue, 14 Nov
 2023 22:43:51 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::703a:a01d:8718:5694%7]) with mapi id 15.20.6954.025; Tue, 14 Nov 2023
 22:43:51 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH] cxl: Augment documentation on cxl operational
 behavior
Thread-Topic: [NDCTL PATCH] cxl: Augment documentation on cxl operational
 behavior
Thread-Index: AQHaDDmAyV3w+UjTsUS14CYjd/nZL7B6f56A
Date: Tue, 14 Nov 2023 22:43:50 +0000
Message-ID: <559acb1a30b52d99cb6eea445fde938ce6a1370d.camel@intel.com>
References: <169878439580.80025.16527732447076656149.stgit@djiang5-mobl3>
In-Reply-To: <169878439580.80025.16527732447076656149.stgit@djiang5-mobl3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|PH7PR11MB7122:EE_
x-ms-office365-filtering-correlation-id: 23d3ff03-73a2-4bda-63aa-08dbe5632c41
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gdqRr7sZ3fK9C6bBrO0QkDYBmD/kyb4c6lRt4VjTZh3FFQeTqvfz3ibPMOaXtbgDxU1U3g+M+bKVW+Mm1959JE0L+4lyTw9Jb8ej22W9zJwET0mVabdEeaX782an7IBj2elr0LWZXzR3EhK0MA/8ZePSXwqm12PDd0GnR/ElRRTwq5HSbEozXb5VhbYvJkwq6YP9GFlB8IJRWEbxiCh+oq+hsxHqHCfEo7BPSAXR/DMsVgHZlyOnxHANPYBx04rV7eN5m8KVbG9zLZ+bhpRQfJZj2bvR2RrE2E7mxcloPsgHjs7ZazeqF4/ma/ZyFUhc0eTbOWdVOkllZyjAeDVUKSWoHR4E8y7e1Aubl0cZOksWuLlQpw/lLYK8LAfkzHPHlPVJRSHZ47AgkvE7K2yot7SQbi28VRioYusTHnajWNUePa4b7Hu1lI4MwATqzgfkyxpUVEjKUgr/eys24LC+VT4hOoyEGlvuvWjlFVhpTzAhLk8gP/uoDLNR+Yl7wlqrlNdJrSDq/VGCZcIfTrY2vJJoGhGpVjhKJ3zBv2nPpavS8zljSidBXI/m/0FDlEJWFV0bEaQg505pP2W2u3N7WKCaBaoiOlFnVFAbmlgoth2vNA1eHdMIMZc5V2Rykv2X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(39860400002)(376002)(346002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(38070700009)(6512007)(5660300002)(26005)(54906003)(38100700002)(122000001)(66476007)(66446008)(66556008)(64756008)(76116006)(6486002)(36756003)(316002)(86362001)(66946007)(71200400001)(41300700001)(83380400001)(37006003)(8936002)(6862004)(2906002)(478600001)(6636002)(4001150100001)(2616005)(6506007)(82960400001)(8676002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVl5blJoVFNoLzNJbE9XNzI4eGw4b0JNTGswTXlUYXJwNnpadXdMbm9kUXRj?=
 =?utf-8?B?dVltUFFrWUZqSkpRNGdJb3ZaK2kzQVg3ak96T3l5dlRTZTFRQUZmMFFLWTh5?=
 =?utf-8?B?TzA1VVErL1huNllkZnZwak5tTGVpMElyOWl3cEt4djYycUJrdlltWW9OTnpB?=
 =?utf-8?B?WUw3Yytjb2hKRFBtdXA5amFwQUx0VnVRYXQxN1ptMWQ1RTV1bGQ0NTJyRVFl?=
 =?utf-8?B?cHREdXRLVjZCMjB1QW1KclF5c3htTVRsQVM1UGtCNHZjZTY3Tm9SMlRyR2ZD?=
 =?utf-8?B?cXY4ekRVcHkrYXhtYmxJQkR5cGg3MEdnN2RCZnZvc2pHRFdaeU5xRjk5VE04?=
 =?utf-8?B?NmFsM1QrcG9tS3ZiUVBNbXJndFJvZ0FHYVZGTmF3THV4bUo2TVo2Sy9LYnRF?=
 =?utf-8?B?MFkwVlZEOVpoS1o2WmZ2ZlZ1Kzg2aEN5dEx1bUpxS2YySUl0WVpiMnNLNjA3?=
 =?utf-8?B?ckI5K01mZVNTanpHcnBwcEVJNzQwWVUwZlpqemRFZzFVWUlLM3BwTk1QZnlk?=
 =?utf-8?B?VjhnMnhPN3pNM1Zrd3FVYWlMaVFDRGdnbzE1VUthaTg5QnVvV3QvWERDdDk0?=
 =?utf-8?B?Q1JjYkVRVC9zdWdIOUc0c1N5cW5NTkEwMHBaUm92TzUwN0pkSWZXY21LSTZr?=
 =?utf-8?B?cC9OUGJyZ0dxU2t2ZzR6VHlmR0RsZVMvYmFSejZnZUptZWlYTktXdDJTVGs2?=
 =?utf-8?B?ZHgrTlc5azNUZFV2SE5oSWIxL0pNcEhpZVMwZ3BoelR4TGZaVis1K2lVeVB2?=
 =?utf-8?B?ZzNrOC9xMFF4MDdxblJyV0JTakhxZEpoNUtHTFU4MnNVM3pRWEczZmZscTEx?=
 =?utf-8?B?TE5CcGtjem9qQXdVczg4ZXg2Unc4bklXS1BlK1VDSGIrNDdEUzNNUFFRT2NK?=
 =?utf-8?B?QmJmaTFqUU9MWkpxMXIvSUNXN2h6MVhIZnNVdVFydU5iREF3NGFMcFIxK1Jp?=
 =?utf-8?B?aFhBMTR3UW9yTFUrV0lJSUxFeDd2WUVUTDdmUUZhY2h2WVdnZVdJQi9aMDRu?=
 =?utf-8?B?TjRsMThYV0wyNHo2eXQ1cCtYams1WWp1UHNZZGxFTDd6L3NBNFZzaUxkOEw4?=
 =?utf-8?B?WERTT1JCRmEvdVl4YSswRnBKOW03RHQ2NE5MYWFZamZWNGNRUDNaT0hIeFdD?=
 =?utf-8?B?TVJFZDdSTHlKL3B3RCtzQ3ZEdU16NWhpbUFBZTZnYUdBbXlBTU1scm9RNkVv?=
 =?utf-8?B?bjhWYm9DSFNlU282K1lEWjRNK3ZYck5BN1FLUDhpZG96bE42Q2tSTEcrYWl4?=
 =?utf-8?B?b2k1U0xVY2hXQU9lZkZHNno0Q1NyVE1lOE1NMVJTdXFWR3A0Mk5Hb0hPQ1Bp?=
 =?utf-8?B?TUtKQ2w4cnRTM0NsdHhMUkVqblNRYjVKNXBTUVdsWHhEU0dLblRKenJocGM3?=
 =?utf-8?B?bGNQRkZmY2ZHU1FCQ21FdVVUclpHSmhJRUtLV1BweGI0VEFTbG5VT1V2Z1F1?=
 =?utf-8?B?a0daZ0tmRnZiOEdRTHZkY0FHeWx3bitTK0tvYUhGc2o4MnBKZmdvVGlmSitn?=
 =?utf-8?B?bjQrM1g0TTNSUlY2enBxVVdPNGNDamlIeGlnbFdsSDdXNDcvS1RabHArOXlh?=
 =?utf-8?B?bWoxYjdXT3dRYmRMQXlRSzVmSmdCNDZDR0tUREIrZjhvQk5xYi9zY05nY0dl?=
 =?utf-8?B?MXZkN2plcnhCOGNRTHFoRzZFWDdtcEU2WHp1cWZRaEJ5Z0kyT1VuLzEyNWhY?=
 =?utf-8?B?SUhFdUpiTGVUZklna2FmWlN6SWtxTjF2bmNvS2VxRDRzQ0t3NjdyR09KckxR?=
 =?utf-8?B?T21VQnpqTmJZdGorTkl5KzZjeUVMM21meVd2NS9CQTFZclpLZVNDRzVCSWxm?=
 =?utf-8?B?KzhDSUR6c0wvcG0xWVpWYmJqUW0yR0VONk11UE16UVRCekJTZUpHL1JYMTBl?=
 =?utf-8?B?ODFLWjZLdFl4Ukl4WDNIZ1NQaytBaDZncTV2SmkrS1U2bE1ZNDlMek5qWkxv?=
 =?utf-8?B?K0l1V0Q4aUs2Nm9VcUJKcjZZVEhML0pRQkpBMlJXQ2hnUFJiYiszR21zb3Zj?=
 =?utf-8?B?TktyMW5OSTVxSnE4ajUrcUpyNURkdGxwU3NFajhhVUR1eWd6amVoaTFFOHZp?=
 =?utf-8?B?V21QdmZOeXZtYmF6TlhOaWc5OXBqN0ZJOGJRSGEzTnlxWVpOKzB6dnNSS2Nk?=
 =?utf-8?B?dUdXcmFRcDRHZjAyNFR4Y3d6WGxVU1NIdmZPRlp1YlBMejhkQks1QUhZVFAx?=
 =?utf-8?B?UEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6923C346F48CC4B90ACC88EAAF37F59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23d3ff03-73a2-4bda-63aa-08dbe5632c41
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2023 22:43:50.9550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xHp3talbJN9jH5mYj8jPnJdqi/QcIGUvBsbH6qj8QhigkIyvb0j+BfK7CJzkRxtMdAwgfjBMj79lASR8k/r4D//hXQ/6NFeA5mX778lCPXw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7122
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTEwLTMxIGF0IDEzOjMzIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KDQpJ
IHRoaW5rIGEgbW9yZSBzcGVjaWZpYyBzdWJqZWN0IGxpa2U6DQoNCmN4bC9Eb2N1bWVudGF0aW9u
OiBDbGFyaWZ5IHRoYXQgbm8tb3AgaXMgYSBzdWNjZXNzIGZvciB4YWJsZSBjb21tYW5kcw0KDQpp
cyBiZXR0ZXI/DQoNCj4gSWYgYSBjeGwgb3BlcmF0aW9uIGlzIGV4ZWN1dGVkIHJlc3VsdGluZyBp
biBuby1vcCwgdGhlIHRvb2wgd2lsbCBzdGlsbA0KDQouLiBjeGwgZW5hYmxlIG9yIGRpc2FibGUg
b3BlcmF0aW9uIC4uDQoNCj4gZW1pdCB0aGUgbnVtYmVyIG9mIHRhcmdldHMgdGhlIG9wZXJhdGlv
biBoYXMgc3VjY2VlZGVkIG9uLiBGb3IgZXhhbXBsZSwgaWYNCj4gZGlzYWJsZS1yZWdpb24gaXMg
aXNzdWVkIGFuZCB0aGUgcmVnaW9uIGlzIGFscmVhZHkgZGlzYWJsZWQsIHRoZSB0b29sIHdpbGwN
Cj4gc3RpbGwgcmVwb3J0IDEgcmVnaW9uIGRpc2FibGVkLiBBZGQgdmVyYmlhZ2UgdG8gbWFuIHBh
Z2VzIHRvIGRvY3VtZW50IHRoZQ0KPiBiZWhhdmlvci4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IERh
dmUgSmlhbmcgPGRhdmUuamlhbmdAaW50ZWwuY29tPg0KPiAtLS0NCj4gwqBEb2N1bWVudGF0aW9u
L2N4bC9jeGwtZGlzYWJsZS1idXMudHh0wqDCoMKgIHzCoMKgwqAgMiArKw0KPiDCoERvY3VtZW50
YXRpb24vY3hsL2N4bC1kaXNhYmxlLW1lbWRldi50eHQgfMKgwqDCoCAxICsNCj4gwqBEb2N1bWVu
dGF0aW9uL2N4bC9jeGwtZGlzYWJsZS1wb3J0LnR4dMKgwqAgfMKgwqDCoCAyICsrDQo+IMKgRG9j
dW1lbnRhdGlvbi9jeGwvY3hsLWRpc2FibGUtcmVnaW9uLnR4dCB8wqDCoMKgIDIgKysNCj4gwqBE
b2N1bWVudGF0aW9uL2N4bC9jeGwtZW5hYmxlLW1lbWRldi50eHTCoCB8wqDCoMKgIDIgKysNCj4g
wqBEb2N1bWVudGF0aW9uL2N4bC9jeGwtZW5hYmxlLXBvcnQudHh0wqDCoMKgIHzCoMKgwqAgMiAr
Kw0KPiDCoERvY3VtZW50YXRpb24vY3hsL2N4bC1lbmFibGUtcmVnaW9uLnR4dMKgIHzCoMKgwqAg
MiArKw0KPiDCoERvY3VtZW50YXRpb24vY3hsL21lc29uLmJ1aWxkwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCB8wqDCoMKgIDEgKw0KPiDCoERvY3VtZW50YXRpb24vY3hsL29wZXJhdGlvbnMudHh0wqDC
oMKgwqDCoMKgwqDCoCB8wqDCoCAxNyArKysrKysrKysrKysrKysrKw0KPiDCoDkgZmlsZXMgY2hh
bmdlZCwgMzEgaW5zZXJ0aW9ucygrKQ0KPiDCoGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0
aW9uL2N4bC9vcGVyYXRpb25zLnR4dA0KPiANClsuLl0NCj4gDQo+IGRpZmYgLS1naXQgYS9Eb2N1
bWVudGF0aW9uL2N4bC9vcGVyYXRpb25zLnR4dCBiL0RvY3VtZW50YXRpb24vY3hsL29wZXJhdGlv
bnMudHh0DQo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQoNCk1heWJlIGNhbGwgdGhpcyB4YWJsZS1u
by1vcC50eHQsICdvcGVyYXRpb25zJyBzb3VuZHMgYSBiaXQgdmFndWUuDQoNCj4gaW5kZXggMDAw
MDAwMDAwMDAwLi4wNDZlMmJjMTk1MzINCj4gLS0tIC9kZXYvbnVsbA0KPiArKysgYi9Eb2N1bWVu
dGF0aW9uL2N4bC9vcGVyYXRpb25zLnR4dA0KPiBAQCAtMCwwICsxLDE3IEBADQo+ICsvLyBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogZ3BsLTIuMA0KPiArDQo+ICtHaXZlbiBhbnkgZW4vZGlzYWJs
aW5nIG9wZXJhdGlvbiwgaWYgdGhlIG9wZXJhdGlvbiBpcyBhIG5vLW9wIGR1ZSB0byB0aGUNCg0K
Li5lbmFibGUgb3IgZGlzYWJsZSBjb21tYW5kLi4NCg0KPiArY3VycmVudCBzdGF0ZSBvZiBhIHRh
cmdldCwgaXQgaXMgc3RpbGwgY29uc2lkZXJlZCBzdWNjZXNzZnVsIHdoZW4gZXhlY3V0ZWQNCj4g
K2V2ZW4gaWYgbm8gYWN0dWFsIG9wZXJhdGlvbiBpcyBwZXJmb3JtZWQuIFRoZSB0YXJnZXQgYXBw
bGllcyB0byBhIGJ1cywNCg0KLi4gdGhlIHRhcmdldCBjYW4gYmUgYSBidXMsIC4uDQoNCj4gK2Rl
Y29kZXIsIG1lbWRldiwgb3IgcmVnaW9uLg0KPiArDQo+ICtGb3IgZXhhbXBsZToNCj4gK0lmIGEg
Q1hMIHJlZ2lvbiBpcyBhbHJlYWR5IGRpc2FibGVkIGFuZCB0aGUgY3hsIGRpc2FibGUtcmVnaW9u
IGlzIGNhbGxlZDoNCj4gKw0KPiArLS0tLQ0KPiArIyBjeGwgZGlzYWJsZS1yZWdpb24gcmVnaW9u
MA0KPiArZGlzYWJsZWQgMSByZWdpb25zDQo+ICstLS0tDQo+ICsNCj4gK1RoZSBvcGVyYXRpb24g
d2lsbCBzdGlsbCBzdWNjZWVkIHdpdGggdGhlIG51bWJlciBvZiByZWdpb25zIG9wZXJhdGVkIG9u
DQo+ICtyZXBvcnRlZCwgZXZlbiBpZiB0aGUgb3BlcmF0aW9uIGlzIGEgbm9uLWFjdGlvbi4NCg0K
TG9va2luZyBhdCB0aGUgbWFuIHBhZ2UgZm9yIHNheSBkaXNhYmxlLW1lbWRldiwgYW5kIHNlZWlu
ZyBhIHJlZ2lvbg0KY29tbWFuZCBpbiB0aGUgZXhhbXBsZSBmZWVscyBzbGlnaHRseSBhd2t3YXJk
Li4gSSB3b25kZXIgaWYgd2UgY2FuIGp1c3QNCmRyb3AgdGhlIGV4YW1wbGUsIGFuZCByZWx5IG9u
bHkgb24gdGhlIHRleHQgZGVzY3JpcHRpb24uDQoNCg==
