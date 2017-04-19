Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D928421954075
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 07:55:23 -0700 (PDT)
Date: Wed, 19 Apr 2017 22:55:17 +0800
From: Baoquan He <bhe@redhat.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
Message-ID: <20170419145517.GB2311@x1>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
 <20170419133630.GA2311@x1>
 <CAJcbSZEbrOfnMQhr2dA0HBqogo0dYsEGCGsEbPMh1kM9tX4tEA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJcbSZEbrOfnMQhr2dA0HBqogo0dYsEGCGsEbPMh1kM9tX4tEA@mail.gmail.com>
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
To: Thomas Garnier <thgarnie@google.com>
Cc: linux-nvdimm@lists.01.org, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 04/19/17 at 07:27am, Thomas Garnier wrote:
> On Wed, Apr 19, 2017 at 6:36 AM, Baoquan He <bhe@redhat.com> wrote:
> > Hi all,
> >
> > I login in Jeff's system, and added debug code, no clue found. However
> > DaveY found he disabled page_offset randomization only and the efi issue
> > won't be seen on his system with kaslr enabled. I did it too on Jeff's
> > pmem system, it has the same result. I have rebooted several times, all
> > boot successfully. In the current code, no __PAGE_OFFSET_BASE is used
> > directly, don't know why it failed.
> 
> Great! I still cannot repro it.
> 
> >
> > Does anyone have any idea or hint I can try? I read pmem code about
> > the devm_nsio_enable/pmem_attach_disk/arch_add_memory, have no idea yet.
> 
> I would test couple things:
>  - Set page_offset_base to 0 by default and set it to
> __PAGE_OFFSET_BASE in kernel_randomize_memory (without randomizing
> it). If it crashes on a low address, it might be due to using __va or
> PAGE_OFFSET in general before randomization is done.

Thanks, Thomas!

Changed code like below, it should have the same effect as you suggested.

@@ -140,6 +140,8 @@ void __init kernel_randomize_memory(void)
                 * Select a random virtual address using the extra entropy
                 * available.
                 */
+               if (i == 0)
+                       continue;
                entropy = remain_entropy / (ARRAY_SIZE(kaslr_regions) - i);

Didn't see failure since above change applied.

>  - Does any change in __PAGE_OFFSET lead to a crash? Or only when
> __PAGE_OFFSET is on a specific range. Given that you may have to
> reboot multiple times to get a crash, I assume that a specific range
> is the problem but might be worth checking.

Good point, will check.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
