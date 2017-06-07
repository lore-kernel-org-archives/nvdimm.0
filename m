Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB86D21A08D8A
 for <linux-nvdimm@lists.01.org>; Wed,  7 Jun 2017 14:32:58 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] Add support of NVDIMM memory error notification in ACPI
 6.2
Date: Wed, 7 Jun 2017 21:33:31 +0000
Message-ID: <1496871186.9288.3.camel@hpe.com>
References: <20170607184947.18733-1-toshi.kani@hpe.com>
 <CAPcyv4i7bLU17QEmdUBQrtWP3AZxPRyKK0NN105XrTj8K3nAAQ@mail.gmail.com>
 <1496869051.9288.1.camel@hpe.com>
 <CAPcyv4hwhRc6+JW8m3zVn_tKz__wE9BHOfpjy69RS6OwiqV-PA@mail.gmail.com>
In-Reply-To: <CAPcyv4hwhRc6+JW8m3zVn_tKz__wE9BHOfpjy69RS6OwiqV-PA@mail.gmail.com>
Content-Language: en-US
Content-ID: <343E154C7E43AF46AFC6168967726141@NAMPRD84.PROD.OUTLOOK.COM>
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

T24gV2VkLCAyMDE3LTA2LTA3IGF0IDE0OjA2IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFdlZCwgSnVuIDcsIDIwMTcgYXQgMTo1NyBQTSwgS2FuaSwgVG9zaGltaXRzdSA8dG9zaGku
a2FuaUBocGUuY29tPg0KPiB3cm90ZToNCj4gPiBPbiBXZWQsIDIwMTctMDYtMDcgYXQgMTI6MDkg
LTA3MDAsIERhbiBXaWxsaWFtcyB3cm90ZToNCj4gPiA+IE9uIFdlZCwgSnVuIDcsIDIwMTcgYXQg
MTE6NDkgQU0sIFRvc2hpIEthbmkgPHRvc2hpLmthbmlAaHBlLmNvbT4NCj4gPiA+IHdyb3RlOg0K
PiA+IA0KPiA+IMKgOg0KPiA+ID4gPiArDQo+ID4gPiA+ICtzdGF0aWMgdm9pZCBhY3BpX25maXRf
dWNfZXJyb3Jfbm90aWZ5KHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gPiA+ID4gYWNwaV9oYW5kbGUg
aGFuZGxlKQ0KPiA+ID4gPiArew0KPiA+ID4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgYWNwaV9u
Zml0X2Rlc2MgKmFjcGlfZGVzYyA9DQo+ID4gPiA+IGRldl9nZXRfZHJ2ZGF0YShkZXYpOw0KPiA+
ID4gPiArDQo+ID4gPiA+ICvCoMKgwqDCoMKgwqDCoGFjcGlfbmZpdF9hcnNfcmVzY2FuKGFjcGlf
ZGVzYyk7DQo+ID4gPiANCj4gPiA+IEkgd29uZGVyIGlmIHdlIHNob3VsZCBnYXRlIHJlLXNjYW5u
aW5nIHdpdGggYSBzaW1pbGFyOg0KPiA+ID4gDQo+ID4gPiDCoMKgwqDCoGlmIChhY3BpX2Rlc2Mt
PnNjcnViX21vZGUgPT0gSFdfRVJST1JfU0NSVUJfT04pDQo+ID4gPiANCj4gPiA+IC4uLmNoZWNr
IHRoYXQgd2UgZG8gaW4gdGhlIG1jZSBub3RpZmljYXRpb24gY2FzZT8gTWF5YmUgbm90IHNpbmNl
DQo+ID4gPiB3ZQ0KPiA+ID4gZG9uJ3QgZ2V0IGFuIGluZGljYXRpb24gb2Ygd2hlcmUgdGhlIGVy
cm9yIGlzIHdpdGhvdXQgYSByZXNjYW4uDQo+ID4gDQo+ID4gSSB0aGluayB0aGlzIG1jZSBjYXNl
IGlzIGRpZmZlcmVudCBzaW5jZSB0aGUgTUNFIGhhbmRsZXIgYWxyZWFkeQ0KPiA+IGtub3dzIHdo
ZXJlIHRoZSBuZXcgcG9pc29uIGxvY2F0aW9uIGlzIGFuZCBjYW4gdXBkYXRlIGJhZGJsb2Nrcw0K
PiA+IGluZm9ybWF0aW9uIGZvciBpdC7CoMKgU3RhcnRpbmcgQVJTIGlzIGFuIG9wdGlvbmFsIHBy
ZWNhdXRpb24uDQo+ID4gDQo+ID4gPiBIb3dldmVyLCBhdCBhIG1pbmltdW0gSSB0aGluayB3ZSBu
ZWVkIHN1cHBvcnQgZm9yIHRoZSBuZXcgU3RhcnQNCj4gPiA+IEFSUyBmbGFnICgiSWYgc2V0IHRv
IDEgdGhlIGZpcm13YXJlIHNoYWxsIHJldHVybiBkYXRhIGZyb20gYQ0KPiA+ID4gcHJldmlvdXMg
c2NydWIsIGlmIGFueSwgd2l0aG91dCBzdGFydGluZyBhIG5ldyBzY3J1YiIpIGFuZCB1c2UNCj4g
PiA+IHRoYXQgZm9yIHRoaXMgY2FzZS4NCj4gPiANCj4gPiBUaGF0J3MgYW4gaW50ZXJlc3Rpbmcg
aWRlYS7CoMKgQnV0IEkgd29uZGVyIGhvdyB1c2VycyBrbm93IGlmIGl0IGlzDQo+ID4gT0sgdG8g
c2V0IHRoaXMgZmxhZyBhcyBpdCByZWxpZXMgb24gQklPUyBpbXBsZW1lbnRhdGlvbiB0aGF0IGlz
IG5vdA0KPiA+IGRlc2NyaWJlZCBpbiBBQ1BJLi4uDQo+IA0KPiBVZ2gsIHlvdSdyZSByaWdodC4g
V2UgbWlnaHQgbmVlZCBhIHJldmlzaW9uLWlkPTIgdmVyc2lvbiBvZiBTdGFydCBBUlMNCj4gc28g
c29mdHdhcmUga25vd3MgdGhhdCB0aGUgQklPUyBpcyBhd2FyZSBvZiB0aGUgbmV3IGZsYWcuDQoN
Ck15IGJhZC4gIExvb2tpbmcgYXQgQUNQSSA2LjIsIGl0IGFjdHVhbGx5IGRlZmluZXMgd2hhdCB5
b3UgZGVzY3JpYmVkLiANClN0YXJ0IEFSUyBub3cgZGVmaW5lcyBiaXRbMV0gaW4gRmxhZ3Mgd2hp
Y2ggY2FuIGJlIHNldCB0byBhdm9pZA0Kc2Nhbm5pbmcgZm9yIHRoaXMgbm90aWZpY2F0aW9uLiAg
SSB3aWxsIHVwZGF0ZSB0aGUgcGF0Y2ggdG8gc2V0IHRoaXMNCmZsYWcgd2hlbiBIV19FUlJPUl9T
Q1JVQl9PTiBpcyBub3Qgc2V0Lg0KDQpUaGFua3MsDQotVG9zaGkKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApM
aW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlz
dGluZm8vbGludXgtbnZkaW1tCg==
