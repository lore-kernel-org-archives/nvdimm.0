Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD07C290B
	for <nvdimm@lists.linux.dev>; Fri,  3 Feb 2023 23:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675465677; x=1707001677;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qMCu58hB58TAVJYlOTqpLjpnP1xt03UW3w+q4A+xUvA=;
  b=Z4iyw9NQVerIRkfzWH/LxVQ9VqWzV0vs/zSHAdD3OEAmpPxY7mqV5Jnj
   QT/SaquRBZVeScIUddpstg8OO8LNyJiGMiYaNqstA8hoHpXpgJkif8ki9
   JzvPpH6rNizNsmwlZs+3Xk9rUQqP7+Jj8I8vzD/6baYNPToT9sb11xJhe
   P9dgBRhjmKwYvaokePNOPdHTEs01ABOYTJIGcYDEiy5/dEJtoFeTykVd2
   r+GtBrJS9yscp8/RW55Z5xO3CdslwvNwHFyKZhepw+MCrWWk5TfJIaaPg
   sYOhLrXRuASiXjcX2uwqp3Ixdz4iBJQZWcmppHfpkmkMtlMotcr1ttDaZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="316878592"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="316878592"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 15:07:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="774497081"
X-IronPort-AV: E=Sophos;i="5.97,271,1669104000"; 
   d="scan'208";a="774497081"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 03 Feb 2023 15:07:56 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 15:07:56 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 15:07:56 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 3 Feb 2023 15:07:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUkvuVhfdOvjwlvhcTyCQWw7Jq1srYS3MP2I6h/IokVu37QJE0nv0cotVjcRmhWgoUY7bEgm/h2oiFJPcXoltCzOwrwxCPjfQ4aP7Hqksst5zNrdS0SQRE/gkzESu0dB1rR4zCYLOX00lDOoUC4prWYZeF903yqoSupppV4dGdtiwZytm3S/cotB+ARPBkMPCq9yfpQExP+57PVOBQB9uz8e19Kd2K0SiZSlO1O4TIsVDT+E3YHAkJk1X4eP+2MIvDpOgW51pfGhfRJkHpo/K/0lIYN6U75so1Z8HVmCiKmOwrhYl6h1OBZYWaf1XiQDDh4sWNVj9ovsa3C5pmhF6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qMCu58hB58TAVJYlOTqpLjpnP1xt03UW3w+q4A+xUvA=;
 b=a/C7QJlrPY72Xt+gitZQMG4gwEkKrza7FsZqyVkIysL40WTzG+Qp7QYm76X1HJSNMWAJCl4AvrI29h7nJrSKjMCbHHTSSS5AP3Ti/xu82PamoACczW7AZiKeXhOyiFFF03BKFm00Jga+SB26LLrMl3LCAZpeyc/N9668IFLF20Cjxq1igEXFPkij6tWMHfbp10QCG2wiIrx3KsU17z1BHmMaYNoBLZVkdsEQNi4vC8CEHqzow2ClNPWzpzD2rlsH/ypSxpf8JyxJX7JxfTwIETyhlVBs/XhLfweFvp9G6MIDcNjs+dCQiWdGLRe5v+HrjMC+6D5FIqMhSLKLBbvYPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by SA3PR11MB7581.namprd11.prod.outlook.com (2603:10b6:806:31b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Fri, 3 Feb
 2023 23:07:54 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1ad0:a5dd:2fec:399c]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::1ad0:a5dd:2fec:399c%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 23:07:54 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [PATCH] daxctl: Fix memblock enumeration off-by-one
