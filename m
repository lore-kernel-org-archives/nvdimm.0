Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 023B521A16E28
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 15:34:57 -0700 (PDT)
Received: from G9W8455.americas.hpqcorp.net (g9w8455.houston.hp.com
 [16.216.161.94])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g9t5008.houston.hpe.com (Postfix) with ESMTPS id 1BC3760
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 22:34:56 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 2/2] ndctl: add list --media-errors support
Date: Wed, 10 May 2017 22:33:42 +0000
Message-ID: <1494455610.30303.86.camel@hpe.com>
References: <149443923101.16024.9360569471346131929.stgit@djiang5-desk3.ch.intel.com>
 <149443929943.16024.5561881574160309534.stgit@djiang5-desk3.ch.intel.com>
 <1494441822.30303.77.camel@hpe.com>
 <e2873152-d765-4bcd-40c8-2f8caaa72803@intel.com>
 <1494449841.30303.80.camel@hpe.com>
 <c3b83dd6-e45a-82b5-92f9-c49e9d80ba3d@intel.com>
 <CAPcyv4jL-5sOVSm8+E_drQdOw-UQ3owajuJfBdTAhYxy97130Q@mail.gmail.com>
In-Reply-To: <CAPcyv4jL-5sOVSm8+E_drQdOw-UQ3owajuJfBdTAhYxy97130Q@mail.gmail.com>
Content-Language: en-US
Content-ID: <BA567F49A5AB7F4695E2FF3535937CC3@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gV2VkLCAyMDE3LTA1LTEwIGF0IDE1OjI0IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFdlZCwgTWF5IDEwLCAyMDE3IGF0IDI6MTMgUE0sIERhdmUgSmlhbmcgPGRhdmUuamlhbmdA
aW50ZWwuY29tPg0KPiB3cm90ZToNCj4gPiBPbiAwNS8xMC8yMDE3IDAxOjU3IFBNLCBLYW5pLCBU
b3NoaW1pdHN1IHdyb3RlOg0KPiA+ID4gT24gV2VkLCAyMDE3LTA1LTEwIGF0IDEyOjU2IC0wNzAw
LCBEYXZlIEppYW5nIHdyb3RlOg0KPiA+ID4gPiANCiA6DQo+ID4gPiANCj4gPiA+IEkgYWdyZWUg
dGhhdCBvZmZzZXRzIGRvIG5vdCBtYWtlIHNlbnNlIGZvciBCVFQsIGJ1dCBpdCBsZWFkcyB0byBh
DQo+ID4gPiBmYWxzZSBpbXByZXNzaW9uIHRoYXQgdGhlcmUgaXMgbm8gZXJyb3IuwqDCoFBlcmhh
cHMsIHdlIGNhbiByZW1vdmUNCj4gPiA+ICJvZmZzZXQiIG9yIHB1dCAibi9hIiBmb3IgQlRULg0K
PiA+IA0KPiA+IEknbSBvayB3aXRoIHRoYXQgaWYgRGFuIGhhcyBubyBwcm9ibGVtIHdpdGggaXQu
DQo+ID4gDQo+IA0KPiBJdCBkb2Vzbid0IHN0cmlrZSBtZSBhcyB0aGUgYmVzdCBwYXRoIGZvcndh
cmQuIElkZWFsbHkgd2hhdCB3ZSBuZWVkDQo+IGlzIGEgY3VzdG9taXplZCBidHQgYmFkYmxvY2tz
IGludGVyZmFjZSB0aGF0IGtub3dzIGhvdyB0byByZXZlcnNlDQo+IGxvb2t1cCBtZWRpYSBlcnJv
cnMgaW50byBhY3RpdmUgLyBidHQgcmVsYXRpdmUgc2VjdG9yIG9mZnNldHMuIFVudGlsDQo+IHdl
IGhhdmUgdGhhdCwgdG8gbGlzdCB0aGUgZXJyb3JzIHRoYXQgYXJlIGFzc29jaWF0ZWQgd2l0aCB0
aGUgYnR0DQo+IG5hbWVzcGFjZSB5b3UgbmVlZCB0byByZWxvYWQgaXQgaW4gcmF3IG1vZGUgb3Ig
anVzdCByZWxheSBvbiB0aGUNCj4gcGFyZW50IHJlZ2lvbiBtZWRpYSBlcnJvciBsaXN0LiBOb3cs
IHRoYXQgc2FpZCBJIHdvdWxkbid0IG1pbmQgaWYgd2UNCj4gaGFkIGEgZmxhZyB0aGF0IGluZGlj
YXRlcyB3aGV0aGVyIGJhZGJsb2NrcyBhcmUgcHJlc2VudCBvciBub3QgYnkNCj4gZGVmYXVsdCwg
YW5kIHRoZW4gLU0gdHJpZXMgdG8gbGlzdCB0aGVtLiBTb21ldGhpbmcgbGlrZSB0aGlzIHdoZXJl
IHdlDQo+IGhhdmUgMiBuYW1lc3BhY2VzIGluIHRoZSBzYW1lIHJlZ2lvbiB0aGF0IGhhcyBiYWRi
bG9ja3M6DQo+IA0KPiAjIG5kY3RsIGxpc3QNCj4gWw0KPiDCoCB7DQo+IMKgwqDCoMKgImRldiI6
Im5hbWVzcGFjZTAuMCIsDQo+IMKgwqDCoMKgIm1vZGUiOiJzZWN0b3IiLA0KPiDCoMKgwqDCoCJz
aXplIjo0Mjk0OTY3Mjk2LA0KPiDCoMKgwqDCoCJ1dWlkIjoiM2Y0NWM3NTQtNWU4ZS00ZDNlLTg5
ZGItNTNhZTVjYzVhOWJkIiwNCj4gwqDCoMKgwqAiYmxvY2tkZXYiOiJwbWVtMHMiLA0KPiDCoMKg
wqDCoCJoYXNfYmFkYmxvY2tzIjp0cnVlLA0KPiDCoCB9LA0KPiDCoCB7DQo+IMKgwqDCoMKgImRl
diI6Im5hbWVzcGFjZTAuMSIsDQo+IMKgwqDCoMKgIm1vZGUiOiJtZW1vcnkiLA0KPiDCoMKgwqDC
oCJzaXplIjoxNTg1MjM3MTk2OCwNCj4gwqDCoMKgwqAidXVpZCI6IjY0NDZiM2JkLWI2NGEtNDE2
My1iNTQyLWQ4MmVkNTU3ZmI3OCIsDQo+IMKgwqDCoMKgImJsb2NrZGV2IjoicG1lbTAuMSINCj4g
wqDCoMKgwqAiaGFzX2JhZGJsb2NrcyI6dHJ1ZSwNCj4gwqB9LA0KPiBdDQo+IA0KPiAjIG5kY3Rs
IGxpc3QgLU0NCj4gWw0KPiDCoCB7DQo+IMKgwqDCoMKgImRldiI6Im5hbWVzcGFjZTAuMCIsDQo+
IMKgwqDCoMKgIm1vZGUiOiJzZWN0b3IiLA0KPiDCoMKgwqDCoCJzaXplIjo0Mjk0OTY3Mjk2LA0K
PiDCoMKgwqDCoCJ1dWlkIjoiM2Y0NWM3NTQtNWU4ZS00ZDNlLTg5ZGItNTNhZTVjYzVhOWJkIiwN
Cj4gwqDCoMKgwqAiYmxvY2tkZXYiOiJwbWVtMHMiLA0KPiDCoMKgwqDCoCJoYXNfYmFkYmxvY2tz
Ijp0cnVlLA0KPiDCoCB9LA0KPiDCoCB7DQo+IMKgwqDCoMKgImRldiI6Im5hbWVzcGFjZTAuMSIs
DQo+IMKgwqDCoMKgIm1vZGUiOiJtZW1vcnkiLA0KPiDCoMKgwqDCoCJzaXplIjoxNTg1MjM3MTk2
OCwNCj4gwqDCoMKgwqAidXVpZCI6IjY0NDZiM2JkLWI2NGEtNDE2My1iNTQyLWQ4MmVkNTU3ZmI3
OCIsDQo+IMKgwqDCoMKgImJsb2NrZGV2IjoicG1lbTAuMSINCj4gwqDCoMKgwqAiaGFzX2JhZGJs
b2NrcyI6dHJ1ZSwNCj4gwqDCoMKgwqAiYmFkYmxvY2tzIjpbDQo+IMKgwqDCoMKgwqDCoHsNCj4g
wqDCoMKgwqDCoMKgwqDCoCJvZmZzZXQiOjQsDQo+IMKgwqDCoMKgwqDCoMKgwqAibGVuZ3RoIjox
DQo+IMKgwqDCoMKgwqDCoH0sDQo+IMKgfSwNCj4gXQ0KPiANCj4gSW4gdGhlIGNvbW1vbiBjYXNl
IHdoZXJlIHRoZXJlIGFyZSBubyBiYWRibG9ja3Mgd2UgY2FuIGp1c3QgaGFkIHRoZQ0KPiAiaGFz
X2JhZGJsb2NrcyIgYm9vbGVhbi4NCg0KR29vZCBpZGVhISAgV2l0aCAiaGFzX2JhZGJsb2NrcyIg
aW5mbywgeWVzLCB3ZSBjYW4gYXZvaWQgdGhlIGZhbHNlDQppbXByZXNzaW9uIEkgY29uY2VybmVk
IGFib3V0LCBhbmQgY2FuIHdhaXQgZm9yIGEgY3VzdG9taXplZCBidHQNCmJhZGJsb2NrcyBpbnRl
cmZhY2UuDQoNClRoYW5rcywNCi1Ub3NoaQ0KDQoNCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZk
aW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xp
bnV4LW52ZGltbQo=
