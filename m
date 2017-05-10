Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 832F021A0BABF
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 14:49:14 -0700 (PDT)
Received: from G9W8454.americas.hpqcorp.net (g9w8454.houston.hp.com
 [16.216.161.4])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2353.austin.hpe.com (Postfix) with ESMTPS id B58795E
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 21:49:13 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 2/2] ndctl: add list --media-errors support
Date: Wed, 10 May 2017 21:47:44 +0000
Message-ID: <1494452852.30303.84.camel@hpe.com>
References: <149443923101.16024.9360569471346131929.stgit@djiang5-desk3.ch.intel.com>
 <149443929943.16024.5561881574160309534.stgit@djiang5-desk3.ch.intel.com>
 <1494441822.30303.77.camel@hpe.com>
 <e2873152-d765-4bcd-40c8-2f8caaa72803@intel.com>
 <1494449841.30303.80.camel@hpe.com>
 <c3b83dd6-e45a-82b5-92f9-c49e9d80ba3d@intel.com>
 <1494451676.30303.82.camel@hpe.com>
 <c25539ef-f892-7f08-3f1e-c7c318c7747e@intel.com>
In-Reply-To: <c25539ef-f892-7f08-3f1e-c7c318c7747e@intel.com>
Content-Language: en-US
Content-ID: <5A073AB440891746B2FD1C186A93933A@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gV2VkLCAyMDE3LTA1LTEwIGF0IDE0OjM0IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiAN
Cj4gT24gMDUvMTAvMjAxNyAwMjoyOCBQTSwgS2FuaSwgVG9zaGltaXRzdSB3cm90ZToNCj4gPiBP
biBXZWQsIDIwMTctMDUtMTAgYXQgMTQ6MTMgLTA3MDAsIERhdmUgSmlhbmcgd3JvdGU6DQo+ID4g
PiANCj4gPiA+IE9uIDA1LzEwLzIwMTcgMDE6NTcgUE0sIEthbmksIFRvc2hpbWl0c3Ugd3JvdGU6
DQo+ID4gPiA+IE9uIFdlZCwgMjAxNy0wNS0xMCBhdCAxMjo1NiAtMDcwMCwgRGF2ZSBKaWFuZyB3
cm90ZToNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBPbiAwNS8xMC8yMDE3IDExOjQzIEFNLCBLYW5p
LCBUb3NoaW1pdHN1IHdyb3RlOg0KPiA+IA0KPiA+IMKgOg0KPiA+ID4gPiANCj4gPiA+ID4gQXR0
YWNoZWQgInN0cmFjZS5sb2ciLsKgwqBOb3RlLCB0aGVyZSBpcyBubyByZWZlcmVuY2UgdG8NCj4g
PiA+ID4gImJhZGJsb2NrcyINCj4gPiA+ID4gZmlsZXMgaW4gdGhlIGxvZy4NCj4gPiA+IA0KPiA+
ID4gSG1tbS4uLi5pcyB0aGVyZSBhbnkgcmVhc29uIG15IHJhdyBuYW1lc3BhY2UgaXMgZGlmZmVy
ZW50IHR5cGUNCj4gPiA+IHRoYW4geW91cnM/IERvIHlvdSBrbm93IGlmIHlvdXJzIGhpdCB0aGUg
ZWxzZSBicmFuY2ggb24NCj4gPiA+IHV0aWwvanNvbi5jOjUxNiBpbiB1dGlsX25hbWVzcGFjZV90
b19qc29uKCk/IFRoYXQgaXMgdGhlIG9ubHkNCj4gPiA+IHRoaW5nIEkgY2FuIHRoaW5rIG9mIHRo
YXQgd291bGQgc2hvdyBubyBiYWRibG9ja3MgaW4gdGhlIHN0cmFjZS4NCj4gPiANCj4gPiBZZXMs
IGl0IGhpdHMgdGhlIGVsc2UgY2FzZS7CoMKgTm90IHN1cmUgaWYgaXQncyByZWxhdGVkLCBidXQg
b3VyIHJhdw0KPiA+IGRldmljZSBkb2VzIG5vdCBoYXZlIGFueSBtZXRhZGF0YSBzbyBpdCBkb2Vz
IG5vdCBoYXZlIHV1aWQuDQo+IA0KPiBUaGUgcmF3IG5hbWVzcGFjZSBpcyBub3QgTkRfREVWSUNF
X05BTUVTUEFDRV9JTyBmb3IgeW91LiBNYXliZSB0aGF0J3MNCj4gY29ycmVsYXRlZCB0byBub3Qg
aGF2aW5nIHV1aWQ/IEkgY2FuIGFkZCBkdW1waW5nIG9mIGJhZGJsb2NrcyB0byB0aGUNCj4gZWxz
ZSBicmFuY2guIEVzc2VudGlhbGx5IGl0J3MgYSBwYXNzIHRocm91Z2ggb2YgdGhlIHJlZ2lvbiBi
YWRibG9ja3MNCj4gZm9yIHJhdyBucy4NCg0KT3VyIHJhdyBuYW1lc3BhY2UgX2lzXyBORF9ERVZJ
Q0VfTkFNRVNQQUNFX0lPLiAgWWVzLCBpdCBsb29rcyBsaWtlIHRoaXMNCmlzIGNhdXNpbmcgdGhl
IGlzc3VlLg0KDQpUaGFua3MsDQotVG9zaGkNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1t
QGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4
LW52ZGltbQo=
