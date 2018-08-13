Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7DDFB20945C0A
 for <linux-nvdimm@lists.01.org>; Mon, 13 Aug 2018 07:29:11 -0700 (PDT)
Date: Mon, 13 Aug 2018 10:29:06 -0400
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH V3 3/4] mm: add a function to differentiate the pages is
 from DAX device memory
Message-ID: <20180813142906.GA3451@redhat.com>
References: <cover.1533811181.git.yi.z.zhang@linux.intel.com>
 <2b7856596e519130946c834d5d61b00b7f592770.1533811181.git.yi.z.zhang@linux.intel.com>
 <872818364.892078.1533806608252.JavaMail.zimbra@redhat.com>
 <5ea50e63-b55a-c1e1-50be-6e2d951c04cf@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5ea50e63-b55a-c1e1-50be-6e2d951c04cf@linux.intel.com>
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
To: "Zhang,Yi" <yi.z.zhang@linux.intel.com>
Cc: jack@suse.cz, yu c zhang <yu.c.zhang@intel.com>, kvm@vger.kernel.org, linux-nvdimm@lists.01.org, rkrcmar@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, hch@lst.de, yi z zhang <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCBBdWcgMTQsIDIwMTggYXQgMDE6NDE6NDBBTSArMDgwMCwgWmhhbmcsWWkgd3JvdGU6
Cj4gCj4gCj4gT24gMjAxOOW5tDA45pyIMDnml6UgMTc6MjMsIFBhbmthaiBHdXB0YSB3cm90ZToK
PiA+PiBEQVggZHJpdmVyIGhvdHBsdWcgdGhlIGRldmljZSBtZW1vcnkgYW5kIG1vdmUgaXQgdG8g
bWVtb3J5IHpvbmUsIHRoZXNlCj4gPj4gcGFnZXMgd2lsbCBiZSBtYXJrZWQgcmVzZXJ2ZWQgZmxh
ZywgaG93ZXZlciwgc29tZSBvdGhlciBrZXJuZWwgY29tcG9uZXQKPiA+PiB3aWxsIG1pc2NvbmNl
aXZlIHRoZXNlIHBhZ2VzIGFyZSByZXNlcnZlZCBtbWlvIChleDogd2UgbWFwIHRoZXNlIGRldl9k
YXgKPiA+PiBvciBmc19kYXggcGFnZXMgdG8ga3ZtIGZvciBESU1NL05WRElNTSBiYWNrZW5kKS4g
VG9nZXRoZXIgd2l0aCB0aGUgdHlwZQo+ID4+IE1FTU9SWV9ERVZJQ0VfRlNfREFYLCB3ZSBjYW4g
dXNlIGlzX2RheF9wYWdlKCkgdG8gZGlmZmVyZW50aWF0ZSB0aGUgcGFnZXMKPiA+PiBpcyBEQVgg
ZGV2aWNlIG1lbW9yeSBvciBub3QuCj4gPj4KPiA+PiBTaWduZWQtb2ZmLWJ5OiBaaGFuZyBZaSA8
eWkuei56aGFuZ0BsaW51eC5pbnRlbC5jb20+Cj4gPj4gU2lnbmVkLW9mZi1ieTogWmhhbmcgWXUg
PHl1LmMuemhhbmdAbGludXguaW50ZWwuY29tPgo+ID4+IC0tLQo+ID4+ICBpbmNsdWRlL2xpbnV4
L21tLmggfCAxMiArKysrKysrKysrKysKPiA+PiAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlv
bnMoKykKPiA+Pgo+ID4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21tLmggYi9pbmNsdWRl
L2xpbnV4L21tLmgKPiA+PiBpbmRleCA2OGE1MTIxLi5kZTVjYmMzIDEwMDY0NAo+ID4+IC0tLSBh
L2luY2x1ZGUvbGludXgvbW0uaAo+ID4+ICsrKyBiL2luY2x1ZGUvbGludXgvbW0uaAo+ID4+IEBA
IC04ODksNiArODg5LDEzIEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBpc19kZXZpY2VfcHVibGljX3Bh
Z2UoY29uc3Qgc3RydWN0Cj4gPj4gcGFnZSAqcGFnZSkKPiA+PiAgCQlwYWdlLT5wZ21hcC0+dHlw
ZSA9PSBNRU1PUllfREVWSUNFX1BVQkxJQzsKPiA+PiAgfQo+ID4+ICAKPiA+PiArc3RhdGljIGlu
bGluZSBib29sIGlzX2RheF9wYWdlKGNvbnN0IHN0cnVjdCBwYWdlICpwYWdlKQo+ID4+ICt7Cj4g
Pj4gKwlyZXR1cm4gaXNfem9uZV9kZXZpY2VfcGFnZShwYWdlKSAmJgo+ID4+ICsJCShwYWdlLT5w
Z21hcC0+dHlwZSA9PSBNRU1PUllfREVWSUNFX0ZTX0RBWCB8fAo+ID4+ICsJCXBhZ2UtPnBnbWFw
LT50eXBlID09IE1FTU9SWV9ERVZJQ0VfREVWX0RBWCk7Cj4gPj4gK30KPiA+IEkgdGhpbmsgcXVl
c3Rpb24gZnJvbSBEYW4gZm9yIEtWTSBWTSB3aXRoICdNRU1PUllfREVWSUNFX1BVQkxJQycgc3Rp
bGwgaG9sZHM/Cj4gPiBJIGFtIGFsc28gaW50ZXJlc3RlZCB0byBrbm93IGlmIHRoZXJlIGlzIGFu
eSB1c2UtY2FzZS4KPiA+Cj4gPiBUaGFua3MsCj4gPiBQYW5rYWoKPiBZZXMsIGl0IGlzLCB0aGFu
a3MgZm9yIHlvdXIgcmVtaW5kLCBQYW5rYWouCj4gQWRkaW5nIEplcm9tZSBmb3IgRGFuJ3MgcXVl
c3Rpb25zIG9uIFYxOgo+IFtEYW5dOgo+IAo+IEplcm9tZSwgbWlnaHQgdGhlcmUgYmUgYW55IHVz
ZSBjYXNlIHRvIHBhc3MgTUVNT1JZX0RFVklDRV9QVUJMSUMKPiBtZW1vcnkgdG8gYSBndWVzdCB2
bT8KClllcyBhbmQgbm8sIGkgYW0gbm90IHN1cmUgaG93IHdlIGFyZSBnb2luZyB0byBkbyBpdC4g
QnV0IGJlaW5nIGFibGUgdG8Kc2hhcmUgR1BVIGFtb25nIG11bHRpcGxlIFZNIGlzIG9uIFRPRE8g
bGlzdCBhbmQgdGhvc2UgR1BVIHdpbGwgaGF2ZQpNRU1PUllfREVWSUNFX1BVQkxJQ3xQUklWQVRF
IGRlcGVuZGluZyBvbiB0aGUgcGxhdGZvcm0uIFNvIGVpdGhlciB3ZQpwYXNzIGRvd24gdGhlIHJl
YWwgdW5kZXJseWluZyByZXNvdXJjZSB0byB0aGUgZ3Vlc3QsIG9yIHdlIHdpbGwgcGFzcwpkb3du
IGEgZmFrZSBvbmUgYW5kIGhhdmUgZ3Vlc3QgYW5kIGhvc3QgZHJpdmVyIHRhbGsgdG8gZWFjaCBv
dGhlciBzbwp0aGF0IHRoZSBob3N0IGRyaXZlciBjYW4gZG8gb3ZlcmFsbCByZXNvdXJjZSBtYW5h
Z2VtZW50IGFjY3Jvc3MgbXVsdGlwbGUKZ3Vlc3RzLgoKU28gaSB3b3VsZCBzYXkgdGhhdCBmb3Ig
bm93IHlvdSBjYW4gaWdub3JlIE1FTU9SWV9ERVZJQ0VfUFVCTElDIGFuZCB3aGVuCndlIGdldCB0
byB0aGUgS1ZNIGd1ZXN0IHNoYXJpbmcgb2YgdGhvc2UgYW5kIGRlY2lkZSBob3cgd2Ugd2FudCB0
byBkbwppdCB0aGVuIHdlIGNhbiB1cGRhdGUga3ZtIHRvIHByb3Blcmx5IGludGVycHJldCB0aG9z
ZS4KCkNoZWVycywKSsOpcsO0bWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMu
MDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1t
Cg==
