Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F572DDC8
	for <nvdimm@lists.linux.dev>; Mon, 24 Jul 2023 21:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690232966; x=1721768966;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NvX1UiWGORCaz4RcRAf4hIi18c5FU0neInVl4u7gMeU=;
  b=NV75JWb7czn5k+B4G0FP5M/MeuWSWA9QW4BZaBw1I/S/+XBPzaUdHj9r
   f0PYtKcVlpJqlqG49+mxQDTf82BQuY+O7KjUDDWVaLwS0zKSws90P+iRQ
   CbrT5EgAitMCu9lG9+1lZoKQ0ciDXzGVfAT9RHCaId0Y/mdSjs5kDE8qX
   s6/zMdLutswLj0hoGP6lhOJGcDqpQ9MEF2J+2f+c01dkIQ1C1EDKdnbv/
   Wj3eVy2BRF141qtI0IM4CcdoC5LCKOvhVQyR4Jz40i72eBcPGePJwnmqa
   eaN7prUieprOo8X0lLPsOrGZvUs0EXV5csQKwtU6gGyeT/ULSQI7EvIhE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="433796707"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="433796707"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 14:08:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="729064057"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="729064057"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jul 2023 14:08:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 14:08:24 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 24 Jul 2023 14:08:24 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 24 Jul 2023 14:08:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RN271PGAZ/V/bfYfzr+rOGW8EvDiS1u3cV0M+DXHuaWaSR2YZAXqVFa6WwoO9vFhESmqKknj07OEbFxpFcAL4ryNxRl3UCxkzKqxuJsSlFE7cCGYb5GQBYVv1sFdfh42pizXSWUYfEtwF7z5yn2cYN3Qz5/AnfAOfxR29d4AVAZS0GwUX009ra2L9zQ+Cx65riXxrPCI4zl6KFThAuazwPJQK2+kSbWI1Ur3bLFPkgKtjENVocgUo/Z+ul1RqHydhNg5kextSSC3z+UFEgmxoW139C7FSJj/7EblIoKHrulr/OQ/WQC4f7aO8z2TNy+8eeL4zPku556M/e90qmUM/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NvX1UiWGORCaz4RcRAf4hIi18c5FU0neInVl4u7gMeU=;
 b=kpK3HWaH6U/wq7nGt16IwnGJdh/rqPHM82Am5pxL0tFxvrXa9zDKdnu5RuiLnAOVm3rzTBRUGO5g1jHhR8MCPYLw3kGSdSa9l2V0g5ywt/FcMf/uUjAppTwGTtu2TQTqyOyzr0iDGUAM981fmwK7iOWl8M85WCo0cbOtwbfP4nzA7UJu+S/wuksCdUPGMqJ/yIC8uOAt7hfZTLfWwO0kZvH+AvL+WJmqtBjRN8+EDBlZlpXuVxSSvTlRy7GefTX+llGZsVjagJOLjvX2enLGy4vgIRZde3OeY+fW7dvnhCujiql9t/im6Jgy7Hu2b9iQyH1Fu+dgkxL8sHZC8n73ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by DS0PR11MB8184.namprd11.prod.outlook.com (2603:10b6:8:160::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Mon, 24 Jul
 2023 21:08:21 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e527:d79c:2bb3:e370]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::e527:d79c:2bb3:e370%2]) with mapi id 15.20.6609.032; Mon, 24 Jul 2023
 21:08:21 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "jehoon.park@samsung.com" <jehoon.park@samsung.com>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "Schofield, Alison"
	<alison.schofield@intel.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>, "im, junhyeok" <junhyeok.im@samsung.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"dave@stgolabs.net" <dave@stgolabs.net>, "ks0204.kim@samsung.com"
	<ks0204.kim@samsung.com>
Subject: Re: [ndctl PATCH RESEND 2/2] libcxl: Fix accessors for temperature
 field to support negative value
Thread-Topic: [ndctl PATCH RESEND 2/2] libcxl: Fix accessors for temperature
 field to support negative value
Thread-Index: AQHZuHev1g7mtyUPG0mGyG87j5xBe6/JdQGA
Date: Mon, 24 Jul 2023 21:08:21 +0000
Message-ID: <ad6439d56a07c6fac2dc58a4b37fd852f79cfec8.camel@intel.com>
References: <20230717062908.8292-1-jehoon.park@samsung.com>
	 <CGME20230717062633epcas2p44517748291e35d023f19cf00b4f85788@epcas2p4.samsung.com>
	 <20230717062908.8292-3-jehoon.park@samsung.com>
