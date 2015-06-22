Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1434993807.11808.155.camel@misato.fc.hp.com>
Subject: Re: [PATCH 2/3] mm, x86: Remove region_is_ram() call from ioremap
From: Toshi Kani <toshi.kani@hp.com>
Date: Mon, 22 Jun 2015 11:23:27 -0600
In-Reply-To: <55883605.5020706@sgi.com>
References: <1434750245-6304-1-git-send-email-toshi.kani@hp.com>
	 <1434750245-6304-3-git-send-email-toshi.kani@hp.com>
	 <55883605.5020706@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Travis <travis@sgi.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org, roland@purestorage.com, dan.j.williams@intel.com, x86@kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Clive Harding <clive@sgi.com>, Russ Anderson <rja@sgi.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2015-06-22 at 09:21 -0700, Mike Travis wrote:
> 
> On 6/19/2015 2:44 PM, Toshi Kani wrote:
> > __ioremap_caller() calls region_is_ram() to look up the resource
> > to check if a target range is RAM, which was added as an additinal
> > check to improve the lookup performance over page_is_ram() (commit
> > 906e36c5c717 "x86: use optimized ioresource lookup in ioremap
> > function").
> > 
> > __ioremap_caller() then calls walk_system_ram_range(), which had
> > replaced page_is_ram() to improve the lookup performance (commit
> > c81c8a1eeede "x86, ioremap: Speed up check for RAM pages").
> > 
> > Since both functions walk through the resource table, there is
> > no need to call the two functions.  Furthermore, region_is_ram()
> > has bugs and always returns with -1.  This makes
> > walk_system_ram_range() as the only check being used.
> 
> Do you have an example of a failing case?  

Well, region_is_ram() fails with -1 for every case... This is because it
breaks the for-loop at 'if (p->end < start)' in the first entry (i.e.
the lowest address range) of the resource table.  For example, the first
entry of 'p->end' is 0xfff on my system, which is certainly smaller than
'start'.

  # cat /proc/iomem
  00000000-00000fff : reserved
  00001000-00092fff : System RAM
  00093000-00093fff : reserved
	:

> Also, I didn't know that
> IOREMAP'd addresses were allowed to be on non-page boundaries?

Yes, that is allowed.  Here is a comment in __ioremap_caller(). 

 * NOTE! We need to allow non-page-aligned mappings too: we will
obviously
 * have to convert them into an offset in a page-aligned mapping, but
the
 * caller shouldn't need to know that small detail.

> Here's the comment and reason for the patches from Patch 0:
> 
> <<<
> We have a large university system in the UK that is experiencing
> very long delays modprobing the driver for a specific I/O device.
> The delay is from 8-10 minutes per device and there are 31 devices
> in the system.  This 4 to 5 hour delay in starting up those I/O
> devices is very much a burden on the customer.
> ...
> The problem was tracked down to a very slow IOREMAP operation and
> the excessively long ioresource lookup to insure that the user is
> not attempting to ioremap RAM.  These patches provide a speed up
> to that function.
> >>>
> 
> The speed up was pretty dramatic, I think to about 15-20 minutes
> (the test was done by our local CS person in the UK).  I think this
> would prove the function was working since it would have fallen
> back to the previous page_is_ram function and the 4 to 5 hour
> startup.

I wonder how this test was conducted.  When the region_is_ram() change
got in, the kernel already had the other speed up change (c81c8a1eeede),
which had replaced page_is_ram().

> If there is a failure, it would be better for all to fix the specific
> bug and not re-introduce the original problem.  Perhaps drop to
> page is ram if the address is not page aligned?

walk_system_ram_range() is the one that has the issue with
page-unaligned address.  region_is_ram() after fixed by patch 3/3 does
not have this issue.  ioremap() does not call page_is_ram() anymore.  

pcibios_add_device(), ksysfs.c, kdebugfs.c (and possibly more) call
ioremap for setup_data, which is page-unaligned.  If we are going to
disallow such callers, they all need to be converted with a different
mapping interface, such as vmap().  But vmap() takes an array of page
pointers as an argument, and is not convenient for them to use.  Since
setup_data is a special range, if they need to be changed may be
arguable.  I think issue 3 described in patch 0/3 needs further
discussion.  For now, I'd like to fix issue 1 & 2.

Thanks,
-Toshi


--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
