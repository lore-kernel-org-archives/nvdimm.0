Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08811CA48
	for <nvdimm@lists.linux.dev>; Wed, 20 Sep 2023 22:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695247815; x=1726783815;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eCFaMVGIDKkkUlxuI++V25miGxySVOM+JGAuuRNqrQA=;
  b=O1cyc0ZXVyqExrKQuxixQQDU4gRdqIGjYm71YdA29d57NR62cZCm4EG7
   NfKdqatMgEoNMMhE+xFlkzNjF4Bab5DeNlU4MlzgDeB0eQGJhWCSy1kaq
   UjRhRW8dE/AsVq+I3XlSHjmoFvYqJbDgmW9ORg6XGMRv+xix8hYQi+QUt
   FzQVAWYTS9YjkQAASCh5jrUK0TiLuTyS2MsboFpkYRsLPKf5iulqT0sii
   OeVkuKyjgJBSEjSv8eO/iZJJgRi9wUKAIVvVk05qTuYD9xnCLmUFPgjla
   li3HX2gP7ggMRtyS82Rbu18vbduE83rsAbFJZKV6t03b5IH6VvrZCq2Td
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="360602021"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="360602021"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2023 15:04:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10839"; a="862175202"
X-IronPort-AV: E=Sophos;i="6.03,162,1694761200"; 
   d="scan'208";a="862175202"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Sep 2023 15:04:42 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 20 Sep 2023 15:04:42 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Wed, 20 Sep 2023 15:04:41 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Wed, 20 Sep 2023 15:04:41 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Wed, 20 Sep 2023 15:04:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CH5ESnXDWWIaLRTUZ/HveN5ow92GlfjCW4sFN/g2DQmG+fmZqmbJyKOCKWsyFNwQ2SOOIJ5fLidlsGsF/R39qT50BcSpnRMFdnR1+pTdrf7pnKnGf1AFsjYUTrLJohS1FXiogwfn9YqI9JUFma8ldo2JfIqsGWve6X3pbg4W81HU3gjWlmc4AZw6A6L7s7bgA2xYPldbrDglZImGJf9vutK5miwy/lnmrajXCP4RCYJKco6OSZ5h7GuH+kC+5yspnwJxGoluPZqyFucwC/BbDxC9xloN5ugfSWRlezws7fZOU7Uvf6Igc0mL8L8cmxECEP5JPEkyZ6gUvFL0eAXtHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eCFaMVGIDKkkUlxuI++V25miGxySVOM+JGAuuRNqrQA=;
 b=LBIazaFEp3GBPSa2aL9WkqLozenib5GjdZjAWhVGDnjpU2kJfvTJjhb/1Nn2I3bd92ZXXaomaCPe4rAjRtnybO7FcdJ3Cpi7bcXrlNrTcWrT8Hmlm5kb/K63L5lWad+7ifUjlD/P8qXScyoEQrYc/Jf/VQnbNWUKXqthNP4HD4SzWC6kwDP0m6DuY72swyDezZcdhZylu52JDggK8fLX0/B6qjUVyASa7uZJWjRJBHO2rThx+2ZerCeDasQhIB44ec0pjR/MlzCAaDDC53jC3KbUrzZxlXbPSf/BIkWy7757aUGW3Xm1hfsdS5k32pR2lSD1cSquLm074vN0KcLIIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by SA0PR11MB4575.namprd11.prod.outlook.com (2603:10b6:806:9b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Wed, 20 Sep
 2023 22:04:37 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::3693:a1b6:b431:4827]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::3693:a1b6:b431:4827%3]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 22:04:37 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [NDCTL PATCH] cxl/region: Add -f option for disable-region
