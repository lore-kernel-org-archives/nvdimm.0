Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A50E020945BF7
 for <linux-nvdimm@lists.01.org>; Tue, 12 Sep 2017 08:35:28 -0700 (PDT)
Date: Tue, 12 Sep 2017 09:38:20 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Message-ID: <20170912153820.GA5000@linux.intel.com>
References: <20170908152805.GA16646@linux.intel.com>
 <20170908212153.14880-1-ross.zwisler@linux.intel.com>
 <20170912064411.GR10621@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170912064411.GR10621@dastard>
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

On Tue, Sep 12, 2017 at 04:44:11PM +1000, Dave Chinner wrote:
> On Fri, Sep 08, 2017 at 03:21:53PM -0600, Ross Zwisler wrote:
> > This adds a regression test for the following kernel patch:
> > 
> >   xfs: always use DAX if mount option is used
> > 
> > This test will also pass with kernel v4.14-rc1 and beyond because the XFS
> > DAX I/O mount option has been disabled (but not removed), so the
> > "chattr -x" to turn off DAX doesn't actually do anything.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> .....
> > +pgsize=`$here/src/feature -s`
> > +
> > +# disable tracing, clear the existing trace buffer and turn on dax tracepoints
> > +echo 0 > /sys/kernel/debug/tracing/tracing_on
> > +echo > /sys/kernel/debug/tracing/trace
> > +echo 1 > /sys/kernel/debug/tracing/events/fs_dax/enable
> > +
> > +# enable tracing for our one mmap I/O, then see if dax was used
> > +echo 1 > /sys/kernel/debug/tracing/tracing_on
> > +xfs_io  -t -c "truncate $pgsize" \
> > +	-c "chattr -x" \
> > +	-c "mmap -r 0 $pgsize" -c "mread 0 $pgsize" -c "munmap" \
> > +	-f $SCRATCH_MNT/testfile >> $seqres.full
> > +echo 0 > /sys/kernel/debug/tracing/tracing_on
> 
> So what happens when the user is already tracing the test to
> find a bug and the test turns all their tracing off?
> 
> Regardless of this screwing up developer bug triage, do we really
> want to add a dependency on kernel tracing into the test harness?

Yep, these are both valid concerns.  I ended up trying to get around both of
them by using perf instead in my v2, as suggested by Dan:

https://www.spinics.net/lists/linux-xfs/msg10420.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
