Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmailnode02.adl6.internode.on.net
 (ipmailnode02.adl6.internode.on.net [150.101.137.148])
 by ml01.01.org (Postfix) with ESMTP id 2DE1521E87993
 for <linux-nvdimm@lists.01.org>; Wed, 13 Sep 2017 17:37:58 -0700 (PDT)
Date: Thu, 14 Sep 2017 10:40:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add regression test for DAX mount option usage
Message-ID: <20170914004038.GZ10621@dastard>
References: <20170908152805.GA16646@linux.intel.com>
 <20170908212153.14880-1-ross.zwisler@linux.intel.com>
 <20170912064411.GR10621@dastard>
 <20170912153820.GA5000@linux.intel.com>
 <20170912234729.GW10621@dastard>
 <20170913144215.GA12395@linux.intel.com>
 <20170913220108.GX10621@dastard>
 <CAPcyv4hGSLQS1GmTYtzMCBDDNNuK1nLRKme6e-Vpx8_pyaJwrg@mail.gmail.com>
 <20170913233438.GY10621@dastard>
 <CAPcyv4hYc5=44vyyL+_hW9qpq54izKMMEOEQq1yHHkZVv-MR0w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hYc5=44vyyL+_hW9qpq54izKMMEOEQq1yHHkZVv-MR0w@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 13, 2017 at 05:28:39PM -0700, Dan Williams wrote:
> On Wed, Sep 13, 2017 at 4:34 PM, Dave Chinner <david@fromorbit.com> wrote:
> > /me shrugs
> >
> > I just don't like the concept of using tracepoints to as a
> > definitive diagnostic test for something working because it'll break
> > when the kernel implementation and tracepoints change. So while we
> > can probe for perf being present, we can't probe whether the
> > tracepoint we need behaves as the test expects it to...
> 
> That concern makes sense.
> 
> We handle that it a crude way in the libnvdimm unit tests by hard
> coding a required minimum kernel version and rolling a test forward to
> depend on a new kernel when assumptions about the kernel-internals
> change. The tests also inject out-of-tree kernel modules that let us
> go after specific kernel internal behavior. With this approach we
> don't end up creating userspace ABI since the test explicitly loads
> out-of-tree modules.

That's horrible. OT, but how are distros or anyone backporting
libnvdimm fixes and features supposed to test their kernels work
correctly with such a test harness?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
