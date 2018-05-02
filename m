Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22c.google.com (mail-io0-x22c.google.com
 [IPv6:2607:f8b0:4001:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C8E9C2007E7E2
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 21:14:53 -0700 (PDT)
Received: by mail-io0-x22c.google.com with SMTP id e12-v6so15930491iob.8
 for <linux-nvdimm@lists.01.org>; Tue, 01 May 2018 21:14:53 -0700 (PDT)
MIME-Version: 1.0
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
 <CAPcyv4idV+hp-W56gyQDN4p9SQsYz+xondgVJwQSYphUMxkYnw@mail.gmail.com>
In-Reply-To: <CAPcyv4idV+hp-W56gyQDN4p9SQsYz+xondgVJwQSYphUMxkYnw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 02 May 2018 04:14:41 +0000
Message-ID: <CA+55aFwjaY6Nv7x0d8BQaSddZwAK7fukrYOHWEG_v2-1JZi5Qg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 1, 2018 at 9:00 PM Dan Williams <dan.j.williams@intel.com>
wrote:
> >
> > I  have some dim memory of "rep movs doesn't work well for pmem", but
does
> > it *seriously* need unrolling to cacheline boundaries? And if it does,
who
> > designed it, and why is anybody using it?
> >

> I think this is an FAQ from the original submission, in fact some guy
> named "Linus Torvalds" asked [1]:

Oh, I already mentioned that  I remembered that "rep movs" didn't work well.

But there's a big gap between "just use 'rep movs' and 'do some cacheline
unrollong'".

Why isn't it just doing a simple word-at-a-time loop and letting the CPU do
the unrolling that it will already do on its own?

I may have gotten that answered too, but there's no comment in the code
about why it's such a disgusting mess, so I've long since forgotten _why_
it's such a disgusting mess.

That loop unrolling _used_ to be "hey, it's simple".

Now it's "Hey, that's truly disgusting", with the separate fault handling
for every single case in the unrolled loop.

Just look at the nasty _ASM_EXTABLE_FAULT() uses and those E_cache_x error
labels, and getting the number rof bytes copied right.

And then ask yourself "what if we didn't unroll that thing 8 times, AND WE
COULD GET RID OF ALL OF THOSE?"

Maybe you already did ask yourself.  But I'm asking because it sure isn't
explained in the code.

             Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
