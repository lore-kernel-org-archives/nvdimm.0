Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 732F5210C0CFC
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 22:33:27 -0700 (PDT)
Subject: Re: [PATCH 3/3] kvm: add a function to check if page is from NVDIMM
 pmem.
References: <cover.1530716899.git.yi.z.zhang@linux.intel.com>
 <359fdf0103b61014bf811d88d4ce36bc793d18f2.1530716899.git.yi.z.zhang@linux.intel.com>
 <1efab832-8782-38f3-9fd5-7a8b45bde153@redhat.com>
From: "Zhang,Yi" <yi.z.zhang@linux.intel.com>
Message-ID: <a6049ab7-19f4-3cdb-a954-c8ad7a05ed37@linux.intel.com>
Date: Thu, 5 Jul 2018 21:19:30 +0800
MIME-Version: 1.0
In-Reply-To: <1efab832-8782-38f3-9fd5-7a8b45bde153@redhat.com>
Content-Language: en-US
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
To: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, jack@suse.cz, hch@lst.de, yu.c.zhang@intel.com
Cc: linux-mm@kvack.org, yi.z.zhang@intel.com, rkrcmar@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAyMDE45bm0MDfmnIgwNOaXpSAyMzoyNSwgUGFvbG8gQm9uemluaSB3cm90ZToKPiBPbiAw
NC8wNy8yMDE4IDE3OjMwLCBaaGFuZyBZaSB3cm90ZToKPj4gRm9yIGRldmljZSBzcGVjaWZpYyBt
ZW1vcnkgc3BhY2UsIHdoZW4gd2UgbW92ZSB0aGVzZSBhcmVhIG9mIHBmbiB0bwo+PiBtZW1vcnkg
em9uZSwgd2Ugd2lsbCBzZXQgdGhlIHBhZ2UgcmVzZXJ2ZWQgZmxhZyBhdCB0aGF0IHRpbWUsIHNv
bWUgb2YKPj4gdGhlc2UgcmVzZXJ2ZWQgZm9yIGRldmljZSBtbWlvLCBhbmQgc29tZSBvZiB0aGVz
ZSBhcmUgbm90LCBzdWNoIGFzCj4+IE5WRElNTSBwbWVtLgo+Pgo+PiBOb3csIHdlIG1hcCB0aGVz
ZSBkZXZfZGF4IG9yIGZzX2RheCBwYWdlcyB0byBrdm0gZm9yIERJTU0vTlZESU1NCj4+IGJhY2tl
bmQsIHNpbmNlIHRoZXNlIHBhZ2VzIGFyZSByZXNlcnZlZC4gdGhlIGNoZWNrIG9mCj4+IGt2bV9p
c19yZXNlcnZlZF9wZm4oKSBtaXNjb25jZWl2ZXMgdGhvc2UgcGFnZXMgYXMgTU1JTy4gVGhlcmVm
b3IsIHdlCj4+IGludHJvZHVjZSAyIHBhZ2UgbWFwIHR5cGVzLCBNRU1PUllfREVWSUNFX0ZTX0RB
WC9NRU1PUllfREVWSUNFX0RFVl9EQVgsCj4+IHRvIGluZGVudGlmeSB0aGVzZSBwYWdlcyBhcmUg
ZnJvbSBOVkRJTU0gcG1lbS4gYW5kIGxldCBrdm0gdHJlYXQgdGhlc2UKPj4gYXMgbm9ybWFsIHBh
Z2VzLgo+Pgo+PiBXaXRob3V0IHRoaXMgcGF0Y2gsIE1hbnkgb3BlcmF0aW9ucyB3aWxsIGJlIG1p
c3NlZCBkdWUgdG8gdGhpcwo+PiBtaXN0cmVhdG1lbnQgdG8gcG1lbSBwYWdlcy4gRm9yIGV4YW1w
bGUsIGEgcGFnZSBtYXkgbm90IGhhdmUgY2hhbmNlIHRvCj4+IGJlIHVucGlubmVkIGZvciBLVk0g
Z3Vlc3QoaW4ga3ZtX3JlbGVhc2VfcGZuX2NsZWFuKTsgbm90IGFibGUgdG8gYmUKPj4gbWFya2Vk
IGFzIGRpcnR5L2FjY2Vzc2VkKGluIGt2bV9zZXRfcGZuX2RpcnR5L2FjY2Vzc2VkKSBldGMuCj4+
Cj4+IFNpZ25lZC1vZmYtYnk6IFpoYW5nIFlpIDx5aS56LnpoYW5nQGxpbnV4LmludGVsLmNvbT4K
Pj4gU2lnbmVkLW9mZi1ieTogWmhhbmcgWXUgPHl1LmMuemhhbmdAbGludXguaW50ZWwuY29tPgo+
PiAtLS0KPj4gIHZpcnQva3ZtL2t2bV9tYWluLmMgfCAxNyArKysrKysrKysrKysrKystLQo+PiAg
MSBmaWxlIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+Cj4+IGRp
ZmYgLS1naXQgYS92aXJ0L2t2bS9rdm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21haW4uYwo+PiBp
bmRleCBhZmIyZTZlLi4xMzY1ZDE4IDEwMDY0NAo+PiAtLS0gYS92aXJ0L2t2bS9rdm1fbWFpbi5j
Cj4+ICsrKyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMKPj4gQEAgLTE0MCwxMCArMTQwLDIzIEBAIF9f
d2VhayB2b2lkIGt2bV9hcmNoX21tdV9ub3RpZmllcl9pbnZhbGlkYXRlX3JhbmdlKHN0cnVjdCBr
dm0gKmt2bSwKPj4gIHsKPj4gIH0KPj4gIAo+PiArc3RhdGljIGJvb2wga3ZtX2lzX25kX3Bmbihr
dm1fcGZuX3QgcGZuKQo+PiArewo+PiArCXN0cnVjdCBwYWdlICpwYWdlID0gcGZuX3RvX3BhZ2Uo
cGZuKTsKPj4gKwo+PiArCXJldHVybiBpc196b25lX2RldmljZV9wYWdlKHBhZ2UpICYmCj4+ICsJ
CSgocGFnZS0+cGdtYXAtPnR5cGUgPT0gTUVNT1JZX0RFVklDRV9GU19EQVgpIHx8Cj4+ICsJCSAo
cGFnZS0+cGdtYXAtPnR5cGUgPT0gTUVNT1JZX0RFVklDRV9ERVZfREFYKSk7Cj4+ICt9Cj4gSWYg
dGhlIG1tIHBlb3BsZSBhZ3JlZSwgSSdkIHByZWZlciBzb21ldGhpbmcgdGhhdCB0YWtlcyBhIHN0
cnVjdCBwYWdlICoKPiBhbmQgaXMgZXhwb3J0ZWQgYnkgaW5jbHVkZS9saW51eC9tbS5oLiAgVGhl
biBLVk0gY2FuIGp1c3QgZG8gc29tZXRoaW5nIGxpa2UKPgo+IAlzdHJ1Y3QgcGFnZSAqcGFnZTsK
PiAJaWYgKCFwZm5fdmFsaWQocGZuKSkKPiAJCXJldHVybiB0cnVlOwo+Cj4gCXBhZ2UgPSBwZm5f
dG9fcGFnZShwZm4pOwo+IAlyZXR1cm4gUGFnZVJlc2VydmVkKHBhZ2UpICYmICFpc19kYXhfcGFn
ZShwYWdlKTsKPgo+IFRoYW5rcywKPgo+IFBhb2xvClllYWgsIHRoYXQgY291bGQgYmUgbXVjaCBi
ZXR0ZXIuIFRoYW5rcyBmb3IgeW91ciBjb21tZW50cyBQYW9sby4KCkhpIEthcmEsIERvIHUgaGF2
ZSBBbnkgb3BpbmlvbnMvaWRlYXMgdG8gYWRkIHN1Y2ggZGVmaW5pdGlvbiBpbiBtbT8KClJlZ2Fy
ZHMsCllpCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxp
bnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczov
L2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
