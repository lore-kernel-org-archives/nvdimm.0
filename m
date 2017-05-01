Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4E09721A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 16:07:05 -0700 (PDT)
Received: from G2W6311.americas.hpqcorp.net (g2w6311.austin.hp.com
 [16.197.64.53])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g2t2353.austin.hpe.com (Postfix) with ESMTPS id A6C5061
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 23:07:04 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v3] ndctl: add clear error support for ndctl
Date: Mon, 1 May 2017 23:06:35 +0000
Message-ID: <1493679994.30303.34.camel@hpe.com>
References: <149367376823.14721.16804310177322088175.stgit@djiang5-desk3.ch.intel.com>
 <1493676369.30303.30.camel@hpe.com>
 <ebf0cdd5-106c-9fb4-8272-589466423e9c@intel.com>
 <1493677696.30303.32.camel@hpe.com>
 <20170501224158.GA21546@djiang5-desk3.ch.intel.com>
In-Reply-To: <20170501224158.GA21546@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <4D039565EAF2544CBE24EDE6906C6464@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dave.jiang@intel.com" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE3LTA1LTAxIGF0IDE1OjQxIC0wNzAwLCBKaWFuZywgRGF2ZSB3cm90ZToNCj4g
T24gTW9uLCBNYXkgMDEsIDIwMTcgYXQgMDM6Mjg6MThQTSAtMDcwMCwgS2FuaSwgVG9zaGltaXRz
dSB3cm90ZToNCj4gPiBPbiBNb24sIDIwMTctMDUtMDEgYXQgMTU6MTYgLTA3MDAsIERhdmUgSmlh
bmcgd3JvdGU6DQo+ID4gPiANCj4gPiA+IE9uIDA1LzAxLzIwMTcgMDM6MDYgUE0sIEthbmksIFRv
c2hpbWl0c3Ugd3JvdGU6DQo+ID4gPiA+IE9uIE1vbiwgMjAxNy0wNS0wMSBhdCAxNDoyMyAtMDcw
MCwgRGF2ZSBKaWFuZyB3cm90ZToNCj4gPiA+ID4gwqA6DQo+ID4gPiA+ID4gKysrIGIvRG9jdW1l
bnRhdGlvbi9uZGN0bC1jbGVhci1lcnJvci50eHQNCj4gPiA+ID4gPiBAQCAtMCwwICsxLDM3IEBA
DQo+ID4gPiA+ID4gK25kY3RsLWNsZWFyLWVycm9yKDEpDQo+ID4gPiA+ID4gKz09PT09PT09PT09
PT09PT09PT09DQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICtOQU1FDQo+ID4gPiA+ID4gKy0tLS0N
Cj4gPiA+ID4gPiArbmRjdGwtY2xlYXItZXJyb3IgLSBjbGVhciBiYWRibG9ja3MgZm9yIGEgZGV2
aWNlDQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICtTWU5PUFNJUw0KPiA+ID4gPiA+ICstLS0tLS0t
LQ0KPiA+ID4gPiA+ICtbdmVyc2VdDQo+ID4gPiA+ID4gKyduZGN0bCBjbGVhci1lcnJvcicgWzxv
cHRpb25zPl0NCj4gPiA+ID4gPiArDQo+ID4gPiA+ID4gK0VYQU1QTEVTDQo+ID4gPiA+ID4gKy0t
LS0tLS0tDQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICtDbGVhciBwb2lzb24gKGJhZCBibG9ja3Mp
IGZvciB0aGUgcHJvdmlkZWQgZGV2aWNlDQo+ID4gPiA+ID4gK1t2ZXJzZV0NCj4gPiA+ID4gPiAr
bmRjdGwgY2xlYXItZXJyb3IgLWYgL2Rldi9kYXgwLjAgLXMgMCAtbCA4DQo+ID4gPiA+ID4gKw0K
PiA+ID4gPiA+ICtDbGVhciBwb2lzb24gKGJhZCBibG9ja3MpIGF0IGJsb2NrIG9mZnNldCAwIGZv
ciA4IGJsb2NrcyBvbg0KPiA+ID4gPiA+IGRldmljZQ0KPiA+ID4gPiA+IC9kZXYvZGF4MC4wDQo+
ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICtPUFRJT05TDQo+ID4gPiA+ID4gKy0tLS0tLS0NCj4gPiA+
ID4gPiArLWY6Og0KPiA+ID4gPiA+ICstLWZpbGU6Og0KPiA+ID4gPiA+ICtUaGUgZGV2aWNlL2Zp
bGUgdG8gYmUgY2xlYXJlZCBvZiBwb2lzb24gKGJhZCBibG9ja3MpLg0KPiA+ID4gPiA+ICsNCj4g
PiA+ID4gPiArLXM6Og0KPiA+ID4gPiA+ICstLXN0YXJ0OjoNCj4gPiA+ID4gPiArVGhlIG9mZnNl
dCB3aGVyZSB0aGUgcG9pc29uIChiYWQgYmxvY2spIHN0YXJ0cyBmb3IgdGhpcw0KPiA+ID4gPiA+
IGRldmljZS4NCj4gPiA+ID4gPiArVHlwaWNhbGx5IHRoaXMgaXMgYWNxdWlyZWQgZnJvbSB0aGUg
c3lzZnMgYmFkYmxvY2tzIGZpbGUuDQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICstbDo6DQo+ID4g
PiA+ID4gKy0tbGVuOjoNCj4gPiA+ID4gPiArVGhlIG51bWJlciBvZiBiYWRibG9ja3MgdG8gY2xl
YXIgaW4gc2l6ZSBvZiA1MTIgYnl0ZXMNCj4gPiA+ID4gPiBpbmNyZW1lbnRzLg0KPiA+ID4gPiA+
ICsNCj4gPiA+ID4gDQo+ID4gPiA+IFdoZW4gYSBzcGVjaWZpZWQgcmFuZ2UgaXMgbGFyZ2VyIHRo
YW4gYSBiYWRibG9jayByYW5nZSwgdGhlDQo+ID4gPiA+IGNvbW1hbmQgY29tcGxldGVzIHdpdGgg
bm8tb3Agd2l0aG91dCBhbnkgbWVzc2FnZS7CoMKgSSB0aGluayBpdA0KPiA+ID4gPiBzaG91bGQg
ZWl0aGVyIGZhaWwgd2l0aCBhbiBlcnJvciBtZXNzYWdlIG9yIGNsZWFyIGFuIGluY2x1c2l2ZQ0K
PiA+ID4gPiBiYWRibG9jay4NCj4gPiA+IA0KPiA+ID4gSXQncyBzdXBwb3NlIHRvIGp1c3QgZmFp
bC4gTG9va3MgbGlrZSBJIGp1c3QgZm9yZ290IHRvIGluc2VydCBhbg0KPiA+ID4gZXJyb3IgcHJp
bnQgb3V0Lg0KPiA+IA0KPiA+IFllcywgSSBhbSBmaW5lIHdpdGggdGhlIGJlaGF2aW9yIHdpdGgg
YSBwcm9wZXIgZXJyb3IgbWVzc2FnZS4gSXQnZA0KPiA+IGJlIGdvb2QgdG8gY2xhcmlmeSBpdCBp
biB0aGUgZG9jdW1lbnQgYXMgd2VsbC4NCj4gDQo+IC0twqANCj4gDQo+IERvZXMgc29tZXRoaW5n
IGxpa2UgdGhpcyB3b3JrIGZvciB5b3U/DQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmRjdGwvY2xlYXIt
ZXJyb3IuYyBiL25kY3RsL2NsZWFyLWVycm9yLmMNCj4gaW5kZXggMzNkOTMwYS4uMWE5Yjk0YSAx
MDA2NDQNCj4gLS0tIGEvbmRjdGwvY2xlYXItZXJyb3IuYw0KPiArKysgYi9uZGN0bC9jbGVhci1l
cnJvci5jDQo+IEBAIC0xNjcsNiArMTY3LDcgQEAgc3RhdGljIGludCBjbGVhcl9lcnJvcihzdHJ1
Y3QgY2xlYXJfZXJyICpjZSkNCj4gwqDCoMKgwqDCoMKgwqDCoGlmIChjaGVja191c2VyX2lucHV0
X3JhbmdlKGNlLT5yZWdpb24sIGNsZWFyX2Vyci5iYl9zdGFydCwNCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGNsZWFyX2Vy
ci5iYl9sZW4pID09IDApIHsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByYyA9
IC1FSU5WQUw7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlcnJvcigiYmFkYmxv
Y2tzIHJlZ2lvbiBpbnB1dCBvdXQgb2YgcmFuZ2UuXG4iKTsNCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBnb3RvIGNsZWFudXA7DQo+IMKgwqDCoMKgwqDCoMKgwqB9DQo+IMKgDQoN
ClllcywgaXQgbG9va3MgZ29vZCB0byBtZSBhcyB0aGlzIGVycm9yIHNob3dzIHVwIGluIGJvdGgg
emVybyBhbmQNCmluY2x1c2l2ZSBiYWRibG9jayBpbiB0aGUgaW5wdXQgcmFuZ2UuICBXZSBjYW4g
dXNlIHRoZSBkb2N1bWVudCB0bw0KZGVzY3JpYmUgdGhlIHJlc3RyaWN0aW9uIHRoYXQgYW4gaW5w
dXQgcmFuZ2UgbXVzdCBmaXQgaW50byBiYWRibG9ja3MNCnJhbmdlLg0KDQpUaGFua3MsDQotVG9z
aGkNCg0KDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpM
aW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6
Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
