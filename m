Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 901F01A1DFA
 for <linux-nvdimm@lists.01.org>; Fri,  9 Sep 2016 10:45:55 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] libnvdimm: allow legacy (e820) pmem region to clear bad
 blocks
Date: Fri, 9 Sep 2016 17:45:53 +0000
Message-ID: <1473443112.18144.26.camel@intel.com>
References: <147337760801.38083.16900960834862325097.stgit@djiang5-desk3.ch.intel.com>
 <1473380906.3095.9.camel@intel.com>
 <CAPcyv4jtM0p6VhcS3f3UhE4YyVk9+TjTXBLXAUJ_meshm80C9w@mail.gmail.com>
In-Reply-To: <CAPcyv4jtM0p6VhcS3f3UhE4YyVk9+TjTXBLXAUJ_meshm80C9w@mail.gmail.com>
Content-Language: en-US
Content-ID: <8DD8C1C578EABB49A7433FE3789CA697@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE2LTA5LTA4IGF0IDIwOjU3IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IE9uIFRodSwgU2VwIDgsIDIwMTYgYXQgNToyOCBQTSwgVmVybWEsIFZpc2hhbCBMDQo+IDx2aXNo
YWwubC52ZXJtYUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFRodSwgMjAxNi0wOS0w
OCBhdCAxNjozMyAtMDcwMCwgRGF2ZSBKaWFuZyB3cm90ZToNCj4gPiA+IA0KPiA+ID4gQmFkIGJs
b2NrcyBjYW4gYmUgaW5qZWN0ZWQgdmlhIC9zeXMvYmxvY2svcG1lbU4vYmFkYmxvY2tzLiBJbiBh
DQo+ID4gPiBzaXR1YXRpb24NCj4gPiA+IHdoZXJlIGxlZ2FjeSBwbWVtIGlzIGJlaW5nIHVzZWQg
b3IgYSBwbWVtIHJlZ2lvbiBjcmVhdGVkIGJ5IHVzaW5nDQo+ID4gPiBtZW1tYXANCj4gPiA+IGtl
cm5lbCBwYXJhbWV0ZXIsIHRoZSBpbmplY3RlZCBiYWQgYmxvY2tzIGFyZSBub3QgY2xlYXJlZCBk
dWUgdG8NCj4gPiA+IG52ZGltbV9jbGVhcl9wb2lzb24oKSBmYWlsaW5nIGZyb20gbGFjayBvZiBu
ZGN0bCBmdW5jdGlvbiBwb2ludGVyLg0KPiA+ID4gSW4NCj4gPiA+IHRoaXMgY2FzZSB3ZSBuZWVk
IHRvIGp1c3QgcmV0dXJuIGFzIGhhbmRsZWQgYW5kIGFsbG93IHRoZSBiYWQNCj4gPiA+IGJsb2Nr
cw0KPiA+ID4gdG8NCj4gPiA+IGJlIGNsZWFyZWQgcmF0aGVyIHRoYW4gZmFpbC4NCj4gPiA+IA0K
PiA+ID4gU2lnbmVkLW9mZi1ieTogRGF2ZSBKaWFuZyA8ZGF2ZS5qaWFuZ0BpbnRlbC5jb20+DQo+
ID4gPiAtLS0NCj4gPiA+IMKgZHJpdmVycy9udmRpbW0vYnVzLmMgfMKgwqDCoMKgNiArKysrKy0N
Cj4gPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0K
PiA+IA0KPiA+IExvb2tzIGdvb2QgdG8gbWUhDQo+ID4gUmV2ZWlld2VkLWJ5OiBWaXNoYWwgVmVy
bWEgPFZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCj4gDQo+IEFwcGxpZWQsIGFsdGhvdWdoIEkg
anVzdCBub3RpY2VkIHRoYXQgcGF0Y2h3b3JrIGRpZCBub3QgcGljayB1cCB0aGF0DQo+IHJldmll
d2VkLWJ5IGR1ZSB0byB0aGUgdHlwby4NCg0KT29wcywgdGhhdCdzIHdoYXQgaGFwcGVucyB3aGVu
IEkgdHlwZSBzdHVmZiBvdXQgaW5zdGVhZCBvZiB1c2luZyB2aW0NCm1hY3JvcyA6KQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFp
bGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcv
bWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
