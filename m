Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5287421B02822
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 11:35:17 -0800 (PST)
Date: Thu, 17 Jan 2019 12:34:03 -0700
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 0/4] Allow persistent memory to be used like normal RAM
Message-ID: <20190117193403.GD31543@localhost.localdomain>
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <x49sgxr9rjd.fsf@segfault.boston.devel.redhat.com>
 <20190117164736.GC31543@localhost.localdomain>
 <x49pnsv8am1.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49pnsv8am1.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: thomas.lendacky@amd.com, dave@sr71.net, linux-nvdimm@lists.01.org, tiwai@suse.de, Dave Hansen <dave.hansen@linux.intel.com>, ying.huang@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, bp@suse.de, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, bhelgaas@google.com, akpm@linux-foundation.org, fengguang.wu@intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 17, 2019 at 12:20:06PM -0500, Jeff Moyer wrote:
> Keith Busch <keith.busch@intel.com> writes:
> > On Thu, Jan 17, 2019 at 11:29:10AM -0500, Jeff Moyer wrote:
> >> Dave Hansen <dave.hansen@linux.intel.com> writes:
> >> > Persistent memory is cool.  But, currently, you have to rewrite
> >> > your applications to use it.  Wouldn't it be cool if you could
> >> > just have it show up in your system like normal RAM and get to
> >> > it like a slow blob of memory?  Well... have I got the patch
> >> > series for you!
> >> 
> >> So, isn't that what memory mode is for?
> >>   https://itpeernetwork.intel.com/intel-optane-dc-persistent-memory-operating-modes/
> >> 
> >> Why do we need this code in the kernel?
> >
> > I don't think those are the same thing. The "memory mode" in the link
> > refers to platforms that sequester DRAM to side cache memory access, where
> > this series doesn't have that platform dependency nor hides faster DRAM.
> 
> OK, so you are making two arguments, here.  1) platforms may not support
> memory mode, and 2) this series allows for performance differentiated
> memory (even though applications may not modified to make use of
> that...).
> 
> With this patch set, an unmodified application would either use:
> 
> 1) whatever memory it happened to get
> 2) only the faster dram (via numactl --membind=)
> 3) only the slower pmem (again, via numactl --membind1)
> 4) preferentially one or the other (numactl --preferred=)

Yes, numactl and mbind are good ways for unmodified applications
to use these different memory types when they're available.

Tangentially related, I have another series[1] that provides supplementary
information that can be used to help make these decisions for platforms
that provide HMAT (heterogeneous memory attribute tables).

> The other options are:
> - as mentioned above, memory mode, which uses DRAM as a cache for the
>   slower persistent memory.  Note that it isn't all or nothing--you can
>   configure your system with both memory mode and appdirect.  The
>   limitation, of course, is that your platform has to support this.
>
>   This seems like the obvious solution if you want to make use of the
>   larger pmem capacity as regular volatile memory (and your platform
>   supports it).  But maybe there is some other limitation that motivated
>   this work?

The hardware supported implementation is one way it may be used, and it's
up side is that accessing the cached memory is transparent to the OS and
applications. They can use memory unaware that this is happening, so it
has a low barrier for applications to make use of the large available
address space.

There are some minimal things software may do that improve this mode,
as Dan mentioned in his reply [2], but it is still usable even without
such optimizations.

On the downside, a reboot would be required if you want to change the
memory configuration at a later time, like you decide more or less DRAM
as cache is needed. This series has runtime hot pluggable capabilities.

It's also possible the customer may know better which applications require
more hot vs cold data, but the memory mode caching doesn't give them as
much control since the faster memory is hidden.

> - libmemkind or pmdk.  These options typically* require application
>   modifications, but allow those applications to actively decide which
>   data lives in fast versus slow media.
> 
>   This seems like the obvious answer for applications that care about
>   access latency.
> 
> * you could override the system malloc, but some libraries/application
>   stacks already do that, so it isn't a universal solution.
> 
> Listing something like this in the headers of these patch series would
> considerably reduce the head-scratching for reviewers.
> 
> Keith, you seem to be implying that there are platforms that won't
> support memory mode.  Do you also have some insight into how customers
> want to use this, beyond my speculation?  It's really frustrating to see
> patch sets like this go by without any real use cases provided.

Right, most NFIT reporting platforms today don't have memory mode, and
the kernel currently only supports the persistent DAX mode with these.
This series adds another option for those platforms.

I think numactl as you mentioned is the first consideration for how
customers may make use. Dave or Dan might have other use cases in mind.
Just thinking out loud, if we wanted an in-kernel use case, it may be
interesting to make slower memory a swap tier so the host can manage
the cache rather than the hardware.

[1]
https://lore.kernel.org/patchwork/cover/1032688/

[2]
https://lore.kernel.org/lkml/154767945660.1983228.12167020940431682725.stgit@dwillia2-desk3.amr.corp.intel.com/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
