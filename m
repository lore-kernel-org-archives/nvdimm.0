Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0B23721A0BAA8
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 11:44:13 -0700 (PDT)
Received: from G4W9122.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net
 [16.210.21.17])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g4t3426.houston.hpe.com (Postfix) with ESMTPS id 4F9F260
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 18:44:12 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 2/2] ndctl: add list --media-errors support
Date: Wed, 10 May 2017 18:43:54 +0000
Message-ID: <1494441822.30303.77.camel@hpe.com>
References: <149443923101.16024.9360569471346131929.stgit@djiang5-desk3.ch.intel.com>
 <149443929943.16024.5561881574160309534.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149443929943.16024.5561881574160309534.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <D1C701E78D13F74384A8DDE40812B89C@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "dave.jiang@intel.com" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE3LTA1LTEwIGF0IDExOjAzIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
Q1BJIE5GSVQgZW5hYmxlZCBwbGF0Zm9ybXMgcHJvdmlkZSBtZWRpYSBlcnJvcnMgYXMgYWJzb2x1
dGUgcGh5aXNjYWwNCj4gYWRkcmVzcyBvZmZzZXRzLiBBZGQgYW4gb3B0aW9uIHRvIG5kY3RsIHRv
IGRpc3BsYXkgdGhvc2UgbWVkaWEgZXJyb3JzDQo+IHRyYW5sc2F0ZWQgdG8gcmVnaW9uIGFuZCBu
YW1lc3BhY2UgZGV2aWNlIGxldmVsIG9mZnNldHMgaW4gYW4gIm5kY3RsDQo+IGxpc3QiIGxpc3Rp
bmcuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIEppYW5nIDxkYXZlLmppYW5nQGludGVsLmNv
bT4NCj4gLS0tDQo+IA0KPiB2MjogYWRkZWQgZml4IHRvIGJhZGJsb2NrcyBkaXNwbGF5IGZyb20g
VG9zaGkncyB0ZXN0aW5nIHJlc3VsdC4NCj4gdjM6IGZpeGVkIG5hbWluZyBpc3N1ZXMgZnJvbSBE
YW4ncyBjb21tZW50cy4NCj4gwqDCoMKgwqBmaXhlZCBiYWRibG9ja3MgYm91bmRhcnkgb2Zmc2V0
IGNhbGN1bGF0aW9ucyBmcm9tIFRvc2hpJ3MNCj4gdGVzdGluZy4NCg0KVGhhbmtzIGZvciB0aGUg
cXVpY2sgdXBkYXRlLiAgVGhpcyB2ZXJzaW9uIHdvcmtzIG5pY2VseSBmb3IgZGF4IGFuZA0KbWVt
b3J5IG1vZGVzLiAgSXMgdGhlcmUgcGFydGljdWxhciByZWFzb24gd2h5IGl0IGRvZXMgbm90IGxp
c3QgZXJyb3JzDQpmb3IgcmF3IGFuZCBzZWN0b3IgbW9kZXM/DQoNCi1Ub3NoaQpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGlu
ZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFp
bG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
