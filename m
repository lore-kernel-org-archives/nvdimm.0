From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/6] xfs: Set BH_New for allocated DAX blocks in
 __xfs_get_blocks()
Date: Tue, 27 Sep 2016 19:17:07 +0200
Message-ID: <20160927171707.GA30327@quack2.suse.cz>
References: <1474994615-29553-1-git-send-email-jack@suse.cz>
 <1474994615-29553-5-git-send-email-jack@suse.cz>
 <20160927170118.GA15908@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160927170118.GA15908@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-Id: linux-nvdimm@lists.01.org

On Tue 27-09-16 10:01:18, Christoph Hellwig wrote:
> On Tue, Sep 27, 2016 at 06:43:33PM +0200, Jan Kara wrote:
> > So far we did not set BH_New for newly allocated blocks for DAX inodes
> > in __xfs_get_blocks() because we wanted to avoid zeroing done in generic
> > DAX code which was racy. Now the zeroing is gone so we can remove this
> > workaround and return BH_New for newly allocated blocks. DAX will use this
> > information to properly update mappings of the file.
> 
> __xfs_get_blocks isn't used by the DAX code any more.
> xfs_file_iomap_begin should already be doing the right thing for now.

OK, the changelog is stale but I actually took care to integrate this with
your iomap patches and for the new invalidation code in iomap_dax_actor()
to work we need this additional information...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
