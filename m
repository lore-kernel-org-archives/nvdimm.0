Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D8781A1DF7
 for <linux-nvdimm@lists.01.org>; Fri,  7 Oct 2016 00:24:06 -0700 (PDT)
Date: Fri, 7 Oct 2016 09:24:02 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 10/12] dax: add struct iomap based DAX PMD support
Message-ID: <20161007072402.GB16260@quack2.suse.cz>
References: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475189370-31634-11-git-send-email-ross.zwisler@linux.intel.com>
 <20161003105949.GP6457@quack2.suse.cz>
 <20161003210557.GA28177@linux.intel.com>
 <20161006213424.GA4569@linux.intel.com>
 <20161007025833.GA2934@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161007025833.GA2934@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu 06-10-16 20:58:33, Ross Zwisler wrote:
> On Thu, Oct 06, 2016 at 03:34:24PM -0600, Ross Zwisler wrote:
> > Interesting - adding iomap_end() calls to the DAX PTE fault handler causes an
> > AA deadlock because we try and retake ei->dax_sem.  We take dax_sem in
> > ext2_dax_fault() before calling into the DAX code, then if we end up going
> > through the error path in ext2_iomap_end(), we call 
> >   ext2_write_failed()
> >     ext2_truncate_blocks()
> >       dax_sem_down_write()
> > 
> > Where we try and take dax_sem again.  This error path is really only valid for
> > I/O operations, but we happen to call it for page faults because 'written' in
> > ext2_iomap_end() is just 0.
> > 
> > So...how should we handle this?  A few ideas:
> > 
> > 1) Just continue to omit the calls to iomap_end() in the DAX page fault
> > handlers for now, and add them when there is useful work to be done in one of
> > the filesystems.
> > 
> > 2) Add an IOMAP_FAULT flag to the flags passed into iomap_begin() and
> > iomap_end() so make it explicit that we are calling as part of a fault handler
> > and not an I/O operation, and use this to adjust the error handling in
> > ext2_iomap_end().
> > 
> > 3) Just work around the existing error handling in ext2_iomap_end() by either
> > unsetting IOMAP_WRITE or by setting 'written' to the size of the fault.
> > 
> > For #2 or #3, probably add a comment explaining the deadlock and why we need
> > to never call ext2_write_failed() while handling a page fault.
> > 
> > Thoughts?
> 
> Never mind, #3 it is, I think it was just a plain bug to call iomap_end() with
> 'length' != 'written'.

Yup, that's what I'd think as well.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
