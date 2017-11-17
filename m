Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CEAA220D4BF6
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 12:43:51 -0800 (PST)
Date: Fri, 17 Nov 2017 13:48:01 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [xfsprogs PATCH 2/2] xfs_io: add a new 'log_writes' command
Message-ID: <20171117204801.GA16597@linux.intel.com>
References: <20171117202524.24696-1-ross.zwisler@linux.intel.com>
 <20171117202524.24696-3-ross.zwisler@linux.intel.com>
 <84006b9c-90db-7eea-0bdc-b73da1bb1394@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <84006b9c-90db-7eea-0bdc-b73da1bb1394@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Nov 17, 2017 at 02:39:07PM -0600, Eric Sandeen wrote:
> On 11/17/17 2:25 PM, Ross Zwisler wrote:
> > Add a new 'log_writes' command to xfs_io so that we can add dm-log-writes
> > log marks via the external 'dmsetup' executable.  It's helpful to allow
> > users of xfs_io to adds these marks from within xfs_io instead of waiting
> > until after xfs_io exits because then they are able to replay the
> > dm-log-writes log up to immediately after another xfs_io operation such as
> > mwrite.  This isolates the log replay from other operations that happen as
> > part of xfs_io exiting (file handles being closed, mmaps being torn down,
> > etc.).  This also allows users to insert multiple marks between different
> > xfs_io commands.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> 
> Without reviewing in detail, what is the advantage of wrapping dmsetup
> into xfs_io?  My first inclination is that there is none at all, and
> xfstests can call dmsetup as easily as they can call xfs_io.  No?
> 
> -Eric

I commented on this a bit in the changelog for the 2nd patch:

It's helpful to allow users of xfs_io to adds these marks from within xfs_io
instead of waiting until after xfs_io exits because then they are able to
replay the dm-log-writes log up to immediately after another xfs_io operation
such as mwrite.  This isolates the log replay from other operations that
happen as part of xfs_io exiting (file handles being closed, mmaps being torn
down, etc.).  This also allows users to insert multiple marks between
different xfs_io commands.

I agree that the shell-out to dmsetup isn't awesome...  For the current test I
have written I think we can get away with just assuming that the xfs_io exit
stuff won't interact too heavily with the dm-log-writes log, and we could
potentially move the dmsetup call back into the fstest.  This is how I
initially had it, and moved it into the C program via shell-out in response to
Amir's feedback:

https://lists.01.org/pipermail/linux-nvdimm/2017-October/012976.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
