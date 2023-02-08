Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528AE62F
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 06:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675837442; x=1707373442;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nMsLqeI25KXCaT+YIyTf+3fgZzFPqKQ1g6OcIqQW4cM=;
  b=dCQYohMUKkB8sK4YnmUV0LxS+J4jfIYrVV0AxxszVhGN/Q/R+dgv2OEA
   Tm1VPJrDaQksIT456VTsAlxRl8/SSq/oroVAZeRlWnbjMeOE+jFJD35aP
   CKlB/jjWriICfFDYAxcrEv2nCYi1CXz1WGBLbp9u4XA3lzMHIuW38XlWc
   wVRpcvJgiwx7XWURFVoyt893MUxo3ch8xOen80qxI9c45PtMS3eIErjH4
   RfNAUmf4Kes6R7MssxqxbVcdk29tLY4JhW/XjxedwNN1Q2L419PfHlh3o
   fEFciAKQHp31QZIiSZ/KfDbFQc6S1kRnXjw+2nTYHSRz0Hr91cvxauqeW
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="317721471"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="317721471"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 22:23:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="912622073"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="912622073"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 07 Feb 2023 22:23:51 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 22:23:50 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 22:23:50 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 22:23:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jhb/dE8WUMSvaVGSDN8S+muEKqKycHqOGuQMqbg58Es8NQWs6QBUM02kpOycoHCtPq1Qfq3YIhweK/FuI7tIji3lHprhdQ01Yyl/HzrE6LmCde193a8UP5GYIRIyZF/7dxKOBQ8Qm/maV4S8KQ+DJQh6e+5MadvMFg93qB121jyKOXbV5XqbbcbW5x7jlSPZHwoyAKMAm+yqkLYhJQvV/gzjN+Y6N7e5ZLfYqYscwPbjcrhV3nzqaYWBCMctBv0Pqu/Qp1oGgedaZYi64OuC6lkap1dD4Ca5Yvw7KgGt1SDgFmGUA8qjicw6NhQcLfz4ia7rkM43KrYhGQIWN7eQeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nMsLqeI25KXCaT+YIyTf+3fgZzFPqKQ1g6OcIqQW4cM=;
 b=Ojwz3RqR8Ok/PqdonLMfmUFIQC9sQKWB6007b9iX09MWZKXZiN5VcUiI+0btEQ5ZuflH4nd+pAGtiCXaaSyx1bNaiplLDSWWiLXgnx4ebwYG++7pYYSA0kQNajdvp0UD+PFy63KDbirnwctA8wx8ogt6pRRQ6L1c8BqREXPY7FjojmhfMc66G6dbkPBQjigQfmDB2aQAn0RY+gRuPT7MEQcHpRxQhXanDAqE1ghfgkhFydoGR9EJaINLbmMi3AoRGFC9Ys7i5pWQIau8PwVJwO1n2l6VLwWHMZopR5/vOMyhYZlevOcI4y/cIEwbxP+gdXk9GIVh8UFytdbmED56Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN6PR11MB3988.namprd11.prod.outlook.com (2603:10b6:405:7c::23)
 by BY1PR11MB8077.namprd11.prod.outlook.com (2603:10b6:a03:527::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Wed, 8 Feb
 2023 06:23:48 +0000
Received: from BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::16cf:5ab1:7f74:d1e5]) by BN6PR11MB3988.namprd11.prod.outlook.com
 ([fe80::16cf:5ab1:7f74:d1e5%7]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 06:23:48 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "gregory.price@memverge.com"
	<gregory.price@memverge.com>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "dave@stgolabs.net" <dave@stgolabs.net>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 3/7] cxl: add core plumbing for creation of ram
 regions
Thread-Topic: [PATCH ndctl 3/7] cxl: add core plumbing for creation of ram
 regions
Thread-Index: AQHZOyjQmol0gElqfEWoXyX0vnCTrq7EbAWAgAApdQA=
Date: Wed, 8 Feb 2023 06:23:48 +0000
Message-ID: <544c4a34207fe45195472451730881991f541ec4.camel@intel.com>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
	 <20230120-vv-volatile-regions-v1-3-b42b21ee8d0b@intel.com>
	 <63e31d2bc5178_107e3f294e2@iweiny-mobl.notmuch>
