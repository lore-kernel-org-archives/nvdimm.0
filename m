Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mailapp01.imgtec.com (mailapp01.imgtec.com [195.59.15.196])
 by ml01.01.org (Postfix) with ESMTP id 4B8D71A1E9F
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jul 2016 09:30:14 -0700 (PDT)
From: Eric Engestrom <eric.engestrom@imgtec.com>
Subject: [PATCH 1/2] libnvdimm: add missing macros
Date: Fri, 8 Jul 2016 17:29:10 +0100
Message-ID: <20160708162911.18756-1-eric.engestrom@imgtec.com>
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
To: linux-kernel@vger.kernel.org
Cc: Eric Engestrom <eric@engestrom.ch>, Eric Engestrom <eric.engestrom@imgtec.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

U2lnbmVkLW9mZi1ieTogRXJpYyBFbmdlc3Ryb20gPGVyaWMuZW5nZXN0cm9tQGltZ3RlYy5jb20+
Ci0tLQoKVGhpcyBjYW4ndCBjb21waWxlIHdpdGhvdXQgdGhlc2UgbWFjcm9z4oCmIElzIHRoaXMg
aGVhZGVyIHJlYWxseSB1c2VkIGJ5IGFueW9uZT8KU2hvdWxkIGl0IGJlIHJlbW92ZWQsIHRvIGF2
b2lkIGJpdC1yb3Q/CgotLS0KIGluY2x1ZGUvdWFwaS9saW51eC9uZGN0bC5oIHwgOCArKysrKysr
KwogMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUv
dWFwaS9saW51eC9uZGN0bC5oIGIvaW5jbHVkZS91YXBpL2xpbnV4L25kY3RsLmgKaW5kZXggMzA5
OTE1Zi4uNTBhZTVlNyAxMDA2NDQKLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L25kY3RsLmgKKysr
IGIvaW5jbHVkZS91YXBpL2xpbnV4L25kY3RsLmgKQEAgLTE1LDYgKzE1LDE0IEBACiAKICNpbmNs
dWRlIDxsaW51eC90eXBlcy5oPgogCisjaWZkZWYgX19HTlVDX18KKyNkZWZpbmUgX19wYWNrZWQg
X19hdHRyaWJ1dGVfXygocGFja2VkKSkKKyNlbHNlCisjZGVmaW5lIF9fcGFja2VkCisjZW5kaWYK
KworI2RlZmluZSBBUlJBWV9TSVpFKGFycikgKHNpemVvZihhcnIpIC8gc2l6ZW9mKGFycilbMF0p
CisKIHN0cnVjdCBuZF9jbWRfc21hcnQgewogCV9fdTMyIHN0YXR1czsKIAlfX3U4IGRhdGFbMTI4
XTsKLS0gCjIuOS4wCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcK
aHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
