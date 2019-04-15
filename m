Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com
 [IPv6:2607:f8b0:4864:20::32c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 78170212017CD
 for <linux-nvdimm@lists.01.org>; Mon, 15 Apr 2019 10:05:04 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 103so15069409otd.9
 for <linux-nvdimm@lists.01.org>; Mon, 15 Apr 2019 10:05:04 -0700 (PDT)
MIME-Version: 1.0
References: <1555051638-32354-1-git-send-email-lirongqing@baidu.com>
 <CAPcyv4hD9rwFHyEh=5gAWe0JPwzUJqUTi4FaUkyLtyovE==U1w@mail.gmail.com>
 <46ecaf420d664ebfab035e8202a774a9@baidu.com>
 <AT5PR8401MB11694F5888BCE7133F1FDD4FAB2A0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <0ebe45b82dbf48348e4582e597e6edfc@baidu.com>
In-Reply-To: <0ebe45b82dbf48348e4582e597e6edfc@baidu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Apr 2019 10:04:52 -0700
Message-ID: <CAPcyv4i0oMipX1jySgmmgBjn_nZr+pN=_EemzZ3TdKyAW5xC6g@mail.gmail.com>
Subject: Re: [PATCH][RFC] nvdimm: pmem: always flush nvdimm for write request
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
To: "Li,Rongqing" <lirongqing@baidu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gU3VuLCBBcHIgMTQsIDIwMTkgYXQgODoyNiBQTSBMaSxSb25ncWluZyA8bGlyb25ncWluZ0Bi
YWlkdS5jb20+IHdyb3RlOgo+Cj4KPgo+ID4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQo+ID4g5Y+R
5Lu25Lq6OiBFbGxpb3R0LCBSb2JlcnQgKFNlcnZlcnMpIFttYWlsdG86ZWxsaW90dEBocGUuY29t
XQo+ID4g5Y+R6YCB5pe26Ze0OiAyMDE55bm0NOaciDE05pelIDExOjIxCj4gPiDmlLbku7bkuro6
IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT47IERhbiBXaWxsaWFtcwo+ID4gPGRh
bi5qLndpbGxpYW1zQGludGVsLmNvbT4KPiA+IOaKhOmAgTogbGludXgtbnZkaW1tIDxsaW51eC1u
dmRpbW1AbGlzdHMuMDEub3JnPgo+ID4g5Li76aKYOiBSRTogW1BBVENIXVtSRkNdIG52ZGltbTog
cG1lbTogYWx3YXlzIGZsdXNoIG52ZGltbSBmb3Igd3JpdGUgcmVxdWVzdAo+ID4KPiA+Cj4gPgo+
ID4gPj4gQEAgLTIxNSw3ICsyMTYsNyBAQCBzdGF0aWMgYmxrX3FjX3QgcG1lbV9tYWtlX3JlcXVl
c3Qoc3RydWN0Cj4gPiByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgYmlvICpiaW8pCj4gPiA+PiAg
ICBpZiAoZG9fYWNjdCkKPiA+ID4+ICAgICAgICAgICAgbmRfaW9zdGF0X2VuZChiaW8sIHN0YXJ0
KTsKPiA+ID4+Cj4gPiA+PiAtICBpZiAoYmlvLT5iaV9vcGYgJiBSRVFfRlVBKQo+ID4gPj4gKyAg
aWYgKGJpby0+Ymlfb3BmICYgUkVRX0ZVQSB8fCBvcF9pc193cml0ZShvcCkpCj4gPiA+PiAgICAg
ICAgICAgIG52ZGltbV9mbHVzaChuZF9yZWdpb24pOwo+ID4gLi4uCj4gPiA+PiBCZWZvcmU6Cj4g
PiA+PiBKb2JzOiAzMiAoZj0zMik6IFtXKDMyKV1bMTQuMiVdW3c9MTg4NE1pQi9zXVt3PTQ4Mmsg
SU9QU11bZXRhCj4gPiA+PiAwMW06NDNzXQo+ID4gPj4gQWZ0ZXI6Cj4gPiA+PiBKb2JzOiAzMiAo
Zj0zMik6IFtXKDMyKV1bOC4zJV1bdz0yMzc4TWlCL3NdW3c9NjA5ayBJT1BTXVtldGEgMDFtOjUw
c10KPiA+ID4+Cj4gPiA+PiAtUm9uZ1FpbmcKPiA+Cj4gPgo+ID4gRG9pbmcgbW9yZSB3b3JrIGNh
bm5vdCBiZSBmYXN0ZXIgdGhhbiBkb2luZyBsZXNzIHdvcmssIHNvIHNvbWV0aGluZyBlbHNlCj4g
PiBtdXN0IGJlIGhhcHBlbmluZyBoZXJlLgo+ID4KPgo+IERhbiBXaWxsaWFtcyBtYXliZSBrbm93
IG1vcmUuCgpPbmUgdGhvdWdodCBpcyB0aGF0IGJhY2stcHJlc3N1cmUgZnJvbSBhd2FpdGluZyB3
cml0ZS1wb3N0ZWQtcXVldWUKZmx1c2ggY29tcGxldGlvbiBjYXVzZXMgZnVsbCBidWZmZXIgd3Jp
dGVzIHRvIGNvYWxlc2NlIGF0IHRoZQpjb250cm9sbGVyLCBpLmUuIHdyaXRlLWNvbWJpbmluZyBl
ZmZlY3RzIGZyb20gdGhlIGZsdXNoLWRlbGF5LgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGlt
bUBsaXN0cy4wMS5vcmcKaHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51
eC1udmRpbW0K
