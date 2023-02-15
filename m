Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6315C195
	for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 00:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676421408; x=1707957408;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DhVqPyjoIHnkIlypaFy1++RNffxophYPa2GV2nnbLro=;
  b=l5cT30r5GKQWQApRh844f850s3xEMRCqFYCfPbE1k0W/Gg6W0OUjm3EV
   QoOMiGtCV3F+FWmoDlqvAdCQ9o8CXqUBRSqGbst1+PzNOIqLuExcqoSpQ
   QkGuxDSz9vZmkzmE20ez0KCQvVm5+pakFI0efNllX8eHr891TEFvK2t6W
   dWje0+8XSV/I5VAH0ZRWL4Zob09iHeMXh0F0O8LA0VlyK/mtBBKbVQDGE
   Stp+b+0RWEbz/jaSh6z0v9cMTMdXxhd1v+5eDXa2JOircGoelLB4YoTEY
   2cSd/6uSmYHgzAe8Q5+Vi4ma9k39g3mFzhltyThBieatTKRUEgNw/noq9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="393710919"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="393710919"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 16:36:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="669402782"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="669402782"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 14 Feb 2023 16:36:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 16:36:39 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 16:36:39 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 16:36:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WKm0HRBdqJku3m7iFPpsLESkYW29PZb3CoFNo2Y6KzuSqpITJeOB9I9gRIuIoDpmdFLAnQwr/UY2zwYxMwit2c+bARX+MGrSYgF8+2XD/VhXjnPTXU4A9qBODfem2/EbmxdVcySiCRe6GDlTYrt8lOuEp0J1bXLeio3ljcUhIqCE9XA0w2fF7TbCAoSdcZF3KOZd3TL+ro4oUq4qfd0O80+ihb4Tg9GUkhmpNRRSTqAKNW9lhvj7pbFeLSbdRfzcg11R3fVgz+X9M3XCIPlwBf2OxxWVb3emAF2NlyoxPzwRbpH77b0j1v/GUUJisKFmOfQWgr0ALfPtDevHUl+4JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhVqPyjoIHnkIlypaFy1++RNffxophYPa2GV2nnbLro=;
 b=T3RdbyCWDiGBfr+L/9Y+/7qdadcJBBMCuNxowT80+wjLFnEQZnkphimEkXX3rm7hpb7tceP4i/wGKqnSuwfwosYPmIhKAlSpJduXfQgQPa897yrcYqJcU/mV2UlP8SfEjvXlaNBAIZlGb2pD/UQjyWGDb3lIaQBDV3OLrEhCmOtbCwahjLltU8gfptGz30q7YE7YGWLBV+vElkOyKLnq/MdtQDEbWu1tygD5oFLROPCnKitywyqY3G6ITOSsijp1OC0Gmp6+B9exF2ol+3WdJMQYRQOoFRJcXc1jnrMA3uVSJCgVkTND45YNIgopTKDmI7a3LkA+ZZacsxMIdmfoCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by CH0PR11MB5443.namprd11.prod.outlook.com (2603:10b6:610:d2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 00:36:37 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627%5]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 00:36:36 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "a.manzanares@samsung.com"
	<a.manzanares@samsung.com>
CC: "fan.ni@samsung.com" <fan.ni@samsung.com>, "dave@stgolabs.net"
	<dave@stgolabs.net>
Subject: Re: [ndctl PATCH] daxctl: Skip over memory failure node status
Thread-Topic: [ndctl PATCH] daxctl: Skip over memory failure node status
Thread-Index: AQHZP/OehnE/B2wTYkm5lOWEJwqLy67PKzaA
Date: Wed, 15 Feb 2023 00:36:36 +0000
Message-ID: <63e11faf0aee21a68be130bb1cf2573837f07422.camel@intel.com>
References: <CGME20230213213916uscas1p2ee91a53c14ec5ddcb31322212af6cdaa@uscas1p2.samsung.com>
	 <20230213213853.436788-1-a.manzanares@samsung.com>
