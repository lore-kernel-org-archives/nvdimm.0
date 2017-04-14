Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6568D2194EB69
 for <linux-nvdimm@lists.01.org>; Fri, 14 Apr 2017 12:00:53 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, check: Add a sigbus handler to detect
 metadata corruption
Date: Fri, 14 Apr 2017 19:00:48 +0000
Message-ID: <1492196446.1657.1.camel@intel.com>
References: <20170414000251.23904-1-vishal.l.verma@intel.com>
 <F7CF62AA-B1F5-486D-AA87-F61674B86AC5@intel.com>
In-Reply-To: <F7CF62AA-B1F5-486D-AA87-F61674B86AC5@intel.com>
Content-Language: en-US
Content-ID: <6975FDCF6862D94BB2EB8CF578AFC2E8@intel.com>
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
To: "Rudoff, Andy" <andy.rudoff@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE3LTA0LTE0IGF0IDAwOjEwICswMDAwLCBSdWRvZmYsIEFuZHkgd3JvdGU6DQo+
ID4gSWYgd2UgaGF2ZSBwb2lzb24vYmFkYmxvY2tzIGluIHRoZSBCVFQgbWV0YWRhdGEgc2VjdGlv
bnMsIHRoZSBtbWFwLQ0KPiA+IHJlYWRzDQo+ID4gaGFwcGVuaW5nIGluIHRoZSBjaGVja2VyIHdp
bGwgdHJpZ2dlciBhIFNJR0JVUywgYW5kIHRoZSBwcm9ncmFtDQo+ID4gd2lsbA0KPiA+IGhhbHQg
YWJydXB0bHkuIEFkZCBhIHNpZ2J1cyBoYW5kbGVyIHdoaWNoIG5vdGlmaWVzIHRoZSB1c2VyIG9m
DQo+ID4gdGhpcywgYW5kDQo+ID4gcHJpbnRzIG91dCBhIHJlbGV2YW50IGVycm9yIG1lc3NhZ2U6
DQo+ID4gDQo+ID4gwqBuYW1lc3BhY2U1LjA6IG5hbWVzcGFjZV9jaGVjazogY2hlY2tpbmcgbmFt
ZXNwYWNlNS4wDQo+ID4gwqBuYW1lc3BhY2U1LjA6IGJ0dF9kaXNjb3Zlcl9hcmVuYXM6IGZvdW5k
IDEgQlRUIGFyZW5hDQo+ID4gwqBuYW1lc3BhY2U1LjA6IGJ0dF9jaGVja19hcmVuYXM6IGNoZWNr
aW5nIGFyZW5hIDANCj4gPiDCoG5hbWVzcGFjZTUuMDogbmFtZXNwYWNlX2NoZWNrOiBSZWNlaXZl
ZCBhIFNJR0JVUw0KPiA+IMKgbmFtZXNwYWNlNS4wOiBuYW1lc3BhY2VfY2hlY2s6IE1ldGFkYXRh
IGNvcnJ1cHRpb24gZm91bmQsIHJlY292ZXJ5DQo+ID4gaXMgbm90IHBvc3NpYmxlDQo+ID4gwqBl
cnJvciBjaGVja2luZyBuYW1lc3BhY2VzOiBCYWQgYWRkcmVzcw0KPiANCj4gSWYgaW4gcmVwYWly
IG1vZGUsIHNob3VsZCBhIFNJR0JVUyBjYXVzZSB5b3UgdG8gc2V0IHRoZSBlcnJvciBzdGF0ZQ0K
PiBpbiB0aGUgYXNzb2NpYXRlZCBhcmVuYT8NCj4gDQo+IC1hbmR5DQo+IA0KU28gSSB0aG91Z2h0
IGEgYml0IGFib3V0IHRoaXMgLQ0KV2hpbGUgd2UgY2FuIHNldCB0aGUgZXJyb3Igc3RhdGUsIHRo
YXQgbGVhdmVzIHRoZSBCVFQgd2l0aCBubyB3YXkgdG8NCmdldCBhbnkgZGF0YSBvZmYgaXQgKGN1
cnJlbnRseSkuDQoNCklmIHdlIGFsbG93IHRoZSBrZXJuZWwgdG8gZW5hYmxlIHRoZSBuYW1lc3Bh
Y2UsIHRoZSB1c2VyIGhhcyBzb21lDQpjaGFuY2UgdG8gZG8gYXQgbGVhc3QgcGFydGlhbCByZWNv
dmVyeSB1bnRpbCB0aGV5IGhpdCB0aGUgYmFkYmxvY2suDQooYXNzdW1pbmcgdGhlIGJhZGJsb2Nr
IGlzIGluIHRoZSBtYXAsIHdoaWNoIGlzIHRoZSBsYXJnZXN0IG9uLWRpc2sNCnN0cnVjdHVyZSku
IElmIGl0IGlzIG9uIHRoZSBmbG9nIG9yIGluZm8gYmxvY2ssIHRoZW4sIHllcywgdGhlcmUgaXMg
bm8NCnJlY292ZXJ5Lg0KDQoJLVZpc2hhbApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBs
aXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1u
dmRpbW0K
