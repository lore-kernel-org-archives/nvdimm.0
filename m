Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 05FD621A134BC
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 10:49:07 -0700 (PDT)
Received: from G4W9121.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net
 [16.210.21.16])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g9t5008.houston.hpe.com (Postfix) with ESMTPS id 608864E
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 17:49:06 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v6 2/3] ndctl: add list-errors support
Date: Fri, 5 May 2017 17:49:03 +0000
Message-ID: <1494006538.30303.67.camel@hpe.com>
References: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
 <149393454673.2642.10490569511477839936.stgit@djiang5-desk3.ch.intel.com>
 <1494004041.30303.59.camel@hpe.com>
 <caa48123-9daa-4ca6-2110-ef7e2a409ca3@intel.com>
 <1494004877.30303.61.camel@hpe.com>
 <92151b8e-8121-2b28-cc2d-c9f19bf9b5ef@intel.com>
 <1494005739.30303.65.camel@hpe.com>
In-Reply-To: <1494005739.30303.65.camel@hpe.com>
Content-Language: en-US
Content-ID: <C4CB2C3CE3B4874F9E909AF528E3682F@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gRnJpLCAyMDE3LTA1LTA1IGF0IDExOjM1IC0wNjAwLCBUb3NoaSBLYW5pIHdyb3RlOg0KPiBP
biBGcmksIDIwMTctMDUtMDUgYXQgMTA6MjcgLTA3MDAsIERhdmUgSmlhbmcgd3JvdGU6DQo+ID4g
DQo+ID4gT24gMDUvMDUvMjAxNyAxMDoyMSBBTSwgS2FuaSwgVG9zaGltaXRzdSB3cm90ZToNCj4g
PiA+IE9uIEZyaSwgMjAxNy0wNS0wNSBhdCAxMDoxNCAtMDcwMCwgRGF2ZSBKaWFuZyB3cm90ZToN
Cj4gPiA+ID4gDQo+ID4gPiA+IE9uIDA1LzA1LzIwMTcgMTA6MDcgQU0sIEthbmksIFRvc2hpbWl0
c3Ugd3JvdGU6DQo+ID4gPiA+ID4gT24gVGh1LCAyMDE3LTA1LTA0IGF0IDE0OjQ5IC0wNzAwLCBE
YXZlIEppYW5nIHdyb3RlOg0KPiA+ID4gPiA+ID4gQWRkaW5nIGxpc3QtZXJyb3JzIGNvbW1hbmQg
dG8gc3VwcG9ydCBkaXNwbGF5aW5nIG9mIGFsbA0KPiA+ID4gPiA+ID4gYmFkYmxvY2tzIGluIHJl
bGF0aW9uIHRvIHRoZSBkZXZpY2UgcmF0aGVyIHRoYW4gdGhlIHJlZ2lvbi4NCj4gPiA+ID4gPiA+
IFRoaXMgYWxsb3dzIHRoZSB1c2VyIHRvIGtub3cgd2hhdCBiYWRibG9ja3MgdG8gcGFzcyBpbiB3
aGVuDQo+ID4gPiA+ID4gPiBkb2luZyBjbGVhci1lcnJvciBjYWxscy4NCj4gPiA+ID4gPiA+IA0K
PiA+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogRGF2ZSBKaWFuZyA8ZGF2ZS5qaWFuZ0BpbnRlbC5j
b20+DQo+ID4gPiA+ID4gPiAtLS0NCj4gPiA+ID4gPiA+IMKgRG9jdW1lbnRhdGlvbi9uZGN0bC1s
aXN0LWVycm9ycy50eHQgfMKgwqDCoDI2ICsrKysrKysNCj4gPiA+ID4gPiA+IMKgYnVpbHRpbi5o
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfMKg
wqDCoMKgMQ0KPiA+ID4gPiA+ID4gwqBuZGN0bC9jbGVhci1lcnJvci5jwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHzCoMKgMTMzDQo+ID4gPiA+ID4gPiArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKy0tLQ0KPiA+ID4gPiA+ID4gwqBuZGN0bC9uZGN0bC5jwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHzCoMKgwqDCoDENCj4gPiA+ID4g
PiA+IMKgNCBmaWxlcyBjaGFuZ2VkLCAxNTEgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0p
DQo+ID4gPiA+ID4gPiDCoGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1bWVudGF0aW9uL25kY3RsLWxp
c3QtZXJyb3JzLnR4dA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvRG9j
dW1lbnRhdGlvbi9uZGN0bC1saXN0LWVycm9ycy50eHQNCj4gPiA+ID4gPiA+IGIvRG9jdW1lbnRh
dGlvbi9uZGN0bC1saXN0LWVycm9ycy50eHQNCj4gPiA+ID4gPiA+IG5ldyBmaWxlIG1vZGUgMTAw
NjQ0DQo+ID4gPiA+ID4gPiBpbmRleCAwMDAwMDAwLi5mODMxYmEwDQo+ID4gPiA+ID4gPiAtLS0g
L2Rldi9udWxsDQo+ID4gPiA+ID4gPiArKysgYi9Eb2N1bWVudGF0aW9uL25kY3RsLWxpc3QtZXJy
b3JzLnR4dA0KPiA+ID4gPiA+ID4gQEAgLTAsMCArMSwyNiBAQA0KPiA+ID4gPiA+ID4gK25kY3Rs
LWxpc3QtZXJyb3JzKDEpDQo+ID4gPiA+ID4gPiArPT09PT09PT09PT09PT09PT09PT0NCj4gPiA+
ID4gPiA+ICsNCj4gPiA+ID4gPiA+ICtOQU1FDQo+ID4gPiA+ID4gPiArLS0tLQ0KPiA+ID4gPiA+
ID4gK25kY3RsLWxpc3QtZXJyb3JzIC0gbGlzdCBiYWRibG9ja3Mgc3BlY2lmaWNhbGx5IGluDQo+
ID4gPiA+ID4gPiByZWxhdGlvbg0KPiA+ID4gPiA+ID4gdG8gYQ0KPiA+ID4gPiA+ID4gZGV2aWNl
DQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiArU1lOT1BTSVMNCj4gPiA+ID4gPiA+ICstLS0t
LS0tLQ0KPiA+ID4gPiA+ID4gK1t2ZXJzZV0NCj4gPiA+ID4gPiA+ICsnbmRjdGwgbGlzdC1lcnJv
cnMnIFs8b3B0aW9ucz5dDQo+ID4gPiA+ID4gPiArDQo+ID4gPiA+ID4gPiArRVhBTVBMRVMNCj4g
PiA+ID4gPiA+ICstLS0tLS0tLQ0KPiA+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ID4gK0xpc3QgYmFk
IGJsb2NrcyBmb3IgdGhlIHByb3ZpZGVkIGRldmljZQ0KPiA+ID4gPiA+ID4gK1t2ZXJzZV0NCj4g
PiA+ID4gPiA+ICtuZGN0bCBsaXN0LWVycm9ycyAtZiAvZGV2L2RheDAuMA0KPiA+ID4gPiA+ID4g
Kw0KPiA+ID4gPiA+ID4gK0xpc3QgYWxsIGJhZGJsb2NrcyBmb3IgZGV2aWNlIC9kZXYvZGF4MC4w
Lg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEhpIERhdmUsDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
SSBhbSBub3QgZ2V0dGluZyBzZW5zaWJsZSB2YWx1ZXMgZnJvbSBsaXN0LWVycm9ycy7CoMKgQWxz
bywNCj4gPiA+ID4gPiBwbGVhc2UgZGVzY3JpYmUgdGhlIG91dHB1dCBmb3JtYXQgb2YgdGhpcyBj
b21tYW5kIGluIHRoZQ0KPiA+ID4gPiA+IGRvY3VtZW50Lg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+
ICMgY2F0IC9zeXMvYnVzL25kL2RldmljZXMvcmVnaW9uMC9zaXplDQo+ID4gPiA+ID4gMTcxNzk4
NjkxODQNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiAjIGNhdCAvc3lzL2NsYXNzL2RheC9kYXgwLjAv
c2l6ZQ0KPiA+ID4gPiA+IDE2OTA5MzM2NTc2DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gIyBjYXQg
L3N5cy9idXMvbmQvZGV2aWNlcy9yZWdpb24wL2JhZGJsb2Nrcw0KPiA+ID4gPiA+IDEwNDg1NzYg
MQ0KPiA+ID4gPiA+IDE1NzI4NjQgMQ0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+ICMgbmRjdGwgbGlz
dC1lcnJvcnMgLWYgL2Rldi9kYXgwLjANCj4gPiA+ID4gPiAwIDMxNDU3MjkNCj4gPiA+ID4gPiAw
IDM2NzAwMTcNCj4gPiA+ID4gDQo+ID4gPiA+IFRoYXQgaXMgdmVyeSBzdHJhbmdlLiBJdCBsb29r
cyBjb3JyZWN0IHdpdGggbmZpdF90ZXN0IGZvciBtZS4NCj4gPiA+ID4gSG93IGRvIEkgcmVwcm9k
dWNlIHlvdXIgY2FzZSBvciBkbyBJIGFjdHVhbGx5IG5lZWQgYWN0dWFsDQo+ID4gPiA+IGhhcmR3
YXJlPw0KPiA+ID4gDQo+ID4gPiBZZXMsIG15IHN0ZXBzIG5lZWQgYSBoYXJkd2FyZSwgYnV0IHRo
aXMgYmFkYmxvY2tzIGhhbmRsaW5nIGl0c2VsZg0KPiA+ID4gc2hvdWxkIGJlIHBsYXRmb3JtLWlu
ZGVwZW5kZW50LsKgwqBJIHdpbGwgY2hlY2sgdG8gc2VlIHdoeSBJIGdvdA0KPiA+ID4gdGhlc2Ug
dmFsdWVzLg0KPiA+IA0KPiA+IFRoYW5rcyEgd2hhdCBpcyB5b3VyIHJlZ2lvbi9yZXNvdXJjZSBh
bmQgZGF4L3Jlc291cmNlPw0KPiANCj4gU2VlIGF0dGFjaGVkLiBMZXQgbWUga25vdyBpZiB5b3Ug
bmVlZCBtb3JlIGluZm8uDQoNCmRheF9iZWdpbiBhbmQgZGF4X2VuZCBnZXQgLTEgaW4gcHJpbnRf
ZGF4X2JhZGJsb2NrcygpIGJlY2F1c2UNCm5kY3RsX2RheF9nZXRfcmVzb3VyY2UoKSBhbmQgbmRj
dGxfZGF4X2dldF9zaXplKCkgZmFpbGVkLiAgSSB0aGluayB0aGlzDQppcyBkdWUgdG8gdGhlIG51
bWJlcmluZyBvZiBzeXNmcyBkYXggZmlsZXMsIHdoaWNoIERhbiBhbiBJIHRhbGtlZCBhYm91dA0K
eWVzdGVyZGF5Lg0KDQpUaGFua3MsDQotVG9zaGkgIA0KDQoNCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2xpbnV4LW52ZGltbQo=
