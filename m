Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282541101
	for <nvdimm@lists.linux.dev>; Wed, 22 Feb 2023 06:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677047634; x=1708583634;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4UxxlpTiLbm9Pfxemn1hmTBxJmMRCzQv4f6b9bJyCBc=;
  b=DHdNKlsteSVLjV7ggrqrhQaX9tR4b5Hs6x/W3rWy0r0kEcZ7cWrMVg7j
   Aa6H85+/dvZcJzlvS+IPE7B6jgpcQzCEy0a4N9TDrmRNbGDeLUEd3TfOi
   n2XENY60cJR0nncvz+OymYiaGystm8F86y/rhQIp6oYWJkK1qDmBmVcQl
   Tm7nS7dDLQ2FYY9UeqSljLGs0o7xhQU+VSfcpt7i8ajF4r0dDOHINDYbt
   sTWijSzeWDRSW0IiETEUfwVz6Tm/cF4FZM3xGq9AdKYV0roNbwc72s7Gy
   9GZGx2rI/nA4rWvrShocjnvYD3/ak/dPUpjEzuJMx71d0tePooGfwyjvD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="419077079"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="419077079"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 22:33:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="740696654"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="740696654"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 21 Feb 2023 22:33:53 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 22:33:52 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 22:33:52 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 22:33:52 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 22:33:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bxa9LdF7uupMTU0HmUjzOUsHldlJqHnoKf04zRqFSRIssP0QpbsiSHJcxx3+C1SOc2VLO8v6OswN1WHt2vsR1yj3AKkaLDhKkvM4kybM8BxPT38f2DpC9+fMgoJE5DeRwn9SD1U11nW9o08IchVInfXIXg3UUgKYr0HskbKqqv8JslQ2HlKek7jWMF8fFyxQ+nTmxkHcJhQQrv3sjJSdvo7laR030MKwniyD4zN7LondXb3M0bq8J1SMpjBhCq5G2XfEoSpxgspWmRTNBxPqH6p7khZWNk8BNHn6a/zRJfSHgChrtjXjqcWtxio6m6N4H8TQ7f4joY8VCY76U6X9NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4UxxlpTiLbm9Pfxemn1hmTBxJmMRCzQv4f6b9bJyCBc=;
 b=idNcedKGbmtdbuzxt8vE7lXhsucsIHhoUFSQaOfcER1hMoz1d11seduF8kNjOv/wcKaIkruO77qIpQMH7wtANTBwEn6wMgXwouTe42Sfn7J2v/Ua/xXFHz8Yq/Y91mOszj7DcXtBbyzgGMjPIn5XJkcrFXCGzX08MHLuV5yfhjg2gALqTd4Rh0xcQvwuUsE6Z7FqZY3laf5dh6Zr8aU6tDGlcc1HF27TauptaSCG7Mw4dwWTOclmjHHpMHdJ8ixUEoKeLLC6pxUxpJPI9ZY02OQonI7fannxZD4UhTBoaZ/K+dzJ7Go5saGyXwGnLRT8ZGb/sU0GZNdM/MJGcaLSfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by IA1PR11MB7812.namprd11.prod.outlook.com (2603:10b6:208:3f7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Wed, 22 Feb
 2023 06:33:50 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627%5]) with mapi id 15.20.6111.019; Wed, 22 Feb 2023
 06:33:50 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave"
	<dave.jiang@intel.com>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH ndctl 2/3] cxl/monitor: retain error code in
 monitor_event()
Thread-Topic: [PATCH ndctl 2/3] cxl/monitor: retain error code in
 monitor_event()
Thread-Index: AQHZQzGdwLMe3Uo/wECSJefjZv1jYq7aO2QAgABNdIA=
Date: Wed, 22 Feb 2023 06:33:49 +0000
Message-ID: <6b68c9f360ede90ebd724771fc938820a12e274b.camel@intel.com>
References: <20230217-coverity-fixes-v1-0-043fac896a40@intel.com>
	 <20230217-coverity-fixes-v1-2-043fac896a40@intel.com>
	 <63f57652656e8_1dd2fc294b@iweiny-mobl.notmuch>
