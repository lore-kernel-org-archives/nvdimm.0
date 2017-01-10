Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2001:1868:205::9])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D2893818E8
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jan 2017 07:48:14 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] ext4: fix DAX write locking
Date: Tue, 10 Jan 2017 16:48:07 +0100
Message-Id: <1484063288-18255-2-git-send-email-hch@lst.de>
In-Reply-To: <1484063288-18255-1-git-send-email-hch@lst.de>
References: <1484063288-18255-1-git-send-email-hch@lst.de>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

VW5saWtlIE9fRElSRUNUIERBWCBpcyBub3QgYW4gb3B0aW9uYWwgb3B0LWluIGZlYXR1cmUgc2Vs
ZWN0ZWQgYnkgdGhlCmFwcGxpY2F0aW9uLCBzbyB3ZSdsbCBoYXZlIHRvIHByb3ZpZGUgdGhlIHRy
YWRpdGlvbmFsIHN5bmNocm9u0ZZ6YXRpb24Kb2Ygb3ZlcmxhcHBpbmcgd3JpdGVzIGFzIHdlIGRv
IGZvciBidWZmZXJlZCB3cml0ZXMuCgpUaGlzIHdhcyBicm9rZW4gaGlzdG9yaWNhbGx5IGZvciBE
QVgsIGJ1dCBnb3QgZml4ZWQgZm9yIGV4dDIgYW5kIFhGUwphcyBwYXJ0IG9mIHRoZSBpb21hcCBj
b252ZXJzaW9uLiAgRml4IHVwIGV4dDQgYXMgd2VsbC4KClNpZ25lZC1vZmYtYnk6IENocmlzdG9w
aCBIZWxsd2lnIDxoY2hAbHN0LmRlPgotLS0KIGZzL2V4dDQvZmlsZS5jIHwgMTAgKy0tLS0tLS0t
LQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAt
LWdpdCBhL2ZzL2V4dDQvZmlsZS5jIGIvZnMvZXh0NC9maWxlLmMKaW5kZXggZDY2M2QzZC4uYTFl
ODhhYSAxMDA2NDQKLS0tIGEvZnMvZXh0NC9maWxlLmMKKysrIGIvZnMvZXh0NC9maWxlLmMKQEAg
LTE3NSw3ICsxNzUsNiBAQCBleHQ0X2RheF93cml0ZV9pdGVyKHN0cnVjdCBraW9jYiAqaW9jYiwg
c3RydWN0IGlvdl9pdGVyICpmcm9tKQogewogCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBmaWxlX2lu
b2RlKGlvY2ItPmtpX2ZpbHApOwogCXNzaXplX3QgcmV0OwotCWJvb2wgb3ZlcndyaXRlID0gZmFs
c2U7CiAKIAlpbm9kZV9sb2NrKGlub2RlKTsKIAlyZXQgPSBleHQ0X3dyaXRlX2NoZWNrcyhpb2Ni
LCBmcm9tKTsKQEAgLTE4OCwxNiArMTg3LDkgQEAgZXh0NF9kYXhfd3JpdGVfaXRlcihzdHJ1Y3Qg
a2lvY2IgKmlvY2IsIHN0cnVjdCBpb3ZfaXRlciAqZnJvbSkKIAlpZiAocmV0KQogCQlnb3RvIG91
dDsKIAotCWlmIChleHQ0X292ZXJ3cml0ZV9pbyhpbm9kZSwgaW9jYi0+a2lfcG9zLCBpb3ZfaXRl
cl9jb3VudChmcm9tKSkpIHsKLQkJb3ZlcndyaXRlID0gdHJ1ZTsKLQkJZG93bmdyYWRlX3dyaXRl
KCZpbm9kZS0+aV9yd3NlbSk7Ci0JfQogCXJldCA9IGRheF9pb21hcF9ydyhpb2NiLCBmcm9tLCAm
ZXh0NF9pb21hcF9vcHMpOwogb3V0OgotCWlmICghb3ZlcndyaXRlKQotCQlpbm9kZV91bmxvY2so
aW5vZGUpOwotCWVsc2UKLQkJaW5vZGVfdW5sb2NrX3NoYXJlZChpbm9kZSk7CisJaW5vZGVfdW5s
b2NrKGlub2RlKTsKIAlpZiAocmV0ID4gMCkKIAkJcmV0ID0gZ2VuZXJpY193cml0ZV9zeW5jKGlv
Y2IsIHJldCk7CiAJcmV0dXJuIHJldDsKLS0gCjIuMS40CgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4
LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5m
by9saW51eC1udmRpbW0K
