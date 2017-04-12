Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C55C21A0483A
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 13:27:07 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking'
 from 'atomic'
Date: Wed, 12 Apr 2017 20:27:05 +0000
Message-ID: <1492028744.2738.14.camel@intel.com>
References: <20170411224457.24777-1-vishal.l.verma@intel.com>
 <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
 <20170412195903.GA29506@omniknight.lm.intel.com>
 <20170412202238.5d327vmwjqvbzzop@pd.tnic>
In-Reply-To: <20170412202238.5d327vmwjqvbzzop@pd.tnic>
Content-Language: en-US
Content-ID: <FEF137F316E1DC44A49E0F2DDE05F219@intel.com>
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
To: "bp@suse.de" <bp@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE3LTA0LTEyIGF0IDIyOjIyICswMjAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIFdlZCwgQXByIDEyLCAyMDE3IGF0IDAxOjU5OjAzUE0gLTA2MDAsIFZpc2hhbCBWZXJt
YSB3cm90ZToNCj4gPiBJIGRvbid0IHRoaW5rIHdlIGNhbiBkbyBhbnl0aGluZyBhYm91dCB0aGUg
cGFuaWMgcGF0aCBlcnJvcnMuDQo+IA0KPiBUaGVuIHRoZSBmaXggc2hvdWxkIGJlIGEgbG90IGVh
c2llcjoNCj4gDQo+IC0tLQ0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9hY3BpL25maXQvbWNlLmMg
Yi9kcml2ZXJzL2FjcGkvbmZpdC9tY2UuYw0KPiBpbmRleCAzYmExYzM0NzJjZjkuLjQ0YzA5MmVj
MmFjOSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9hY3BpL25maXQvbWNlLmMNCj4gKysrIGIvZHJp
dmVycy9hY3BpL25maXQvbWNlLmMNCj4gQEAgLTI1LDYgKzI1LDkgQEAgc3RhdGljIGludCBuZml0
X2hhbmRsZV9tY2Uoc3RydWN0IG5vdGlmaWVyX2Jsb2NrDQo+ICpuYiwgdW5zaWduZWQgbG9uZyB2
YWwsDQo+IMKgCXN0cnVjdCBhY3BpX25maXRfZGVzYyAqYWNwaV9kZXNjOw0KPiDCoAlzdHJ1Y3Qg
bmZpdF9zcGEgKm5maXRfc3BhOw0KPiDCoA0KPiArCWlmIChpbl9hdG9taWMoKSkNCj4gKwkJcmV0
dXJuIE5PVElGWV9ET05FOw0KDQpCdXQgaXNuJ3QgdGhlIGF0b21pYyBub3RpZmllciBjYWxsIGNo
YWluIGFsd2F5cyBjYWxsZWQgaW4gYXRvbWljDQpjb250ZXh0Pw0KDQo+ICsNCj4gwqAJLyogV2Ug
b25seSBjYXJlIGFib3V0IG1lbW9yeSBlcnJvcnMgKi8NCj4gwqAJaWYgKCEobWNlLT5zdGF0dXMg
JiBNQ0FDT0QpKQ0KPiDCoAkJcmV0dXJuIE5PVElGWV9ET05FOw0KPiANCj4gDQo+IC0twqANCj4g
UmVnYXJkcy9HcnVzcywNCj4gwqDCoMKgwqBCb3Jpcy4NCj4gDQo+IFNVU0UgTGludXggR21iSCwg
R0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgSmFuZSBTbWl0aGFyZCwgR3JhaGFtIE5vcnRvbiwNCj4g
SFJCIDIxMjg0IChBRyBOw7xybmJlcmcpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxp
c3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52
ZGltbQo=
