Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E7E822130D7E0
 for <linux-nvdimm@lists.01.org>; Mon,  5 Aug 2019 10:37:05 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id l12so1998751oil.1
 for <linux-nvdimm@lists.01.org>; Mon, 05 Aug 2019 10:34:35 -0700 (PDT)
MIME-Version: 1.0
References: <156479006271.707590.298793474092813749.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156479006802.707590.7623788701230232646.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x491rxzr1rq.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x491rxzr1rq.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 5 Aug 2019 10:34:23 -0700
Message-ID: <CAPcyv4jZVMFqd7G++vsOxCxPWp-bUUQ4KKAq0-oku0=hAE5zzA@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 1/8] ndctl/build: Suppress
 -Waddress-of-packed-member
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gTW9uLCBBdWcgNSwgMjAxOSBhdCAxMDowNiBBTSBKZWZmIE1veWVyIDxqbW95ZXJAcmVkaGF0
LmNvbT4gd3JvdGU6Cj4KPiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4g
d3JpdGVzOgo+Cj4gPiBnY2MgOS4xLjEgZW1pdHMgYSBzbGV3IG9mIHdhcm5pbmdzIGZvciBtYW55
IG9mIHRoZSBjb21tYW5kIGZpZWxkCj4gPiBhY2Nlc3Nlcy4gSS5lLiB3YXJuaW5ncyBvZiB0aGUg
Zm9ybToKPiA+Cj4gPiBsaWJuZGN0bC5jOjI1ODY6MjE6IHdhcm5pbmc6IHRha2luZyBhZGRyZXNz
IG9mIHBhY2tlZCBtZW1iZXIgb2Yg4oCYc3RydWN0IG5kX2NtZF9nZXRfY29uZmlnX2RhdGFfaGRy
4oCZIG1heSByZXN1bHQgaW4gYW4gdW5hbGlnbmVkIHBvaW50ZXIgdmFsdWUgWy1XYWRkcmVzcy1v
Zi1wYWNrZWQtbWVtYmVyXQo+ID4gIDI1ODYgfCAgY21kLT5pdGVyLm9mZnNldCA9ICZjbWQtPmdl
dF9kYXRhLT5pbl9vZmZzZXQ7Cj4gPiAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgXn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fgo+ID4KPiA+IFN1cHByZXNzIHRoZXNlIGFzIGZpeGluZyB0aGUg
d2FybmluZyB3b3VsZCBkZWZlYXQgdGhlIGFic3RyYWN0aW9uIG9mIGJlaW5nIGFibGUKPiA+IHRv
IGhhdmUgY29tbW9uIGNvZGUgdGhhdCBvcGVyYXRlcyBvbiBjb21tYW5kcyB3aXRoIGNvbW1vbiBm
aWVsZHMgYXQgZGlmZmVyZW50Cj4gPiBvZmZzZXRzIGluIHRoZSBwYXlsb2FkLgo+Cj4gQXMgSSB1
bmRlcnN0YW5kIGl0LCB0YWtpbmcgYSBwb2ludGVyIHRvIHRoaXMgcG90ZW50aWFsbHkgdW5hbGln
bmVkCj4gbWVtYmVyIGNhbiByZXN1bHQgaW4gYnVzIGVycm9ycyAob3Igd29yc2UsIGFjY2Vzc2lu
ZyB3cm9uZyBkYXRhKSBvbgo+IGFyY2hpdGVjdHVyZXMgdGhhdCBkb24ndCBzdXBwb3J0IHVuYWxp
Z25lZCBhY2Nlc3Nlcy4gIEknZCBiZSBhIHdob2xlIGxvdAo+IGhhcHBpZXIgd2l0aCB0aGlzIGNo
YW5nZWxvZyBpZiBpdCBtZW50aW9uZWQgdGhhdCB5b3UgaGFkIGNvbnNpZGVyZWQgd2hhdAo+IHRo
ZSB3YXJuaW5nIGFjdHVhbGx5IG1lYW50LCBhbmQgZGVjaWRlZCBpdCBkaWRuJ3QgbWF0dGVyIGZv
ciB0aGUKPiBhcmNoaXRlY3R1cmVzIHlvdSB3YW50IHRvIHN1cHBvcnQuCgpUcnVlLCBpdCB3YXMg
YSBmbGVldGluZyB0aG91Z2h0LCBidXQgbm90IHNvbWV0aGluZyBJIGNvbnNpZGVyZWQKZmxlc2hp
bmcgb3V0Li4uIEknbGwgc2VuZCBhIHJldmlzaW9uLgoKPgo+IHg4NiBpcywgb2YgY291cnNlLCBz
YWZlLiAgSSBiZWxpZXZlIGFhcmNoNjQgaXMsIGFzIHdlbGwuICBJIGRpZG4ndCBsb29rCj4gaW50
byBvdGhlcnMuCj4KCktlZXAgaW4gbWluZCB0aGF0IHRoaXMgY29kZSBpcyBmb3IgaW50ZXJmYWNp
bmcgd2l0aCB0aGUgQUNQSSBEU00gcGF0aC4KSWYgYW4gdW5hbGlnbmVkLWluY2FwYWJsZSBhcmNo
aXRlY3R1cmUgZGVmaW5lZCBhbiBOVkRJTU0gY29tbWFuZCBzZXQKaXQgaXMgaGlnaGx5IHVubGlr
ZWx5IGl0IHdvdWxkIGJlIEFDUEkgYmFzZWQsIG9yIHBpY2sgdGhlc2UKcHJvYmxlbWF0aWMgY29t
bWFuZCBmb3JtYXRzLiBJIGNhbiBhZGQgdGhlc2Ugbm90ZXMgdG8gdGhlIGNoYW5nZWxvZywKYnV0
IHRoZSB1bmZvcnR1bmF0ZSBkZWZpbml0aW9uIG9mIHRoZXNlIHBheWxvYWRzIHRoYXQgcmVxdWly
ZSBfX3BhY2tlZAppcyBzb21ldGhpbmcgSSBob3BlIG90aGVyIGFyY2hpdGVjdHVyZXMgYXZvaWQu
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52
ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3Rz
LjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