In-Reply-To: <63e31d2bc5178_107e3f294e2@iweiny-mobl.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB3988:EE_|BY1PR11MB8077:EE_
x-ms-office365-filtering-correlation-id: 5e410134-e44c-43d1-6725-08db099d09f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1rqPYYthw2UFmKhF5pLChz+NCdnlyHmGxE9NSiaen7kGqR124GseKFbC42rglupeinoYmPIunV5fkZz1cpvBEJ+4s0nWBJf6MAt+qotaokL2G9IDir3bQBniN44ynQViD2Ta538RqkzYcrDFL1+ND9WGivcyc/uboEBNn8Kw0zaCV0BDVhNy6B7R6U67m51TvXWjm1/ZKSHr4ju+L0DS+XRMewmoqVQOrQxswc8pHJk0U5Z4sqbI3MQQs0/+iIDhly+LzDoa6HaysAi6aa4QLgsWsS1Kxt/CS1RaG8XLtN4wZ7TE1XacW7TuHP2uQwqoqvfyE5Oti5ereYm7czbFxXKUdZWY67sXXhhPwDS3lo5kHJxqLpvPABdXpjYT88DEFKfTVATYYR0pAuvWwvXsudAlB8unK3vJbMu4be30JOs0te1r2KBBMv38Hqhr7QzT1s326hUkzNjWqHfjQqpc1/gDqlcghvmZYumD7AYSgcNza+CvchB3e7LUEYd4fnRY8NXFkc095nTrZCSvUFCw963XOI8Juz6VcY+8kezcW8/pP+FYNxH24X4RPcB9SrR3OgiOrUPiW4WkAG9Wj1Y2KQ3uv6RedCkkhAz2vOYO6rL11ILIreoonfZ3AhLyCmMtJZlvs0XsOMZZTRJqZ83wl79CZaRyIYyqdySSGnMub8AWu0pZBLO+SV6rvt3dPT1Ja31qrv6azY/3Y9JTocFkzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB3988.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199018)(316002)(6636002)(54906003)(110136005)(83380400001)(86362001)(38070700005)(38100700002)(122000001)(82960400001)(6512007)(186003)(26005)(2616005)(6506007)(71200400001)(36756003)(6486002)(478600001)(41300700001)(5660300002)(2906002)(8936002)(64756008)(8676002)(66446008)(66476007)(66556008)(66946007)(91956017)(4326008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?THJRNGlMQXk0aXc4STJ2QTdlbVRVUVNWS1FwWWFVSTREdU5zQkUwdGRPTmNx?=
 =?utf-8?B?WWdzWWZkMTM5Q1hPTFhyaHI1eHg2QnFNQ09odjlWYTgxOGpxRzBsNGtYOTlp?=
 =?utf-8?B?VTBhWS9lVGNXTmxaNktUYUhnbVB6UEpITVBwMjZDc1ZCMHFiRlUvMFU1TGd4?=
 =?utf-8?B?OGlzaUlncFJxb1ZyVUJUU0QvVElWeTE3SVRMMFRmTk9hdCtpLzY4TWVjKzRK?=
 =?utf-8?B?MHpnb3FaanhjeTV5d0pZYkNZZFg0MngzZHQrVFQrb1daWVEwK2VkUFBrSDV4?=
 =?utf-8?B?b24rRVkyREg5TXFOQ0dWNGc3cE90bjdvRXl5YUxobGRLTTFnUC95akRDMzI1?=
 =?utf-8?B?cUl4OHppQm9KT1ZmRnFEMDM2VG5FWDRCVFVUSkJ0ZlBnQWwycWE0TGdUaGY3?=
 =?utf-8?B?dmorT3lOand6NlUySnZOVjE3MjQ3dEQwelk0M1kxSmFaTXhHdUxJTkdVUVkr?=
 =?utf-8?B?QTJWcnd1L1hyeENtVFpnQVZpQXFmUFZ5d0pOS0VCZStuWHZManhqRERmZ1VG?=
 =?utf-8?B?eVRYelhFKzdUbjFvSUhqRGk3ZVpxT3dTN0xSTlQveFVVZkpWM2V5QnRZdEpS?=
 =?utf-8?B?UmlVUzFZb0k5S0J3RjBWM3FWcG1rV0RjZ0s0ejB4NU9HNzc2S3hoR3FoMVJx?=
 =?utf-8?B?VU9ZQ2pDQStKSG45RkxLcnBlV1NTcUMzQTFsWFRiUHowcm5BY1g4N3ZIbUUr?=
 =?utf-8?B?VDhPVnRyS3VNQUR5SndEdGhtT0xCbkZHTmR3QWYrOEdoeGowenJjck5IS052?=
 =?utf-8?B?VzhFL0FSQjQ2NUdNSVlYT0tXNC8wcUdxRGMrbnpUMEMwU1lWYzF6TlVyanB4?=
 =?utf-8?B?Ry9ZcUptMUxSOFFuczhMdDdrMnd6eVd4VzBlWUVWQWRXNzdMNjU1NEI2S0xn?=
 =?utf-8?B?SlhZczVCdEVqbm5MaENaV0RYaWZ5cUJCZmxBemw3UFZtQklQRFlUMXRuRVhS?=
 =?utf-8?B?R21xNXRrRG9pOTd4RjBBRTlMa0ZPMm15SmMwQk56WHRxWDNsaWx6QUFIZXdG?=
 =?utf-8?B?cE0rM0hJUUtGdVJWamZlTGp6Ny83MGt2OERrSXIzYndHYUhCQTJLOHA4RG1E?=
 =?utf-8?B?eU5qYmkyREpPbjRpaW04RnNFY3VlQ0RSNDRTdGlPQnBaY24vMDZjL0tTUHZt?=
 =?utf-8?B?cHRNb0hXSmx4SEtKVmxCd2FUS2ZGSlJYbmpXS1Jsblhuc2RuOHEyVjhLazBm?=
 =?utf-8?B?Sk90NGF1VjV2MmJWVWw0YkFkaFFraTBaV3VqY01mZjcyVXNWcTNhL1ZNQ3ZY?=
 =?utf-8?B?dGRicE5BYSt3YmxkaUg5anZtTWFKQVJKalp4Y1IrV3l0Sm9GQjY3MzNJUkNy?=
 =?utf-8?B?RGROV1plR1ZDYTA1eTZGMUNiWDhkQkpIVTlIM1o1WFpsQWl3RG1rc0hnWjVl?=
 =?utf-8?B?SVlMWFdpb2x1bHhNemt6Q01RZ0lTUzhwNXZleEY1Qi9XY3kxYjlMVVUvME9T?=
 =?utf-8?B?SE5WN1lBUFRMTHN2blJBRGFvMm1haW1NVXBxMXRGd0x3NS9QaGJYUDU5VThV?=
 =?utf-8?B?S1poQTVJUGJQM0dQMHl0MFpHMlZaMFNKTmVUNndRckl3aGVVMFlYdU5NdTBY?=
 =?utf-8?B?Z1B4Q1NaV0lKZUl6UzhZSkVPUjdkbGN0eCtjdmNQUW9TRDY1bDdNMUVBeUtl?=
 =?utf-8?B?TmlLYitNa2lNWHYzK3lFMi96dHc5V00wRnh0emtuWmpLcEhKaHlEcWVjM01o?=
 =?utf-8?B?MGNiaW5rZXhxNU5yRG9wdGc5NDZTRzJyQ2d2b0hEcDNjNzZRbGo1VWZKZUoy?=
 =?utf-8?B?dEtENWZWQ3k2bmRuV2dyTldIaWovMTRpYUV1MjU3djYzb1IyNStBMnZ6aUdm?=
 =?utf-8?B?eGxBMzRNSE4vYUNpT1NBckxnK2RQSE1KeHRvSVBqMXd1Q21pY2hhdGxqMnhv?=
 =?utf-8?B?bXNWUnkxL2s3dTEwZ0NOKzBHSkxOVnhaWUdqTEVTQ2o0UXNvSFBabkJDVHFM?=
 =?utf-8?B?YzY2cHBYam95L05iQUxWM2RRaG5aSEdqWStGcTdEMmlLd3ZoSkJoaWJlUEFt?=
 =?utf-8?B?TE5WRVhHeTg1SlJab3dCQzM0MkNHM2dXTGRsNFZUN2MzTHB5WTgxd2thZG5S?=
 =?utf-8?B?ejVJUlg1RXN5aWNaNCtSbHhvNFVCOVd3ZEZxa0xMbnhERXk0Z2FEalp0U3Mx?=
 =?utf-8?B?RDJNUVA1TVR6aHByWEx0ZC9sdWpYNzRIRk5FOElvKzRFK3ZOcG1DblZ0M3dN?=
 =?utf-8?B?N0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AEB5C265A14366498BE465D5D493243F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB3988.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e410134-e44c-43d1-6725-08db099d09f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 06:23:48.3828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N6i1KV6pBweBSfvbb5oBFlIdFESQHiSGTfTJt3JFgDIkzJaCRLkZsZgvA012UjHjEcwWoQLPRdf0Zzo+TyF48CytM6woQnvvQPT5rUkaNLs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8077
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTAyLTA3IGF0IDE5OjU1IC0wODAwLCBJcmEgV2Vpbnkgd3JvdGU6Cj4gVmlz
aGFsIFZlcm1hIHdyb3RlOgo8Li4+Cj4gPiAKPiA+IGRpZmYgLS1naXQgYS9jeGwvcmVnaW9uLmMg
Yi9jeGwvcmVnaW9uLmMKPiA+IGluZGV4IDM4YWExNDIuLjA5NDVhMTQgMTAwNjQ0Cj4gPiAtLS0g
YS9jeGwvcmVnaW9uLmMKPiA+ICsrKyBiL2N4bC9yZWdpb24uYwo+ID4gQEAgLTM4MCw3ICszODAs
MjIgQEAgc3RhdGljIHZvaWQgY29sbGVjdF9taW5zaXplKHN0cnVjdCBjeGxfY3R4ICpjdHgsIHN0
cnVjdCBwYXJzZWRfcGFyYW1zICpwKQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBzdHJ1Y3QganNvbl9vYmplY3QgKmpvYmogPQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKganNvbl9vYmplY3RfYXJyYXlfZ2V0X2lkeChwLT5tZW1k
ZXZzLCBpKTsKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IGN4bF9t
ZW1kZXYgKm1lbWRldiA9IGpzb25fb2JqZWN0X2dldF91c2VyZGF0YShqb2JqKTsKPiA+IC3CoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB1NjQgc2l6ZSA9IGN4bF9tZW1kZXZfZ2V0X3BtZW1f
c2l6ZShtZW1kZXYpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHU2NCBzaXpl
Owo+ID4gKwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHN3aXRjaChwLT5tb2Rl
KSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY2FzZSBDWExfREVDT0RFUl9N
T0RFX1JBTToKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgc2l6ZSA9IGN4bF9tZW1kZXZfZ2V0X3JhbV9zaXplKG1lbWRldik7Cj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJyZWFrOwo+ID4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNhc2UgQ1hMX0RFQ09ERVJfTU9ERV9QTUVNOgo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzaXplID0gY3hsX21l
bWRldl9nZXRfcG1lbV9zaXplKG1lbWRldik7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJyZWFrOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGRlZmF1bHQ6Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoC8qCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAqIFRoaXMgd2lsbCAncG9pc29uJyBlcF9taW5fc2l6ZSB3aXRoIGEgMCwgYW5kCj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIHN1YnNl
cXVlbnRseSBjYXVzZSB0aGUgcmVnaW9uIGNyZWF0aW9uIHRvIGZhaWwuCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzaXplID0gMDsKPiAKPiBXaHkgbm90
IGNoYW5nZSBjb2xsZWN0X21pbnNpemUoKSB0byByZXR1cm4gaW50IGFuZCBwcm9wYWdhdGUgdGhl
IGVycm9yIHVwCj4gdGhyb3VnaCBjcmVhdGVfcmVnaW9uX3ZhbGlkYXRlX2NvbmZpZygpPwo+IAo+
IEl0IHNlZW1zIG1vcmUgY29uZnVzaW5nIHRvIGhpZGUgYSBzcGVjaWFsIHZhbHVlIGluIHNpemUg
bGlrZSB0aGlzLgo+IApIbSwgdHJ1ZSwgdGhvdWdoIHRoZSBkZWZhdWx0IGNhc2Ugc2hvdWxkIG5l
dmVyIGdldCBoaXQuIEluIGZhY3QgSSB3YXMKcGxhbm5pbmcgdG8gbGVhdmUgaXQgb3V0IGVudGly
ZWx5IHVudGlsIGdjYyB3YXJuZWQgdGhhdCBJIGNhbid0IHNraXAKY2FzZXMgaWYgc3dpdGNoaW5n
IGZvciBhbiBlbnVtLiBJIHRoaW5rIHRoZSBjb21tZW50IGlzIG1heWJlIG1pc2xlYWRpbmcKaW4g
dGhhdCBpdCBtYWtlcyBvbmUgdGhpbmsgdGhhdCB0aGlzIGlzIHNvbWUgc3BlY2lhbCBoYW5kbGlu
Zy4gSXQgd291bGQKcHJvYmFibHkgYmUgY2xlYXJlciB0byBtYWtlIHNpemUgPSAwIGluIHRoZSBp
bml0aWFsIGRlY2xhcmF0aW9uLCBhbmQKbWFrZSB0aGUgZGVmYXVsdCBjYXNlIGEgbm8tb3AgKG1h
eWJlIHdpdGggYSBjb21tZW50IHRoYXQgd2Ugd291bGQgbmV2ZXIKZ2V0IGhlcmUpLiBEb2VzIHRo
YXQgc291bmQgYmV0dGVyPwo+IAo=
