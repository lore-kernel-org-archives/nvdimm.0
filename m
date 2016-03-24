Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F2671A1E94
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 07:49:06 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id r187so64166752oih.3
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 07:48:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2305610.tLOzfXxl0W@c203>
References: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
 <20160324012526.21436.70359.stgit@dwillia2-desk3.jf.intel.com>
 <2305610.tLOzfXxl0W@c203>
Date: Thu, 24 Mar 2016 07:48:07 -0700
Message-ID: <CAPcyv4i+7=k8AEtcq_7XyktQMaAbQzy3ezvxj_ziLDakwwotiw@mail.gmail.com>
Subject: Re: [PATCH 01/13] libnvdimm, pfn: fix nvdimm_namespace_add_poison()
 vs section alignment
From: Dan Williams <dan.j.williams@intel.com>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCBNYXIgMjQsIDIwMTYgYXQgMzoxMCBBTSwgSm9oYW5uZXMgVGh1bXNoaXJuIDxqdGh1
bXNoaXJuQHN1c2UuZGU+IHdyb3RlOgo+IE9uIE1pdHR3b2NoLCAyMy4gTcOkcnogMjAxNiAxODoy
NToyNiBDRVQgRGFuIFdpbGxpYW1zIHdyb3RlOgo+PiBXaGVuIHNlY3Rpb24gYWxpZ25tZW50IHBh
ZGRpbmcgaXMgaW4gZWZmZWN0IHdlIG5lZWQgdG8gc2hpZnQgLyB0cnVuY2F0ZQo+PiB0aGUgcmFu
Z2UgdGhhdCBpcyBxdWVyaWVkIGZvciBwb2lzb24gYnkgdGhlICdzdGFydF9wYWQnIG9yICdlbmRf
dHJ1bmMnCj4+IHJlc2VydmF0aW9ucy4KPj4KPj4gSXQncyBlYXNpZXN0IGlmIHdlIGp1c3QgcGFz
cyBpbiBhbiBhZGp1c3RlZCByZXNvdXJjZSByYW5nZSByYXRoZXIgdGhhbgo+PiBkZXJpdmluZyBp
dCBmcm9tIHRoZSBwYXNzZWQgaW4gbmFtZXNwYWNlLiAgV2l0aCB0aGUgcmVzb3VyY2UgcmFuZ2UK
Pj4gcmVzb2x1dGlvbiBwdXNoZWQgb3V0IHRvIHRoZSBjYWxsZXIgd2UgY2FuIGFsc28gcHVzaCB0
aGUKPj4gbmFtZXNwYWNlLXRvLXJlZ2lvbiBsb29rdXAgdG8gdGhlIGNhbGxlciBhbmQgZHJvcCB0
aGUgaW1wbGljaXQgcG1lbS10eXBlCj4+IGFzc3VtcHRpb24gYWJvdXQgdGhlIHBhc3NlZCBpbiBu
YW1lc3BhY2Ugb2JqZWN0Lgo+Pgo+PiBDYzogVmlzaGFsIFZlcm1hIDx2aXNoYWwubC52ZXJtYUBp
bnRlbC5jb20+Cj4+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KPj4gU2lnbmVkLW9mZi1i
eTogRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+Cj4KPiBEb2VzIHRoaXMg
cmVhbGx5IHF1YWxpZnkgZm9yIGluY2x1c2lvbiBpbnRvIHN0YWJsZT8KCkRlcGVuZHMgb24gd2hl
biB3ZSBwdXNoIGl0LiAgSWYgd2Ugd2FpdCBmb3IgdGhlIDQuNyBtZXJnZSB3aW5kb3cgdGhpcwp3
aWxsIGJlIC1zdGFibGUgbWF0ZXJpYWwgdG8gZml4IDQuNi4gIFRoZSBsYWNrIG9mIHVyZ2VuY3kg
aXMgZHJpdmVuIGJ5CnRoZSBmYWN0IHRoYXQgdGhlcmUgaXMgc3RpbGwgdGltZSB0byB3b3JrIHdp
dGggQklPUyBpbXBsZW1lbnRhdGlvbnMgdG8KYWRkcmVzcyB0aGUgMTI4TUIgYWxpZ25tZW50IHBy
b2JsZW0uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxp
bnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczov
L2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
