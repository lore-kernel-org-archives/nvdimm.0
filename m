Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 26AEC21D490E1
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 03:31:52 -0700 (PDT)
Date: Fri, 11 Aug 2017 12:34:10 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/5] fs, xfs: introduce S_IOMAP_IMMUTABLE
Message-ID: <20170811103410.GA13025@lst.de>
References: <150181368442.32119.13336247800141074356.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150181369070.32119.1019092252036976783.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170805094708.GB14930@lst.de> <20170807002502.GI21024@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170807002502.GI21024@dastard>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 07, 2017 at 10:25:02AM +1000, Dave Chinner wrote:
> We've always told people not to do those "horrible abuses" because
> of the TOCTOU race conditions inherent in getting accurate
> BMAP/FIEMAP information to userspace. However, immutable extent maps
> solve the TOCTOU problem and so removes the only *technical* barrier
> in the way of using extent maps to implement functionality such as
> userspace pNFS servers.

For pNFS block/scsi and my upcoming RDMA persistent memory layout?
Hell no - we'll need concepts we can't expose to userspace for them,
and to expose the advanced functionality people are asking for
(reflinks, atomic updates, no stale data exposure) immutable extents
maps won't work at all.

> The core requirement for a userspace pNFS block server to be able to
> safely export the block map of a file to remote clients is that the
> extent map is allocated and will not change while the client has
> been granted access to it.

No.  The core feature for the block layout is to create an unwrittent
extent that we can expose to the client for writing to it and only
marking it as written after commit by converting the extent list.

Now I know you're going to argue that this could work with pre-zeroing
the extents, but for and actual SCSI or NVMe device that will suck
badly.  And for RDMA-like layouts we don't even need the zeroing as
we can control client behavior a lot better because memory registrations
allow much more fine grained control.

Either way we a good notification from the file system to the server
when the extent map changes.

But for either blocks or rdma layout and implementation with the filesystem
in kernel space and the server in user is stupid as they need to interact
closely.  There is a good reason why all successful NFS products have
the server very tightly coupled to the file system, and a userspace <->
kernel barrier does not help with that.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
