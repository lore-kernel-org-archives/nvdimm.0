Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0378A212CFEAB
 for <linux-nvdimm@lists.01.org>; Mon,  5 Aug 2019 10:47:45 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [ndctl PATCH v3 1/8] ndctl/build: Suppress
 -Waddress-of-packed-member
References: <156479006271.707590.298793474092813749.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156479006802.707590.7623788701230232646.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x491rxzr1rq.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jZVMFqd7G++vsOxCxPWp-bUUQ4KKAq0-oku0=hAE5zzA@mail.gmail.com>
Date: Mon, 05 Aug 2019 13:45:12 -0400
In-Reply-To: <CAPcyv4jZVMFqd7G++vsOxCxPWp-bUUQ4KKAq0-oku0=hAE5zzA@mail.gmail.com>
 (Dan Williams's message of "Mon, 5 Aug 2019 10:34:23 -0700")
Message-ID: <x49tvavpkuv.fsf@segfault.boston.devel.redhat.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

RGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+IHdyaXRlczoKCj4gT24gTW9u
LCBBdWcgNSwgMjAxOSBhdCAxMDowNiBBTSBKZWZmIE1veWVyIDxqbW95ZXJAcmVkaGF0LmNvbT4g
d3JvdGU6Cj4+Cj4+IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPiB3cml0
ZXM6Cj4+Cj4+ID4gZ2NjIDkuMS4xIGVtaXRzIGEgc2xldyBvZiB3YXJuaW5ncyBmb3IgbWFueSBv
ZiB0aGUgY29tbWFuZCBmaWVsZAo+PiA+IGFjY2Vzc2VzLiBJLmUuIHdhcm5pbmdzIG9mIHRoZSBm
b3JtOgo+PiA+Cj4+ID4gbGlibmRjdGwuYzoyNTg2OjIxOiB3YXJuaW5nOiB0YWtpbmcgYWRkcmVz
cyBvZiBwYWNrZWQgbWVtYmVyIG9mIOKAmHN0cnVjdCBuZF9jbWRfZ2V0X2NvbmZpZ19kYXRhX2hk
cuKAmSBtYXkgcmVzdWx0IGluIGFuIHVuYWxpZ25lZCBwb2ludGVyIHZhbHVlIFstV2FkZHJlc3Mt
b2YtcGFja2VkLW1lbWJlcl0KPj4gPiAgMjU4NiB8ICBjbWQtPml0ZXIub2Zmc2V0ID0gJmNtZC0+
Z2V0X2RhdGEtPmluX29mZnNldDsKPj4gPiAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgXn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fgo+PiA+Cj4+ID4gU3VwcHJlc3MgdGhlc2UgYXMgZml4aW5n
IHRoZSB3YXJuaW5nIHdvdWxkIGRlZmVhdCB0aGUgYWJzdHJhY3Rpb24gb2YgYmVpbmcgYWJsZQo+
PiA+IHRvIGhhdmUgY29tbW9uIGNvZGUgdGhhdCBvcGVyYXRlcyBvbiBjb21tYW5kcyB3aXRoIGNv
bW1vbiBmaWVsZHMgYXQgZGlmZmVyZW50Cj4+ID4gb2Zmc2V0cyBpbiB0aGUgcGF5bG9hZC4KPj4K
Pj4gQXMgSSB1bmRlcnN0YW5kIGl0LCB0YWtpbmcgYSBwb2ludGVyIHRvIHRoaXMgcG90ZW50aWFs
bHkgdW5hbGlnbmVkCj4+IG1lbWJlciBjYW4gcmVzdWx0IGluIGJ1cyBlcnJvcnMgKG9yIHdvcnNl
LCBhY2Nlc3Npbmcgd3JvbmcgZGF0YSkgb24KPj4gYXJjaGl0ZWN0dXJlcyB0aGF0IGRvbid0IHN1
cHBvcnQgdW5hbGlnbmVkIGFjY2Vzc2VzLiAgSSdkIGJlIGEgd2hvbGUgbG90Cj4+IGhhcHBpZXIg
d2l0aCB0aGlzIGNoYW5nZWxvZyBpZiBpdCBtZW50aW9uZWQgdGhhdCB5b3UgaGFkIGNvbnNpZGVy
ZWQgd2hhdAo+PiB0aGUgd2FybmluZyBhY3R1YWxseSBtZWFudCwgYW5kIGRlY2lkZWQgaXQgZGlk
bid0IG1hdHRlciBmb3IgdGhlCj4+IGFyY2hpdGVjdHVyZXMgeW91IHdhbnQgdG8gc3VwcG9ydC4K
Pgo+IFRydWUsIGl0IHdhcyBhIGZsZWV0aW5nIHRob3VnaHQsIGJ1dCBub3Qgc29tZXRoaW5nIEkg
Y29uc2lkZXJlZAo+IGZsZXNoaW5nIG91dC4uLiBJJ2xsIHNlbmQgYSByZXZpc2lvbi4KClRoYW5r
cy4KCj4+IHg4NiBpcywgb2YgY291cnNlLCBzYWZlLiAgSSBiZWxpZXZlIGFhcmNoNjQgaXMsIGFz
IHdlbGwuICBJIGRpZG4ndCBsb29rCj4+IGludG8gb3RoZXJzLgo+Pgo+IEtlZXAgaW4gbWluZCB0
aGF0IHRoaXMgY29kZSBpcyBmb3IgaW50ZXJmYWNpbmcgd2l0aCB0aGUgQUNQSSBEU00gcGF0aC4K
PiBJZiBhbiB1bmFsaWduZWQtaW5jYXBhYmxlIGFyY2hpdGVjdHVyZSBkZWZpbmVkIGFuIE5WRElN
TSBjb21tYW5kIHNldAo+IGl0IGlzIGhpZ2hseSB1bmxpa2VseSBpdCB3b3VsZCBiZSBBQ1BJIGJh
c2VkLCBvciBwaWNrIHRoZXNlCj4gcHJvYmxlbWF0aWMgY29tbWFuZCBmb3JtYXRzLiBJIGNhbiBh
ZGQgdGhlc2Ugbm90ZXMgdG8gdGhlIGNoYW5nZWxvZywKPiBidXQgdGhlIHVuZm9ydHVuYXRlIGRl
ZmluaXRpb24gb2YgdGhlc2UgcGF5bG9hZHMgdGhhdCByZXF1aXJlIF9fcGFja2VkCj4gaXMgc29t
ZXRoaW5nIEkgaG9wZSBvdGhlciBhcmNoaXRlY3R1cmVzIGF2b2lkLgoKV2UgY2FuIGhvcGUuLi4g
IDopIEFueXdheSwgdGhhbmtzIGZvciB0aGUgYWRkaXRpb25hbCBjb250ZXh0LgoKQ2hlZXJzLApK
ZWZmCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4
LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xp
c3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
