Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 26 Jan 2016 14:05:21 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH] dax, ext2, ext4, XFS: fix data corruption race
Message-ID: <20160126130521.GB23820@quack.suse.cz>
References: <1453503971-5319-1-git-send-email-ross.zwisler@linux.intel.com>
 <20160124220107.GI20456@dastard>
 <20160125135921.GE24938@quack.suse.cz>
 <20160126124812.GJ2948@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160126124812.GJ2948@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com
List-ID: <linux-nvdimm@lists.01.org>

On Tue 26-01-16 07:48:12, Matthew Wilcox wrote:
> On Mon, Jan 25, 2016 at 02:59:21PM +0100, Jan Kara wrote:
> > On Mon 25-01-16 09:01:07, Dave Chinner wrote:
> > > What happens if we get rid of that DAX write fault optimisation that
> > > skips the initial read fault? The write fault will always run on a
> > > mapping that has a hole loaded, right?, so the race between
> > > dax_load_hole() and dax_insert_mapping() goes away, because nothing
> > > will be calling dax_load_hole() once the write fault is allocating
> > > blocks....
> > 
> > So frankly I don't like mixing of page locks into the DAX fault locking.
> > Also your scheme would require more tricks to deal with races between PMD
> > write faults racing with PTE read faults since you don't want to require
> > 2MB worth of hole-pages to be able to do a PMD write fault. Transparent
> > huge pages deal with this issue using compound pages but I'd like to avoid
> > that horror in the DAX path...
> 
> I *think* that what Dave's proposing (and if he isn't, I'm proposing it
> for him) is that the filesystem takes its allocation lock shared during
> the ->fault handler, then in the ->page_mkwrite handler, it knows that an
> allocation is coming, so it takes its allocation lock in exclusive mode.
> 
> So read vs write faults won't be able to race because the allocation lock
> will prevent it.

So this is correct and clean design but we will take the lock in exclusive
mode (and thus hurt scalability) for every write fault, not just for the
ones allocating blocks. And at the moment we take exclusive lock for write
faults, there's no more need for having the hole page instantiated - we can
still do it for simplicity but it's no longer necessary to avoid data
corruption.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
