Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 321A5209831CF
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 22:00:10 -0700 (PDT)
Subject: [PATCH v6 06/13] mm, dev_pagemap: Do not clear ->mapping on final put
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 13 Jul 2018 21:50:01 -0700
Message-ID: <153154380137.34503.3754023882460956800.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153154376846.34503.15480221419473501643.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <153154376846.34503.15480221419473501643.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
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
To: linux-nvdimm@lists.01.org
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

TUVNT1JZX0RFVklDRV9GU19EQVggcmVsaWVzIG9uIHR5cGljYWwgcGFnZSBzZW1hbnRpY3Mgd2hl
cmVieSAtPm1hcHBpbmcKaXMgb25seSBldmVyIGNsZWFyZWQgYnkgdHJ1bmNhdGlvbiwgbm90IGZp
bmFsIHB1dC4KCldpdGhvdXQgdGhpcyBmaXggZGF4IHBhZ2VzIG1heSBmb3JnZXQgdGhlaXIgbWFw
cGluZyBhc3NvY2lhdGlvbiBhdCB0aGUKZW5kIG9mIGV2ZXJ5IHBhZ2UgcGluIGV2ZW50LgoKTW92
ZSB0aGlzIGF0eXBpY2FsIGJlaGF2aW9yIHRoYXQgSE1NIHdhbnRzIGludG8gdGhlIEhNTSAtPnBh
Z2VfZnJlZSgpCmNhbGxiYWNrLgoKQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpDYzogSmFu
IEthcmEgPGphY2tAc3VzZS5jej4KQ2M6IErDqXLDtG1lIEdsaXNzZSA8amdsaXNzZUByZWRoYXQu
Y29tPgpDYzogQW5kcmV3IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4KQ2M6IFJv
c3MgWndpc2xlciA8cm9zcy56d2lzbGVyQGxpbnV4LmludGVsLmNvbT4KRml4ZXM6IGQyYzk5N2Mw
ZjE0NSAoImZzLCBkYXg6IHVzZSBwYWdlLT5tYXBwaW5nLi4uIikKU2lnbmVkLW9mZi1ieTogRGFu
IFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+Ci0tLQoga2VybmVsL21lbXJlbWFw
LmMgfCAgICAxIC0KIG1tL2htbS5jICAgICAgICAgIHwgICAgMiArKwogMiBmaWxlcyBjaGFuZ2Vk
LCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvbWVt
cmVtYXAuYyBiL2tlcm5lbC9tZW1yZW1hcC5jCmluZGV4IDU4NTcyNjdhNGFmNS4uNjI2MDM2MzRh
MWQyIDEwMDY0NAotLS0gYS9rZXJuZWwvbWVtcmVtYXAuYworKysgYi9rZXJuZWwvbWVtcmVtYXAu
YwpAQCAtMzM5LDcgKzMzOSw2IEBAIHZvaWQgX19wdXRfZGV2bWFwX21hbmFnZWRfcGFnZShzdHJ1
Y3QgcGFnZSAqcGFnZSkKIAkJX19DbGVhclBhZ2VBY3RpdmUocGFnZSk7CiAJCV9fQ2xlYXJQYWdl
V2FpdGVycyhwYWdlKTsKIAotCQlwYWdlLT5tYXBwaW5nID0gTlVMTDsKIAkJbWVtX2Nncm91cF91
bmNoYXJnZShwYWdlKTsKIAogCQlwYWdlLT5wZ21hcC0+cGFnZV9mcmVlKHBhZ2UsIHBhZ2UtPnBn
bWFwLT5kYXRhKTsKZGlmZiAtLWdpdCBhL21tL2htbS5jIGIvbW0vaG1tLmMKaW5kZXggZGU3YjZi
Zjc3MjAxLi5mOWQxZDg5ZGVjNGQgMTAwNjQ0Ci0tLSBhL21tL2htbS5jCisrKyBiL21tL2htbS5j
CkBAIC05NjMsNiArOTYzLDggQEAgc3RhdGljIHZvaWQgaG1tX2Rldm1lbV9mcmVlKHN0cnVjdCBw
YWdlICpwYWdlLCB2b2lkICpkYXRhKQogewogCXN0cnVjdCBobW1fZGV2bWVtICpkZXZtZW0gPSBk
YXRhOwogCisJcGFnZS0+bWFwcGluZyA9IE5VTEw7CisKIAlkZXZtZW0tPm9wcy0+ZnJlZShkZXZt
ZW0sIHBhZ2UpOwogfQogCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5v
cmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
