Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail2-relais-roc.national.inria.fr
 (mail2-relais-roc.national.inria.fr [192.134.164.83])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E2E12117FD54
 for <linux-nvdimm@lists.01.org>; Thu, 15 Nov 2018 05:48:02 -0800 (PST)
Date: Thu, 15 Nov 2018 05:47:35 -0800 (PST)
From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [Ksummit-discuss] [RFC PATCH 2/3] MAINTAINERS, Handbook: Subsystem
 Profile
In-Reply-To: <CAMuHMdVmvCOX6gF0BskQ1NBUpdMZHSBQXpxkx085B9ZKGm0wiA@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.1811150544090.2354@hadrien>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225760492.2499188.14152986544451112930.stgit@dwillia2-desk3.amr.corp.intel.com>
 <alpine.DEB.2.21.1811142146230.9620@hadrien>
 <CAMuHMdVmvCOX6gF0BskQ1NBUpdMZHSBQXpxkx085B9ZKGm0wiA@mail.gmail.com>
MIME-Version: 1.0
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
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: ksummit-discuss@lists.linuxfoundation.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, Dmitry Vyukov <dvyukov@google.com>, Greg KH <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, stfrench@microsoft.com, "Tobin C. Harding" <me@tobin.cc>
List-ID: <linux-nvdimm@lists.01.org>



On Thu, 15 Nov 2018, Geert Uytterhoeven wrote:

> Hi Julia,
>
> On Thu, Nov 15, 2018 at 6:48 AM Julia Lawall <julia.lawall@lip6.fr> wrote:
> > On Wed, 14 Nov 2018, Dan Williams wrote:
> > > As presented at the 2018 Linux Plumbers conference [1], the Subsystem
> > > Profile is proposed as a way to reduce friction between committers and
> > > maintainers and perhaps encourage conversations amongst maintainers
> > > about best practice policies.
> > >
> > > The profile contains short answers to some of the common policy
> > > questions a contributor might have, or that a maintainer might consider
> > > formalizing. The current list of maintenance policies is:
> > >
> > > Overview: General introduction to maintaining the subsystem
> > > Core: List of source files considered core
> > > Leaf: List of source files that consume core functionality
> > > Patches or Pull requests: Simple statement of expected submission format
> > > Last -rc for new feature submissions: Expected lead time for submissions
> > > Last -rc to merge features: Deadline for merge decisions
> > > Non-author Ack / Review Tags Required: Patch review economics
> > > Test Suite: Pass this suite before requesting inclusion
> > > Resubmit Cadence: When to ping the maintainer
> > > Trusted Reviewers: Help for triaging patches
> > > Time Zone / Office Hours: When might a maintainer be available
> > > Checkpatch / Style Cleanups: Policy on pure cleanup patches
> > > Off-list review: Request for review gates
> > > TODO: Potential development tasks up for grabs, or active focus areas
> >
> > How about patch subject lines?  What is the formula that should be used to
> > transform the name(s) of the affected file(s) into an appropriate suject
> > line?
>
> Automating that may be difficult.
> I always use "git log --oneline", and try to derive something sane
> from its output.

Yes, I do likewise.  But there may be some subsystems for which it would
be possible to come up with a more specific policy.  The advantage of what
is proposed here is that it is not necessary to come up with a single
formula that works everywhere.  Even a description in English could be
helpful.

Other subsystem specific properties such as what tree to work on, whether
to CC stable, ordering of variables or header files, etc could also be
useful to mention.  Anything that will cause a maintainer to immediately
reject a patch for syntactic reasons.

julia
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
