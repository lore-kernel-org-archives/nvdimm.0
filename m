Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C24E721A134BC
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 10:07:31 -0700 (PDT)
Received: from G4W9120.americas.hpqcorp.net (exchangepmrr1.us.hpecorp.net
 [16.210.21.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by g9t5008.houston.hpe.com (Postfix) with ESMTPS id 5C76551
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 17:07:30 +0000 (UTC)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v6 2/3] ndctl: add list-errors support
Date: Fri, 5 May 2017 17:07:27 +0000
Message-ID: <1494004041.30303.59.camel@hpe.com>
References: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
 <149393454673.2642.10490569511477839936.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149393454673.2642.10490569511477839936.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <650128CB8B852045BF5B45D3C312A592@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gVGh1LCAyMDE3LTA1LTA0IGF0IDE0OjQ5IC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBB
ZGRpbmcgbGlzdC1lcnJvcnMgY29tbWFuZCB0byBzdXBwb3J0IGRpc3BsYXlpbmcgb2YgYWxsIGJh
ZGJsb2NrcyBpbg0KPiByZWxhdGlvbiB0byB0aGUgZGV2aWNlIHJhdGhlciB0aGFuIHRoZSByZWdp
b24uIFRoaXMgYWxsb3dzIHRoZSB1c2VyDQo+IHRvIGtub3cgd2hhdCBiYWRibG9ja3MgdG8gcGFz
cyBpbiB3aGVuIGRvaW5nIGNsZWFyLWVycm9yIGNhbGxzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
RGF2ZSBKaWFuZyA8ZGF2ZS5qaWFuZ0BpbnRlbC5jb20+DQo+IC0tLQ0KPiDCoERvY3VtZW50YXRp
b24vbmRjdGwtbGlzdC1lcnJvcnMudHh0IHzCoMKgwqAyNiArKysrKysrDQo+IMKgYnVpbHRpbi5o
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgfMKg
wqDCoMKgMcKgDQo+IMKgbmRjdGwvY2xlYXItZXJyb3IuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqB8wqDCoDEzMw0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0t
LQ0KPiDCoG5kY3RsL25kY3RsLmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgfMKgwqDCoMKgMcKgDQo+IMKgNCBmaWxlcyBjaGFuZ2VkLCAxNTEgaW5zZXJ0aW9u
cygrKSwgMTAgZGVsZXRpb25zKC0pDQo+IMKgY3JlYXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRp
b24vbmRjdGwtbGlzdC1lcnJvcnMudHh0DQo+IA0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlv
bi9uZGN0bC1saXN0LWVycm9ycy50eHQNCj4gYi9Eb2N1bWVudGF0aW9uL25kY3RsLWxpc3QtZXJy
b3JzLnR4dA0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwLi5mODMxYmEw
DQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIvRG9jdW1lbnRhdGlvbi9uZGN0bC1saXN0LWVycm9y
cy50eHQNCj4gQEAgLTAsMCArMSwyNiBAQA0KPiArbmRjdGwtbGlzdC1lcnJvcnMoMSkNCj4gKz09
PT09PT09PT09PT09PT09PT09DQo+ICsNCj4gK05BTUUNCj4gKy0tLS0NCj4gK25kY3RsLWxpc3Qt
ZXJyb3JzIC0gbGlzdCBiYWRibG9ja3Mgc3BlY2lmaWNhbGx5IGluIHJlbGF0aW9uIHRvIGENCj4g
ZGV2aWNlDQo+ICsNCj4gK1NZTk9QU0lTDQo+ICstLS0tLS0tLQ0KPiArW3ZlcnNlXQ0KPiArJ25k
Y3RsIGxpc3QtZXJyb3JzJyBbPG9wdGlvbnM+XQ0KPiArDQo+ICtFWEFNUExFUw0KPiArLS0tLS0t
LS0NCj4gKw0KPiArTGlzdCBiYWQgYmxvY2tzIGZvciB0aGUgcHJvdmlkZWQgZGV2aWNlDQo+ICtb
dmVyc2VdDQo+ICtuZGN0bCBsaXN0LWVycm9ycyAtZiAvZGV2L2RheDAuMA0KPiArDQo+ICtMaXN0
IGFsbCBiYWRibG9ja3MgZm9yIGRldmljZSAvZGV2L2RheDAuMC4NCg0KSGkgRGF2ZSwNCg0KSSBh
bSBub3QgZ2V0dGluZyBzZW5zaWJsZSB2YWx1ZXMgZnJvbSBsaXN0LWVycm9ycy4gIEFsc28sIHBs
ZWFzZQ0KZGVzY3JpYmUgdGhlIG91dHB1dCBmb3JtYXQgb2YgdGhpcyBjb21tYW5kIGluIHRoZSBk
b2N1bWVudC4NCg0KIyBjYXQgL3N5cy9idXMvbmQvZGV2aWNlcy9yZWdpb24wL3NpemUNCjE3MTc5
ODY5MTg0DQoNCiMgY2F0IC9zeXMvY2xhc3MvZGF4L2RheDAuMC9zaXplDQoxNjkwOTMzNjU3Ng0K
DQojIGNhdCAvc3lzL2J1cy9uZC9kZXZpY2VzL3JlZ2lvbjAvYmFkYmxvY2tzDQoxMDQ4NTc2IDEN
CjE1NzI4NjQgMQ0KDQojIG5kY3RsIGxpc3QtZXJyb3JzIC1mIC9kZXYvZGF4MC4wDQowIDMxNDU3
MjkNCjAgMzY3MDAxNw0KDQpUaGFua3MsDQotVG9zaGkNCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgt
bnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZv
L2xpbnV4LW52ZGltbQo=
