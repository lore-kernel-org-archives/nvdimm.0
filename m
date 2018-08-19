Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x243.google.com (mail-it0-x243.google.com
 [IPv6:2607:f8b0:4001:c0b::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3FC7B210F2CF6
 for <linux-nvdimm@lists.01.org>; Sat, 18 Aug 2018 22:09:06 -0700 (PDT)
Received: by mail-it0-x243.google.com with SMTP id d9-v6so16498728itf.2
 for <linux-nvdimm@lists.01.org>; Sat, 18 Aug 2018 22:09:06 -0700 (PDT)
MIME-Version: 1.0
References: <1b332ae402bfc3806b834ee2c050dbc52b7eeb01.camel@intel.com>
 <CA+55aFy18-r8FM614FWo8o0T2yOSy9rvv1hX50EOij84v1n1-g@mail.gmail.com>
In-Reply-To: <CA+55aFy18-r8FM614FWo8o0T2yOSy9rvv1hX50EOij84v1n1-g@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 18 Aug 2018 22:08:53 -0700
Message-ID: <CAA9_cmcGchAuDB-8kz34PjJeR10rAKPV4k=thahojiC5XNWY3Q@mail.gmail.com>
Subject: Re: [GIT PULL]: libnvdimm updates for v4.19-rc1
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
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

/me peeks in from vacation and realizes he has left his coverage with a mess

On Sat, Aug 18, 2018 at 4:15 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Aug 17, 2018 at 9:17 AM Jiang, Dave <dave.jiang@intel.com> wrote:
> >
> > Please pull to receive libnvdimm contributions for v4.19-rc1
>
> So I don't care about the libnvdimm code itself, but when you guys add
> code to the core mm/ code, I start looking.
>
> And when I then see shit like this:
>
>         if (is_zone_device_page(p))
>                 tk->size_shift = ilog2(dev_pagemap_mapping_size(p, vma));
>
> I go "No".
>
> There's two issues with this:
>
>  - the damn thing can return 0, which would be an error for ilog2, and
> the result is undefined
>
>    You never check for errors. There's a check for tk->size_shift ==
> 0, but is that actually the guaranteed return value of ilog2(0)? No.
>
>  - there is exactly one user of dev_pagemap_mapping_size(), and the above is it.
>
>    Why the hell didn't that function just return the number of bits to
> begin with?

In an earlier version of the patch set the raw size was used, but yes,
now we only need the number of bits.

> I do not care if you screw up your own particular driver that much.
>
> But when I see a pull request with complete and utter garbage in the
> core mm part, I will not pull.
>
> This is not acceptable.
>
> Pulled, merge conflict fixed, and then immediately unpulled again.
>
> I do not want to *EVER* see these kinds of patches to core MM code.
> And I'm not going to pull these patches or anythinig that looks like
> it has any trace of this shit.
>
> I get upset, because dammit, I expect better. I don't want to go "oh,
> this changes core code, let's just skim over the patches" and
> immediately find something fundamentally broken like this.

Yes, that's my wreckage. I particularly should have known better
because I have seen your ilog2() misuse review comments on other patch
sets and was careless in this instance. I was focused on the
dax_lock_mapping_entry() implementation and did not circle back to
sanity check this when the test case started passing (not an excuse,
just thinking through how I overlooked this).

This support for turning machine checks in dax mappings into SIGBUS
unfortunately ended up touching "all the things" across mm/ and x86/
in addition to drivers/nvdimm/ and drivers/dax/. It ran out of time
for 4.18, and to help not miss 4.19 I offered to coordinate the series
in libnvdimm.git with acks from Naoya, Ingo, and Jan.

If it can still make 4.19, would you except a fixed up branch?

The justification for pushing this sooner rather than later is to
start the pipeline to the distros since enterprise in-memory-database
developers reported this gap in the kernel memory error handling
compared to the DRAM / page cache case.

I'm otherwise not in a position to help out on this with code until
I'm back in the office mid-September, so I'd have to put this on Dave
to clean up. Sorry Dave, and apologies Linus for the screw up.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
