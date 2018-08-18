Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x242.google.com (mail-io0-x242.google.com
 [IPv6:2607:f8b0:4001:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E1E2210F48F0
 for <linux-nvdimm@lists.01.org>; Sat, 18 Aug 2018 16:15:17 -0700 (PDT)
Received: by mail-io0-x242.google.com with SMTP id r196-v6so2791501iod.0
 for <linux-nvdimm@lists.01.org>; Sat, 18 Aug 2018 16:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <1b332ae402bfc3806b834ee2c050dbc52b7eeb01.camel@intel.com>
In-Reply-To: <1b332ae402bfc3806b834ee2c050dbc52b7eeb01.camel@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 18 Aug 2018 16:15:05 -0700
Message-ID: <CA+55aFy18-r8FM614FWo8o0T2yOSy9rvv1hX50EOij84v1n1-g@mail.gmail.com>
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
To: Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 17, 2018 at 9:17 AM Jiang, Dave <dave.jiang@intel.com> wrote:
>
> Please pull to receive libnvdimm contributions for v4.19-rc1

So I don't care about the libnvdimm code itself, but when you guys add
code to the core mm/ code, I start looking.

And when I then see shit like this:

        if (is_zone_device_page(p))
                tk->size_shift = ilog2(dev_pagemap_mapping_size(p, vma));

I go "No".

There's two issues with this:

 - the damn thing can return 0, which would be an error for ilog2, and
the result is undefined

   You never check for errors. There's a check for tk->size_shift ==
0, but is that actually the guaranteed return value of ilog2(0)? No.

 - there is exactly one user of dev_pagemap_mapping_size(), and the above is it.

   Why the hell didn't that function just return the number of bits to
begin with?

I do not care if you screw up your own particular driver that much.

But when I see a pull request with complete and utter garbage in the
core mm part, I will not pull.

This is not acceptable.

Pulled, merge conflict fixed, and then immediately unpulled again.

I do not want to *EVER* see these kinds of patches to core MM code.
And I'm not gfoing to pull these patches or anythinig that looks like
it has any trace of this shit.

I get upset, because dammit, I expect better. I don't want to go "oh,
this changes core code, let's just skim over the patches" and
immediately find something fundamentally broken like this.

               Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
