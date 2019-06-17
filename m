Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4EC4A2128A65C
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jun 2019 05:27:45 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: dev_pagemap related cleanups v2
Date: Mon, 17 Jun 2019 14:27:08 +0200
Message-Id: <20190617122733.22432-1-hch@lst.de>
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
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

SGkgRGFuLCBKw6lyw7RtZSBhbmQgSmFzb24sCgpiZWxvdyBpcyBhIHNlcmllcyB0aGF0IGNsZWFu
cyB1cCB0aGUgZGV2X3BhZ2VtYXAgaW50ZXJmYWNlIHNvIHRoYXQKaXQgaXMgbW9yZSBlYXNpbHkg
dXNhYmxlLCB3aGljaCByZW1vdmVzIHRoZSBuZWVkIHRvIHdyYXAgaXQgaW4gaG1tCmFuZCB0aHVz
IGFsbG93aW5nIHRvIGtpbGwgYSBsb3Qgb2YgY29kZQoKTm90ZTogdGhpcyBzZXJpZXMgaXMgb24g
dG9wIG9mIHRoZSByZG1hL2htbSBicmFuY2ggKyB0aGUgZGV2X3BhZ2VtYXAKcmVsZWFzIGZpeCBz
ZXJpZXMgZnJvbSBEYW4gdGhhdCB3ZW50IGludG8gNS4yLXJjNS4KCkdpdCB0cmVlOgoKICAgIGdp
dDovL2dpdC5pbmZyYWRlYWQub3JnL3VzZXJzL2hjaC9taXNjLmdpdCBobW0tZGV2bWVtLWNsZWFu
dXAuMgoKR2l0d2ViOgoKICAgIGh0dHA6Ly9naXQuaW5mcmFkZWFkLm9yZy91c2Vycy9oY2gvbWlz
Yy5naXQvc2hvcnRsb2cvcmVmcy9oZWFkcy9obW0tZGV2bWVtLWNsZWFudXAuMgoKQ2hhbmdlcyBz
aW5jZSB2MToKIC0gcmViYXNlCiAtIGFsc28gc3dpdGNoIHAycGRtYSB0byB0aGUgaW50ZXJuYWwg
cmVmY291bnQKIC0gYWRkIHR5cGUgY2hlY2tpbmcgZm9yIHBnbWFwLT50eXBlCiAtIHJlbmFtZSB0
aGUgbWlncmF0ZSBtZXRob2QgdG8gbWlncmF0ZV90b19yYW0KIC0gY2xlYW51cCB0aGUgYWx0bWFw
X3ZhbGlkIGZsYWcKIC0gdmFyaW91cyB0aWRiaXRzIGZyb20gdGhlIHJldmlld3MKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxp
bmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21h
aWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
