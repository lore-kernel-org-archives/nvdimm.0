Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E7013AEF
	for <nvdimm@lists.linux.dev>; Wed,  5 Jul 2023 21:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688591819; x=1720127819;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aVhRuwtIJkp9nWt6xmwTxTWOZQ/4sAGDIRc1YSqNnFk=;
  b=ImAIpzpp1W4tTWZhMgEK2sBXB78EhizWiC+4VWv014av4FkG6S/rmpWw
   qxZm6m6kctPewy99lVaHUlusMGS4RU2sxNxZ4CUn9almpYuesVexZi+HH
   OOTtta9165v3QfDGH/XT14IMiF50IXHETrA7aoKyU0br338p6zpKIKR5l
   78dph/KysyuPWiSIej//+D9DLtcZVrF2fOcuCGkC2NGhV7d5kEgD4PuSn
   AmQSy8WAcWArlUL66lrzC7fL5Lzlh7y6aVEwg9+WRbcJUpy9fHNOZY1Fb
   EwLNafu1Ls5iAn8eGFbTCHUaxbvHjt9cs6ouIyQln+Pj2narBv/n96Ewh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="429486962"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="429486962"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 14:16:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="789297390"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="789297390"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 05 Jul 2023 14:16:58 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 5 Jul 2023 14:16:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 5 Jul 2023 14:16:57 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 5 Jul 2023 14:16:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsYhwDkr4UsXVOJ8fkKoUQ8cLTZ2XCmQbNMe3nVWkE5IUxr6ll356Dn1NWlPblFF89GPKJbtkKRR6tEW9Q01dntIeg8uLuGqPookRaYETTE46k5V4IXFxfL0M+LpXXjL/9ug5et/+D1CyUuWQbrz7zfMouSlkpyhGROkGMS5HErM/ixPOHVB0lLHw4AQtLDkrfGjjttTT8IRObE3hxENK338MSTqV80YAf/S0dlMSDoQHKSZjfF219PFzp5MUy80UPCnWJrXoGQpEP43mn7fPXlvQaFcAJCZgb93+4AK+ixBCWdTb+wONqlRUqgitTtwDRkRQ/MFLbsBddLvhBtbRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aVhRuwtIJkp9nWt6xmwTxTWOZQ/4sAGDIRc1YSqNnFk=;
 b=i2/DDR1KXhC4EJcPTGP8WRiR3614ZC5EVY38KvfqdGVgFqImPTUCIPV/ebxg/BbBKG7ZfwIn3SdJtkLDiyWvKBUfnU2s3WYFtdQzsRsYPMeEKMnWSLo4wnNk7vqDX44bhcZCoF6dN1Yi+ZvUh8STJse7gJXqufZfquGyr2luv+dmeRZBBlrl85ae6bfXb1zJyQUEzSK7YpMyyBsUxrdfkJ3gklLUO0cvDeeqcR4Wijw4AOpgCpQa75LOwLqQN+mCbrP9bsJ5NUloM488CBDx0H69ToIiPk7UpsdhALyPNYjTU0hjNLUCukiezsIKPbvIhPHUPS698cp3hWs0RJ59eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by CH0PR11MB8142.namprd11.prod.outlook.com (2603:10b6:610:18c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Wed, 5 Jul
 2023 21:16:55 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::8e37:caf2:1d81:631d]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::8e37:caf2:1d81:631d%3]) with mapi id 15.20.6544.024; Wed, 5 Jul 2023
 21:16:54 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "lizhijian@fujitsu.com" <lizhijian@fujitsu.com>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "Schofield, Alison" <alison.schofield@intel.com>
Subject: Re: [ndctl PATCH v3 4/6] cxl/monitor: always log started message
Thread-Topic: [ndctl PATCH v3 4/6] cxl/monitor: always log started message
Thread-Index: AQHZk2Zog1r9WntiKUyo8dLHQuUqva+r5T2A
Date: Wed, 5 Jul 2023 21:16:54 +0000
Message-ID: <4c2341c8a4e579e9643b7daa3eb412b0ac0da98a.camel@intel.com>
References: <20230531021936.7366-1-lizhijian@fujitsu.com>
	 <20230531021936.7366-5-lizhijian@fujitsu.com>
