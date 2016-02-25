Return-Path: <linux-ext4-owner@vger.kernel.org>
Date: Thu, 25 Feb 2016 09:37:28 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2, ext4: Fix issue with missing journal entry
Message-ID: <20160225083728.GA24965@quack.suse.cz>
References: <1453921308-5544-1-git-send-email-ross.zwisler@linux.intel.com>
 <20160128131630.GI7726@quack.suse.cz>
 <20160128163211.GA19770@linux.intel.com>
 <20160224204446.GB13473@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160224204446.GB13473@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 24-02-16 13:44:46, Ross Zwisler wrote:
> On Thu, Jan 28, 2016 at 09:32:11AM -0700, Ross Zwisler wrote:
> > On Thu, Jan 28, 2016 at 02:16:30PM +0100, Jan Kara wrote:
> > > On Wed 27-01-16 12:01:48, Ross Zwisler wrote:
> > > > As it is currently written ext4_dax_mkwrite() assumes that the call into
> > > > __dax_mkwrite() will not have to do a block allocation so it doesn't create
> > > > a journal entry.  For a read that creates a zero page to cover a hole
> > > > followed by a write that actually allocates storage this is incorrect.  The
> > > > ext4_dax_mkwrite() -> __dax_mkwrite() -> __dax_fault() path calls
> > > > get_blocks() to allocate storage.
> > > > 
> > > > Fix this by having the ->page_mkwrite fault handler call ext4_dax_fault()
> > > > as this function already has all the logic needed to allocate a journal
> > > > entry and call __dax_fault().
> > > > 
> > > > Also update the ext2 fault handlers in this same way to remove duplicate
> > > > code and keep the logic between ext2 and ext4 the same.
> > > > 
> > > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > 
> > > Ah, ok, you are right. The patch looks good but Matthew is reworking the
> > > area more (so ext4_da_mkwrite() is likely to return) so it this worth it?
> > > Or do you expect Matthew's patches to land much later?
> > 
> > Yep, Matthew is in the process of reworking all of the DAX fault handling.
> > 
> > I was thinking that we might want to take this patch for v4.5, since it fixes
> > a bug that I'm guessing could lead to some sort of corruption (lack of a
> > journal entry entry for an allocating write), and then Matthew's reworks would
> > land in v4.6?
> 
> Hey Jan,
> 
> Looks like this patch didn't ever get merged for v4.5?  Is it still queued for
> v4.6?

Ted has been pretty busy lately and we probably didn't make it sufficiently
clear that he should pick up this patch. Ted, can you please pick up this
patch and push it to 4.5? Thanks. Feel free to add my:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
