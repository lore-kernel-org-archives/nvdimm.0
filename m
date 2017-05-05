Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 905F521A134BC
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 10:21:33 -0700 (PDT)
Received: from G9W8454.americas.hpqcorp.net (g9w8454.houston.hp.com
 [16.216.161.4])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g4t3427.houston.hpe.com (Postfix) with ESMTPS id C324A63
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 17:21:32 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v6 2/3] ndctl: add list-errors support
Date: Fri, 5 May 2017 17:21:23 +0000
Message-ID: <1494004877.30303.61.camel@hpe.com>
References: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
 <149393454673.2642.10490569511477839936.stgit@djiang5-desk3.ch.intel.com>
 <1494004041.30303.59.camel@hpe.com>
 <caa48123-9daa-4ca6-2110-ef7e2a409ca3@intel.com>
In-Reply-To: <caa48123-9daa-4ca6-2110-ef7e2a409ca3@intel.com>
Content-Language: en-US
Content-ID: <DCFA050D311FE04EA195D6451EAED7F9@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gRnJpLCAyMDE3LTA1LTA1IGF0IDEwOjE0IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiAN
Cj4gT24gMDUvMDUvMjAxNyAxMDowNyBBTSwgS2FuaSwgVG9zaGltaXRzdSB3cm90ZToNCj4gPiBP
biBUaHUsIDIwMTctMDUtMDQgYXQgMTQ6NDkgLTA3MDAsIERhdmUgSmlhbmcgd3JvdGU6DQo+ID4g
PiBBZGRpbmcgbGlzdC1lcnJvcnMgY29tbWFuZCB0byBzdXBwb3J0IGRpc3BsYXlpbmcgb2YgYWxs
IGJhZGJsb2Nrcw0KPiA+ID4gaW4gcmVsYXRpb24gdG8gdGhlIGRldmljZSByYXRoZXIgdGhhbiB0
aGUgcmVnaW9uLiBUaGlzIGFsbG93cyB0aGUNCj4gPiA+IHVzZXIgdG8ga25vdyB3aGF0IGJhZGJs
b2NrcyB0byBwYXNzIGluIHdoZW4gZG9pbmcgY2xlYXItZXJyb3INCj4gPiA+IGNhbGxzLg0KPiA+
ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIEppYW5nIDxkYXZlLmppYW5nQGludGVsLmNv
bT4NCj4gPiA+IC0tLQ0KPiA+ID4gwqBEb2N1bWVudGF0aW9uL25kY3RsLWxpc3QtZXJyb3JzLnR4
dCB8wqDCoMKgMjYgKysrKysrKw0KPiA+ID4gwqBidWlsdGluLmjCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB8wqDCoMKgwqAxDQo+ID4gPiDCoG5k
Y3RsL2NsZWFyLWVycm9yLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfMKgwqAx
MzMNCj4gPiA+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tDQo+ID4gPiDCoG5k
Y3RsL25kY3RsLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
fMKgwqDCoMKgMQ0KPiA+ID4gwqA0IGZpbGVzIGNoYW5nZWQsIDE1MSBpbnNlcnRpb25zKCspLCAx
MCBkZWxldGlvbnMoLSkNCj4gPiA+IMKgY3JlYXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24v
bmRjdGwtbGlzdC1lcnJvcnMudHh0DQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9Eb2N1bWVu
dGF0aW9uL25kY3RsLWxpc3QtZXJyb3JzLnR4dA0KPiA+ID4gYi9Eb2N1bWVudGF0aW9uL25kY3Rs
LWxpc3QtZXJyb3JzLnR4dA0KPiA+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiA+IGluZGV4
IDAwMDAwMDAuLmY4MzFiYTANCj4gPiA+IC0tLSAvZGV2L251bGwNCj4gPiA+ICsrKyBiL0RvY3Vt
ZW50YXRpb24vbmRjdGwtbGlzdC1lcnJvcnMudHh0DQo+ID4gPiBAQCAtMCwwICsxLDI2IEBADQo+
ID4gPiArbmRjdGwtbGlzdC1lcnJvcnMoMSkNCj4gPiA+ICs9PT09PT09PT09PT09PT09PT09PQ0K
PiA+ID4gKw0KPiA+ID4gK05BTUUNCj4gPiA+ICstLS0tDQo+ID4gPiArbmRjdGwtbGlzdC1lcnJv
cnMgLSBsaXN0IGJhZGJsb2NrcyBzcGVjaWZpY2FsbHkgaW4gcmVsYXRpb24gdG8gYQ0KPiA+ID4g
ZGV2aWNlDQo+ID4gPiArDQo+ID4gPiArU1lOT1BTSVMNCj4gPiA+ICstLS0tLS0tLQ0KPiA+ID4g
K1t2ZXJzZV0NCj4gPiA+ICsnbmRjdGwgbGlzdC1lcnJvcnMnIFs8b3B0aW9ucz5dDQo+ID4gPiAr
DQo+ID4gPiArRVhBTVBMRVMNCj4gPiA+ICstLS0tLS0tLQ0KPiA+ID4gKw0KPiA+ID4gK0xpc3Qg
YmFkIGJsb2NrcyBmb3IgdGhlIHByb3ZpZGVkIGRldmljZQ0KPiA+ID4gK1t2ZXJzZV0NCj4gPiA+
ICtuZGN0bCBsaXN0LWVycm9ycyAtZiAvZGV2L2RheDAuMA0KPiA+ID4gKw0KPiA+ID4gK0xpc3Qg
YWxsIGJhZGJsb2NrcyBmb3IgZGV2aWNlIC9kZXYvZGF4MC4wLg0KPiA+IA0KPiA+IEhpIERhdmUs
DQo+ID4gDQo+ID4gSSBhbSBub3QgZ2V0dGluZyBzZW5zaWJsZSB2YWx1ZXMgZnJvbSBsaXN0LWVy
cm9ycy7CoMKgQWxzbywgcGxlYXNlDQo+ID4gZGVzY3JpYmUgdGhlIG91dHB1dCBmb3JtYXQgb2Yg
dGhpcyBjb21tYW5kIGluIHRoZSBkb2N1bWVudC4NCj4gPiANCj4gPiAjIGNhdCAvc3lzL2J1cy9u
ZC9kZXZpY2VzL3JlZ2lvbjAvc2l6ZQ0KPiA+IDE3MTc5ODY5MTg0DQo+ID4gDQo+ID4gIyBjYXQg
L3N5cy9jbGFzcy9kYXgvZGF4MC4wL3NpemUNCj4gPiAxNjkwOTMzNjU3Ng0KPiA+IA0KPiA+ICMg
Y2F0IC9zeXMvYnVzL25kL2RldmljZXMvcmVnaW9uMC9iYWRibG9ja3MNCj4gPiAxMDQ4NTc2IDEN
Cj4gPiAxNTcyODY0IDENCj4gPiANCj4gPiAjIG5kY3RsIGxpc3QtZXJyb3JzIC1mIC9kZXYvZGF4
MC4wDQo+ID4gMCAzMTQ1NzI5DQo+ID4gMCAzNjcwMDE3DQo+IA0KPiBUaGF0IGlzIHZlcnkgc3Ry
YW5nZS4gSXQgbG9va3MgY29ycmVjdCB3aXRoIG5maXRfdGVzdCBmb3IgbWUuIEhvdyBkbw0KPiBJ
IHJlcHJvZHVjZSB5b3VyIGNhc2Ugb3IgZG8gSSBhY3R1YWxseSBuZWVkIGFjdHVhbCBoYXJkd2Fy
ZT8NCg0KWWVzLCBteSBzdGVwcyBuZWVkIGEgaGFyZHdhcmUsIGJ1dCB0aGlzIGJhZGJsb2NrcyBo
YW5kbGluZyBpdHNlbGYNCnNob3VsZCBiZSBwbGF0Zm9ybS1pbmRlcGVuZGVudC4gIEkgd2lsbCBj
aGVjayB0byBzZWUgd2h5IEkgZ290IHRoZXNlDQp2YWx1ZXMuDQoNClRoYW5rcywNCi1Ub3NoaQ0K
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZk
aW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMu
MDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
