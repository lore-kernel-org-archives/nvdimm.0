Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C02C8472
	for <nvdimm@lists.linux.dev>; Tue, 13 Dec 2022 23:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670973314; x=1702509314;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=i6ZdZFyyYrF0V8pdepglvwU3JxpKgvHL2yRPM2HtLHo=;
  b=G8IddBq/m2GE0E3yIUjzryx7fYjWkBTOaHZ1OKQXASF2SnWCJRhS+m1W
   BP+pQ8ADUR3uVQFNHwJ6gld8FcIzpVyLq4wf8JD6kqevMjW+HxnjRmDSy
   FuyIEfXQMWNoexUEkn7ECWy61WU5Fetjpn+2u3oSaAXoz9OiM2jRzqFPw
   Pd1th+26v0RbC2CenM/1sSna7lnK/oB8vYOzr0K4le5uguas6BiRRy4x1
   E+KZpo/d3efvEoJ0Sm3GGfVMj19PrQT6+DrCmq9KBK+jkFmzBw8IxEPvx
   d2MIwM/V9rvCP0DtzqnF2KXJCCQzNdbHE6ky9rP3yCKUyALWsJWwlrgAf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="305900971"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="305900971"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 15:14:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="791106219"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="791106219"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2022 15:14:59 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 15:14:58 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 15:14:58 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 15:14:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SA1AcDpm4jVQyzcjwvn7CO1jQx/XcwS9xZ2VxXaz+9+jCANTd+622UmtVusMqeFsBL3aWehvWBjQgt7KZyAyttUF7AqID/laJTLMIfKVHjUMBdbzXnTQ45bX/ML1yfH9r63/PPj+GcsTwYsIyCm2UT+V8RndAHczzBSYUtaVXI08/u4zHRn7zo0+YO+Pl231T2KODaDbG2kCjNyK09U+9QfTwv8gAk6ejvddqHuPXzqYWTaV6IeIBQfsCDzo4Z3bVr8h2GufmHnbwfNghEoHX7ZVAf9AQXpG1o0tWO1a67Kaln+WPmFEjCcooIT8dXwsVGdkf20zVFuUzGXYg1p7JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i6ZdZFyyYrF0V8pdepglvwU3JxpKgvHL2yRPM2HtLHo=;
 b=K01tvvzEBIxq1zrFNx8ciChgKpBeTNTm8KIf4EyUSQ1Cm80UzIWIfV/hEO0O7b93kHY0aurgtPtwIVPXfibRooPwYMOL+HCKFqLQp/+eTC4Pc9PsvPc3CjLdkc1KIKwYBDax8y0Tuxbbv12RU0NmUMcmK9Hfp3arsrvhlA9RqJNbGU5T9pBA6wgOxfcM3ECiPlXfUyDx35qP0yi9/7zjwYUs1/+t4tSTItkPCTi/M6zq3jIgQcJxR/pOdqaxYlTxA9b78VxDxXSBqbKfwOX4B3mEC3VBnY21UYQHaRkk2dOGycyiLdxule62l5pCxRh9mY9xbwjMKzF4YyfpetI9Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by DM6PR11MB4596.namprd11.prod.outlook.com (2603:10b6:5:2a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 23:14:56 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 23:14:56 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH 3/4] ndctl/libndctl: Add retrieving of unique_id for cxl
 mem dev
Thread-Topic: [PATCH 3/4] ndctl/libndctl: Add retrieving of unique_id for cxl
 mem dev
