Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-CY1-obe.outbound.protection.outlook.com
 (mail-cys01nam02on0726.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe45::726])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 93D6281EF0
 for <linux-nvdimm@lists.01.org>; Thu, 17 Nov 2016 08:35:01 -0800 (PST)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] libnvdimm: clear poison in mem map metadata
Date: Thu, 17 Nov 2016 16:35:04 +0000
Message-ID: <1479400371.20881.151.camel@hpe.com>
References: <147916930808.236748.8215175004635279925.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <147916930808.236748.8215175004635279925.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <19D31A9DFBE3994EAA895D59EB112B0F@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gTW9uLCAyMDE2LTExLTE0IGF0IDE3OjIxIC0wNzAwLCBEYXZlIEppYW5nIHdyb3RlOg0KPiBD
bGVhcmluZyBvdXQgdGhlIHBvaXNvbiBpbiB0aGUgbWV0YWRhdGEgYmxvY2sgb2YgdGhlIG5hbWVz
cGFjZSBiZWZvcmUNCj4gd2UgdXNlIGl0LiBSYW5nZSBmcm9tIHN0YXJ0ICsgOGsgdG8gcGZuX3Ni
LT5kYXRhb2ZmLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRGF2ZSBKaWFuZyA8ZGF2ZS5qaWFuZ0Bp
bnRlbC5jb20+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvbnZkaW1tL3Bmbl9kZXZzLmMgfMKgwqDCoDI0
ICsrKysrKysrKysrKysrKysrKysrKysrKw0KPiDCoDEgZmlsZSBjaGFuZ2VkLCAyNCBpbnNlcnRp
b25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9udmRpbW0vcGZuX2RldnMuYyBiL2Ry
aXZlcnMvbnZkaW1tL3Bmbl9kZXZzLmMNCj4gaW5kZXggY2VhODM1MC4uZmYzYjU1ZCAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9udmRpbW0vcGZuX2RldnMuYw0KPiArKysgYi9kcml2ZXJzL252ZGlt
bS9wZm5fZGV2cy5jDQo+IEBAIC01MjcsMTEgKzUyNywzNSBAQCBzdGF0aWMgc3RydWN0IHZtZW1f
YWx0bWFwDQo+ICpfX252ZGltbV9zZXR1cF9wZm4oc3RydWN0IG5kX3BmbiAqbmRfcGZuLA0KPiDC
oAkJLmJhc2VfcGZuID0gaW5pdF9hbHRtYXBfYmFzZShiYXNlKSwNCj4gwqAJCS5yZXNlcnZlID0g
aW5pdF9hbHRtYXBfcmVzZXJ2ZShiYXNlKSwNCj4gwqAJfTsNCj4gKwlzZWN0b3JfdCBzZWN0b3I7
DQo+ICsJcmVzb3VyY2Vfc2l6ZV90IG1ldGFfc3RhcnQsIG1ldGFfc2l6ZTsNCj4gKwlsb25nIGNs
ZWFyZWQ7DQo+ICsJdW5zaWduZWQgaW50IHN6X2FsaWduOw0KPiDCoA0KPiDCoAltZW1jcHkocmVz
LCAmbnNpby0+cmVzLCBzaXplb2YoKnJlcykpOw0KPiDCoAlyZXMtPnN0YXJ0ICs9IHN0YXJ0X3Bh
ZDsNCj4gwqAJcmVzLT5lbmQgLT0gZW5kX3RydW5jOw0KPiDCoA0KPiArCW1ldGFfc3RhcnQgPSBy
ZXMtPnN0YXJ0ICsgU1pfOEs7DQo+ICsJbWV0YV9zaXplID0gb2Zmc2V0IC0gbWV0YV9zdGFydCAr
IDE7DQo+ICsNCj4gKwlpZiAobWV0YV9zdGFydCArIG1ldGFfc2l6ZSA+IG9mZnNldCkNCj4gKwkJ
cmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7DQo+ICsNCj4gKwlzZWN0b3IgPSBtZXRhX3N0YXJ0ID4+
IDk7DQo+ICsJc3pfYWxpZ24gPSBBTElHTihtZXRhX3NpemUgKyAobWV0YV9zdGFydCAmICg1MTIg
LSAxKSksIDUxMik7DQoNClNob3VsZCB0aGlzIGJlIEFMSUdOX1VQPw0KDQo+ICsNCj4gKwlpZiAo
dW5saWtlbHkoaXNfYmFkX3BtZW0oJm5zaW8tPmJiLCBzZWN0b3IsIHN6X2FsaWduKSkpIHsNCj4g
KwkJaWYgKElTX0FMSUdORUQobWV0YV9zdGFydCwgNTEyKSAmJg0KPiBJU19BTElHTkVEKG1ldGFf
c2l6ZSwgNTEyKSkgew0KPiArCQkJY2xlYXJlZCA9IG52ZGltbV9jbGVhcl9wb2lzb24oJm5kX3Bm
bi0+ZGV2LA0KPiArCQkJCQkJwqDCoMKgwqDCoMKgbWV0YV9zdGFydCwNCj4gbWV0YV9zaXplKTsN
Cj4gKwkJCWJhZGJsb2Nrc19jbGVhcigmbnNpby0+YmIsIHNlY3RvciwgY2xlYXJlZA0KPiA+PiA5
KTsNCg0KJ2NsZWFyZWQnIGNhbiBiZSBhIG5lZ2F0aXZlIGVycm9yIHZhbHVlLCBzbyBJIGRvIG5v
dCB0aGluayB5b3UgY2FuDQpzaW1wbHkgcGFzcyBpdCB0byBiYWRibG9ja3NfY2xlYXIoKS4NCg0K
VGhhbmtzLA0KLVRvc2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9y
ZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
