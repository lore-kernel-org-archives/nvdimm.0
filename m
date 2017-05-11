Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 650C921A0BA9E
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 11:01:10 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v5 2/2] ndctl: add list --media-errors support
Date: Thu, 11 May 2017 18:01:02 +0000
Message-ID: <1494525578.20330.13.camel@intel.com>
References: <149452421176.25868.9410889126303443053.stgit@djiang5-desk3.ch.intel.com>
 <149452423401.25868.12072221454250478213.stgit@djiang5-desk3.ch.intel.com>
 <1494524875.30303.92.camel@hpe.com>
 <f32a0671-926f-04be-210e-bccd0bd4f1b7@intel.com>
In-Reply-To: <f32a0671-926f-04be-210e-bccd0bd4f1b7@intel.com>
Content-Language: en-US
Content-ID: <EF69819B0F4B4549AFA503FEACC2BEDF@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "toshi.kani@hpe.com" <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA1LTExIGF0IDEwOjUyIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiAN
Cj4gT24gMDUvMTEvMjAxNyAxMDo0OCBBTSwgS2FuaSwgVG9zaGltaXRzdSB3cm90ZToNCj4gPiBP
biBUaHUsIDIwMTctMDUtMTEgYXQgMTA6MzcgLTA3MDAsIERhdmUgSmlhbmcgd3JvdGU6DQo+ID4g
PiBBQ1BJIE5GSVQgZW5hYmxlZCBwbGF0Zm9ybXMgcHJvdmlkZSBtZWRpYSBlcnJvcnMgYXMgYWJz
b2x1dGUNCj4gPiA+IHBoeWlzY2FsDQo+ID4gPiBhZGRyZXNzIG9mZnNldHMuIEFkZCBhbiBvcHRp
b24gdG8gbmRjdGwgdG8gZGlzcGxheSB0aG9zZSBtZWRpYQ0KPiA+ID4gZXJyb3JzDQo+ID4gPiB0
cmFubHNhdGVkIHRvIHJlZ2lvbiBhbmQgbmFtZXNwYWNlIGRldmljZSBsZXZlbCBvZmZzZXRzIGlu
IGFuDQo+ID4gPiAibmRjdGwNCj4gPiA+IGxpc3QiIGxpc3RpbmcuIEJUVCBiYWRibG9ja3Mgc2hv
dyBpcyBub3Qgc3VwcG9ydGVkIGluIHRoaXMNCj4gPiA+IGl0ZXJhdGlvbg0KPiA+ID4gYW5kIHdp
bGwgY29tZSBsYXRlci4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogRGF2ZSBKaWFuZyA8
ZGF2ZS5qaWFuZ0BpbnRlbC5jb20+DQo+ID4gPiAtLS0NCj4gPiA+IA0KPiA+ID4gdjI6IGFkZGVk
IGZpeCB0byBiYWRibG9ja3MgZGlzcGxheSBmcm9tIFRvc2hpJ3MgdGVzdGluZyByZXN1bHQuDQo+
ID4gPiB2MzogZml4ZWQgbmFtaW5nIGlzc3VlcyBmcm9tIERhbidzIGNvbW1lbnRzLg0KPiA+ID4g
wqDCoMKgwqBmaXhlZCBiYWRibG9ja3MgYm91bmRhcnkgb2Zmc2V0IGNhbGN1bGF0aW9ucyBmcm9t
IFRvc2hpJ3MNCj4gPiA+IHRlc3RpbmcuDQo+ID4gPiB2NDogQWRkIGluZGljYXRvciB0byBzaG93
IGJhZGJsb2NrcyBleGlzdCBvciBub3QsIHBlciBUb3NoaSdzDQo+ID4gPiBjb21tZW50cy4NCj4g
PiA+IHY1OiBBZGQgQlRUIGJhZGJsb2NrX2NvdW50IGZyb20gVG9zaGkgYW5kIERhbidzIGNvbW1l
bnRzLg0KPiA+IA0KPiA+IFRoYW5rcyBEYXZlIGZvciB0aGUgcXVpY2sgdXBkYXRlLsKgwqBTb3Jy
eSwgYnV0IEkgZXhwZWN0ZWQNCj4gPiAiYmFkYmxvY2tfY291bnQiIHRvIGJlIGEgbnVtYmVyIG9m
IGJhZGJsb2NrIHNlY3RvcnMsIG5vdCBhIG51bWJlciBvZg0KPiA+IGJhZGJsb2NrIHJhbmdlcy4N
Cj4gDQo+IEFoISBJJ2xsIGZpeCB0aGF0Lg0KDQpXaXRoIHRoZSBmaXgsIHlvdSBjYW4gYWRkIGZv
ciB0aGUgc2VyaWVzDQoNClJldmlld2VkLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1h
QGludGVsLmNvbT4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0
dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
