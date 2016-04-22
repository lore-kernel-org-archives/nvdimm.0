Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 70DEC1A20D7
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 12:48:07 -0700 (PDT)
Subject: [ndctl PATCH 3/8] ndctl: fix build on systems where /bin/sh is not
 a link to bash
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Apr 2016 12:47:18 -0700
Message-ID: <146135443801.4228.10172852540070823673.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Marcin =?utf-8?q?=C5=9Alusarz?= <marcin.slusarz@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

RnJvbTogTWFyY2luIMWabHVzYXJ6IDxtYXJjaW4uc2x1c2FyekBpbnRlbC5jb20+CgpPbiBEZWJp
YW4gYW5kIFVidW50dSBhdXRvZ2VuLnNoIGZhaWxzIGJlY2F1c2U6Ci4vZ2l0LXZlcnNpb246IDM3
OiAuL2dpdC12ZXJzaW9uOiBCYWQgc3Vic3RpdHV0aW9uCgpTaWduZWQtb2ZmLWJ5OiBNYXJjaW4g
xZpsdXNhcnogPG1hcmNpbi5zbHVzYXJ6QGludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTogRGFuIFdp
bGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+Ci0tLQogZ2l0LXZlcnNpb24gfCAgICAy
ICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYg
LS1naXQgYS9naXQtdmVyc2lvbiBiL2dpdC12ZXJzaW9uCmluZGV4IGM3OGFmZjQ2MDIzZi4uNjI5
ZjZkNGEyMTNkIDEwMDc1NQotLS0gYS9naXQtdmVyc2lvbgorKysgYi9naXQtdmVyc2lvbgpAQCAt
MSw0ICsxLDQgQEAKLSMhL2Jpbi9zaAorIyEvYmluL2Jhc2gKIAogZGlydHkoKSB7CiAJZ2l0IHVw
ZGF0ZS1pbmRleCAtcSAtLXJlZnJlc2gKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxp
c3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52
ZGltbQo=
