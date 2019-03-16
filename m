Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF594211D6729
 for <linux-nvdimm@lists.01.org>; Fri, 15 Mar 2019 18:20:06 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id j132so5836643oib.2
 for <linux-nvdimm@lists.01.org>; Fri, 15 Mar 2019 18:20:06 -0700 (PDT)
MIME-Version: 1.0
References: <54fb48ed-f681-1420-b2d0-082ed14802a7@inria.fr>
 <CAPcyv4g0KCON5KfTyeoK3UWApD=Gg=-eg=9Cc0OR-QcArXKMFA@mail.gmail.com>
 <f1374ac6-5007-8ac9-782d-d0615feb3b09@inria.fr>
In-Reply-To: <f1374ac6-5007-8ac9-782d-d0615feb3b09@inria.fr>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Mar 2019 18:19:54 -0700
Message-ID: <CAPcyv4ivcUmiPSgS-27iB2dv455n64nmeSMh690QjYUTLmG1ow@mail.gmail.com>
Subject: Re: failure to setup devdax over fake nvdimm
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
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gRnJpLCBNYXIgMTUsIDIwMTkgYXQgNDo0MiBQTSBCcmljZSBHb2dsaW4gPEJyaWNlLkdvZ2xp
bkBpbnJpYS5mcj4gd3JvdGU6Cj4KPgo+IExlIDE2LzAzLzIwMTkgw6AgMDA6MTIsIERhbiBXaWxs
aWFtcyBhIMOpY3JpdCA6Cj4gPiBPbiBGcmksIE1hciAxNSwgMjAxOSBhdCAzOjMxIFBNIEJyaWNl
IEdvZ2xpbiA8QnJpY2UuR29nbGluQGlucmlhLmZyPiB3cm90ZToKPiA+PiBIZWxsbyBEYW4sCj4g
Pj4KPiA+PiBPbiBhIG1hY2hpbmUgZW11bGF0aW5nIG52ZGltbXMgb3ZlciBERFIgdXNpbmcgdGhl
IG1lbW1hcCBrZXJuZWwgcGFyYW1ldGVyLAo+ID4+IEkgY2FuJ3QgZW5hYmxlIGRldmRheCBhbnlt
b3JlIHdpdGggbmRjdGwsIHdoZW4gdXNpbmcgeW91ciBsaWJudmRpbW0tcGVuZGluZwo+ID4+IGJy
YW5jaCAoMWZmYzY2NGY5YjhjYTczNDZmMmFmMGZiNGY2MmI5MjMxOTNiZjY1Yyk6Cj4gPj4KPiA+
PiAjIG5kY3RsIGNyZWF0ZS1uYW1lc3BhY2UgLWYgLWUgbmFtZXNwYWNlMS4wIC10IHBtZW0gLW0g
ZGV2ZGF4Cj4gPj4gbGlibmRjdGw6IG5kY3RsX2RheF9lbmFibGU6IGRheDEuMDogZmFpbGVkIHRv
IGVuYWJsZQo+ID4+ICAgRXJyb3I6IG5hbWVzcGFjZTEuMDogZmFpbGVkIHRvIGVuYWJsZQo+ID4+
IGZhaWxlZCB0byByZWNvbmZpZ3VyZSBuYW1lc3BhY2U6IE5vIHN1Y2ggZGV2aWNlIG9yIGFkZHJl
c3MKPiA+Pgo+ID4+IEluIHRoZSBwcmV2aW91cyB2ZXJzaW9uIG9mIHlvdXIgbGlibnZkaW1tLXBl
bmRpbmcgYnJhbmNoIHRoYXQgSSB1c2VkIGJlZm9yZQo+ID4+ICg4ZDRhN2UzZGE2OGU4OGE2ZWZk
M2FjYjVjYzk3MWQwYzJjYTIxOWE0IGZyb20gSmFudWFyeSA4dGgpIHRoaXMgbmRjdGwgbGluZQo+
ID4+IHdvcmtlZCBmaW5lIHJpZ2h0IGFmdGVyIGJvb3QuCj4gPj4KPiA+PiBUaGUgZGlmZmVyZW5j
ZSBiZXR3ZWVuIHN0cmFjZSBuZGN0bCBkb2Vzbid0IHNob3cgYW55dGhpbmcgb2J2aW91cy4KPiA+
PiAqIC9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9lODIwX3BtZW0vbmRidXMwL3JlZ2lvbjEvbmFtZXNw
YWNlMS4wL2hvbGRlcl9jbGFzcyBjb250YWlucyBub3RoaW5nIGluc3RlYWQgb2YgImRheCIKPiA+
PiAqIC9zeXMvZGV2aWNlcy9wbGF0Zm9ybS9lODIwX3BtZW0vbmRidXMwL3JlZ2lvbjEvZGF4X3Nl
ZWQgY29udGFpbnMgZGF4MS4wIGluc3RlYWQgb2YgZGF4MS4xCj4gPj4KPiA+PiBBbnkgaWRlYSB3
aGVyZSB0byBsb29rPwo+ID4gSWYgbXkgbGlibnZkaW1tLXBlbmRpbmcgYnJhbmNoIHdvcmtlZCBp
dCBpcyBsaWtlbHkgZHVlIHRvIHRoZQo+ID4gYWxpZ25tZW50IHBhZGRpbmcgZml4ZXMgSSBoYWQg
cGVuZGluZyB0aGVyZS4gQ2FuIHlvdSBwb3N0IHRoZSBkbWVzZwo+ID4gZnJvbSB0aGlzIGZhaWx1
cmU/Cj4gPgo+ID4gVGhlIGFsaWdubWVudCBwYWRkaW5nIGZpeGVzIGFyZSBiZWluZyBhYmFuZG9u
ZWQgaW4gZmF2b3Igb2YganVzdAo+ID4gdGVhY2hpbmcgdGhlIGNvcmUtbW0gdG8gbm90IHJlcXVp
cmUgc2VjdGlvbiAoMTI4TUIpIGFsaWdubWVudCwgYnV0Cj4gPiB1bnRpbCB0aGVuIHlvdSBuZWVk
IHRvIG1ha2Ugc3VyZSB5b3VyIHBlcnNpc3RlbnQgbWVtb3J5IGlzIDEyOE1CCj4gPiBhbGlnbmVk
Lgo+Cj4gSSBhbSBwYXNzaW5nIG1lbW1hcD0yNEchN0cgbWVtbWFwPTI0RyEzOUcgdG8gdGhlIGtl
cm5lbCBjb21tYW5kLWxpbmUuCj4gSXQgbG9va3MgcHJvcGVybHkgYWxpZ25lZC4KPgo+IGRtZXNn
IGlzIGJlbG93LiBOb3RoaW5nIGFwcGVhcnMgd2hlbiBuZGN0bCBmYWlscy4KCkhtbSwgb2suIENh
biB5b3UgYm9vdCB3aXRoIGxpYm52ZGltbS5keW5kYmcgYW5kIHNlZSBpZiBpdCBzcXVhd2tzCmFi
b3V0IHRoZSBwcm9ibGVtPyBJZiB0aGlzIGlzIDFmZmM2NjRmOWI4YyB0aGVuIHlvdSBuZWVkIHRv
IGhhdmUgdGhlCmRheF9wbWVtX2NvbXBhdCBkcml2ZXIgb3IgdGhlIGRheF9wbWVtIGRyaXZlciB0
byBhdHRhY2gsIGFuZCB0aGlzIGFsc28Kd29uJ3Qgd29yayBpZiB5b3UndmUgaG90cGx1Z2dlZCBp
dCB3aXRoIHRoZSBrbWVtIGRyaXZlci4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlz
dHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtbnZk
aW1tCg==
