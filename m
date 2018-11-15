Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-vk1-f194.google.com (mail-vk1-f194.google.com
 [209.85.221.194])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C27EE21191725
 for <linux-nvdimm@lists.01.org>; Wed, 14 Nov 2018 23:58:28 -0800 (PST)
Received: by mail-vk1-f194.google.com with SMTP id h128so4258686vkg.11
 for <linux-nvdimm@lists.01.org>; Wed, 14 Nov 2018 23:58:28 -0800 (PST)
MIME-Version: 1.0
References: <154225759358.2499188.15268218778137905050.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154225760492.2499188.14152986544451112930.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154225760492.2499188.14152986544451112930.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 15 Nov 2018 08:58:15 +0100
Message-ID: <CAMuHMdV5UKwMHa1ydBiEiiSBswzcVBjqjW573fSeD08RNRnzGw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: ksummit-discuss@lists.linuxfoundation.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stfrench@microsoft.com, Greg KH <gregkh@linuxfoundation.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, "Tobin C. Harding" <me@tobin.cc>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

On Thu, Nov 15, 2018 at 6:05 AM Dan Williams <dan.j.williams@intel.com> wrote:
> As presented at the 2018 Linux Plumbers conference [1], the Subsystem
> Profile is proposed as a way to reduce friction between committers and
> maintainers and perhaps encourage conversations amongst maintainers
> about best practice policies.
>
> The profile contains short answers to some of the common policy
> questions a contributor might have, or that a maintainer might consider
> formalizing. The current list of maintenance policies is:
>
> Overview: General introduction to maintaining the subsystem
> Core: List of source files considered core
> Leaf: List of source files that consume core functionality
> Patches or Pull requests: Simple statement of expected submission format
> Last -rc for new feature submissions: Expected lead time for submissions
> Last -rc to merge features: Deadline for merge decisions
> Non-author Ack / Review Tags Required: Patch review economics
> Test Suite: Pass this suite before requesting inclusion
> Resubmit Cadence: When to ping the maintainer
> Trusted Reviewers: Help for triaging patches
> Time Zone / Office Hours: When might a maintainer be available
> Checkpatch / Style Cleanups: Policy on pure cleanup patches
> Off-list review: Request for review gates
> TODO: Potential development tasks up for grabs, or active focus areas
>
> The goal of the Subsystem Profile is to set expectations for
> contributors and interim or replacement maintainers for a subsystem.
>
> See Documentation/maintainer/subsystem-profile.rst for more details, and
> a follow-on example profile for the libnvdimm subsystem.

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Thanks for your patch!

> --- /dev/null
> +++ b/Documentation/maintainer/subsystem-profile.rst

> +Last -rc to merge features
> +--------------------------
> +Indicate to contributors the point at which an as yet un-applied patch
> +set will need to wait for the NEXT+1 merge window. Of course there is no
> +obligation to ever except any given patchset, but if the review has not

s/except/accept/

> +concluded by this point the expectation the contributor should wait and

expectation is (that)

> +resubmit for the following merge window. The answer may be different for
> +'Core:' files, include a second entry prefixed with 'Core:' if so.

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
