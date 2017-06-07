Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D20D21A16EC1
 for <linux-nvdimm@lists.01.org>; Wed,  7 Jun 2017 13:56:54 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] Add support of NVDIMM memory error notification in ACPI
 6.2
Date: Wed, 7 Jun 2017 20:57:57 +0000
Message-ID: <1496869051.9288.1.camel@hpe.com>
References: <20170607184947.18733-1-toshi.kani@hpe.com>
 <CAPcyv4i7bLU17QEmdUBQrtWP3AZxPRyKK0NN105XrTj8K3nAAQ@mail.gmail.com>
In-Reply-To: <CAPcyv4i7bLU17QEmdUBQrtWP3AZxPRyKK0NN105XrTj8K3nAAQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <8D0D1EC9E3B52B41AB5518D3BC20446D@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCAyMDE3LTA2LTA3IGF0IDEyOjA5IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFdlZCwgSnVuIDcsIDIwMTcgYXQgMTE6NDkgQU0sIFRvc2hpIEthbmkgPHRvc2hpLmthbmlA
aHBlLmNvbT4NCj4gd3JvdGU6DQogOg0KPiA+ICsNCj4gPiArc3RhdGljIHZvaWQgYWNwaV9uZml0
X3VjX2Vycm9yX25vdGlmeShzdHJ1Y3QgZGV2aWNlICpkZXYsDQo+ID4gYWNwaV9oYW5kbGUgaGFu
ZGxlKQ0KPiA+ICt7DQo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGFjcGlfbmZpdF9kZXNjICph
Y3BpX2Rlc2MgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsNCj4gPiArDQo+ID4gK8KgwqDCoMKgwqDC
oMKgYWNwaV9uZml0X2Fyc19yZXNjYW4oYWNwaV9kZXNjKTsNCj4gDQo+IEkgd29uZGVyIGlmIHdl
IHNob3VsZCBnYXRlIHJlLXNjYW5uaW5nIHdpdGggYSBzaW1pbGFyOg0KPiANCj4gwqDCoMKgwqBp
ZiAoYWNwaV9kZXNjLT5zY3J1Yl9tb2RlID09IEhXX0VSUk9SX1NDUlVCX09OKQ0KPiANCj4gLi4u
Y2hlY2sgdGhhdCB3ZSBkbyBpbiB0aGUgbWNlIG5vdGlmaWNhdGlvbiBjYXNlPyBNYXliZSBub3Qg
c2luY2Ugd2UNCj4gZG9uJ3QgZ2V0IGFuIGluZGljYXRpb24gb2Ygd2hlcmUgdGhlIGVycm9yIGlz
IHdpdGhvdXQgYSByZXNjYW4uDQoNCkkgdGhpbmsgdGhpcyBtY2UgY2FzZSBpcyBkaWZmZXJlbnQg
c2luY2UgdGhlIE1DRSBoYW5kbGVyIGFscmVhZHkga25vd3MNCndoZXJlIHRoZSBuZXcgcG9pc29u
IGxvY2F0aW9uIGlzIGFuZCBjYW4gdXBkYXRlIGJhZGJsb2NrcyBpbmZvcm1hdGlvbg0KZm9yIGl0
LiAgU3RhcnRpbmcgQVJTIGlzIGFuIG9wdGlvbmFsIHByZWNhdXRpb24uDQoNCj4gSG93ZXZlciwg
YXQgYSBtaW5pbXVtIEkgdGhpbmsgd2UgbmVlZCBzdXBwb3J0IGZvciB0aGUgbmV3IFN0YXJ0IEFS
Uw0KPiBmbGFnICgiSWYgc2V0IHRvIDEgdGhlIGZpcm13YXJlIHNoYWxsIHJldHVybiBkYXRhIGZy
b20gYSBwcmV2aW91cw0KPiBzY3J1YiwgaWYgYW55LCB3aXRob3V0IHN0YXJ0aW5nIGEgbmV3IHNj
cnViIikgYW5kIHVzZSB0aGF0IGZvciB0aGlzDQo+IGNhc2UuDQoNClRoYXQncyBhbiBpbnRlcmVz
dGluZyBpZGVhLiAgQnV0IEkgd29uZGVyIGhvdyB1c2VycyBrbm93IGlmIGl0IGlzIE9LIHRvDQpz
ZXQgdGhpcyBmbGFnIGFzIGl0IHJlbGllcyBvbiBCSU9TIGltcGxlbWVudGF0aW9uIHRoYXQgaXMg
bm90IGRlc2NyaWJlZA0KaW4gQUNQSS4uLg0KDQo+IEFub3RoZXIgdGhpbmcgdGhhdCBzZWVtcyB0
byBiZSBtaXNzaW5nIGluIGJvdGggdGhpcyBhbmQgdGhlIG1jZSBjYXNlDQo+IGlzIGEgbm90aWZp
Y2F0aW9uIHRvIHVzZXJzcGFjZSB0aGF0IHNvbWV0aGluZyBjaGFuZ2VkLiBXZSBoYXZlIGNhbGxz
DQo+IHRvIHN5c2ZzX25vdGlmeV9kaXJlbnQoKSB0byBub3RpZnkgc2NydWIgY29tcGxldGlvbiBl
dmVudHMgYW5kIERJTU0NCj4gaGVhbHRoIHN0YXR1cyBjaGFuZ2UgZXZlbnRzLCBJIHRoaW5rIHdl
IG5lZWQgYSBzaW1pbGFyIG5vdGlmaWVyDQo+IG1lY2hhbmlzbSBmb3IgbmV3IHVuLWNvcnJlY3Rh
YmxlIGVycm9ycy4NCg0KR29vZCBwb2ludC4gIEkgdGhpbmsgdGhpcyBjYW4gYmUgYSBiYWRibG9j
a3MgcG9wdWxhdGlvbiBldmVudCwgd2hpY2gNCmdldHMgZ2VuZXJhdGVkIHdoZW4gYmFkYmxvY2tz
IGluZm9ybWF0aW9uIGlzIHVwZGF0ZWQgYXQgYm9vdC10aW1lIGFuZA0KcnVuLXRpbWUgdmlhIHRo
aXMgbm90aWZpY2F0aW9uIGFuZCBNQ0UuDQoNClRoYW5rcywNCi1Ub3NoaQpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBs
aXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1h
bi9saXN0aW5mby9saW51eC1udmRpbW0K
