Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 110272095D9E7
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 12:09:50 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v4 0/6] BTT error clearing rework
Date: Tue, 1 Aug 2017 19:11:53 +0000
Message-ID: <1501614143.2042.101.camel@hpe.com>
References: <20170726233546.29052-1-vishal.l.verma@intel.com>
 <1501542358.2042.97.camel@hpe.com> <1501544000.4405.5.camel@intel.com>
 <1501600767.2042.99.camel@hpe.com>
In-Reply-To: <1501600767.2042.99.camel@hpe.com>
Content-Language: en-US
Content-ID: <661714EF8CE9E04998910473712B9FC4@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE3LTA4LTAxIGF0IDA5OjE5IC0wNjAwLCBUb3NoaSBLYW5pIHdyb3RlOg0KPiBP
biBNb24sIDIwMTctMDctMzEgYXQgMjM6MzUgKzAwMDAsIFZlcm1hLCBWaXNoYWwgTCB3cm90ZToN
Cj4gPiBPbiBNb24sIDIwMTctMDctMzEgYXQgMjM6MTUgKzAwMDAsIEthbmksIFRvc2hpbWl0c3Ug
d3JvdGU6DQo+ID4gPiBPbiBXZWQsIDIwMTctMDctMjYgYXQgMTc6MzUgLTA2MDAsIFZpc2hhbCBW
ZXJtYSB3cm90ZToNCiA6DQo+ID4gVGhhbmtzIGZvciB0aGUgdGVzdCBUb3NoaSwgSSB3aWxsIHRy
eSBhbmQgcmVwcm9kdWNlIGl0Lg0KPiA+IE15IGZpcnN0IGd1ZXNzIGlzIC0gYXJlIHRoZSBpbmpl
Y3RlZCBlcnJvcnMgcG90ZW50aWFsbHkgaW4gdGhlIEJUVA0KPiA+IG1ldGFkYXRhIGFyZWEgdG93
YXJkcyB0aGUgZW5kPw0KPiA+IA0KPiA+IC0+cndfYnl0ZXMgY2FuIG9ubHkgY2xlYXIgZXJyb3Jz
IG9uIHByb3Blcmx5IGFsaWduZWQgd3JpdGVzLCBhbmQNCj4gPiB0aGUgYnR0IG1ldGFkYXRhIHdy
aXRlcyB3aWxsIGJlIHRvbyBzbWFsbCB0byBjbGVhciBtZXRhZGF0YQ0KPiA+IGVycm9ycy4uDQo+
IA0KPiBJIHBpY2tlZCBhbiBpbmplY3RlZCBvZmZzZXQgd2l0aG91dCBjYXJlZnVsIHRob3VnaHRz
LCBzbyBpdCBpcw0KPiBwb3NzaWJsZSB0aGF0IEkgbWlnaHQgaGF2ZSBzdGVwcGVkIGludG8gc3Vj
aCBhcmVhLsKgwqBJIGp1c3QgdGVzdGVkDQo+IHdpdGggYSBibG9jayBkZXZpY2UgaW50ZXJmYWNl
IHdpdGggbXVsdGlwbGUgZGlmZmVyZW50IG9mZnNldHMsIGFuZA0KPiB0aGV5IGZhaWxlZCBpbiBj
bGVhcmluZyBhcyB3ZWxsLi4uwqDCoEkgd2lsbCBsb29rIGludG8gZnVydGhlciBhcyB3ZWxsDQo+
IGFzIG15IHRlc3Qgc2V0dXAuDQoNClRoZSBjaGFuZ2UvaGFjayBiZWxvdyB0YWtlcyBjYXJlIG9m
IHRoZSBpc3N1ZSBpbiBteSBzZXR1cC4gIFRoZXJlIGlzIGENCmRpc2NyZXBhbmN5IGluIG9mZnNl
dCBiZXR3ZWVuIHRoZSBwcmUtY2hlY2sgaW4gYnR0X3dyaXRlX3BnKCkgYW5kIHRoZQ0KYWN0dWFs
IGNoZWNrIGluIG5zaW9fcndfYnl0ZXMoKS4NCg0KVGhhbmtzLA0KLVRvc2hpDQoNCi0tLQ0KwqBk
cml2ZXJzL252ZGltbS9idHQuYyB8wqDCoMKgwqAyICstDQrCoDEgZmlsZSBjaGFuZ2VkLCAxIGlu
c2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9udmRpbW0v
YnR0LmMgYi9kcml2ZXJzL252ZGltbS9idHQuYw0KaW5kZXggOGE5NTlmOC4uODNhZDRjNiAxMDA2
NDQNCi0tLSBhL2RyaXZlcnMvbnZkaW1tL2J0dC5jDQorKysgYi9kcml2ZXJzL252ZGltbS9idHQu
Yw0KQEAgLTExMzcsNyArMTEzNyw3IEBAIHN0YXRpYyBib29sIGJ0dF9pc19iYWRibG9jayhzdHJ1
Y3QgYnR0ICpidHQsDQpzdHJ1Y3QgYXJlbmFfaW5mbyAqYXJlbmEsDQrCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHUzMiBwb3N0bWFwKQ0KwqB7DQrCoMKgwqDCoMKgwqDCoMKgdTY0IG5z
b2ZmID0gdG9fbmFtZXNwYWNlX29mZnNldChhcmVuYSwgcG9zdG1hcCk7DQotwqDCoMKgwqDCoMKg
wqBzZWN0b3JfdCBwaHlzX3NlY3RvciA9IG5zb2ZmID4+IDk7DQorwqDCoMKgwqDCoMKgwqBzZWN0
b3JfdCBwaHlzX3NlY3RvciA9IChuc29mZiArIGFyZW5hLT5uZF9idHQtPmluaXRpYWxfb2Zmc2V0
KQ0KPj4gOTsNCg0KwqDCoMKgwqDCoMKgwqDCoHJldHVybiBpc19iYWRfcG1lbShidHQtPnBoeXNf
YmIsIHBoeXNfc2VjdG9yLCBhcmVuYS0NCj5pbnRlcm5hbF9sYmFzaXplKTsNCsKgfQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFp
bGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcv
bWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