In-Reply-To: <63f57652656e8_1dd2fc294b@iweiny-mobl.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|IA1PR11MB7812:EE_
x-ms-office365-filtering-correlation-id: 7cbd53b0-f193-4323-dbe6-08db149ec1e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wVgS5PsS+chdFTV9Yfx12BXdOQ76sthGmiQ4Jr0jc5L4dX2ieIbTdktL6i1vHIUWrMCraOHfDREsbMiSw2X1H0ptuZVidwmScHzhsgYOVbzdK9UYq+U1aK3hBCV+uCK2pxiWwSTewWB3tgyA+pAoHvwz2lxea0CUtNsRIEzT7e14QrF0fdhFLBn9k5eZog0tEoKJlHNNNq7/rREY7HwdjZEU/xEBImbVOQJ8Ib3kWa454GZyNrxDEizbuuiPZ/yv14nRAE0Up6q5Uq7jFMHLJZW7HzOCFOjj6RwEh+2QilHxIFh5O+x0hdYvhedHQRuv4aD7kE8wtmHfSSNASgeDPFrDS3hRgnRLjVZmiPYrg7V1FIMyfgMUE/N/yEySeI20A9N4PZ/uzATa4y0UxXD0/YMfqGplyETy4xmRMgAHhDT4UuKKbUQqsocLCJc3PiQ5GC2AbJyWASWuKCKHufbqFR/nCYlUsmG9NTfvORgs+c1Ru0bNBFf+rFQFtHSEutzNXTplVlmu7n/TAg2eGlfeX5wPcXa4VnS6M94CrUif5eh/FKKz9JKDYoZq+2Z0/da3PEJml8FJ4qOi4yriJHgQKwVzFlvj2dFV3PW5YOWJqvSw7WjSz1SgHtlMsf3qzWF1/U8isnBYbnU19I8rzz7NCROxxgmi7exIlqZ/iIWHIV3hPOfqvVXm0Bc9BNxsMTp9m7fR9ZhXmBoT59TAb1AZ1Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199018)(2906002)(5660300002)(8936002)(83380400001)(36756003)(26005)(6512007)(6486002)(186003)(71200400001)(6506007)(2616005)(76116006)(38100700002)(38070700005)(122000001)(86362001)(8676002)(66476007)(64756008)(478600001)(41300700001)(66946007)(82960400001)(91956017)(66446008)(110136005)(6636002)(54906003)(4326008)(316002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmpVcmFoN0VPeWdJVVdkZXNPem9SckVLZFVnSGQ5Yk1jRGh2cUJaRFIxaGdZ?=
 =?utf-8?B?VU9yOE9RZ1JEVjhLS1pGMVdYcXAwV201dDQyTXVEVEZKOFRCZWhJaWpOOGlB?=
 =?utf-8?B?aVA0WlZ1RWt0QWYxb1VqMk9ac3dtdUxvbUlVcURPdE9uc0RRc1ZNakhkYzln?=
 =?utf-8?B?U0dUcmlOa25IeVpQOG9oNDVMdTNQcVh5VC9iWVlrMFdVUnZKeE5jeFBKZkty?=
 =?utf-8?B?WGJwSzBKd2lCVHc4ZTJjdWhCTS9NY1RHMnJCay9JMGFCZDlGVVhaM0RyS0U1?=
 =?utf-8?B?MEJSbVhUUDAvTUZhZ0k4TFgrU3RwYitvTzJOaGV0bVRhSXVzTGNzK0RsK25N?=
 =?utf-8?B?aUJIR0RBUzFvYXc2RHRNU21VUTBNbDBVQ2ZjTEVIWXBDY0F0bGJiU0R3d3RK?=
 =?utf-8?B?NnJCbVRPb1pkYVJUQ21GeTRwRHFtTFZYY0ZHU1JlK25oWE5HcWplWkJESVpI?=
 =?utf-8?B?ampYbGVPbVFIRXM0YlhSMVRud0xxa3NyeTR4VW1MdndvTjhxcThTWlhxSGhw?=
 =?utf-8?B?MW1OdnBNdlRPQ2owVVdNNkNkVkR6eDZadWNwR05NclRHZzd5Qkh4NkdVbG9P?=
 =?utf-8?B?NENIejJhWGZoczZvbjdOSjNyUm8rNTEzUUVrZWFPay96Yk1JRzZTUThTUjlL?=
 =?utf-8?B?eUwrTFg5M2FibUJWb3JKQzlZc0RqRi9oQTNVT0pzQXJZUzhNTnVZTm56RCtk?=
 =?utf-8?B?Z1BoMk9tNFZNcFdRcVJMM3Nyc1pJeURnTzhGOXBPaHVJWjlhQThZaXpxTlYw?=
 =?utf-8?B?d0RDRHB6REZaZ0ozbmZQR0Z4Vm1PcENrT091YlE5SEwwTmFPMnVUc1NWQmlF?=
 =?utf-8?B?d3N6cEZrZWNHVHc4d09hLytoTG9FMzZlUGpSSndOMkF5RTlTL2ZoZlhGa3pT?=
 =?utf-8?B?WlR2RTBoc05ISnFmd3oyRHZQaGJBWTJDU2crVXoybU5ubmFpRVp0dFV6eFNM?=
 =?utf-8?B?K3I1YjFrcXhVQk5ybm1taDY2VkVMaHQ5WS9BVFV1ZlNmK2VJTUsvYzdWaEVQ?=
 =?utf-8?B?cDAzdWYwejdvU05NN2F6MDQ5a2xrbFVmUldLN3lwS3pya1ZQclNmYW84ZXBB?=
 =?utf-8?B?dzBiR1Z5cVlqMWFRcHpOTzViWDNRdE1BWWNLbXhvQjlpMUordHhYQkVOM2hW?=
 =?utf-8?B?aWFkRkx4cThYN2xrcThpY2RFd0hhaCttVnBSalhhenpaQ1FqWGVQQXI4Rmxs?=
 =?utf-8?B?eDEvM3VlMFhscWhlQVhDUzVPbWVGU3ltS3NMVVA2cEZDUzRGeklzbmg4c0RQ?=
 =?utf-8?B?SDIwVmlGY0JvNVlIa1NJWU9aVlMxV3lXQlVVMERGb25nYjU0M0ovTy90RURV?=
 =?utf-8?B?a01NQVFRVmlJNHppaG1Db1AvWmxYVEVYVi9wM01SMzVzSktpU0wxeitTM0Zs?=
 =?utf-8?B?M1I5eTNEd0pvL09USStMZWtBcWVUNCtvSGZYM01Va2luc1ppK2NBc3dIcXFi?=
 =?utf-8?B?MDU5cnZXRE1Cbzc0d0NkV0h4cTYrQUpJbFpBYXhwZTNMZkMxdUlxbEdGTlkx?=
 =?utf-8?B?OUt1UkdkYlZUREZaS3FDUmczUjAyNCtiRXJHaUFhYkYzWVNsTnR3eFZ0ZXQr?=
 =?utf-8?B?aS9pYXN5NStIRHdxbGZNNG10d3Z2TzY5RTk1bEN6b3BDNkN2MDRkbnlGWkdB?=
 =?utf-8?B?WnJEMTJzWVMzRENxelJZZnVjbzF0cWltZHIxdEE3ZlM2SmZycmtZQ3NTcGpl?=
 =?utf-8?B?TVdoT1doTXdiVng1MElnbjJQUkRQWkwxR0U1MU4rWTZpMjFYeE44RU55eVAv?=
 =?utf-8?B?NkVFSk14anZCUG82Z1lGWWVXaGJHNFZFcWFJKzhMVlNTQmE4bWRtZDduNzQ1?=
 =?utf-8?B?bnlGNEpsRkY1MHRncWJpb2RmUXZ1dlFLdGozdjlWaDc1dXd2WnBybkpSeFk1?=
 =?utf-8?B?eHkyTzNVczZQV0FPc2lwZ0cyRVVYQ1lVeHZGQVpoRmZqRkdESjVjbUFST1Bi?=
 =?utf-8?B?dmF6bFRDQkpmeG1qL0pjV3JMVEVyN3BpS2x2dmNzd3pzeWpkNEZvaXQzSi9G?=
 =?utf-8?B?dzdibHRZMUtLQnVuMjVlbjBjRHNSTlk5bjdPTlhhSW5kZW4yL1ZMdnpid2pO?=
 =?utf-8?B?cE9FZk96WHVQbmQ2Zmw3cFFFOWZEaDhiUGhSRjRzaEFYSHN1TFhWckpJQ2tZ?=
 =?utf-8?B?dmsxWHIrM2tQbjJaVTl2SUszT1RjNWV3c1kyTGIvRW5sREFpdTl3YUsvbU5W?=
 =?utf-8?B?YkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9FDBB1646B7EB840938CF5409BA4098E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cbd53b0-f193-4323-dbe6-08db149ec1e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 06:33:49.2912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JLNO8RFI+nUX6WC5vRL3T3BU50XC9HicEFryqgdouDZfKd9fPLfrgMZv4FB5hpaFf+zoq0kFM3WRsDINGOztSphI17uW+Lz/sz6L16QnOd0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7812
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTAyLTIxIGF0IDE3OjU2IC0wODAwLCBJcmEgV2Vpbnkgd3JvdGU6DQo+IFZp
c2hhbCBWZXJtYSB3cm90ZToNCj4gPiBTdGF0aWMgYW5hbHlzaXMgcmVwb3J0cyB0aGF0IHRoZSBl
cnJvciB1bndpbmRpbmcgcGF0aCBpbiBtb25pdG9yX2V2ZW50KCkNCj4gPiBvdmVyd3JpdGVzICdy
Yycgd2l0aCB0aGUgcmV0dXJuIGZyb20gY3hsX2V2ZW50X3RyYWNpbmdfZGlzYWJsZSgpLiBUaGlz
DQo+ID4gbWFza3MgdGhlIGFjdHVhbCBlcnJvciBjb2RlIGZyb20gZWl0aGVyIGVwb2xsX3dhaXQo
KSBvcg0KPiA+IGN4bF9wYXJzZV9ldmVudHMoKSB3aGljaCBpcyB0aGUgb25lIHRoYXQgc2hvdWxk
IGJlIHByb3BhZ2F0ZWQuDQo+ID4gDQo+ID4gUHJpbnQgYSBzcG90IGVycm9yIGluIGNhc2UgdGhl
cmUncyBhbiBlcnJvciB3aGlsZSBkaXNhYmxpbmcgdHJhY2luZywgYnV0DQo+ID4gb3RoZXJ3aXNl
IHJldGFpbiB0aGUgcmMgZnJvbSB0aGUgbWFpbiBib2R5IG9mIHRoZSBmdW5jdGlvbi4NCj4gPiAN
Cj4gPiBGaXhlczogMjk5ZjY5Zjk3NGE2ICgiY3hsL21vbml0b3I6IGFkZCBhIG5ldyBtb25pdG9y
IGNvbW1hbmQgZm9yIENYTCB0cmFjZSBldmVudHMiKQ0KPiA+IENjOiBEYXZlIEppYW5nIDxkYXZl
LmppYW5nQGludGVsLmNvbT4NCj4gPiBDYzogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0Bp
bnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJt
YUBpbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gwqBjeGwvbW9uaXRvci5jIHwgMyArKy0NCj4gPiDC
oDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4g
PiBkaWZmIC0tZ2l0IGEvY3hsL21vbml0b3IuYyBiL2N4bC9tb25pdG9yLmMNCj4gPiBpbmRleCAz
MWU2Zjk4Li43NDlmNDcyIDEwMDY0NA0KPiA+IC0tLSBhL2N4bC9tb25pdG9yLmMNCj4gPiArKysg
Yi9jeGwvbW9uaXRvci5jDQo+ID4gQEAgLTEzMCw3ICsxMzAsOCBAQCBzdGF0aWMgaW50IG1vbml0
b3JfZXZlbnQoc3RydWN0IGN4bF9jdHggKmN0eCkNCj4gPiDCoMKgwqDCoMKgwqDCoMKgfQ0KPiA+
IMKgDQo+ID4gwqBwYXJzZV9lcnI6DQo+ID4gLcKgwqDCoMKgwqDCoMKgcmMgPSBjeGxfZXZlbnRf
dHJhY2luZ19kaXNhYmxlKGluc3QpOw0KPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChjeGxfZXZlbnRf
dHJhY2luZ19kaXNhYmxlKGluc3QpIDwgMCkNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgZXJyKCZtb25pdG9yLCAiZmFpbGVkIHRvIGRpc2FibGUgdHJhY2luZ1xuIik7DQo+IA0K
PiBJcyB0aGlzIGV2ZW4gd29ydGggcHJpbnRpbmc/wqAgUGVyaGFwcyBqdXN0IG1ha2UNCj4gY3hs
X2V2ZW50X3RyYWNpbmdfZGlzYWJsZSgpIHJldHVybiB2b2lkPw0KDQpJIHRob3VnaHQgYWJvdXQg
aXQsIGJ1dCB0aGUgdW5kZXJseWluZyB0cmFjZWZzX3RyYWNlX29mZigpIHJldHVybnMgYW4NCmlu
dCwgd2hpY2ggaXMgcHJvYmFibHkgd2h5IGN4bF9ldmVudF90cmFjaW5nX2Rpc2FibGUoKSBkb2Vz
IHRvby4gSGF2aW5nDQp0aGUgcHJpbnQgc2F0aXNmaWVzIHN0YXRpYyBhbmFseXplcnMgdGhhdCB3
ZSdyZSBjaGVja2luZyB0aGUgcmV0dXJuDQp2YWx1ZSAtIG90aGVyIHRoYW4gdGhhdCBJIGFncmVl
IGl0IGRvZXNuJ3QgYWRkIG11Y2guDQoNCj4gDQo+IEVpdGhlciB3YXk6DQo+IA0KPiBSZXZpZXdl
ZC1ieTogSXJhIFdlaW55IDxpcmEud2VpbnlAaW50ZWwuY29tPg0KDQpUaGFua3MgSXJhIQ0KDQo+
IA0KPiA+IMKgZXZlbnRfZW5fZXJyOg0KPiA+IMKgZXBvbGxfY3RsX2VycjoNCj4gPiDCoMKgwqDC
oMKgwqDCoMKgY2xvc2UoZmQpOw0KPiA+IA0KPiA+IC0tIA0KPiA+IDIuMzkuMQ0KPiA+IA0KPiA+
IA0KPiANCj4gDQoNCg==
