Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com
 [IPv6:2607:f8b0:4864:20::744])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7B562126CFA9
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 17:31:34 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id z128so1214718qkb.6
 for <linux-nvdimm@lists.01.org>; Wed, 15 May 2019 17:31:34 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [RESEND PATCH] nvdimm: fix some compilation warnings
From: Qian Cai <cai@lca.pw>
In-Reply-To: <CAPcyv4gGwyPf0j4rXRM3JjsjGSHB6bGdZfwg+v2y8NQ6hNVK8g@mail.gmail.com>
Date: Wed, 15 May 2019 20:31:31 -0400
Message-Id: <3D0A6725-A738-4778-BB5B-1617B6184337@lca.pw>
References: <20190514150735.39625-1-cai@lca.pw>
 <CAPcyv4gGwyPf0j4rXRM3JjsjGSHB6bGdZfwg+v2y8NQ6hNVK8g@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Cj4+ICAgICAgICAgICAgICAgIH0KPj4gCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL252ZGltbS9i
dXMuYyBiL2RyaXZlcnMvbnZkaW1tL2J1cy5jCj4+IGluZGV4IDdmZjY4NDE1OWYyOS4uMmViNmE2
Y2ZlOWU0IDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL252ZGltbS9idXMuYwo+PiArKysgYi9kcml2
ZXJzL252ZGltbS9idXMuYwo+PiBAQCAtNjQyLDcgKzY0Miw3IEBAIHN0YXRpYyBzdHJ1Y3QgYXR0
cmlidXRlICpuZF9kZXZpY2VfYXR0cmlidXRlc1tdID0gewo+PiAgICAgICAgTlVMTCwKPj4gfTsK
Pj4gCj4+IC0vKioKPj4gKy8qCj4+ICAqIG5kX2RldmljZV9hdHRyaWJ1dGVfZ3JvdXAgLSBnZW5l
cmljIGF0dHJpYnV0ZXMgZm9yIGFsbCBkZXZpY2VzIG9uIGFuIG5kIGJ1cwo+PiAgKi8KPj4gc3Ry
dWN0IGF0dHJpYnV0ZV9ncm91cCBuZF9kZXZpY2VfYXR0cmlidXRlX2dyb3VwID0gewo+PiBAQCAt
NjcxLDcgKzY3MSw3IEBAIHN0YXRpYyB1bW9kZV90IG5kX251bWFfYXR0cl92aXNpYmxlKHN0cnVj
dCBrb2JqZWN0ICprb2JqLCBzdHJ1Y3QgYXR0cmlidXRlICphLAo+PiAgICAgICAgcmV0dXJuIGEt
Pm1vZGU7Cj4+IH0KPj4gCj4+IC0vKioKPj4gKy8qCj4+ICAqIG5kX251bWFfYXR0cmlidXRlX2dy
b3VwIC0gTlVNQSBhdHRyaWJ1dGVzIGZvciBhbGwgZGV2aWNlcyBvbiBhbiBuZCBidXMKPj4gICov
Cj4gCj4gTGV0cyBqdXN0IGZpeCB0aGlzIHRvIGJlIGEgdmFsaWQga2VybmVsLWRvYyBmb3JtYXQg
Zm9yIGEgc3RydWN0Lgo+IAo+IEBAIC02NzIsNyArNjcyLDcgQEAgc3RhdGljIHVtb2RlX3QgbmRf
bnVtYV9hdHRyX3Zpc2libGUoc3RydWN0IGtvYmplY3QKPiAqa29iaiwgc3RydWN0IGF0dHJpYnV0
ZSAqYSwKPiB9Cj4gCj4gLyoqCj4gLSAqIG5kX251bWFfYXR0cmlidXRlX2dyb3VwIC0gTlVNQSBh
dHRyaWJ1dGVzIGZvciBhbGwgZGV2aWNlcyBvbiBhbiBuZCBidXMKPiArICogc3RydWN0IG5kX251
bWFfYXR0cmlidXRlX2dyb3VwIC0gTlVNQSBhdHRyaWJ1dGVzIGZvciBhbGwgZGV2aWNlcwo+IG9u
IGFuIG5kIGJ1cwo+ICAqLwo+IHN0cnVjdCBhdHRyaWJ1dGVfZ3JvdXAgbmRfbnVtYV9hdHRyaWJ1
dGVfZ3JvdXAgPSB7Cj4gICAgICAgIC5hdHRycyA9IG5kX251bWFfYXR0cmlidXRlcywKClRoaXMg
d29u4oCZdCB3b3JrIGJlY2F1c2Uga2VybmVsLWRvYyBpcyB0byBleHBsYWluIGEgc3RydWN0IGRl
ZmluaXRpb24sIGJ1dCB0aGlzIGlzIGEganVzdCBhbiBhc3NpZ25tZW50LgpUaGUgInN0cnVjdCBh
dHRyaWJ1dGVfZ3JvdXDigJ0ga2VybmVsLWRvYyBpcyBpbiBpbmNsdWRlL2xpbnV4L3N5c2ZzLmgu
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52
ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3Rz
LjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
