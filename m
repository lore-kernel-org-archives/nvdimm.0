Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 576F12095606D
 for <linux-nvdimm@lists.01.org>; Fri, 30 Mar 2018 21:13:21 -0700 (PDT)
Subject: [PATCH v8 14/18] memremap: mark devm_memremap_pages()
 EXPORT_SYMBOL_GPL
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Mar 2018 21:03:25 -0700
Message-ID: <152246900495.36038.12673192605922080966.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152246892890.36038.18436540150980653229.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, snitzer@redhat.com, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

VGhlIGRldm1fbWVtcmVtYXBfcGFnZXMoKSBmYWNpbGl0eSBpcyB0aWdodGx5IGludGVncmF0ZWQg
d2l0aCB0aGUKa2VybmVsJ3MgbWVtb3J5IGhvdHBsdWcgZnVuY3Rpb25hbGl0eS4gSXQgaW5qZWN0
cyBhbiBhbHRtYXAgYXJndW1lbnQKZGVlcCBpbnRvIHRoZSBhcmNoaXRlY3R1cmUgc3BlY2lmaWMg
dm1lbW1hcCBpbXBsZW1lbnRhdGlvbiB0byBhbGxvdwphbGxvY2F0aW5nIGZyb20gc3BlY2lmaWMg
cmVzZXJ2ZWQgcGFnZXMsIGFuZCBpdCBoYXMgTGludXggc3BlY2lmaWMKYXNzdW1wdGlvbnMgYWJv
dXQgcGFnZSBzdHJ1Y3R1cmUgcmVmZXJlbmNlIGNvdW50aW5nIHJlbGF0aXZlIHRvCmdldF91c2Vy
X3BhZ2VzKCkgYW5kIGdldF91c2VyX3BhZ2VzX2Zhc3QoKS4gSXQgd2FzIGFuIG92ZXJzaWdodCB0
aGF0CnRoaXMgd2FzIG5vdCBtYXJrZWQgRVhQT1JUX1NZTUJPTF9HUEwgZnJvbSB0aGUgb3V0c2V0
LgoKQ2M6IE1pY2hhbCBIb2NrbyA8bWhvY2tvQHN1c2UuY29tPgpDYzogIkrDqXLDtG1lIEdsaXNz
ZSIgPGpnbGlzc2VAcmVkaGF0LmNvbT4KUmV2aWV3ZWQtYnk6IENocmlzdG9waCBIZWxsd2lnIDxo
Y2hAbHN0LmRlPgpTaWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGlu
dGVsLmNvbT4KLS0tCiBrZXJuZWwvbWVtcmVtYXAuYyB8ICAgIDIgKy0KIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9tZW1y
ZW1hcC5jIGIva2VybmVsL21lbXJlbWFwLmMKaW5kZXggMDdhNmE0MDVjZjNkLi40YjBlMTdkZjg5
ODEgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9tZW1yZW1hcC5jCisrKyBiL2tlcm5lbC9tZW1yZW1hcC5j
CkBAIC0yNTcsNyArMjU3LDcgQEAgdm9pZCAqZGV2bV9tZW1yZW1hcF9wYWdlcyhzdHJ1Y3QgZGV2
aWNlICpkZXYsIHN0cnVjdCBkZXZfcGFnZW1hcCAqcGdtYXApCiAJZGV2cmVzX2ZyZWUocGdtYXAp
OwogCXJldHVybiBFUlJfUFRSKGVycm9yKTsKIH0KLUVYUE9SVF9TWU1CT0woZGV2bV9tZW1yZW1h
cF9wYWdlcyk7CitFWFBPUlRfU1lNQk9MX0dQTChkZXZtX21lbXJlbWFwX3BhZ2VzKTsKIAogdW5z
aWduZWQgbG9uZyB2bWVtX2FsdG1hcF9vZmZzZXQoc3RydWN0IHZtZW1fYWx0bWFwICphbHRtYXAp
CiB7CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51
eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9s
aXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
