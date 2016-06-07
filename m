Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from na01-by2-obe.outbound.protection.outlook.com
 (mail-by2on0799.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fc0c::799])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 80EE71A1F4A
 for <linux-nvdimm@lists.01.org>; Tue,  7 Jun 2016 11:11:52 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH 04/13] libnvdimm, nfit: move flush hint mapping to dimm
 driver
Date: Tue, 7 Jun 2016 18:11:31 +0000
Message-ID: <1465322493.3504.143.camel@hpe.com>
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
 <146507357415.8347.2659418918775329626.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146507357415.8347.2659418918775329626.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <DEA621885D86394FAF4E2BB0E624CFA9@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "david@fromorbit.com" <david@fromorbit.com>, "hch@lst.de" <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gU2F0LCAyMDE2LTA2LTA0IGF0IDEzOjUyIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQrC
oDoNCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZkaW1tL3JlZ2lvbl9kZXZzLmMgYi9kcml2ZXJz
L252ZGltbS9yZWdpb25fZGV2cy5jDQo+IGluZGV4IDQyMGUxYTVlMjI1MC4uNWI2Zjg1ZDAwYmI1
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL252ZGltbS9yZWdpb25fZGV2cy5jDQo+ICsrKyBiL2Ry
aXZlcnMvbnZkaW1tL3JlZ2lvbl9kZXZzLmMNCj4gQEAgLTgwMywxMSArODAzLDI5IEBAIEVYUE9S
VF9TWU1CT0xfR1BMKG52ZGltbV92b2xhdGlsZV9yZWdpb25fY3JlYXRlKTsNCj4gwqAgKi8NCj4g
wqB2b2lkIG52ZGltbV9mbHVzaChzdHJ1Y3QgbmRfcmVnaW9uICpuZF9yZWdpb24pDQo+IMKgew0K
PiArCWludCBpOw0KPiArDQo+IMKgCS8qDQo+IC0JwqAqIFRPRE86IHJlcGxhY2Ugd21iX3BtZW0o
KSB1c2FnZSB3aXRoIGZsdXNoIGhpbnQgd3JpdGVzIHdoZXJlDQo+IC0JwqAqIGF2YWlsYWJsZS4N
Cj4gKwnCoCogVGhlIGZpcnN0IHdtYigpIGlzIG5lZWRlZCB0byAnc2ZlbmNlJyBhbGwgcHJldmlv
dXMgd3JpdGVzDQo+ICsJwqAqIHN1Y2ggdGhhdCB0aGV5IGFyZSBhcmNoaXRlY3R1cmFsbHkgdmlz
aWJsZSBmb3IgdGhlIHBsYXRmb3JtDQo+ICsJwqAqIGJ1ZmZlciBmbHVzaC7CoMKgTm90ZSB0aGF0
IHdlJ3ZlIGFscmVhZHkgYXJyYW5nZWQgZm9yIHBtZW0NCj4gKwnCoCogd3JpdGVzIHRvIGF2b2lk
IHRoZSBjYWNoZSB2aWEgYXJjaF9tZW1jcHlfdG9fcG1lbSgpLsKgwqBUaGUNCj4gKwnCoCogZmlu
YWwgd21iKCkgZW5zdXJlcyBvcmRlcmluZyBmb3IgdGhlIE5WRElNTSBmbHVzaCB3cml0ZS4NCj4g
wqAJwqAqLw0KPiAtCXdtYl9wbWVtKCk7DQo+ICsJd21iKCk7DQo+ICsJZm9yIChpID0gMDsgaSA8
IG5kX3JlZ2lvbi0+bmRyX21hcHBpbmdzOyBpKyspIHsNCj4gKwkJc3RydWN0IG5kX21hcHBpbmcg
Km5kX21hcHBpbmcgPSAmbmRfcmVnaW9uLT5tYXBwaW5nW2ldOw0KPiArCQlzdHJ1Y3QgbnZkaW1t
X2RydmRhdGEgKm5kZCA9IHRvX25kZF91bmxvY2tlZChuZF9tYXBwaW5nKTsNCj4gKw0KPiArCQkv
Kg0KPiArCQnCoCogTm90ZSwgbnZkaW1tX2RydmRhdGEgZ3VhcmFudGVlZCB0byBiZSBsaXZlIHNp
bmNlIHdlDQo+ICsJCcKgKiBhcnJhbmdlIGZvciBhbGwgYXNzb2NpYXRlZCByZWdpb25zIHRvIGJl
IGRpc2FibGVkDQo+ICsJCcKgKiBiZWZvcmUgdGhlIGRpbW0gaXMgZGlzYWJsZWQuDQo+ICsJCcKg
Ki8NCj4gKwkJaWYgKG5kZC0+Zmx1c2hfd3BxWzBdKQ0KDQpIaSBEYW4sDQoNCm5kZCBpcyBOVUxM
IG9uIG91ciBzeXN0ZW0gc2luY2XCoG52ZGltbV9wcm9iZSgpIGFsd2F5cyBmYWlscw0KaW7CoG52
ZGltbV9pbml0X25zYXJlYSgpLCB3aGljaCB0aGVuIGNhbGxzwqBwdXRfbmRkKCkgYW5kDQpudmRp
bW1fZHJ2ZGF0YV9yZWxlYXNlKCkuDQoNClRoYW5rcywNCi1Ub3NoaQpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0
CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9s
aXN0aW5mby9saW51eC1udmRpbW0K
