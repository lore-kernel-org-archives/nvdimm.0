From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/6] xfs: Set BH_New for allocated DAX blocks in
 __xfs_get_blocks()
Date: Mon, 3 Oct 2016 16:42:46 +0200
Message-ID: <20161003144246.GA14183@quack2.suse.cz>
References: <1474994615-29553-1-git-send-email-jack@suse.cz>
 <1474994615-29553-5-git-send-email-jack@suse.cz>
 <20160927170118.GA15908@infradead.org>
 <20160927171707.GA30327@quack2.suse.cz>
 <20160928021350.GA11309@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160928021350.GA11309@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-Id: linux-nvdimm@lists.01.org

On Tue 27-09-16 19:13:50, Christoph Hellwig wrote:
> On Tue, Sep 27, 2016 at 07:17:07PM +0200, Jan Kara wrote:
> > OK, the changelog is stale but I actually took care to integrate this with
> > your iomap patches and for the new invalidation code in iomap_dax_actor()
> > to work we need this additional information...
> 
> It's not just the changelogs (which will need updates on more than this
> patch), but also the content.  We're not using get_blocks for DAX
> anymore, so this patch should not be needed anymore.

Ah, you are right. After reading the code again this patch is not needed
anymore because xfs_file_iomap_begin() returns IOMAP_F_NEW whenever we
allocated block regardless whether it was zeroed-out or not. But if I get it
right, all the IS_DAX checks in __xfs_get_blocks() can be dropped now, cannot
they?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
