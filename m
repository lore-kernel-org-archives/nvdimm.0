Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1B1C21A13493
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 14:29:06 -0700 (PDT)
Received: from G4W9122.americas.hpqcorp.net (g4w9122.houston.hp.com
 [16.210.21.17])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g4t3427.houston.hpe.com (Postfix) with ESMTPS id 0F5D369
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 21:29:06 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3 2/2] ndctl: add list --media-errors support
Date: Wed, 10 May 2017 21:28:08 +0000
Message-ID: <1494451676.30303.82.camel@hpe.com>
References: <149443923101.16024.9360569471346131929.stgit@djiang5-desk3.ch.intel.com>
 <149443929943.16024.5561881574160309534.stgit@djiang5-desk3.ch.intel.com>
 <1494441822.30303.77.camel@hpe.com>
 <e2873152-d765-4bcd-40c8-2f8caaa72803@intel.com>
 <1494449841.30303.80.camel@hpe.com>
 <c3b83dd6-e45a-82b5-92f9-c49e9d80ba3d@intel.com>
In-Reply-To: <c3b83dd6-e45a-82b5-92f9-c49e9d80ba3d@intel.com>
Content-Language: en-US
Content-ID: <FF459C85F9339E4A82B5AC00BD35DEE2@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gV2VkLCAyMDE3LTA1LTEwIGF0IDE0OjEzIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiAN
Cj4gT24gMDUvMTAvMjAxNyAwMTo1NyBQTSwgS2FuaSwgVG9zaGltaXRzdSB3cm90ZToNCj4gPiBP
biBXZWQsIDIwMTctMDUtMTAgYXQgMTI6NTYgLTA3MDAsIERhdmUgSmlhbmcgd3JvdGU6DQo+ID4g
PiANCj4gPiA+IE9uIDA1LzEwLzIwMTcgMTE6NDMgQU0sIEthbmksIFRvc2hpbWl0c3Ugd3JvdGU6
DQogOg0KPiA+IA0KPiA+IEF0dGFjaGVkICJzdHJhY2UubG9nIi7CoMKgTm90ZSwgdGhlcmUgaXMg
bm8gcmVmZXJlbmNlIHRvICJiYWRibG9ja3MiDQo+ID4gZmlsZXMgaW4gdGhlIGxvZy4NCj4gDQo+
IEhtbW0uLi4uaXMgdGhlcmUgYW55IHJlYXNvbiBteSByYXcgbmFtZXNwYWNlIGlzIGRpZmZlcmVu
dCB0eXBlIHRoYW4NCj4geW91cnM/IERvIHlvdSBrbm93IGlmIHlvdXJzIGhpdCB0aGUgZWxzZSBi
cmFuY2ggb24gdXRpbC9qc29uLmM6NTE2IGluDQo+IHV0aWxfbmFtZXNwYWNlX3RvX2pzb24oKT8g
VGhhdCBpcyB0aGUgb25seSB0aGluZyBJIGNhbiB0aGluayBvZiB0aGF0DQo+IHdvdWxkIHNob3cg
bm8gYmFkYmxvY2tzIGluIHRoZSBzdHJhY2UuDQoNClllcywgaXQgaGl0cyB0aGUgZWxzZSBjYXNl
LiAgTm90IHN1cmUgaWYgaXQncyByZWxhdGVkLCBidXQgb3VyIHJhdw0KZGV2aWNlIGRvZXMgbm90
IGhhdmUgYW55IG1ldGFkYXRhIHNvIGl0IGRvZXMgbm90IGhhdmUgdXVpZC4NCg0KVGhhbmtzLA0K
LVRvc2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxp
bnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczov
L2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
