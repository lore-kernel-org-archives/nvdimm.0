Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam01on0701.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe42::701])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22FEF81C1C
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jan 2017 10:26:44 -0800 (PST)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH v5] DAX: enable iostat for read/write
Date: Thu, 12 Jan 2017 18:26:42 +0000
Message-ID: <1484248944.2029.5.camel@hpe.com>
References: <20170112183848.23159-1-toshi.kani@hpe.com>
 <1484244141.3065.20.camel@perches.com>
In-Reply-To: <1484244141.3065.20.camel@perches.com>
Content-Language: en-US
Content-ID: <DA8DC6D43B5B4740B822E8EDA8745976@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE3LTAxLTEyIGF0IDEwOjAyIC0wODAwLCBKb2UgUGVyY2hlcyB3cm90ZToNCj4g
T24gVGh1LCAyMDE3LTAxLTEyIGF0IDExOjM4IC0wNzAwLCBUb3NoaSBLYW5pIHdyb3RlOg0KPiA+
IERBWCBJTyBwYXRoIGRvZXMgbm90IHN1cHBvcnQgaW9zdGF0LCBidXQgaXRzIG1ldGFkYXRhIElP
IHBhdGggZG9lcy4NCj4gPiBUaGVyZWZvcmUsIGlvc3RhdCBzaG93cyBtZXRhZGF0YSBJTyBzdGF0
aXN0aWNzIG9ubHksIHdoaWNoIGhhcyBiZWVuDQo+ID4gY29uZnVzaW5nIHRvIHVzZXJzLg0KPiAN
Cj4gW10NCj4gPiBkaWZmIC0tZ2l0IGEvZnMvZGF4LmMgYi9mcy9kYXguYw0KPiANCj4gW10NCj4g
PiBAQCAtMTA1OCwxMiArMTA1OCwyNCBAQCBkYXhfaW9tYXBfcncoc3RydWN0IGtpb2NiICppb2Ni
LCBzdHJ1Y3QNCj4gPiBpb3ZfaXRlciAqaXRlciwNCj4gPiDCoHsNCj4gPiDCoAlzdHJ1Y3QgYWRk
cmVzc19zcGFjZSAqbWFwcGluZyA9IGlvY2ItPmtpX2ZpbHAtPmZfbWFwcGluZzsNCj4gPiDCoAlz
dHJ1Y3QgaW5vZGUgKmlub2RlID0gbWFwcGluZy0+aG9zdDsNCj4gPiArCXN0cnVjdCBnZW5kaXNr
ICpkaXNrID0gaW5vZGUtPmlfc2ItPnNfYmRldi0+YmRfZGlzazsNCj4gPiDCoAlsb2ZmX3QgcG9z
ID0gaW9jYi0+a2lfcG9zLCByZXQgPSAwLCBkb25lID0gMDsNCj4gPiDCoAl1bnNpZ25lZCBmbGFn
cyA9IDA7DQo+ID4gKwl1bnNpZ25lZCBsb25nIHN0YXJ0ID0gMDsNCj4gPiArCWludCBkb19hY2N0
ID0gYmxrX3F1ZXVlX2lvX3N0YXQoZGlzay0+cXVldWUpOw0KPiA+IMKgDQo+ID4gwqAJaWYgKGlv
dl9pdGVyX3J3KGl0ZXIpID09IFdSSVRFKQ0KPiA+IMKgCQlmbGFncyB8PSBJT01BUF9XUklURTsN
Cj4gPiDCoA0KPiA+ICsJaWYgKGRvX2FjY3QpIHsNCj4gPiArCQlzZWN0b3JfdCBzZWMgPSBpb3Zf
aXRlcl9jb3VudChpdGVyKSA+PiA5Ow0KPiA+ICsNCj4gPiArCQlzdGFydCA9IGppZmZpZXM7DQo+
ID4gKwkJZ2VuZXJpY19zdGFydF9pb19hY2N0KGlvdl9pdGVyX3J3KGl0ZXIpLA0KPiA+ICsJCQkJ
wqDCoMKgwqDCoMKgbWluX3QodW5zaWduZWQgbG9uZywgMSwNCj4gPiBzZWMpLA0KPiANCj4gSSBi
ZWxpZXZlIEkgbWlzbGVhZCB5b3Ugd2l0aCBhIHRoaW5rby4NCj4gDQo+IFlvdXIgb3JpZ2luYWwg
Y29kZSB3YXMNCj4gCSghc2VjKSA/IDEgOiBzZWMNCj4gYW5kIEkgc3VnZ2VzdGVkIGluY29ycmVj
dGx5IHVzaW5nIG1pbl90DQo+IA0KPiBJdCBzaG91bGQgb2YgY291cnNlIGJlIG1heF90LsKgwqBT
b3JyeS4NCg0KTXkgYmFkLiBJIHNob3VsZCBoYXZlIGNhdWdodCBpdC4NCg0KPiBBbHNvLCBhcyBz
ZWMgaXMgbm93IHNlY3Rvcl90ICh1NjQpLCBwZXJoYXBzIHRoaXMNCj4gdW5zaWduZWQgbG9uZyBj
YXN0IGlzIGluY29ycmVjdC4NCg0KSSBzZWUuIFNpbmNlIGlvdl9pdGVyX2NvdW50KCkgcmV0dXJu
cyBhIHNpemVfdCB2YWx1ZSwgSSB3aWxsIHVzZQ0KJ3NpemVfdCcgZm9yICdzZWMnIGFzIHlvdSBv
cmlnaW5hbGx5IHN1Z2dlc3RlZC4gDQoNClRoYW5rcywNCi1Ub3NoaQ0KX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlz
dApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4v
bGlzdGluZm8vbGludXgtbnZkaW1tCg==
