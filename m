Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id C55221A1E01
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 10:16:17 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 1/3] pmem: clarify a debug print in pmem_clear_poison
Date: Tue, 19 Jul 2016 17:15:25 +0000
Message-ID: <1468948496.30121.60.camel@intel.com>
References: <1468889100-30698-1-git-send-email-vishal.l.verma@intel.com>
 <1468889100-30698-2-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4gpRGJLVfoC3o-rVypQtppkAKg1hObr=1EhcT3Y3g8KUw@mail.gmail.com>
In-Reply-To: <CAPcyv4gpRGJLVfoC3o-rVypQtppkAKg1hObr=1EhcT3Y3g8KUw@mail.gmail.com>
Content-Language: en-US
Content-ID: <5C8E6D11FD483341ADC3BB7B3F7C54B3@intel.com>
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
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Luck,, "Rafael J  <rafael.j.wysocki@intel.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE2LTA3LTE5IGF0IDA4OjUzIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIE1vbiwgSnVsIDE4LCAyMDE2IGF0IDU6NDQgUE0sIFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwu
dmVybWFAaW50ZWwuY28NCj4gbT4gd3JvdGU6DQo+ID4gUHJlZml4IHRoZSBzZWN0b3IgbnVtYmVy
IGJlaW5nIGNsZWFyZWQgd2l0aCBhICcweCcgdG8gbWFrZSBpdCBjbGVhcg0KPiA+IHRoYXQNCj4g
PiB0aGlzIGlzIGEgaGV4IHZhbHVlLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFZpc2hhbCBW
ZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+IMKgZHJpdmVycy9u
dmRpbW0vcG1lbS5jIHwgMiArLQ0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCsp
LCAxIGRlbGV0aW9uKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZkaW1tL3Bt
ZW0uYyBiL2RyaXZlcnMvbnZkaW1tL3BtZW0uYw0KPiA+IGluZGV4IDYwOGZjNDQuLjI5YWIyNWIg
MTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9udmRpbW0vcG1lbS5jDQo+ID4gKysrIGIvZHJpdmVy
cy9udmRpbW0vcG1lbS5jDQo+ID4gQEAgLTU3LDcgKzU3LDcgQEAgc3RhdGljIHZvaWQgcG1lbV9j
bGVhcl9wb2lzb24oc3RydWN0IHBtZW1fZGV2aWNlDQo+ID4gKnBtZW0sIHBoeXNfYWRkcl90IG9m
ZnNldCwNCj4gPiDCoMKgwqDCoMKgwqDCoMKgY2xlYXJlZCA9IG52ZGltbV9jbGVhcl9wb2lzb24o
ZGV2LCBwbWVtLT5waHlzX2FkZHIgKyBvZmZzZXQsDQo+ID4gbGVuKTsNCj4gPiANCj4gPiDCoMKg
wqDCoMKgwqDCoMKgaWYgKGNsZWFyZWQgPiAwICYmIGNsZWFyZWQgLyA1MTIpIHsNCj4gPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGV2X2RiZyhkZXYsICIlczogJWxseCBjbGVhciAl
bGQgc2VjdG9yJXNcbiIsDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRldl9k
YmcoZGV2LCAiJXM6IDB4JWxseCBjbGVhciAlbGQgc2VjdG9yJXNcbiIsDQo+IA0KPiAlI2xseCBp
cyBhIGJpdCBzbWFsbGVyIC8gbW9yZSByZWFkYWJsZS7CoMKgU2hhbGwgSSBqdXN0IGZpeCB0aGlz
IHVwIG9uDQo+IGFwcGx5aW5nPw0KDQpUSUwgOikgWWVzIHlvdSBjYW4gZG8gdGhlIGZpeHVwLCB0
aGFua3MhCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxp
bnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczov
L2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
