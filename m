Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E19B31A1E6E
 for <linux-nvdimm@lists.01.org>; Thu,  8 Sep 2016 17:29:00 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] libnvdimm: allow legacy (e820) pmem region to clear bad
 blocks
Date: Fri, 9 Sep 2016 00:28:59 +0000
Message-ID: <1473380906.3095.9.camel@intel.com>
References: <147337760801.38083.16900960834862325097.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <147337760801.38083.16900960834862325097.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <855F2C703FB85942A5302579D5CB70D1@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTA5LTA4IGF0IDE2OjMzIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBC
YWQgYmxvY2tzIGNhbiBiZSBpbmplY3RlZCB2aWEgL3N5cy9ibG9jay9wbWVtTi9iYWRibG9ja3Mu
IEluIGENCj4gc2l0dWF0aW9uDQo+IHdoZXJlIGxlZ2FjeSBwbWVtIGlzIGJlaW5nIHVzZWQgb3Ig
YSBwbWVtIHJlZ2lvbiBjcmVhdGVkIGJ5IHVzaW5nDQo+IG1lbW1hcA0KPiBrZXJuZWwgcGFyYW1l
dGVyLCB0aGUgaW5qZWN0ZWQgYmFkIGJsb2NrcyBhcmUgbm90IGNsZWFyZWQgZHVlIHRvDQo+IG52
ZGltbV9jbGVhcl9wb2lzb24oKSBmYWlsaW5nIGZyb20gbGFjayBvZiBuZGN0bCBmdW5jdGlvbiBw
b2ludGVyLiBJbg0KPiB0aGlzIGNhc2Ugd2UgbmVlZCB0byBqdXN0IHJldHVybiBhcyBoYW5kbGVk
IGFuZCBhbGxvdyB0aGUgYmFkIGJsb2Nrcw0KPiB0bw0KPiBiZSBjbGVhcmVkIHJhdGhlciB0aGFu
IGZhaWwuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIEppYW5nIDxkYXZlLmppYW5nQGludGVs
LmNvbT4NCj4gLS0tDQo+IMKgZHJpdmVycy9udmRpbW0vYnVzLmMgfMKgwqDCoMKgNiArKysrKy0N
Cj4gwqAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCkxv
b2tzIGdvb2QgdG8gbWUhDQpSZXZlaWV3ZWQtYnk6IFZpc2hhbCBWZXJtYSA8VmlzaGFsLmwudmVy
bWFAaW50ZWwuY29tPg0KDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9udmRpbW0vYnVzLmMg
Yi9kcml2ZXJzL252ZGltbS9idXMuYw0KPiBpbmRleCA0NThkYWY5Li45MzU4NjZmIDEwMDY0NA0K
PiAtLS0gYS9kcml2ZXJzL252ZGltbS9idXMuYw0KPiArKysgYi9kcml2ZXJzL252ZGltbS9idXMu
Yw0KPiBAQCAtMTg1LDggKzE4NSwxMiBAQCBsb25nIG52ZGltbV9jbGVhcl9wb2lzb24oc3RydWN0
IGRldmljZSAqZGV2LA0KPiBwaHlzX2FkZHJfdCBwaHlzLA0KPiDCoAkJcmV0dXJuIC1FTlhJTzsN
Cj4gwqANCj4gwqAJbmRfZGVzYyA9IG52ZGltbV9idXMtPm5kX2Rlc2M7DQo+ICsJLyoNCj4gKwnC
oCogaWYgbmRjdGwgZG9lcyBub3QgZXhpc3QsIGl0J3MgUE1FTV9MRUdBQ1kgYW5kDQo+ICsJwqAq
IHdlIHdhbnQgdG8ganVzdCBwcmV0ZW5kIGV2ZXJ5dGhpbmcgaXMgaGFuZGxlZC4NCj4gKwnCoCov
DQo+IMKgCWlmICghbmRfZGVzYy0+bmRjdGwpDQo+IC0JCXJldHVybiAtRU5YSU87DQo+ICsJCXJl
dHVybiBsZW47DQo+IMKgDQo+IMKgCW1lbXNldCgmYXJzX2NhcCwgMCwgc2l6ZW9mKGFyc19jYXAp
KTsNCj4gwqAJYXJzX2NhcC5hZGRyZXNzID0gcGh5czsNCj4gCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2xpbnV4LW52ZGltbQo=
