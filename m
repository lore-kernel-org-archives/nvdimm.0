Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmailnode02.adl6.internode.on.net
 (ipmailnode02.adl6.internode.on.net [150.101.137.148])
 by ml01.01.org (Postfix) with ESMTP id 33A9221CEB108
 for <linux-nvdimm@lists.01.org>; Wed, 13 Sep 2017 14:59:29 -0700 (PDT)
Date: Thu, 14 Sep 2017 08:01:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Message-ID: <20170913220108.GX10621@dastard>
References: <20170908152805.GA16646@linux.intel.com>
 <20170908212153.14880-1-ross.zwisler@linux.intel.com>
 <20170912064411.GR10621@dastard>
 <20170912153820.GA5000@linux.intel.com>
 <20170912234729.GW10621@dastard>
 <20170913144215.GA12395@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170913144215.GA12395@linux.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-nvdimm@lists.01.org, "Darrick J.  Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 13, 2017 at 08:42:15AM -0600, Ross Zwisler wrote:
> On Wed, Sep 13, 2017 at 09:47:29AM +1000, Dave Chinner wrote:
> 
> <>
> 
> > I think similar concerns exist with using perf, too....
> 
> I though that using perf addressed both concerns?
> 
> > > > So what happens when the user is already tracing the test to
> > > > find a bug and the test turns all their tracing off?
> 
> By using perf we isolate our tracing from whatever other tracing is happening
> in the system.  So, unlike the case where we were messing with a system-wide
> ftrace knob, we run perf on our executable, and someone else can run perf on
> their executable, and they don't collide.

Yes, you've addressed the "gets inteh way of other tracing concern,
but it's doesn't address the "it's an ugly way to determine a
feature is active" concerns. It also creates an implicit stable
tracepoint out of whatever you are looking at. i.e. that tracepoint
can't go away, nor can it change functionality once a userspace app
depends on it's current semantics to function correctly.

And....

> > > > Regardless of this screwing up developer bug triage, do we really
> > > > want to add a dependency on kernel tracing into the test harness?
> 
> Yep, you're right that this adds a dependency on perf.  But unfortunately,
> without using either perf or ftrace, I don't know of a way to detect whether
> or not DAX is actually being used.  Can you think of another way?

... if there isn't a programmatic interface to tell applications
that DAX is in use, then perhaps we're missing a formal userspace
API that we should have, yes?

> I tried to do this correctly and just skip the test with _notrun
> if perf isn't available on the host system.  This is the same
> thing that happens if you are missing other dependencies for a
> test (some other command (chacl, getfattr, setfattr) not present,
> quota tools not installed, required users not present, etc).

Sure, but if we have user configurable functionality, then using
something like ftrace/perf to discover if it's turned is indicative
of a bigger problem. i.e. that the user can't tell if the
functionality they turned on/off is actually active or not.

That's a bug that needs fixing, not working around with
ftrace/perf in xfstests...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
