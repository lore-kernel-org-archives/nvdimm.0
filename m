Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F82120945C0B
 for <linux-nvdimm@lists.01.org>; Fri,  8 Sep 2017 08:25:15 -0700 (PDT)
Date: Fri, 8 Sep 2017 09:28:05 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/2] xfs: always use DAX if mount option is used
Message-ID: <20170908152805.GA16646@linux.intel.com>
References: <20170907210832.17969-1-ross.zwisler@linux.intel.com>
 <20170907210832.17969-2-ross.zwisler@linux.intel.com>
 <20170908072027.GA27725@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170908072027.GA27725@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 08, 2017 at 12:20:28AM -0700, Christoph Hellwig wrote:
> On Thu, Sep 07, 2017 at 03:08:31PM -0600, Ross Zwisler wrote:
> > Before support for the per-inode DAX flag was disabled the XFS the code had
> > an issue where the user couldn't reliably tell whether or not DAX was being
> > used to service page faults and I/O when the DAX mount option was used.  In
> > this case each inode within the mounted filesystem started with S_DAX set
> > due to the mount option, but it could be cleared if someone touched the
> > individual inode flag.
> 
> Looks good, but can you please add a testcase to xfstests for this?

Hmm...aside from looking at tracepoints, I'm not sure how to detect whether or
not S_DAX is actually being used for an inode.  I don't see any other xfstests
that try and look at the trace buffer, but I guess that could work.

Do you know of a better way to detect this test failure/success?

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks for the review!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
