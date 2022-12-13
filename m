Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D8F8472
	for <nvdimm@lists.linux.dev>; Tue, 13 Dec 2022 23:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670973044; x=1702509044;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=i/LvNypDEYy1A8mZvIb2TCtXcWkmlJhyHWAtE+/rt5Q=;
  b=HnDnHibuZc26LKgck8UtPf0su6XWSeFp5jSh3vpOPII7T8VHbzbtlv82
   uIzz0WA5Ti/K+pkXjMGumD+pB0VDolUuihkN6E5oG6vEbnU0ABOTRy0s4
   d+F3nBzOdjxDLCwPHI0x4tdR+tY3dJ4mYFZU2uMBsd3FKzxKAAqcIlUwe
   uZGnmWRoqneogVnciSQw0JhOlOwRvdyA4mC6i31hRL9mNazFXL8NtNl82
   xs9ofH3M2q85GyISUNws/gbZPDER9Kfo9rGSWPVFePv51HWpZXv/+WzIo
   gnNVibtAGjr5BTXIib5a0We29q/OHueVKjLly4dFV00bKhGBkQi50e5vX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="404523306"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="404523306"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 15:10:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="679475306"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="679475306"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga008.jf.intel.com with ESMTP; 13 Dec 2022 15:10:43 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 15:10:43 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 15:10:43 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 15:10:43 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 15:10:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdlxEAwPQdkKCF8FaqgoTXDVInciYh0pqrriiScutpd7RpusjfJtiYS9jZWAmu65xqzUHArWJhGsZfyXZPVl1Rpev8hFCQ+6ovuTxZOdYXEX3/C267V16BdQxf3wkwH/YoqNXYH8cm1oPP9/Nm2ipY9MPVvyrIZCJJjEvVGx44NguFuoX9/DHpx6pPasOxTu77+yotlJXXtyCTZhRyG+Qc+NYRUoS+CFKxvpIBw1P6Bqgi4D0kMG16sSmRGNALyjyQyjJQNX+uyx5lQcUefXk2PcuBsiShULlYXL3NAWlxpQsfZ1ZXW3wSMRtUm2xWfGIQgdeCzFKdY0s3YIBqnqUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i/LvNypDEYy1A8mZvIb2TCtXcWkmlJhyHWAtE+/rt5Q=;
 b=P7xHDeds+aoX7X9IwqP+YtIlQp8QbjMdc8QdUmvGk6poxI5kZMYrD1Q1d1KeInulEKossgL4O7FQL1ZEUHs9QVhOmCTtmHYQcZRaZjcxHf5WETgS4npyhFPhOefDCG+M0aZFON21azHpet7wFke0g4y1p0ppup8R51SXuOd/0ZXCGTm3UujfP/tMpQGNKZUlqsR7BN6cVq1uum9CtDcvCFXlW2aqQMn98o16SUOv1EMf1VdHE23jFZJsGCXpLpH4XE/XDMwP8LDVyWUn62j4AQJm/sZK6boLXaK+NF4Rb6eajgYF6iMym5wtWQUt5/WC5bV+un/tyFQc1DokUx/Nvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by BN9PR11MB5355.namprd11.prod.outlook.com (2603:10b6:408:11c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 23:10:41 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::82bb:46b:3969:c919%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 23:10:41 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Jiang, Dave" <dave.jiang@intel.com>, "linux-cxl@vger.kernel.org"
	<linux-cxl@vger.kernel.org>, "nvdimm@lists.linux.dev"
	<nvdimm@lists.linux.dev>
Subject: Re: [PATCH 2/4] ndctl/libndctl: Add bus_prefix for cxl
Thread-Topic: [PATCH 2/4] ndctl/libndctl: Add bus_prefix for cxl
Thread-Index: AQHYzf2DhHGY9CukMkyM/7R86lKbca5s9D4A
Date: Tue, 13 Dec 2022 23:10:41 +0000
Message-ID: <ebfa331be4696e73f30f78f016d8da54248089e2.camel@intel.com>
References: <166379397620.433612.13099557870939895846.stgit@djiang5-desk3.ch.intel.com>
	 <166379416797.433612.11380777795382753298.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <166379416797.433612.11380777795382753298.stgit@djiang5-desk3.ch.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.2 (3.46.2-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|BN9PR11MB5355:EE_
x-ms-office365-filtering-correlation-id: d847197d-5221-4f44-58f6-08dadd5f4172
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KsDo5Cqoa9LDxcqCG8HWUzTR0M1Ll8tMdZvXKylYQr7O0w9b5GNJxkp3P/zBdwBlq+Yby+lVjvBWdkIt1X+qlt9A4ZsbWCxWi9gqjWKvKdZftKzYd6R+6AqZpILPdDlsNze8iwJGIT4wzQalHNQtz59RBo8DejE4lR+2giOHMJUHXhCAYk4J6gjyWvgP3xRASJphr+7Hse24/gC9rI4RMRMtq83cDjfeesBmqmvNCrFpnNQWVVfle7hQ3gtqHFqoYI/gR9j8eM+O8Q27bt6sil0/gdsBF/y+JNxDx3tiyA5uEzy5+oLNDkWXBtgp+wSM9LHE4CQ4aLp+A1O7P59aPcn4/+rg+HZEz2s5LEUM1BzNERjUpbnwcvjr0xEx9Oqrl8th9+xbsOPWuby1eEK6ZkjcVFwuQ6aGS2JXavZMyAoPbVNBrTmoi/2dEDGL79SFQ2G7oOJDnv9gW8jwS4zRGV5NVFdGWaE0AlpfvTXtIoJT6rrINc+HCgqOGVnUe6E1L49+Et2935EsW2bFz2z7JF/qWJHVDaIKuGlhv9S59w6LEgUg39KPKIdBKsFXH4GYpfIV7BpkF5RV8DdxCYtuXnEXpHsk0UqSu2g0OSrLLW6NbcTWhjwnQQbzvSzNZeeLbfLMMmFsmCoDK9fPl0B32Pq8m4btUBR33o8Zfi5/MN0aPKwK39A9dy4PlOO09saYsnJU/BovsGlsi2SkrRBpdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(376002)(396003)(366004)(451199015)(4744005)(38100700002)(82960400001)(6506007)(2616005)(478600001)(41300700001)(186003)(66946007)(76116006)(86362001)(6512007)(91956017)(26005)(8676002)(64756008)(66556008)(66446008)(71200400001)(38070700005)(83380400001)(66476007)(5660300002)(6486002)(8936002)(36756003)(316002)(122000001)(110136005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1VRaW4xZGRGbkErTWFjcFkzaEYwTmZkNEI3dzBuNi9yL3FIVEpRemY5YWZn?=
 =?utf-8?B?QkVmQW0vcEpQTFhOY0hOY1BCZVJob21jcktwTFpNY3VIb3FqWEJqS01PaVMr?=
 =?utf-8?B?a2YzYUNVSGU5ZGpVODRwWFdoeHk4YStReUJKWEtTQTJ6c2htQ2o5c3dCV3Jl?=
 =?utf-8?B?VDBLbytZVFNEUkFmb3JVV3k1MEd0bW9rbXBlVVlDWU40elBjWFJoVk5vT3JY?=
 =?utf-8?B?OE9vdm1LZ2ZmQmw1RDltem1FbkNrOWIxdE02LzBTcnQwUm5paXdyT3pyKzh1?=
 =?utf-8?B?cE9iU3ZzZy8raFAra01GbU9mSCtITVNsMWdseDE4TWd5QWo0VGJob0FIVVJq?=
 =?utf-8?B?UHNMeGZnL1F1dG8rRDNsWHVhbFQzSzJFbFVRSERKVVU3c1AzUER1OU5FQ05B?=
 =?utf-8?B?anYycnh2NFh2OEY1MEIvTnUybm9QK21adjlvcDFqTDFIVEg4UTh4TzdaZ3lG?=
 =?utf-8?B?cTdMOTR5bjNVQVBkUEI0YTR6U3k1ME5UcExqaWNBN3ovSm1CektmNC9sd0pT?=
 =?utf-8?B?WWJzWkRncjc4TjJXLy9QdnkrMnpjejRoUTkzWlp3RU9STm5vbFF5aWM4NnlU?=
 =?utf-8?B?N0NmYXVDNGdmejh3Q09BMUZWbHZyY3lmSU5UTnNqUjJ1OW12RHJvaUJCVnFQ?=
 =?utf-8?B?dVh3SU1jL0ZneDZmYTh4Q1pDeFl1b0IyZHg5Zk43cVUrVjJVOW1peVA1YkNa?=
 =?utf-8?B?bDJmazFWci9kNEFCRGN2NmlsRnNiQ2tzNXRPUFhLc1FiN1RDR09NNWRwUURo?=
 =?utf-8?B?dGZVME9zellPcEh2TFM3Zlo5VkkrVzVKWUo0YkZhQzBJZjN1THFGTldjZ1d6?=
 =?utf-8?B?ZWRaUml5UXM5cTE4ZGtKOUVnMzhPaEVTcVpieXBwaW0yT3E3SFo5alk5WmFP?=
 =?utf-8?B?WCtOUXZnODE3NVhrdERrL0VreDBwZG9rUXFKbVNRUzNOMkFNRkJDWS9XcHdz?=
 =?utf-8?B?b0lnM1pGSDUxVGhtaHlhR25GT1BXVkNLZlhUd2J5ejllOFEwR0dzN28xeUlv?=
 =?utf-8?B?OXpWRGNxUEdONk5VeSt4VngxV3c4S0RDRWI3VnBkS0ZQQTkrSG1XRGhrTEVx?=
 =?utf-8?B?Z2ZaVVZlMW55ZjN3S25xaG9CL1VocVdEVytlK0VOamZGNCtzNzFIUWl1TXJr?=
 =?utf-8?B?MS91aEYvZE5IUlk3MmJobm1wVUxJeGViT0RVWms3a2JwR0JWQWlYaEU0KzYy?=
 =?utf-8?B?d0NjcGZuYkVrc0tWdVFTc0g2Y1ViZHVxaEIvR3hWejhxSE5nYUZLS254NzZW?=
 =?utf-8?B?WThIWTIvYzBFL2N0V3hPYU1qZzdWZGF3dzdOSis0b2VzVVJJWlhOY1V4WDRC?=
 =?utf-8?B?dVFRZXpMTnJoL3NnYklPUmZ1K2pIdXRYaEdCQ0FtQ0pqM3pnSjhWNEZTK2ZS?=
 =?utf-8?B?U3FkNDVWbkkrMmwwdlA2cjJ1WEFvRWZiWFludFpoaU9LeHdYdk9WNFVxSVJ4?=
 =?utf-8?B?d3VNNTRsMkhJWmJoRVpic2RJeHVmL2dWWnExVkV2azNXNGRtd3FZMlBIQVpV?=
 =?utf-8?B?VDZoTWUzNFh4L2g1OEdOUWtMSWlFOSttQnJReVZHQ1lOa3QwZCt5bExvNWpX?=
 =?utf-8?B?a3lXcWwyY2x3WjU4OTJuc055OEU2N0VlRWVVNEgvOHMweVQzU0d2MUhoUkRw?=
 =?utf-8?B?QlhMbVZ5ZHVCbDNpT295WmJSZlZlYkJTV0ZpWE5wTEZHcFJSbUVKbnlFVVZT?=
 =?utf-8?B?KzRqVUpSWWkwS0FRS0RheTBBLzZKaUUyUU5TdjZ4NVpzS050VmdxakxoUk0z?=
 =?utf-8?B?bHdOUHJva0REa1laNUZQbnEzL3pibjkwOGEyTXlORkZIajFvQ2JXMWtMdE1T?=
 =?utf-8?B?aDdYbkNxTUxucnI3WjZzNmJSMWdGNVNJM1paaGhqeStobTByS3ExUHFFYXhU?=
 =?utf-8?B?em1wWWtxaElvRmNKRG5tejFTVTdoYzFPWnA1WURwWjkrMDJXQmpaZS8vM1FD?=
 =?utf-8?B?NUl1bkU3V2N6U0NzTW04RHlpYXdOeWJFcVJzOWZIZVFzcS9HYVFGUktMRTht?=
 =?utf-8?B?VUIrdm1TUHdvSFpveUVoWU9IQWdoU00xUzA4R1Q5MWpzZ21tY3RaOHJGTk9a?=
 =?utf-8?B?a2xUYW1pQmUwU1oxV1hOSkZkcDJGOVg5dWhNWUpJeVJBUEdUM3o1V20zVVRu?=
 =?utf-8?B?a3ZWZjF4VEFhcjYwRm94YXNCS3JtY1BhYTRiQ0cxdU5wUmhaU2VSZHgyQWxP?=
 =?utf-8?B?UGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <378739E06883EC4FBB83EA1BE4765668@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d847197d-5221-4f44-58f6-08dadd5f4172
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 23:10:41.5834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kH+Cf+XFZYqPO0SWHB/vkub/hSEySkWXvVsYD5IDtp6mZd5xUSuPTExntwEtO4HZaWsnKpeBnik2+6AeM69mDyAObkeVKxk9xAEiwfUmK4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5355
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDIyLTA5LTIxIGF0IDE0OjAyIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOgo+IFdp
dGggc3VwcG9ydCBvZiBiZWluZyBhYmxlIHRvIGRldGVjdCB0aGUgY3hsIGJ1cywgc2V0dXAgdGhl
IGJ1c19wcmVmaXgKPiBmb3IgY3hsIGJ1cy4KClNhbWUgY29tbWVudCBhcyBwYXRjaCAxIGFib3V0
ICdDWEwnLiBUaGlzIG1pZ2h0IGFsc28gYmUgcmV3b3JkZWQgYXM6CgpXaGVuIHRoZSAnbmRidXMn
IGlzIGJhY2tlZCBieSBDWEwsIHNldCB1cCB0aGUgYnVzX3ByZWZpeCBmb3IgdGhlIGRpbW0Kb2Jq
ZWN0IGFwcHJvcHJpYXRlbHkuCgo+IAo+IFNpZ25lZC1vZmYtYnk6IERhdmUgSmlhbmcgPGRhdmUu
amlhbmdAaW50ZWwuY29tPgo+IC0tLQo+IMKgbmRjdGwvbGliL2xpYm5kY3RsLmMgfMKgwqDCoCA2
ICsrKysrKwo+IMKgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1n
aXQgYS9uZGN0bC9saWIvbGlibmRjdGwuYyBiL25kY3RsL2xpYi9saWJuZGN0bC5jCj4gaW5kZXgg
MTA0MjJlMjRkMzhiLi5kMmU4MDBiYzg0MGEgMTAwNjQ0Cj4gLS0tIGEvbmRjdGwvbGliL2xpYm5k
Y3RsLmMKPiArKysgYi9uZGN0bC9saWIvbGlibmRjdGwuYwo+IEBAIC0yMDEyLDYgKzIwMTIsMTIg
QEAgc3RhdGljIHZvaWQgKmFkZF9kaW1tKHZvaWQgKnBhcmVudCwgaW50IGlkLAo+IGNvbnN0IGNo
YXIgKmRpbW1fYmFzZSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBnb3RvIG91dDsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJjID3CoCBhZGRfcGFwcl9kaW1tKGRpbW0s
IGRpbW1fYmFzZSk7Cj4gK8KgwqDCoMKgwqDCoMKgfSBlbHNlIGlmIChuZGN0bF9idXNfaGFzX2N4
bChidXMpKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRpbW0tPmJ1c19wcmVm
aXggPSBzdHJkdXAoImN4bCIpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAo
IWRpbW0tPmJ1c19wcmVmaXgpIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHJjID0gLUVOT01FTTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0Owo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqB9Cj4gwqDCoMKgwqDCoMKgwqDCoH0KPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqBpZiAocmMg
PT0gLUVOT0RFVikgewo+IAo+IAoK
