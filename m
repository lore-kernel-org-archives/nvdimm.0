Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A1235225E967D
 for <linux-nvdimm@lists.01.org>; Wed, 21 Mar 2018 16:00:38 -0700 (PDT)
Subject: [PATCH v7 10/14] memremap: mark devm_memremap_pages()
 EXPORT_SYMBOL_GPL
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Mar 2018 15:58:04 -0700
Message-ID: <152167308477.5268.13030863847054062531.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152167302988.5268.4370226749268662682.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, jack@suse.cz, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, =?utf-8?b?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

VGhlIGRldm1fbWVtcmVtYXBfcGFnZXMoKSBmYWNpbGl0eSBpcyB0aWdodGx5IGludGVncmF0ZWQg
d2l0aCB0aGUKa2VybmVsJ3MgbWVtb3J5IGhvdHBsdWcgZnVuY3Rpb25hbGl0eS4gSXQgaW5qZWN0
cyBhbiBhbHRtYXAgYXJndW1lbnQKZGVlcCBpbnRvIHRoZSBhcmNoaXRlY3R1cmUgc3BlY2lmaWMg
dm1lbW1hcCBpbXBsZW1lbnRhdGlvbiB0byBhbGxvdwphbGxvY2F0aW5nIGZyb20gc3BlY2lmaWMg
cmVzZXJ2ZWQgcGFnZXMsIGFuZCBpdCBoYXMgTGludXggc3BlY2lmaWMKYXNzdW1wdGlvbnMgYWJv
dXQgcGFnZSBzdHJ1Y3R1cmUgcmVmZXJlbmNlIGNvdW50aW5nIHJlbGF0aXZlIHRvCmdldF91c2Vy
X3BhZ2VzKCkgYW5kIGdldF91c2VyX3BhZ2VzX2Zhc3QoKS4gSXQgd2FzIGFuIG92ZXJzaWdodCB0
aGF0CnRoaXMgd2FzIG5vdCBtYXJrZWQgRVhQT1JUX1NZTUJPTF9HUEwgZnJvbSB0aGUgb3V0c2V0
LgoKQ2M6IE1pY2hhbCBIb2NrbyA8bWhvY2tvQHN1c2UuY29tPgpDYzogQ2hyaXN0b3BoIEhlbGx3
aWcgPGhjaEBsc3QuZGU+CkNjOiAiSsOpcsO0bWUgR2xpc3NlIiA8amdsaXNzZUByZWRoYXQuY29t
PgpTaWduZWQtb2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4K
LS0tCiBrZXJuZWwvbWVtcmVtYXAuYyB8ICAgIDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2Vy
dGlvbigrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9tZW1yZW1hcC5jIGIv
a2VybmVsL21lbXJlbWFwLmMKaW5kZXggNzJkMGJiNmZjNDdkLi43NjZjYjlhNDg3YWUgMTAwNjQ0
Ci0tLSBhL2tlcm5lbC9tZW1yZW1hcC5jCisrKyBiL2tlcm5lbC9tZW1yZW1hcC5jCkBAIC00MzAs
NyArNDMwLDcgQEAgdm9pZCAqZGV2bV9tZW1yZW1hcF9wYWdlcyhzdHJ1Y3QgZGV2aWNlICpkZXYs
IHN0cnVjdCBkZXZfcGFnZW1hcCAqcGdtYXApCiAJZGV2cmVzX2ZyZWUocGdtYXApOwogCXJldHVy
biBFUlJfUFRSKGVycm9yKTsKIH0KLUVYUE9SVF9TWU1CT0woZGV2bV9tZW1yZW1hcF9wYWdlcyk7
CitFWFBPUlRfU1lNQk9MX0dQTChkZXZtX21lbXJlbWFwX3BhZ2VzKTsKIAogdW5zaWduZWQgbG9u
ZyB2bWVtX2FsdG1hcF9vZmZzZXQoc3RydWN0IHZtZW1fYWx0bWFwICphbHRtYXApCiB7CgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0g
bWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5v
cmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
