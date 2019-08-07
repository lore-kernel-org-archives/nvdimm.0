Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F36AC21BADAB6
 for <linux-nvdimm@lists.01.org>; Wed,  7 Aug 2019 14:47:59 -0700 (PDT)
Subject: [PATCH] tools/testing/nvdimm: Fix fallthrough warning
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 07 Aug 2019 14:31:11 -0700
Message-ID: <156521347159.1442374.1381360879102718899.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

VXNlIHRoZSBleHBlY3RlZCAnZmFsbCB0aHJvdWdoJyBkZXNpZ25hdGlvbiB0byBmaXg6CgogICAg
dG9vbHMvdGVzdGluZy9udmRpbW0vdGVzdC9uZml0LmM6IEluIGZ1bmN0aW9uIOKAmG5kX2ludGVs
X3Rlc3RfZmluaXNoX3F1ZXJ54oCZOgogICAgdG9vbHMvdGVzdGluZy9udmRpbW0vdGVzdC9uZml0
LmM6NDMzOjEzOiB3YXJuaW5nOiB0aGlzIHN0YXRlbWVudCBtYXkgZmFsbCB0aHJvdWdoIFstV2lt
cGxpY2l0LWZhbGx0aHJvdWdoPV0KICAgICAgIGZ3LT5zdGF0ZSA9IEZXX1NUQVRFX1VQREFURUQ7
CiAgICAgICB+fn5+fn5+fn5+Xn5+fn5+fn5+fn5+fn5+fn5+CiAgICB0b29scy90ZXN0aW5nL252
ZGltbS90ZXN0L25maXQuYzo0MzU6Mjogbm90ZTogaGVyZQogICAgICBjYXNlIEZXX1NUQVRFX1VQ
REFURUQ6CiAgICAgIF5+fn4KClNpZ25lZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2ls
bGlhbXNAaW50ZWwuY29tPgotLS0KIHRvb2xzL3Rlc3RpbmcvbnZkaW1tL3Rlc3QvbmZpdC5jIHwg
ICAgMyArLS0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMiBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL252ZGltbS90ZXN0L25maXQuYyBiL3Rvb2xzL3Rl
c3RpbmcvbnZkaW1tL3Rlc3QvbmZpdC5jCmluZGV4IDUwN2U2ZjRjYmI1My4uYmY2NDIyYTZhZjdm
IDEwMDY0NAotLS0gYS90b29scy90ZXN0aW5nL252ZGltbS90ZXN0L25maXQuYworKysgYi90b29s
cy90ZXN0aW5nL252ZGltbS90ZXN0L25maXQuYwpAQCAtNDI4LDEwICs0MjgsOSBAQCBzdGF0aWMg
aW50IG5kX2ludGVsX3Rlc3RfZmluaXNoX3F1ZXJ5KHN0cnVjdCBuZml0X3Rlc3QgKnQsCiAJCQlk
ZXZfZGJnKGRldiwgIiVzOiBzdGlsbCB2ZXJpZnlpbmdcbiIsIF9fZnVuY19fKTsKIAkJCWJyZWFr
OwogCQl9Ci0KIAkJZGV2X2RiZyhkZXYsICIlczogdHJhbnNpdGlvbiBvdXQgdmVyaWZ5XG4iLCBf
X2Z1bmNfXyk7CiAJCWZ3LT5zdGF0ZSA9IEZXX1NUQVRFX1VQREFURUQ7Ci0JCS8qIHdlIGFyZSBn
b2luZyB0byBmYWxsIHRocm91Z2ggaWYgaXQncyAiZG9uZSIgKi8KKwkJLyogZmFsbCB0aHJvdWdo
ICovCiAJY2FzZSBGV19TVEFURV9VUERBVEVEOgogCQluZF9jbWQtPnN0YXR1cyA9IDA7CiAJCS8q
IGJvZ3VzIHRlc3QgdmVyc2lvbiAqLwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
