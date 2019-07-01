Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27E71212AB4DD
 for <linux-nvdimm@lists.01.org>; Sun, 30 Jun 2019 23:21:01 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/22] mm/hmm: Poison hmm_range during unregister
Date: Mon,  1 Jul 2019 08:20:13 +0200
Message-Id: <20190701062020.19239-16-hch@lst.de>
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
Cc: Philip Yang <Philip.Yang@amd.com>, Ralph Campbell <rcampbell@nvidia.com>, John Hubbard <jhubbard@nvidia.com>, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Souptick Joarder <jrdr.linux@gmail.com>, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

RnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgoKVHJ5aW5nIHRvIG1pc3Vz
ZSBhIHJhbmdlIG91dHNpZGUgaXRzIGxpZmV0aW1lIGlzIGEga2VybmVsIGJ1Zy4gVXNlIHBvaXNv
bgpieXRlcyB0byBoZWxwIGRldGVjdCB0aGlzIGNvbmRpdGlvbi4gRG91YmxlIHVucmVnaXN0ZXIg
d2lsbCByZWxpYWJseSBjcmFzaC4KClNpZ25lZC1vZmYtYnk6IEphc29uIEd1bnRob3JwZSA8amdn
QG1lbGxhbm94LmNvbT4KUmV2aWV3ZWQtYnk6IErDqXLDtG1lIEdsaXNzZSA8amdsaXNzZUByZWRo
YXQuY29tPgpSZXZpZXdlZC1ieTogSm9obiBIdWJiYXJkIDxqaHViYmFyZEBudmlkaWEuY29tPgpB
Y2tlZC1ieTogU291cHRpY2sgSm9hcmRlciA8anJkci5saW51eEBnbWFpbC5jb20+ClJldmlld2Vk
LWJ5OiBSYWxwaCBDYW1wYmVsbCA8cmNhbXBiZWxsQG52aWRpYS5jb20+ClJldmlld2VkLWJ5OiBJ
cmEgV2VpbnkgPGlyYS53ZWlueUBpbnRlbC5jb20+ClRlc3RlZC1ieTogUGhpbGlwIFlhbmcgPFBo
aWxpcC5ZYW5nQGFtZC5jb20+Ci0tLQogbW0vaG1tLmMgfCAxNCArKysrKysrKy0tLS0tLQogMSBm
aWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9tbS9obW0uYyBiL21tL2htbS5jCmluZGV4IDJlZjE0YjJiNTUwNS4uYzMwYWE5NDAzZGJlIDEw
MDY0NAotLS0gYS9tbS9obW0uYworKysgYi9tbS9obW0uYwpAQCAtOTI1LDE5ICs5MjUsMjEgQEAg
dm9pZCBobW1fcmFuZ2VfdW5yZWdpc3RlcihzdHJ1Y3QgaG1tX3JhbmdlICpyYW5nZSkKIHsKIAlz
dHJ1Y3QgaG1tICpobW0gPSByYW5nZS0+aG1tOwogCi0JLyogU2FuaXR5IGNoZWNrIHRoaXMgcmVh
bGx5IHNob3VsZCBub3QgaGFwcGVuLiAqLwotCWlmIChobW0gPT0gTlVMTCB8fCByYW5nZS0+ZW5k
IDw9IHJhbmdlLT5zdGFydCkKLQkJcmV0dXJuOwotCiAJbXV0ZXhfbG9jaygmaG1tLT5sb2NrKTsK
IAlsaXN0X2RlbF9pbml0KCZyYW5nZS0+bGlzdCk7CiAJbXV0ZXhfdW5sb2NrKCZobW0tPmxvY2sp
OwogCiAJLyogRHJvcCByZWZlcmVuY2UgdGFrZW4gYnkgaG1tX3JhbmdlX3JlZ2lzdGVyKCkgKi8K
LQlyYW5nZS0+dmFsaWQgPSBmYWxzZTsKIAltbXB1dChobW0tPm1tKTsKIAlobW1fcHV0KGhtbSk7
Ci0JcmFuZ2UtPmhtbSA9IE5VTEw7CisKKwkvKgorCSAqIFRoZSByYW5nZSBpcyBub3cgaW52YWxp
ZCBhbmQgdGhlIHJlZiBvbiB0aGUgaG1tIGlzIGRyb3BwZWQsIHNvCisJICogcG9pc29uIHRoZSBw
b2ludGVyLiAgTGVhdmUgb3RoZXIgZmllbGRzIGluIHBsYWNlLCBmb3IgdGhlIGNhbGxlcidzCisJ
ICogdXNlLgorCSAqLworCXJhbmdlLT52YWxpZCA9IGZhbHNlOworCW1lbXNldCgmcmFuZ2UtPmht
bSwgUE9JU09OX0lOVVNFLCBzaXplb2YocmFuZ2UtPmhtbSkpOwogfQogRVhQT1JUX1NZTUJPTCho
bW1fcmFuZ2VfdW5yZWdpc3Rlcik7CiAKLS0gCjIuMjAuMQoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51
eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGlu
Zm8vbGludXgtbnZkaW1tCg==
