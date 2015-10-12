Return-Path: <linux-ext4-owner@vger.kernel.org>
Date: Mon, 12 Oct 2015 15:41:35 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 2/2] ext2: Add locking for DAX faults
Message-ID: <20151012214135.GA24720@linux.intel.com>
References: <1444428128-12200-1-git-send-email-ross.zwisler@linux.intel.com>
 <1444428128-12200-3-git-send-email-ross.zwisler@linux.intel.com>
 <20151011231443.GY27164@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151011231443.GY27164@dastard>
Sender: linux-ext4-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 12, 2015 at 10:14:43AM +1100, Dave Chinner wrote:
> On Fri, Oct 09, 2015 at 04:02:08PM -0600, Ross Zwisler wrote:
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
> 
> Why limit this just to DAX page faults?

Yep, I see that XFS uses the same locking to protect both DAX and non-DAX
faults.  I'll add this protection to non-DAX ext2 faults as well.

One quick question - it looks like that dax_pmd_fault() only grabs the
pagefault lock and updates the file_update_time() if the FAULT_WRITE_FLAG is
set. In xfs_filemap_pfn_mkwrite(), though, these two steps are taken for read
faults as well.  Is this intentional?
