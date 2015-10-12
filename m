Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151012232427.GH27164@dastard>
References: <1444428128-12200-1-git-send-email-ross.zwisler@linux.intel.com>
	<1444428128-12200-3-git-send-email-ross.zwisler@linux.intel.com>
	<20151011231443.GY27164@dastard>
	<20151012214135.GA24720@linux.intel.com>
	<20151012232427.GH27164@dastard>
Date: Tue, 13 Oct 2015 00:35:44 +0100
Message-ID: <CANpvso6auD-NWsEYw10FNSviusA63tyK785usG=9R3r+a3Rirg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ext2: Add locking for DAX faults
From: Eric Curtin <ericcurtin17@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Kernel development list <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 13 October 2015 at 00:24, Dave Chinner <david@fromorbit.com> wrote:
>
> On Mon, Oct 12, 2015 at 03:41:35PM -0600, Ross Zwisler wrote:
> > On Mon, Oct 12, 2015 at 10:14:43AM +1100, Dave Chinner wrote:
> > > On Fri, Oct 09, 2015 at 04:02:08PM -0600, Ross Zwisler wrote:
> > > > Add locking to ensure that DAX faults are isolated from ext2 operations
> > > > that modify the data blocks allocation for an inode.  This is intended to
> > > > be analogous to the work being done in XFS by Dave Chinner:
> > > >
> > > > http://www.spinics.net/lists/linux-fsdevel/msg90260.html
> > > >
> > > > Compared with XFS the ext2 case is greatly simplified by the fact that ext2
> > > > already allocates and zeros new blocks before they are returned as part of
> > > > ext2_get_block(), so DAX doesn't need to worry about getting unmapped or
> > > > unwritten buffer heads.
> > > >
> > > > This means that the only work we need to do in ext2 is to isolate the DAX
> > > > faults from inode block allocation changes.  I believe this just means that
> > > > we need to isolate the DAX faults from truncate operations.
> > >
> > > Why limit this just to DAX page faults?
> >
> > Yep, I see that XFS uses the same locking to protect both DAX and non-DAX
> > faults.  I'll add this protection to non-DAX ext2 faults as well.
> >
> > One quick question - it looks like that dax_pmd_fault() only grabs the
> > pagefault lock and updates the file_update_time() if the FAULT_WRITE_FLAG is
> > set. In xfs_filemap_pfn_mkwrite(), though, these two steps are taken for read
> > faults as well.  Is this intentional?
>
> xfs_filemap_pfn_mkwrite() should not be called for read faults.
> We've already had to have a fault that maps the page to pfn for us
> to get a pfn based fault, and hence that code is correct.
>
> Or are you talking about xfs_filemap_pmd_fault()? In which case, I
> refer you to the commit log and it should be obvious that it was
> committed without me even looking at it.  I have another patch in my
> current series for 4.4 that will fix this.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Hi Ross,

For all those int ret declarations. Why not declare and initialize all
on the same line?

Regards,

Eric
