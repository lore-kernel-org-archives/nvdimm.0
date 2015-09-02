Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <55E6C991.5010006@plexistor.com>
Date: Wed, 02 Sep 2015 13:04:01 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH] dax, pmem: add support for msync
References: <1441047584-14664-1-git-send-email-ross.zwisler@linux.intel.com> <20150831233803.GO3902@dastard> <20150901070608.GA5482@lst.de> <20150901222120.GQ3902@dastard> <20150902031945.GA8916@linux.intel.com>
In-Reply-To: <20150902031945.GA8916@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@osdl.org>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Matthew Wilcox <willy@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 09/02/2015 06:19 AM, Ross Zwisler wrote:
> On Wed, Sep 02, 2015 at 08:21:20AM +1000, Dave Chinner wrote:
>> Which means applications that should "just work" without
>> modification on DAX are now subtly broken and don't actually
>> guarantee data is safe after a crash. That's a pretty nasty
>> landmine, and goes against *everything* we've claimed about using
>> DAX with existing applications.
>>
>> That's wrong, and needs fixing.
> 
> I agree that we need to fix fsync as well, and that the fsync solution could
> be used to implement msync if we choose to go that route.  I think we might
> want to consider keeping the msync and fsync implementations separate, though,
> for two reasons.
> 
> 1) The current msync implementation is much more efficient than what will be
> needed for fsync.  Fsync will need to call into the filesystem, traverse all
> the blocks, get kernel virtual addresses from those and then call
> wb_cache_pmem() on those kernel addresses.  

I was thinking about this some more, and no this is not what we need to do
because of the virtual-based-cache ARCHs. And what we do for these systems
will also work for physical-based-cache ARCHs.

What we need to do, is dig into the mapping structure and pic up the current
VMA on the call to fsync. Then just flush that one on that virtual address,
(since it is current at the context of the fsync sys call)

And of course we need to do like I wrote, we must call fsync on vm_operations->close
before the VMA mappings goes away. Then an fsync after unmap is a no-op.

> I think this is a necessary evil
> for fsync since you don't have a VMA, but for msync we do and we can just
> flush using the user addresses without any fs lookups.
> 

right see above

> 2) I believe that the near-term fsync code will rely on struct pages for
> PMEM, which I believe are possible but optional as of Dan's last patch set:
> 
> https://lkml.org/lkml/2015/8/25/841
> 
> I believe that this means that if we don't have struct pages for PMEM (becuase
> ZONE_DEVICE et al. are turned off) fsync won't work.  I'd be nice not to lose
> msync as well.

Please see above it can be made to work. Actually what we do is the
traversal-kernel-ptr thing, and the fsync-on-unmap. And it works we have heavy
persistence testing and it is all very good.

So no, without pages it can all work very-well. There is only the sync problem
that I intend to fix soon, is only a matter of keeping a dax-dirty inode-list
per sb.

So no this is not an excuse.

Cheers
Boaz

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