Thread-Topic: [NDCTL PATCH] cxl/region: Add -f option for disable-region
Thread-Index: AQHZ61RfJKAbZNxeakSyvZBf0VTRVbAkRjoA
Date: Wed, 20 Sep 2023 22:04:37 +0000
Message-ID: <3502a14247c520fe830109b96f4e4be99ca47a84.camel@intel.com>
References: <169516754868.2998393.297443133671590500.stgit@djiang5-mobl3>
In-Reply-To: <169516754868.2998393.297443133671590500.stgit@djiang5-mobl3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.4 (3.48.4-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|SA0PR11MB4575:EE_
x-ms-office365-filtering-correlation-id: 04848a72-b259-49d4-496d-08dbba2594da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YsDSLgri6XQPQUtCg2fCxEatTC+hMuhellwe1tqJaZj04PYjHmoc3DAofFTjA8udNR+x7uTZaZL7NBTi/EeeOHIZDQrcysjnRoO6KL6chm/79iOC1itf3MWc3gmZApTz5sbV74UFw9mTpwtmOjVRLNLHdKduUOb7uWvj9mUZOltEhG5EVPu5Pxx8BwzetLEjwg+C1RhczjzaEbKmEnMC332FgzP6kn0W9QLgNjFxosb+EjyT+aGLcxCn+krOTojMoN8oUtDP5qqr0qkUWfVKPoaf49L67EeyF4ygq7vJImqhMwy1/EUSmmdohOqr7vwIawTmlYrm5ekbPOcfWyBJrl4Ag11ViRdyIkgPf8zQ5no+Ckc/0uC1RdTp6n+c3nxvLPUJpq+hdTSyALNh3c9dRvQwuBKZpyV+rofDkGxcqF8a4rzyvtUGUK0s5jBhA8s4OZwj/VUAdZ5ua79KHkqLmYRmiJghBJqWbGLt+j9JaJckh6Z6bebK3OQAoUw3lXoDOdp2ek0LOPa7TB4LXplZXpdCEOrTfy00wqdYTn+PxRwRSLxvXcN1KjVaEiaE/pSYNd2kMdPO6/llIXjQwavBnUR6GnWYHWjjeo1YzJ4aIBpl9DE3JC3ZPDmUhMlkGcv2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199024)(1800799009)(186009)(38070700005)(38100700002)(6486002)(6506007)(71200400001)(36756003)(82960400001)(83380400001)(122000001)(86362001)(2616005)(37006003)(2906002)(6512007)(8936002)(478600001)(8676002)(6862004)(41300700001)(4326008)(316002)(5660300002)(6636002)(64756008)(66476007)(54906003)(76116006)(66556008)(66446008)(26005)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzM3ZjVLZXFWcFBTRU5GajZoaTFodUVaSXNPYkRocjhGNUJNR0pEYi9ZNU5l?=
 =?utf-8?B?bVQzblBmdHFuRjVOeTJRM01LZ1dlbHk0Ukk1TThvVjNoSGs5RWNxTUgzdVdU?=
 =?utf-8?B?M0hxYUxWLzB3ZU1WM09rT1MxcktRcXIzRWRmNXNvTDdYaEgvNUN3VzB6WkpB?=
 =?utf-8?B?SjZsSDJST3RlNW4xbWl4Unlnb213cHY4bFRCajJ3NWNoMDVZbVl4Y09vb2d5?=
 =?utf-8?B?eFk3NUdBTlBGYlQxT2dBT3JYQmZZRmh5bzQzdFozZlBlc3c2d2ZERkxCd2Rj?=
 =?utf-8?B?Z0JhdkZvSFdKSXl0UVg4U0syQWVWVjFFODB6L3dISVU2UnJrdVhWSE1sb2NX?=
 =?utf-8?B?SXY2a1JZbkFXWjhHWkhYUys4ZXlQcVMvL2tCRzdQamp6TnFjdGQ0dmdrZ2dT?=
 =?utf-8?B?MXhtM1NDd3k2RDBxS1RHRHoxc3N5R0htYnBDcFU2UHhSLzM0RWR0OGN5d0xR?=
 =?utf-8?B?d1V1OWdpeFVTSWQwZmVvOGJCNlpjcWYreUd3dEpYRVdYK0QxdHIxalZ0S3Zr?=
 =?utf-8?B?K1VMNm9tQVI5cExkU1cvRXA2bGNnWW0vU3kyY2FROHVLZCtNWXJkNTNzeFUy?=
 =?utf-8?B?K1NiMHFYdXB4Ym1tUlQzZm90NXRvRTd5VW40bHQwRkpyTVFtQ2NzaVpwZjFL?=
 =?utf-8?B?VFUvQm9WWUlGeFlSK1hXN1dKa3BSODVCMm9oR0RQQ1JxT0NVbWs4WVNyS1g5?=
 =?utf-8?B?Um8xZ0hNS3llK3JlaW11eFplL1F5YVV4Y0JkVnpBWmFZejFRYXgySkVHYkNM?=
 =?utf-8?B?KzVQN0V6WDZoaXo0b3NtU3dkRndPRWVFaWNNVXlLSVJVMTZKY0RNbzZlNFhl?=
 =?utf-8?B?YU01c0tZMGpBRmpEMGVNZTU5RGJTVmNzOTExY213OXdzT0VQNWpaZUJtUk9U?=
 =?utf-8?B?MlhEVndWd2s1Y3lRUktYZ0Nnd2ZNVitaZ0pKZTVlRW93WjFYeUFnZTEvU1NY?=
 =?utf-8?B?RkpVS1N3Yys0U00wb1FMeTR4T0c3WWt6R3lPMW0zRVRWSWVKajUwczhBRlU1?=
 =?utf-8?B?Z0padm1CbVFyd1l0SDVTUk9aazQxYld2bDFDRDNmcGh4MkJNMU5kMTN6YXZH?=
 =?utf-8?B?YmV5NlFvZ0t6eHdzd0N1cXhpelZjYUk5elQ1dlQzRVlmZmlEd0x6WjFqdlpy?=
 =?utf-8?B?NVkxL1V6Lzl0WE5XaGRTWm5DQTZHbkxRWUdmWWxxVk0ydUU2ZFZmdmxrVFVw?=
 =?utf-8?B?ZVNYdjVoUlBZK0V6SUNKZ1Fjb1NTMDRPdy85dG1KU29wUllsSEF0TDhIZWM0?=
 =?utf-8?B?eUF3c2tYUmcwdzg0MGVTVHl5aG1ob1BPN2wvT3hibnBVekQwSWR2MEcxVnZV?=
 =?utf-8?B?QitFZDJOUVdVQ0tBMXZUcFc5OW1YSk5zZVBZYkhlT3IzamZ1UlZaVkR5WStT?=
 =?utf-8?B?Q3Nrcm8xYXU5OWtzRWNRMlZ0aXEzSnJTbWdUM29lTFdsWDQzcGZKWTVJUitl?=
 =?utf-8?B?QzRxVVNLQ3lpR3JtN0ZpbEdGWjVIbnJFZTRPejh6c012M21MUnNXUytZd293?=
 =?utf-8?B?L2lQQWFnRjFSb0UwNkk3VkNaa2V2d3BNUFVqMHoyMUV0eTBtOGVnaUhBbXVq?=
 =?utf-8?B?cVF0bkpybnZhYWdWV0xUaUY3MUZRMDNKNU1zc3Y2OHV5clZyZ2VVd1lMbnEv?=
 =?utf-8?B?SlBuMWFJMDFvVDh0RFp6dUpSWERQaW9NeXFUQlhrekordzZMVUJzRDdSVmhE?=
 =?utf-8?B?YndtWEUxT3FsaEVpNzhSaENWd0xCUURTYXM2aHVqOGFSVnRhTG1rK0FpMFds?=
 =?utf-8?B?dDNXaG9ubmQ4WHZOWkJpTzRtOGMyVnNWN29BMlJscm8yTGljT2g0SWY2MW1T?=
 =?utf-8?B?c1krczZpaUhhc1VHb3Jxa1p1NGdvdnVGR05NVTJSYWpWbnFPVXRBVm5lWldm?=
 =?utf-8?B?RjhKT3IrREJlTlpEaG54aW9jam1HQ0lHbkpnMzRjSXhncEJid001NDRPTndy?=
 =?utf-8?B?RUc4MFFwSkdJRkdEQ0tDeW5Hb3VSSzhpeFQ3VXZHbGdNKys4NFNGaGlLbFRN?=
 =?utf-8?B?Ulhhb0dGekU4cFIvMmVEZzNSWjI5dHd5RGJ5T2FPc2JnTDd1V1BqaDZNRFlT?=
 =?utf-8?B?KzNOY1lWaUF5ZHl5Q0RGOUQ5ajEwTUV5YUc2SnZtMi9hUkRjTjFyZ3Z2OTJv?=
 =?utf-8?B?RHhxUHFuaU5FRFp0TUNCMDEwaDM3NGJsMGw4T0plT3lCOTRaNXpDc1crSW9i?=
 =?utf-8?B?ZXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6FDFB0B930D0BA408FE5D65078EC93ED@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04848a72-b259-49d4-496d-08dbba2594da
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2023 22:04:37.6442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xLKnhc2pU4zjWOtoqjqGnSulpmmvzwvH83eyNvqKRx2iILi+nArcLiBGnSHsgUR58JXlWu/VMOJdezQTRzdK9YvUyoTscbNdKmBRCDJ6zrU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4575
X-OriginatorOrg: intel.com

