Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 83DD021A070BA
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 10:35:56 -0700 (PDT)
Received: from G9W8456.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net
 [16.216.161.95])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g4t3427.houston.hpe.com (Postfix) with ESMTPS id E1BB48C
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 17:35:55 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v6 2/3] ndctl: add list-errors support
Date: Fri, 5 May 2017 17:35:46 +0000
Message-ID: <1494005739.30303.65.camel@hpe.com>
References: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
 <149393454673.2642.10490569511477839936.stgit@djiang5-desk3.ch.intel.com>
 <1494004041.30303.59.camel@hpe.com>
 <caa48123-9daa-4ca6-2110-ef7e2a409ca3@intel.com>
 <1494004877.30303.61.camel@hpe.com>
 <92151b8e-8121-2b28-cc2d-c9f19bf9b5ef@intel.com>
In-Reply-To: <92151b8e-8121-2b28-cc2d-c9f19bf9b5ef@intel.com>
Content-Language: en-US
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

T24gRnJpLCAyMDE3LTA1LTA1IGF0IDEwOjI3IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiAN
Cj4gT24gMDUvMDUvMjAxNyAxMDoyMSBBTSwgS2FuaSwgVG9zaGltaXRzdSB3cm90ZToNCj4gPiBP
biBGcmksIDIwMTctMDUtMDUgYXQgMTA6MTQgLTA3MDAsIERhdmUgSmlhbmcgd3JvdGU6DQo+ID4g
PiANCj4gPiA+IE9uIDA1LzA1LzIwMTcgMTA6MDcgQU0sIEthbmksIFRvc2hpbWl0c3Ugd3JvdGU6
DQo+ID4gPiA+IE9uIFRodSwgMjAxNy0wNS0wNCBhdCAxNDo0OSAtMDcwMCwgRGF2ZSBKaWFuZyB3
cm90ZToNCj4gPiA+ID4gPiBBZGRpbmcgbGlzdC1lcnJvcnMgY29tbWFuZCB0byBzdXBwb3J0IGRp
c3BsYXlpbmcgb2YgYWxsDQo+ID4gPiA+ID4gYmFkYmxvY2tzIGluIHJlbGF0aW9uIHRvIHRoZSBk
ZXZpY2UgcmF0aGVyIHRoYW4gdGhlIHJlZ2lvbi4NCj4gPiA+ID4gPiBUaGlzIGFsbG93cyB0aGUg
dXNlciB0byBrbm93IHdoYXQgYmFkYmxvY2tzIHRvIHBhc3MgaW4gd2hlbg0KPiA+ID4gPiA+IGRv
aW5nIGNsZWFyLWVycm9yIGNhbGxzLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFNpZ25lZC1vZmYt
Ynk6IERhdmUgSmlhbmcgPGRhdmUuamlhbmdAaW50ZWwuY29tPg0KPiA+ID4gPiA+IC0tLQ0KPiA+
ID4gPiA+IMKgRG9jdW1lbnRhdGlvbi9uZGN0bC1saXN0LWVycm9ycy50eHQgfMKgwqDCoDI2ICsr
KysrKysNCj4gPiA+ID4gPiDCoGJ1aWx0aW4uaMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHzCoMKgwqDCoDENCj4gPiA+ID4gPiDCoG5kY3RsL2Ns
ZWFyLWVycm9yLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfMKgwqAxMzMNCj4g
PiA+ID4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLQ0KPiA+ID4gPiA+IMKg
bmRjdGwvbmRjdGwuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqB8wqDCoMKgwqAxDQo+ID4gPiA+ID4gwqA0IGZpbGVzIGNoYW5nZWQsIDE1MSBpbnNlcnRpb25z
KCspLCAxMCBkZWxldGlvbnMoLSkNCj4gPiA+ID4gPiDCoGNyZWF0ZSBtb2RlIDEwMDY0NCBEb2N1
bWVudGF0aW9uL25kY3RsLWxpc3QtZXJyb3JzLnR4dA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IGRp
ZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL25kY3RsLWxpc3QtZXJyb3JzLnR4dA0KPiA+ID4gPiA+
IGIvRG9jdW1lbnRhdGlvbi9uZGN0bC1saXN0LWVycm9ycy50eHQNCj4gPiA+ID4gPiBuZXcgZmls
ZSBtb2RlIDEwMDY0NA0KPiA+ID4gPiA+IGluZGV4IDAwMDAwMDAuLmY4MzFiYTANCj4gPiA+ID4g
PiAtLS0gL2Rldi9udWxsDQo+ID4gPiA+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9uZGN0bC1saXN0
LWVycm9ycy50eHQNCj4gPiA+ID4gPiBAQCAtMCwwICsxLDI2IEBADQo+ID4gPiA+ID4gK25kY3Rs
LWxpc3QtZXJyb3JzKDEpDQo+ID4gPiA+ID4gKz09PT09PT09PT09PT09PT09PT09DQo+ID4gPiA+
ID4gKw0KPiA+ID4gPiA+ICtOQU1FDQo+ID4gPiA+ID4gKy0tLS0NCj4gPiA+ID4gPiArbmRjdGwt
bGlzdC1lcnJvcnMgLSBsaXN0IGJhZGJsb2NrcyBzcGVjaWZpY2FsbHkgaW4gcmVsYXRpb24NCj4g
PiA+ID4gPiB0byBhDQo+ID4gPiA+ID4gZGV2aWNlDQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICtT
WU5PUFNJUw0KPiA+ID4gPiA+ICstLS0tLS0tLQ0KPiA+ID4gPiA+ICtbdmVyc2VdDQo+ID4gPiA+
ID4gKyduZGN0bCBsaXN0LWVycm9ycycgWzxvcHRpb25zPl0NCj4gPiA+ID4gPiArDQo+ID4gPiA+
ID4gK0VYQU1QTEVTDQo+ID4gPiA+ID4gKy0tLS0tLS0tDQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+
ICtMaXN0IGJhZCBibG9ja3MgZm9yIHRoZSBwcm92aWRlZCBkZXZpY2UNCj4gPiA+ID4gPiArW3Zl
cnNlXQ0KPiA+ID4gPiA+ICtuZGN0bCBsaXN0LWVycm9ycyAtZiAvZGV2L2RheDAuMA0KPiA+ID4g
PiA+ICsNCj4gPiA+ID4gPiArTGlzdCBhbGwgYmFkYmxvY2tzIGZvciBkZXZpY2UgL2Rldi9kYXgw
LjAuDQo+ID4gPiA+IA0KPiA+ID4gPiBIaSBEYXZlLA0KPiA+ID4gPiANCj4gPiA+ID4gSSBhbSBu
b3QgZ2V0dGluZyBzZW5zaWJsZSB2YWx1ZXMgZnJvbSBsaXN0LWVycm9ycy7CoMKgQWxzbywNCj4g
PiA+ID4gcGxlYXNlIGRlc2NyaWJlIHRoZSBvdXRwdXQgZm9ybWF0IG9mIHRoaXMgY29tbWFuZCBp
biB0aGUNCj4gPiA+ID4gZG9jdW1lbnQuDQo+ID4gPiA+IA0KPiA+ID4gPiAjIGNhdCAvc3lzL2J1
cy9uZC9kZXZpY2VzL3JlZ2lvbjAvc2l6ZQ0KPiA+ID4gPiAxNzE3OTg2OTE4NA0KPiA+ID4gPiAN
Cj4gPiA+ID4gIyBjYXQgL3N5cy9jbGFzcy9kYXgvZGF4MC4wL3NpemUNCj4gPiA+ID4gMTY5MDkz
MzY1NzYNCj4gPiA+ID4gDQo+ID4gPiA+ICMgY2F0IC9zeXMvYnVzL25kL2RldmljZXMvcmVnaW9u
MC9iYWRibG9ja3MNCj4gPiA+ID4gMTA0ODU3NiAxDQo+ID4gPiA+IDE1NzI4NjQgMQ0KPiA+ID4g
PiANCj4gPiA+ID4gIyBuZGN0bCBsaXN0LWVycm9ycyAtZiAvZGV2L2RheDAuMA0KPiA+ID4gPiAw
IDMxNDU3MjkNCj4gPiA+ID4gMCAzNjcwMDE3DQo+ID4gPiANCj4gPiA+IFRoYXQgaXMgdmVyeSBz
dHJhbmdlLiBJdCBsb29rcyBjb3JyZWN0IHdpdGggbmZpdF90ZXN0IGZvciBtZS4gSG93DQo+ID4g
PiBkbyBJIHJlcHJvZHVjZSB5b3VyIGNhc2Ugb3IgZG8gSSBhY3R1YWxseSBuZWVkIGFjdHVhbCBo
YXJkd2FyZT8NCj4gPiANCj4gPiBZZXMsIG15IHN0ZXBzIG5lZWQgYSBoYXJkd2FyZSwgYnV0IHRo
aXMgYmFkYmxvY2tzIGhhbmRsaW5nIGl0c2VsZg0KPiA+IHNob3VsZCBiZSBwbGF0Zm9ybS1pbmRl
cGVuZGVudC7CoMKgSSB3aWxsIGNoZWNrIHRvIHNlZSB3aHkgSSBnb3QNCj4gPiB0aGVzZSB2YWx1
ZXMuDQo+IA0KPiBUaGFua3MhIHdoYXQgaXMgeW91ciByZWdpb24vcmVzb3VyY2UgYW5kIGRheC9y
ZXNvdXJjZT8NCg0KU2VlIGF0dGFjaGVkLiBMZXQgbWUga25vdyBpZiB5b3UgbmVlZCBtb3JlIGlu
Zm8uDQoNClRoYW5rcywNCi1Ub3NoaQ0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
