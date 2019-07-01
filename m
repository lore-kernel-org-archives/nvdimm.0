Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 519662194EB70
 for <linux-nvdimm@lists.01.org>; Sun, 30 Jun 2019 23:20:37 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/22] mm/hmm: Only set FAULT_FLAG_ALLOW_RETRY for non-blocking
Date: Mon,  1 Jul 2019 08:20:03 +0200
Message-Id: <20190701062020.19239-6-hch@lst.de>
In-Reply-To: <20190701062020.19239-1-hch@lst.de>
References: <20190701062020.19239-1-hch@lst.de>
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
To: Dan Williams <dan.j.williams@intel.com>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, "Kuehling," Felix" <Felix.Kuehling@amd.com>, linux-kernel@vger.kernel.org," dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

RnJvbTogIkt1ZWhsaW5nLCBGZWxpeCIgPEZlbGl4Lkt1ZWhsaW5nQGFtZC5jb20+CgpEb24ndCBz
ZXQgdGhpcyBmbGFnIGJ5IGRlZmF1bHQgaW4gaG1tX3ZtYV9kb19mYXVsdC4gSXQgaXMgc2V0CmNv
bmRpdGlvbmFsbHkganVzdCBhIGZldyBsaW5lcyBiZWxvdy4gU2V0dGluZyBpdCB1bmNvbmRpdGlv
bmFsbHkgY2FuIGxlYWQKdG8gaGFuZGxlX21tX2ZhdWx0IGRvaW5nIGEgbm9uLWJsb2NraW5nIGZh
dWx0LCByZXR1cm5pbmcgLUVCVVNZIGFuZAp1bmxvY2tpbmcgbW1hcF9zZW0gdW5leHBlY3RlZGx5
LgoKU2lnbmVkLW9mZi1ieTogRmVsaXggS3VlaGxpbmcgPEZlbGl4Lkt1ZWhsaW5nQGFtZC5jb20+
ClJldmlld2VkLWJ5OiBKw6lyw7RtZSBHbGlzc2UgPGpnbGlzc2VAcmVkaGF0LmNvbT4KU2lnbmVk
LW9mZi1ieTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgotLS0KIG1tL2htbS5j
IHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpk
aWZmIC0tZ2l0IGEvbW0vaG1tLmMgYi9tbS9obW0uYwppbmRleCBkY2U0ZTcwZTY0OGEuLjgyNjgx
NmFiMjM3NyAxMDA2NDQKLS0tIGEvbW0vaG1tLmMKKysrIGIvbW0vaG1tLmMKQEAgLTMyOCw3ICsz
MjgsNyBAQCBzdHJ1Y3QgaG1tX3ZtYV93YWxrIHsKIHN0YXRpYyBpbnQgaG1tX3ZtYV9kb19mYXVs
dChzdHJ1Y3QgbW1fd2FsayAqd2FsaywgdW5zaWduZWQgbG9uZyBhZGRyLAogCQkJICAgIGJvb2wg
d3JpdGVfZmF1bHQsIHVpbnQ2NF90ICpwZm4pCiB7Ci0JdW5zaWduZWQgaW50IGZsYWdzID0gRkFV
TFRfRkxBR19BTExPV19SRVRSWSB8IEZBVUxUX0ZMQUdfUkVNT1RFOworCXVuc2lnbmVkIGludCBm
bGFncyA9IEZBVUxUX0ZMQUdfUkVNT1RFOwogCXN0cnVjdCBobW1fdm1hX3dhbGsgKmhtbV92bWFf
d2FsayA9IHdhbGstPnByaXZhdGU7CiAJc3RydWN0IGhtbV9yYW5nZSAqcmFuZ2UgPSBobW1fdm1h
X3dhbGstPnJhbmdlOwogCXN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hID0gd2Fsay0+dm1hOwot
LSAKMi4yMC4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
XwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0
cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
