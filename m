Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 204E421959CB2
 for <linux-nvdimm@lists.01.org>; Sun, 30 Jun 2019 23:20:56 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/22] mm/hmm: Use lockdep instead of comments
Date: Mon,  1 Jul 2019 08:20:11 +0200
Message-Id: <20190701062020.19239-14-hch@lst.de>
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

RnJvbTogSmFzb24gR3VudGhvcnBlIDxqZ2dAbWVsbGFub3guY29tPgoKU28gd2UgY2FuIGNoZWNr
IGxvY2tpbmcgYXQgcnVudGltZS4KClNpZ25lZC1vZmYtYnk6IEphc29uIEd1bnRob3JwZSA8amdn
QG1lbGxhbm94LmNvbT4KUmV2aWV3ZWQtYnk6IErDqXLDtG1lIEdsaXNzZSA8amdsaXNzZUByZWRo
YXQuY29tPgpSZXZpZXdlZC1ieTogSm9obiBIdWJiYXJkIDxqaHViYmFyZEBudmlkaWEuY29tPgpS
ZXZpZXdlZC1ieTogUmFscGggQ2FtcGJlbGwgPHJjYW1wYmVsbEBudmlkaWEuY29tPgpBY2tlZC1i
eTogU291cHRpY2sgSm9hcmRlciA8anJkci5saW51eEBnbWFpbC5jb20+ClJldmlld2VkLWJ5OiBD
aHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KVGVzdGVkLWJ5OiBQaGlsaXAgWWFuZyA8UGhp
bGlwLllhbmdAYW1kLmNvbT4KLS0tCiBtbS9obW0uYyB8IDQgKystLQogMSBmaWxlIGNoYW5nZWQs
IDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9tbS9obW0uYyBi
L21tL2htbS5jCmluZGV4IDFlZGRkYTQ1Y2VmYS4uNmY1ZGM2ZDU2OGZlIDEwMDY0NAotLS0gYS9t
bS9obW0uYworKysgYi9tbS9obW0uYwpAQCAtMjQ2LDExICsyNDYsMTEgQEAgc3RhdGljIGNvbnN0
IHN0cnVjdCBtbXVfbm90aWZpZXJfb3BzIGhtbV9tbXVfbm90aWZpZXJfb3BzID0gewogICoKICAq
IFRvIHN0YXJ0IG1pcnJvcmluZyBhIHByb2Nlc3MgYWRkcmVzcyBzcGFjZSwgdGhlIGRldmljZSBk
cml2ZXIgbXVzdCByZWdpc3RlcgogICogYW4gSE1NIG1pcnJvciBzdHJ1Y3QuCi0gKgotICogVEhF
IG1tLT5tbWFwX3NlbSBNVVNUIEJFIEhFTEQgSU4gV1JJVEUgTU9ERSAhCiAgKi8KIGludCBobW1f
bWlycm9yX3JlZ2lzdGVyKHN0cnVjdCBobW1fbWlycm9yICptaXJyb3IsIHN0cnVjdCBtbV9zdHJ1
Y3QgKm1tKQogeworCWxvY2tkZXBfYXNzZXJ0X2hlbGRfZXhjbHVzaXZlKCZtbS0+bW1hcF9zZW0p
OworCiAJLyogU2FuaXR5IGNoZWNrICovCiAJaWYgKCFtbSB8fCAhbWlycm9yIHx8ICFtaXJyb3It
Pm9wcykKIAkJcmV0dXJuIC1FSU5WQUw7Ci0tIAoyLjIwLjEKCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGlu
dXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3Rp
bmZvL2xpbnV4LW52ZGltbQo=
