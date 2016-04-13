Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE2F41A21CA
 for <linux-nvdimm@lists.01.org>; Wed, 13 Apr 2016 08:17:07 -0700 (PDT)
Message-ID: <1460560116.24985.55.camel@hpe.com>
Subject: Re: [PATCH v2 2/5] ext4: call dax_get_unmapped_area() for DAX pmd
 mappings
From: Toshi Kani <toshi.kani@hpe.com>
Date: Wed, 13 Apr 2016 09:08:36 -0600
In-Reply-To: <20160413030156.GN2781@linux.intel.com>
References: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
 <20160413030156.GN2781@linux.intel.com>
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
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, akpm@linux-foundation.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCAyMDE2LTA0LTEyIGF0IDIzOjAxIC0wNDAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToK
PiBPbiBUdWUsIEFwciAxMiwgMjAxNiBhdCAwMjozOToyOVBNIC0wNjAwLCBUb3NoaSBLYW5pIHdy
b3RlOgo+ID4gCj4gPiBUbyBzdXBwb3J0IERBWCBwbWQgbWFwcGluZ3Mgd2l0aCB1bm1vZGlmaWVk
IGFwcGxpY2F0aW9ucywKPiA+IGZpbGVzeXN0ZW1zIG5lZWQgdG8gYWxpZ24gYW4gbW1hcCBhZGRy
ZXNzIGJ5IHRoZSBwbWQgc2l6ZS4KPiA+IAo+ID4gQEAgLTcwOCw2ICs3MDgsOSBAQCBjb25zdCBz
dHJ1Y3QgZmlsZV9vcGVyYXRpb25zIGV4dDRfZmlsZV9vcGVyYXRpb25zID0KPiA+IHsKPiA+IMKg
CS5vcGVuCQk9IGV4dDRfZmlsZV9vcGVuLAo+ID4gwqAJLnJlbGVhc2UJPSBleHQ0X3JlbGVhc2Vf
ZmlsZSwKPiA+IMKgCS5mc3luYwkJPSBleHQ0X3N5bmNfZmlsZSwKPiA+ICsjaWZkZWYgQ09ORklH
X0ZTX0RBWAo+ID4gKwkuZ2V0X3VubWFwcGVkX2FyZWEgPSBkYXhfZ2V0X3VubWFwcGVkX2FyZWEs
Cj4gPiArI2VuZGlmCj4gPiDCoAkuc3BsaWNlX3JlYWQJPSBnZW5lcmljX2ZpbGVfc3BsaWNlX3Jl
YWQsCj4gPiDCoAkuc3BsaWNlX3dyaXRlCT0gaXRlcl9maWxlX3NwbGljZV93cml0ZSwKPiA+IMKg
CS5mYWxsb2NhdGUJPSBleHQ0X2ZhbGxvY2F0ZSwKPgo+IENvdWxkIHlvdSBkbyBzb21ldGhpbmcg
bGlrZToKPiAKPiDCoCNpZmRlZiBDT05GSUdfRlNfREFYCj4gwqBzdHJ1Y3QgcGFnZSAqcmVhZF9k
YXhfc2VjdG9yKHN0cnVjdCBibG9ja19kZXZpY2UgKmJkZXYsIHNlY3Rvcl90IG4pOwo+ICt1bnNp
Z25lZCBsb25nIGRheF9nZXRfdW5tYXBwZWRfYXJlYShzdHJ1Y3QgZmlsZSAqZmlscCwgdW5zaWdu
ZWQgbG9uZwo+IGFkZHIsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHVuc2lnbmVk
IGxvbmcgbGVuLCB1bnNpZ25lZCBsb25nIHBnb2ZmLCB1bnNpZ25lZCBsb25nCj4gZmxhZ3MpOwo+
IMKgI2Vsc2UKPiDCoHN0YXRpYyBpbmxpbmUgc3RydWN0IHBhZ2UgKnJlYWRfZGF4X3NlY3Rvcihz
dHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBzZWN0b3JfdCBuKQo+IMKgewo+IMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBFUlJfUFRS
KC1FTlhJTyk7Cj4gwqB9Cj4gKyNkZWZpbmUgZGF4X2dldF91bm1hcHBlZF9hcmVhCU5VTEwKPiDC
oCNlbmRpZgo+IAo+IGluIHBhdGNoIDEvNS7CoMKgVGhlbiB0aGVyZSdzIG5vIG5lZWQgZm9yIHRo
ZSBpZmRlZnMgaW4gZWFjaCBmaWxlc3lzdGVtLgoKSSB0aG91Z2h0IGFib3V0IGl0LCBidXQgSSBk
byBub3QgdGhpbmsgd2UgY2FuIHVzZSBhbiBpbmxpbmUgZnVuY3Rpb24gdG8gYW4KZW50cnkgcG9p
bnQuCgpUaGFua3MsCi1Ub3NoaQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4w
MS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
