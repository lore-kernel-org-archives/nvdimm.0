Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 25 Jan 2016 14:59:21 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH] dax, ext2, ext4, XFS: fix data corruption race
Message-ID: <20160125135921.GE24938@quack.suse.cz>
References: <1453503971-5319-1-git-send-email-ross.zwisler@linux.intel.com>
 <20160124220107.GI20456@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160124220107.GI20456@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com
List-ID: <linux-nvdimm@lists.01.org>

On Mon 25-01-16 09:01:07, Dave Chinner wrote:
> On Fri, Jan 22, 2016 at 04:06:11PM -0700, Ross Zwisler wrote:
> > With the current DAX code the following race exists:
> > 
> > Process 1                	Process 2
> > ---------			---------
> > 
> > __dax_fault() - read file f, index 0
> >   get_block() -> returns hole
> >                              	__dax_fault() - write file f, index 0
> >                                   get_block() -> allocates blocks
> >                                   dax_insert_mapping()
> >   dax_load_hole()
> >   *data corruption*
> > 
> > An analogous race exists between __dax_fault() loading a hole and
> > __dax_pmd_fault() allocating a PMD DAX page and trying to insert it, and
> > that race also ends in data corruption.
> 
> Ok, so why doesn't this problem exist for the normal page cache
> insertion case with concurrent read vs write faults?  It's because
> the write fault first does a read fault and so always the write
> fault always has a page in the radix tree for the get_block call
> that allocates the extents, right?

Yes, any fault (read or write) has a page to lock which avoids races for
normal fault path.

> And DAX has an optimisation in the page fault part where it skips
> the read fault part of the write fault?  And so essentially the DAX
> write fault is missing the object (page lock of page in the radix
> tree) that the non-DAX write fault uses to avoid this problem?
> 
> What happens if we get rid of that DAX write fault optimisation that
> skips the initial read fault? The write fault will always run on a
> mapping that has a hole loaded, right?, so the race between
> dax_load_hole() and dax_insert_mapping() goes away, because nothing
> will be calling dax_load_hole() once the write fault is allocating
> blocks....

So frankly I don't like mixing of page locks into the DAX fault locking.
Also your scheme would require more tricks to deal with races between PMD
write faults racing with PTE read faults since you don't want to require
2MB worth of hole-pages to be able to do a PMD write fault. Transparent
huge pages deal with this issue using compound pages but I'd like to avoid
that horror in the DAX path...

> > One solution to this race was proposed by Jan Kara:
> > 
> >   So we need some exclusion that makes sure pgoff->block mapping
> >   information is uptodate at the moment we insert it into page tables. The
> >   simplest reasonably fast thing I can see is:
> > 
> >   When handling a read fault, things stay as is and filesystem protects the
> >   fault with an equivalent of EXT4_I(inode)->i_mmap_sem held for reading.
> >   When handling a write fault we first grab EXT4_I(inode)->i_mmap_sem for
> >   reading and try a read fault. If __dax_fault() sees a hole returned from
> >   get_blocks() during a write fault, it bails out. Filesystem grabs
> >   EXT4_I(inode)->i_mmap_sem for writing and retries with different
> >   get_blocks() callback which will allocate blocks. That way we get proper
> >   exclusion for faults needing to allocate blocks.
> > 
> > This patch adds this logic to DAX, ext2, ext4 and XFS.
> 
> It's too ugly to live. It hacks around a special DAX optimisation in
> the fault code by adding special case locking to the filesystems,
> and adds a siginificant new locking constraint to the page fault
> path.
> 
> If the write fault first goes through the read fault path and loads
> the hole, this race condition simply does not exist. I'd suggest
> that we get rid of the DAX optimisation that skips read fault
> processing on write fault so that this problem simply goes away.
> Yes, it means write faults on holes will be a little slower (which,
> quite frankly, I don't care at all about), but it means we don't
> need to hack special cases into code that should not have to care
> about various different types of page fault races. Correctness
> first, speed later.
> 
> FWIW, this also means we can get rid of the hacks in the filesystem
> code where we have to handle write faults through the ->fault
> handler rather than the ->page_mkwrite handler.

So I don't mind doing read-fault first. But as I wrote above I don't think
it solves all the issues. The rule I wanted to introduce is:

1) Fault requiring block allocation require exclusive lock held over the
whole fault.

2) Fault not requiring allocation is enough with shared lock held over the
whole fault.

So we can certainly grab i_mmap_sem exclusively whenever we hit a write
fault and it would be correct. This looks like a quite clean design to me.

As a performance optimization (which is upto each filesystem) we can try to
satisfy write fault without allocation while holding i_mmap_sem in a shared
mode and if that fails, grab the lock exclusively and retry. Still don't like
it?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
