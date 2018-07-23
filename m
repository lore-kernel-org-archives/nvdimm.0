Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 21FE3210C0F5A
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jul 2018 09:12:07 -0700 (PDT)
Subject: Re: [PATCH v6 06/13] mm, dev_pagemap: Do not clear ->mapping on final
 put
References: <153154376846.34503.15480221419473501643.stgit@dwillia2-desk3.amr.corp.intel.com>
 <153154380137.34503.3754023882460956800.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <3fcb3c8a-2a41-7c78-edde-066c10110d34@intel.com>
Date: Mon, 23 Jul 2018 09:12:06 -0700
MIME-Version: 1.0
In-Reply-To: <153154380137.34503.3754023882460956800.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

SmVyb21lLApJcyBpdCBwb3NzaWJsZSB0byBnZXQgYW4gYWNrIGZvciB0aGlzPyBUaGFua3MhCgpP
biAwNy8xMy8yMDE4IDA5OjUwIFBNLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4gTUVNT1JZX0RFVklD
RV9GU19EQVggcmVsaWVzIG9uIHR5cGljYWwgcGFnZSBzZW1hbnRpY3Mgd2hlcmVieSAtPm1hcHBp
bmcKPiBpcyBvbmx5IGV2ZXIgY2xlYXJlZCBieSB0cnVuY2F0aW9uLCBub3QgZmluYWwgcHV0Lgo+
IAo+IFdpdGhvdXQgdGhpcyBmaXggZGF4IHBhZ2VzIG1heSBmb3JnZXQgdGhlaXIgbWFwcGluZyBh
c3NvY2lhdGlvbiBhdCB0aGUKPiBlbmQgb2YgZXZlcnkgcGFnZSBwaW4gZXZlbnQuCj4gCj4gTW92
ZSB0aGlzIGF0eXBpY2FsIGJlaGF2aW9yIHRoYXQgSE1NIHdhbnRzIGludG8gdGhlIEhNTSAtPnBh
Z2VfZnJlZSgpCj4gY2FsbGJhY2suCj4gCj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgo+
IENjOiBKYW4gS2FyYSA8amFja0BzdXNlLmN6Pgo+IENjOiBKw6lyw7RtZSBHbGlzc2UgPGpnbGlz
c2VAcmVkaGF0LmNvbT4KPiBDYzogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9u
Lm9yZz4KPiBDYzogUm9zcyBad2lzbGVyIDxyb3NzLnp3aXNsZXJAbGludXguaW50ZWwuY29tPgo+
IEZpeGVzOiBkMmM5OTdjMGYxNDUgKCJmcywgZGF4OiB1c2UgcGFnZS0+bWFwcGluZy4uLiIpCj4g
U2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+Cj4g
LS0tCj4gIGtlcm5lbC9tZW1yZW1hcC5jIHwgICAgMSAtCj4gIG1tL2htbS5jICAgICAgICAgIHwg
ICAgMiArKwo+ICAyIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigt
KQo+IAo+IGRpZmYgLS1naXQgYS9rZXJuZWwvbWVtcmVtYXAuYyBiL2tlcm5lbC9tZW1yZW1hcC5j
Cj4gaW5kZXggNTg1NzI2N2E0YWY1Li42MjYwMzYzNGExZDIgMTAwNjQ0Cj4gLS0tIGEva2VybmVs
L21lbXJlbWFwLmMKPiArKysgYi9rZXJuZWwvbWVtcmVtYXAuYwo+IEBAIC0zMzksNyArMzM5LDYg
QEAgdm9pZCBfX3B1dF9kZXZtYXBfbWFuYWdlZF9wYWdlKHN0cnVjdCBwYWdlICpwYWdlKQo+ICAJ
CV9fQ2xlYXJQYWdlQWN0aXZlKHBhZ2UpOwo+ICAJCV9fQ2xlYXJQYWdlV2FpdGVycyhwYWdlKTsK
PiAgCj4gLQkJcGFnZS0+bWFwcGluZyA9IE5VTEw7Cj4gIAkJbWVtX2Nncm91cF91bmNoYXJnZShw
YWdlKTsKPiAgCj4gIAkJcGFnZS0+cGdtYXAtPnBhZ2VfZnJlZShwYWdlLCBwYWdlLT5wZ21hcC0+
ZGF0YSk7Cj4gZGlmZiAtLWdpdCBhL21tL2htbS5jIGIvbW0vaG1tLmMKPiBpbmRleCBkZTdiNmJm
NzcyMDEuLmY5ZDFkODlkZWM0ZCAxMDA2NDQKPiAtLS0gYS9tbS9obW0uYwo+ICsrKyBiL21tL2ht
bS5jCj4gQEAgLTk2Myw2ICs5NjMsOCBAQCBzdGF0aWMgdm9pZCBobW1fZGV2bWVtX2ZyZWUoc3Ry
dWN0IHBhZ2UgKnBhZ2UsIHZvaWQgKmRhdGEpCj4gIHsKPiAgCXN0cnVjdCBobW1fZGV2bWVtICpk
ZXZtZW0gPSBkYXRhOwo+ICAKPiArCXBhZ2UtPm1hcHBpbmcgPSBOVUxMOwo+ICsKPiAgCWRldm1l
bS0+b3BzLT5mcmVlKGRldm1lbSwgcGFnZSk7Cj4gIH0KPiAgCj4gCj4gX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiBMaW51eC1udmRpbW0gbWFpbGluZyBs
aXN0Cj4gTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwo+IGh0dHBzOi8vbGlzdHMuMDEub3JnL21h
aWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCj4gCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZk
aW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xp
bnV4LW52ZGltbQo=
