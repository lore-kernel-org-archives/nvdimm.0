Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27474210C1EF8
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 22:34:32 -0700 (PDT)
Subject: Re: [PATCH 2/3] mm: introduce memory type MEMORY_DEVICE_DEV_DAX
References: <cover.1530716899.git.yi.z.zhang@linux.intel.com>
 <5c7996b8e6d31541f3185f8e4064ff97582c86f8.1530716899.git.yi.z.zhang@linux.intel.com>
 <CAPcyv4gjFVG7tHv65Z=FsZ9=5wXDxNWawFJqO8MkyMudch4zDw@mail.gmail.com>
From: zhangyi6 <yi.z.zhang@intel.com>
Message-ID: <c5fad961-05ea-73da-7fda-f48c910136d9@intel.com>
Date: Thu, 5 Jul 2018 21:20:35 +0800
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gjFVG7tHv65Z=FsZ9=5wXDxNWawFJqO8MkyMudch4zDw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Zhang Yi <yi.z.zhang@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, "Zhang, Yu C" <yu.c.zhang@intel.com>, KVM list <kvm@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, rkrcmar@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAyMDE45bm0MDfmnIgwNOaXpSAyMjo1MCwgRGFuIFdpbGxpYW1zIHdyb3RlOgo+IE9uIFdl
ZCwgSnVsIDQsIDIwMTggYXQgODozMCBBTSwgWmhhbmcgWWkgPHlpLnouemhhbmdAbGludXguaW50
ZWwuY29tPiB3cm90ZToKPj4gQ3VycmVudGx5LCBOVkRJTU0gcGFnZXMgd2lsbCBiZSBtYXJrZWQg
J1BhZ2VSZXNlcnZlZCcuIEhvd2V2ZXIsIHVubGlrZQo+PiBvdGhlciByZXNlcnZlZCBQRk5zLCBw
YWdlcyBvbiBOVkRJTU0gc2hhbGwgc3RpbGwgYmVoYXZlIGxpa2Ugbm9ybWFsIG9uZXMKPj4gaW4g
bWFueSBjYXNlcywgaS5lLiB3aGVuIHVzZWQgYXMgYmFja2VuZCBtZW1vcnkgb2YgS1ZNIGd1ZXN0
LiBUaGlzIHBhdGNoCj4+IGludHJvZHVjZXMgYSBuZXcgbWVtb3J5IHR5cGUsIE1FTU9SWV9ERVZJ
Q0VfREVWX0RBWC4gVG9nZXRoZXIgd2l0aCB0aGUKPj4gZXhpc3RpbmcgdHlwZSBNRU1PUllfREVW
SUNFX0ZTX0RBWCwgd2UgY2FuIGRpZmZlcmVudGlhdGUgdGhlIHBhZ2VzIG9uCj4+IE5WRElNTSB3
aXRoIHRoZSBub3JtYWwgcmVzZXJ2ZWQgcGFnZXMuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IFpoYW5n
IFlpIDx5aS56LnpoYW5nQGxpbnV4LmludGVsLmNvbT4KPj4gU2lnbmVkLW9mZi1ieTogWmhhbmcg
WXUgPHl1LmMuemhhbmdAbGludXguaW50ZWwuY29tPgo+PiAtLS0KPj4gIGRyaXZlcnMvZGF4L3Bt
ZW0uYyAgICAgICB8IDEgKwo+PiAgaW5jbHVkZS9saW51eC9tZW1yZW1hcC5oIHwgMSArCj4+ICAy
IGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQo+Pgo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9kYXgvcG1lbS5jIGIvZHJpdmVycy9kYXgvcG1lbS5jCj4+IGluZGV4IGZkNDliMjQuLmZiM2Yz
NjMgMTAwNjQ0Cj4+IC0tLSBhL2RyaXZlcnMvZGF4L3BtZW0uYwo+PiArKysgYi9kcml2ZXJzL2Rh
eC9wbWVtLmMKPj4gQEAgLTExMSw2ICsxMTEsNyBAQCBzdGF0aWMgaW50IGRheF9wbWVtX3Byb2Jl
KHN0cnVjdCBkZXZpY2UgKmRldikKPj4gICAgICAgICAgICAgICAgIHJldHVybiByYzsKPj4KPj4g
ICAgICAgICBkYXhfcG1lbS0+cGdtYXAucmVmID0gJmRheF9wbWVtLT5yZWY7Cj4+ICsgICAgICAg
ZGF4X3BtZW0tPnBnbWFwLnR5cGUgPSBNRU1PUllfREVWSUNFX0RFVl9EQVg7Cj4+ICAgICAgICAg
YWRkciA9IGRldm1fbWVtcmVtYXBfcGFnZXMoZGV2LCAmZGF4X3BtZW0tPnBnbWFwKTsKPj4gICAg
ICAgICBpZiAoSVNfRVJSKGFkZHIpKQo+PiAgICAgICAgICAgICAgICAgcmV0dXJuIFBUUl9FUlIo
YWRkcik7Cj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21lbXJlbWFwLmggYi9pbmNsdWRl
L2xpbnV4L21lbXJlbWFwLmgKPj4gaW5kZXggNWViZmZmNi4uNDEyN2JmNyAxMDA2NDQKPj4gLS0t
IGEvaW5jbHVkZS9saW51eC9tZW1yZW1hcC5oCj4+ICsrKyBiL2luY2x1ZGUvbGludXgvbWVtcmVt
YXAuaAo+PiBAQCAtNTgsNiArNTgsNyBAQCBlbnVtIG1lbW9yeV90eXBlIHsKPj4gICAgICAgICBN
RU1PUllfREVWSUNFX1BSSVZBVEUgPSAxLAo+PiAgICAgICAgIE1FTU9SWV9ERVZJQ0VfUFVCTElD
LAo+PiAgICAgICAgIE1FTU9SWV9ERVZJQ0VfRlNfREFYLAo+PiArICAgICAgIE1FTU9SWV9ERVZJ
Q0VfREVWX0RBWCwKPiBQbGVhc2UgYWRkIGRvY3VtZW50YXRpb24gZm9yIHRoaXMgbmV3IHR5cGUg
dG8gdGhlIGNvbW1lbnQgYmxvY2sgYWJvdXQKPiB0aGlzIGRlZmluaXRpb24uClRoYW5rcyBmb3Ig
eW91ciBjb21tZW50cyBEYW4sIFdpbGwgYWRkIGl0IGluIG5leHQgdmVyc2lvbiwKUmVnYXJkcwpZ
aS4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgt
bnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlz
dHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
