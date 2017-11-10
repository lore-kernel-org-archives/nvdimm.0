Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 898C221B00DC2
 for <linux-nvdimm@lists.01.org>; Thu,  9 Nov 2017 22:56:17 -0800 (PST)
Received: by mail-ot0-x241.google.com with SMTP id s88so7440924ota.4
 for <linux-nvdimm@lists.01.org>; Thu, 09 Nov 2017 23:00:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1510238453-7713-1-git-send-email-lukasz.plewa@intel.com>
References: <1510238453-7713-1-git-send-email-lukasz.plewa@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 9 Nov 2017 23:00:18 -0800
Message-ID: <CAPcyv4gs3EBJidGCMgPTJ2zFKBKnqBBj=0ZaE3pcxgGnhE_wZQ@mail.gmail.com>
Subject: Re: [PATCH] daxctl: remove libpmem dependency
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
To: "Plewa, Lukasz" <lukasz.plewa@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gVGh1LCBOb3YgOSwgMjAxNyBhdCA2OjQwIEFNLCA8bHVrYXN6LnBsZXdhQGludGVsLmNvbT4g
d3JvdGU6Cj4KPiBGcm9tOiDFgXVrYXN6IFBsZXdhIDxsdWthc3oucGxld2FAaW50ZWwuY29tPgo+
Cj4gVGhlIG5leHQgdmVyc2lvbiBvZiBsaWJwbWVtIHdpbGwgZGVwZW5kIG9uIGxpYm5kY3RsIC0g
YXMgZGF4Y3RsCj4gZGVwZW5kcyBvbiBsaWJwbWVtLCBpdCB3aWxsIG1ha2UgYnVpbGRpbmcgcGFj
a2FnZXMgaW5jb252ZW5pZW50Lgo+IFRoaXMgcGF0Y2ggcmVwbGFjZXMgbGlicG1lbSBjYWxscyB3
aXRoIGludHJpbnNpYyBmdW5jdGlvbnMgd2hhdAo+IGFsbG93cyB0byByZW1vdmUgYSBsaWJwbWVt
IGRlcGVuZGVuY3kuCj4KPiBTaWduZWQtb2ZmLWJ5OiDFgXVrYXN6IFBsZXdhIDxsdWthc3oucGxl
d2FAaW50ZWwuY29tPgpbLi5dCj4gQEAgLTM1Nyw2ICszNTcsMjAgQEAgc3RhdGljIGludCBjbGVh
cl9iYWRibG9ja3Moc3RydWN0IGlvX2RldiAqZGV2LCB1aW50NjRfdCBsZW4pCj4gICAgICAgICBy
ZXR1cm4gMDsKPiAgfQo+Cj4gKyNkZWZpbmUgRkxVU0hfQUxJR04gNjQKPiArCj4gK3N0YXRpYyB2
b2lkIGNsZmx1c2goY29uc3Qgdm9pZCAqYWRkciwgc2l6ZV90IGxlbikKPiArewo+ICsgICAgICAg
LyoKPiArICAgICAgICAqIExvb3AgdGhyb3VnaCBjYWNoZS1saW5lLXNpemUgKHR5cGljYWxseSA2
NEIpIGFsaWduZWQgY2h1bmtzCj4gKyAgICAgICAgKiBjb3ZlcmluZyB0aGUgZ2l2ZW4gcmFuZ2Uu
Cj4gKyAgICAgICAgKi8KPiArICAgICAgIGZvciAodWludHB0cl90IHVwdHIgPSAodWludHB0cl90
KWFkZHIgJiB+KEZMVVNIX0FMSUdOIC0gMSk7Cj4gKyAgICAgICAgICAgIHVwdHIgPCAodWludHB0
cl90KWFkZHIgKyBsZW47IHVwdHIgKz0gRkxVU0hfQUxJR04pCj4gKyAgICAgICAgICAgICAgIF9t
bV9jbGZsdXNoKChjaGFyICopdXB0cik7Cj4gKyAgICAgICBfbW1fc2ZlbmNlKCk7CgpUaGUgY2xm
bHVzaCBpbnN0cnVjdGlvbiBpcyBzZXJpYWxpemluZyBzbyB3ZSBkb24ndCBuZWVkIHRoZSBzZmVu
Y2UuCkNhbiB3ZSBvcHRpb25hbGx5IHVzZSBjbHdiIGhlcmUgdG8gYXZvaWQgdGhlIGNhY2hlIGlu
dmFsaWRhdGlvbj8gQWxzbwpkb2VzIHRoZSBjbHdiIGludHJpbnNpYyBoYW5kbGUgZmFsbGluZyBi
YWNrIHRvIGNsZmx1c2hvcHQgYW5kIGNsZmx1c2gKd2hlbiB0aGUgY3B1IGRvZXMgbm90IGhhdmUg
Y2x3YiBzdXBwb3J0PwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpMaW51eC1udmRpbW0gbWFpbGluZyBsaXN0CkxpbnV4LW52ZGltbUBsaXN0cy4wMS5vcmcK
aHR0cHM6Ly9saXN0cy4wMS5vcmcvbWFpbG1hbi9saXN0aW5mby9saW51eC1udmRpbW0K
