Return-Path: <linux-ext4-owner@vger.kernel.org>
Date: Mon, 25 Jan 2016 09:01:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] dax, ext2, ext4, XFS: fix data corruption race
Message-ID: <20160124220107.GI20456@dastard>
References: <1453503971-5319-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1453503971-5319-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 22, 2016 at 04:06:11PM -0700, Ross Zwisler wrote:
> With the current DAX code the following race exists:
> 
> Process 1                	Process 2
> ---------			---------
> 
> __dax_fault() - read file f, index 0
>   get_block() -> returns hole
>                              	__dax_fault() - write file f, index 0
>                                   get_block() -> allocates blocks
>                                   dax_insert_mapping()
>   dax_load_hole()
>   *data corruption*
> 
> An analogous race exists between __dax_fault() loading a hole and
> __dax_pmd_fault() allocating a PMD DAX page and trying to insert it, and
> that race also ends in data corruption.

Ok, so why doesn't this problem exist for the normal page cache
insertion case with concurrent read vs write faults?  It's because
the write fault first does a read fault and so always the write
fault always has a page in the radix tree for the get_block call
that allocates the extents, right?

And DAX has an optimisation in the page fault part where it skips
the read fault part of the write fault?  And so essentially the DAX
write fault is missing the object (page lock of page in the radix
tree) that the non-DAX write fault uses to avoid this problem?

What happens if we get rid of that DAX write fault optimisation that
skips the initial read fault? The write fault will always run on a
mapping that has a hole loaded, right?, so the race between
dax_load_hole() and dax_insert_mapping() goes away, because nothing
will be calling dax_load_hole() once the write fault is allocating
blocks....

> One solution to this race was proposed by Jan Kara:
> 
>   So we need some exclusion that makes sure pgoff->block mapping
>   information is uptodate at the moment we insert it into page tables. The
>   simplest reasonably fast thing I can see is:
> 
>   When handling a read fault, things stay as is and filesystem protects the
>   fault with an equivalent of EXT4_I(inode)->i_mmap_sem held for reading.
>   When handling a write fault we first grab EXT4_I(inode)->i_mmap_sem for
>   reading and try a read fault. If __dax_fault() sees a hole returned from
>   get_blocks() during a write fault, it bails out. Filesystem grabs
>   EXT4_I(inode)->i_mmap_sem for writing and retries with different
>   get_blocks() callback which will allocate blocks. That way we get proper
>   exclusion for faults needing to allocate blocks.
> 
> This patch adds this logic to DAX, ext2, ext4 and XFS.

It's too ugly to live. It hacks around a special DAX optimisation in
the fault code by adding special case locking to the filesystems,
and adds a siginificant new locking constraint to the page fault
path.

If the write fault first goes through the read fault path and loads
the hole, this race condition simply does not exist. I'd suggest
that we get rid of the DAX optimisation that skips read fault
processing on write fault so that this problem simply goes away.
Yes, it means write faults on holes will be a little slower (which,
quite frankly, I don't care at all about), but it means we don't
need to hack special cases into code that should not have to care
about various different types of page fault races. Correctness
first, speed later.

FWIW, this also means we can get rid of the hacks in the filesystem
code where we have to handle write faults through the ->fault
handler rather than the ->page_mkwrite handler.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
