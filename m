Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 29D9821A04E1D
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 08:55:22 -0700 (PDT)
Received: from G2W6309.americas.hpqcorp.net (g2w6309.austin.hp.com
 [16.197.64.51])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2352.austin.hpe.com (Postfix) with ESMTPS id 8A83543
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 15:55:21 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4 2/2] ndctl: add list --media-errors support
Date: Thu, 11 May 2017 15:55:19 +0000
Message-ID: <1494518108.30303.90.camel@hpe.com>
References: <149446050265.19998.6594654322891878230.stgit@djiang5-desk3.ch.intel.com>
 <149446059426.19998.8536490603388756669.stgit@djiang5-desk3.ch.intel.com>
 <1494516683.30303.88.camel@hpe.com>
 <CAPcyv4iTF0S1JgqTc04CJRkO7243AmNyr_kiPhPZq9a5+LLT-g@mail.gmail.com>
In-Reply-To: <CAPcyv4iTF0S1JgqTc04CJRkO7243AmNyr_kiPhPZq9a5+LLT-g@mail.gmail.com>
Content-Language: en-US
Content-ID: <01C8F862306A624A9DD3D8870F0B9DCD@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA1LTExIGF0IDA4OjM5IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgTWF5IDExLCAyMDE3IGF0IDg6MzEgQU0sIEthbmksIFRvc2hpbWl0c3UgPHRvc2hp
LmthbmlAaHBlLmNvbQ0KPiA+IHdyb3RlOg0KPiA+IE9uIFdlZCwgMjAxNy0wNS0xMCBhdCAxNjo1
NyAtMDcwMCwgRGF2ZSBKaWFuZyB3cm90ZToNCj4gPiA+IEFDUEkgTkZJVCBlbmFibGVkIHBsYXRm
b3JtcyBwcm92aWRlIG1lZGlhIGVycm9ycyBhcyBhYnNvbHV0ZQ0KPiA+ID4gcGh5aXNjYWwgYWRk
cmVzcyBvZmZzZXRzLiBBZGQgYW4gb3B0aW9uIHRvIG5kY3RsIHRvIGRpc3BsYXkgdGhvc2UNCj4g
PiA+IG1lZGlhIGVycm9ycyB0cmFubHNhdGVkIHRvIHJlZ2lvbiBhbmQgbmFtZXNwYWNlIGRldmlj
ZSBsZXZlbA0KPiA+ID4gb2Zmc2V0cyBpbiBhbiAibmRjdGwgbGlzdCIgbGlzdGluZy4gQlRUIGJh
ZGJsb2NrcyBzaG93IGlzIG5vdA0KPiA+ID4gc3VwcG9ydGVkIGluIHRoaXMgaXRlcmF0aW9uIGFu
ZCB3aWxsIGNvbWUgbGF0ZXIuDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IERhdmUgSmlh
bmcgPGRhdmUuamlhbmdAaW50ZWwuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiANCj4gPiA+IHYyOiBh
ZGRlZCBmaXggdG8gYmFkYmxvY2tzIGRpc3BsYXkgZnJvbSBUb3NoaSdzIHRlc3RpbmcgcmVzdWx0
Lg0KPiA+ID4gdjM6IGZpeGVkIG5hbWluZyBpc3N1ZXMgZnJvbSBEYW4ncyBjb21tZW50cy4NCj4g
PiA+IMKgwqDCoMKgZml4ZWQgYmFkYmxvY2tzIGJvdW5kYXJ5IG9mZnNldCBjYWxjdWxhdGlvbnMg
ZnJvbSBUb3NoaSdzDQo+ID4gPiB0ZXN0aW5nLg0KPiA+ID4gdjQ6IEFkZCBpbmRpY2F0b3IgdG8g
c2hvdyBiYWRibG9ja3MgZXhpc3Qgb3Igbm90LCBwZXIgVG9zaGkncw0KPiA+ID4gY29tbWVudHMu
DQo+ID4gDQo+ID4gVGhpcyB2ZXJzaW9uIHdvcmtzIHByZXR0eSBnb29kLCBleGNlcHQgdGhhdCBp
dCBkb2VzIG5vdCBzaG93DQo+ID4gImhhc19iYWRibG9ja3MiIGZvciBzZWN0b3IgbW9kZS4NCj4g
PiANCj4gPiAjIG5kY3RsIGxpc3QgLU0gLW0gc2VjdG9yDQo+ID4gew0KPiA+IMKgICJkZXYiOiJu
YW1lc3BhY2UwLjAiLA0KPiA+IMKgICJtb2RlIjoic2VjdG9yIiwNCj4gPiDCoCAic2l6ZSI6MTcx
NjIwMjcwMDgsDQo+ID4gwqAgInV1aWQiOiI3NzQyZGZmMy0zZWRkLTRhMjgtODk0ZC05YWMxYWVk
ZTZiMmMiLA0KPiA+IMKgICJzZWN0b3Jfc2l6ZSI6NDA5NiwNCj4gPiDCoCAiYmxvY2tkZXYiOiJw
bWVtMHMiDQo+ID4gfQ0KPiANCj4gU2luY2Ugd2UncmUgZ29pbmcgdG8gc3BpbiB0aGUgcGF0Y2gg
dG8gZml4IHRoaXMgdXAuLi4gVG9zaGksIHdoYXQgZG8NCj4geW91IHRoaW5rIGFib3V0IGNoYW5n
aW5nICJoYXNfYmFkYmxvY2tzIiB0byAiYmFkYmxvY2tfY291bnQiLiBNeQ0KPiBjb25jZXJuIGlz
IHRoYXQgZm9yIHRoZSBidHQgY2FzZSBpdCB3aWxsIGFsc28gY291bnQgYmFkYmxvY2tzIHRoYXQN
Cj4gYXJlIG9uIHRoZSBmcmVlIGxpc3Qgb3IgaW4gbWV0YWRhdGEsIGJ1dCBpdCBhdCBsZWFzdCBn
aXZlcyB5b3UgYQ0KPiBiZXR0ZXIgaW5kaWNhdGlvbiBvZiB0aGUgZGFtYWdlIGxldmVsIG9mIHRo
ZSB1bmRlcmx5aW5nIG5hbWVzcGFjZS4NCg0KR29vZCBpZGVhLiAgWWVzLCBJIGxpa2UgImJhZGJs
b2NrX2NvdW50IiBiZXR0ZXIuDQoNClRoYW5rcyENCi1Ub3NoaQpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0Ckxp
bnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0
aW5mby9saW51eC1udmRpbW0K
