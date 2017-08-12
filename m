Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6E4021D49100
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 19:29:49 -0700 (PDT)
Date: Fri, 11 Aug 2017 19:31:54 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 2/6] fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
Message-ID: <20170812023154.GJ24087@magnolia>
References: <150243355681.8777.14902834768886160223.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150243356799.8777.11625037981403766282.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170811232708.GT21024@dastard>
 <CAPcyv4gwgYfLviDJ5wJ5ZRKbX+fDkw_i7A+OwQyMM+MKXe8e=w@mail.gmail.com>
 <20170812003034.GX21024@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170812003034.GX21024@dastard>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Aug 12, 2017 at 10:30:34AM +1000, Dave Chinner wrote:
> On Fri, Aug 11, 2017 at 04:42:18PM -0700, Dan Williams wrote:
> > On Fri, Aug 11, 2017 at 4:27 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > On Thu, Aug 10, 2017 at 11:39:28PM -0700, Dan Williams wrote:
> > >> >From falloc.h:
> > >>
> > >>     FALLOC_FL_SEAL_BLOCK_MAP is used to seal (make immutable) all of the
> > >>     file logical-to-physical extent offset mappings in the file. The
> > >>     purpose is to allow an application to assume that there are no holes
> > >>     or shared extents in the file and that the metadata needed to find
> > >>     all the physical extents of the file is stable and can never be
> > >>     dirtied.
> > >>
> > >> For now this patch only permits setting the in-memory state of
> > >> S_IOMAP_IMMMUTABLE. Support for clearing and persisting the state is
> > >> saved for later patches.
> > >>
> > >> The implementation is careful to not allow the immutable state to change
> > >> while any process might have any established mappings. It reuses the
> > >> existing xfs_reflink_unshare() and xfs_alloc_file_space() to unshare
> > >> extents and fill all holes in the file. It then holds XFS_ILOCK_EXCL
> > >> while it validates the file is in the proper state and sets
> > >> S_IOMAP_IMMUTABLE.
> > >
> > > SO I've been thinking about this - I'm thinking that we need to
> > > separate the changes to the extent map from the action of sealing
> > > the extent map.
> > >
> > > That is, I have a need to freeze an extent map without any
> > > modification to it at all and breaking all the sharing and filling
> > > all the holes completely screws up the file layout I need to
> > > preserve. i.e. I want to be able to freeze the maps of a pair of
> > > reflinked files so I can use FIEMAP to query only the changed blocks
> > > and then read out the data in the private/changed blocks in the
> > > reflinked file. I only need a temporary seal (if we crash it goes
> > > away), so maybe there's another command modifier flag needed here,
> > > too.
> > >
> > > The DAX allocation requirements can be handled by a preallocation
> > > call to filll holes with zeros, followed by an unshare call to break
> > > all the COW mappings, and then the extent map can be sealed. If you
> > > need to check for holes after sealing, SEEK_HOLE will tell you what
> > > you need to know...
> > >
> > > My preference really is for each fallocate command to do just one
> > > thing - having the seal operation also modify the extent map
> > > means it's not useful for the use cases where we need the extent map
> > > to remain unmodified....
> > >
> > > Thoughts?
> > 
> > That does seem to better follow the principle of least surprise and
> > make the interface more composable. However, for the DAX case do we
> > now end up needing a SEEK_SHARED, or something similar to check that
> > we sealed the file without shared extents?

Well, fiemap/bmap will tell you (presumably after you confirm that the
file got sealed or whatever) if there are shared extents.

> Don't we have an inode attribute flag for that? There's definitely a
> flag in the on disk XFS inode to indicate that there are shared
> extents on the file.
> 
> Hmmmm - for some reason it's not exposed in FS_IOC_FSGETXATTR.
> Darrick? Any reason we don't expose the "this file has shared
> extents" flag to userspace? How are we checking that on-disk state
> in xfstests?
> 
> As it is, if we're adding an immutable extent flag, we've got to be
> able to query the immutable extent state of a file from userspace so
> I'm thinking that we'd need to expose it via the same interface that
> exposes the immutable flag. i.e. we could add the "shared extents
> present" flag to FS_IOC_FSGETXATTR at the same time...

We used to have a FSGETXATTR flag; iirc hch nak'd it during the review.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
