Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F512C81
	for <nvdimm@lists.linux.dev>; Fri, 19 Nov 2021 20:57:06 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10173"; a="297910195"
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="297910195"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2021 12:57:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,248,1631602800"; 
   d="scan'208";a="551191443"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 19 Nov 2021 12:57:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 19 Nov 2021 12:57:05 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 19 Nov 2021 12:57:05 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 19 Nov 2021 12:57:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0r40YInB9nsxY1mcVEpmM+g+rR+6frT6jQRch1OUl0+PtPuNRJ8gxvxVJ31qJGWBvKgkJleusDcC0/2mrmsuMQdNwhCkIgCTpeO50o6icax7QE15d+zDetShIXe+ZMvd+M2TdIQkGqQXVrpLac0aHtjpHf/gXmmr2ncuegRzTg7CZmab2e/NlpwB2NSTz7DH6Md3u2fEQwlNkoPzsVbXw1+81Hw7xAYoi4IAy0rPfuESN8NEoIeW2NswM/v5I0xAeTKeCjC8YWahI2PAatVwGCFHP8JdYFIIM9djOixy5/Kz0b4XYxjnMbF+eFjL2mS4CF3EAib754rO9m8/4g8Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXC7SYaVjyH8wHniM2AzWON+HcTm+uCdbPcZURIcQ/A=;
 b=hXwTIdLmlyMdIopAdfMMG9jIOfjQHkj8vhZIjvfoKPwEitUoEHoVgswxrAiPDPtc2Rp4UA2ouuMQZzGATn0gHdQVm6E+D3uP2Uhbv/d2E7xhU7zVnmqe9gJABB6OaxZqxPgg+UZEW6VK+8DG5LeHN8NX4M7iyAATE6oTcc7RrxibkE+kasiI56kfh6ZqC4aGD2Yq12C5hDVLB2Gxm12Q7grSnPgd76+PSJa2mCju1MrzSzDMfYGjdjvJ8W+TF8q6PjA2mlLxJfJspW2UC3ENk+Kmymmtq6szIMeqHvDC7SK05HTSPU50jZx5AW0Pl6jD9kPFtBV55s5gQpuTlMtPeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXC7SYaVjyH8wHniM2AzWON+HcTm+uCdbPcZURIcQ/A=;
 b=WM8vWV4fSlnHcLQ5q3ib0ti1ZAjJ5B3EKjK7PhbUlAVaGtWA4NT+1ZF2LG5yZk0mXb5FDQDUSNhnJZKdbWKI33faad0ZCWkKyr4XTuyaoNvgG/FtVyIvOezOnmTGtb06uUf1FZBFGDNLLjZatXK8h78fwhNhbp5yaDNWFUJqR1k=
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by MN2PR11MB4693.namprd11.prod.outlook.com (2603:10b6:208:261::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25; Fri, 19 Nov
 2021 20:57:04 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::d8a5:47b2:8750:11df%7]) with mapi id 15.20.4690.029; Fri, 19 Nov 2021
 20:57:03 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "Hu, Fenghua"
	<fenghua.hu@intel.com>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
Subject: Re: [ndctl PATCH 0/7] Policy based reconfiguration for daxctl
Thread-Topic: [ndctl PATCH 0/7] Policy based reconfiguration for daxctl
Thread-Index: AQHXnkdPuYe9olEtCUCXR5X/iEyP5KunU1+AgGSAEgA=
Date: Fri, 19 Nov 2021 20:57:03 +0000
Message-ID: <12c8ad6454965f5f901bfda869135d919ca420ea.camel@intel.com>
References: <20210831090459.2306727-1-vishal.l.verma@intel.com>
	 <CAPcyv4jGs9t6zKdzOJL1watQ7RvC0qdbT=jB2Cn948iM+0eLQw@mail.gmail.com>
