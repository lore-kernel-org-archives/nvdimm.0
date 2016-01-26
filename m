Return-Path: <linux-ext4-owner@vger.kernel.org>
Date: Tue, 26 Jan 2016 09:47:46 -0500
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC PATCH] dax, ext2, ext4, XFS: fix data corruption race
Message-ID: <20160126144746.GL2948@linux.intel.com>
References: <1453503971-5319-1-git-send-email-ross.zwisler@linux.intel.com>
 <20160124220107.GI20456@dastard>
 <20160125135921.GE24938@quack.suse.cz>
 <20160126124812.GJ2948@linux.intel.com>
 <20160126130521.GB23820@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160126130521.GB23820@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 26, 2016 at 02:05:21PM +0100, Jan Kara wrote:
> On Tue 26-01-16 07:48:12, Matthew Wilcox wrote:
> > I *think* that what Dave's proposing (and if he isn't, I'm proposing it
> > for him) is that the filesystem takes its allocation lock shared during
> > the ->fault handler, then in the ->page_mkwrite handler, it knows that an
> > allocation is coming, so it takes its allocation lock in exclusive mode.
> > 
> > So read vs write faults won't be able to race because the allocation lock
> > will prevent it.
> 
> So this is correct and clean design but we will take the lock in exclusive
> mode (and thus hurt scalability) for every write fault, not just for the
> ones allocating blocks. And at the moment we take exclusive lock for write
> faults, there's no more need for having the hole page instantiated - we can
> still do it for simplicity but it's no longer necessary to avoid data
> corruption.

In my mind we take it only for allocating writes, because we also include
the patch to insert PFNs with the writable bit set in the dax_fault
handler if the page fault was for writes.

Although that only works when the *first* fault is a write ... if we
read and page then write the same page, we will indeed take the lock
in exclusive mode.  I think that's fixable too -- in the page_mkwrite
handler, take the lock in exclusive mode only if there's a page in the
radix tree.  I'll take a look at that optimisation after doing the first
couple of steps.
