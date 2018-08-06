Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
 [150.101.137.131])
 by ml01.01.org (Postfix) with ESMTP id 6C5FE21BADAB9
 for <linux-nvdimm@lists.01.org>; Mon,  6 Aug 2018 15:25:05 -0700 (PDT)
Date: Tue, 7 Aug 2018 08:25:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 0/2] ext4: fix DAX dma vs truncate/hole-punch
Message-ID: <20180806222501.GK2234@dastard>
References: <20180710191031.17919-1-ross.zwisler@linux.intel.com>
 <20180711081741.lmr44sp4cmt3f6um@quack2.suse.cz>
 <20180725222839.GA28304@linux.intel.com>
 <CAOxpaSWCT+XRtGxGQT_PVMcn79csMxbqb+cf4yycbV3eqjjnkQ@mail.gmail.com>
 <20180806035550.GE7395@dastard> <20180806154943.GA17666@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180806154943.GA17666@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, darrick.wong@oracle.com, linux-xfs <linux-xfs@vger.kernel.org>, Ross Zwisler <zwisler@kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lczerner@redhat.com, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 06, 2018 at 05:49:43PM +0200, Christoph Hellwig wrote:
> > > > This allows the direct I/O path to do I/O and raise & lower page->_refcount
> > > > while we're executing a truncate/hole punch.  This leads to us trying to free
> > > > a page with an elevated refcount.
> > 
> > I don't see how this is possible in XFS - maybe I'm missing
> > something, but "direct IO submission during truncate" is not
> > something that should ever be happening in XFS, DAX or not.
> 
> The pages involved in a direct I/O are not that of the file that
> the direct I/O read/write syscalls are called on, but those of the
> memory regions the direct I/O read/write syscalls operate on.
> Those pages could be file backed and undergo a truncate at the
> same time.

So let me get this straight. First, mmap() file A, then fault it all
in, then use the mmapped range of file A as the user buffer for
direct IO to file B, then concurrently truncate file A down so the
destination buffer for the file B dio will be beyond EOF and so we
need to invalidate it. But waiting for gup references in truncate
can race with other new page references via gup because gup does not
serialise access to the file backed pages in any way?

i.e. we hold no fs locks at all on file A when gup takes page
references during direct IO to file B unless we have to fault in the
page. this doesn't seem like a problem that the filesystem can
solve, but it does indicate to me a potential solution. i.e. we
take the MMAPLOCK during page faults, and so we can use that to
serialise gup against the invalidation in progress on file A.

i.e. it would seem to me that gup needs to refault file-backed pages
rather than just blindly take a reference to them so that it
triggers serialisation of the page references against in-progress
invalidation operations.

Thoughts?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
