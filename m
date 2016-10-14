Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam01on0712.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe42::712])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 159B21A1E9E
 for <linux-nvdimm@lists.01.org>; Fri, 14 Oct 2016 11:47:38 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] DAX: enable iostat for read/write
Date: Fri, 14 Oct 2016 18:47:36 +0000
Message-ID: <1476470760.20881.63.camel@hpe.com>
References: <1476465913-25305-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4gLTayEYpmEz0V-EjU4hmAVt9BCs_p8wqW=1kTfEakqMA@mail.gmail.com>
In-Reply-To: <CAPcyv4gLTayEYpmEz0V-EjU4hmAVt9BCs_p8wqW=1kTfEakqMA@mail.gmail.com>
Content-Language: en-US
Content-ID: <6B877BA1E93E4A41828FD5338365FA20@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE2LTEwLTE0IGF0IDEwOjM1IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIEZyaSwgT2N0IDE0LCAyMDE2IGF0IDEwOjI1IEFNLCBUb3NoaSBLYW5pIDx0b3NoaS5rYW5p
QGhwZS5jb20+DQo+IHdyb3RlOg0KPiA+IA0KPiA+IERBWCBJTyBwYXRoIGRvZXMgbm90IHN1cHBv
cnQgaW9zdGF0LCBidXQgaXRzIG1ldGFkYXRhIElPIHBhdGggZG9lcy4NCj4gPiBUaGVyZWZvcmUs
IGlvc3RhdCBzaG93cyBtZXRhZGF0YSBJTyBzdGF0aXN0aWNzIG9ubHksIHdoaWNoIGhhcyBiZWVu
DQo+ID4gY29uZnVzaW5nIHRvIHVzZXJzLg0KPiA+IA0KPiA+IEFkZCBpb3N0YXQgc3VwcG9ydCB0
byB0aGUgREFYIHJlYWQvd3JpdGUgcGF0aC4NCj4gPiANCj4gPiBOb3RlLCBpb3N0YXQgc3RpbGwg
ZG9lcyBub3Qgc3VwcG9ydCB0aGUgREFYIG1tYXAgcGF0aCBhcyBpdCBhbGxvd3MNCj4gPiB1c2Vy
IGFwcGxpY2F0aW9ucyB0byBhY2Nlc3MgZGlyZWN0bHkuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1i
eTogVG9zaGkgS2FuaSA8dG9zaGkua2FuaUBocGUuY29tPg0KPiA+IENjOiBBbmRyZXcgTW9ydG9u
IDxha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnPg0KPiA+IENjOiBBbGV4YW5kZXIgVmlybyA8dmly
b0B6ZW5pdi5saW51eC5vcmcudWs+DQo+ID4gQ2M6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlh
bXNAaW50ZWwuY29tPg0KPiA+IENjOiBSb3NzIFp3aXNsZXIgPHJvc3Muendpc2xlckBsaW51eC5p
bnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gwqBmcy9kYXguYyB8wqDCoMKgMzcgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDM3IGluc2Vy
dGlvbnMoKykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZnMvZGF4LmMgYi9mcy9kYXguYw0KPiA+
IGluZGV4IDAxNGRlZmQuLjNhYWFhYzIgMTAwNjQ0DQo+ID4gLS0tIGEvZnMvZGF4LmMNCj4gPiAr
KysgYi9mcy9kYXguYw0KPiA+IEBAIC0xNDQsNiArMTQ0LDM0IEBAIHN0YXRpYyBzZWN0b3JfdCB0
b19zZWN0b3IoY29uc3Qgc3RydWN0DQo+ID4gYnVmZmVyX2hlYWQgKmJoLA0KPiA+IMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gc2VjdG9yOw0KPiA+IMKgfQ0KPiA+IA0KPiA+ICtzdGF0aWMgdm9pZCBk
YXhfaW9zdGF0X3N0YXJ0KHN0cnVjdCBnZW5kaXNrICpkaXNrLCBzdHJ1Y3QgaW92X2l0ZXINCj4g
PiAqaXRlciwNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBsb25nICpzdGFydCkNCj4gPiArew0KPiA+ICvCoMKgwqDC
oMKgwqDCoGludCBydyA9IGlvdl9pdGVyX3J3KGl0ZXIpOw0KPiA+ICvCoMKgwqDCoMKgwqDCoGlu
dCBzZWMgPSBpb3ZfaXRlcl9jb3VudChpdGVyKSA+PiA5Ow0KPiANCj4gU2hvdWxkIHRoaXMgYmUg
YSBtaW5pbXVtIG9mIG9uZSBzZWN0b3Igc2luY2Ugd2UgYWxsb3cgdW5hbGlnbmVkDQo+IHRyYW5z
ZmVycyB0aHJvdWdoIHRoaXMgaW50ZXJmYWNlPw0KPiANCj4gLi4ub3IgaXMgaW92X2l0ZXJfY291
bnQoKSBzb21laG93IGd1YXJhbnRlZWQgdG8gYmUgc2VjdG9yIGFsaWduZWQNCj4gaGVyZT8NCg0K
WW91IGFyZSByaWdodC4gSSB3aWxsIHVwZGF0ZSB0byBzZXQgYSBtaW5pbXVtIG9mIG9uZSBzZWN0
b3IgaW4gdjIuwqANCg0KVGhhbmtzIQ0KLVRvc2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZk
aW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xp
bnV4LW52ZGltbQo=
