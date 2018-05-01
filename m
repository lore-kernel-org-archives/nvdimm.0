Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 81DCB2007E7EE
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 16:28:22 -0700 (PDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 05DED2370A
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 23:28:22 +0000 (UTC)
Received: by mail-wm0-f48.google.com with SMTP id i3so21138692wmf.3
 for <linux-nvdimm@lists.01.org>; Tue, 01 May 2018 16:28:21 -0700 (PDT)
MIME-Version: 1.0
References: <152520750404.36522.15462513519590065300.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CA+55aFwoOee_8H-1KRnY1G-Ud4Rez16s8xjVbG8YOPn1jqxxtg@mail.gmail.com>
 <CAPcyv4jA98NVNqYFpj29OHE45HVp1DMH9oFO4-neWKA_4WKTwA@mail.gmail.com>
In-Reply-To: <CAPcyv4jA98NVNqYFpj29OHE45HVp1DMH9oFO4-neWKA_4WKTwA@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 01 May 2018 23:28:10 +0000
Message-ID: <CALCETrV=HtQDfrKmY0Td2GfxAxZbAoz71JbYSZcq0LxL2A-RqQ@mail.gmail.com>
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
Cc: Tony Luck <tony.luck@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 1, 2018 at 4:02 PM Dan Williams <dan.j.williams@intel.com>
wrote:

> On Tue, May 1, 2018 at 2:05 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Tue, May 1, 2018 at 1:55 PM Dan Williams <dan.j.williams@intel.com>
> > wrote:
> >
> >> The result of the bypass is that the kernel treats machine checks
during
> >> read as system fatal (reboot) when they could simply be flagged as an
> >> I/O error, similar to performing reads through the pmem driver. Prevent
> >> this fatal condition by deploying memcpy_mcsafe() in the fsdax read
> >> path.
> >
> > How about just changing the rules, and go the old "Don't do that then"
way?
> >
> > IOW, get rid of the whole idea that MCS errors should be fatal. It's
wrong
> > and pointless anyway.
> >
> > The while approach seems fundamentally buggered, if you ever want to
mmap
> > one of these things. And don't you want that?
> >
> > So why continue down a fundamentally broken path?

> I'm confused. Are you talking about getting rid of the block-layer
> bypass or changing how MCS errors are handled? If it's the former I've
> gotten push back in the past trying to remove the bypass, but I feel
> better about my chances to slay that beast wielding the +5 Hammer of
> Linus. If it's the latter, MCS error handling, I don't see how get
> around something like copy_to_iter_mcsafe().

> You mention mmap. Yes, we want the predominant access model to be
> dax-mmap for Persistent Memory, but there's still the question about
> what to do with media errors. To date we are trying to mirror the
> error handling model for System Memory, i.e. SIGBUS to the process
> that consumed the error. Is that error handling model also problematic
> in your view?

I'm not sure exactly what you mean here, but my understanding of the status
quo is that memory errors in user code are non-fatal but that memory errors
in kernel code are fatal unless there's an appropriate extable entry.  The
old iov_iter code assumes that memcpy() on kernel addresses can't fail.
I'm not sure how else it could work.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
