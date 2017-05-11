Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E95021A13493
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 14:53:07 -0700 (PDT)
Received: from G1W8106.americas.hpqcorp.net (g1w8106.austin.hp.com
 [16.193.72.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2353.austin.hpe.com (Postfix) with ESMTPS id 6D59663
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 21:53:06 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] ndctl: add list -M documentation
Date: Thu, 11 May 2017 21:52:32 +0000
Message-ID: <1494539540.30303.99.camel@hpe.com>
References: <149453390131.38698.13565665088604739422.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149453390131.38698.13565665088604739422.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <F4B899DED27D8642A2B118AC4EA23E8C@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gVGh1LCAyMDE3LTA1LTExIGF0IDEzOjE4IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
ZGRpbmcgdGhlIGxpc3QgLS1tZWRpYS1lcnJvcnMgb3B0aW9uIHRvIGRvY3VtZW50YXRpb24uDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIEppYW5nIDxkYXZlLmppYW5nQGludGVsLmNvbT4NCj4g
LS0tDQo+IMKgRG9jdW1lbnRhdGlvbi9uZGN0bC1saXN0LnR4dCB8wqDCoMKgMjkgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysNCj4gwqAxIGZpbGUgY2hhbmdlZCwgMjkgaW5zZXJ0aW9ucygr
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vbmRjdGwtbGlzdC50eHQgYi9Eb2N1
bWVudGF0aW9uL25kY3RsLQ0KPiBsaXN0LnR4dA0KPiBpbmRleCA0NDRhNmY5Li4wYWMwOGE4IDEw
MDY0NA0KPiAtLS0gYS9Eb2N1bWVudGF0aW9uL25kY3RsLWxpc3QudHh0DQo+ICsrKyBiL0RvY3Vt
ZW50YXRpb24vbmRjdGwtbGlzdC50eHQNCj4gQEAgLTE0Niw2ICsxNDYsMzUgQEAgaW5jbHVkZTo6
eGFibGUtcmVnaW9uLW9wdGlvbnMudHh0W10NCj4gwqAtLWlkbGU6Og0KPiDCoAlJbmNsdWRlIGlk
bGUgKG5vdCBlbmFibGVkKSBkZXZpY2VzIGluIHRoZSBsaXN0aW5nDQoNClRoZSBvdXRwdXQgdW5k
ZXIgRVhBTVBMRSBzaG91bGQgaGF2ZSAiYmFkYmxvY2tfY291bnQiLiAgDQrCoA0KPiArLU06Og0K
PiArLS1tZWRpYS1lcnJvcnM6Og0KPiArCUluY2x1ZGUgbWVkaWEgZXJyb3JzIChiYWRibG9ja3Mp
IGluIHRoZSBsaXN0aW5nLiANCg0KYmFkYmxvY2tfY291bnQgZG9lcyBub3QgbmVlZCAtTS4gIFNv
LCBJIHRoaW5rIHRoZSBkZXNjcmlwdGlvbiBiZWxvdw0KY291bGQgYmUgcHV0IHVuZGVyIE5PVEUg
b3Igc29tZXRoaW5nLiANCg0KPiBiYWRibG9ja3NfY291bnQNCj4gKwltYXkgY291bnQgYmxvY2tz
IHRoYXQgYXJlIG5vdCBpbiB0aGUgZGF0YSBzcGFjZSBvZiB0aGUNCj4gbmFtZXNwYWNlDQo+ICsJ
Zm9yIHNlY3RvciBtb2RlLg0KDQpUaGFua3MsDQotVG9zaGkNCg0KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApM
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlz
dGluZm8vbGludXgtbnZkaW1tCg==
