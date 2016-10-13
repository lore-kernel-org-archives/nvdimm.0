Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on0715.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe40::715])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 341CC1A1E92
 for <linux-nvdimm@lists.01.org>; Thu, 13 Oct 2016 09:08:04 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] pmem: report error on clear poison failure
Date: Thu, 13 Oct 2016 16:08:02 +0000
Message-ID: <1476374787.20881.34.camel@hpe.com>
References: <1476374061-9080-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4jdRhM8r1Ut4Ls4a4_PTroiXXZVcvruJ9TEj_SifenBCw@mail.gmail.com>
In-Reply-To: <CAPcyv4jdRhM8r1Ut4Ls4a4_PTroiXXZVcvruJ9TEj_SifenBCw@mail.gmail.com>
Content-Language: en-US
Content-ID: <D027AC5394CAF041AA3A22D7A3677681@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTEwLTEzIGF0IDA5OjAxIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgT2N0IDEzLCAyMDE2IGF0IDg6NTQgQU0sIFRvc2hpIEthbmkgPHRvc2hpLmthbmlA
aHBlLmNvbT4NCj4gd3JvdGU6DQo+ID4gDQo+ID4gQUNQSSBDbGVhciBVbmNvcnJlY3RhYmxlIEVy
cm9yIERTTSBmdW5jdGlvbiBtYXkgZmFpbCBvciBtYXkgYmUNCj4gPiB1bnN1cHBvcnRlZCBvbiBh
IHBsYXRmb3JtLsKgwqBwbWVtX2NsZWFyX3BvaXNvbigpIHJldHVybnMgd2l0aG91dA0KPiA+IGNs
ZWFyaW5nIGJhZGJsb2NrcyBpbiBzdWNoIGNhc2VzLCB3aGljaCBsZWFkcyB0byBhIHNpbGVudCBk
YXRhDQo+ID4gY29ycnVwdGlvbi4NCj4gPiANCj4gPiBDaGFuZ2UgcG1lbV9kb19idmVjKCkgYW5k
IHBtZW1fY2xlYXJfcG9pc29uKCkgdG8gcmV0dXJuIC1FSU8NCj4gPiBzbyB0aGF0IGZpbGVzeXN0
ZW0gY2FuIGxvZyBhbiBlcnJvciBtZXNzYWdlLg0KPiANCj4gV2hhdCdzIHRoZSBzaWxlbnQgZGF0
YSBjb3JydXB0aW9uIHNjZW5hcmlvP8KgwqBJZiB0aGUgY2xlYXIgcG9pc29uDQo+IGZhaWxzIEkn
bSBhc3N1bWluZyB0aGF0IHRoZSBwb2lzb24gd2lsbCBzdGlsbCBiZSBub3RpZmllZCBvbiB0aGUg
bmV4dA0KPiByZWFkLg0KDQpJIGFncmVlIHRoYXQgdGhlIGRhdGEgaXMgZXZlbnR1YWxseSByZWFk
LCBidXQgdGhlcmUgaXMgbm8gZ3VyYW50ZWVkDQp0aGF0IHdoZW4gaXQgaXMgcmVhZCBzb29uIGVu
b3VnaCwgaS5lLiB1c2VyIG1pZ2h0IG5vdCBhY2Nlc3MgdG8gdGhlDQpkYXRhIGZvciBhIGxvbmcg
dGltZS4NCg0KVGhhbmtzLA0KLVRvc2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxp
c3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52
ZGltbQo=
