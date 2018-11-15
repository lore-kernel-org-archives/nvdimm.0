Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vs1-f67.google.com (mail-vs1-f67.google.com
 [209.85.217.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 685AF21191725
 for <linux-nvdimm@lists.01.org>; Wed, 14 Nov 2018 23:59:56 -0800 (PST)
Received: by mail-vs1-f67.google.com with SMTP id t17so11154500vsc.8
 for <linux-nvdimm@lists.01.org>; Wed, 14 Nov 2018 23:59:56 -0800 (PST)
MIME-Version: 1.0
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225760492.2499188.14152986544451112930.stgit@dwillia2-desk3.amr.corp.intel.com>
 <alpine.DEB.2.21.1811142146230.9620@hadrien>
In-Reply-To: <alpine.DEB.2.21.1811142146230.9620@hadrien>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 15 Nov 2018 08:59:43 +0100
Message-ID: <CAMuHMdVmvCOX6gF0BskQ1NBUpdMZHSBQXpxkx085B9ZKGm0wiA@mail.gmail.com>
Subject: Re: [Ksummit-discuss] [RFC PATCH 2/3] MAINTAINERS, Handbook:
 Subsystem Profile
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
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: ksummit-discuss@lists.linuxfoundation.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Greg KH <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, stfrench@microsoft.com, "Tobin C. Harding" <me@tobin.cc>
List-ID: <linux-nvdimm@lists.01.org>

Hi Julia,

On Thu, Nov 15, 2018 at 6:48 AM Julia Lawall <julia.lawall@lip6.fr> wrote:
> On Wed, 14 Nov 2018, Dan Williams wrote:
> > As presented at the 2018 Linux Plumbers conference [1], the Subsystem
> > Profile is proposed as a way to reduce friction between committers and
> > maintainers and perhaps encourage conversations amongst maintainers
> > about best practice policies.
> >
> > The profile contains short answers to some of the common policy
> > questions a contributor might have, or that a maintainer might consider
> > formalizing. The current list of maintenance policies is:
> >
> > Overview: General introduction to maintaining the subsystem
> > Core: List of source files considered core
> > Leaf: List of source files that consume core functionality
> > Patches or Pull requests: Simple statement of expected submission format
> > Last -rc for new feature submissions: Expected lead time for submissions
> > Last -rc to merge features: Deadline for merge decisions
> > Non-author Ack / Review Tags Required: Patch review economics
> > Test Suite: Pass this suite before requesting inclusion
> > Resubmit Cadence: When to ping the maintainer
> > Trusted Reviewers: Help for triaging patches
> > Time Zone / Office Hours: When might a maintainer be available
> > Checkpatch / Style Cleanups: Policy on pure cleanup patches
> > Off-list review: Request for review gates
> > TODO: Potential development tasks up for grabs, or active focus areas
>
> How about patch subject lines?  What is the formula that should be used to
> transform the name(s) of the affected file(s) into an appropriate suject
> line?

Automating that may be difficult.
I always use "git log --oneline", and try to derive something sane
from its output.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
