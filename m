Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A0BB921A0480F
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 15:29:22 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH 1/2] libnvdimm: fix clear length of nvdimm_forget_poison()
Date: Fri, 28 Apr 2017 22:29:16 +0000
Message-ID: <1493418523.30303.6.camel@hpe.com>
References: <20170427225706.26791-1-toshi.kani@hpe.com>
 <CAPcyv4i+U62GMyK=xNXB9ZjzS-028q4Qch=kxa9_pkwXrFJdsA@mail.gmail.com>
In-Reply-To: <CAPcyv4i+U62GMyK=xNXB9ZjzS-028q4Qch=kxa9_pkwXrFJdsA@mail.gmail.com>
Content-Language: en-US
Content-ID: <A8736674EC59F440A5C98341E925E61B@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE3LTA0LTI4IGF0IDE0OjQ4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgQXByIDI3LCAyMDE3IGF0IDM6NTcgUE0sIFRvc2hpIEthbmkgPHRvc2hpLmthbmlA
aHBlLmNvbT4NCj4gd3JvdGU6DQo+ID4gTkRfQ01EX0NMRUFSX0VSUk9SIGNvbW1hbmQgcmV0dXJu
cyAnY2xlYXJfZXJyLmNsZWFyZWQnLCB0aGUgbGVuZ3RoDQo+ID4gb2YgZXJyb3IgYWN0dWFsbHkg
Y2xlYXJlZCwgd2hpY2ggbWF5IGJlIHNtYWxsZXIgdGhhbiBpdHMgcmVxdWVzdGVkDQo+ID4gJ2xl
bicuDQo+ID4gDQo+ID4gQ2hhbmdlIG52ZGltbV9jbGVhcl9wb2lzb24oKSB0byBjYWxsIG52ZGlt
bV9mb3JnZXRfcG9pc29uKCkgd2l0aA0KPiA+ICdjbGVhcl9lcnIuY2xlYXJlZCcgd2hlbiB0aGlz
IHZhbHVlIGlzIHZhbGlkLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFRvc2hpIEthbmkgPHRv
c2hpLmthbmlAaHBlLmNvbT4NCj4gPiBDYzogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0Bp
bnRlbC5jb20+DQo+ID4gQ2M6IERhdmUgSmlhbmcgPGRhdmUuamlhbmdAaW50ZWwuY29tPg0KPiA+
IENjOiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCj4gPiAtLS0NCj4g
PiBCYXNlZCBvbiAnbGlibnZkaW1tLWZvci1uZXh0Jy4NCj4gPiAtLS0NCj4gPiDCoGRyaXZlcnMv
bnZkaW1tL2J1cy5jIHzCoMKgwqDCoDQgKysrLQ0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDMgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L252ZGltbS9idXMuYyBiL2RyaXZlcnMvbnZkaW1tL2J1cy5jDQo+ID4gaW5kZXggZDIxNGFjNDQu
LjQzZGRmZDQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9udmRpbW0vYnVzLmMNCj4gPiArKysg
Yi9kcml2ZXJzL252ZGltbS9idXMuYw0KPiA+IEBAIC0yMTksNyArMjE5LDkgQEAgbG9uZyBudmRp
bW1fY2xlYXJfcG9pc29uKHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gPiBwaHlzX2FkZHJfdCBwaHlz
LA0KPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoY21kX3JjIDwgMCkNCj4gPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBjbWRfcmM7DQo+ID4gDQo+ID4gLcKgwqDCoMKgwqDC
oMKgbnZkaW1tX2ZvcmdldF9wb2lzb24obnZkaW1tX2J1cywgcGh5cywgbGVuKTsNCj4gPiArwqDC
oMKgwqDCoMKgwqBpZiAoY2xlYXJfZXJyLmNsZWFyZWQgPiAwKQ0KPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBudmRpbW1fZm9yZ2V0X3BvaXNvbihudmRpbW1fYnVzLCBwaHlzLA0K
PiA+IGNsZWFyX2Vyci5jbGVhcmVkKTsNCj4gPiArDQo+ID4gwqDCoMKgwqDCoMKgwqDCoHJldHVy
biBjbGVhcl9lcnIuY2xlYXJlZDsNCj4gDQo+IExvb2tzLCBnb29kIHdlIG5lZWQgdG8gbWFyayB0
aGlzIGZvciAtc3RhYmxlIHNpbmNlIHRoZSBidWcgaXMgYWxzbw0KPiBwcmVzZW50IGluIGN1cnJl
bnQgbWFpbmxpbmUuDQo+IA0KPiBGaXhlczogZTA0NjExNGFmNWZjICgibGlibnZkaW1tOiBjbGVh
ciB0aGUgaW50ZXJuYWwgcG9pc29uX2xpc3Qgd2hlbg0KPiBjbGVhcmluZyBiYWRibG9ja3MiKQ0K
DQpTaGFsbCBJIHNlbmQgYSBwYXRjaCBiYXNlZCBvbiB0aGUgY3VycmVudCBtYWlubGluZSB3aXRo
IGNjIHRvIC1zdGFibGU/IA0KVGhlIGZ1bmMgbmFtZSBpcyBudmRpbW1fY2xlYXJfZnJvbV9wb2lz
b25fbGlzdCgpIGluIHRoZSBtYWlubGluZS4NCg0KVGhhbmtzLA0KLVRvc2hpCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5n
IGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWls
bWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