In-Reply-To: <CAPcyv4jGs9t6zKdzOJL1watQ7RvC0qdbT=jB2Cn948iM+0eLQw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba1e542c-ed5a-4110-a3c1-08d9ab9f23d7
x-ms-traffictypediagnostic: MN2PR11MB4693:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MN2PR11MB469312D70CD03D30DB9864FDC79C9@MN2PR11MB4693.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YaxHOeVaUtmXz9QyxWKWmH3favdTHHqgTuwNAOe/uxtVlIji5i8Wo+cwNqSM8YdNB83mamGH/Pfkogg2fS8p2zkLnhuPAl39sTA60rahCxrmhFOxRAsun0q8yymvoKUUAPILYGpathn79fOxpA4xDU4o+esLLbwMyjlu3YGrNCVkbk0w7zjFLpFqxjPNlbyCBgTT5p9gWOWylca3Dn5gxtLM1xoNpif4OhONJarDy+Y5pP35pcQ83aT5q81XrnFaw3DXHJESDOxV/QGGXd7DVpRe+Oj+xTuBlQtMC0Aja/F/8OwAHkZtzEu6EBfsCB1F5VdYd1jLC75ZiuvAFXpjmahO0xvxwgqxNIvfmaGiOTaI+qztMfDTmLsw7bVWQU9TnQYbMA3UG5YWH/3s57yFgXnUxrpSlG5110aK8bEKeXgfS/kpN9PPu89Y9srri21wia56aerR+O7GYk01bfepfAMT3IZ+oJVO6VpA9ak41TJewpRFOmdGMKDhNltaA0ITrOXXRCvKPK9Ery5+YO4J77VoaHJUfYoMBVgLrLGpPtWCpM+UZX83ftgpb4UixglPrrY0LzfBc8otwQ98mG/cTK9u+gB+im9ZtV0KXoAgXJ3FiXOFskkYkeLkfFmf8yOg7AuPtMKBRWqDWClrc/vLThD8yka7NtQe+0liJRPEIxRYouDSXBGtD33MW7Z8dTQSInmV3+t27s1a94DV20MILQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(36756003)(38070700005)(122000001)(82960400001)(6862004)(38100700002)(66556008)(8676002)(4326008)(71200400001)(54906003)(316002)(6636002)(5660300002)(6512007)(508600001)(6506007)(2906002)(186003)(26005)(76116006)(66946007)(86362001)(37006003)(83380400001)(8936002)(91956017)(64756008)(53546011)(66476007)(6486002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWpGRS9MM0dBYWsvaDl1bUVEQm1jaGR2VUZtSEtZQUs0OWtsM0p3bU1NQ09C?=
 =?utf-8?B?bUJFZnUyMVEvK1NHdExyQ2wxUTUyK0hrWndkNCtEcFhyS1NFemc4S1ZBaHdF?=
 =?utf-8?B?OXFYRUtjZitEaFZwc1Z1VGxsYlZ3WE5NRGRDa2hPeG1MY3RjV1FNK0RXM2lL?=
 =?utf-8?B?R1hmWkxqdCtTaDJqWkt2Y1ZKV3FlWG1JZFhiMXVkemx0NUw4WDh0cjNLMFU5?=
 =?utf-8?B?c1J6OVBUTlNNUTBnWHFXMnZyRjc1TEVEaXIvZ2hkVXRmUGpld3JGb1ZwckRN?=
 =?utf-8?B?ZE1vN1Jpd1ZkeHhwK3k3RVJuN1lwRGJ4VHF1c0dZTU9MR3diaGV1T0VvdDF3?=
 =?utf-8?B?aDJ3MjAzNWR2OEMyL2hYT1psVHVYdTQzZ1Z2Q0FLNmNTM0VJTmphSk0xb3Rx?=
 =?utf-8?B?V2VuY3BvbVBOTVF0V2JRRUJsM0NEZjBwZ2ZxZUhqWTRIRHphRjI0RlpxNlQ1?=
 =?utf-8?B?cWJsUGZpVDRsWXordTU3VkdlV0dDSXFzNjdvbEhkQi9xdDhkYWVBcWsxb2E5?=
 =?utf-8?B?UFVhVHZVZm1GOEd3RmJkdFBGbWdhSkowaGtVVkYwN09MbnJqZUkxZmhEcXMy?=
 =?utf-8?B?bG9sT3c4SFE3VUxNQnlibjJwb3YyMjNvNXlQUWJsS0ZCUVFsZnNNeUU2RnYv?=
 =?utf-8?B?a1RGMUVYc2NFQTRoMk9reEdPR2gvd3B3ejVDYnB0OWdEcUQwTVIzS2dxSzdo?=
 =?utf-8?B?MlJYZFNPQ28ySlp3ZGx1ODhDUjMzTDVzNHBEbXQwQUIySFZja0N0L0MyZDFK?=
 =?utf-8?B?K0owaytaSHN4Rnh3Ynd1UXhYMHpya0Y4K2Q4QThkQ2JHY2RvTGtjbW9yQUtm?=
 =?utf-8?B?bjdBcENrVDlTWGplbmNKbGZzUVQvYXBQTzZLMkI4ZnA2WDZjT1JEd3k1eHR6?=
 =?utf-8?B?TmNHT0dOaGg4am5GWGZnU3JZaER0eWZTYTh4SVBQSkpCNExkemcxNTdmT21N?=
 =?utf-8?B?aFh0SUkzYVBLRFdXVUxKUVhFRTVhOEFmU3BOTURjZWh1S2ZIdTA1dllGeUFw?=
 =?utf-8?B?VEVRWXIzN2lweWdpbzEzeVFXRkQ0Um14LzlxT28xVGNncEdHbEFNMEFpamw4?=
 =?utf-8?B?NGF3TW4ra0FrY1EvSHp2OFk0cXFMZ2NCVVlQVE03ZDBBejBqUGpuTkFXcHZX?=
 =?utf-8?B?VTBJalYrTVpEc1FscFc5S2JDY3FhcXUyNGZScW9kRDBlemZiTkU5eGF1emhG?=
 =?utf-8?B?MXIzc24zek1IMmpBQ0JVUk1LbmJXUEhlQXRtQ1ROUUdoZHJJcW1uTXZZM0pC?=
 =?utf-8?B?VjlJdzJZVFNjZllKZGg3R01kRjRKa05UT3BRTmpzbFZEN3NiQm5URmdjcUMy?=
 =?utf-8?B?SnBDaU90TkFEalMydllvaTFuVklJYXViMG1HUlZzVHBZYmVvK05wOFhyOU84?=
 =?utf-8?B?bTNVNlBLdHQ2YTc2aTNKZEV1dDZuTXBUUzNoTngvTmFTWW5GM24waHVYSHRv?=
 =?utf-8?B?M3lmVWRkY2J1OGQweXQrc0d2eTM2Yzh4WkRjNGFLd3hTZkhLWVVuK2ltZFR1?=
 =?utf-8?B?OE5ubnBZU01mR0N5VHVxNlBGRmI5Kyt6S3NxWEJUMkhISkoyNWdsM1h1Ynk5?=
 =?utf-8?B?cDBXQTdNblBqZTVEbjFOZVFMNER2YTQ5M2F4SkVjNDZzaHRFY0orMHZlRDhz?=
 =?utf-8?B?QmpGbzZLQWhBNGZmVVc0amF0R25PTTdCU016YXFyQnBYa0p2bDRtZ3A3Qm56?=
 =?utf-8?B?N3hYSmdFUzlPaVFhajFheGtZK1orRHEwMFppWEp3S2pmc3NMOGRONFVka3Qr?=
 =?utf-8?B?ZGtxQzNzMjRuR1ZHZWFlSXBabG16U0JjSHRWK0drcFJIbnRWUXVta3lIc01w?=
 =?utf-8?B?eUE3TGxZY0dQcG9yZ2VqaGhSSkZHdWY3TTNHdnFZVmxScHdLeXNISWJ0ZHcr?=
 =?utf-8?B?UTBybm5PWDAydmhLOHV6ajBRa1NiWXdIbnFhMlpWcTVzR1V2Z0JJZVQwTUNx?=
 =?utf-8?B?MGRIaDErSHFtdW1ZZ1M2aVFEOUhZVDgvcjIrYzVQWkd0TnZYZllaMFVXWFFC?=
 =?utf-8?B?RDQ2Rlo0UWU3aXEzM1RVZ1dHS2p6a21KSGhxd2JmS3BOT2FVbUZFT29HSEJD?=
 =?utf-8?B?S0NINjVpaVpqVkxFNW54bVBvaWZnWFlQMi8xckVKVHg1YzdiU1o2ZHlxa05C?=
 =?utf-8?B?RTlzTkZFMCtSeFRiTjR0dnI2eVI3MUR6aVIzWk9WOHhVR3BxaTFSRStleVlO?=
 =?utf-8?B?aDE3UFQ3bDk3eDErR2s5VUFPSW1xbWtNNGloRlNXeno4QUczQ0pPTVhmY1ps?=
 =?utf-8?Q?qFor8qghRqPb17GZgmgpRB8yWVIMt4jWn6IgtSAOiQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <85E00865A155434F8551161ACEF9CDB8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba1e542c-ed5a-4110-a3c1-08d9ab9f23d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2021 20:57:03.7741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i/aGCG8jbE4ItVrYl58qVrQW21cmrpQhaSsgIr4xHiwyi5toScHJHYNcE0KuYUEaIH71yfDMAta2j9z9WYXHGSNo3oBn1gkkPRphosNC81g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4693
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIxLTA5LTE2IGF0IDE1OjEyIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgQXVnIDMxLCAyMDIxIGF0IDI6MDUgQU0gVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52
ZXJtYUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IFRoZXNlIHBhdGNoZXMgYWRkIHBvbGlj
eSAoY29uZmlnIGZpbGUpIHN1cHBvcnQgdG8gZGF4Y3RsLiBUaGUNCj4gPiBpbnRyb2R1Y3Rvcnkg
dXNlciBpcyBkYXhjdGwtcmVjb25maWd1cmUtZGV2aWNlLiBTeXNhZG1pbnMgbWF5IHdpc2ggdG8N
Cj4gPiB1c2UgZGF4Y3RsIGRldmljZXMgYXMgc3lzdGVtLXJhbSwgYnV0IGl0IG1heSBiZSBjdW1i
ZXJzb21lIHRvIGF1dG9tYXRlDQo+ID4gdGhlIHJlY29uZmlndXJhdGlvbiBzdGVwIGZvciBldmVy
eSBkZXZpY2UgdXBvbiBib290Lg0KPiA+IA0KPiA+IEludHJvZHVjZSBhIG5ldyBvcHRpb24gZm9y
IGRheGN0bC1yZWNvbmZpZ3VyZS1kZXZpY2UsIC0tY2hlY2stY29uZmlnLg0KPiA+IFRoaXMgaXMg
YXQgdGhlIGhlYXJ0IG9mIHBvbGljeSBiYXNlZCByZWNvbmZpZ3VyYXRpb24sIGFzIGl0IGFsbG93
cw0KPiA+IGRheGN0bCB0byBsb29rIHVwIHJlY29uZmlndXJhdGlvbiBwYXJhbWV0ZXJzIGZvciBh
IGdpdmVuIGRldmljZSBmcm9tIHRoZQ0KPiA+IGNvbmZpZyBzeXN0ZW0gaW5zdGVhZCBvZiB0aGUg
Y29tbWFuZCBsaW5lLg0KPiA+IA0KPiA+IFNvbWUgc3lzdGVtZCBhbmQgdWRldiBnbHVlIHRoZW4g
YXV0b21hdGVzIHRoaXMgZm9yIGV2ZXJ5IG5ldyBkYXggZGV2aWNlDQo+ID4gdGhhdCBzaG93cyB1
cCwgcHJvdmlkaW5nIGEgd2F5IGZvciB0aGUgYWRtaW5pc3RyYXRvciB0byBzaW1wbHkgbGlzdCBh
bGwNCj4gPiB0aGUgJ3N5c3RlbS1yYW0nIFVVSURzIGluIGEgY29uZmlnIGZpbGUsIGFuZCBub3Qg
aGF2ZSB0byB3b3JyeSBhYm91dA0KPiA+IGFueXRoaW5nIGVsc2UuDQo+ID4gDQo+ID4gQW4gZXhh
bXBsZSBjb25maWcgZmlsZSBjYW4gYmU6DQo+ID4gDQo+ID4gICAjIGNhdCAvZXRjL25kY3RsL2Rh
eGN0bC5jb25mDQo+IA0KPiBUYWtlIHRoZXNlIGNvbW1lbnRzIGFzIHByb3Zpc2lvbmFsIHVudGls
IEkgcmVhZCB0aHJvdWdoIHRoZSByZXN0LCBidXQNCj4gdGhpcyBpcyBqdXN0IGEgcmVhY3Rpb24g
dG8gdGhlIHByb3Bvc2VkIGluaSBmb3JtYXQuDQoNCkkgc29tZWhvdyBtaXNzZWQgdGhpcyBlbWFp
bCBvcmlnaW5hbGx5LCBhbmQganVzdCBzYXcgaXQgb24gbG9yZS4uDQoNCj4gPiANCj4gPiAgIFth
dXRvLW9ubGluZSB1bmlxdWVfaWRlbnRpZmllcl9mb29dDQo+IA0KPiBJIGFtIHRoaW5raW5nIHRo
aXMgc2VjdGlvbiBuYW1lIHNob3VsZCBiZSAicmVjb25maWd1cmUtZGV2aWNlDQo+IHVuaXF1ZV9p
ZGVudGlmaWVyX2ZvbyIgaWYgb25seSBiZWNhdXNlIHJlc2l6ZSBtaWdodCBhbHNvIGJlIHNvbWV0
aGluZw0KPiBzb21lb25lIHdhbnRzIHRvIGRvLCBhbmQgaWYgb3RoZXIgY29tbWFuZHMgZ2V0IGNv
bmZpZyBhdXRvbWF0aW9uIGl0DQo+IG1ha2VzIGl0IGNsZWFyZXIgd2hpY2ggY29uZmlnIHNuaXBw
ZXRzIGFwcGx5IHRvIHdoaWNoIGNvbW1hbmQuDQoNClllcCB0aGF0IG1ha2VzIHNlbnNlIC0gSSds
bCBjaGFuZ2UgdGhpcy4NCj4gDQo+ID4gICB1dWlkID0gNDhkOGU0MmMtYTJmMC00MzEyLTllNzAt
YTgzN2ZhYWZlODYyDQo+IA0KPiBJIHRoaW5rIHRoaXMgc2hvdWxkIGJlIGNhbGxlZDoNCj4gDQo+
ICJudmRpbW0udXVpZCINCj4gDQo+IC4uLm9yIHNvbWV0aGluZyBsaWtlIHRoYXQgdG8gbWFrZSBp
dCBjbGVhciB0aGlzIGRlcGVuZHMgb24gZGF4IGRldmljZXMNCj4gZW1pdHRlZCBieSBsaWJudmRp
bW0sIGFuZCBub3QgdGhvc2UgdGhhdCBjb21lIGZyb20gInNvZnQtcmVzZXJ2ZWQiDQo+IG1lbW9y
eS4gSXQgYWxzbyBoZWxwcyBkaXN0aW5ndWlzaCBpZiB3ZSBldmVyIGdldCBVVUlEcyBpbiB0aGUg
SE1BVA0KPiB3aGljaCBpcyBzb21ldGhpbmcgSSBoYXZlIGJlZW4gbWVhbmluZyB0byBwcm9wb3Nl
Lg0KDQpZZXAgbWFrZXMgc2Vuc2UsIHdpbGwgY2hhbmdlLg0KDQo+ID4gICBtb2RlID0gc3lzdGVt
LXJhbQ0KPiANCj4gSSBjYW4gc2VlIHRoaXMgYmVpbmcgIm1vZGUgPSBkZXZkYXgiIGlmIGZlYXR1
cmUgd2FzIGJlaW5nIHVzZWQgdG8NCj4gY2hhbmdlIHNpemUgb3IgYWxpZ25tZW50Lg0KDQpBZ3Jl
ZWQsIGJ1dCB0aGF0IHNob3VsZCAnanVzdCB3b3JrJyByaWdodCAtIGVzcGVjaWFsbHkgb25jZSB3
ZSByZW5hbWUNCnRoZSBzZWN0aW9uIG5hbWUgZnJvbSBhdXRvLW9ubGluZSB0byByZWNvbmZpZ3Vy
ZS1kZXZpY2UuDQoNCj4gDQo+ID4gICBvbmxpbmUgPSB0cnVlDQo+ID4gICBtb3ZhYmxlID0gZmFs
c2UNCj4gDQo+IEkgd29uZGVyIGlmIHRoZXNlIGtleXMgc2hvdWxkIGJlIHByZWZpeGVkIGJ5IHRo
ZSBtb2RlIG5hbWU6DQo+IA0KPiBzeXN0ZW0tcmFtLm9ubGluZSA9IHRydWUNCj4gc3lzdGVtLXJh
bS5tb3ZhYmxlID0gZmFsc2UNCg0KSG0sIG1heWJlLCBidXQgc2luY2UgdGhlIGNvbmZpZyBvcHRp
b25zIGZlZWQgZGlyZWN0bHkgaW50byB0aGUgY29tbWFuZHMNCnBhcmFtcywgSSBmaWd1cmVkIHdl
IGNhbiBsZXQgdGhlIGNvbW1hbmQncyBvcHRpb24gcGFyc2luZyB0aHJvdyBhbnkNCmVycm9ycyBm
b3IgaW5jb21wYXRpYmxlIG9wdGlvbnMuIE15IGhvcGUgd2FzIGZvciBjb25maWcgaWRlbnRpZmll
cnMgdG8NCi0gYXMgZmFyIGFzIHBvc3NpYmxlIC0gZXhhY3RseSBtYXRjaCBjb21tYW5kLWxpbmUg
b3B0aW9ucy4gSWYgd2UgZG8NCm1ha2UgY2hhbmdlcyBsaWtlIHRoaXMsIEkgZmVlbCBmb3IgZXZl
cnkgY29tbWFuZCB0aGF0IHN1cHBvcnRzIGNvbmZpZywNCnRoZSBtYW4gcGFnZSBpcyBhc2tpbmcg
Zm9yIGEgZGVkaWNhdGVkIGNvbmZpZyBzZWN0aW9uIGRvY3VtZW50aW5nIGV2ZXJ5DQpjb25maWcg
b3B0aW9uIGl0IHN1cHBvcnRzLiBNYXliZSB0aGlzIGlzIGEgZ29vZCBpZGVhIHJlZ2FyZGxlc3Mg
OikNCg0KPiANCj4gLi4uc28gaXQncyBhIGJpdCBtb3JlIHNlbGYgZG9jdW1lbnRpbmcgYWJvdXQg
d2hpY2ggcGFyYW1ldGVycyBhcmUNCj4gc3ViLW9wdGlvbnMsIGFuZCBkZWxpbmVhdGVzIHRoZW0g
ZnJvbSBnZW5lcmljIG9wdGlvbnMgbGlrZSBzaXplLg0KPiANCj4gPiBBbnkgZmlsZSB1bmRlciAn
L2V0Yy9uZGN0bC8nIGNhbiBiZSB1c2VkIC0gYWxsIGZpbGVzIHdpdGggYSAnLmNvbmYnIHN1ZmZp
eA0KPiA+IHdpbGwgYmUgY29uc2lkZXJlZCB3aGVuIGxvb2tpbmcgZm9yIG1hdGNoZXMuDQo+IA0K
PiBhbnkgY29uY2VybiBhYm91dCBuYW1lIGNvbGxpc2lvbnMgYmV0d2VlbiBuZGN0bCwgZGF4Y3Rs
LCBhbmQgY3hsLWNsaQ0KPiBzZWN0aW9uIG5hbWVzPw0KDQpZZXAgZ29vZCBwb2ludCwgY2hhbmdl
ZCB0aGlzIHRvIGJlIGluIC9ldGMvZGF4Y3RsLywgYW5kIGN4bC1jbGkgY2FuIGdldA0KaXRzIG93
biBkaXJlY3RvcnkgdG9vIHdoZW4gdGhlIHRpbWUgY29tZXMuDQoNCg==
