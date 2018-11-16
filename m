Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtprelay.hostedemail.com (smtprelay0141.hostedemail.com
 [216.40.44.141])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EF22A2115C07D
 for <linux-nvdimm@lists.01.org>; Fri, 16 Nov 2018 09:57:08 -0800 (PST)
Message-ID: <f08820b05467cc95cc195a2639595c0274c95d69.camel@perches.com>
Subject: Re: [Ksummit-discuss] [RFC PATCH 2/3] MAINTAINERS, Handbook:
 Subsystem Profile
From: Joe Perches <joe@perches.com>
Date: Fri, 16 Nov 2018 09:56:59 -0800
In-Reply-To: <878t1tgpk8.fsf@intel.com>
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225760492.2499188.14152986544451112930.stgit@dwillia2-desk3.amr.corp.intel.com>
 <alpine.DEB.2.21.1811142146230.9620@hadrien>
 <CAMuHMdVmvCOX6gF0BskQ1NBUpdMZHSBQXpxkx085B9ZKGm0wiA@mail.gmail.com>
 <alpine.DEB.2.21.1811150544090.2354@hadrien> <878t1tgpk8.fsf@intel.com>
Mime-Version: 1.0
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
To: Jani Nikula <jani.nikula@intel.com>, Julia Lawall <julia.lawall@lip6.fr>, Geert Uytterhoeven <geert@linux-m68k.org>
Cc: ksummit-discuss@lists.linuxfoundation.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Greg KH <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, stfrench@microsoft.com, "Tobin C. Harding" <me@tobin.cc>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2018-11-16 at 14:44 +0200, Jani Nikula wrote:
> I quickly cooked up this script to produce the top-5 commit prefixes for
> the given files over the arbitrary last 200 commits. It'll give you a
> pretty good idea if you're even close.
> 
> ---
> #!/bin/sh
> # usage: subject-prefix FILE [...]
> # show top 5 subject prefixes for FILEs
> 
> git log --format=%s -n 200 -- "$@" |\
> 	grep -v "^Merge " |\
> 	sed 's/\(.*\):.*/\1/' |\
> 	sort | uniq -c | sort -nr | sed 's/ *[0-9]\+ //' |\
> 	head -n 5
> ---
> 
> Someone who knows perl could turn that into a checkpatch check: See if
> the patch subject prefix is one of the top-5 for all files changed by
> the patch, and ask the user to double check if it isn't. Or some
> heuristics thereof.

This won't work when a patch contains multiple files
from different paths, or even multiple files from a
single driver.

Perhaps it's better to use a generic mechanism like

	basename $(dirname $filename):

with some exceptions and add an override patch subject
grammar to appropriate various sections of MAINTAINERS.

I also think it's better to use a separate script like
scripts/spdxcheck.py and tie any necessary checkpatch
use to that script.



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