In-Reply-To: <20230531021936.7366-5-lizhijian@fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|CH0PR11MB8142:EE_
x-ms-office365-filtering-correlation-id: ad9345c1-1e67-456c-89fd-08db7d9d287a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KoN3ocO/IPpZ5TmKxl71SR83lLdK50963HODlBOSN/FloYXatrs2cI3KCEb22aJmPHNTQPFmPPtTTFavcdy/v8DhzLilO1Oe36cAqDR7c4lB31tkvy/T7EzIqmOMaOVhp1zZHht/xoChgzvdPCtyNV90CP6QFif9UB92k5iFk0Ep9ygedQtOlLrFsxrRfsVq1ZyOEJDL0o7h5nSjJ8hbIvKS3VH7DHM7RSBCts2UNk78phA/Le3yckpoxraeyiZ44uA8fI6NejBKbuKBrJQfZooiUDhpCJ5m4tDBJ2Ck3fHC1N7VggtoPHE2Zp2oxXyLwHV7YY6E/T3sG43ruqGsJNjvT3Wm4AMF3hyaS/xIFGHRRyPvGzNO4w3We66n5RUXb5uDZSmh8taflaOIUQPPGb+s59u/bexB9NvvyMwaO0Q4LMCaYD3b047HTeT4s/FYAXQawpXTNjIl1myJAL3m9GRBFi+tLktz89QF6k3vLcxAW7u6d2WI33pApLaf7LFqjd55BUfgiGUoAfODvLXWmE4AK1wJgrt4oPb20yu10+ReVYRrPnsvm8+P+4xx41IjZcgqNcw+BnpFDZcz0uXZksf/CI1CEA8Phcm8OSFQcqPuADQRD74W9y8czdvi80bH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199021)(110136005)(6486002)(6512007)(54906003)(478600001)(15650500001)(71200400001)(186003)(26005)(6506007)(2906002)(8936002)(76116006)(66476007)(66946007)(66556008)(41300700001)(5660300002)(8676002)(64756008)(82960400001)(107886003)(4326008)(122000001)(66446008)(38100700002)(316002)(36756003)(38070700005)(86362001)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejRpeFpYNlQrSVpxQlphay9hUWJwenI0N3FFYlNHRWtlQXJZUUx4QVk1TnpY?=
 =?utf-8?B?VFNOZmdDTnB2Y05zTGE0NkJSRi92OTdmNVZFOGFoM3BhZ0hNRVFyaWdXMUl5?=
 =?utf-8?B?TzdDckRQRThoMTFkNkpiTEpaNVJuYk05dHVBeDUxRkZDa1p3NG00TWJaS1FU?=
 =?utf-8?B?T0dIbllFQWdQVURDamt5L3VOSHRjMXBCTmVZMlJvVTVidG1wMDEwSitNNVNO?=
 =?utf-8?B?d1N0dkNpelRyV1B4Y0RiTXRJU2JlOHNFNE9VWmQ2TkI2aS9sc01aRTlWbXRD?=
 =?utf-8?B?UlhLQzFTQkw1aG44UVhlL3R4RWZCdEt3b2Fpbno2LzFkTC9QZ3hqWHZjTzF3?=
 =?utf-8?B?ZEoxeGduZGZ6MHY0NXZLb1BhNURoZW44RmF1cTlQR2J2V1Q5aFNybUw2UWp4?=
 =?utf-8?B?N1dxUmZTQWU1L2ZlbmZFSks1dmpPTlVzQW9DdXV4NmVoRk82MS8zRDJHT2p0?=
 =?utf-8?B?aW9xMi9CUzgyRUtaSkFTUmYwaVZ0aW5MSW94NHArZDRzcERnRk9ENGFzbnNU?=
 =?utf-8?B?QlAwbnZEOStGRHdQZTBRRDVJbU94cXRBbVpiL2ZlZ2FJbTJWejlNdUlsN0wy?=
 =?utf-8?B?UExXcFdGOVA1S3RvdVp5M1N1Sk4wSW5qTkYveVI0WTl2eDQ4QnhIMXJmMHNm?=
 =?utf-8?B?ckdUSnRDODJHMDd3QXpJTE5TNXFiRUtCMGdndC9oc2ttanRicC9zWjFqL1By?=
 =?utf-8?B?YUZFdDR6OWFwYmFDVHVTbXlPNzQxVHpSOFh2aDNIVWg1aDhkbFF6S2xwNHg1?=
 =?utf-8?B?cWZIb2VMZVRBS1ZIckVubVEwQzFweDE0SEttVGZiOUtFNmh5eEtOd2s5dE9r?=
 =?utf-8?B?QjczVlRBa3hIOEpWVVBGT2lvS2pndlp2YW1obmV2R3BRTmQ0ZDlPVFNURjBy?=
 =?utf-8?B?b3gzWHUvZUcwc2Y3MGlJMmF2YUlINDBlakdoUGR6aVNEdWtPVGJsbXgwdGNP?=
 =?utf-8?B?cExYQ1lKVGhuY25MeDFHSzJIMXFqc1hZT2IrOEVWcmpSYkFEUStNVXNUcFVm?=
 =?utf-8?B?Vk1HY3phMXdQa3BCT3F3YXNlRmdvZVBmVUtaK0p0bno2QVFiQ2ZkMXE3NTl1?=
 =?utf-8?B?d2dUQ1YvcExudWtILzRZam9vUGhobjlOcUhONjJJazh0T01ZS3NFWGhXUVJN?=
 =?utf-8?B?VTNHamsramVjbmNXOWFPYWs3Rng2d0kxMWhwdTZ6cTY4Y2s4YlpEaHMySFRZ?=
 =?utf-8?B?NU1mejdDMFF5L1BVU0tieTZIMFc3bGhkc0FJV21WL2NuU21xU0VrdzdDc2hY?=
 =?utf-8?B?N1djbHNKSy81N2NoL0FUandIS1RreThqYzBqZDZpb3pBcFo3QWdJaFhFdmRT?=
 =?utf-8?B?bDk1dUZNeWFadHJnL3JoZk1MaWNOUEV5U2N6Yis2TXd6SjZvVlU5SDhnTmQ1?=
 =?utf-8?B?empwZ2sxT2wvWmx2K3A1TlRIc3VyV2prMkdmT1g0YjFDUm5hMlVJaFM3bnc2?=
 =?utf-8?B?TjdHaEhGc2hjQStmLzJiZUFJc3BNU2JVcFdpVEFsRTJsOEMxcDdzQkw3dVBi?=
 =?utf-8?B?dlI2QnMrUnoxSlJvZzFmS0ZQN2R2RmFQcllMYWQ1SW9PZkdtMmNMVUVOTXUw?=
 =?utf-8?B?WVFkN2c0MUF0Z3RoMDF3R3dDbG82MWg1eXdYTThWZkh6cCtQQTB2TCsvOXFV?=
 =?utf-8?B?K0FLbW5rL2sxWVhoTHFvaHlHOWkrTlR2aUt4UUtJQ2pyVXpvYjJ6dUtGb0xD?=
 =?utf-8?B?Q1JManIxckdrWk1JYThmM0YyZUxXTG1FS1JMQlRmM01EV2loajN1d0pGZTU3?=
 =?utf-8?B?T2FUZVlNSkx1WGpLdjBhbUpvMEhadXl0TVFYMzNXQlJPeWZkVU1YbFB3ZThQ?=
 =?utf-8?B?eHBxbUxHMndGYjJuZ2JlRSszMXFlQWxTdW9ES2dwL1RDdkJsWGtVMU10bWF4?=
 =?utf-8?B?aVh4QXRrZ3RybzZSTzB0VjN2QmV3ZjgzUVh1RDVmbVRMRmwxUXQ1MmtObFZu?=
 =?utf-8?B?RmxMSzZveC91VHFDSU84di9aN2FtNmVpaXVnRXlscVF4YWZjYUlicEdMbHUz?=
 =?utf-8?B?b21GdHMwcGZIRm9QcXlZU05naEt4dktxcHpBeUlrUUhGT2lML0pRMWZaWnUx?=
 =?utf-8?B?SGdERFpGdmVkTTNvMEJiSVpBWHBMdHpqMjMybXgvdzFzTDE5bnNPTXQzUHg2?=
 =?utf-8?B?MWpHRmVNU0owV0hzQkF2QzRDOGx3QWFteEIyZzNvQkRRTXFtOXdVaUs0Y2dm?=
 =?utf-8?B?R3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <88FA633D36E5CE4DBDAF6ABE00ED6825@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad9345c1-1e67-456c-89fd-08db7d9d287a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2023 21:16:54.5061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JbMSohmuoFHtl6bkrL7aukmFWWsTA1HtR5NpcG5vdI/W9oz8u1f8m3Vkf1qoyrBU7sNquwI6FG44PD1RcMqr6XafVSDrOBDfucKYD4ZsUuU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8142
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIzLTA1LTMxIGF0IDEwOjE5ICswODAwLCBMaSBaaGlqaWFuIHdyb3RlOg0KPiBU
ZWxsIHBlb3BsZSBtb25pdG9yIGlzIHN0YXJ0aW5nIHJhdGhlciBvbmx5IGRhZW1vbiBtb2RlIHdp
bGwgbG9nIHRoaXMNCj4gbWVzc2FnZSBiZWZvcmUuIEl0J3MgYSBtaW5vciBmaXggc28gdGhhdCB3
aGF0ZXZlciBzdGRvdXQgb3IgbG9nZmlsZQ0KPiBpcyBzcGVjaWZpZWQsIHBlb3BsZSBjYW4gc2Vl
IGEgKm5vcm1hbCogbWVzc2FnZS4NCj4gDQo+IEFmdGVyIHRoaXMgcGF0Y2gNCj4gwqAjIGN4bCBt
b25pdG9yDQo+IMKgY3hsIG1vbml0b3Igc3RhcnRlZC4NCj4gwqBeQw0KPiDCoCMgY3hsIG1vbml0
b3IgLWwgc3RhbmRhcmQubG9nDQo+IMKgXkMNCj4gwqAjIGNhdCBzdGFuZGFyZC5sb2cNCj4gwqBb
MTY4NDczNTk5My43MDQ4MTU1NzFdIFs4MTg0OTldIGN4bCBtb25pdG9yIHN0YXJ0ZWQuDQo+IMKg
IyBjeGwgbW9uaXRvciAtLWRhZW1vbiAtbCAvdmFyL2xvZy9kYWVtb24ubG9nDQo+IMKgIyBjYXQg
L3Zhci9sb2cvZGFlbW9uLmxvZw0KPiDCoFsxNjg0NzM2MDc1LjgxNzE1MDQ5NF0gWzgxODUwOV0g
Y3hsIG1vbml0b3Igc3RhcnRlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IExpIFpoaWppYW4gPGxp
emhpamlhbkBmdWppdHN1LmNvbT4NCj4gLS0tDQo+IFYyOiBjb21taXQgbG9nIHVwZGF0ZWQgIyBE
YXZlDQo+IC0tLQ0KPiDCoGN4bC9tb25pdG9yLmMgfCAyICstDQo+IMKgMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvY3hsL21v
bml0b3IuYyBiL2N4bC9tb25pdG9yLmMNCj4gaW5kZXggMTc5NjQ2NTYyMTg3Li4wNzM2NDgzY2M1
MGEgMTAwNjQ0DQo+IC0tLSBhL2N4bC9tb25pdG9yLmMNCj4gKysrIGIvY3hsL21vbml0b3IuYw0K
PiBAQCAtMjA1LDggKzIwNSw4IEBAIGludCBjbWRfbW9uaXRvcihpbnQgYXJnYywgY29uc3QgY2hh
ciAqKmFyZ3YsIHN0cnVjdCBjeGxfY3R4ICpjdHgpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGVycigmbW9uaXRvciwgImRhZW1vbiBzdGFydCBmYWls
ZWRcbiIpOw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBnb3RvIG91dDsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9DQo+IC3CoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpbmZvKCZtb25pdG9yLCAiY3hsIG1vbml0b3IgZGFl
bW9uIHN0YXJ0ZWQuXG4iKTsNCj4gwqDCoMKgwqDCoMKgwqDCoH0NCj4gK8KgwqDCoMKgwqDCoMKg
aW5mbygmbW9uaXRvciwgImN4bCBtb25pdG9yIHN0YXJ0ZWQuXG4iKTsNCg0KQWN0dWFsbHkgSSBk
b24ndCB0aGluayB0aGlzIG1lc3NhZ2Ugc2hvdWxkIGdvIGluIGEgbG9nIGZpbGUgYXQgYWxsLiBJ
dA0KaXMgb2theSB0byBwcmludCB0aGlzIG9uIHN0ZGVyciBvbmx5IGluIGFsbCBjYXNlcywgYnV0
IGlmIHRoZSBtb25pdG9yDQpsb2cgaXMgbWVhbnQgdG8gY29udGFpbiBzYXkganNvbiwgc3VjaCBh
IG1lc3NhZ2Ugd2lsbCBicmVhayB0aGF0Lg0KDQpSZWdhcmRsZXNzIG9mIHRoZSBmb3JtYXQsIHRo
ZSBmYWN0IHRoYXQgdGhlIGZpbGUgaXMgcHJlc2VudCBpcyBlbm91Z2gNCnRvIHNlZSB0aGF0IHRo
ZSBtb25pdG9yIHdhcyBzdGFydGVkLg0KDQo+IMKgDQo+IMKgwqDCoMKgwqDCoMKgwqByYyA9IG1v
bml0b3JfZXZlbnQoY3R4KTsNCj4gwqANCg0K