In-Reply-To: <20230717062908.8292-3-jehoon.park@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|DS0PR11MB8184:EE_
x-ms-office365-filtering-correlation-id: ebc0b959-8538-46c8-17f4-08db8c8a1c55
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wMajZhgzqcdzVPRIOm95BlhronXbzZClTb+cVlHneXSKnqyI57BPRS3ZlpBI6B7HP448xmDKoI6iu05pnnGA+dXmfw+2TuQV11mX5o9gGTw2+wwYOpi88sXpsF9QhNyvf9qnLX0jgMth27PgZL3O8AV8Tx4+vUaUAfXv8fRqplNyyiHxK4b0eVFiW2jjuDUaU4xIMAV4rS03ZtMQ9+oAESJIbN4KHyk6fcZeMaTc8oZbXxRquMrYrn/SsP29yTIjS4NA7ueLKir9duvYwTM5F8gjMGRKMrrxcQesQnCNA2bBaLOOseAKPI9/3sU04tdn0HsrvHDkasqU8V3V8esSh92FpW7M2LvtLMzwG80RgVtZp1iU19nLdTFLy6jos9xaS4p18DoFvczPbRwy3jzKnrM/Jg0KVeQCliNedWMaejqlTCoC1Ca/j5Tki25SNMsKAcmpocSTSZ/fkFvG8aBI7A7GwCiQNYG9zH0b5EVkW9m13G1ORW1eMw4z8PelRN0GVBUIhyWAPzTOrZthE8MHISUdgxBAwwci2PED5qk2vry2CJZXCXo7KzOYbmV08kWKqlCysMzuZAoRJ95xufZDwXqNSbWEIiDH6FYTweatU4rRlwDOqvJ8o9DLQm29Bcc7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(366004)(376002)(346002)(451199021)(26005)(186003)(6506007)(71200400001)(2616005)(83380400001)(66446008)(66556008)(316002)(64756008)(76116006)(66476007)(66946007)(4326008)(8676002)(8936002)(5660300002)(41300700001)(6486002)(6512007)(2906002)(54906003)(478600001)(110136005)(38100700002)(122000001)(36756003)(86362001)(82960400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bW8vdFJldDZQUlM3UzZYVHBQQTdOT1V0MjhJZ2NSUGgyQ2FJRjRVVXR5Sk5k?=
 =?utf-8?B?RWVQMnJsS0xhK0kzT3ZiS1RZRjFnbUp1V1lFb3o5N1R0cnFPR3JYQTFlRVJy?=
 =?utf-8?B?Y3lEOUZpcWpaVnZDWlVlamxnUm5HZXRJdE5nbjdYWjNlek8wS0pLNkx5L0FY?=
 =?utf-8?B?dC9CcHBHcm5GWHBtT1htdnI2bFo2NXc5RFFtQlFkTjN3RFp1OWZ4UzFEenBx?=
 =?utf-8?B?TVNlZ2FxRUFLUFFWelBWV0RyQk81ckY0WkNqc1gxZ3NmSFhYZnIwSnBKUnY4?=
 =?utf-8?B?MnQ1SjdEUHJjeFpybkJCNU1hSGJsbXk1V1pxdjJQSldJR2FhRkRvZHJNUmV6?=
 =?utf-8?B?cnVCMTJTekZ5aUErOUZQdUNUSzM1bFQzbTZKamVKWEJGaElvbDV1Yk1mbEJh?=
 =?utf-8?B?MEtpcTlvbGVsOThiQVVpVkJPMEJENjNxV1Nwb1RFcWNrN0hCS1JvaGxTbWxJ?=
 =?utf-8?B?elRxcDRvU1pRREhWRXVwbWNPR1JjZlBXRjBnODVkYVd4SDREMmo5MnZValcr?=
 =?utf-8?B?c1ZOUnBFUG5GUkM3RlNESDFLMGNTUlMwL3NQYmgydjU1YWFSN1BKdnN4MWVp?=
 =?utf-8?B?a0lvTmdsT0I3MzhsS0FFNWVOYUdoWVM0Yk10YlR3M2sxZTYwQkNzZXE3TlhB?=
 =?utf-8?B?WE43STlvb3NLUHp0Uit6VXB1aEJRcTV2Qnpybi9jVGZtaFNabWcySGh6OFRh?=
 =?utf-8?B?SUtwQnlPYm0yanJ2WnZETStRYUlDZGlMSWJpdDQ5WVBRM1puSVpmQ0NIOHdP?=
 =?utf-8?B?bHV4TnpoaWhnYVBUb2VFSm1CdFNhTG05cW5oaytlcGNVZXFCMkdaTFgvQjE5?=
 =?utf-8?B?NURRdklRYmJYS1VvWnVNRVVlUHlJWUg4RXhpZUNpZi9IYnpJUUxCN2pLY3Ey?=
 =?utf-8?B?RGlTK0FUUUJFLzR0UkZzLytRRytDa1ZNYjBjM3NiZXl2SUU1RTlUZEN6a1Va?=
 =?utf-8?B?NFU4OHM0Vm1XNWFKUUtiT1dzbmZ1U1loc1JOR1dKSXdpZFE1MXpCNEp2L2lU?=
 =?utf-8?B?K1JVSUgra0VRSU9aZWROYVZlUlZ2UkNaMUdYTnprOGRhSGtxNW5uQWU3NGU4?=
 =?utf-8?B?M2dZNGQzakhXcmdGR1pFM2V4V2c5aVpSWkY5Q1lPM2FHVTMrRklyNFlxdG10?=
 =?utf-8?B?L1pwYldPdGo5SW1OVXh1UkpQTTNzVFFib3JIcEpGcTJoUW9aUTNtK01GWDdN?=
 =?utf-8?B?bEpqQjNlV1ZKeUs0QmRrTnc3QkxSOStBMWZOc3E0MWJmZEhxTUhBaHV2U2Vu?=
 =?utf-8?B?QXIrSnZFc2tlelZ0bm5LYmxIb0M3M3NNbG8xL3NjbXlBbG1vVUl5ek84RitZ?=
 =?utf-8?B?K2ZsaGhEUEQ5UEcwN055NXNCMkpuSHhPRlJkQzJBYlpIU1ZMcGNLUTF6cThQ?=
 =?utf-8?B?RC9oMEZFQmxxdEJHdVNRYzRybWo0UFZQV3p4Z2ErVHZaemI2VnZuVmRuS1hG?=
 =?utf-8?B?WHlrcThWSXNoZDFEYVBQWkxOVkgzeFJiMlFVaGl6RXBxQzR3TlN4YzErNjhK?=
 =?utf-8?B?d2txMjN3VzFOVmR2TStNRWFZTTdRdEhidlc3NW1CTXhzUmRZWFJZcXVwSEtL?=
 =?utf-8?B?ZEs5cUJKK1Baem01dWNGTjZuT3ZzMTBoekhZZlhYM2VwYWFSSlhiTUJKN2Jh?=
 =?utf-8?B?SlJYYThIeFd5b2k2QkZDVnA1OGpLeG5PZHdKZXIrYTJZT1hKYzJqZmFBYWd3?=
 =?utf-8?B?WWJsK0RuTndvaENmZ3dwb0xzTysxM3FJcEdLSzJtR0k3YWxmNENzVUM1ZVl4?=
 =?utf-8?B?b2FoQ21STVlHTVJrS21GWUI5ZGRUb1BDMXZJSUFuUVd4aUxPdi9xSGhIYmRj?=
 =?utf-8?B?bTlTVlVlN1pLRGlScTBNQWoybkN3bzR2L1FMNmxobHBtNWN2K2F1S1ZKMzZm?=
 =?utf-8?B?cVdTNExsd2U3Q0IwWGdrd3lhQ3hYeHlDcEpNWXVBdU0wRUdQTDdnamdKQm1S?=
 =?utf-8?B?cXkrOVdNdDhKWDE3aXEwdmoxMW1OTkQyTEgrWVRETEtXbkNIaEJscHRFeHRs?=
 =?utf-8?B?VkxJOFRUQi91L1BVaTR6M1hDZlJQeDl5UEphZ0tFbHlNaUpkeTlsMi9IYkNC?=
 =?utf-8?B?R0xkaVJzSE04dlNEUk04bnpvaCtxL3VQYnpib1lMSENCdkQ5UDNFZXNHSDdP?=
 =?utf-8?B?KzYxYTVnT3U3VUdFMjlkaHZ0dmREK3lITzdzSGp3eDM0M21PU084QU01WjRx?=
 =?utf-8?B?TXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5030285FCD4DD4B8CEAC94A3102449C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebc0b959-8538-46c8-17f4-08db8c8a1c55
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2023 21:08:21.1578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nFV4lMT5j4ju8HHmrGR0ibP5BkRHwz7nl4CAgRJm+bOPPjyvVxUZ7gxoRbnBT1J2K3iZF7+HSUD7Bo+3f3HBDLDpAgUxVhUYRzQHhaPb7AA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8184
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTA3LTE3IGF0IDE1OjI5ICswOTAwLCBKZWhvb24gUGFyayB3cm90ZToKPiBB
ZGQgYSBuZXcgbWFjcm8gZnVuY3Rpb24gdG8gcmV0cmlldmUgYSBzaWduZWQgdmFsdWUgc3VjaCBh
cyBhIHRlbXBlcmF0dXJlLgo+IFJlcGxhY2UgaW5kaXN0aW5ndWlzaGFibGUgZXJyb3IgbnVtYmVy
cyB3aXRoIGRlYnVnIG1lc3NhZ2UuCj4gCj4gU2lnbmVkLW9mZi1ieTogSmVob29uIFBhcmsgPGpl
aG9vbi5wYXJrQHNhbXN1bmcuY29tPgo+IC0tLQo+IMKgY3hsL2xpYi9saWJjeGwuYyB8IDM2ICsr
KysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLQo+IMKgMSBmaWxlIGNoYW5nZWQsIDI2
IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9jeGwvbGli
L2xpYmN4bC5jIGIvY3hsL2xpYi9saWJjeGwuYwo+IGluZGV4IDc2OWNkOGEuLmZjYTdmYWEgMTAw
NjQ0Cj4gLS0tIGEvY3hsL2xpYi9saWJjeGwuYwo+ICsrKyBiL2N4bC9saWIvbGliY3hsLmMKPiBA
QCAtMzQ1MiwxMSArMzQ1MiwyMSBAQCBjeGxfY21kX2FsZXJ0X2NvbmZpZ19nZXRfbGlmZV91c2Vk
X3Byb2dfd2Fybl90aHJlc2hvbGQoc3RydWN0IGN4bF9jbWQgKmNtZCkKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgbGlmZV91c2VkX3Byb2dfd2Fybl90
aHJlc2hvbGQpOwo+IMKgfQo+IMKgCj4gKyNkZWZpbmUgY21kX2dldF9maWVsZF9zMTYoY21kLCBu
LCBOLCBmaWVsZCnCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoFwKPiArZG8ge8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgXAo+ICvCoMKgwqDCoMKgwqDC
oHN0cnVjdCBjeGxfY21kXyMjbiAqYyA9wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFwKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKHN0cnVjdCBjeGxfY21kXyMjbiAqKWNtZC0+c2Vu
ZF9jbWQtPm91dC5wYXlsb2FkO8KgwqDCoMKgwqDCoMKgXAo+ICvCoMKgwqDCoMKgwqDCoGludCBy
YyA9IGN4bF9jbWRfdmFsaWRhdGVfc3RhdHVzKGNtZCwgQ1hMX01FTV9DT01NQU5EX0lEXyMjTik7
wqDCoFwKPiArwqDCoMKgwqDCoMKgwqBpZiAocmMpwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgXAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gMHhmZmZmO8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoFwKPiArwqDC
oMKgwqDCoMKgwqByZXR1cm4gKGludDE2X3QpbGUxNl90b19jcHUoYy0+ZmllbGQpO8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgXAo+ICt9IHdoaWxlKDApCj4gKwo+IMKgQ1hMX0VYUE9SVCBpbnQKPiDCoGN4bF9jbWRfYWxl
cnRfY29uZmlnX2dldF9kZXZfb3Zlcl90ZW1wZXJhdHVyZV9jcml0X2FsZXJ0X3RocmVzaG9sZCgK
PiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IGN4bF9jbWQgKmNtZCkKPiDCoHsKPiAtwqDCoMKgwqDC
oMKgwqBjbWRfZ2V0X2ZpZWxkX3UxNihjbWQsIGdldF9hbGVydF9jb25maWcsIEdFVF9BTEVSVF9D
T05GSUcsCj4gK8KgwqDCoMKgwqDCoMKgY21kX2dldF9maWVsZF9zMTYoY21kLCBnZXRfYWxlcnRf
Y29uZmlnLCBHRVRfQUxFUlRfQ09ORklHLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl9vdmVyX3RlbXBlcmF0dXJlX2NyaXRfYWxlcnRfdGhy
ZXNob2xkKTsKPiDCoH0KPiDCoAo+IEBAIC0zNDY0LDcgKzM0NzQsNyBAQCBDWExfRVhQT1JUIGlu
dAo+IMKgY3hsX2NtZF9hbGVydF9jb25maWdfZ2V0X2Rldl91bmRlcl90ZW1wZXJhdHVyZV9jcml0
X2FsZXJ0X3RocmVzaG9sZCgKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IGN4bF9jbWQgKmNtZCkK
PiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBjbWRfZ2V0X2ZpZWxkX3UxNihjbWQsIGdldF9hbGVydF9j
b25maWcsIEdFVF9BTEVSVF9DT05GSUcsCj4gK8KgwqDCoMKgwqDCoMKgY21kX2dldF9maWVsZF9z
MTYoY21kLCBnZXRfYWxlcnRfY29uZmlnLCBHRVRfQUxFUlRfQ09ORklHLAo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl91bmRlcl90ZW1wZXJh
dHVyZV9jcml0X2FsZXJ0X3RocmVzaG9sZCk7Cj4gwqB9Cj4gwqAKPiBAQCAtMzQ3Miw3ICszNDgy
LDcgQEAgQ1hMX0VYUE9SVCBpbnQKPiDCoGN4bF9jbWRfYWxlcnRfY29uZmlnX2dldF9kZXZfb3Zl
cl90ZW1wZXJhdHVyZV9wcm9nX3dhcm5fdGhyZXNob2xkKAo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1
Y3QgY3hsX2NtZCAqY21kKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoGNtZF9nZXRfZmllbGRfdTE2
KGNtZCwgZ2V0X2FsZXJ0X2NvbmZpZywgR0VUX0FMRVJUX0NPTkZJRywKPiArwqDCoMKgwqDCoMKg
wqBjbWRfZ2V0X2ZpZWxkX3MxNihjbWQsIGdldF9hbGVydF9jb25maWcsIEdFVF9BTEVSVF9DT05G
SUcsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
ZGV2X292ZXJfdGVtcGVyYXR1cmVfcHJvZ193YXJuX3RocmVzaG9sZCk7Cj4gwqB9Cj4gwqAKPiBA
QCAtMzQ4MCw3ICszNDkwLDcgQEAgQ1hMX0VYUE9SVCBpbnQKPiDCoGN4bF9jbWRfYWxlcnRfY29u
ZmlnX2dldF9kZXZfdW5kZXJfdGVtcGVyYXR1cmVfcHJvZ193YXJuX3RocmVzaG9sZCgKPiDCoMKg
wqDCoMKgwqDCoMKgc3RydWN0IGN4bF9jbWQgKmNtZCkKPiDCoHsKPiAtwqDCoMKgwqDCoMKgwqBj
bWRfZ2V0X2ZpZWxkX3UxNihjbWQsIGdldF9hbGVydF9jb25maWcsIEdFVF9BTEVSVF9DT05GSUcs
Cj4gK8KgwqDCoMKgwqDCoMKgY21kX2dldF9maWVsZF9zMTYoY21kLCBnZXRfYWxlcnRfY29uZmln
LCBHRVRfQUxFUlRfQ09ORklHLAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGRldl91bmRlcl90ZW1wZXJhdHVyZV9wcm9nX3dhcm5fdGhyZXNob2xk
KTsKPiDCoH0KPiDCoAo+IEBAIC0zNjk1LDI4ICszNzA1LDM0IEBAIHN0YXRpYyBpbnQgaGVhbHRo
X2luZm9fZ2V0X2xpZmVfdXNlZF9yYXcoc3RydWN0IGN4bF9jbWQgKmNtZCkKPiDCoENYTF9FWFBP
UlQgaW50IGN4bF9jbWRfaGVhbHRoX2luZm9fZ2V0X2xpZmVfdXNlZChzdHJ1Y3QgY3hsX2NtZCAq
Y21kKQo+IMKgewo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgcmMgPSBoZWFsdGhfaW5mb19nZXRfbGlm
ZV91c2VkX3JhdyhjbWQpOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBjeGxfY3R4ICpjdHggPSBj
eGxfbWVtZGV2X2dldF9jdHgoY21kLT5tZW1kZXYpOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGlm
IChyYyA8IDApCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiByYzsKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGJnKGN0eCwgIiVzOiBJbnZhbGlkIGNvbW1h
bmQgc3RhdHVzXG4iLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY3hs
X21lbWRldl9nZXRfZGV2bmFtZShjbWQtPm1lbWRldikpOwo+IMKgwqDCoMKgwqDCoMKgwqBpZiAo
cmMgPT0gQ1hMX0NNRF9IRUFMVEhfSU5GT19MSUZFX1VTRURfTk9UX0lNUEwpCj4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRU9QTk9UU1VQUDsKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgZGJnKGN0eCwgIiVzOiBMaWZlIFVzZWQgbm90IGltcGxlbWVudGVk
XG4iLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY3hsX21lbWRldl9n
ZXRfZGV2bmFtZShjbWQtPm1lbWRldikpOwo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gcmM7Cj4g
wqB9Cj4gwqAKPiDCoHN0YXRpYyBpbnQgaGVhbHRoX2luZm9fZ2V0X3RlbXBlcmF0dXJlX3Jhdyhz
dHJ1Y3QgY3hsX2NtZCAqY21kKQo+IMKgewo+IC3CoMKgwqDCoMKgwqDCoGNtZF9nZXRfZmllbGRf
dTE2KGNtZCwgZ2V0X2hlYWx0aF9pbmZvLCBHRVRfSEVBTFRIX0lORk8sCj4gK8KgwqDCoMKgwqDC
oMKgY21kX2dldF9maWVsZF9zMTYoY21kLCBnZXRfaGVhbHRoX2luZm8sIEdFVF9IRUFMVEhfSU5G
TywKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHRlbXBlcmF0dXJlKTsKPiDCoH0KPiDCoAo+IMKgQ1hMX0VYUE9SVCBpbnQg
Y3hsX2NtZF9oZWFsdGhfaW5mb19nZXRfdGVtcGVyYXR1cmUoc3RydWN0IGN4bF9jbWQgKmNtZCkK
PiDCoHsKPiDCoMKgwqDCoMKgwqDCoMKgaW50IHJjID0gaGVhbHRoX2luZm9fZ2V0X3RlbXBlcmF0
dXJlX3JhdyhjbWQpOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBjeGxfY3R4ICpjdHggPSBjeGxf
bWVtZGV2X2dldF9jdHgoY21kLT5tZW1kZXYpOwo+IMKgCj4gLcKgwqDCoMKgwqDCoMKgaWYgKHJj
IDwgMCkKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJjOwo+ICvCoMKg
wqDCoMKgwqDCoGlmIChyYyA9PSAweGZmZmYpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGRiZyhjdHgsICIlczogSW52YWxpZCBjb21tYW5kIHN0YXR1c1xuIiwKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGN4bF9tZW1kZXZfZ2V0X2Rldm5hbWUoY21kLT5t
ZW1kZXYpKTsKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHJjID09IENYTF9DTURfSEVBTFRIX0lORk9f
VEVNUEVSQVRVUkVfTk9UX0lNUEwpCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiAtRU9QTk9UU1VQUDsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGJnKGN0
eCwgIiVzOiBEZXZpY2UgVGVtcGVyYXR1cmUgbm90IGltcGxlbWVudGVkXG4iLAo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY3hsX21lbWRldl9nZXRfZGV2bmFtZShjbWQt
Pm1lbWRldikpOwoKSGkgSmVob29uLAoKbGliY3hsIHRlbmRzIHRvIGp1c3QgcmV0dXJuIGVycm5v
IGNvZGVzIGZvciBzaW1wbGUgYWNjZXNzb3JzIGxpZWsgdGhpcywKYW5kIGxlYXZlIGl0IHVwIHRv
IHRoZSBjYWxsZXIgdG8gcHJpbnQgYWRkaXRpb25hbCBpbmZvcm1hdGlvbiBhYm91dCB3aHkKdGhl
IGNhbGwgbWlnaHQgaGF2ZSBmYWlsZWQuIEV2ZW4gdGhvdWdoIHRoZXNlIGFyZSBkYmcoKSBtZXNz
YWdlcywgSSdkCnByZWZlciBsZWF2aW5nIHRoZW0gb3V0IG9mIHRoaXMgcGF0Y2gsIGFuZCBpZiB0
aGVyZSBpcyBhIGNhbGwgc2l0ZQp3aGVyZSB0aGlzIGZhaWxzIGFuZCB0aGVyZSBpc24ndCBhbiBh
ZGVxdWF0ZSBlcnJvciBtZXNzYWdlIHByaW50ZWQgYXMKdG8gd2h5LCB0aGVuIGFkZCB0aGVzZSBw
cmludHMgdGhlcmUuCgpSZXN0IG9mIHRoZSBjb252ZXJzaW9uIHRvIHMxNiBsb29rcyBnb29kLgoK
PiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJjOwo+IMKgfQo+IMKgCgo=
