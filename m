Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C9EDD21D492E6
 for <linux-nvdimm@lists.01.org>; Wed, 13 Sep 2017 07:39:18 -0700 (PDT)
Date: Wed, 13 Sep 2017 08:42:15 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Message-ID: <20170913144215.GA12395@linux.intel.com>
References: <20170908152805.GA16646@linux.intel.com>
 <20170908212153.14880-1-ross.zwisler@linux.intel.com>
 <20170912064411.GR10621@dastard>
 <20170912153820.GA5000@linux.intel.com>
 <20170912234729.GW10621@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170912234729.GW10621@dastard>
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
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, linux-nvdimm@lists.01.org, "Darrick J.  Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 13, 2017 at 09:47:29AM +1000, Dave Chinner wrote:

<>

> I think similar concerns exist with using perf, too....

I though that using perf addressed both concerns?

> > > So what happens when the user is already tracing the test to
> > > find a bug and the test turns all their tracing off?

By using perf we isolate our tracing from whatever other tracing is happening
in the system.  So, unlike the case where we were messing with a system-wide
ftrace knob, we run perf on our executable, and someone else can run perf on
their executable, and they don't collide.

> > > Regardless of this screwing up developer bug triage, do we really
> > > want to add a dependency on kernel tracing into the test harness?

Yep, you're right that this adds a dependency on perf.  But unfortunately,
without using either perf or ftrace, I don't know of a way to detect whether
or not DAX is actually being used.  Can you think of another way?

I tried to do this correctly and just skip the test with _notrun if perf isn't
available on the host system.  This is the same thing that happens if you are
missing other dependencies for a test (some other command (chacl, getfattr,
setfattr) not present, quota tools not installed, required users not present,
etc).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
