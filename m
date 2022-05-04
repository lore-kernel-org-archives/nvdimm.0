Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238A433DF;
	Wed,  4 May 2022 22:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651705019; x=1683241019;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=97MDwCeuXEBYnN3PMMEk2u0Rr98d4kxIyhnw5EXyTmk=;
  b=DRj5myKzE3BY8yRjq8owNdA4z3oEHCEOAG7Vg3ndQ6pQQ4oesAou9bEE
   qc0dDfGOwXpzn2RNSH55LQ1b3dNDW8PKRuhvpMNmCTb2EcQZHmY+3tAJs
   lOZNp51NtSqTFxux1iZmC5PdbWsdd3rYVNXVDPpamT1lF9/hoatfMOZB3
   S6ofrfteoe2lXF+AAqYNNHEck6fd7rom8tl9gKgArDc1mqFqgezrarruj
   EJoemTavClDieCKFuL0T5g1aE8VghQl+8kvF8WuEvU6EsngRDtIpPYVqL
   XXwjkbzFa4w5XLBff8ZMDG2LHwqzpK/ixpkA6ye1wibxGXb0jSo+H1DeT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="293118902"
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="293118902"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 15:56:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,199,1647327600"; 
   d="scan'208";a="537053384"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga006.jf.intel.com with ESMTP; 04 May 2022 15:56:57 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 15:56:57 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 15:56:56 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 4 May 2022 15:56:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 4 May 2022 15:56:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EilSXuQaHQJhTofcPW7hR1Ta9EIt+3S+UCESbO+fp7pvK+LHegK71AwsVtozYK3orEYqypytNj2blUXRyuIv84AEi9XRRNkVVFb8B6oZYKcBxpFvdbGNdkED1tzkqcT0/ZZ7SWpC/jgrO73xI4YXPHKRRPRTfS2aPjkwra98VhZyyE7OdnP0EVVZSJBfuq42n9Rqk8s/TkPSXVHVhBrKk9kM3m/O0NQQTSIzKOAJp4Bqvqfwd5LmNbGtbh8VWjJ9ZDHMvsOBdVNP7Qkx3JReJzF7APTHJtlXRfAXZhI2+QVpCm4I9yf6E1oJ/OM+p+VMkZWm5xgPn2hRTIMz71bU8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=97MDwCeuXEBYnN3PMMEk2u0Rr98d4kxIyhnw5EXyTmk=;
 b=LdtxlY9R/U1BqH10dJFga8V54ZXs+soy7dtqs3IVk+Zrx4pjhAZo3qvxi1Vg15LhzTbOhB0gtxFC4P1MuAtJtmvJA8KdcMQ/pnstWx1qoY0uvcoTJKiox/GpqJ8bgztRNbjptjjizd59hha2xC1xAW0BAia3GUFH90zF487bSCxGHWq3+ZAsl8E/skGTFm42H23dnCTRTuT9yCyDVvETDRGDr1cjb9e15PRX546FkrFV9o6EHxFu+7mKiNCtB7rOHWjLeAArcp5bNcyW8VCjHFjIDhEqBwVb1EiXv9U0597YuG0p71sr2+qgl4juQ0oX1B/gUev4Whaj/E/luFl3nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BY5PR11MB4401.namprd11.prod.outlook.com (2603:10b6:a03:1be::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Wed, 4 May
 2022 22:56:48 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::e576:1ed2:dc35:14bc]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::e576:1ed2:dc35:14bc%5]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 22:56:48 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Widawsky, Ben" <ben.widawsky@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Schofield, Alison"
	<alison.schofield@intel.com>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 12/15] cxl/region: Add region creation ABI
Thread-Topic: [RFC PATCH 12/15] cxl/region: Add region creation ABI
Thread-Index: AQHYT2WYYE5muSBTek66Cl+8D3t8rq0PdaoA
Date: Wed, 4 May 2022 22:56:47 +0000
Message-ID: <f9fa0a306b167db2a91021aff70bcdbc8c154391.camel@intel.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
	 <20220413183720.2444089-13-ben.widawsky@intel.com>
