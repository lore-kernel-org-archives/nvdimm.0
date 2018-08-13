Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C81C210DC1A1
 for <linux-nvdimm@lists.01.org>; Mon, 13 Aug 2018 02:48:22 -0700 (PDT)
Subject: Re: [PATCH V3 4/4] kvm: add a check if pfn is from NVDIMM pmem.
References: <cover.1533811181.git.yi.z.zhang@linux.intel.com>
 <0cc6cba7020f80168695fba731b8fd72fd649dc8.1533811181.git.yi.z.zhang@linux.intel.com>
 <2130082365.883434.1533803526182.JavaMail.zimbra@redhat.com>
From: "Zhang,Yi" <yi.z.zhang@linux.intel.com>
Message-ID: <083b8170-a9ba-beee-7578-6d33e70a8b6e@linux.intel.com>
Date: Tue, 14 Aug 2018 01:32:05 +0800
MIME-Version: 1.0
In-Reply-To: <2130082365.883434.1533803526182.JavaMail.zimbra@redhat.com>
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
To: Pankaj Gupta <pagupta@redhat.com>
Cc: jack@suse.cz, yu c zhang <yu.c.zhang@intel.com>, kvm@vger.kernel.org, linux-nvdimm@lists.01.org, rkrcmar@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, hch@lst.de, yi z zhang <yi.z.zhang@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

CgpPbiAyMDE45bm0MDjmnIgwOeaXpSAxNjozMiwgUGFua2FqIEd1cHRhIHdyb3RlOgo+PiBGb3Ig
ZGV2aWNlIHNwZWNpZmljIG1lbW9yeSBzcGFjZSwgd2hlbiB3ZSBtb3ZlIHRoZXNlIGFyZWEgb2Yg
cGZuIHRvCj4+IG1lbW9yeSB6b25lLCB3ZSB3aWxsIHNldCB0aGUgcGFnZSByZXNlcnZlZCBmbGFn
IGF0IHRoYXQgdGltZSwgc29tZSBvZgo+PiB0aGVzZSByZXNlcnZlZCBmb3IgZGV2aWNlIG1taW8s
IGFuZCBzb21lIG9mIHRoZXNlIGFyZSBub3QsIHN1Y2ggYXMKPj4gTlZESU1NIHBtZW0uCj4+Cj4+
IE5vdywgd2UgbWFwIHRoZXNlIGRldl9kYXggb3IgZnNfZGF4IHBhZ2VzIHRvIGt2bSBmb3IgRElN
TS9OVkRJTU0KPj4gYmFja2VuZCwgc2luY2UgdGhlc2UgcGFnZXMgYXJlIHJlc2VydmVkLiB0aGUg
Y2hlY2sgb2YKPj4ga3ZtX2lzX3Jlc2VydmVkX3BmbigpIG1pc2NvbmNlaXZlcyB0aG9zZSBwYWdl
cyBhcyBNTUlPLiBUaGVyZWZvciwgd2UKPj4gaW50cm9kdWNlIDIgcGFnZSBtYXAgdHlwZXMsIE1F
TU9SWV9ERVZJQ0VfRlNfREFYL01FTU9SWV9ERVZJQ0VfREVWX0RBWCwKPj4gdG8gaW5kZW50aWZ5
IHRoZXNlIHBhZ2VzIGFyZSBmcm9tIE5WRElNTSBwbWVtLiBhbmQgbGV0IGt2bSB0cmVhdCB0aGVz
ZQo+IHMvaW5kZW50aWZ5L2lkZW50aWZ5ICYgcmVtb3ZlICcuJwpUaGFua3MgUGFua2FqLCA6LSkK
Pgo+PiBhcyBub3JtYWwgcGFnZXMuCj4+Cj4+IFdpdGhvdXQgdGhpcyBwYXRjaCwgTWFueSBvcGVy
YXRpb25zIHdpbGwgYmUgbWlzc2VkIGR1ZSB0byB0aGlzCj4+IG1pc3RyZWF0bWVudCB0byBwbWVt
IHBhZ2VzLiBGb3IgZXhhbXBsZSwgYSBwYWdlIG1heSBub3QgaGF2ZSBjaGFuY2UgdG8KPj4gYmUg
dW5waW5uZWQgZm9yIEtWTSBndWVzdChpbiBrdm1fcmVsZWFzZV9wZm5fY2xlYW4pOyBub3QgYWJs
ZSB0byBiZQo+PiBtYXJrZWQgYXMgZGlydHkvYWNjZXNzZWQoaW4ga3ZtX3NldF9wZm5fZGlydHkv
YWNjZXNzZWQpIGV0Ywo+Pgo+PiBTaWduZWQtb2ZmLWJ5OiBaaGFuZyBZaSA8eWkuei56aGFuZ0Bs
aW51eC5pbnRlbC5jb20+Cj4+IC0tLQo+PiAgdmlydC9rdm0va3ZtX21haW4uYyB8IDggKysrKysr
LS0KPj4gIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCj4+
Cj4+IGRpZmYgLS1naXQgYS92aXJ0L2t2bS9rdm1fbWFpbi5jIGIvdmlydC9rdm0va3ZtX21haW4u
Ywo+PiBpbmRleCBjNDRjNDA2Li45NjliNmNhIDEwMDY0NAo+PiAtLS0gYS92aXJ0L2t2bS9rdm1f
bWFpbi5jCj4+ICsrKyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMKPj4gQEAgLTE0Nyw4ICsxNDcsMTIg
QEAgX193ZWFrIHZvaWQKPj4ga3ZtX2FyY2hfbW11X25vdGlmaWVyX2ludmFsaWRhdGVfcmFuZ2Uo
c3RydWN0IGt2bSAqa3ZtLAo+PiAgCj4+ICBib29sIGt2bV9pc19yZXNlcnZlZF9wZm4oa3ZtX3Bm
bl90IHBmbikKPj4gIHsKPj4gLSAgICAgICAgaWYgKHBmbl92YWxpZChwZm4pKQo+PiAtICAgICAg
ICAgICAgICAgIHJldHVybiBQYWdlUmVzZXJ2ZWQocGZuX3RvX3BhZ2UocGZuKSk7Cj4+ICsgICAg
ICAgIHN0cnVjdCBwYWdlICpwYWdlOwo+PiArCj4+ICsgICAgICAgIGlmIChwZm5fdmFsaWQocGZu
KSkgewo+PiArICAgICAgICAgICAgICAgIHBhZ2UgPSBwZm5fdG9fcGFnZShwZm4pOwo+PiArICAg
ICAgICAgICAgICAgIHJldHVybiBQYWdlUmVzZXJ2ZWQocGFnZSkgJiYgIWlzX2RheF9wYWdlKHBh
Z2UpOwo+PiArICAgICAgICB9Cj4+ICAKPj4gICAgICAgICAgcmV0dXJuIHRydWU7Cj4+ICB9Cj4+
IC0tCj4+IDIuNy40Cj4+Cj4+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4w
MS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
