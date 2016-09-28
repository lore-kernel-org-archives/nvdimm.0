From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] xfs: Set BH_New for allocated DAX blocks in
 __xfs_get_blocks()
Date: Wed, 28 Sep 2016 10:22:55 +1000
Message-ID: <20160928002255.GG9806@dastard>
References: <1474994615-29553-1-git-send-email-jack@suse.cz>
 <1474994615-29553-5-git-send-email-jack@suse.cz>
 <20160927170118.GA15908@infradead.org>
 <20160927171707.GA30327@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160927171707.GA30327@quack2.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-Id: linux-nvdimm@lists.01.org

On Tue, Sep 27, 2016 at 07:17:07PM +0200, Jan Kara wrote:
> On Tue 27-09-16 10:01:18, Christoph Hellwig wrote:
> > On Tue, Sep 27, 2016 at 06:43:33PM +0200, Jan Kara wrote:
> > > So far we did not set BH_New for newly allocated blocks for DAX inodes
> > > in __xfs_get_blocks() because we wanted to avoid zeroing done in generic
> > > DAX code which was racy. Now the zeroing is gone so we can remove this
> > > workaround and return BH_New for newly allocated blocks. DAX will use this
> > > information to properly update mappings of the file.
> > 
> > __xfs_get_blocks isn't used by the DAX code any more.
> > xfs_file_iomap_begin should already be doing the right thing for now.
> 
> OK, the changelog is stale but I actually took care to integrate this with
> your iomap patches and for the new invalidation code in iomap_dax_actor()
> to work we need this additional information...

So this applies to the iomap-4.9-dax branch in the XFS tree?

https://git.kernel.org/cgit/linux/kernel/git/dgc/linux-xfs.git/log/?h=iomap-4.9-dax

i.e. Do I need to merge the patchset with that branch?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
