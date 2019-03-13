Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F285420081A62
 for <linux-nvdimm@lists.01.org>; Wed, 13 Mar 2019 09:07:26 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id b3so2240152otp.4
 for <linux-nvdimm@lists.01.org>; Wed, 13 Mar 2019 09:07:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190228083522.8189-1-aneesh.kumar@linux.ibm.com>
 <20190228083522.8189-2-aneesh.kumar@linux.ibm.com>
 <CAOSf1CHjkyX2NTex7dc1AEHXSDcWA_UGYX8NoSyHpb5s_RkwXQ@mail.gmail.com>
 <CAPcyv4jhEvijybSVsy+wmvgqfvyxfePQ3PUqy1hhmVmPtJTyqQ@mail.gmail.com>
 <87k1hc8iqa.fsf@linux.ibm.com> <20190306124453.126d36d8@naga.suse.cz>
 <df01bf6e-84a1-53fb-bf0c-0957af2f79e1@linux.ibm.com>
In-Reply-To: <df01bf6e-84a1-53fb-bf0c-0957af2f79e1@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 13 Mar 2019 09:07:13 -0700
Message-ID: <CAPcyv4iLm09DSiF3niFprP3PTFrgB5pZPp9AysBpRa-m725tmw@mail.gmail.com>
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Ross Zwisler <zwisler@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCBNYXIgNiwgMjAxOSBhdCA0OjQ2IEFNIEFuZWVzaCBLdW1hciBLLlYKPGFuZWVzaC5r
dW1hckBsaW51eC5pYm0uY29tPiB3cm90ZToKPgo+IE9uIDMvNi8xOSA1OjE0IFBNLCBNaWNoYWwg
U3VjaMOhbmVrIHdyb3RlOgo+ID4gT24gV2VkLCAwNiBNYXIgMjAxOSAxNDo0NzozMyArMDUzMAo+
ID4gIkFuZWVzaCBLdW1hciBLLlYiIDxhbmVlc2gua3VtYXJAbGludXguaWJtLmNvbT4gd3JvdGU6
Cj4gPgo+ID4+IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNAaW50ZWwuY29tPiB3cml0ZXM6
Cj4gPj4KPiA+Pj4gT24gVGh1LCBGZWIgMjgsIDIwMTkgYXQgMTo0MCBBTSBPbGl2ZXIgPG9vaGFs
bEBnbWFpbC5jb20+IHdyb3RlOgo+ID4+Pj4KPiA+Pj4+IE9uIFRodSwgRmViIDI4LCAyMDE5IGF0
IDc6MzUgUE0gQW5lZXNoIEt1bWFyIEsuVgo+ID4+Pj4gPGFuZWVzaC5rdW1hckBsaW51eC5pYm0u
Y29tPiB3cm90ZToKPiA+Cj4gPj4gQWxzbyBldmVuIGlmIHRoZSB1c2VyIGRlY2lkZWQgdG8gbm90
IHVzZSBUSFAsIGJ5Cj4gPj4gZWNobyAibmV2ZXIiID4gdHJhbnNwYXJlbnRfaHVnZXBhZ2UvZW5h
YmxlZCAsIHdlIHNob3VsZCBjb250aW51ZSB0byBtYXAKPiA+PiBkYXggZmF1bHQgdXNpbmcgaHVn
ZSBwYWdlIG9uIHBsYXRmb3JtcyB0aGF0IGNhbiBzdXBwb3J0IGh1Z2UgcGFnZXMuCj4gPgo+ID4g
SXMgdGhpcyBhIGdvb2QgaWRlYT8KPiA+Cj4gPiBUaGlzIGtub2IgaXMgdGhlcmUgZm9yIGEgcmVh
c29uLiBJbiBzb21lIHNpdHVhdGlvbnMgaGF2aW5nIGh1Z2UgcGFnZXMKPiA+IGNhbiBzZXZlcmVs
eSBpbXBhY3QgcGVyZm9ybWFuY2Ugb2YgdGhlIHN5c3RlbSAoZHVlIHRvIGhvc3QtZ3Vlc3QKPiA+
IGludGVyYWN0aW9uIG9yIHdoYXRldmVyKSBhbmQgdGhlIGFiaWxpdHkgdG8gcmVhbGx5IHR1cm4g
b2ZmIGFsbCBUSFAKPiA+IHdvdWxkIGJlIGltcG9ydGFudCBpbiB0aG9zZSBjYXNlcywgcmlnaHQ/
Cj4gPgo+Cj4gTXkgdW5kZXJzdGFuZGluZyB3YXMgdGhhdCBpcyBub3QgdHJ1ZSBmb3IgZGF4IHBh
Z2VzPyBUaGVzZSBhcmUgbm90Cj4gcmVndWxhciBtZW1vcnkgdGhhdCBnb3QgYWxsb2NhdGVkLiBU
aGV5IGFyZSBhbGxvY2F0ZWQgb3V0IG9mIC9kZXYvZGF4Lwo+IG9yIC9kZXYvcG1lbSouIERvIHdl
IGhhdmUgYSByZWFzb24gbm90IHRvIHVzZSBodWdlcGFnZXMgZm9yIG1hcHBpbmcKPiBwYWdlcyBp
biB0aGF0IGNhc2U/CgpUaGUgcHJvYmxlbSB3aXRoIHRoZSB0cmFuc3BhcmVudF9odWdlcGFnZS9l
bmFibGVkIGludGVyZmFjZSBpcyB0aGF0IGl0CmNvbmZsYXRlcyBwZXJmb3JtaW5nIGNvbXBhY3Rp
b24gd29yayB0byBwcm9kdWNlIFRIUC1wYWdlcyB3aXRoIHRoZQphYmlsaXR5IHRvIG1hcCBodWdl
IHBhZ2VzIGF0IGFsbC4gVGhlIGNvbXBhY3Rpb24gaXMgYSBub3AgZm9yIGRheApiZWNhdXNlIHRo
ZSBtZW1vcnkgaXMgYWxyZWFkeSBzdGF0aWNhbGx5IGFsbG9jYXRlZC4gSWYgdGhlCmFkbWluaXN0
cmF0b3IgZG9lcyBub3Qgd2FudCBkYXggdG8gY29uc3VtZSBodWdlIFRMQiBlbnRyaWVzIHRoZW4g
ZG9uJ3QKY29uZmlndXJlIGh1Z2UtcGFnZSBkYXguIElmIGEgaHlwZXJ2aXNvciB3YW50cyB0byBm
b3JjZSBkaXNhYmxlCmh1Z2UtcGFnZS1jb25maWd1cmVkIGRldmljZS1kYXggaW5zdGFuY2VzIGFm
dGVyIHRoZSBmYWN0IGl0IHNlZW1zIHdlCm5lZWQgYW4gZXhwbGljaXQgaW50ZXJmYWNlIGZvciB0
aGF0IGFuZCBub3Qgb3ZlcmxvYWQKdHJhbnNwYXJlbnRfaHVnZXBhZ2UvZW5hYmxlZC4KX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1h
aWxpbmcgbGlzdApMaW51eC1udmRpbW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3Jn
L21haWxtYW4vbGlzdGluZm8vbGludXgtbnZkaW1tCg==