In-Reply-To: <20230213213853.436788-1-a.manzanares@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|CH0PR11MB5443:EE_
x-ms-office365-filtering-correlation-id: a877ab63-d5fb-43e1-202a-08db0eecb23e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RvIMMJ9lRNgjD0auZCnlLZ7ic0NKxnXQp83RCHYgc0UxopewcBHX057sk5mrQwA1DQACDdjw1Kqiv3qCTuVQc4os7nnVERYwexU1yQnf6auOo8SeD7/k7Cqg2TqTavGg8Pbe2gCRZJskO7LN9dUDyBTxdiSKkheYfqG3396GlcEd4kQBh1af4hX4z8RsEuSKLz9GXM4YSGYVBMSueZkHaLgjAwv2YsplYFM8xwCe4RJHUXsdO3u0OMc9AlW/VODePVeyeoGWun+D8VD9FF8eH+pVj+UUuJyfz7GqUjaY2iI6O0ZcxHosETnh5TS/vkiRwkN1C02WFMt1E8bmIJZFYvWJd82ILl1As2UHC+PxIorLPerWlC47irBObuvSlqSyfj/UW9f/5Zub05mGeXxnCi6R4P1EY/JPElB1W2ADBZw0ga4+xqqxeVz3hMPnK3VZBpt8sgate6uYgr8jgtSHhn2k6UebQPxXB4L8H3rglPbFwhNx6fl74pQQuoI63MnWmvuYpwlORbx1LwjdvNjbYLjAdseDXGIpPJ+q9cVF3Ln6XulP6qkayKJ9R1senQp+KnKXoomxaWJrTnDn0Y4wkE1LX4GAX8LJs7arVGdLwgxU4mqAj7kDiKq7+ciEU6FS54+k1xTVRMuqLXrdC8DZguecpsbVEmtUbZB2nFoIFP3kz+8kBlLD3x/m4PC7GoeO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(39860400002)(396003)(346002)(451199018)(6512007)(82960400001)(38100700002)(122000001)(83380400001)(76116006)(8936002)(91956017)(66446008)(66946007)(4326008)(5660300002)(41300700001)(8676002)(2906002)(66556008)(66476007)(71200400001)(64756008)(6486002)(6506007)(36756003)(26005)(186003)(2616005)(478600001)(316002)(38070700005)(86362001)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2p1WndsbmtvM1A4eXNlaEVhQzdJSlREQk1vOGRoS3I3c0FJejZKREZ2amlI?=
 =?utf-8?B?VFlYRzAwVGswMXlEUkxzaW84MTlQYlpPbFRxbWlaaVI1RDdRVmFxSUdnWEd4?=
 =?utf-8?B?M3plbENZWFA2bVBCR05FTDl5dUFUdmlyZkFBaFgxdnd2TVlka1hNM1hsNTNZ?=
 =?utf-8?B?MmsrQW9UazJJVXVHWHZ1Vk9MdWJYTEtzcTZSbHR4QWsvRUtrUUpCQitRaVdU?=
 =?utf-8?B?bHRMMWtFUEY1Zi85Q2tPUm5nYVE4MmpJZHBuWngyTTJkMldnbXhGWmJrRVRL?=
 =?utf-8?B?RklCd3FCU3pzTkxFQlVtaWtMa3pkMzVCU2JrdmgwMzNhR25hN081eThxWUVL?=
 =?utf-8?B?cllzOGlERjYvdW9SdUs4RXNDZmQzR0x2U0dhNzNmRXYwcU5RZ2xqL3dBTjhh?=
 =?utf-8?B?MlVJVm9kZzI3TW1CVHVmdU0vK0ZsRUF5YWxHZFJtdFVEMEEwUXN5LzVwVkNV?=
 =?utf-8?B?dHU4TzR0Y3ZTb2lzbGN0eWE3RVAyUFlWbXdBdGplNHV6dmcwNkI5T1lhaWJx?=
 =?utf-8?B?d0xNWDJKWkVBTDVtVUNUK3ZqZ1FrY1FOM0I0a0l3RFg3NFpOZ2lVaXI3UE4r?=
 =?utf-8?B?SnhWMVJMc3QwUC9NQm92eG13WmN0UmRjRHFvM0wwZ3pxa3hKeHcwdlNVKzNY?=
 =?utf-8?B?YitGN1M1K0crTXZOeUQ0Mk5FaDdYb1BsTm1haC9sT25LM1BueDR0eW5FWXRF?=
 =?utf-8?B?eTZVUVhVdjc2NnoxM0hPWjdzL05EM0tEdjE3WGwyR0VhUHB0WWdPMS9yRXlq?=
 =?utf-8?B?NDR6aW1teW1HcFR5TkFBTk1vdmx4bTE4S1NOMVpVaVdVQ3QwZzJ5elo2YVRF?=
 =?utf-8?B?RHZSSlh3d3ozSWx3WGFIMHNuWjZnYy9odVZhVUhhNkRIVkF5b1hJZG5yU0JO?=
 =?utf-8?B?Uk1OWWN0Yk1rR2l0aHN4NGdvV1dvckg4VmtJWk5ud0FLeTlrY21ibXpJdUto?=
 =?utf-8?B?SWVEY1k1TjI3cVBhZUFZdFFCYi9uV3N6enhtNGN4VTZ6ekxPNmZ3SjBaVURS?=
 =?utf-8?B?bkUwREpXeXhYUTZZZS91c0Y3UWpuc3FTRllGWEF5d0VsRmdOVmhoTU5VU1E5?=
 =?utf-8?B?dTBqRnd3eHFRQ2hYcFVSeFpoUjZTQkdFaVZaYUh1OGRMTzNGK3V2WWFmVmcy?=
 =?utf-8?B?RGJNZ0pXVGFyOStlZndWTmtQNlJZVllLUjJrcUdWR3RqN1h6OGdMVW9RN2pL?=
 =?utf-8?B?RHQ3WGlmaExWK2lIc0Rjcmk2c0VsaUVpNUJLNGgxMmxVR0g3ODUzdjVuV2pa?=
 =?utf-8?B?YnA0OWd6YkZFSmk1NE1lYU8zOFg3QysrM3A4Z2ZwRE1ETU82VmY0NjYzY3FC?=
 =?utf-8?B?S28yeE5LTmxqSHVxUmhSdnRLQlY5Y1dFZXdSSzd6RTZZczcxdFJ4YndsVWFU?=
 =?utf-8?B?bHpUTE9HVjJuZndQOFMyNC9obTZGYlNjMjhYSGRKK2Nxa21BYXFPUUpUZ1do?=
 =?utf-8?B?aThpbWRpZW8vN3FCQzNmTE5BQm1YVnlISW1BMEl2ZmU1UExIS04vN2VMZHQ4?=
 =?utf-8?B?dU9qdFZBOFBpVG1UejBqUGxFdmFuSWhuU0FSTmhjUkVaNFQ2WWRDMks5WjJJ?=
 =?utf-8?B?NHZVUXhZbnB6R21xanprQVZrRW41NVpCbHVORWNTTXRvUjlxeG9tOHF3cXAx?=
 =?utf-8?B?aEQ1UWpLdmNXcmtzWFhZNEVKRVQ0WkNGaUtOYjlYNGZ2YXBOcHJnd0M1UlV6?=
 =?utf-8?B?cEMvK0d3SXIxNTAzd2c2ZnJWcDJDNlhFVHc3VmVWenpDeHA4YXpHMk5FTkZ2?=
 =?utf-8?B?ell4S1ArVU9UNzcvaWhOekE4RklMKy82eFF1eEtYVEtYV09WUHp5WTNaOXVJ?=
 =?utf-8?B?VzYzNHJ4SVN5R2JvZkl5L2Jodk43TmxBeXdRTzZkK1prUXdFbHY1V3JrYjV6?=
 =?utf-8?B?Um0yRzdJQjZ1emlidVliUDBSUkd2eEl5VFZWOExQY0F2UE9sYnlEbGlSQ1BX?=
 =?utf-8?B?bGtKQTJHRVJsVUpZbHNTT0Y0c095b0RQTTBPd25KSnJ5QnhXOGErZG1HaEMv?=
 =?utf-8?B?NDZEV21aTjlmYXVxcDBUZEsvWHVkV3pxVExBekh2WUFKbFcwdTlUb21rb2M2?=
 =?utf-8?B?WXRHUHpGVUJjcE1pQm01TjRmQTRIdjA4N243cnp3NEducjNRaVZwK2p2dXpn?=
 =?utf-8?B?Zkduc3ZPYlJxTHEwaUNUUHBmMlE3Ty83Y3BzaUdmVkZld2xGWmJsV2xRZGNL?=
 =?utf-8?B?V3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8BA3D4F584E20F4ABFA155FF53829DCA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a877ab63-d5fb-43e1-202a-08db0eecb23e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 00:36:36.8387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K/44GBrTf+BxvysCszVWP708Wrw5OZ+asfVZ3QeRe7M7cGtAF+Ey/TfQ2Ytu9XYq4/cScMxmlEpmI4/7/ndYXZVuXQjiaVJe+yj3cECI3eo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5443
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTAyLTEzIGF0IDIxOjM5ICswMDAwLCBBZGFtIE1hbnphbmFyZXMgd3JvdGU6
Cj4gV2hlbiB0cnlpbmcgdG8gbWF0Y2ggYSBkYXggZGV2aWNlIHRvIGEgbWVtYmxvY2sgcGh5c2lj
YWwgYWRkcmVzcwo+IG1lbWJsb2NrX2luX2RldiB3aWxsIGZhaWwgaWYgdGhlIHRoZSBwaHlzX2lu
ZGV4IHN5c2ZzIGZpbGUgZG9lcwo+IG5vdCBleGlzdCBpbiB0aGUgbWVtYmxvY2suIEN1cnJlbnRs
eSB0aGUgbWVtb3J5IGZhaWx1cmUgZGlyZWN0b3J5Cj4gYXNzb2NpYXRlZCB3aXRoIGEgbm9kZSBp
cyBjdXJyZW50bHkgaW50ZXJwcmV0ZWQgYXMgYSBtZW1ibG9jay4KPiBTa2lwIG92ZXIgdGhlIG1l
bW9yeV9mYWlsdXJlIGRpcmVjdG9yeSB3aXRoaW4gdGhlIG5vZGUgZGlyZWN0b3J5Lgo+IAo+IFNp
Z25lZC1vZmYtYnk6IEFkYW0gTWFuemFuYXJlcyA8YS5tYW56YW5hcmVzQHNhbXN1bmcuY29tPgo+
IC0tLQo+IMKgZGF4Y3RsL2xpYi9saWJkYXhjdGwuYyB8IDIgKysKPiDCoDEgZmlsZSBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKykKPiAKPiBkaWZmIC0tZ2l0IGEvZGF4Y3RsL2xpYi9saWJkYXhjdGwu
YyBiL2RheGN0bC9saWIvbGliZGF4Y3RsLmMKPiBpbmRleCBkOTkwNDc5Li5iMjdhOGFmIDEwMDY0
NAo+IC0tLSBhL2RheGN0bC9saWIvbGliZGF4Y3RsLmMKPiArKysgYi9kYXhjdGwvbGliL2xpYmRh
eGN0bC5jCj4gQEAgLTE1NTIsNiArMTU1Miw4IEBAIHN0YXRpYyBpbnQgZGF4Y3RsX21lbW9yeV9v
cChzdHJ1Y3QgZGF4Y3RsX21lbW9yeSAqbWVtLCBlbnVtIG1lbW9yeV9vcCBvcCkKPiDCoMKgwqDC
oMKgwqDCoMKgZXJybm8gPSAwOwo+IMKgwqDCoMKgwqDCoMKgwqB3aGlsZSAoKGRlID0gcmVhZGRp
cihub2RlX2RpcikpICE9IE5VTEwpIHsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGlmIChzdHJuY21wKGRlLT5kX25hbWUsICJtZW1vcnkiLCA2KSA9PSAwKSB7Cj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoc3RybmNtcChkZS0+ZF9u
YW1lLCAibWVtb3J5XyIsIDcpID09IDApCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY29udGludWU7Cj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmMgPSBtZW1ibG9ja19pbl9kZXYo
bWVtLCBkZS0+ZF9uYW1lKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBpZiAocmMgPCAwKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBnb3RvIG91dF9kaXI7CgpBcHBsaWVkLCB0
aGFua3MgQWRhbSBhbmQgRGFuIQo=
