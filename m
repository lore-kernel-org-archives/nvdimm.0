Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 285B22097F54C
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jul 2018 23:43:16 -0700 (PDT)
Subject: Re: [PATCH V2 0/4] Fix kvm misconceives NVDIMM pages as reserved mmio
References: <cover.1531241281.git.yi.z.zhang@linux.intel.com>
From: "Zhang,Yi" <yi.z.zhang@linux.intel.com>
Message-ID: <6c0fea06-d52e-9bc4-c690-581b1d6f3cd3@linux.intel.com>
Date: Fri, 13 Jul 2018 22:29:09 +0800
MIME-Version: 1.0
In-Reply-To: <cover.1531241281.git.yi.z.zhang@linux.intel.com>
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
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, pbonzini@redhat.com, dan.j.williams@intel.com, jack@suse.cz, hch@lst.de, yu.c.zhang@intel.com
Cc: linux-mm@kvack.org, yi.z.zhang@intel.com, rkrcmar@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

UGluZyBmb3IgZnVydGhlciByZXZpZXcsIGNvbW1lbnRzLgoKVGhhbmtzIEFsbAoKUmVnYXJkcwpZ
aS4KCk9uIDIwMTjlubQwN+aciDEx5pelIDAxOjAxLCBaaGFuZyBZaSB3cm90ZToKPiBGb3IgZGV2
aWNlIHNwZWNpZmljIG1lbW9yeSBzcGFjZSwgd2hlbiB3ZSBtb3ZlIHRoZXNlIGFyZWEgb2YgcGZu
IHRvCj4gbWVtb3J5IHpvbmUsIHdlIHdpbGwgc2V0IHRoZSBwYWdlIHJlc2VydmVkIGZsYWcgYXQg
dGhhdCB0aW1lLCBzb21lIG9mCj4gdGhlc2UgcmVzZXJ2ZWQgZm9yIGRldmljZSBtbWlvLCBhbmQg
c29tZSBvZiB0aGVzZSBhcmUgbm90LCBzdWNoIGFzCj4gTlZESU1NIHBtZW0uCj4KPiBOb3csIHdl
IG1hcCB0aGVzZSBkZXZfZGF4IG9yIGZzX2RheCBwYWdlcyB0byBrdm0gZm9yIERJTU0vTlZESU1N
Cj4gYmFja2VuZCwgc2luY2UgdGhlc2UgcGFnZXMgYXJlIHJlc2VydmVkLiB0aGUgY2hlY2sgb2YK
PiBrdm1faXNfcmVzZXJ2ZWRfcGZuKCkgbWlzY29uY2VpdmVzIHRob3NlIHBhZ2VzIGFzIE1NSU8u
IFRoZXJlZm9yLCB3ZQo+IGludHJvZHVjZSAyIHBhZ2UgbWFwIHR5cGVzLCBNRU1PUllfREVWSUNF
X0ZTX0RBWC9NRU1PUllfREVWSUNFX0RFVl9EQVgsCj4gdG8gaW5kZW50aWZ5IHRoZXNlIHBhZ2Vz
IGFyZSBmcm9tIE5WRElNTSBwbWVtLiBhbmQgbGV0IGt2bSB0cmVhdCB0aGVzZQo+IGFzIG5vcm1h
bCBwYWdlcy4KPgo+IFdpdGhvdXQgdGhpcyBwYXRjaCwgTWFueSBvcGVyYXRpb25zIHdpbGwgYmUg
bWlzc2VkIGR1ZSB0byB0aGlzCj4gbWlzdHJlYXRtZW50IHRvIHBtZW0gcGFnZXMuIEZvciBleGFt
cGxlLCBhIHBhZ2UgbWF5IG5vdCBoYXZlIGNoYW5jZSB0bwo+IGJlIHVucGlubmVkIGZvciBLVk0g
Z3Vlc3QoaW4ga3ZtX3JlbGVhc2VfcGZuX2NsZWFuKTsgbm90IGFibGUgdG8gYmUKPiBtYXJrZWQg
YXMgZGlydHkvYWNjZXNzZWQoaW4ga3ZtX3NldF9wZm5fZGlydHkvYWNjZXNzZWQpIGV0Yy4KPgo+
IFYxOgo+IGh0dHBzOi8vbGttbC5vcmcvbGttbC8yMDE4LzcvNC85MQo+Cj4gVjI6Cj4gKkFkZCBk
b2N1bWVudGF0aW9uIGZvciBNRU1PUllfREVWSUNFX0RFVl9EQVggbWVtb3J5IHR5cGUgaW4gY29t
bWVudCBibG9jawo+ICpBZGQgaXNfZGF4X3BhZ2UoKSBpbiBtbS5oIHRvIGRpZmZlcmVudGlhdGUg
dGhlIHBhZ2VzIGlzIGZyb20gREFYIGRldmljZS4KPiAqUmVtb3ZlIHRoZSBmdW5jdGlvbiBrdm1f
aXNfbmRfcGZuKCkuCj4KPiBaaGFuZyBZaSAoNCk6Cj4gICBrdm06IHJlbW92ZSByZWR1bmRhbnQg
cmVzZXJ2ZWQgcGFnZSBjaGVjawo+ICAgbW06IGludHJvZHVjZSBtZW1vcnkgdHlwZSBNRU1PUllf
REVWSUNFX0RFVl9EQVgKPiAgIG1tOiBhZGQgYSBmdW5jdGlvbiB0byBkaWZmZXJlbnRpYXRlIHRo
ZSBwYWdlcyBpcyBmcm9tIERBWCBkZXZpY2UKPiAgICAgbWVtb3J5Cj4gICBrdm06IGFkZCBhIGNo
ZWNrIGlmIHBmbiBpcyBmcm9tIE5WRElNTSBwbWVtLgo+Cj4gIGRyaXZlcnMvZGF4L3BtZW0uYyAg
ICAgICB8ICAxICsKPiAgaW5jbHVkZS9saW51eC9tZW1yZW1hcC5oIHwgIDkgKysrKysrKysrCj4g
IGluY2x1ZGUvbGludXgvbW0uaCAgICAgICB8IDEyICsrKysrKysrKysrKwo+ICB2aXJ0L2t2bS9r
dm1fbWFpbi5jICAgICAgfCAxNiArKysrKysrKy0tLS0tLS0tCj4gIDQgZmlsZXMgY2hhbmdlZCwg
MzAgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKPgoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51
eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGlu
Zm8vbGludXgtbnZkaW1tCg==
