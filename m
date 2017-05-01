Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B70462195DA43
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 08:05:50 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH 2/2] libnvdimm: clear region badblock in
 nvdimm_clear_poison()
Date: Mon, 1 May 2017 15:05:46 +0000
Message-ID: <1493651145.30303.13.camel@hpe.com>
References: <20170427225706.26791-1-toshi.kani@hpe.com>
 <20170427225706.26791-2-toshi.kani@hpe.com>
 <CAPcyv4j9QPSwpqs9YPjFo=O8RA+NmpsAZhARfNcSqA0TqqMhLA@mail.gmail.com>
 <CAPcyv4gbTEXjLAP6fT2+tT4tqwA9_8D6MYzzD7wZC8cOQNUVKw@mail.gmail.com>
 <CAPcyv4jQGiDEW6QJYi3EeF5f0UkC=FEx4uA-K+_RaEN-JpZGEw@mail.gmail.com>
In-Reply-To: <CAPcyv4jQGiDEW6QJYi3EeF5f0UkC=FEx4uA-K+_RaEN-JpZGEw@mail.gmail.com>
Content-Language: en-US
Content-ID: <969166676757964D8986BBE663CEF769@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gRnJpLCAyMDE3LTA0LTI4IGF0IDE3OjM1IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIEZyaSwgQXByIDI4LCAyMDE3IGF0IDU6MTIgUE0sIERhbiBXaWxsaWFtcyA8ZGFuLmoud2ls
bGlhbXNAaW50ZWwuYw0KPiBvbT4gd3JvdGU6DQo+ID4gT24gRnJpLCBBcHIgMjgsIDIwMTcgYXQg
NToxMCBQTSwgRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbA0KPiA+IC5jb20+IHdy
b3RlOg0KPiA+ID4gT24gVGh1LCBBcHIgMjcsIDIwMTcgYXQgMzo1NyBQTSwgVG9zaGkgS2FuaSA8
dG9zaGkua2FuaUBocGUuY29tPg0KPiA+ID4gd3JvdGU6DQo+ID4gPiA+IEJhZGJsb2NrcyBhcmUg
dHJhY2tlZCBhdCBib3RoIHJlZ2lvbiBhbmQgZGV2aWNlIGxldmVscy4NCj4gPiA+ID4gcG1lbV9j
bGVhcl9wb2lzb24oKSBhbmQgbnNpb19yd19ieXRlcygpIGNhbGwNCj4gPiA+ID4gbnZkaW1tX2Ns
ZWFyX3BvaXNvbigpIGFuZCB0aGVuIGJhZGJsb2Nrc19jbGVhcigpIHRvIGNsZWFyDQo+ID4gPiA+
IGJhZGJsb2NrcyBhdCB0aGUgZGV2aWNlIGxldmVsLiBIb3dldmVyLCBpdCBkb2VzIG5vdCB1cGRh
dGUNCj4gPiA+ID4gYmFkYmxvY2tzIGF0IHRoZSByZWdpb24gbGV2ZWwsIHdoaWNoIG1ha2VzIHRo
ZW0gaW5jb25zaXN0ZW50Lg0KPiA+ID4gPiANCj4gPiA+ID4gQ2hhbmdlIG52ZGltbV9jbGVhcl9w
b2lzb24oKSB0byB1cGRhdGUgYmFja2Jsb2NrcyBhdCB0aGUgcmVnaW9uDQo+ID4gPiA+IGxldmVs
IHRvIGtlZXAgdGhlbSBjb25zaXN0ZW50Lg0KPiA+ID4gPiANCj4gPiA+ID4gU2lnbmVkLW9mZi1i
eTogVG9zaGkgS2FuaSA8dG9zaGkua2FuaUBocGUuY29tPg0KPiA+ID4gPiBDYzogRGFuIFdpbGxp
YW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+ID4gPiA+IENjOiBEYXZlIEppYW5nIDxk
YXZlLmppYW5nQGludGVsLmNvbT4NCj4gPiA+ID4gQ2M6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwu
dmVybWFAaW50ZWwuY29tPg0KPiA+ID4gDQo+ID4gPiBUaGlzIGxvb2tzIGdvb2QsIGFuZCBpdCBz
ZWVtcyB3ZSBoYXZlIGEgYnVnIGluIHRoZSBvdGhlciBsb2NhdGlvbg0KPiA+ID4gdGhhdCBkb2Vz
IHRoaXMgaW4gX19uZF9pb2N0bCgpLiBUaGF0IG90aGVyIG9uZSBpcyBtaXNzaW5nIHRoZQ0KPiA+
ID4gImNsZWFyX2Vyci5jbGVhcmVkIC8gNTEyIiBjaGVjay4gQ2FuIHlvdSByZXNwaW4gdGhpcyBh
bmQgZGVmaW5lIGENCj4gPiA+IGNvbW1vbiBoZWxwZXIgdGhhdCBib3RoIGxvY2F0aW9ucyBjYW4g
Y2FsbD8NCj4gPiANCj4gPiBPbiBzZWNvbmQgdGhvdWdodCwgSSdsbCB0YWtlIHRoaXMgYW5kIHNw
aW4gbXkgb3duIGNsZWFudXAgLyBmaXggb24NCj4gPiB0b3AuDQo+ID4gDQo+ID4gVGhhbmtzIFRv
c2hpIQ0KPiANCj4gLi4uYW5kIEkgbmVlZCB0byBkcm9wIGl0IGFnYWluIGJlY2F1c2UgaXQgY2F1
c2VzIHRoaXM6DQo+IA0KPiBbwqDCoDEwNi45NzQ4ODldIEJVRzogc2xlZXBpbmcgZnVuY3Rpb24g
Y2FsbGVkIGZyb20gaW52YWxpZCBjb250ZXh0IGF0DQo+IGtlcm5lbC9sb2NraW5nL211dGV4LmM6
NzQ3DQo+IFvCoMKgMTA2Ljk3NzMyOF0gaW5fYXRvbWljKCk6IDEsIGlycXNfZGlzYWJsZWQoKTog
MCwgcGlkOiA1NTg0LCBuYW1lOg0KPiBkZA0KDQpTb3JyeSwgSSBzaG91bGQgaGF2ZSB0ZXN0ZWQg
d2l0aCBDT05GSUdfREVCVUdfQVRPTUlDX1NMRUVQIHNldC4gIFRoYW5rcw0KZm9yIHN0cmFpZ2h0
ZW4gaXQgb3V0IGluIHlvdXIgcGF0Y2ghwqANCg0KLVRvc2hpIA0KX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApM
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlz
dGluZm8vbGludXgtbnZkaW1tCg==
