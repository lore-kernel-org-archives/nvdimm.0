Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2670621F3C1B9
 for <linux-nvdimm@lists.01.org>; Mon,  9 Oct 2017 13:21:51 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 2/4] nfit_test: add error injection DSMs
Date: Mon, 9 Oct 2017 20:25:17 +0000
Message-ID: <1507580593.23025.79.camel@intel.com>
References: <20171006015340.29722-1-vishal.l.verma@intel.com>
 <20171006015340.29722-3-vishal.l.verma@intel.com>
 <CAPcyv4hLcpngRij-Kr+OZkK=CbHVNc_A+9qP=cgPpOxUKH3SzQ@mail.gmail.com>
In-Reply-To: <CAPcyv4hLcpngRij-Kr+OZkK=CbHVNc_A+9qP=cgPpOxUKH3SzQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <F43F75D27C7EB740804598E61ECE1395@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gU2F0LCAyMDE3LTEwLTA3IGF0IDEwOjA3IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgT2N0IDUsIDIwMTcgYXQgNjo1MyBQTSwgVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52
ZXJtYUBpbnRlbC5jb20NCj4gPiB3cm90ZToNCg0KW10NCg0KPiA+IMKgwqDCoMKgwqDCoMKgwqBO
RklUX0FSU19USU1FT1VUID0gOTAsDQo+ID4gK8KgwqDCoMKgwqDCoMKgTkZJVF9BUlNfSU5KRUNU
X0lOVkFMSUQgPSAyLA0KPiANCj4gSWYgdGhlcmUgaXMgbm8gdXNhZ2Ugb2YgdGhpcyBkZWZpbmUg
b3V0c2lkZSBvZiBuZml0X3Rlc3QgdGhlbiBpdA0KPiBzaG91bGQgYmUgZGVmaW5lZCBpbiB0b29s
cy90ZXN0aW5nL252ZGltbS90ZXN0L25maXQuaC4NCg0KWWVzIG1vdmVkLg0KDQo+IA0KPiA+IMKg
fTsNCj4gPiANCj4gPiDCoGVudW0gbmZpdF9yb290X25vdGlmaWVycyB7DQo+ID4gZGlmZiAtLWdp
dCBhL3Rvb2xzL3Rlc3RpbmcvbnZkaW1tL0tidWlsZA0KPiA+IGIvdG9vbHMvdGVzdGluZy9udmRp
bW0vS2J1aWxkDQo+ID4gaW5kZXggZDg3MDUyMC4uMzI3MmFiNSAxMDA2NDQNCj4gPiAtLS0gYS90
b29scy90ZXN0aW5nL252ZGltbS9LYnVpbGQNCj4gPiArKysgYi90b29scy90ZXN0aW5nL252ZGlt
bS9LYnVpbGQNCj4gPiBAQCAtNjksNiArNjksNyBAQCBsaWJudmRpbW0teSArPSAkKE5WRElNTV9T
UkMpL3JlZ2lvbl9kZXZzLm8NCj4gPiDCoGxpYm52ZGltbS15ICs9ICQoTlZESU1NX1NSQykvcmVn
aW9uLm8NCj4gPiDCoGxpYm52ZGltbS15ICs9ICQoTlZESU1NX1NSQykvbmFtZXNwYWNlX2RldnMu
bw0KPiA+IMKgbGlibnZkaW1tLXkgKz0gJChOVkRJTU1fU1JDKS9sYWJlbC5vDQo+ID4gK2xpYm52
ZGltbS15ICs9ICQoTlZESU1NX1NSQykvYmFkcmFuZ2Uubw0KPiANCj4gVGhpcyBodW5rIHNob3Vs
ZCBnbyBpbiB0aGUgc2FtZSBwYXRjaCB0aGF0IGNoYW5nZXMNCj4gZHJpdmVycy9udmRpbW0vTWFr
ZWZpbGUgdG8gYWRkIGJhZHJhbmdlLm8gc28gd2UgZG9uJ3QgaGF2ZSBhbg0KPiBuZml0X3Rlc3Qg
Y29tcGlsZSBicmVha2FnZSBnYXAgYmV0d2VlbiBjb21taXRzLg0KDQpUaGUga2VybmVsJ3Mgbm9y
bWFsIHVzYWdlIGFscmVhZHkgaGFzIHRoZSBrYnVpbGQgY2hhbmdlIGluIHRoZSByaWdodA0KcGxh
Y2UgKHBhdGNoIDEpLiBUaGlzIGFkZHMgdGhlIHVzZSBvZiBiYWRyYW5nZSBmdW5jdGlvbnMgdG8g
bmZpdF90ZXN0DQpmb3IgdGhlIGZpcnN0IHRpbWUsIGFuZCBoZW5jZSB0aGUga2J1aWxkIGFkZGl0
aW9uIGhlcmUuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRw
czovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
