Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x22c.google.com (mail-wm0-x22c.google.com
 [IPv6:2a00:1450:400c:c09::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A3BAB1A1E11
 for <linux-nvdimm@lists.01.org>; Mon,  1 Aug 2016 03:13:49 -0700 (PDT)
Received: by mail-wm0-x22c.google.com with SMTP id p129so52458301wmp.0
 for <linux-nvdimm@lists.01.org>; Mon, 01 Aug 2016 03:13:49 -0700 (PDT)
Message-ID: <579F20D9.80107@plexistor.com>
Date: Mon, 01 Aug 2016 13:13:45 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: Subtle races between DAX mmap fault and write path
References: <20160727120745.GI6860@quack2.suse.cz>
 <20160727211039.GA20278@linux.intel.com> <20160727221949.GU16044@dastard>
 <20160728081033.GC4094@quack2.suse.cz> <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard>
In-Reply-To: <20160730001249.GE16044@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 07/30/2016 03:12 AM, Dave Chinner wrote:
<>
> 
> If we track the dirty blocks from write in the radix tree like we
> for mmap, then we can just use a normal memcpy() in dax_do_io(),
> getting rid of the slow cache bypass that is currently run. Radix
> tree updates are much less expensive than a slow memcpy of large
> amounts of data, ad fsync can then take care of persistence, just
> like we do for mmap.
> 

No! 

mov_nt instructions, That "slow cache bypass that is currently run" above
is actually faster then cached writes by 20%, and if you add the dirty
tracking and cl_flush instructions it becomes x2 slower in the most
optimal case and 3 times slower in the DAX case.

The network guys have noticed the mov_nt instructions superior performance
for years before we pushed DAX into the tree. look for users of copy_from_iter_nocache
and the comments when they where introduced, those where used before DAX, and
nothing at all to do with persistence.

So what you are suggesting is fine only 3 times slower in the current
implementation.

> We should just make the design assumption that all persistent memory
> is volatile, track where we dirty it in all paths, and use the
> fastest volatile memcpy primitives available to us in the IO path.

The "fastest volatile memcpy primitives available" is what we do
today with the mov_nt instructions.

> We'll end up with a faster fastpath that if we use CPU cache bypass
> copies, dax_do_io() and mmap will be coherent and synchronised, and
> fsync() will have the same requirements and overhead regardless of
> the way the application modifies the pmem or the hardware platform
> used to implement the pmem.
> 

I measured, there is tests running in our labs every night, your
suggestion on an ADR system is 3 times slower to reach persistence.

Is why I was pushing for MMAP_PMEM_AWARE, because a smart mmap application
from user-mode uses mov_nt anyway because it wants that 20% gain regardless
of what the Kernel will do. Then it calls fsync() and the Kernel will burn
x2 more CPU, just for the sake of burning CPU, because the data is already
persistent at the get go.

> Cheers,
> Dave.

As you, I do not care for DAX very much, but please lets keep the physical
facts strait

Cheers indeed
Boaz

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
