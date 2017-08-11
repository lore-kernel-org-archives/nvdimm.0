Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
 [150.101.137.143])
 by ml01.01.org (Postfix) with ESMTP id 8B4632095E01B
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 16:24:51 -0700 (PDT)
Date: Sat, 12 Aug 2017 09:27:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/6] fs, xfs: introduce FALLOC_FL_SEAL_BLOCK_MAP
Message-ID: <20170811232708.GT21024@dastard>
References: <150243355681.8777.14902834768886160223.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150243356799.8777.11625037981403766282.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150243356799.8777.11625037981403766282.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 10, 2017 at 11:39:28PM -0700, Dan Williams wrote:
> >From falloc.h:
> 
>     FALLOC_FL_SEAL_BLOCK_MAP is used to seal (make immutable) all of the
>     file logical-to-physical extent offset mappings in the file. The
>     purpose is to allow an application to assume that there are no holes
>     or shared extents in the file and that the metadata needed to find
>     all the physical extents of the file is stable and can never be
>     dirtied.
> 
> For now this patch only permits setting the in-memory state of
> S_IOMAP_IMMMUTABLE. Support for clearing and persisting the state is
> saved for later patches.
> 
> The implementation is careful to not allow the immutable state to change
> while any process might have any established mappings. It reuses the
> existing xfs_reflink_unshare() and xfs_alloc_file_space() to unshare
> extents and fill all holes in the file. It then holds XFS_ILOCK_EXCL
> while it validates the file is in the proper state and sets
> S_IOMAP_IMMUTABLE.

SO I've been thinking about this - I'm thinking that we need to
separate the changes to the extent map from the action of sealing
the extent map.

That is, I have a need to freeze an extent map without any
modification to it at all and breaking all the sharing and filling
all the holes completely screws up the file layout I need to
preserve. i.e. I want to be able to freeze the maps of a pair of
reflinked files so I can use FIEMAP to query only the changed blocks
and then read out the data in the private/changed blocks in the
reflinked file. I only need a temporary seal (if we crash it goes
away), so maybe there's another command modifier flag needed here,
too.

The DAX allocation requirements can be handled by a preallocation
call to filll holes with zeros, followed by an unshare call to break
all the COW mappings, and then the extent map can be sealed. If you
need to check for holes after sealing, SEEK_HOLE will tell you what
you need to know...

My preference really is for each fallocate command to do just one
thing - having the seal operation also modify the extent map
means it's not useful for the use cases where we need the extent map
to remain unmodified....

Thoughts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
