Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3428.houston.hp.com (g4t3428.houston.hp.com [15.201.208.56])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BBE221A1E7E
 for <linux-nvdimm@lists.01.org>; Wed, 13 Apr 2016 12:01:16 -0700 (PDT)
Message-ID: <1460573564.24985.60.camel@hpe.com>
Subject: Re: [PATCH v2 2/5] ext4: call dax_get_unmapped_area() for DAX pmd
 mappings
From: Toshi Kani <toshi.kani@hpe.com>
Date: Wed, 13 Apr 2016 12:52:44 -0600
In-Reply-To: <20160413182249.GB3120@linux.intel.com>
References: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
 <20160413030156.GN2781@linux.intel.com> <1460560116.24985.55.camel@hpe.com>
 <20160413182249.GB3120@linux.intel.com>
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

T24gV2VkLCAyMDE2LTA0LTEzIGF0IDE0OjIyIC0wNDAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToK
PiBPbiBXZWQsIEFwciAxMywgMjAxNiBhdCAwOTowODozNkFNIC0wNjAwLCBUb3NoaSBLYW5pIHdy
b3RlOgo+ID4gCj4gPiA+IAo+ID4gPiBDb3VsZCB5b3UgZG8gc29tZXRoaW5nIGxpa2U6Cj4gPiA+
IAo+ID4gPiDCoCNpZmRlZiBDT05GSUdfRlNfREFYCj4gPiA+IMKgc3RydWN0IHBhZ2UgKnJlYWRf
ZGF4X3NlY3RvcihzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBzZWN0b3JfdCBuKTsKPiA+ID4g
K3Vuc2lnbmVkIGxvbmcgZGF4X2dldF91bm1hcHBlZF9hcmVhKHN0cnVjdCBmaWxlICpmaWxwLCB1
bnNpZ25lZCBsb25nCj4gPiA+IGFkZHIsCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqB1bnNpZ25lZCBsb25nIGxlbiwgdW5zaWduZWQgbG9uZyBwZ29mZiwgdW5zaWduZWQgbG9u
Zwo+ID4gPiBmbGFncyk7Cj4gPiA+IMKgI2Vsc2UKPiA+ID4gwqBzdGF0aWMgaW5saW5lIHN0cnVj
dCBwYWdlICpyZWFkX2RheF9zZWN0b3Ioc3RydWN0IGJsb2NrX2RldmljZQo+ID4gPiAqYmRldiwK
PiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHNlY3Rvcl90IG4pCj4gPiA+
IMKgewo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gRVJSX1BUUigtRU5YSU8pOwo+ID4g
PiDCoH0KPiA+ID4gKyNkZWZpbmUgZGF4X2dldF91bm1hcHBlZF9hcmVhCU5VTEwKPiA+ID4gwqAj
ZW5kaWYKPiA+ID4gCj4gPiA+IGluIHBhdGNoIDEvNS7CoMKgVGhlbiB0aGVyZSdzIG5vIG5lZWQg
Zm9yIHRoZSBpZmRlZnMgaW4gZWFjaAo+ID4gPiBmaWxlc3lzdGVtLgo+ID4KPiA+IEkgdGhvdWdo
dCBhYm91dCBpdCwgYnV0IEkgZG8gbm90IHRoaW5rIHdlIGNhbiB1c2UgYW4gaW5saW5lIGZ1bmN0
aW9uIHRvCj4gPiBhbiBlbnRyeSBwb2ludC4KPgo+IFRoYXQncyBub3QgYW4gaW5saW5lIGZ1bmN0
aW9uLsKgwqBJdCdzIGp1c3QgTlVMTC7CoMKgU28gYWZ0ZXIgdGhlCj4gcHJlcHJvY2Vzc29yIGlz
IGRvbmUgd2l0aCBpdCwgaXQganVzdCBsb29rcyBsaWtlOgo+IAo+IAkuZ2V0X3VubWFwcGVkX2Fy
ZWEgPSBOVUxMLAo+IAo+IGFuZCBpdCB3b24ndCBiZSBjYWxsZWQgYnkgZ2V0X3VubWFwcGVkX2Fy
ZWEoKS4KCk9oLCBJIHNlZS4gR29vZCBpZGVhLiBJIHdpbGwgZG8gdGhhdC4KClRoYW5rcywKLVRv
c2hpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4
LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xp
c3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
