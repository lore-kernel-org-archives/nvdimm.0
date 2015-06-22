Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1434999993.11808.184.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/3] mm, x86: Remove region_is_ram() call from ioremap
From: Toshi Kani <toshi.kani@hp.com>
Date: Mon, 22 Jun 2015 13:06:33 -0600
In-Reply-To: <5588526E.7010801@sgi.com>
References: <1434750245-6304-1-git-send-email-toshi.kani@hp.com>
		 <1434750245-6304-3-git-send-email-toshi.kani@hp.com>
		 <55883605.5020706@sgi.com> <1434993807.11808.155.camel@misato.fc.hp.com>
	 <5588526E.7010801@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Travis <travis@sgi.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, roland@purestorage.com, dan.j.williams@intel.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Clive Harding <clive@sgi.com>, Russ Anderson <rja@sgi.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2015-06-22 at 11:22 -0700, Mike Travis wrote:
> 
> On 6/22/2015 10:23 AM, Toshi Kani wrote:
> > On Mon, 2015-06-22 at 09:21 -0700, Mike Travis wrote:
> >>
> >> On 6/19/2015 2:44 PM, Toshi Kani wrote:
> >>> __ioremap_caller() calls region_is_ram() to look up the resource
> >>> to check if a target range is RAM, which was added as an additinal
> >>> check to improve the lookup performance over page_is_ram() (commit
> >>> 906e36c5c717 "x86: use optimized ioresource lookup in ioremap
> >>> function").
> >>>
> >>> __ioremap_caller() then calls walk_system_ram_range(), which had
> >>> replaced page_is_ram() to improve the lookup performance (commit
> >>> c81c8a1eeede "x86, ioremap: Speed up check for RAM pages").
> >>>
> >>> Since both functions walk through the resource table, there is
> >>> no need to call the two functions.  Furthermore, region_is_ram()
> >>> has bugs and always returns with -1.  This makes
> >>> walk_system_ram_range() as the only check being used.
> >>
> >> Do you have an example of a failing case?  
> > 
> > Well, region_is_ram() fails with -1 for every case... This is because it
> > breaks the for-loop at 'if (p->end < start)' in the first entry (i.e.
> > the lowest address range) of the resource table.  For example, the first
> > entry of 'p->end' is 0xfff on my system, which is certainly smaller than
> > 'start'.
> > 
> >   # cat /proc/iomem
> >   00000000-00000fff : reserved
> >   00001000-00092fff : System RAM
> >   00093000-00093fff : reserved
> > 	:
> 
> That is a small entry.  But I don't understand that when it
> returned the -1, the page_is_ram function was not used instead?
> Or am I missing something?
> 
> -	/* If could not be identified(-1), check page by page */
> -	if (ram_region < 0) {
> -		pfn      = phys_addr >> PAGE_SHIFT;
> -		last_pfn = last_addr >> PAGE_SHIFT;
> -		if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,

I am afraid that you are missing something...  After region_is_ram()
failed, __ioremap_call() calls walk_system_ram_range(), not
page_is_ram().  This patch 2/3 removes the call to region_is_ram(), and
calls walk_system_ram_range() unconditionally without checking
'ram_region', which is set by region_is_ram().  Please note that ioremap
does not call page_is_ram() any more.  It had been removed by
c81c8a1eeede.

> >> Also, I didn't know that
> >> IOREMAP'd addresses were allowed to be on non-page boundaries?
> > 
> > Yes, that is allowed.  Here is a comment in __ioremap_caller(). 
> > 
> >  * NOTE! We need to allow non-page-aligned mappings too: we will
> > obviously
> >  * have to convert them into an offset in a page-aligned mapping, but
> > the
> >  * caller shouldn't need to know that small detail.
> 
> You're right, I forgot about that realignment.  The original
> intent was to try to optimize and if that failed, fall back
> to the original method.  I think this case would have been 
> caught as well?

Yes, this case would have been caught if region_is_ram() would have
worked.
 
> >> Here's the comment and reason for the patches from Patch 0:
> >>
> >> <<<
> >> We have a large university system in the UK that is experiencing
> >> very long delays modprobing the driver for a specific I/O device.
> >> The delay is from 8-10 minutes per device and there are 31 devices
> >> in the system.  This 4 to 5 hour delay in starting up those I/O
> >> devices is very much a burden on the customer.
> >> ...
> >> The problem was tracked down to a very slow IOREMAP operation and
> >> the excessively long ioresource lookup to insure that the user is
> >> not attempting to ioremap RAM.  These patches provide a speed up
> >> to that function.
> >>>>>
> >>
> >> The speed up was pretty dramatic, I think to about 15-20 minutes
> >> (the test was done by our local CS person in the UK).  I think this
> >> would prove the function was working since it would have fallen
> >> back to the previous page_is_ram function and the 4 to 5 hour
> >> startup.
> > 
> > I wonder how this test was conducted.  When the region_is_ram() change
> > got in, the kernel already had the other speed up change (c81c8a1eeede),
> > which had replaced page_is_ram().
> 
> The onsite system was not running the latest kernel (these large
> system customers are very reluctant to disrupt their running
> environments.)

Then you had probably replaced page_is_ram() with region_is_ram() and
ignored the error in this test...
 
> >> If there is a failure, it would be better for all to fix the specific
> >> bug and not re-introduce the original problem.  Perhaps drop to
> >> page is ram if the address is not page aligned?
> > 
> > walk_system_ram_range() is the one that has the issue with
> > page-unaligned address.  region_is_ram() after fixed by patch 3/3 does
> > not have this issue.  ioremap() does not call page_is_ram() anymore.
> 
> It appears ioremap does not call region_is_ram either.
> 
> -       /* First check if whole region can be identified as RAM or not */
> -       ram_region = region_is_ram(phys_addr, size);
> -       if (ram_region > 0) {
> ...
> +       pfn      = phys_addr >> PAGE_SHIFT;
> +       last_pfn = last_addr >> PAGE_SHIFT;
> +       if (walk_system_ram_range(pfn, last_pfn - pfn + 1, NULL,

That's the case after this patch 2/3 is applied.  ioremap calls
region_is_ram() today.

> It appears that the walk_system_ram_range() patch does supersede
> the region_is_ram patch.  Perhaps we can add a caveat to this
> patch that you should not use this patch without also using
> the patch from c81c8a1eeede?  Otherwise the excessive slowdown
> in ioremap will be reintroduced?
> 
> (I'm thinking about back ports to distro kernels that customers use.)

This patch changes ioremap() to call walk_system_ram_range() only.
Since walk_system_ram_range() walks through the resource table, there is
no such slowdown issue.  In other words, there is no behavioral change
in this patch, except it'd be slightly faster.
 
> > pcibios_add_device(), ksysfs.c, kdebugfs.c (and possibly more) call
> > ioremap for setup_data, which is page-unaligned.  If we are going to
> > disallow such callers, they all need to be converted with a different
> > mapping interface, such as vmap().  But vmap() takes an array of page
> > pointers as an argument, and is not convenient for them to use.  Since
> > setup_data is a special range, if they need to be changed may be
> > arguable.  I think issue 3 described in patch 0/3 needs further
> > discussion.  For now, I'd like to fix issue 1 & 2.
> 
> Since __ioremap_caller() was the only caller of region_is_ram, then
> the function can be removed instead of being fixed.

Well, there is a new caller, memremap_valid(), in Dan's patchset.
https://lkml.org/lkml/2015/6/22/100

Thanks,
-Toshi


--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
