Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64AD8210EE4C5
 for <linux-nvdimm@lists.01.org>; Mon, 13 Aug 2018 02:57:39 -0700 (PDT)
Subject: Re: [PATCH V3 3/4] mm: add a function to differentiate the pages is
 from DAX device memory
References: <cover.1533811181.git.yi.z.zhang@linux.intel.com>
 <2b7856596e519130946c834d5d61b00b7f592770.1533811181.git.yi.z.zhang@linux.intel.com>
 <872818364.892078.1533806608252.JavaMail.zimbra@redhat.com>
From: "Zhang,Yi" <yi.z.zhang@linux.intel.com>
Message-ID: <5ea50e63-b55a-c1e1-50be-6e2d951c04cf@linux.intel.com>
Date: Tue, 14 Aug 2018 01:41:40 +0800
MIME-Version: 1.0
In-Reply-To: <872818364.892078.1533806608252.JavaMail.zimbra@redhat.com>
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
To: Pankaj Gupta <pagupta@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
Cc: jack@suse.cz, yu c zhang <yu.c.zhang@intel.com>, kvm@vger.kernel.org, linux-nvdimm@lists.01.org, rkrcmar@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, hch@lst.de, yi z zhang <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAyMDE45bm0MDjmnIgwOeaXpSAxNzoyMywgUGFua2FqIEd1cHRhIHdyb3RlOgo+PiBEQVgg
ZHJpdmVyIGhvdHBsdWcgdGhlIGRldmljZSBtZW1vcnkgYW5kIG1vdmUgaXQgdG8gbWVtb3J5IHpv
bmUsIHRoZXNlCj4+IHBhZ2VzIHdpbGwgYmUgbWFya2VkIHJlc2VydmVkIGZsYWcsIGhvd2V2ZXIs
IHNvbWUgb3RoZXIga2VybmVsIGNvbXBvbmV0Cj4+IHdpbGwgbWlzY29uY2VpdmUgdGhlc2UgcGFn
ZXMgYXJlIHJlc2VydmVkIG1taW8gKGV4OiB3ZSBtYXAgdGhlc2UgZGV2X2RheAo+PiBvciBmc19k
YXggcGFnZXMgdG8ga3ZtIGZvciBESU1NL05WRElNTSBiYWNrZW5kKS4gVG9nZXRoZXIgd2l0aCB0
aGUgdHlwZQo+PiBNRU1PUllfREVWSUNFX0ZTX0RBWCwgd2UgY2FuIHVzZSBpc19kYXhfcGFnZSgp
IHRvIGRpZmZlcmVudGlhdGUgdGhlIHBhZ2VzCj4+IGlzIERBWCBkZXZpY2UgbWVtb3J5IG9yIG5v
dC4KPj4KPj4gU2lnbmVkLW9mZi1ieTogWmhhbmcgWWkgPHlpLnouemhhbmdAbGludXguaW50ZWwu
Y29tPgo+PiBTaWduZWQtb2ZmLWJ5OiBaaGFuZyBZdSA8eXUuYy56aGFuZ0BsaW51eC5pbnRlbC5j
b20+Cj4+IC0tLQo+PiAgaW5jbHVkZS9saW51eC9tbS5oIHwgMTIgKysrKysrKysrKysrCj4+ICAx
IGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS9saW51eC9tbS5oIGIvaW5jbHVkZS9saW51eC9tbS5oCj4+IGluZGV4IDY4YTUxMjEuLmRlNWNi
YzMgMTAwNjQ0Cj4+IC0tLSBhL2luY2x1ZGUvbGludXgvbW0uaAo+PiArKysgYi9pbmNsdWRlL2xp
bnV4L21tLmgKPj4gQEAgLTg4OSw2ICs4ODksMTMgQEAgc3RhdGljIGlubGluZSBib29sIGlzX2Rl
dmljZV9wdWJsaWNfcGFnZShjb25zdCBzdHJ1Y3QKPj4gcGFnZSAqcGFnZSkKPj4gIAkJcGFnZS0+
cGdtYXAtPnR5cGUgPT0gTUVNT1JZX0RFVklDRV9QVUJMSUM7Cj4+ICB9Cj4+ICAKPj4gK3N0YXRp
YyBpbmxpbmUgYm9vbCBpc19kYXhfcGFnZShjb25zdCBzdHJ1Y3QgcGFnZSAqcGFnZSkKPj4gK3sK
Pj4gKwlyZXR1cm4gaXNfem9uZV9kZXZpY2VfcGFnZShwYWdlKSAmJgo+PiArCQkocGFnZS0+cGdt
YXAtPnR5cGUgPT0gTUVNT1JZX0RFVklDRV9GU19EQVggfHwKPj4gKwkJcGFnZS0+cGdtYXAtPnR5
cGUgPT0gTUVNT1JZX0RFVklDRV9ERVZfREFYKTsKPj4gK30KPiBJIHRoaW5rIHF1ZXN0aW9uIGZy
b20gRGFuIGZvciBLVk0gVk0gd2l0aCAnTUVNT1JZX0RFVklDRV9QVUJMSUMnIHN0aWxsIGhvbGRz
Pwo+IEkgYW0gYWxzbyBpbnRlcmVzdGVkIHRvIGtub3cgaWYgdGhlcmUgaXMgYW55IHVzZS1jYXNl
Lgo+Cj4gVGhhbmtzLAo+IFBhbmthagpZZXMsIGl0IGlzLCB0aGFua3MgZm9yIHlvdXIgcmVtaW5k
LCBQYW5rYWouCkFkZGluZyBKZXJvbWUgZm9yIERhbidzIHF1ZXN0aW9ucyBvbiBWMToKW0Rhbl06
CgpKZXJvbWUsIG1pZ2h0IHRoZXJlIGJlIGFueSB1c2UgY2FzZSB0byBwYXNzIE1FTU9SWV9ERVZJ
Q0VfUFVCTElDCm1lbW9yeSB0byBhIGd1ZXN0IHZtPwoKPgo+PiArCj4+ICAjZWxzZSAvKiBDT05G
SUdfREVWX1BBR0VNQVBfT1BTICovCj4+ICBzdGF0aWMgaW5saW5lIHZvaWQgZGV2X3BhZ2VtYXBf
Z2V0X29wcyh2b2lkKQo+PiAgewo+PiBAQCAtOTEyLDYgKzkxOSwxMSBAQCBzdGF0aWMgaW5saW5l
IGJvb2wgaXNfZGV2aWNlX3B1YmxpY19wYWdlKGNvbnN0IHN0cnVjdAo+PiBwYWdlICpwYWdlKQo+
PiAgewo+PiAgCXJldHVybiBmYWxzZTsKPj4gIH0KPj4gKwo+PiArc3RhdGljIGlubGluZSBib29s
IGlzX2RheF9wYWdlKGNvbnN0IHN0cnVjdCBwYWdlICpwYWdlKQo+PiArewo+PiArCXJldHVybiBm
YWxzZTsKPj4gK30KPj4gICNlbmRpZiAvKiBDT05GSUdfREVWX1BBR0VNQVBfT1BTICovCj4+ICAK
Pj4gIHN0YXRpYyBpbmxpbmUgdm9pZCBnZXRfcGFnZShzdHJ1Y3QgcGFnZSAqcGFnZSkKPj4gLS0K
Pj4gMi43LjQKPj4KPj4KCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9y
ZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
