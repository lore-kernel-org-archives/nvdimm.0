Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 01BAC21959CB2
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 02:17:14 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x5K98Wp9001235
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 05:17:13 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2t878bratg-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Thu, 20 Jun 2019 05:17:13 -0400
Received: from localhost
 by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Thu, 20 Jun 2019 10:17:13 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: [PATCH v4 0/6] Fixes related namespace alignment/page size/big endian
Date: Thu, 20 Jun 2019 14:46:20 +0530
MIME-Version: 1.0
Message-Id: <20190620091626.31824-1-aneesh.kumar@linux.ibm.com>
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
To: dan.j.williams@intel.com
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

VGhpcyBzZXJpZXMgaGFuZGxlIGNvbmZpZ3Mgd2hlcmUgaHVnZXBhZ2Ugc3VwcG9ydCBpcyBub3Qg
ZW5hYmxlZCBieSBkZWZhdWx0LgpBbHNvLCB3ZSB1cGRhdGUgc29tZSBvZiB0aGUgaW5mb3JtYXRp
b24gbWVzc2FnZXMgdG8gbWFrZSBzdXJlIHdlIHVzZSBQQUdFX1NJWkUgaW5zdGVhZApvZiBTWl80
Sy4gV2Ugbm93IHN0b3JlIHBhZ2Ugc2l6ZSBhbmQgc3RydWN0IHBhZ2Ugc2l6ZSBpbiBwZm5fc2Ig
YW5kIGRvIGV4dHJhIGNoZWNrCmJlZm9yZSBlbmFibGluZyBuYW1lc3BhY2UuIFRoZXJlIGFsc28g
YW4gZW5kaWFubmVzcyBmaXguCgpUaGUgcGF0Y2ggc2VyaWVzIGlzIG9uIHRvcCBvZiBzdWJzZWN0
aW9uIHYxMCBwYXRjaHNldAoKaHR0cDovL2xvcmUua2VybmVsLm9yZy9saW51eC1tbS8xNTYwOTIz
NDkzMDAuOTc5OTU5LjE3NjAzNzEwNzExOTU3NzM1MTM1LnN0Z2l0QGR3aWxsaWEyLWRlc2szLmFt
ci5jb3JwLmludGVsLmNvbQoKQ2hhbmdlcyBmcm9tIFYzOgoqIERyb3BwZWQgdGhlIGNoYW5nZSBy
ZWxhdGVkIFBGTl9NSU5fVkVSU0lPTgoqIGZvciBwZm5fc2IgbWlub3IgdmVyc2lvbiA8IDQsIHdl
IGRlZmF1bHQgcGFnZV9zaXplIHRvIFBBR0VfU0laRSBpbnN0ZWFkIG9mIFNaXzRrLgoKQW5lZXNo
IEt1bWFyIEsuViAoNik6CiAgbnZkaW1tOiBDb25zaWRlciBwcm9iZSByZXR1cm4gLUVPUE5PVFNV
UFAgYXMgc3VjY2VzcwogIG1tL252ZGltbTogQWRkIHBhZ2Ugc2l6ZSBhbmQgc3RydWN0IHBhZ2Ug
c2l6ZSB0byBwZm4gc3VwZXJibG9jawogIG1tL252ZGltbTogVXNlIGNvcnJlY3QgI2RlZmluZXMg
aW5zdGVhZCBvZiBvcGVuIGNvZGluZwogIG1tL252ZGltbTogUGljayB0aGUgcmlnaHQgYWxpZ25t
ZW50IGRlZmF1bHQgd2hlbiBjcmVhdGluZyBkYXggZGV2aWNlcwogIG1tL252ZGltbTogVXNlIGNv
cnJlY3QgYWxpZ25tZW50IHdoZW4gbG9va2luZyBhdCBmaXJzdCBwZm4gZnJvbSBhCiAgICByZWdp
b24KICBtbS9udmRpbW06IEZpeCBlbmRpYW4gY29udmVyc2lvbiBpc3N1ZXPCoAoKIGFyY2gvcG93
ZXJwYy9pbmNsdWRlL2FzbS9saWJudmRpbW0uaCB8ICA5ICsrKysKIGFyY2gvcG93ZXJwYy9tbS9N
YWtlZmlsZSAgICAgICAgICAgICB8ICAxICsKIGFyY2gvcG93ZXJwYy9tbS9udmRpbW0uYyAgICAg
ICAgICAgICB8IDM0ICsrKysrKysrKysrKysrKwogYXJjaC94ODYvaW5jbHVkZS9hc20vbGlibnZk
aW1tLmggICAgIHwgMTkgKysrKysrKysrCiBkcml2ZXJzL252ZGltbS9idHQuYyAgICAgICAgICAg
ICAgICAgfCAgOCArKy0tCiBkcml2ZXJzL252ZGltbS9idXMuYyAgICAgICAgICAgICAgICAgfCAg
NCArLQogZHJpdmVycy9udmRpbW0vbGFiZWwuYyAgICAgICAgICAgICAgIHwgIDIgKy0KIGRyaXZl
cnMvbnZkaW1tL25hbWVzcGFjZV9kZXZzLmMgICAgICB8IDEzICsrKy0tLQogZHJpdmVycy9udmRp
bW0vbmQtY29yZS5oICAgICAgICAgICAgIHwgIDMgKy0KIGRyaXZlcnMvbnZkaW1tL25kLmggICAg
ICAgICAgICAgICAgICB8ICA2IC0tLQogZHJpdmVycy9udmRpbW0vcGZuLmggICAgICAgICAgICAg
ICAgIHwgIDUgKystCiBkcml2ZXJzL252ZGltbS9wZm5fZGV2cy5jICAgICAgICAgICAgfCA2MiAr
KysrKysrKysrKysrKysrKysrKysrKysrKy0tCiBkcml2ZXJzL252ZGltbS9wbWVtLmMgICAgICAg
ICAgICAgICAgfCAyNiArKysrKysrKysrLS0KIGRyaXZlcnMvbnZkaW1tL3JlZ2lvbl9kZXZzLmMg
ICAgICAgICB8IDI3ICsrKysrKysrLS0tLQogaW5jbHVkZS9saW51eC9odWdlX21tLmggICAgICAg
ICAgICAgIHwgIDcgKysrLQoga2VybmVsL21lbXJlbWFwLmMgICAgICAgICAgICAgICAgICAgIHwg
IDggKystLQogMTYgZmlsZXMgY2hhbmdlZCwgMTk0IGluc2VydGlvbnMoKyksIDQwIGRlbGV0aW9u
cygtKQogY3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9saWJudmRp
bW0uaAogY3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gvcG93ZXJwYy9tbS9udmRpbW0uYwogY3JlYXRl
IG1vZGUgMTAwNjQ0IGFyY2gveDg2L2luY2x1ZGUvYXNtL2xpYm52ZGltbS5oCgotLSAKMi4yMS4w
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpMaW51eC1u
dmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0
cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
