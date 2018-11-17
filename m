Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com
 [IPv6:2607:f8b0:4864:20::742])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F405C21A07A92
 for <linux-nvdimm@lists.01.org>; Sat, 17 Nov 2018 06:12:32 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id d19so42018341qkg.5
 for <linux-nvdimm@lists.01.org>; Sat, 17 Nov 2018 06:12:32 -0800 (PST)
MIME-Version: 1.0
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225760492.2499188.14152986544451112930.stgit@dwillia2-desk3.amr.corp.intel.com>
 <alpine.DEB.2.21.1811142146230.9620@hadrien>
 <CAMuHMdVmvCOX6gF0BskQ1NBUpdMZHSBQXpxkx085B9ZKGm0wiA@mail.gmail.com>
 <alpine.DEB.2.21.1811150544090.2354@hadrien> <878t1tgpk8.fsf@intel.com>
 <f08820b05467cc95cc195a2639595c0274c95d69.camel@perches.com>
In-Reply-To: <f08820b05467cc95cc195a2639595c0274c95d69.camel@perches.com>
From: Rob Herring <robherring2@gmail.com>
Date: Sat, 17 Nov 2018 08:12:18 -0600
Message-ID: <CAL_Jsq+4FbB=wj3L67=KEPb_5e8GinMJaXoB2cW6c23yazeNiw@mail.gmail.com>
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
To: Joe Perches <joe@perches.com>
Cc: ksummit-discuss@lists.linuxfoundation.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Jani Nikula <jani.nikula@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>, Geert Uytterhoeven <geert@linux-m68k.org>, stfrench@microsoft.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, "Tobin C. Harding" <me@tobin.cc>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 16, 2018 at 11:57 AM Joe Perches <joe@perches.com> wrote:
>
> On Fri, 2018-11-16 at 14:44 +0200, Jani Nikula wrote:
> > I quickly cooked up this script to produce the top-5 commit prefixes for
> > the given files over the arbitrary last 200 commits. It'll give you a
> > pretty good idea if you're even close.
> >
> > ---
> > #!/bin/sh
> > # usage: subject-prefix FILE [...]
> > # show top 5 subject prefixes for FILEs
> >
> > git log --format=%s -n 200 -- "$@" |\
> >       grep -v "^Merge " |\

--no-merges in git log can replace this line.

> >       sed 's/\(.*\):.*/\1/' |\
> >       sort | uniq -c | sort -nr | sed 's/ *[0-9]\+ //' |\
> >       head -n 5
> > ---
> >
> > Someone who knows perl could turn that into a checkpatch check: See if
> > the patch subject prefix is one of the top-5 for all files changed by
> > the patch, and ask the user to double check if it isn't. Or some
> > heuristics thereof.
>
> This won't work when a patch contains multiple files
> from different paths, or even multiple files from a
> single driver.

Different paths is often, but not always a sign that patches may need
to be split up. Maybe that is something checkpatch should point out.

> Perhaps it's better to use a generic mechanism like
>
>         basename $(dirname $filename):
>
> with some exceptions and add an override patch subject
> grammar to appropriate various sections of MAINTAINERS.

Perhaps just use the script as a starting point to populate
MAINTAINERS as it may never be that accurate.

> I also think it's better to use a separate script like
> scripts/spdxcheck.py and tie any necessary checkpatch
> use to that script.

Yes, checkpatch is getting pretty unwieldy.

Rob
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
