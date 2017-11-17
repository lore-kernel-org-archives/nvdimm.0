Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sandeen.net (sandeen.net [63.231.237.45])
 by ml01.01.org (Postfix) with ESMTP id 9E09D220D4C03
 for <linux-nvdimm@lists.01.org>; Fri, 17 Nov 2017 12:34:58 -0800 (PST)
Subject: Re: [xfsprogs PATCH 2/2] xfs_io: add a new 'log_writes' command
References: <20171117202524.24696-1-ross.zwisler@linux.intel.com>
 <20171117202524.24696-3-ross.zwisler@linux.intel.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <84006b9c-90db-7eea-0bdc-b73da1bb1394@sandeen.net>
Date: Fri, 17 Nov 2017 14:39:07 -0600
MIME-Version: 1.0
In-Reply-To: <20171117202524.24696-3-ross.zwisler@linux.intel.com>
Content-Language: en-US
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, fstests <fstests@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 11/17/17 2:25 PM, Ross Zwisler wrote:
> Add a new 'log_writes' command to xfs_io so that we can add dm-log-writes
> log marks via the external 'dmsetup' executable.  It's helpful to allow
> users of xfs_io to adds these marks from within xfs_io instead of waiting
> until after xfs_io exits because then they are able to replay the
> dm-log-writes log up to immediately after another xfs_io operation such as
> mwrite.  This isolates the log replay from other operations that happen as
> part of xfs_io exiting (file handles being closed, mmaps being torn down,
> etc.).  This also allows users to insert multiple marks between different
> xfs_io commands.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Suggested-by: Dave Chinner <david@fromorbit.com>

Without reviewing in detail, what is the advantage of wrapping dmsetup
into xfs_io?  My first inclination is that there is none at all, and
xfstests can call dmsetup as easily as they can call xfs_io.  No?

-Eric
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
