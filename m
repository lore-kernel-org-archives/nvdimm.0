Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-SN1-obe.outbound.protection.outlook.com
 (mail-sn1nam01on0708.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe40::708])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3EEF31A1E10
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 12:12:20 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] DAX: enable iostat for read/write
Date: Mon, 17 Oct 2016 19:12:18 +0000
Message-ID: <1476731438.20881.73.camel@hpe.com>
References: <1476465913-25305-1-git-send-email-toshi.kani@hpe.com>
 <20161015075443.GG27872@dastard> <1476725956.20881.68.camel@hpe.com>
 <CAPcyv4h-5CUs8iApR5=_M_qx1oMuVq5vkyOej6Ci=B5oj-Bs-g@mail.gmail.com>
In-Reply-To: <CAPcyv4h-5CUs8iApR5=_M_qx1oMuVq5vkyOej6Ci=B5oj-Bs-g@mail.gmail.com>
Content-Language: en-US
Content-ID: <F3C02B1C5BE0C248A3A145B9AB960760@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCAyMDE2LTEwLTE3IGF0IDExOjU1IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIE1vbiwgT2N0IDE3LCAyMDE2IGF0IDEwOjQwIEFNLCBLYW5pLCBUb3NoaW1pdHN1IDx0b3No
aS5rYW5pQGhwZS5jbw0KPiBtPiB3cm90ZToNCj4gPiANCj4gPiBPbiBTYXQsIDIwMTYtMTAtMTUg
YXQgMTg6NTQgKzExMDAsIERhdmUgQ2hpbm5lciB3cm90ZToNCj4gPiA+IA0KPiA+ID4gT24gRnJp
LCBPY3QgMTQsIDIwMTYgYXQgMTE6MjU6MTNBTSAtMDYwMCwgVG9zaGkgS2FuaSB3cm90ZToNCj4g
PiDCoDoNCj4gPiA+IA0KPiA+ID4gPiANCj4gPiA+ID4gK3N0YXRpYyB2b2lkIGRheF9pb3N0YXRf
c3RhcnQoc3RydWN0IGdlbmRpc2sgKmRpc2ssIHN0cnVjdA0KPiA+ID4gPiBpb3ZfaXRlcg0KPiA+
ID4gPiAqaXRlciwNCj4gPiA+ID4gK8KgwqDCoMKgwqB1bnNpZ25lZCBsb25nICpzdGFydCkNCj4g
PiA+ID4gK3sNCj4gPiA+ID4gK2ludCBydyA9IGlvdl9pdGVyX3J3KGl0ZXIpOw0KPiA+ID4gPiAr
aW50IHNlYyA9IGlvdl9pdGVyX2NvdW50KGl0ZXIpID4+IDk7DQo+ID4gPiA+ICtpbnQgY3B1ID0g
cGFydF9zdGF0X2xvY2soKTsNCj4gPiA+ID4gKw0KPiA+ID4gPiArKnN0YXJ0ID0gamlmZmllczsN
Cj4gPiA+ID4gK3BhcnRfcm91bmRfc3RhdHMoY3B1LCAmZGlzay0+cGFydDApOw0KPiA+ID4gPiAr
cGFydF9zdGF0X2luYyhjcHUsICZkaXNrLT5wYXJ0MCwgaW9zW3J3XSk7DQo+ID4gPiA+ICtwYXJ0
X3N0YXRfYWRkKGNwdSwgJmRpc2stPnBhcnQwLCBzZWN0b3JzW3J3XSwgc2VjKTsNCj4gPiA+ID4g
K3BhcnRfaW5jX2luX2ZsaWdodCgmZGlzay0+cGFydDAsIHJ3KTsNCj4gPiA+ID4gK3BhcnRfc3Rh
dF91bmxvY2soKTsNCj4gPiA+ID4gK30NCj4gPiA+IA0KPiA+ID4gV2h5IHJlaW1wbGVtZW50IGdl
bmVyaWNfc3RhcnRfaW9fYWNjdCgpIGFuZA0KPiA+ID4gZ2VuZXJpY19lbmRfaW9fYWNjdCgpPw0K
PiA+IA0KPiA+IEl0IHdhcyBtb2RlbGVkIGFmdGVyIF9fbmRfaW9zdGF0X3N0YXJ0KCkgLyBuZF9p
b3N0YXJ0X2VuZCgpLsKgwqBJDQo+ID4gYWdyZWUgdGhhdCB3ZSBjYW4gdXNlIGdlbmVyaWNfc3Rh
cnRfaW9fYWNjdCgpIGFuZA0KPiA+IGdlbmVyaWNfZW5kX2lvX2FjY3QoKSBoZXJlLg0KPiA+IA0K
PiA+IFNob3VsZCB3ZSBhbHNvIGNoYW5nZSB0aGUgbmQgaW50ZXJmYWNlIHRvIHVzZSB0aGUgZ2Vu
ZXJpYyB2ZXJzaW9uDQo+ID4gYXMgd2VsbD8NCj4gDQo+IFllcywgc291bmRzIGdvb2QgdG8gbWUu
DQoNCldpbGwgZG8uIFRoYW5rcyENCi1Ub3NoaQpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGlt
bUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51
eC1udmRpbW0K
