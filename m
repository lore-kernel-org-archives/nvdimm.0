Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A0AB212B0FC8
 for <linux-nvdimm@lists.01.org>; Tue,  9 Jul 2019 21:50:33 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x6A4l2uU066093
 for <linux-nvdimm@lists.01.org>; Wed, 10 Jul 2019 00:50:32 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2tn7ye2j0j-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Wed, 10 Jul 2019 00:50:32 -0400
Received: from localhost
 by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Wed, 10 Jul 2019 05:50:30 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v4 0/6] Fixes related namespace alignment/page size/big
 endian
In-Reply-To: <20190620091626.31824-1-aneesh.kumar@linux.ibm.com>
References: <20190620091626.31824-1-aneesh.kumar@linux.ibm.com>
Date: Wed, 10 Jul 2019 10:20:24 +0530
MIME-Version: 1.0
Message-Id: <87o9221oj3.fsf@linux.ibm.com>
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
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

CkhpIERhbiwKCkNhbiB5b3UgbWVyZ2UgdGhpcyB0byB5b3VyIHRyZWU/CgotYW5lZXNoCiJBbmVl
c2ggS3VtYXIgSy5WIiA8YW5lZXNoLmt1bWFyQGxpbnV4LmlibS5jb20+IHdyaXRlczoKCj4gVGhp
cyBzZXJpZXMgaGFuZGxlIGNvbmZpZ3Mgd2hlcmUgaHVnZXBhZ2Ugc3VwcG9ydCBpcyBub3QgZW5h
YmxlZCBieSBkZWZhdWx0Lgo+IEFsc28sIHdlIHVwZGF0ZSBzb21lIG9mIHRoZSBpbmZvcm1hdGlv
biBtZXNzYWdlcyB0byBtYWtlIHN1cmUgd2UgdXNlIFBBR0VfU0laRSBpbnN0ZWFkCj4gb2YgU1pf
NEsuIFdlIG5vdyBzdG9yZSBwYWdlIHNpemUgYW5kIHN0cnVjdCBwYWdlIHNpemUgaW4gcGZuX3Ni
IGFuZCBkbyBleHRyYSBjaGVjawo+IGJlZm9yZSBlbmFibGluZyBuYW1lc3BhY2UuIFRoZXJlIGFs
c28gYW4gZW5kaWFubmVzcyBmaXguCj4KPiBUaGUgcGF0Y2ggc2VyaWVzIGlzIG9uIHRvcCBvZiBz
dWJzZWN0aW9uIHYxMCBwYXRjaHNldAo+Cj4gaHR0cDovL2xvcmUua2VybmVsLm9yZy9saW51eC1t
bS8xNTYwOTIzNDkzMDAuOTc5OTU5LjE3NjAzNzEwNzExOTU3NzM1MTM1LnN0Z2l0QGR3aWxsaWEy
LWRlc2szLmFtci5jb3JwLmludGVsLmNvbQo+Cj4gQ2hhbmdlcyBmcm9tIFYzOgo+ICogRHJvcHBl
ZCB0aGUgY2hhbmdlIHJlbGF0ZWQgUEZOX01JTl9WRVJTSU9OCj4gKiBmb3IgcGZuX3NiIG1pbm9y
IHZlcnNpb24gPCA0LCB3ZSBkZWZhdWx0IHBhZ2Vfc2l6ZSB0byBQQUdFX1NJWkUgaW5zdGVhZCBv
ZiBTWl80ay4KPgo+IEFuZWVzaCBLdW1hciBLLlYgKDYpOgo+ICAgbnZkaW1tOiBDb25zaWRlciBw
cm9iZSByZXR1cm4gLUVPUE5PVFNVUFAgYXMgc3VjY2Vzcwo+ICAgbW0vbnZkaW1tOiBBZGQgcGFn
ZSBzaXplIGFuZCBzdHJ1Y3QgcGFnZSBzaXplIHRvIHBmbiBzdXBlcmJsb2NrCj4gICBtbS9udmRp
bW06IFVzZSBjb3JyZWN0ICNkZWZpbmVzIGluc3RlYWQgb2Ygb3BlbiBjb2RpbmcKPiAgIG1tL252
ZGltbTogUGljayB0aGUgcmlnaHQgYWxpZ25tZW50IGRlZmF1bHQgd2hlbiBjcmVhdGluZyBkYXgg
ZGV2aWNlcwo+ICAgbW0vbnZkaW1tOiBVc2UgY29ycmVjdCBhbGlnbm1lbnQgd2hlbiBsb29raW5n
IGF0IGZpcnN0IHBmbiBmcm9tIGEKPiAgICAgcmVnaW9uCj4gICBtbS9udmRpbW06IEZpeCBlbmRp
YW4gY29udmVyc2lvbiBpc3N1ZXPCoAo+Cj4gIGFyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9saWJu
dmRpbW0uaCB8ICA5ICsrKysKPiAgYXJjaC9wb3dlcnBjL21tL01ha2VmaWxlICAgICAgICAgICAg
IHwgIDEgKwo+ICBhcmNoL3Bvd2VycGMvbW0vbnZkaW1tLmMgICAgICAgICAgICAgfCAzNCArKysr
KysrKysrKysrKysKPiAgYXJjaC94ODYvaW5jbHVkZS9hc20vbGlibnZkaW1tLmggICAgIHwgMTkg
KysrKysrKysrCj4gIGRyaXZlcnMvbnZkaW1tL2J0dC5jICAgICAgICAgICAgICAgICB8ICA4ICsr
LS0KPiAgZHJpdmVycy9udmRpbW0vYnVzLmMgICAgICAgICAgICAgICAgIHwgIDQgKy0KPiAgZHJp
dmVycy9udmRpbW0vbGFiZWwuYyAgICAgICAgICAgICAgIHwgIDIgKy0KPiAgZHJpdmVycy9udmRp
bW0vbmFtZXNwYWNlX2RldnMuYyAgICAgIHwgMTMgKysrLS0tCj4gIGRyaXZlcnMvbnZkaW1tL25k
LWNvcmUuaCAgICAgICAgICAgICB8ICAzICstCj4gIGRyaXZlcnMvbnZkaW1tL25kLmggICAgICAg
ICAgICAgICAgICB8ICA2IC0tLQo+ICBkcml2ZXJzL252ZGltbS9wZm4uaCAgICAgICAgICAgICAg
ICAgfCAgNSArKy0KPiAgZHJpdmVycy9udmRpbW0vcGZuX2RldnMuYyAgICAgICAgICAgIHwgNjIg
KysrKysrKysrKysrKysrKysrKysrKysrKystLQo+ICBkcml2ZXJzL252ZGltbS9wbWVtLmMgICAg
ICAgICAgICAgICAgfCAyNiArKysrKysrKysrLS0KPiAgZHJpdmVycy9udmRpbW0vcmVnaW9uX2Rl
dnMuYyAgICAgICAgIHwgMjcgKysrKysrKystLS0tCj4gIGluY2x1ZGUvbGludXgvaHVnZV9tbS5o
ICAgICAgICAgICAgICB8ICA3ICsrKy0KPiAga2VybmVsL21lbXJlbWFwLmMgICAgICAgICAgICAg
ICAgICAgIHwgIDggKystLQo+ICAxNiBmaWxlcyBjaGFuZ2VkLCAxOTQgaW5zZXJ0aW9ucygrKSwg
NDAgZGVsZXRpb25zKC0pCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBhcmNoL3Bvd2VycGMvaW5jbHVk
ZS9hc20vbGlibnZkaW1tLmgKPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGFyY2gvcG93ZXJwYy9tbS9u
dmRpbW0uYwo+ICBjcmVhdGUgbW9kZSAxMDA2NDQgYXJjaC94ODYvaW5jbHVkZS9hc20vbGlibnZk
aW1tLmgKPgo+IC0tIAo+IDIuMjEuMAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
