Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D3672007E7E2
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 21:00:38 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id v2-v6so11758639oif.3
 for <linux-nvdimm@lists.01.org>; Tue, 01 May 2018 21:00:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+55aFy2LAzRbjCEghN_7SAZgAOr0RoUFDwYkkB+V91jdTg-YA@mail.gmail.com>
References: <152520750404.36522.15462513519590065300.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFwoOee_8H-1KRnY1G-Ud4Rez16s8xjVbG8YOPn1jqxxtg@mail.gmail.com>
 <CAPcyv4jA98NVNqYFpj29OHE45HVp1DMH9oFO4-neWKA_4WKTwA@mail.gmail.com>
 <CA+55aFwZ3hrrOJ5W-C8gdam3aGNxz8FEAq9gPnRBkVmwu4BvYA@mail.gmail.com>
 <CAPcyv4i=cjQr9xvxt+Mjp-fhzyNJdTTp7uaAtpJN9R4gPg_j-Q@mail.gmail.com>
 <CA+55aFyZXWoiWnEU8S1PNNyUTWsi7UCnBuDKOobfMLaE8uFKJg@mail.gmail.com>
 <CAPcyv4jTUn2gSPSB1r7p9A7VNxBf54Aa5dnGbGsomDqmbvsHLQ@mail.gmail.com>
 <CA+55aFzDt1uvDBqgkB0T2o2-d5Fi0tBiGcy5iAZ-wRNdAL4uQw@mail.gmail.com>
 <CAPcyv4hQVKL=OtoYbWDGfOMdWen3MkF5qBPrek98+w2gODHvtg@mail.gmail.com>
 <CAPcyv4ixtVC3w9BE3Z2ME-qMPCh9evBKP51SDrNPXAsg7xH1RQ@mail.gmail.com>
 <CA+55aFy2LAzRbjCEghN_7SAZgAOr0RoUFDwYkkB+V91jdTg-YA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 May 2018 21:00:37 -0700
Message-ID: <CAPcyv4idV+hp-W56gyQDN4p9SQsYz+xondgVJwQSYphUMxkYnw@mail.gmail.com>
Subject: Re: [PATCH 0/6] use memcpy_mcsafe() for copy_to_iter()
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 1, 2018 at 8:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, May 1, 2018 at 8:22 PM Dan Williams <dan.j.williams@intel.com>
> wrote:
>
>> All that to say that having a typical RAM page covering poisoned pmem
>> would complicate the 'clear badblocks' implementation.
>
> Ugh, ok.
>
> I guess the good news is that your patches aren't so big, and don't really
> affect anything else.
>
> But can we at least take this to be the impetus for just getting rid of
> that disgusting unrolled memcpy? Ablout half of the lines in the patch set
> comes from that thing.
>
> Is anybody seriously going to use pmem with some in-order chip that can't
> even get something as simple as a memory copy loop right? "git blame"
> fingers Tony Luck, I think he may have been influenced by the fumes from
> Itanium.
>
> I  have some dim memory of "rep movs doesn't work well for pmem", but does
> it *seriously* need unrolling to cacheline boundaries? And if it does, who
> designed it, and why is anybody using it?
>

I think this is an FAQ from the original submission, in fact some guy
named "Linus Torvalds" asked [1]:

---

>  - why does this use the complex - and slower, on modern machines -
> unrolled manual memory copy, when you might as well just use a single
>
>      rep ; movsb
>
>     which not only makes it smaller, but makes the exception fixup trivial.

Because current generation cpus don't give a recoverable machine
check if we consume with a "rep ; movsb" :-(
When we have that we can pick the best copy function based
on the capabilities of the cpu we are running on.

---

[1]: https://lkml.org/lkml/2016/2/18/608
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