Thread-Index: AQHYzf2LDu3zeI7V5UqmGQCshMAFka5s9XCA
Date: Tue, 13 Dec 2022 23:14:56 +0000
Message-ID: <6bee8295626b1fd3e8d2fe87822e0dc7715a14e9.camel@intel.com>
References: <166379397620.433612.13099557870939895846.stgit@djiang5-desk3.ch.intel.com>
	 <166379417347.433612.4934530706825880453.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <166379417347.433612.4934530706825880453.stgit@djiang5-desk3.ch.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.2 (3.46.2-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|DM6PR11MB4596:EE_
x-ms-office365-filtering-correlation-id: 576f6365-03ac-4be6-0a36-08dadd5fd994
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CBtACzb8zerrEXbj4Q8qNMJOnPhqlERACSu0KyMfNFxsavWgs1KFNl6jM+8cCCb5JwXEgfc5Tg8nGeOQHbxVWMkovQzUSfPhiz9DAqaHyM6QynpeEAoE6Nh/NOfxZmQ3vYNG8n+zkipBgR9PXUBMtDozieodkM5qOHvPvVVpA/xheXTU9gq0Clg2G7uVrydwkzxzT4ezo59H0rmLprF+mmPwitizW3Tg0PL9ZijbY6BvMHoxEKFLhCanVW38mnRMi3Kx/x6knCETi8blHFH5QsY90XFY4oYAyyi7ETmVvjzsOJim5o64/3Ff1e7AjhWS1P1O59wS+7ag7AqdvaZ3gzuJXLuk/MUyYayoPJpVnCIqRudcpVazGta02+3d682+gY8HZd4ZF4JieefAvi2YcBgtDj9CV1PzZWVI2F6VgYarRFevA7gASJxLk5R8qNY2vkyP93pM6tV1MYFNlYVEcF8JIW2N/AsHXVK6zM5vvsr3l6h0ZybNnrHsIN0gDYZPXwdBzClmym8qSLbfXnVcj7tvO9htG3JpBOw4xHDK1pli7IDPQlEXWjR2JhW1RtmbxoTWLMasMZ5ff33agnVln0gbRW735k65nAcVdvk2OA7LsgQIheu78vlXFWfNPeVxM+RLcuffjN/0lZ1C3CF6Q+ojgES/sLn7hSAyP7daP6xwscYh0c24bsg+zxN7PGjkvguON8VKHWEDIilDHW1/yA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199015)(71200400001)(478600001)(6486002)(26005)(186003)(6506007)(6512007)(38070700005)(316002)(91956017)(5660300002)(2906002)(83380400001)(76116006)(36756003)(66446008)(64756008)(110136005)(8676002)(66946007)(66476007)(2616005)(66556008)(122000001)(86362001)(8936002)(41300700001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enBjeVUzTjVpdlQyenp0VkNSZ01Pamo0anlRNURLZmpBamtXckFwQU90bEtV?=
 =?utf-8?B?S1A3cVMrMit2TFpNWis5MStlTTlKeGE1VnBTOE1rTXZLU0QwZDl5VjBmdUVM?=
 =?utf-8?B?SFFMMGZFUHhROXNEQXRWeHZsWDU1RkkwYTFhS1lrbXIwU0M0MzZOQzc2STFH?=
 =?utf-8?B?cDM3aXdoNmtYbU1HVjQwUzBmSVcyMmx1MHN5NFd6d0I2Tlh3OEZWRi80YTFG?=
 =?utf-8?B?ak1rakNReTR1K2JrSnVURTdBV3dndUVTRVN6YnUvdnRUcjd1RCtEMWZ2UFZM?=
 =?utf-8?B?Y3RiQlhoWjYwSG43dWZoek4rVGRPMndvRnljUzlhd3dNN2RSNXVkWmQxYnZG?=
 =?utf-8?B?TDZhd1V0N3FWa0xmRmROM2dnRHlFVVhnazkrbXY1bS9paXVsVzJId280TkpH?=
 =?utf-8?B?ZUpjN3dKMUN5ZzRFNlNYa0ZpV014UEt4b2dsZWk2bUpEazVJYTRXWE54N1Zj?=
 =?utf-8?B?WDZOKy9IdkF3VjYzcGoyN3VldWVoQUF3Mmx6OG1MTktubmdoZjBlMnhHL25Z?=
 =?utf-8?B?cm0zNXBXV2R1c0lJelpIUUFOTFZYVXg2K003TlFqRG8yYXd3OUk3a2J3ckFp?=
 =?utf-8?B?dU5QZ3VjQnJYUU5NbTl1cjZsTVVuVW1jeUZ4cXZTaEdLZkpxNG1nZWg0bEI3?=
 =?utf-8?B?WG4wN2NuMk1WTTRmT2drc2dCYnRxL2h0d1czaWJUbGg4MVVVdTZLUThJSmQx?=
 =?utf-8?B?Q3NsYU9GVXBTZ0l0bXFTT0dOY2RvQk5jajRrRGZ6S05nOW4zQ3g5TVk5cktw?=
 =?utf-8?B?R2hBdXc0bGhJZEZ1QzZOUjRUdDBJR21LM3h4bnN2YXBsOG5nRXh0WXA0WVZ0?=
 =?utf-8?B?b3QxZVgxNUhPVk1qK3BzUjE2WEhGOXNGZjR2NnEwMXBpUzBWU0JkUktINGRt?=
 =?utf-8?B?U2xjVHZFQlBVa28vNGpsU08xS1BkZVRsTnVoMGxmaDQrMEdMdzU4cmZFdkZo?=
 =?utf-8?B?dEZsc1RUMnRBdFBrdkxzL1BNMFhtU3RKTFNxdDZRRHNpZloxd3ZXbWlVclZO?=
 =?utf-8?B?SEVKa3FtV3FHeG5RMW9ERTg4RFhlNVJ1Y1B6MDRpQzZ1QldNakhra1gwRDNi?=
 =?utf-8?B?a1JoeGtBR1pMNVhlOXN4ODFPS0QyeWVQRVc1MnczZkM4MUZKanJJZHB0WUhD?=
 =?utf-8?B?cllOVmR3Qy9FVndvVitFVDRBVXJPa1RIN2p2eW9TdktmbVUzMlpsZndLMkVM?=
 =?utf-8?B?cmdTRGhqdnk4MXYwNlFDaUdRS2gxazhqSHBDSGMzdG8vWlBCUHVXRU11OUht?=
 =?utf-8?B?Uk0rZWpQOU5kQXVHbWJiM3YxbHpyeTROYlIwUi9YSVZnQTlSTFFWWVNVc3VR?=
 =?utf-8?B?cm9xZkhFTHBDWitHaUxEeDlTOFd5U2F5KzdWMHdlSERVZkpOWFZOakdKS1Jn?=
 =?utf-8?B?MFpQN2xURUp6OWthNkpwRW85MkNVTE03WHFGN1REaWR0KzRhUzlNTWUzTmx5?=
 =?utf-8?B?VWRwWlhaOVNYMS9IUEZla2Yrc3VsL3B1RlNKZmNDMk45TE56cGZPTHdVVGFQ?=
 =?utf-8?B?czJMb3ZoTGc1OTcwSCtSL3RwbEJxK2xLT2t3MlVRSG5HWnEzQ1RVVERXMHFV?=
 =?utf-8?B?cTVsTjBhSkY4c2dYaUNFbkdDcWpaY2Z5algvWG1UUWoyRVNyRlIwM2JETFF6?=
 =?utf-8?B?QTFmQWtqa3g5bWJzR2dxQjgyMUk1b083bzlCK0xIMVhJcmt2VXhkR3lBZ0VF?=
 =?utf-8?B?b3AvbGt5eHJXSUoyOHlGRFRLSXJBdFhxK3ZsUVIvUlVMN3FQaDZScURPTUpj?=
 =?utf-8?B?SnpsZjU5b0l6NlRkdytWTk9wN0g2QTNLY0lKUHpFdDZROEtEWE9LTEZVRW8w?=
 =?utf-8?B?VllDMUMvbzBoa2VOREFZS3BLcXlNN3RvdFRaWFdsdVlhMWxUV1ZxOXNkbXAy?=
 =?utf-8?B?Z0FIeGI0a3ZDZUNKMzExWTdhLzlVeGZGL0Z5eTBoeFhhNkZXSitmbGV5UEJV?=
 =?utf-8?B?aklMSXd2T3lhSDNhMlEzem56ZFFuNUt1V1pEZmdWa0xLNFhvWW9wcHMwVGI0?=
 =?utf-8?B?VGJPZUVXWWlZUTZmQnNETFVxM25MT2pEeHFoaG94RE1IS3BoRGdNZ0MyQ2hC?=
 =?utf-8?B?S1gvcnc0bXNpWlJzNTViU1RxT1dLU002VklvQ2xRUGtsdSs5b09NR1ZVU1I4?=
 =?utf-8?B?VkNPb3hZeXA1dmVWTEtJMUxZcldpdlREVERUTTlrV0NxaldlSkFJQmxpdTB2?=
 =?utf-8?B?TkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99D3CE41A5C6244A99664F9C1F674BB7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 576f6365-03ac-4be6-0a36-08dadd5fd994
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 23:14:56.8179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CIpzMe+GbXQO3YQLAzTkGRet/kffOtdDkogCNC3YcntJB1752D/O601pI1qHXYa+Eo20x5AZcGpN1yID+D0ETUOSAu7Bgu59OeWMn1+q9ts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4596
X-OriginatorOrg: intel.com

QWxzbyBzL2N4bC9DWEwvT24gV2VkLCAyMDIyLTA5LTIxIGF0IDE0OjAyIC0wNzAwLCBEYXZlIEpp
YW5nIHdyb3RlOgoKPiBTdWJqZWN0OiBbUEFUQ0ggMy80XSBuZGN0bC9saWJuZGN0bDogQWRkIHJl
dHJpZXZpbmcgb2YgdW5pcXVlX2lkIGZvciBjeGwgbWVtIGRldgoKIkFsbG93IHJldHJpZXZpbmci
IG9yIGp1c3QgIlJldHJpZXZlIHVuaXF1ZV9pZCBmb3IuLiIKCj4gV2l0aCBidXNfcHJlZml4LCBy
ZXRyaWV2ZSB0aGUgdW5pcXVlX2lkIG9mIGN4bCBtZW0gZGV2aWNlLiBUaGlzIHdpbGwKPiBhbGxv
dyBzZWxlY3RpbmcgYSBzcGVjaWZpYyBjeGwgbWVtIGRldmljZSBmb3IgdGhlIHNlY3VyaXR5IHRl
c3QgY29kZS4KCkFsc28gcy9jeGwvQ1hMLwoKPiAKPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIEppYW5n
IDxkYXZlLmppYW5nQGludGVsLmNvbT4KPiAtLS0KPiDCoG5kY3RsL2xpYi9saWJuZGN0bC5jIHzC
oMKgIDI4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysKPiDCoDEgZmlsZSBjaGFuZ2VkLCAy
OCBpbnNlcnRpb25zKCspCj4gCj4gZGlmZiAtLWdpdCBhL25kY3RsL2xpYi9saWJuZGN0bC5jIGIv
bmRjdGwvbGliL2xpYm5kY3RsLmMKPiBpbmRleCBkMmU4MDBiYzg0MGEuLmM1NjkxNzhiOWEzYSAx
MDA2NDQKPiAtLS0gYS9uZGN0bC9saWIvbGlibmRjdGwuYwo+ICsrKyBiL25kY3RsL2xpYi9saWJu
ZGN0bC5jCj4gQEAgLTE3NDksNiArMTc0OSwzMyBAQCBORENUTF9FWFBPUlQgdm9pZCBuZGN0bF9k
aW1tX3JlZnJlc2hfZmxhZ3Moc3RydWN0IG5kY3RsX2RpbW0gKmRpbW0pCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqBwYXJzZV9wYXByX2ZsYWdzKGRpbW0sIGJ1Zik7Cj4gwqB9Cj4g
wqAKPiArc3RhdGljIGludCBwb3B1bGF0ZV9jeGxfZGltbV9hdHRyaWJ1dGVzKHN0cnVjdCBuZGN0
bF9kaW1tICpkaW1tLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBjb25zdCBjaGFyICpkaW1tX2Jh
c2UpCj4gK3sKPiArwqDCoMKgwqDCoMKgwqBpbnQgcmMgPSAwOwo+ICvCoMKgwqDCoMKgwqDCoGNo
YXIgYnVmW1NZU0ZTX0FUVFJfU0laRV07Cj4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IG5kY3RsX2N0
eCAqY3R4ID0gZGltbS0+YnVzLT5jdHg7Cj4gK8KgwqDCoMKgwqDCoMKgY2hhciAqcGF0aCA9IGNh
bGxvYygxLCBzdHJsZW4oZGltbV9iYXNlKSArIDEwMCk7Cj4gK8KgwqDCoMKgwqDCoMKgY29uc3Qg
Y2hhciAqYnVzX3ByZWZpeCA9IGRpbW0tPmJ1c19wcmVmaXg7Cj4gKwo+ICvCoMKgwqDCoMKgwqDC
oGlmICghcGF0aCkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FTk9N
RU07Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHNwcmludGYocGF0aCwgIiVzLyVzL2lkIiwgZGltbV9i
YXNlLCBidXNfcHJlZml4KTsKPiArwqDCoMKgwqDCoMKgwqBpZiAoc3lzZnNfcmVhZF9hdHRyKGN0
eCwgcGF0aCwgYnVmKSA9PSAwKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRp
bW0tPnVuaXF1ZV9pZCA9IHN0cmR1cChidWYpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBpZiAoIWRpbW0tPnVuaXF1ZV9pZCkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgcmMgPSAtRU5PTUVNOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBlcnJfcmVhZDsKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgfQo+ICvCoMKgwqDCoMKgwqDCoH0KPiArCj4gKyBlcnJfcmVhZDoK
PiArCj4gK8KgwqDCoMKgwqDCoMKgZnJlZShwYXRoKTsKPiArwqDCoMKgwqDCoMKgwqByZXR1cm4g
cmM7Cj4gK30KPiArCj4gwqBzdGF0aWMgaW50IHBvcHVsYXRlX2RpbW1fYXR0cmlidXRlcyhzdHJ1
Y3QgbmRjdGxfZGltbSAqZGltbSwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnN0IGNoYXIgKmRpbW1fYmFz
ZSkKPiDCoHsKPiBAQCAtMjAxOCw2ICsyMDQ1LDcgQEAgc3RhdGljIHZvaWQgKmFkZF9kaW1tKHZv
aWQgKnBhcmVudCwgaW50IGlkLCBjb25zdCBjaGFyICpkaW1tX2Jhc2UpCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmMgPSAtRU5PTUVNOwo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0Owo+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByYyA9IHBvcHVsYXRlX2N4bF9kaW1tX2F0dHJpYnV0ZXMoZGltbSwgZGltbV9iYXNl
KTsKPiDCoMKgwqDCoMKgwqDCoMKgfQo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGlmIChyYyA9PSAt
RU5PREVWKSB7Cj4gCj4gCgo=
