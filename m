Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 486AA2195407A
 for <linux-nvdimm@lists.01.org>; Mon, 17 Apr 2017 10:29:11 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH 2/5] acpi, nfit: add support for acpi 6.1 dimm state flags
Date: Mon, 17 Apr 2017 17:28:56 +0000
Message-ID: <1492450115.26622.3.camel@hpe.com>
References: <149218909065.3926.1234846095650907678.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149218910195.3926.13927602427357940056.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149218910195.3926.13927602427357940056.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <CBE218352406D943B2C27A09D2544F3E@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCAyMDE3LTA0LTE0IGF0IDA5OjU4IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEFkZCBzdXBwb3J0IGZvciB0aGUgQUNQSV9ORklUX01FTV9NQVBfRkFJTEVEICgibWFwX2ZhaWwi
KSBhbmQNCj4gQUNQSV9ORklUX01FTV9IRUFMVEhfRU5BQkxFRCAoInNtYXJ0X25vdGlmeSIpIGhl
YWx0aCBzdGF0ZSBmbGFncy4gVGhlDQo+ICJtYXBfZmFpbCIgZmxhZyBpZGVudGlmaWVzIERJTU1z
IHRoYXQgd2VyZSBub3QgbWFwcGVkIGludG8gb25lIG9yDQo+IG1vcmUgcGh5c2ljYWwgYWRkcmVz
cyByYW5nZXMuIFRoZSAiaGVhbHRoX25vdGlmeSIgZmxhZyBpbmRpY2F0ZXMNCj4gd2hldGhlciBw
bGF0Zm9ybSBmaXJtd2FyZSB3aWxsIHNlbmQgbm90aWZpY2F0aW9ucyB3aGVuIHRoZXJlIGlzIG5l
dw0KPiBTTUFSVCBoZWFsdGggZGF0YSB0byBjb25zdW1lLg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
RGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+IC0tLQ0KPiDCoGRyaXZl
cnMvYWNwaS9uZml0L2NvcmUuYyB8wqDCoMKgwqA2ICsrKystLQ0KPiDCoDEgZmlsZSBjaGFuZ2Vk
LCA0IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9hY3BpL25maXQvY29yZS5jIGIvZHJpdmVycy9hY3BpL25maXQvY29yZS5jDQo+IGluZGV4
IDUzOTQzZDZmNDIxNC4uMDU4MjlkZTQzYjFkIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2FjcGkv
bmZpdC9jb3JlLmMNCj4gKysrIGIvZHJpdmVycy9hY3BpL25maXQvY29yZS5jDQo+IEBAIC0xMjQ2
LDEyICsxMjQ2LDE0IEBAIHN0YXRpYyBzc2l6ZV90IGZsYWdzX3Nob3coc3RydWN0IGRldmljZSAq
ZGV2LA0KPiDCoHsNCj4gwqAJdTE2IGZsYWdzID0gdG9fbmZpdF9tZW1kZXYoZGV2KS0+ZmxhZ3M7
DQo+IMKgDQo+IC0JcmV0dXJuIHNwcmludGYoYnVmLCAiJXMlcyVzJXMlc1xuIiwNCj4gKwlyZXR1
cm4gc3ByaW50ZihidWYsICIlcyVzJXMlcyVzJXMlc1xuIiwNCj4gwqAJCWZsYWdzICYgQUNQSV9O
RklUX01FTV9TQVZFX0ZBSUxFRCA/ICJzYXZlX2ZhaWwgIiA6DQo+ICIiLA0KPiDCoAkJZmxhZ3Mg
JiBBQ1BJX05GSVRfTUVNX1JFU1RPUkVfRkFJTEVEID8gInJlc3RvcmVfZmFpbA0KPiAiIDogIiIs
DQo+IMKgCQlmbGFncyAmIEFDUElfTkZJVF9NRU1fRkxVU0hfRkFJTEVEID8gImZsdXNoX2ZhaWwg
IiA6DQo+ICIiLA0KPiDCoAkJZmxhZ3MgJiBBQ1BJX05GSVRfTUVNX05PVF9BUk1FRCA/ICJub3Rf
YXJtZWQgIiA6ICIiLA0KPiAtCQlmbGFncyAmIEFDUElfTkZJVF9NRU1fSEVBTFRIX09CU0VSVkVE
ID8gInNtYXJ0X2V2ZW50DQo+ICIgOiAiIik7DQo+ICsJCWZsYWdzICYgQUNQSV9ORklUX01FTV9I
RUFMVEhfT0JTRVJWRUQgPyAic21hcnRfZXZlbnQNCj4gIiA6ICIiLA0KPiArCQlmbGFncyAmIEFD
UElfTkZJVF9NRU1fTUFQX0ZBSUxFRCA/ICJtYXBfZmFpbCAiIDogIiIsDQo+ICsJCWZsYWdzICYg
QUNQSV9ORklUX01FTV9IRUFMVEhfRU5BQkxFRCA/ICJzbWFydF9ub3RpZnkNCj4gIiA6ICIiKTsN
Cg0KVGhhbmtzIGZvciB0aGUgdXBkYXRlISAgVGhlIGFib3ZlIGNoYW5nZSBsb29rcyBnb29kLCBi
dXQgd2Ugd2lsbCBhbHNvDQpuZWVkIHRvIG1ha2UgdGhlIHNhbWUgY2hhbmdlcyB0byB0aGUgZGV2
X2luZm8oKSBpbg0KYWNwaV9uZml0X3JlZ2lzdGVyX2RpbW1zKCkuDQoNCi1Ub3NoaQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFp
bGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcv
bWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
