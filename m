Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E6E4921314729
 for <linux-nvdimm@lists.01.org>; Fri,  2 Aug 2019 17:11:16 -0700 (PDT)
Subject: [ndctl PATCH v3 1/8] ndctl/build: Suppress -Waddress-of-packed-member
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 02 Aug 2019 16:54:28 -0700
Message-ID: <156479006802.707590.7623788701230232646.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156479006271.707590.298793474092813749.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156479006271.707590.298793474092813749.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Z2NjIDkuMS4xIGVtaXRzIGEgc2xldyBvZiB3YXJuaW5ncyBmb3IgbWFueSBvZiB0aGUgY29tbWFu
ZCBmaWVsZAphY2Nlc3Nlcy4gSS5lLiB3YXJuaW5ncyBvZiB0aGUgZm9ybToKCmxpYm5kY3RsLmM6
MjU4NjoyMTogd2FybmluZzogdGFraW5nIGFkZHJlc3Mgb2YgcGFja2VkIG1lbWJlciBvZiDigJhz
dHJ1Y3QgbmRfY21kX2dldF9jb25maWdfZGF0YV9oZHLigJkgbWF5IHJlc3VsdCBpbiBhbiB1bmFs
aWduZWQgcG9pbnRlciB2YWx1ZSBbLVdhZGRyZXNzLW9mLXBhY2tlZC1tZW1iZXJdCiAyNTg2IHwg
IGNtZC0+aXRlci5vZmZzZXQgPSAmY21kLT5nZXRfZGF0YS0+aW5fb2Zmc2V0OwogICAgICB8ICAg
ICAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fgoKU3VwcHJlc3MgdGhl
c2UgYXMgZml4aW5nIHRoZSB3YXJuaW5nIHdvdWxkIGRlZmVhdCB0aGUgYWJzdHJhY3Rpb24gb2Yg
YmVpbmcgYWJsZQp0byBoYXZlIGNvbW1vbiBjb2RlIHRoYXQgb3BlcmF0ZXMgb24gY29tbWFuZHMg
d2l0aCBjb21tb24gZmllbGRzIGF0IGRpZmZlcmVudApvZmZzZXRzIGluIHRoZSBwYXlsb2FkLgoK
U2lnbmVkLW9mZi1ieTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+Ci0t
LQogY29uZmlndXJlLmFjIHwgICAgMSArCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykK
CmRpZmYgLS1naXQgYS9jb25maWd1cmUuYWMgYi9jb25maWd1cmUuYWMKaW5kZXggNDczN2NmZmY3
N2YyLi43OWY4Mjk3N2ZhNDQgMTAwNjQ0Ci0tLSBhL2NvbmZpZ3VyZS5hYworKysgYi9jb25maWd1
cmUuYWMKQEAgLTIxNCw2ICsyMTQsNyBAQCBteV9DRkxBR1M9IlwKIC1XbWF5YmUtdW5pbml0aWFs
aXplZCBcCiAtV2RlY2xhcmF0aW9uLWFmdGVyLXN0YXRlbWVudCBcCiAtV3VudXNlZC1yZXN1bHQg
XAorLVduby1hZGRyZXNzLW9mLXBhY2tlZC1tZW1iZXIgXAogLURfRk9SVElGWV9TT1VSQ0U9MiBc
CiAtTzIKICIKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRw
czovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
