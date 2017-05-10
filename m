Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17D4921A13489
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 13:57:38 -0700 (PDT)
Received: from G4W9121.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net
 [16.210.21.16])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g4t3427.houston.hpe.com (Postfix) with ESMTPS id 43BD369
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 20:57:37 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 2/2] ndctl: add list --media-errors support
Date: Wed, 10 May 2017 20:57:33 +0000
Message-ID: <1494449841.30303.80.camel@hpe.com>
References: <149443923101.16024.9360569471346131929.stgit@djiang5-desk3.ch.intel.com>
 <149443929943.16024.5561881574160309534.stgit@djiang5-desk3.ch.intel.com>
 <1494441822.30303.77.camel@hpe.com>
 <e2873152-d765-4bcd-40c8-2f8caaa72803@intel.com>
In-Reply-To: <e2873152-d765-4bcd-40c8-2f8caaa72803@intel.com>
Content-Language: en-US
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

T24gV2VkLCAyMDE3LTA1LTEwIGF0IDEyOjU2IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiAN
Cj4gT24gMDUvMTAvMjAxNyAxMTo0MyBBTSwgS2FuaSwgVG9zaGltaXRzdSB3cm90ZToNCj4gPiBP
biBXZWQsIDIwMTctMDUtMTAgYXQgMTE6MDMgLTA3MDAsIERhdmUgSmlhbmcgd3JvdGU6DQo+ID4g
PiBBQ1BJIE5GSVQgZW5hYmxlZCBwbGF0Zm9ybXMgcHJvdmlkZSBtZWRpYSBlcnJvcnMgYXMgYWJz
b2x1dGUNCj4gPiA+IHBoeWlzY2FsDQo+ID4gPiBhZGRyZXNzIG9mZnNldHMuIEFkZCBhbiBvcHRp
b24gdG8gbmRjdGwgdG8gZGlzcGxheSB0aG9zZSBtZWRpYQ0KPiA+ID4gZXJyb3JzDQo+ID4gPiB0
cmFubHNhdGVkIHRvIHJlZ2lvbiBhbmQgbmFtZXNwYWNlIGRldmljZSBsZXZlbCBvZmZzZXRzIGlu
IGFuDQo+ID4gPiAibmRjdGwNCj4gPiA+IGxpc3QiIGxpc3RpbmcuDQo+ID4gPiANCj4gPiA+IFNp
Z25lZC1vZmYtYnk6IERhdmUgSmlhbmcgPGRhdmUuamlhbmdAaW50ZWwuY29tPg0KPiA+ID4gLS0t
DQo+ID4gPiANCj4gPiA+IHYyOiBhZGRlZCBmaXggdG8gYmFkYmxvY2tzIGRpc3BsYXkgZnJvbSBU
b3NoaSdzIHRlc3RpbmcgcmVzdWx0Lg0KPiA+ID4gdjM6IGZpeGVkIG5hbWluZyBpc3N1ZXMgZnJv
bSBEYW4ncyBjb21tZW50cy4NCj4gPiA+IMKgwqDCoMKgZml4ZWQgYmFkYmxvY2tzIGJvdW5kYXJ5
IG9mZnNldCBjYWxjdWxhdGlvbnMgZnJvbSBUb3NoaSdzDQo+ID4gPiB0ZXN0aW5nLg0KPiA+IA0K
PiA+IFRoYW5rcyBmb3IgdGhlIHF1aWNrIHVwZGF0ZS7CoMKgVGhpcyB2ZXJzaW9uIHdvcmtzIG5p
Y2VseSBmb3IgZGF4IGFuZA0KPiA+IG1lbW9yeSBtb2Rlcy7CoMKgSXMgdGhlcmUgcGFydGljdWxh
ciByZWFzb24gd2h5IGl0IGRvZXMgbm90IGxpc3QNCj4gPiBlcnJvcnMgZm9yIHJhdyBhbmQgc2Vj
dG9yIG1vZGVzPw0KPiANCj4gU28gaXQgc2hvdWxkIHdvcmsgZm9yIHJhdyBBRkFJQ1QuIERhbiBz
YWlkIHRoZSBCVFQgb25lcyBkb24ndCBtYWtlDQo+IHNlbnNlIGJlY2F1c2UgdGhlIG5hbWVzcGFj
ZSByZWxhdGl2ZSBvZmZzZXQgaXMgZHluYW1pYy4NCj4gDQo+IA0KPiAjIC4vbmRjdGwvbmRjdGwg
bGlzdCAtTk0NCj4gWw0KPiDCoCB7DQo+IMKgwqDCoMKgImRldiI6Im5hbWVzcGFjZTUuMCIsDQo+
IMKgwqDCoMKgIm1vZGUiOiJyYXciLA0KPiDCoMKgwqDCoCJzaXplIjozMzU1NDQzMiwNCj4gwqDC
oMKgwqAidXVpZCI6ImJiMzUzOWRkLTA2NWMtNDFiZC04YmNjLWRjM2JiYzMzMTdhNSIsDQo+IMKg
wqDCoMKgImJhZGJsb2NrcyI6Ww0KPiDCoMKgwqDCoMKgwqB7DQo+IMKgwqDCoMKgwqDCoMKgwqAi
b2Zmc2V0Ijo0LA0KPiDCoMKgwqDCoMKgwqDCoMKgImxlbmd0aCI6MQ0KPiDCoMKgwqDCoMKgwqB9
LA0KPiDCoMKgwqDCoMKgwqB7DQo+IMKgwqDCoMKgwqDCoMKgwqAib2Zmc2V0IjozMjc2OCwNCj4g
wqDCoMKgwqDCoMKgwqDCoCJsZW5ndGgiOjgNCj4gwqDCoMKgwqDCoMKgfSwNCj4gwqDCoMKgwqDC
oMKgew0KPiDCoMKgwqDCoMKgwqDCoMKgIm9mZnNldCI6NjU1MjgsDQo+IMKgwqDCoMKgwqDCoMKg
wqAibGVuZ3RoIjo4DQo+IMKgwqDCoMKgwqDCoH0NCj4gwqDCoMKgwqBdLA0KPiDCoMKgwqDCoCJi
bG9ja2RldiI6InBtZW01Ig0KPiDCoCB9LA0KDQpBdHRhY2hlZCAic3RyYWNlLmxvZyIuICBOb3Rl
LCB0aGVyZSBpcyBubyByZWZlcmVuY2UgdG8gImJhZGJsb2NrcyINCmZpbGVzIGluIHRoZSBsb2cu
DQoNCkkgYWdyZWUgdGhhdCBvZmZzZXRzIGRvIG5vdCBtYWtlIHNlbnNlIGZvciBCVFQsIGJ1dCBp
dCBsZWFkcyB0byBhIGZhbHNlDQppbXByZXNzaW9uIHRoYXQgdGhlcmUgaXMgbm8gZXJyb3IuICBQ
ZXJoYXBzLCB3ZSBjYW4gcmVtb3ZlICJvZmZzZXQiIG9yDQpwdXQgIm4vYSIgZm9yIEJUVC4gIA0K
DQpUaGFua3MsDQotVG9zaGkNCg0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0
cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRp
bW0K
