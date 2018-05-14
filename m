Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x22d.google.com (mail-pl0-x22d.google.com
 [IPv6:2607:f8b0:400e:c01::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 034D020969646
 for <linux-nvdimm@lists.01.org>; Mon, 14 May 2018 10:53:53 -0700 (PDT)
Received: by mail-pl0-x22d.google.com with SMTP id c11-v6so7807682plr.5
 for <linux-nvdimm@lists.01.org>; Mon, 14 May 2018 10:53:53 -0700 (PDT)
Mime-Version: 1.0 (1.0)
Subject: Re: use memcpy_mcsafe() for copy_to_iter() (was: Re: [PATCH v3 0/9]
 Series short description)
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <CAPcyv4j2HQH1wdsGGWUAiXEKXeoMUWN_HeUEMmkv8PG7RUTtfw@mail.gmail.com>
Date: Mon, 14 May 2018 10:53:51 -0700
Message-Id: <3CEE65FC-2314-4837-9854-80E73ECBF0EE@amacapital.net>
References: <CAPcyv4g5p72aiXYh8Tf03tvZq8HNYmTFU95PJGG1iQ4JHcr9PA@mail.gmail.com>
 <20180514072603.GA14099@gmail.com>
 <CAPcyv4j2HQH1wdsGGWUAiXEKXeoMUWN_HeUEMmkv8PG7RUTtfw@mail.gmail.com>
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
Cc: "Luck, Tony" <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, =?utf-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

Cgo+IE9uIE1heSAxNCwgMjAxOCwgYXQgODo1MiBBTSwgRGFuIFdpbGxpYW1zIDxkYW4uai53aWxs
aWFtc0BpbnRlbC5jb20+IHdyb3RlOgo+IAoKPiAKPiBJIHRoaW5rICJoYXBweSIgaXMgYSBzdHJv
bmcgd29yZCB3aGVuIGl0IGNvbWVzIHRvIHg4NiBtYWNoaW5lIGNoZWNrCj4gaGFuZGxpbmcuIE15
IGludGVycHJldGF0aW9uIGlzIHRoYXQgaGUgYW5kIEFuZHkgYWNxdWllc2NlZCB0aGF0IHRoaXMK
PiBpcyBhYm91dCB0aGUgYmVzdCB3ZSBjYW4gZG8gd2l0aCBkYXgrbWNlIGFzIHRoaW5ncyBzdGFu
ZCB0b2RheS4KCgpBZ3JlZWQuIEkgdGhpbmsgaXTigJlzIHBsYXVzaWJsZSB0aGF0IHdlIGNvdWxk
IGRvIHNsaWdodGx5IGJldHRlciBmb3IgTUNFcyByZWxhdGVkIHRvIGJhZCBtZW1vcnkgYWNjZXNz
ZWQgdGhyb3VnaCB0aGUgZGlyZWN0IG1hcCwgYnV0IHRoZSBjb2RlIHdvdWxkIGJlIGNvbXBsaWNh
dGVkIGFuZCBtaXNlcmFibGUgdG8gdGVzdCwgYW5kIGl04oCZcyBub3QgZXZlbiBjbGVhciB0aGF0
IGl0IHdvdWxkIG1hdGVyaWFsbHkgZGVjcmVhc2UgdGhlIGNoYW5jZSB0aGF0IHdlIHN1cnZpdmUg
YXMgY29tcGFyZWQgdG8gdGhlc2UgcGF0Y2hlcy4KX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18KTGludXgtbnZkaW1tIG1haWxpbmcgbGlzdApMaW51eC1udmRp
bW1AbGlzdHMuMDEub3JnCmh0dHBzOi8vbGlzdHMuMDEub3JnL21haWxtYW4vbGlzdGluZm8vbGlu
dXgtbnZkaW1tCg==