Thread-Topic: [PATCH] daxctl: Fix memblock enumeration off-by-one
Thread-Index: AQHZN0jh88tiB/XPR0OT594JzNQIn6692hwA
Date: Fri, 3 Feb 2023 23:07:54 +0000
Message-ID: <a892091d7275984f9878b288a01079f52d5934f7.camel@intel.com>
References: <167537140762.3268840.2926966718345830138.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167537140762.3268840.2926966718345830138.stgit@dwillia2-xfh.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|SA3PR11MB7581:EE_
x-ms-office365-filtering-correlation-id: dc49d76a-a456-4725-d3b1-08db063b7b2b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cJyTLxly4TXLSQwNPKrx0mhboM8fHhD80skuuNAG6SIBYWQnvSujhTaVy5vncUZ7+ae8joWXcsJLIyGpfQmVYyXJ+/ZQnPVJ04W8umVXqYfExSyuTeJBBbpkzXMBHyaYWZhDjLUu7rND0RH+sV94XOcVkNQlKycmGR+3/CA0eYNBGFuSaeSLA4EJn904ucvn4fmimbwXcC//qLqGSUsVwJAPmlHm/UoqgpjWF/V8dDEITm4XzLh089UsLaDT7QePyQlOL69iXSdQhIk3JZofXLIZSqSNXrMANuv89ex4DwGYTs9HZIR8yr7uGBSHw++SXq7b99Whsv/Yezsf+DT/f8epwm7Dkw2jH/foVY2P1SkBdcUrWAHdzordrSL8C7iNQ4og85B41aVbPpKlW5sWHCEj6dcyxS2K2GN8aqFK2YF1exUXBilYParrze1COviu/2c2noarb/7T+SNUl3w3zKcbOLL0DaAbqdxjZn4TPf2qf0+rcE/+5EqCpmD5NUcqnyKga/aApowg+RbYH8W8dRCVkmThwbLCkfoHoyMFXLzbhtQUpQdlOn2ocMr8p7ZE1il1eCmWURdKEtHCr/dMcrrVWQ1V7JdqTtu0ajxFFzpe1eHQOsP6Dxx3cgzv5Z+qpMlByhvU6kTs2X5O3SQvqcbhDExQJ1z6z9kYBuy+vJXhfLbnfy/sL/WHhL+8WiL/GfPxmRNNCnmOYTvw223U5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(54906003)(6636002)(37006003)(316002)(36756003)(478600001)(38100700002)(86362001)(82960400001)(122000001)(38070700005)(83380400001)(26005)(186003)(6506007)(2616005)(6512007)(8936002)(6486002)(6862004)(5660300002)(71200400001)(41300700001)(4744005)(2906002)(66446008)(64756008)(4326008)(91956017)(66476007)(66556008)(76116006)(66946007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REdDZms3Nmt2bisrSTBGMzZsOExZTm8xMzZtelVieHl2QjNVYTZkbW1XVkNT?=
 =?utf-8?B?WE9qUEt0VXU0aTA0QzluSnFRZXpjSGpTUW1NWU9HYUFwVjNBL3U0MkI2bUtD?=
 =?utf-8?B?QjlSa2NvSzNHTldvOTNLK1RPei9LNFZKQzZ5UVp6cG41V1ZpenMyOE1JWGYz?=
 =?utf-8?B?TmdxNWhDZzlLcjZTUGZ0ZkdCN1FaaENmQ2kxTlU2Vk12dVJtaGhQVzNqUHNY?=
 =?utf-8?B?dzFzT0cxbUJGNlF4RjhkYkF2ak0rZEFwQ2Z1WGZTU2lGclNWS2hLcEdFaU1j?=
 =?utf-8?B?WDU0Yys2NUpoOTFnY1Y3Qks4cXQwU05hR0FQVGZhRTZ0ZHpQTWJHNXpTVVUw?=
 =?utf-8?B?VG4zbm16M0xaZXNKYmlYaDZRNmVNK1d2ZTF5eDNrVE95K0FTZk1GSHUwMCtu?=
 =?utf-8?B?UlduMEVLNXVpZEZFVUI1S3JjbWR3ZUd1c0Q0VVNKdEJzU2xpTW00bjZ0U3l5?=
 =?utf-8?B?NmZ5Q2U0Qm1jNXpOaXN6NHF0UmZZaklRb04wck84c0JhdlhNRTJROTh2N09n?=
 =?utf-8?B?MmRGNUhNSURPRWFQaG5qVmdrWTRQYVdDVmpVYjYwV0ZJd2FhY0NkYmpXNy9Z?=
 =?utf-8?B?RXRjRHdlcjE5UDd4eHNQenBlZ2t2bGhBMitWMHBCK256UHJwWkVta0t5Ylp3?=
 =?utf-8?B?U1hBbXgxWkNuQnRjS0c3TDl5NFA4aTBrRXpLVlNVbXVQc3BWMGd3SkI5MkJM?=
 =?utf-8?B?bzlBaWV3MmZBZ0packw4L0dvMUw2dWZMUTVod0dTTTVYMHdvTUpnbkJqNkx3?=
 =?utf-8?B?TWMyT0NmeXdMUmU2dW5USm1McDU5dEZsMTRJZGNaNnh4SUlpM2RDQlhudVpB?=
 =?utf-8?B?ZnFONUFJWVpnUDQyKzF1Q1RDTkcvMkNZZU9SV3lKVUNSaXNJQ3FkVU5LMGdq?=
 =?utf-8?B?dDFlSG5vQUdGVkJ0aWNlQkc2aDByY3IxTjhIZS82N1dzNkVSbjYxZHltUjU1?=
 =?utf-8?B?azNQUTZIYWNNWllNTHNHQlBIaTUwdDNDS2llMmREOGgvL0J6MHhhNnkvUlJG?=
 =?utf-8?B?TUtmUEtvTk5KWG82YjZ0UXJ0bCthcStwbk52U001M2pjSExsd0IzaWtSelNt?=
 =?utf-8?B?Z0o5ZnUreitPaktpMGMrczlzeThna3diNEJJNU41RVpNQTY1S3oyVENYUVRq?=
 =?utf-8?B?KzlsczFDdTRwbmRmSlFtbnF0YkFPVnB0NjVKRTFVY2NxSGx3QjdOemxFMlVO?=
 =?utf-8?B?cDVHMmxaYVRYRCtSU1ViWS9NcE1hMHE5a3B5d09jaW51V1o4U281N1N4K1Ba?=
 =?utf-8?B?ZktPVXk3eld3TkwvWm00cGRqQ2VjSFNIVUVoYkhlNGdrSGtYT3pIakw1T281?=
 =?utf-8?B?K1d6TzhoYzlKcmhkTmxxVVpScVlsaWJNV1pNcG5IbXEwbXpPbXYwamEyMjdz?=
 =?utf-8?B?RXVJMEdBR1B1WUxkZGxWeDdWM2x4d1NlQW95RkZVbDU0cDNBUjdnczRmSHY1?=
 =?utf-8?B?cmc2Ym1pNWprQnlMMitNeGY3bDdXSkczYkJ4VVQzeHJzZVlzUjNGWE5xNDFk?=
 =?utf-8?B?QnYzVnJESTZWUCtzdlVxWE84bEoyOFZlc2VRQUhDRUx4Njl6YTl1WlVrKzRw?=
 =?utf-8?B?dUZES1RKdndXWDBXeUFaK29MUVlOV05KaFJwcjVPZVJ1L2hObmJmZnJUaW1P?=
 =?utf-8?B?U0YvQk5wNG0yNnUwVnJMdXMzOVZPMUVlMnFxb1oxRzUvMUduMStKQ3l0ZjB3?=
 =?utf-8?B?T3ZWSGdMdDk3b0Y3QndXU2FhNDVNME1wQVRqTzE4TlpxV3RMRDUxZzljeUhS?=
 =?utf-8?B?NFpscFVhb0ppRkVldFdMMjJhTTBoU2hQa0MrNzgxSS9pRUVJZlFMeXB3UFVs?=
 =?utf-8?B?dW5KbnZsU3RDV0VVV0pJM1ZpTjJiOUZkV2JjNDN3S1hBdTE1L0JYbFlPbTRQ?=
 =?utf-8?B?Mk1NbjVHNExXcEdtK2xvYmVZTGJhYk8vOXc5K2RJRlFJZWlmcUk2cWRUTU4y?=
 =?utf-8?B?UUFzT2hjVWxaL0w3Z20vZW9EL1RQbW9UNlpOcmIvNVpheUs0NVdVazlXc1Ev?=
 =?utf-8?B?VnMwU2FSMkhPUy83ZFBUZURHdVpjNytmRDlvTVk2MmZYVWUwNWxia2RZS1V4?=
 =?utf-8?B?NEhRVmhSb0lCbXNrQWN1RW1uNnZIRzIzL3JkNkFPMGhjY1hFQWV2VjRpUm53?=
 =?utf-8?B?UWJPK0NURnBaQXFYdUhxQUdmdndSYk1xT1RpbzZSeXJyU29qNnZuZ3o2U0lB?=
 =?utf-8?B?d2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0BADF1ECDA5148409110ADFD21AA78AB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc49d76a-a456-4725-d3b1-08db063b7b2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 23:07:54.2207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7JzXdQOETd/32aExFcDnanaIpygGoWeIYDIbzitiT5AfwJ3MvAFOW9OqrJEWGXaGQZGpQIGEeeEpigsdVNoWLNNq+MvcaBPzGAF9G0BfZlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7581
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDIzLTAyLTAyIGF0IDEyOjU2IC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEEgbWVtYmxvY2sgaXMgYW4gaW5jbHVzaXZlIG1lbW9yeSByYW5nZS4gQm91bmQgdGhlIHNlYXJj
aCBieSB0aGUgbGFzdA0KPiBhZGRyZXNzIGluIHRoZSBtZW1vcnkgYmxvY2suDQo+IA0KPiBGb3Vu
ZCBieSB3b25kZXJpbmcgd2h5IGFuIG9mZmxpbmUgMzItYmxvY2sgKGF0IDEyOE1CID09IDRHQikg
cmFuZ2Ugd2FzDQo+IHJlcG9ydGVkIGFzIDMzIGJsb2NrcyB3aXRoIG9uZSBvbmxpbmUuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4N
Cj4gLS0tDQo+IMKgZGF4Y3RsL2xpYi9saWJkYXhjdGwuYyB8wqDCoMKgIDIgKy0NCj4gwqAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCg0KR29vZCBmaW5kISBB
cHBsaWVkLCB0aGFua3MuDQoNCj4gDQo+IGRpZmYgLS1naXQgYS9kYXhjdGwvbGliL2xpYmRheGN0
bC5jIGIvZGF4Y3RsL2xpYi9saWJkYXhjdGwuYw0KPiBpbmRleCA1NzAzOTkyZjViODguLmQ5OTA0
NzlkODU4NSAxMDA2NDQNCj4gLS0tIGEvZGF4Y3RsL2xpYi9saWJkYXhjdGwuYw0KPiArKysgYi9k
YXhjdGwvbGliL2xpYmRheGN0bC5jDQo+IEBAIC0xNDc3LDcgKzE0NzcsNyBAQCBzdGF0aWMgaW50
IG1lbWJsb2NrX2luX2RldihzdHJ1Y3QgZGF4Y3RsX21lbW9yeSAqbWVtLCBjb25zdCBjaGFyICpt
ZW1ibG9jaykNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnIoY3R4LCAiJXM6
IFVuYWJsZSB0byBkZXRlcm1pbmUgcmVzb3VyY2VcbiIsIGRldm5hbWUpOw0KPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUFDQ0VTOw0KPiDCoMKgwqDCoMKgwqDCoMKg
fQ0KPiAtwqDCoMKgwqDCoMKgwqBkZXZfZW5kID0gZGV2X3N0YXJ0ICsgZGF4Y3RsX2Rldl9nZXRf
c2l6ZShkZXYpOw0KPiArwqDCoMKgwqDCoMKgwqBkZXZfZW5kID0gZGV2X3N0YXJ0ICsgZGF4Y3Rs
X2Rldl9nZXRfc2l6ZShkZXYpIC0gMTsNCj4gwqANCj4gwqDCoMKgwqDCoMKgwqDCoG1lbWJsb2Nr
X3NpemUgPSBkYXhjdGxfbWVtb3J5X2dldF9ibG9ja19zaXplKG1lbSk7DQo+IMKgwqDCoMKgwqDC
oMKgwqBpZiAoIW1lbWJsb2NrX3NpemUpIHsNCj4gDQoNCg==
