Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 63D252195406C
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 16:14:15 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] test: regression test for a kernel panic on running ARS
 for BTTs
Date: Thu, 27 Apr 2017 23:14:13 +0000
Message-ID: <1493334771.30844.6.camel@intel.com>
References: <20170427223956.9216-1-vishal.l.verma@intel.com>
 <CAPcyv4jPD1vvtdnw1-eaTNz_PfPQwutFAd3kBCqB2XsptT3TFw@mail.gmail.com>
In-Reply-To: <CAPcyv4jPD1vvtdnw1-eaTNz_PfPQwutFAd3kBCqB2XsptT3TFw@mail.gmail.com>
Content-Language: en-US
Content-ID: <641AE597E8D1C4479E4D26A84EE4A10A@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTA0LTI3IGF0IDE2OjA2IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgQXByIDI3LCAyMDE3IGF0IDM6MzkgUE0sIFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwu
dmVybWFAaW50ZWwuY28NCj4gbT4gd3JvdGU6DQo+ID4gUnVuaW5nIGFuIEFkZHJlc3MgUmFuZ2Ug
U2NydWIgb24gYSByZWdpb24gd2l0aCBhIEJUVCBuYW1lc3BhY2Ugd291bGQNCj4gPiBjYXVzZSBh
IGtlcm5lbCBudWxsIHBvaW50ZXIgZGVyZWZlcmVuY2UuIFRoaXMgdGVzdHMgd2UgZG9uJ3QgcmVn
cmVzcw0KPiA+IHRoYXQuDQo+ID4gDQo+ID4gQ2M6IFRvc2hpIEthbmkgPHRvc2hpLmthbmlAaHBl
LmNvbT4NCj4gPiBDYzogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+
ID4gU2lnbmVkLW9mZi1ieTogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBpbnRlbC5jb20+
DQo+ID4gLS0tDQo+ID4gwqB0ZXN0L01ha2VmaWxlLmFtwqDCoMKgwqDCoMKgfMKgwqAzICstDQo+
ID4gwqB0ZXN0L2J0dC1hcnMtcGFuaWMuc2ggfCA5Mw0KPiA+ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+IMKgMiBmaWxlcyBjaGFuZ2VkLCA5
NSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+ID4gwqBjcmVhdGUgbW9kZSAxMDA3NTUg
dGVzdC9idHQtYXJzLXBhbmljLnNoDQo+ID4gDQpbLi5dDQo+ID4gK3Rlc3RfcGFzcygpDQo+ID4g
K3sNCj4gPiArwqDCoMKgwqDCoMKgwqAjIElmIHRoZSB0ZXN0IGZhaWxlZCwgdGhlcmUgd291bGQg
aGF2ZSBiZWVuIGEga2VybmVsIG51bGwNCj4gPiBwb2ludGVyDQo+ID4gK8KgwqDCoMKgwqDCoMKg
IyBkZXJlZmVyZW5jZSwgYW5kIGEgc3Vic2VxdWVudCBuZGN0bCBkaXNhYmxlLXJlZ2lvbiB3b3Vs
ZA0KPiA+IGhhbmcNCj4gPiArwqDCoMKgwqDCoMKgwqAkbmRjdGwgZGlzYWJsZS1yZWdpb24gYWxs
ICYNCj4gDQo+IFRlc3QgbG9va3MgZ29vZC4gVGhpcyBsaW5lIG1ha2VzIG1lIHRoaW5rIHdlIG5l
ZWQgc29tZXRoaW5nIGxpa2UNCj4gIm5kY3RsIHdhaXQtc2NydWItYnVzIi4NCg0KWWVzLCBwZXJo
YXBzIGFsc28gc29tZXRoaW5nIHRvIHN0YXJ0IGEgc2NydWIuLgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0Ckxp
bnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0
aW5mby9saW51eC1udmRpbW0K
