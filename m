Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com
 [IPv6:2607:f8b0:4864:20::741])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C362021297065
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jun 2019 14:00:31 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id c11so2886702qkk.8
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jun 2019 14:00:31 -0700 (PDT)
Message-ID: <1561582828.5154.83.camel@lca.pw>
Subject: Re: [RESEND PATCH] nvdimm: fix some compilation warnings
From: Qian Cai <cai@lca.pw>
Date: Wed, 26 Jun 2019 17:00:28 -0400
In-Reply-To: <cd6db786ff5758914c77add4d7a9391886038c84.camel@intel.com>
References: <20190514150735.39625-1-cai@lca.pw>
 <CAPcyv4gGwyPf0j4rXRM3JjsjGSHB6bGdZfwg+v2y8NQ6hNVK8g@mail.gmail.com>
 <7ba8164b60be4e41707559ed6623f9462c942735.camel@intel.com>
 <CAPcyv4gLr_WrNOg58C5tfpZTp2wso1C=kHGDkMvH4+sGniLQMQ@mail.gmail.com>
 <cd6db786ff5758914c77add4d7a9391886038c84.camel@intel.com>
Mime-Version: 1.0
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCAyMDE5LTA1LTE2IGF0IDAwOjI5ICswMDAwLCBWZXJtYSwgVmlzaGFsIEwgd3JvdGU6
Cj4gT24gV2VkLCAyMDE5LTA1LTE1IGF0IDE3OjI2IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6
Cj4gPiBPbiBXZWQsIE1heSAxNSwgMjAxOSBhdCA1OjI1IFBNIFZlcm1hLCBWaXNoYWwgTAo+ID4g
PHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4gd3JvdGU6Cj4gPiA+IE9uIFdlZCwgMjAxOS0wNS0x
NSBhdCAxNjoyNSAtMDcwMCwgRGFuIFdpbGxpYW1zIHdyb3RlOgo+ID4gPiA+ID4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbnZkaW1tL2J0dC5jIGIvZHJpdmVycy9udmRpbW0vYnR0LmMKPiA+ID4gPiA+
IGluZGV4IDQ2NzE3NzZmNTYyMy4uOWYwMmE5OWNmYWMwIDEwMDY0NAo+ID4gPiA+ID4gLS0tIGEv
ZHJpdmVycy9udmRpbW0vYnR0LmMKPiA+ID4gPiA+ICsrKyBiL2RyaXZlcnMvbnZkaW1tL2J0dC5j
Cj4gPiA+ID4gPiBAQCAtMTI2OSwxMSArMTI2OSw5IEBAIHN0YXRpYyBpbnQgYnR0X3JlYWRfcGco
c3RydWN0IGJ0dCAqYnR0LAo+ID4gPiA+ID4gc3RydWN0IGJpb19pbnRlZ3JpdHlfcGF5bG9hZCAq
YmlwLAo+ID4gPiA+ID4gCj4gPiA+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHJldCA9IGJ0dF9kYXRhX3JlYWQoYXJlbmEsIHBhZ2UsIG9mZiwgcG9zdG1hcCwKPiA+ID4gPiA+
IGN1cl9sZW4pOwo+ID4gPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAo
cmV0KSB7Cj4gPiA+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGludCByYzsKPiA+ID4gPiA+IC0KPiA+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIE1lZGlhIGVycm9yIC0gc2V0IHRoZSBlX2Zs
YWcgKi8KPiA+ID4gPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgcmMgPSBidHRfbWFwX3dyaXRlKGFyZW5hLCBwcmVtYXAsCj4gPiA+ID4gPiBwb3N0bWFw
LCAwLCAxLAo+ID4gPiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgTlZESU1NX0lPX0FUT01JQyk7Cj4gPiA+ID4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJ0dF9tYXBfd3JpdGUo
YXJlbmEsIHByZW1hcCwgcG9zdG1hcCwgMCwKPiA+ID4gPiA+IDEsCj4gPiA+ID4gPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBOVkRJTU1fSU9fQVRPTUlDKTsKPiA+ID4gPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0X3J0dDsKPiA+ID4gPiAKPiA+
ID4gPiBUaGlzIGRvZXNuJ3QgbG9vayBjb3JyZWN0IHRvIG1lLCBzaG91bGRuJ3Qgd2UgYXQgbGVh
c3QgYmUgbG9nZ2luZwo+ID4gPiA+IHRoYXQKPiA+ID4gPiB0aGUgYmFkLWJsb2NrIGZhaWxlZCB0
byBiZSBwZXJzaXN0ZW50bHkgdHJhY2tlZD8KPiA+ID4gCj4gPiA+IFllcyBsb2dnaW5nIGl0IHNv
dW5kcyBnb29kIHRvIG1lLiBRaWFuLCBjYW4geW91IGluY2x1ZGUgdGhpcyBpbiB5b3VyCj4gPiA+
IHJlc3BpbiBvciBzaGFsbCBJIHNlbmQgYSBmaXggZm9yIGl0IHNlcGFyYXRlbHkgKHNpbmNlIHdl
IHdlcmUgYWx3YXlzCj4gPiA+IGlnbm9yaW5nIHRoZSBmYWlsdXJlIGhlcmUgcmVnYXJkbGVzcyBv
ZiB0aGlzIHBhdGNoKT8KPiA+IAo+ID4gSSB0aGluayBhIHNlcGFyYXRlIGZpeCBmb3IgdGhpcyBt
YWtlcyBtb3JlIHNlbnNlLiBMaWtlbHkgYWxzbyBuZWVkcyB0bwo+ID4gYmUgYSByYXRlbGltaXRl
ZCBtZXNzYWdlIGluIGNhc2UgYSBzdG9ybSBvZiBlcnJvcnMgaXMgZW5jb3VudGVyZWQuCj4gCj4g
WWVzIGdvb2QgcG9pbnQgb24gcmF0ZSBsaW1pdGluZyAtIEkgd2FzIHRoaW5raW5nIFdBUk5fT05D
RSBidXQgdGhhdAo+IG1pZ2h0IG1hc2sgZXJyb3JzIGZvciBkaXN0aW5jdCBibG9ja3MsIGJ1dCBh
IHJhdGUgbGltaXRlZCBwcmludGsgc2hvdWxkCj4gd29yayBiZXN0LiBJJ2xsIHByZXBhcmUgYSBw
YXRjaC4KPiAKClZlcm1hLCBhcmUgeW91IHN0aWxsIHdvcmtpbmcgb24gdGhpcz8gSSBjYW4gc3Rp
bGwgc2VlIHRoaXMgd2FybmluZyBpbiB0aGUgbGF0ZXN0CmxpbnV4LW5leHQuCgpkcml2ZXJzL252
ZGltbS9idHQuYzogSW4gZnVuY3Rpb24gJ2J0dF9yZWFkX3BnJzoKZHJpdmVycy9udmRpbW0vYnR0
LmM6MTI3Mjo4OiB3YXJuaW5nOiB2YXJpYWJsZSAncmMnIHNldCBidXQgbm90IHVzZWQKWy1XdW51
c2VkLWJ1dC1zZXQtdmFyaWFibGVdCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0
cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRp
bW0K
