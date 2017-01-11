Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-CY1-obe.outbound.protection.outlook.com
 (mail-cys01nam02on070a.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe45::70a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D17D681B87
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jan 2017 08:29:23 -0800 (PST)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4] DAX: enable iostat for read/write
Date: Wed, 11 Jan 2017 16:29:21 +0000
Message-ID: <1484155504.2029.3.camel@hpe.com>
References: <20170111001122.10826-1-toshi.kani@hpe.com>
 <1484109363.12006.19.camel@perches.com>
In-Reply-To: <1484109363.12006.19.camel@perches.com>
Content-Language: en-US
Content-ID: <47FAF610C1BCFD4EB01438815B7AD868@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "joe@perches.com" <joe@perches.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "viro@zenihttp.domain.invalid" <viro@zenihttp.domain.invalid>, "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE3LTAxLTEwIGF0IDIwOjM2IC0wODAwLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4g
PiANCk9uIFR1ZSwgMjAxNy0wMS0xMCBhdCAxNzoxMSAtMDcwMCwgVG9zaGkgS2FuaSB3cm90ZToN
Cj4gPiBEQVggSU8gcGF0aCBkb2VzIG5vdCBzdXBwb3J0IGlvc3RhdCwgYnV0IGl0cyBtZXRhZGF0
YSBJTyBwYXRoIGRvZXMuDQo+ID4gVGhlcmVmb3JlLCBpb3N0YXQgc2hvd3MgbWV0YWRhdGEgSU8g
c3RhdGlzdGljcyBvbmx5LCB3aGljaCBoYXMgYmVlbg0KPiA+IGNvbmZ1c2luZyB0byB1c2Vycy4N
Cj4gDQo+IFtdDQo+ID4gZGlmZiAtLWdpdCBhL2ZzL2RheC5jIGIvZnMvZGF4LmMNCj4gDQo+IFtd
DQo+ID4gQEAgLTEwNTgsMTIgKzEwNTgsMjIgQEAgZGF4X2lvbWFwX3J3KHN0cnVjdCBraW9jYiAq
aW9jYiwgc3RydWN0DQo+ID4gaW92X2l0ZXIgKml0ZXIsDQo+IA0KPiBbXQ0KPiA+ICsJaWYgKGJs
a19xdWV1ZV9pb19zdGF0KGRpc2stPnF1ZXVlKSkgew0KPiA+ICsJCWludCBzZWMgPSBpb3ZfaXRl
cl9jb3VudChpdGVyKSA+PiA5Ow0KPiA+ICsNCj4gPiArCQlzdGFydCA9IGppZmZpZXM7DQo+ID4g
KwkJZ2VuZXJpY19zdGFydF9pb19hY2N0KGlvdl9pdGVyX3J3KGl0ZXIpLA0KPiA+ICsJCQkJwqDC
oMKgwqDCoMKgKCFzZWMpID8gMSA6IHNlYywgJmRpc2stDQo+ID4gPnBhcnQwKTsNCj4gPiArCX0N
Cj4gDQo+IFRoZXJlIGlzIGEgc2lnbmVkL3Vuc2lnbmVkIGNvbnZlcnNpb24gb2Ygc2VjDQo+IEl0
IG1heSBiZSBiZXR0ZXIgdG8gdXNlIHNvbWV0aGluZyBsaWtlOg0KPiANCj4gCQlzaXplX3Qgc2Vj
wqDCoD0gaW92X2l0ZXJfY291bnQoaXRlcikgPj4gOTsNCj4gCQlbLi4uXQ0KPiAJCWdlbmVyaWNf
c3RhcnRfaW9fYWNjdChpb3ZfaXRlcl9ydyhpdGVyKSwNCj4gCQkJCcKgwqDCoMKgwqDCoG1pbl90
KHVuc2lnbmVkIGxvbmcsIDEsIHNlYyksDQo+IAkJCQnCoMKgwqDCoMKgwqAmZGlzay0+cGFydDAp
Ow0KDQpHb29kIGNhdGNoLiBJIHdpbGwgY2hhbmdlIGFzIHlvdSBzdWdnZXN0ZWQsIGFuZCB1c2Ug
J3NlY3Rvcl90JyBmb3INCidzZWMnLiANCg0KVGhhbmtzLA0KLVRvc2hpCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxp
c3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFu
L2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
