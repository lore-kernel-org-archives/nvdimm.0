Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
 [150.101.137.143]) by ml01.01.org (Postfix) with ESMTP id 8F30A81C5E
 for <linux-nvdimm@lists.01.org>; Thu, 24 Nov 2016 18:49:22 -0800 (PST)
Date: Fri, 25 Nov 2016 13:49:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/6] dax: add tracepoint infrastructure, PMD tracing
Message-ID: <20161125024918.GX31101@dastard>
References: <1479926662-21718-1-git-send-email-ross.zwisler@linux.intel.com>
 <1479926662-21718-4-git-send-email-ross.zwisler@linux.intel.com>
 <20161124173220.GR1555@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161124173220.GR1555@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 24, 2016 at 05:32:20PM +0000, Al Viro wrote:
> On Wed, Nov 23, 2016 at 11:44:19AM -0700, Ross Zwisler wrote:
> > Tracepoints are the standard way to capture debugging and tracing
> > information in many parts of the kernel, including the XFS and ext4
> > filesystems.  Create a tracepoint header for FS DAX and add the first DAX
> > tracepoints to the PMD fault handler.  This allows the tracing for DAX to
> > be done in the same way as the filesystem tracing so that developers can
> > look at them together and get a coherent idea of what the system is doing.
> 
> 	It also has one hell of potential for becoming a massive nuisance.
> Keep in mind that if any userland code becomes dependent on those - that's it,
> they have become parts of stable userland ABI and are to be maintained
> indefinitely.  Don't expect "tracepoints are special case" to prevent that.

I call bullshit just like I always do when someone spouts this
"tracepoints are stable ABI" garbage.

If we want to provide stable tracepoints, then we need to /create a
stable tracepoint API/ and convert all the tracepoints that /need
to be stable/ to use it. Then developers only need to be careful
about modifying code around the /explicitly stable/ tracepoints and
we avoid retrospectively locking the kernel implementation into a
KABI so tight we can't do anything anymore....

Quite frankly, anyone that wants to stop us from
adding/removing/changing tracepoints or the code that they are
reporting information about "because ABI" can go take a long walk
off a short cliff.  Diagnostic tracepoints are not part of the
stable ABI. End of story.

> 	So treat anything you add in that manner as potential stable ABI
> you might have to keep around forever.  It's *not* a glorified debugging
> printk.

trace_printk() is the glorified debugging printk for tracing, not
trace events.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