SGkgRGF2ZSwKCkxvb2tzIGdvb2QgYXBhcnQgZnJvbSBhIGNvdXBsZSBtaW5vciBuaXRzIC0KCk9u
IFR1ZSwgMjAyMy0wOS0xOSBhdCAxNjo1MiAtMDcwMCwgRGF2ZSBKaWFuZyB3cm90ZToKPiBUaGUg
Y3VycmVudCBvcGVyYXRpb24gZm9yIGRpc2FibGVfcmVnaW9uIGRvZXMgbm90IGNoZWNrIGlmIHRo
ZSBtZW1vcnkKPiBjb3ZlcmVkIGJ5IGEgcmVnaW9uIGlzIG9ubGluZSBiZWZvcmUgYXR0ZW1wdGlu
ZyB0byBkaXNhYmxlIHRoZSBjeGwgcmVnaW9uLgo+IFByb3ZpZGUgYSAtZiBvcHRpb24gZm9yIHRo
ZSByZWdpb24gdG8gZm9yY2Ugb2ZmbGluaW5nIG9mIGN1cnJlbnRseSBvbmxpbmUKPiBtZW1vcnkg
YmVmb3JlIGRpc2FibGluZyB0aGUgcmVnaW9uLiBBbHNvIGFkZCBhIGNoZWNrIHRvIGZhaWwgdGhl
IG9wZXJhdGlvbgo+IGVudGlyZWx5IGlmIHRoZSBtZW1vcnkgaXMgbm9uLW1vdmFibGUuCj4gCj4g
U2lnbmVkLW9mZi1ieTogRGF2ZSBKaWFuZyA8ZGF2ZS5qaWFuZ0BpbnRlbC5jb20+Cj4gLS0tCj4g
wqBEb2N1bWVudGF0aW9uL2N4bC9jeGwtZGlzYWJsZS1yZWdpb24udHh0IHzCoMKgwqAgNSArKysK
PiDCoGN4bC9yZWdpb24uY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHzCoMKgIDQ5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrLQo+
IMKgMiBmaWxlcyBjaGFuZ2VkLCA1MyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCj4gCj4g
ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vY3hsL2N4bC1kaXNhYmxlLXJlZ2lvbi50eHQgYi9E
b2N1bWVudGF0aW9uL2N4bC9jeGwtZGlzYWJsZS1yZWdpb24udHh0Cj4gaW5kZXggNmEzOWFlZTZl
YTY5Li4xNzc4ZWMzYTBmM2YgMTAwNjQ0Cj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9jeGwvY3hsLWRp
c2FibGUtcmVnaW9uLnR4dAo+ICsrKyBiL0RvY3VtZW50YXRpb24vY3hsL2N4bC1kaXNhYmxlLXJl
Z2lvbi50eHQKPiBAQCAtMjUsNiArMjUsMTEgQEAgT1BUSU9OUwo+IMKgLS0tLS0tLQo+IMKgaW5j
bHVkZTo6YnVzLW9wdGlvbi50eHRbXQo+IMKgCj4gKy1mOjoKPiArLS1mb3JjZTo6Cj4gK8KgwqDC
oMKgwqDCoMKgRm9yY2Ugb2ZmbGluZSBvZiBtZW1vcnkgaWYgdGhleSBhcmUgb25saW5lIGJlZm9y
ZSBkaXNhYmxpbmcgdGhlIGFjdGl2ZQo+ICvCoMKgwqDCoMKgwqDCoHJlZ2lvbi4gVGhpcyBkb2Vz
IG5vdCBhbGxvdyBvZmZsaW5lIG9mIHVubW92YWJsZSBtZW1vcnkuCgpJbnN0ZWFkIG9mICJGb3Jj
ZSBvZmZsaW5lIG9mLi4iIHBlcmhhcHMgc29tZXRoaW5nIGxpa2UgLSAKCkF0dGVtcHQgdG8gb2Zm
bGluZSBhbnkgbWVtb3J5IHRoYXQgaGFzIGJlZW4gaG90LWFkZGVkIGludG8gdGhlIHN5c3RlbQp2
aWEgdGhlIENYTCByZWdpb24gYmVmb3JlIGRpc2FibGluZyB0aGUgcmVnaW9uLiBUaGlzIHdvbid0
IGJlIGF0dGVtcHRlZAppZiB0aGUgbWVtb3J5IHdhcyBub3QgYWRkZWQgYXMgJ21vdmFibGUnLCBh
bmQgbWF5IHN0aWxsIGZhaWwgZXZlbiBpZiBpdAp3YXMgbW92YWJsZS4KCi0gYmVjYXVzZSB3ZSBj
YW4ndCByZWFsbHkgZm9yY2UgdGhlIG9mZmxpbmluZyBzdGVwLCB0aGF0IGNhbiBhbHdheXMgYmUK
cmVmdXNlZCwgZXZlbiBpZiBpdCBpcyBtb3ZhYmxlLgoKPiArCj4gwqBpbmNsdWRlOjpkZWNvZGVy
LW9wdGlvbi50eHRbXQo+IMKgCj4gwqBpbmNsdWRlOjpkZWJ1Zy1vcHRpb24udHh0W10KPiBkaWZm
IC0tZ2l0IGEvY3hsL3JlZ2lvbi5jIGIvY3hsL3JlZ2lvbi5jCj4gaW5kZXggYmNkNzAzOTU2MjA3
Li43OWE1ZmI4MWMyNTcgMTAwNjQ0Cj4gLS0tIGEvY3hsL3JlZ2lvbi5jCj4gKysrIGIvY3hsL3Jl
Z2lvbi5jCj4gQEAgLTE0LDYgKzE0LDcgQEAKPiDCoCNpbmNsdWRlIDx1dGlsL3BhcnNlLW9wdGlv
bnMuaD4KPiDCoCNpbmNsdWRlIDxjY2FuL21pbm1heC9taW5tYXguaD4KPiDCoCNpbmNsdWRlIDxj
Y2FuL3Nob3J0X3R5cGVzL3Nob3J0X3R5cGVzLmg+Cj4gKyNpbmNsdWRlIDxkYXhjdGwvbGliZGF4
Y3RsLmg+Cj4gwqAKPiDCoCNpbmNsdWRlICJmaWx0ZXIuaCIKPiDCoCNpbmNsdWRlICJqc29uLmgi
Cj4gQEAgLTk1LDYgKzk2LDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBvcHRpb24gZW5hYmxlX29w
dGlvbnNbXSA9IHsKPiDCoAo+IMKgc3RhdGljIGNvbnN0IHN0cnVjdCBvcHRpb24gZGlzYWJsZV9v
cHRpb25zW10gPSB7Cj4gwqDCoMKgwqDCoMKgwqDCoEJBU0VfT1BUSU9OUygpLAo+ICvCoMKgwqDC
oMKgwqDCoE9QVF9CT09MRUFOKCdmJywgImZvcmNlIiwgJnBhcmFtLmZvcmNlLAo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgImRpc2FibGUgcmVnaW9uIGV2ZW4gaWYgbWVt
b3J5IGN1cnJlbnRseSBvbmxpbmUiKSwKCnNpbWlsYXJseSwKCiJBdHRlbXB0IHRvIG9mZmxpbmUg
bWVtb3J5IGJlZm9yZSBkaXNhYmxpbmcgdGhlIHJlZ2lvbiIKCj4gwqDCoMKgwqDCoMKgwqDCoE9Q
VF9FTkQoKSwKPiDCoH07Cj4gwqAKPiBAQCAtNzg5LDEzICs3OTIsNTcgQEAgc3RhdGljIGludCBk
ZXN0cm95X3JlZ2lvbihzdHJ1Y3QgY3hsX3JlZ2lvbiAqcmVnaW9uKQo+IMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gY3hsX3JlZ2lvbl9kZWxldGUocmVnaW9uKTsKPiDCoH0KPiDCoAo+ICtzdGF0aWMg
aW50IGRpc2FibGVfcmVnaW9uKHN0cnVjdCBjeGxfcmVnaW9uICpyZWdpb24pCj4gK3sKPiArwqDC
oMKgwqDCoMKgwqBjb25zdCBjaGFyICpkZXZuYW1lID0gY3hsX3JlZ2lvbl9nZXRfZGV2bmFtZShy
ZWdpb24pOwo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBkYXhjdGxfcmVnaW9uICpkYXhfcmVnaW9u
Owo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBkYXhjdGxfbWVtb3J5ICptZW07Cj4gK8KgwqDCoMKg
wqDCoMKgc3RydWN0IGRheGN0bF9kZXYgKmRldjsKPiArwqDCoMKgwqDCoMKgwqBpbnQgcmM7Cj4g
Kwo+ICvCoMKgwqDCoMKgwqDCoGRheF9yZWdpb24gPSBjeGxfcmVnaW9uX2dldF9kYXhjdGxfcmVn
aW9uKHJlZ2lvbik7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKCFkYXhfcmVnaW9uKQo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dDsKPiArCj4gK8KgwqDCoMKgwqDCoMKgZGF4
Y3RsX2Rldl9mb3JlYWNoKGRheF9yZWdpb24sIGRldikgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBtZW0gPSBkYXhjdGxfZGV2X2dldF9tZW1vcnkoZGV2KTsKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKCFtZW0pCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVOWElPOwo+ICsKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgaWYgKGRheGN0bF9tZW1vcnlfb25saW5lX25vX21vdmFibGUobWVt
KSkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbG9n
X2VycigmcmwsICIlczogbWVtb3J5IHVubW92YWJsZSBmb3IgJXNcbiIsCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGRldm5hbWUsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRheGN0bF9kZXZfZ2V0
X2Rldm5hbWUoZGV2KSk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gLUVQRVJNOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9
Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKgo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgKiBJZiBtZW1vcnkgaXMgc3RpbGwgb25saW5lIGFuZCB1c2VyIHdh
bnRzIHRvIGZvcmNlIGl0LCBhdHRlbXB0Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCAqIHRvIG9mZmxpbmUgaXQuCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoZGF4Y3RsX21lbW9yeV9pc19vbmxp
bmUobWVtKSAmJiBwYXJhbS5mb3JjZSkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmMgPSBkYXhjdGxfbWVtb3J5X29mZmxpbmUobWVtKTsKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChyYykgewo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGxvZ19lcnIoJnJsLCAiJXM6IHVuYWJsZSB0byBvZmZsaW5lICVzOiAlc1xuIiwKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgZGV2bmFtZSwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGF4Y3Rs
X2Rldl9nZXRfZGV2bmFtZShkZXYpLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzdHJlcnJvcihh
YnMocmMpKSk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJjOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9
Cj4gK8KgwqDCoMKgwqDCoMKgfQo+ICsKPiArb3V0Ogo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiBj
eGxfcmVnaW9uX2Rpc2FibGUocmVnaW9uKTsKPiArfQo+ICsKPiDCoHN0YXRpYyBpbnQgZG9fcmVn
aW9uX3hhYmxlKHN0cnVjdCBjeGxfcmVnaW9uICpyZWdpb24sIGVudW0gcmVnaW9uX2FjdGlvbnMg
YWN0aW9uKQo+IMKgewo+IMKgwqDCoMKgwqDCoMKgwqBzd2l0Y2ggKGFjdGlvbikgewo+IMKgwqDC
oMKgwqDCoMKgwqBjYXNlIEFDVElPTl9FTkFCTEU6Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gY3hsX3JlZ2lvbl9lbmFibGUocmVnaW9uKTsKPiDCoMKgwqDCoMKgwqDC
oMKgY2FzZSBBQ1RJT05fRElTQUJMRToKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
cmV0dXJuIGN4bF9yZWdpb25fZGlzYWJsZShyZWdpb24pOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gZGlzYWJsZV9yZWdpb24ocmVnaW9uKTsKPiDCoMKgwqDCoMKgwqDC
oMKgY2FzZSBBQ1RJT05fREVTVFJPWToKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHJldHVybiBkZXN0cm95X3JlZ2lvbihyZWdpb24pOwo+IMKgwqDCoMKgwqDCoMKgwqBkZWZhdWx0
Ogo+IAo+IAoK
