Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Wed, 14 Oct 2015 09:31:38 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 2/2] ext2: Add locking for DAX faults
Message-ID: <20151014153138.GA12470@linux.intel.com>
References: <1444775137-23685-1-git-send-email-ross.zwisler@linux.intel.com>
 <1444775137-23685-3-git-send-email-ross.zwisler@linux.intel.com>
 <20151014085119.GB23758@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151014085119.GB23758@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 14, 2015 at 10:51:19AM +0200, Jan Kara wrote:
> On Tue 13-10-15 16:25:37, Ross Zwisler wrote:
> > Add locking to ensure that DAX faults are isolated from ext2 operations
> > that modify the data blocks allocation for an inode.  This is intended to
> > be analogous to the work being done in XFS by Dave Chinner:
> > 
> > http://www.spinics.net/lists/linux-fsdevel/msg90260.html
> > 
> > Compared with XFS the ext2 case is greatly simplified by the fact that ext2
> > already allocates and zeros new blocks before they are returned as part of
> > ext2_get_block(), so DAX doesn't need to worry about getting unmapped or
> > unwritten buffer heads.
> > 
> > This means that the only work we need to do in ext2 is to isolate the DAX
> > faults from inode block allocation changes.  I believe this just means that
> > we need to isolate the DAX faults from truncate operations.
> > 
> > The newly introduced dax_sem is intended to replicate the protection
> > offered by i_mmaplock in XFS.  In addition to truncate the i_mmaplock also
> > protects XFS operations like hole punching, fallocate down, extent
> > manipulation IOCTLS like xfs_ioc_space() and extent swapping.  Truncate is
> > the only one of these operations supported by ext2.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> The patch looks good to me. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.com>
> 
> Or I can push the patch through my tree as it seems to be independent of
> any other changes, am I right?
> 
> 								Honza

Yep, it is independent of other patches.  It'd be great if you pushed it up
through your tree, thanks!
