Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BN3-obe.outbound.protection.outlook.com
 (mail-bn3nam01on071d.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe41::71d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BD6281B14
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jan 2017 15:54:57 -0800 (PST)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4] DAX: enable iostat for read/write
Date: Tue, 10 Jan 2017 23:54:54 +0000
Message-ID: <1484095838.2029.1.camel@hpe.com>
References: <20170111001122.10826-1-toshi.kani@hpe.com>
 <CAPcyv4gBtLB1GmKuPyJ257Hej+sEH54624Tuhq6OobV3ZZVawA@mail.gmail.com>
In-Reply-To: <CAPcyv4gBtLB1GmKuPyJ257Hej+sEH54624Tuhq6OobV3ZZVawA@mail.gmail.com>
Content-Language: en-US
Content-ID: <99363862D683E84CB399E152FAD0F3AA@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gVHVlLCAyMDE3LTAxLTEwIGF0IDE1OjQxIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFR1ZSwgSmFuIDEwLCAyMDE3IGF0IDQ6MTEgUE0sIFRvc2hpIEthbmkgPHRvc2hpLmthbmlA
aHBlLmNvbT4NCj4gd3JvdGU6DQogOg0KPiA+IA0KPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChibGtf
cXVldWVfaW9fc3RhdChkaXNrLT5xdWV1ZSkpIHsNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgaW50IHNlYyA9IGlvdl9pdGVyX2NvdW50KGl0ZXIpID4+IDk7DQo+ID4gKw0KPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzdGFydCA9IGppZmZpZXM7DQo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdlbmVyaWNfc3RhcnRfaW9fYWNjdChpb3ZfaXRl
cl9ydyhpdGVyKSwNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAoIXNlYykgPyAxIDogc2VjLCAmZGlz
ay0NCj4gPiA+cGFydDApOw0KPiA+ICvCoMKgwqDCoMKgwqDCoH0NCj4gPiArDQo+ID4gwqDCoMKg
wqDCoMKgwqDCoHdoaWxlIChpb3ZfaXRlcl9jb3VudChpdGVyKSkgew0KPiA+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0ID0gaW9tYXBfYXBwbHkoaW5vZGUsIHBvcywgaW92X2l0
ZXJfY291bnQoaXRlciksDQo+ID4gZmxhZ3MsIG9wcywNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaXRlciwgZGF4X2lv
bWFwX2FjdG9yKTsNCj4gPiBAQCAtMTA3Myw2ICsxMDgzLDkgQEAgZGF4X2lvbWFwX3J3KHN0cnVj
dCBraW9jYiAqaW9jYiwgc3RydWN0DQo+ID4gaW92X2l0ZXIgKml0ZXIsDQo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBkb25lICs9IHJldDsNCj4gPiDCoMKgwqDCoMKgwqDCoMKg
fQ0KPiA+IA0KPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChzdGFydCkNCj4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgZ2VuZXJpY19lbmRfaW9fYWNjdChpb3ZfaXRlcl9ydyhpdGVyKSwg
JmRpc2stDQo+ID4gPnBhcnQwLCBzdGFydCk7DQo+ID4gKw0KPiANCj4gSSB0aGluayB3ZSBjYW4g
YWZmb3JkIHRvIGFkZCBhIHNlcGFyYXRlIGZsYWcgdGhhdCBpbmRpY2F0ZXMgd2hldGhlcg0KPiB3
ZSBjYWxsZWQgZ2VuZXJpY19zdGFydF9pb19hY2N0KCkuIEp1c3QgaW4gY2FzZSAnc3RhcnQnIGlz
ICcwJyBhZnRlcg0KPiAnamlmZmllcycgcm9sbHMgb3Zlci4NCg0KR29vZCBwb2ludC4gSSB3aWxs
IGFkZCBhIGZsYWcgdG8gYWNjb3VudCBzdWNoIGEgY2FzZS4NCg0KVGhhbmtzLA0KLVRvc2hpDQpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRp
bW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4w
MS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
