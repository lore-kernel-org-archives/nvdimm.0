Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E14C82063E318
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 07:19:25 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id a6-v6so16217424oia.2
 for <linux-nvdimm@lists.01.org>; Thu, 03 May 2018 07:19:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69d19601-df56-687d-730e-d043b2cf7161@nextfour.com>
References: <152532351517.17218.3583455156840230837.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152532354268.17218.11923624861859552990.stgit@dwillia2-desk3.amr.corp.intel.com>
 <69d19601-df56-687d-730e-d043b2cf7161@nextfour.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 May 2018 07:19:23 -0700
Message-ID: <CAPcyv4gqu-3w+nPrfYPWxWQYOPrHaNzsr=0YSe562Ns-Ygz4bQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/9] x86,
 memcpy_mcsafe: add write-protection-fault handling
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
To: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

T24gV2VkLCBNYXkgMiwgMjAxOCBhdCAxMDoyOSBQTSwgTWlrYSBQZW50dGlsw6QKPG1pa2EucGVu
dHRpbGFAbmV4dGZvdXIuY29tPiB3cm90ZToKPiBPbiAwNS8wMy8yMDE4IDA3OjU5IEFNLCBEYW4g
V2lsbGlhbXMgd3JvdGU6Cj4+IEluIHByZXBhcmF0aW9uIGZvciB1c2luZyBtZW1jcHlfbWNzYWZl
KCkgdG8gaGFuZGxlIHVzZXIgY29waWVzIGl0IG5lZWRzCj4+IHRvIGJlIHRvIGhhbmRsZSB3cml0
ZS1wcm90ZWN0aW9uIGZhdWx0cyB3aGlsZSB3cml0aW5nIHVzZXIgcGFnZXMuIEFkZAo+PiBNTVUt
ZmF1bHQgaGFuZGxlcnMgYWxvbmdzaWRlIHRoZSBtYWNoaW5lLWNoZWNrIGV4Y2VwdGlvbiBoYW5k
bGVycy4KPj4KPj4gTm90ZSB0aGF0IHRoZSBtYWNoaW5lIGNoZWNrIGZhdWx0IGV4Y2VwdGlvbiBo
YW5kbGluZyBtYWtlcyBhc3N1bXB0aW9ucwo+PiBhYm91dCBzb3VyY2UgYnVmZmVyIGFsaWdubWVu
dCBhbmQgcG9pc29uIGFsaWdubWVudC4gSW4gdGhlIHdyaXRlIGZhdWx0Cj4+IGNhc2UsIGdpdmVu
IHRoZSBkZXN0aW5hdGlvbiBidWZmZXIgaXMgYXJiaXRyYXJpbHkgYWxpZ25lZCwgaXQgbmVlZHMg
YQo+PiBzZXBhcmF0ZSAvIGFkZGl0aW9uYWwgZmF1bHQgaGFuZGxpbmcgYXBwcm9hY2guIFRoZSBt
Y3NhZmVfaGFuZGxlX3RhaWwoKQo+PiBoZWxwZXIgaXMgcmV1c2VkLiBUaGUgQGxpbWl0IGFyZ3Vt
ZW50IGlzIHNldCB0byBAbGVuIHNpbmNlIHRoZXJlIGlzIG5vCj4+IHNhZmV0eSBjb25jZXJuIGFi
b3V0IHJldHJpZ2dlcmluZyBhbiBNTVUgZmF1bHQsIGFuZCB0aGlzIHNpbXBsaWZpZXMgdGhlCj4+
IGFzc2VtYmx5Lgo+Pgo+Cj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9saWIvdXNlcmNvcHlfNjQu
YyBiL2FyY2gveDg2L2xpYi91c2VyY29weV82NC5jCj4+IGluZGV4IDc1ZDM3NzYxMjNjYy4uOTc4
N2Y1ZWUwY2Y5IDEwMDY0NAo+PiAtLS0gYS9hcmNoL3g4Ni9saWIvdXNlcmNvcHlfNjQuYwo+PiAr
KysgYi9hcmNoL3g4Ni9saWIvdXNlcmNvcHlfNjQuYwo+PiBAQCAtNzUsNiArNzUsMjMgQEAgY29w
eV91c2VyX2hhbmRsZV90YWlsKGNoYXIgKnRvLCBjaGFyICpmcm9tLCB1bnNpZ25lZCBsZW4pCj4+
ICAgICAgIHJldHVybiBsZW47Cj4+ICB9Cj4+Cj4+ICsvKgo+PiArICogU2ltaWxhciB0byBjb3B5
X3VzZXJfaGFuZGxlX3RhaWwsIHByb2JlIGZvciB0aGUgd3JpdGUgZmF1bHQgcG9pbnQsCj4+ICsg
KiBidXQgcmV1c2UgX19tZW1jcHlfbWNzYWZlIGluIGNhc2UgYSBuZXcgcmVhZCBlcnJvciBpcyBl
bmNvdW50ZXJlZC4KPj4gKyAqIGNsYWMoKSBpcyBoYW5kbGVkIGluIF9jb3B5X3RvX2l0ZXJfbWNz
YWZlKCkuCj4+ICsgKi8KPj4gK19fdmlzaWJsZSB1bnNpZ25lZCBsb25nCj4+ICttY3NhZmVfaGFu
ZGxlX3RhaWwoY2hhciAqdG8sIGNoYXIgKmZyb20sIHVuc2lnbmVkIGxlbikKPj4gK3sKPj4gKyAg
ICAgZm9yICg7IGxlbjsgLS1sZW4sIHRvKyspIHsKPj4gKyAgICAgICAgICAgICB1bnNpZ25lZCBs
b25nIHJlbSA9IG1lbWNweV9tY3NhZmUodG8sIGZyb20sIDEpOwo+PiArCj4KPgo+IEhtbSB3aHkg
bm90Cj4gICAgICAgICBmb3IgKDsgbGVuOyAtLWxlbiwgZnJvbSsrLCB0bysrKQo+Cj4KCldoeSBu
b3QgaW5kZWVkLiBHcmVhdCBjYXRjaCwgSSdsbCBmaXggdGhpcyBhbmQgZXh0ZW5kIHRoZSB1bml0
IHRlc3QgdG8KdmVyaWZ5IHRoZSBkYXRhIHRyYW5zZmVyIGFzIHdlbGwuCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkxpbnV4LW52ZGltbSBtYWlsaW5nIGxp
c3QKTGludXgtbnZkaW1tQGxpc3RzLjAxLm9yZwpodHRwczovL2xpc3RzLjAxLm9yZy9tYWlsbWFu
L2xpc3RpbmZvL2xpbnV4LW52ZGltbQo=
