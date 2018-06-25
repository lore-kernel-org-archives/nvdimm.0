Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1A4A2202E53F8
 for <linux-nvdimm@lists.01.org>; Mon, 25 Jun 2018 16:55:34 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id C3CCCAC015B
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 08:55:29 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [PATCH] ndctl, list: add controller temperature threshold
Date: Mon, 25 Jun 2018 23:55:27 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E32237E8FF94@g01jpexmbkw01>
References: <20180625084217.10608-1-qi.fuli@jp.fujitsu.com>
 <1529957348.27147.12.camel@intel.com>
In-Reply-To: <1529957348.27147.12.camel@intel.com>
Content-Language: en-US
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
To: "'Verma, Vishal L'" <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWZXJtYSwgVmlzaGFsIEwgW21h
aWx0bzp2aXNoYWwubC52ZXJtYUBpbnRlbC5jb21dDQo+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMjYs
IDIwMTggNTowOSBBTQ0KPiBUbzogbGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZzsgUWksIEZ1bGkv
5paJIOemj+WIqSA8cWkuZnVsaUBqcC5mdWppdHN1LmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRD
SF0gbmRjdGwsIGxpc3Q6IGFkZCBjb250cm9sbGVyIHRlbXBlcmF0dXJlIHRocmVzaG9sZA0KPiAN
Cj4gT24gTW9uLCAyMDE4LTA2LTI1IGF0IDE3OjQyICswOTAwLCBRSSBGdWxpIHdyb3RlOg0KPiA+
IFRoaXMgcGF0Y2ggYWRkcyBjb250cm9sbGVyIHRlbXBlcmF0dXJlIHRocmVzaG9sZCB0byBsaXN0
Lg0KPiA+IFdoZW4gdGhlIGRpbW0tY29udHJvbGxlci10ZW1wZXJhdHVyZSBldmVudCBmaXJlcywg
dXNlcnMgbmVlZCB0byBrbm93DQo+ID4gdGhlIGN1cnJlbnQgY29udHJvbGxlciB0ZW1wZXJhdHVy
ZSB0aHJlc2hvbGQgdmFsdWUuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBRSSBGdWxpIDxxaS5m
dWxpQGpwLmZ1aml0c3UuY29tPg0KPiA+IC0tLQ0KPiA+ICBuZGN0bC91dGlsL2pzb24tc21hcnQu
YyB8IDEyICsrKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygr
KQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL25kY3RsL3V0aWwvanNvbi1zbWFydC5jIGIvbmRjdGwv
dXRpbC9qc29uLXNtYXJ0LmMgaW5kZXgNCj4gPiA5NDgyYjM1Li5kNTkwYjBjIDEwMDY0NA0KPiA+
IC0tLSBhL25kY3RsL3V0aWwvanNvbi1zbWFydC5jDQo+ID4gKysrIGIvbmRjdGwvdXRpbC9qc29u
LXNtYXJ0LmMNCj4gPiBAQCAtNDcsNiArNDcsMTggQEAgc3RhdGljIHZvaWQgc21hcnRfdGhyZXNo
b2xkX3RvX2pzb24oc3RydWN0DQo+ID4gbmRjdGxfZGltbSAqZGltbSwNCj4gPiAgCQkJCQkidGVt
cGVyYXR1cmVfdGhyZXNob2xkIiwgam9iaik7DQo+ID4gIAl9DQo+ID4NCj4gPiArCWlmIChhbGFy
bV9jb250cm9sICYgTkRfU01BUlRfVEVNUF9UUklQKSB7DQo+IA0KPiBJIHRoaW5rIHlvdSB3YW50
IHRvIHVzZSBORF9TTUFSVF9DVEVNUF9UUklQIGhlcmUuDQo+IA0KWWVzLCBJIHdpbGwgZml4IGl0
Lg0KDQo+ID4gKwkJdW5zaWduZWQgaW50IHRlbXA7DQo+ID4gKwkJZG91YmxlIHQ7DQo+ID4gKw0K
PiA+ICsJCXRlbXAgPQ0KPiA+IG5kY3RsX2NtZF9zbWFydF90aHJlc2hvbGRfZ2V0X2N0cmxfdGVt
cGVyYXR1cmUoY21kKTsNCj4gPiArCQl0ID0gbmRjdGxfZGVjb2RlX3NtYXJ0X3RlbXBlcmF0dXJl
KHRlbXApOw0KPiA+ICsJCWpvYmogPSBqc29uX29iamVjdF9uZXdfZG91YmxlKHQpOw0KPiA+ICsJ
CWlmIChqb2JqKQ0KPiA+ICsJCQlqc29uX29iamVjdF9vYmplY3RfYWRkKGpoZWFsdGgsDQo+ID4g
KwkJCQkiY29udHJvbGxlcl90ZW1wZXJhdHVyZV90aHJlc2hvbGQiLA0KPiA+IGpvYmopOw0KPiA+
ICsJfQ0KPiA+ICsNCj4gPiAgCWlmIChhbGFybV9jb250cm9sICYgTkRfU01BUlRfU1BBUkVfVFJJ
UCkgew0KPiA+ICAJCXVuc2lnbmVkIGludCBzcGFyZXM7DQo+IA0KPiBXZSBhbHNvIHNlZW0gdG8g
YmUgbWlzc2luZyBmcm9tIHRoZSBsaXN0aW5nLCBhbiBhbGFybV9jb250cm9sbGVyX3RlbXBlcmF0
dXJlIGZpZWxkDQo+IHRvIHNob3cgd2hldGhlciBvciBub3QgdGhlIGFsYXJtIGlzIGVuYWJsZWQu
IENhbiB5b3UgYWRkIHRoYXQgYXMgd2VsbCBhcyBwYXJ0IG9mDQo+IHRoaXM/DQo+IA0KU3VyZSwg
SSB3aWxsIGFkZCBpdCBpbiB2Mi4NCg0KVGhhbmsgeW91IHZlcnkgbXVjaC4NCiBRaQ0KDQo+IA0K
PiBUaGFua3MsDQo+IAktVmlzaGFsDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0
cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRp
bW0K
