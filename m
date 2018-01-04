Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85A2D21CB2E3A
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 00:29:46 -0800 (PST)
Date: Thu, 4 Jan 2018 09:34:49 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 18/18] xfs, dax: wire up dax_flush_dma support via a
 new xfs_sync_dma helper
Message-ID: <20180104083449.GO2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407705701.38751.6157642918168721562.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180102230027.GV5858@dastard>
 <CAPcyv4gXxoLwZUyHYGUN2i71fjT_r=Mf+USYDLKwPGEYco+1PQ@mail.gmail.com>
 <20180103075112.GF30682@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180103075112.GF30682@dastard>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 03, 2018 at 06:51:12PM +1100, Dave Chinner wrote:
> > "Additionally we call it during the write operation, where aren't
> > concerned about exposing unallocated blocks but just want to provide
> > basic synchronization between a local writer and pNFS clients.  mmap
> > writes would also benefit from this sort of synchronization, but due
> > to the tricky locking rules in the page fault path we don't bother."
> > ---
> 
> The pnfs code  went into 3.20 (4.0, IIRC), whilst the XFS_MMAPLOCK
> code went into 4.1. So the pnfs code was written and tested by
> Christoph a long time before I added the XFS_MMAPLOCK, despite them
> landing only one release apart. We've never really gone back to look
> at this because there hasn't been a need until now....

I suspect we should drop the MMAPLOCK as well, but I'd need to re-read
and re-test the code.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
