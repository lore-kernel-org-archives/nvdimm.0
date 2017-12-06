Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C00C220FB319
 for <linux-nvdimm@lists.01.org>; Tue,  5 Dec 2017 20:36:58 -0800 (PST)
Date: Tue, 5 Dec 2017 21:41:29 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [xfsprogs PATCH v2 3/3] xfs_io: add a new 'log_writes' command
Message-ID: <20171206044129.GB31657@linux.intel.com>
References: <20171205235651.17102-1-ross.zwisler@linux.intel.com>
 <20171205235651.17102-4-ross.zwisler@linux.intel.com>
 <20171206002946.GD5858@dastard>
 <20171206043813.GA31657@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171206043813.GA31657@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 05, 2017 at 09:38:13PM -0700, Ross Zwisler wrote:
> On Wed, Dec 06, 2017 at 11:29:46AM +1100, Dave Chinner wrote:
> > On Tue, Dec 05, 2017 at 04:56:51PM -0700, Ross Zwisler wrote:
> > > Add a new 'log_writes' command to xfs_io so that we can add dm-log-writes
> > > log marks.  It's helpful to allow users of xfs_io to adds these marks from
> > > within xfs_io instead of waiting until after xfs_io exits because then they
> > > are able to replay the dm-log-writes log up to immediately after another
> > > xfs_io operation such as mwrite.  This isolates the log replay from other
> > > operations that happen as part of xfs_io exiting (file handles being
> > > closed, mmaps being torn down, etc.).  This also allows users to insert
> > > multiple marks between different xfs_io commands.
> > > 
> > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > Suggested-by: Dave Chinner <david@fromorbit.com>
> > 
> > having just looked at the xfs_io mess, this new command needs to set
> > "exitcode = 1" on failure. I haven't looked at anything else in the
> > patch.
> 
> Ah, yea, I did think it was odd that when hitting errors in xfs_io it always
> still returned 0.  I'll fix up for the next version.  Is someone else working
> on making the rest of the error cases in xfs_io return 1 as well, or should I
> throw that at the front of the series?

Ah, nevermind, I found your patch that sets exitcode throughout xfs_io.  I'll
fix up for the next version, thanks for the review.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
