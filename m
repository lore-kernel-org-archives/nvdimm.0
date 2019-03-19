Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B04BA211E00EF
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 08:36:51 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id t7so18064527otk.8
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 08:36:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190228083522.8189-1-aneesh.kumar@linux.ibm.com>
 <20190228083522.8189-2-aneesh.kumar@linux.ibm.com>
 <CAOSf1CHjkyX2NTex7dc1AEHXSDcWA_UGYX8NoSyHpb5s_RkwXQ@mail.gmail.com>
 <CAPcyv4jhEvijybSVsy+wmvgqfvyxfePQ3PUqy1hhmVmPtJTyqQ@mail.gmail.com>
 <87k1hc8iqa.fsf@linux.ibm.com> <20190306124453.126d36d8@naga.suse.cz>
 <df01bf6e-84a1-53fb-bf0c-0957af2f79e1@linux.ibm.com>
 <CAPcyv4iLm09DSiF3niFprP3PTFrgB5pZPp9AysBpRa-m725tmw@mail.gmail.com>
 <20190319084439.eya2pisiirattuil@kshutemo-mobl1>
In-Reply-To: <20190319084439.eya2pisiirattuil@kshutemo-mobl1>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Mar 2019 08:36:38 -0700
Message-ID: <CAPcyv4jAMAenu-WJ1P9E-q728OVpvcajPxqPrW0+gQg_Jk1+0g@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/dax: Don't enable huge dax mapping by default
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
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Ross Zwisler <zwisler@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gVHVlLCBNYXIgMTksIDIwMTkgYXQgMTo0NSBBTSBLaXJpbGwgQS4gU2h1dGVtb3YgPGtpcmls
bEBzaHV0ZW1vdi5uYW1lPiB3cm90ZToKPgo+IE9uIFdlZCwgTWFyIDEzLCAyMDE5IGF0IDA5OjA3
OjEzQU0gLTA3MDAsIERhbiBXaWxsaWFtcyB3cm90ZToKPiA+IE9uIFdlZCwgTWFyIDYsIDIwMTkg
YXQgNDo0NiBBTSBBbmVlc2ggS3VtYXIgSy5WCj4gPiA8YW5lZXNoLmt1bWFyQGxpbnV4LmlibS5j
b20+IHdyb3RlOgo+ID4gPgo+ID4gPiBPbiAzLzYvMTkgNToxNCBQTSwgTWljaGFsIFN1Y2jDoW5l
ayB3cm90ZToKPiA+ID4gPiBPbiBXZWQsIDA2IE1hciAyMDE5IDE0OjQ3OjMzICswNTMwCj4gPiA+
ID4gIkFuZWVzaCBLdW1hciBLLlYiIDxhbmVlc2gua3VtYXJAbGludXguaWJtLmNvbT4gd3JvdGU6
Cj4gPiA+ID4KPiA+ID4gPj4gRGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+
IHdyaXRlczoKPiA+ID4gPj4KPiA+ID4gPj4+IE9uIFRodSwgRmViIDI4LCAyMDE5IGF0IDE6NDAg
QU0gT2xpdmVyIDxvb2hhbGxAZ21haWwuY29tPiB3cm90ZToKPiA+ID4gPj4+Pgo+ID4gPiA+Pj4+
IE9uIFRodSwgRmViIDI4LCAyMDE5IGF0IDc6MzUgUE0gQW5lZXNoIEt1bWFyIEsuVgo+ID4gPiA+
Pj4+IDxhbmVlc2gua3VtYXJAbGludXguaWJtLmNvbT4gd3JvdGU6Cj4gPiA+ID4KPiA+ID4gPj4g
QWxzbyBldmVuIGlmIHRoZSB1c2VyIGRlY2lkZWQgdG8gbm90IHVzZSBUSFAsIGJ5Cj4gPiA+ID4+
IGVjaG8gIm5ldmVyIiA+IHRyYW5zcGFyZW50X2h1Z2VwYWdlL2VuYWJsZWQgLCB3ZSBzaG91bGQg
Y29udGludWUgdG8gbWFwCj4gPiA+ID4+IGRheCBmYXVsdCB1c2luZyBodWdlIHBhZ2Ugb24gcGxh
dGZvcm1zIHRoYXQgY2FuIHN1cHBvcnQgaHVnZSBwYWdlcy4KPiA+ID4gPgo+ID4gPiA+IElzIHRo
aXMgYSBnb29kIGlkZWE/Cj4gPiA+ID4KPiA+ID4gPiBUaGlzIGtub2IgaXMgdGhlcmUgZm9yIGEg
cmVhc29uLiBJbiBzb21lIHNpdHVhdGlvbnMgaGF2aW5nIGh1Z2UgcGFnZXMKPiA+ID4gPiBjYW4g
c2V2ZXJlbHkgaW1wYWN0IHBlcmZvcm1hbmNlIG9mIHRoZSBzeXN0ZW0gKGR1ZSB0byBob3N0LWd1
ZXN0Cj4gPiA+ID4gaW50ZXJhY3Rpb24gb3Igd2hhdGV2ZXIpIGFuZCB0aGUgYWJpbGl0eSB0byBy
ZWFsbHkgdHVybiBvZmYgYWxsIFRIUAo+ID4gPiA+IHdvdWxkIGJlIGltcG9ydGFudCBpbiB0aG9z
ZSBjYXNlcywgcmlnaHQ/Cj4gPiA+ID4KPiA+ID4KPiA+ID4gTXkgdW5kZXJzdGFuZGluZyB3YXMg
dGhhdCBpcyBub3QgdHJ1ZSBmb3IgZGF4IHBhZ2VzPyBUaGVzZSBhcmUgbm90Cj4gPiA+IHJlZ3Vs
YXIgbWVtb3J5IHRoYXQgZ290IGFsbG9jYXRlZC4gVGhleSBhcmUgYWxsb2NhdGVkIG91dCBvZiAv
ZGV2L2RheC8KPiA+ID4gb3IgL2Rldi9wbWVtKi4gRG8gd2UgaGF2ZSBhIHJlYXNvbiBub3QgdG8g
dXNlIGh1Z2VwYWdlcyBmb3IgbWFwcGluZwo+ID4gPiBwYWdlcyBpbiB0aGF0IGNhc2U/Cj4gPgo+
ID4gVGhlIHByb2JsZW0gd2l0aCB0aGUgdHJhbnNwYXJlbnRfaHVnZXBhZ2UvZW5hYmxlZCBpbnRl
cmZhY2UgaXMgdGhhdCBpdAo+ID4gY29uZmxhdGVzIHBlcmZvcm1pbmcgY29tcGFjdGlvbiB3b3Jr
IHRvIHByb2R1Y2UgVEhQLXBhZ2VzIHdpdGggdGhlCj4gPiBhYmlsaXR5IHRvIG1hcCBodWdlIHBh
Z2VzIGF0IGFsbC4KPgo+IFRoYXQncyBub3QgW2VudGlyZWx5XSB0cnVlLiB0cmFuc3BhcmVudF9o
dWdlcGFnZS9kZWZyYWcgZ2F0ZXMgaGVhdnktZHV0eQo+IGNvbXBhY3Rpb24uIFdlIGRvIG9ubHkg
dmVyeSBsaW1pdGVkIGNvbXBhY3Rpb24gaWYgaXQncyBub3QgYWR2aXNlZCBieQo+IHRyYW5zcGFy
ZW50X2h1Z2VwYWdlL2RlZnJhZy4KPgo+IEkgYmVsaWV2ZSBEQVggaGFzIHRvIHJlc3BlY3QgdHJh
bnNwYXJlbnRfaHVnZXBhZ2UvZW5hYmxlZC4gT3Igbm90Cj4gYWR2ZXJ0aXNlIGl0cyBodWdlIHBh
Z2VzIGFzIFRIUC4gSXQncyBjb25mdXNpbmcgZm9yIHVzZXIuCgpXaGF0IGRvZXMgImFkdmVydGlz
ZSBpdHMgaHVnZSBwYWdlcyBhcyBUSFAiIG1lYW4gaW4gcHJhY3RpY2U/IEkgdGhpbmsKaXQncyBj
b25mdXNpbmcgdGhhdCBEQVgsIGEgZmFjaWxpdHkgdGhhdCBieXBhc3NlcyBTeXN0ZW0gUkFNLCBp
cwphZmZlY3RlZCBieSBhIHRyYW5zcGFyZW50X2h1Z2VwYWdlIGZsYWcgd2hpY2ggaXMgYSBmZWF0
dXJlIGZvcgpjb21iaW5pbmcgU3lzdGVtIFJBTSBwYWdlcyBpbnRvIGxhcmdlciBwYWdlcy4gRm9y
IHRoZSBzYW1lIHJlYXNvbiB0aGF0CnRyYW5zcGFyZW50X2h1Z2VwYWdlIGRvZXMgbm90IGdhdGUg
LyBjb250cm9sIGh1Z2V0bGIgb3BlcmF0aW9uIGlzIHRoZQpzYW1lIHJlYXNvbiB0aGF0IHRyYW5z
cGFyZW50X2h1Z2VwYWdlIHNob3VsZCBub3QgZ2F0ZSAvIGNvbnRyb2wgREFYLiBBCmdsb2JhbCBz
ZXR0aW5nIHRvIGRpc2FibGUgb3Bwb3J0dW5pc3RpYyBsYXJnZSBwYWdlIG1hcHBpbmdzIG9mClN5
c3RlbS1SQU0gbWFrZXMgc2Vuc2UsIGJ1dCBJIGRvbid0IHNlZSB3aHkgdGhhdCBzaG91bGQgcmVh
ZCBvbiBEQVg/Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
CkxpbnV4LW52ZGltbSBtYWlsaW5nIGxpc3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRw
czovL2xpc3RzLjAxLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
