Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 13 Oct 2015 10:07:12 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext2: Add locking for DAX faults
Message-ID: <20151013080712.GI17050@quack.suse.cz>
References: <1444428128-12200-1-git-send-email-ross.zwisler@linux.intel.com>
 <1444428128-12200-3-git-send-email-ross.zwisler@linux.intel.com>
 <20151011231443.GY27164@dastard>
 <20151012214135.GA24720@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151012214135.GA24720@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 12-10-15 15:41:35, Ross Zwisler wrote:
> On Mon, Oct 12, 2015 at 10:14:43AM +1100, Dave Chinner wrote:
> > On Fri, Oct 09, 2015 at 04:02:08PM -0600, Ross Zwisler wrote:
> > > Add locking to ensure that DAX faults are isolated from ext2 operations
> > > that modify the data blocks allocation for an inode.  This is intended to
> > > be analogous to the work being done in XFS by Dave Chinner:
> > > 
> > > http://www.spinics.net/lists/linux-fsdevel/msg90260.html
> > > 
> > > Compared with XFS the ext2 case is greatly simplified by the fact that ext2
> > > already allocates and zeros new blocks before they are returned as part of
> > > ext2_get_block(), so DAX doesn't need to worry about getting unmapped or
> > > unwritten buffer heads.
> > > 
> > > This means that the only work we need to do in ext2 is to isolate the DAX
> > > faults from inode block allocation changes.  I believe this just means that
> > > we need to isolate the DAX faults from truncate operations.
> > 
> > Why limit this just to DAX page faults?
> 
> Yep, I see that XFS uses the same locking to protect both DAX and non-DAX
> faults.  I'll add this protection to non-DAX ext2 faults as well.

Actually, since ext2 driver doesn't support punch hole, there is no need
for additional locking in non-DAX paths. So we can save some space in inode
and locking for that common case. So I'd prefer if we didn't add
unnecessary locking in those paths and just document that for non-DAX
faults using page lock and i_size check is enough. After all the main
usecase of ext2 driver these days is for people with tiny devices...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
