Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1A41722212BE0
 for <linux-nvdimm@lists.01.org>; Sun, 17 Dec 2017 09:21:37 -0800 (PST)
Received: by mail-oi0-x241.google.com with SMTP id w131so9240283oiw.0
 for <linux-nvdimm@lists.01.org>; Sun, 17 Dec 2017 09:26:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171215140947.26075-12-hch@lst.de>
References: <20171215140947.26075-1-hch@lst.de>
 <20171215140947.26075-12-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 17 Dec 2017 09:26:20 -0800
Message-ID: <CAPcyv4hbezncGj16p9D2ypsPbfmJwMVbaZ36XpuCsf640O4xtA@mail.gmail.com>
Subject: Re: [PATCH 11/17] mm: move get_dev_pagemap out of line
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
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCBEZWMgMTUsIDIwMTcgYXQgNjowOSBBTSwgQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBs
c3QuZGU+IHdyb3RlOgo+IFRoaXMgaXMgYSBwcmV0dHkgYmlnIGZ1bmN0aW9uLCB3aGljaCBzaG91
bGQgYmUgb3V0IG9mIGxpbmUgaW4gZ2VuZXJhbCwKPiBhbmQgYSBuby1vcCBzdHViIGlmIENPTkZJ
R19aT05FX0RFVklD0JUgaXMgbm90IHNldC4KPgo+IFNpZ25lZC1vZmYtYnk6IENocmlzdG9waCBI
ZWxsd2lnIDxoY2hAbHN0LmRlPgo+IFJldmlld2VkLWJ5OiBMb2dhbiBHdW50aG9ycGUgPGxvZ2Fu
Z0BkZWx0YXRlZS5jb20+ClsuLl0KPiArLyoqCj4gKyAqIGdldF9kZXZfcGFnZW1hcCgpIC0gdGFr
ZSBhIG5ldyBsaXZlIHJlZmVyZW5jZSBvbiB0aGUgZGV2X3BhZ2VtYXAgZm9yIEBwZm4KPiArICog
QHBmbjogcGFnZSBmcmFtZSBudW1iZXIgdG8gbG9va3VwIHBhZ2VfbWFwCj4gKyAqIEBwZ21hcDog
b3B0aW9uYWwga25vd24gcGdtYXAgdGhhdCBhbHJlYWR5IGhhcyBhIHJlZmVyZW5jZQo+ICsgKgo+
ICsgKiBAcGdtYXAgYWxsb3dzIHRoZSBvdmVyaGVhZCBvZiBhIGxvb2t1cCB0byBiZSBieXBhc3Nl
ZCB3aGVuIEBwZm4gbGFuZHMgaW4gdGhlCj4gKyAqIHNhbWUgbWFwcGluZy4KPiArICovCj4gK3N0
cnVjdCBkZXZfcGFnZW1hcCAqZ2V0X2Rldl9wYWdlbWFwKHVuc2lnbmVkIGxvbmcgcGZuLAo+ICsg
ICAgICAgICAgICAgICBzdHJ1Y3QgZGV2X3BhZ2VtYXAgKnBnbWFwKQo+ICt7Cj4gKyAgICAgICBj
b25zdCBzdHJ1Y3QgcmVzb3VyY2UgKnJlcyA9IHBnbWFwID8gcGdtYXAtPnJlcyA6IE5VTEw7Cj4g
KyAgICAgICByZXNvdXJjZV9zaXplX3QgcGh5cyA9IFBGTl9QSFlTKHBmbik7Cj4gKwo+ICsgICAg
ICAgLyoKPiArICAgICAgICAqIEluIHRoZSBjYWNoZWQgY2FzZSB3ZSdyZSBhbHJlYWR5IGhvbGRp
bmcgYSBsaXZlIHJlZmVyZW5jZSBzbwo+ICsgICAgICAgICogd2UgY2FuIHNpbXBseSBkbyBhIGJs
aW5kIGluY3JlbWVudAo+ICsgICAgICAgICovCj4gKyAgICAgICBpZiAocmVzICYmIHBoeXMgPj0g
cmVzLT5zdGFydCAmJiBwaHlzIDw9IHJlcy0+ZW5kKSB7Cj4gKyAgICAgICAgICAgICAgIHBlcmNw
dV9yZWZfZ2V0KHBnbWFwLT5yZWYpOwo+ICsgICAgICAgICAgICAgICByZXR1cm4gcGdtYXA7Cj4g
KyAgICAgICB9CgpJIHdhcyBnb2luZyB0byBzYXkga2VlcCB0aGUgY2FjaGVkIGNhc2UgaW4gdGhl
IHN0YXRpYyBpbmxpbmUsIGJ1dCB3aXRoCnRoZSBvcHRpbWl6YXRpb24gdG8gdGhlIGNhbGxpbmcg
Y29udmVudGlvbiBpbiB0aGUgZm9sbG93aW5nIHBhdGNoIEkKdGhpbmsgdGhhdCBtYWtlcyB0aGlz
IG1vb3QuCgpTbywKClJldmlld2VkLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGlu
dGVsLmNvbT4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
TGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBz
Oi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