In-Reply-To: <20220413183720.2444089-13-ben.widawsky@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.42.4 (3.42.4-2.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8bb5da1-e2f1-48f2-8d7e-08da2e215e54
x-ms-traffictypediagnostic: BY5PR11MB4401:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <BY5PR11MB44019E2D6F2DECBC9A5E424DC7C39@BY5PR11MB4401.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4wyRpdfHmlLKOw8pN1F+yYBXW8j2FXkvcRxHZkhNuPDO++nlJQqZEWKjEIQ2lqyjUT/9vPqtN926o/RNQTp/GSOKfY0lLuFuUj2MyjECFPpvhoZCR2ttoHHGYbXbkhP60Xff2012LLSUIGliTxfEosZN49BbeuNMFVCU1ODVefd9DfJtUvr8MQAQvVGB6eSwZYMatbs5bCZ8gD5lf+mdALUlmnmHLZQZClnsX9UC9bksoTxVmtQkdmgK39Jv/cQMODgXWRsVyFBdgxvdfOc0ajIvBjx+bDxH7QsOzwDzNllauRghMOPr/Vx1faKineYTuXy0DtFYsa9ixCIz3WTf2pBrOq8ggN6TD4jNzxkwnEX2MiAU6DmHOhYKfQz4I9zjtnsWVZtKpIREKiqP1zyrbW/WPaWeEDMKlhkSWPpjgbGeUSSVGXhXYC75xuFyZNJbqEIkIUz34+bP1la+1HoywNHdKj1SRO+aTe+OqWBFi4CboeSl9FjFWmsdbDkEMA7f2lJjpNSIap/4BrM1P30c6ccN9yW/h4W7bOvCDKrVM8hfUyJ1/bosjyyRGP1N4JzYinWlJAme0bnKWRuIfM2QOUTxd/Sj01+QGTVnMnxmEHo1dTfRf78fN5vSbWa33n4UJqpm5FpdbXi5IkGSaKsnW6vE6/POd/BJ3SFmNer4S1d6AjDEAZQRMeENhm+sL3Hs+KDAK+5egbYHj8PgaxU57Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(508600001)(66946007)(2616005)(6486002)(54906003)(6512007)(36756003)(64756008)(86362001)(26005)(38070700005)(186003)(38100700002)(83380400001)(66556008)(66446008)(91956017)(4326008)(76116006)(8676002)(122000001)(82960400001)(2906002)(110136005)(5660300002)(8936002)(6506007)(316002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXNYOXFtdEM2ajZoSzlHdEJHSVF4M1ZKY2Vjb1VxOG14U2lZaWJ2dittaUtt?=
 =?utf-8?B?bENPeERqbDBnUFQrNEs3WEhVczUwRThzalRIaWFTTnNkYkdwekpxeGtFaWNE?=
 =?utf-8?B?VnRrc25Cb2JXekJ4NThzU3NaNVFOZ0xNaWVYVjlvNjNiUTA3NlRhTGhMbGh4?=
 =?utf-8?B?a3c4RFZEdXhoRXl5T21rN1ZUdFM2dU04SXVCRFpPZDFXUjN5QlU2cXBYTVdz?=
 =?utf-8?B?YXRtakdJSGoyTUNaWFhDNU5CUkFQWlpZZEx4c2pxQmVybTBYZkc4Q3NJRUtL?=
 =?utf-8?B?NTRRN1V6VVVmLzdibzI4WC9US0wwQVZTOXlnaWl1b1U0TnV6ZG16NDlObCtu?=
 =?utf-8?B?dGRxV1BXYzV0UG11UVo5L3ByTVk2MnYyMzdHMkZTMzRyTFVnZFhXVVlMWWtQ?=
 =?utf-8?B?UW1KM3EweVBMY2xWTS9NVUJaZlhKRjVkaDU5UjBWMVl0dDlaOThUK2s5ckdM?=
 =?utf-8?B?L2hBZXNzYXJTc0pQTXEwQ2h3N2JFRW5iZDNHbThxMWdPaEVKaGdyUm1jOXBr?=
 =?utf-8?B?ajZ0dWNPbXVwY0IvT3pFUUNkT3grQjc1Z0VnQi82VlZxUzZCbjdUeC9vLzUv?=
 =?utf-8?B?WFR0alVuVElqK0wrNnVSRTJxQWtvR0VrNG5KSVBybkswYXh3OHBvS2ZPWlJy?=
 =?utf-8?B?TVFDYnNlbjhySStjbUhnQ3cvVWczaHpVaHZ3RlBHbWNpTWtpajNUdWpTeGFT?=
 =?utf-8?B?NTlJMzFEZEh1Z0diNzBDazdCZmd5T2hjR3pVZlIxVDB0S1duSnRHVjlheVEr?=
 =?utf-8?B?S1pNc3JQMmZ5Z0RDQUJlTGNWeVM2djAwS28rSmVDTWhoZDhWanN0MFkvL3U0?=
 =?utf-8?B?anVwVkVKSlVHbHJNdzQvNGt2MUZ1czk1bnNqUnppN09UZjV2NWU1OCtlTUN2?=
 =?utf-8?B?Q0hUeGhSdjE4WitGUUQ4WGlScnA3UzZCUFBJc3lreXE3WGZ0TTNvZDdTaVpK?=
 =?utf-8?B?NndkRll2UE1xdE11dXJ3eDVpRzdEVmZHcW8wWkU2M3pzc0xsMklYYkRrQW9y?=
 =?utf-8?B?WW0xWjMwNVRuOXQ5NmlNTktMN0h5RkZCMTdBZWh2WUZsYjd2QUszaFoxQVV2?=
 =?utf-8?B?d0dzNjcrL2lrNy9KalBWVjZMNm1OK3NEMmMrVTllZE1CVWc3WG92YUM1bk52?=
 =?utf-8?B?MVhwUzZJQUJGcWttUGNoelJIeUFjY1RoTzBYU3hyZGt4eE8xZEhGSjRFSk4y?=
 =?utf-8?B?Yi81c0VaaW5JeUpwK3RpbjZUTGMrdjZ1MlppZmZjbEM5T0FxMERzSEpiU3Bk?=
 =?utf-8?B?T1p3ZDd0NFVUNWxCc3ZLd2hrY014TWhOd2tjODBQSHdxOWx5WUwreXRqajNB?=
 =?utf-8?B?R1ByV0RrekdycG93UVJOdW4vakYyanNrMDFuNEJUQ0l2Y0c1R3BnU1FZdmZW?=
 =?utf-8?B?TE4zUUgvSG1MV0tJbEtZbUdvazFGYi94a01WcVlLZFRpTlBTMVE5ZGlrL2c3?=
 =?utf-8?B?SC82ZGtiNmQrU29BY1FvMW5ySU1hWDAxVkZJcEpSL21UTml6Qzd4OUdXZGNj?=
 =?utf-8?B?Z1BXNi9FazFpanlocExjZjNScDI0ZUZJNlkweXZuekJiTjFnUmFVL1FHUnIy?=
 =?utf-8?B?NTFMbklKRlRCZVI0eWtMbE9ybXhObWY5TkphUjhza0RmdDM5eDJ5MjhMREdm?=
 =?utf-8?B?cUVrY2dLeENCWkYrUDFyYzVrL1lwMThlc09ZNE85OFlqUjhMZFJ2Q090NzNM?=
 =?utf-8?B?bjAzMm9wYis5RXJOWDJsRkloT1RUWGxOaThlcWMrYkk0ZnRHZjF4a3FxRWhU?=
 =?utf-8?B?V0JKeCtZU1ZSMjdvZWFjOUVQUDQrdENFbUlKVGRLK29JazE4M29pYVVyUXhl?=
 =?utf-8?B?WFRwM3g4bk50dDk4Kzc5K091Nll2dkwzd1g4dGxkNUVtbXdPc01VdHFXNzNy?=
 =?utf-8?B?ZkNNME5ORGk3VEZEVkYwem9URS95SFd5cS9LK2w0QnNoeG9Sb0dOQW9WWE1J?=
 =?utf-8?B?UFF3MVMyZEdYcFRmQnlseXd6cDlURUxkYlJOUFRNV1lta2xsR2hiRW53UFJJ?=
 =?utf-8?B?d0ppbk90UTZLQjgwMHVpZ0R2MXdPQ2tuQjlyeVk0eS91ZSs3VEVianVVMk9V?=
 =?utf-8?B?ZWpDUVIwYi95bHNUYjdYcWROcy9laURqQzZhMzY4T0pDYU9QUWFhMllzSjQx?=
 =?utf-8?B?SW14RGZBYzRGQ0dHcThJOWk3M0kwL0RVQ0tOSDZVR3pOREtuL0dzcjc1MTRt?=
 =?utf-8?B?dytZZUNLbVlFdWdidFRWY2x5dkZOemRZbThZVjhnVGx3aDFOSnphRVNudncv?=
 =?utf-8?B?NGNvLzdTMzB1bDRZRlh6NGNUUnhDb1VrRVh5QW1vYWNvN2pEaUNpZEkvTUlH?=
 =?utf-8?B?dkYxTWc1OWx6Y0tHLzlBNG0zcGpZZ0NORUN6S2t4bkkycjBLS0JwSTFTWW5Y?=
 =?utf-8?Q?N+Uub8Pw/ILbcVIs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <23CC6F9C7D16CF43AAC13787631932EA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8bb5da1-e2f1-48f2-8d7e-08da2e215e54
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2022 22:56:47.7275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cquh/ttwG6Zpj9rxjqqT7/JT5EkqoG18gm5iKaF44KVJaDNR5DUViYXzx25k5BdZLMZ3uB9hxj/qBntA/pehutNd75r/zcRSKitTlzUx8W0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4401
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIyLTA0LTEzIGF0IDExOjM3IC0wNzAwLCBCZW4gV2lkYXdza3kgd3JvdGU6Cj4g
UmVnaW9ucyBhcmUgY3JlYXRlZCBhcyBhIGNoaWxkIG9mIHRoZSBkZWNvZGVyIHRoYXQgZW5jb21w
YXNzZXMgYW4KPiBhZGRyZXNzIHNwYWNlIHdpdGggY29uc3RyYWludHMuIFJlZ2lvbnMgaGF2ZSBh
IG51bWJlciBvZiBhdHRyaWJ1dGVzIHRoYXQKPiBtdXN0IGJlIGNvbmZpZ3VyZWQgYmVmb3JlIHRo
ZSByZWdpb24gY2FuIGJlIGFjdGl2YXRlZC4KPiAKPiBNdWx0aXBsZSBwcm9jZXNzZXMgd2hpY2gg
YXJlIHRyeWluZyBub3QgdG8gcmFjZSB3aXRoIGVhY2ggb3RoZXIKPiBzaG91bGRuJ3QgbmVlZCBz
cGVjaWFsIHVzZXJzcGFjZSBzeW5jaHJvbml6YXRpb24gdG8gZG8gc28uCj4gCj4gLy8gQWxsb2Nh
dGUgYSBuZXcgcmVnaW9uIG5hbWUKPiByZWdpb249JChjYXQgL3N5cy9idXMvY3hsL2RldmljZXMv
ZGVjb2RlcjAuMC9jcmVhdGVfcG1lbV9yZWdpb24pCj4gCj4gLy8gQ3JlYXRlIGEgbmV3IHJlZ2lv
biBieSBuYW1lCj4gd2hpbGUKPiByZWdpb249JChjYXQgL3N5cy9idXMvY3hsL2RldmljZXMvZGVj
b2RlcjAuMC9jcmVhdGVfcG1lbV9yZWdpb24pCj4gISBlY2hvICRyZWdpb24gPiAvc3lzL2J1cy9j
eGwvZGV2aWNlcy9kZWNvZGVyMC4wL2NyZWF0ZV9wbWVtX3JlZ2lvbgo+IGRvIHRydWU7IGRvbmUK
PiAKPiAvLyBSZWdpb24gbm93IGV4aXN0cyBpbiBzeXNmcwo+IHN0YXQgLXQgL3N5cy9idXMvY3hs
L2RldmljZXMvZGVjb2RlcjAuMC8kcmVnaW9uCj4gCj4gLy8gRGVsZXRlIHRoZSByZWdpb24sIGFu
ZCBuYW1lCj4gZWNobyAkcmVnaW9uID4gL3N5cy9idXMvY3hsL2RldmljZXMvZGVjb2RlcjAuMC9k
ZWxldGVfcmVnaW9uCgpJIG5vdGljZWQgYSBzbGlnaHQgQUJJIGluY29uc2lzdGVuY3kgaGVyZSB3
aGlsZSB3b3JraW5nIG9uIHRoZSBsaWJjeGwKc2lkZSBvZiB0aGlzIC0gc2VlIGJlbG93LgoKPiAr
Cj4gK3N0YXRpYyBzc2l6ZV90IGNyZWF0ZV9wbWVtX3JlZ2lvbl9zaG93KHN0cnVjdCBkZXZpY2Ug
KmRldiwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIs
IGNoYXIgKmJ1ZikKPiArewo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBjeGxfZGVjb2RlciAqY3hs
ZCA9IHRvX2N4bF9kZWNvZGVyKGRldik7Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGN4bF9yb290
X2RlY29kZXIgKmN4bHJkID0gdG9fY3hsX3Jvb3RfZGVjb2RlcihjeGxkKTsKPiArwqDCoMKgwqDC
oMKgwqBzaXplX3QgcmM7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoC8qCj4gK8KgwqDCoMKgwqDCoMKg
ICogVGhlcmUncyBubyBwb2ludCBpbiByZXR1cm5pbmcga25vd24gYmFkIGFuc3dlcnMgd2hlbiB0
aGUgbG9jayBpcyBoZWxkCj4gK8KgwqDCoMKgwqDCoMKgICogb24gdGhlIHN0b3JlIHNpZGUsIGV2
ZW4gdGhvdWdoIHRoZSBhbnN3ZXIgZ2l2ZW4gaGVyZSBtYXkgYmUKPiArwqDCoMKgwqDCoMKgwqAg
KiBpbW1lZGlhdGVseSBpbnZhbGlkYXRlZCBhcyBzb29uIGFzIHRoZSBsb2NrIGlzIGRyb3BwZWQg
aXQncyBzdGlsbAo+ICvCoMKgwqDCoMKgwqDCoCAqIHVzZWZ1bCB0byB0aHJvdHRsZSByZWFkZXJz
IGluIHRoZSBwcmVzZW5jZSBvZiB3cml0ZXJzLgo+ICvCoMKgwqDCoMKgwqDCoCAqLwo+ICvCoMKg
wqDCoMKgwqDCoHJjID0gbXV0ZXhfbG9ja19pbnRlcnJ1cHRpYmxlKCZjeGxyZC0+aWRfbG9jayk7
Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKHJjKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gcmM7Cj4gK8KgwqDCoMKgwqDCoMKgcmMgPSBzeXNmc19lbWl0KGJ1ZiwgIiVkXG4i
LCBjeGxyZC0+bmV4dF9yZWdpb25faWQpOwoKVGhpcyBlbWl0cyBhIG51bWVyaWMgcmVnaW9uIElE
LCBlLmcuICIwIiwgd2hlcmUgYXMKCj4gK8KgwqDCoMKgwqDCoMKgbXV0ZXhfdW5sb2NrKCZjeGxy
ZC0+aWRfbG9jayk7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHJldHVybiByYzsKPiArfQo+ICsKCjxz
bmlwPgoKPiArc3RhdGljIHNzaXplX3QgZGVsZXRlX3JlZ2lvbl9zdG9yZShzdHJ1Y3QgZGV2aWNl
ICpkZXYsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGNvbnN0IGNoYXIgKmJ1Ziwgc2l6ZV90IGxlbikKPiArewo+ICvCoMKgwqDCoMKgwqDC
oHN0cnVjdCBjeGxfcG9ydCAqcG9ydCA9IHRvX2N4bF9wb3J0KGRldi0+cGFyZW50KTsKPiArwqDC
oMKgwqDCoMKgwqBzdHJ1Y3QgY3hsX2RlY29kZXIgKmN4bGQgPSB0b19jeGxfZGVjb2RlcihkZXYp
Owo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBjeGxfcmVnaW9uICpjeGxyOwo+ICsKPiArwqDCoMKg
wqDCoMKgwqBjeGxyID0gY3hsX2ZpbmRfcmVnaW9uX2J5X25hbWUoY3hsZCwgYnVmKTsKClRoaXMg
ZXhwZWN0cyBhIGZ1bGwgcmVnaW9uIG5hbWUgc3RyaW5nIGUuZy4gInJlZ2lvbjAiCgpXYXMgdGhp
cyBpbnRlbnRpb25hbD8gSSBkb24ndCB0aGluayBpdCdzIGEgaHVnZSBkZWFsLCB0aGUgbGlicmFy
eSBjYW4KY2VydGFpbmx5IGRlYWwgd2l0aCBpdCBpZiBuZWVkZWQgLSBidXQgd291bGQgaXQgYmUg
YmV0dGVyIHRvIGhhdmUgdGhlCkFCSSBzeW1tZXRyaWNhbCBiZXR3ZWVuIGNyZWF0ZSBhbmQgZGVs
ZXRlPwoK
