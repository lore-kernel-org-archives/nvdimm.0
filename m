Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
 [150.101.137.145]) by ml01.01.org (Postfix) with ESMTP id 7F4921A1DFF
 for <linux-nvdimm@lists.01.org>; Wed,  3 Aug 2016 16:17:29 -0700 (PDT)
Date: Thu, 4 Aug 2016 09:16:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [4.8 hang] xfstests generic/361 hangs on dax enabled filesystems
Message-ID: <20160803231655.GY16044@dastard>
References: <20160803003354.GP16044@dastard>
 <20160803171127.GA15876@linux.intel.com>
 <20160803223713.GA22364@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803223713.GA22364@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 03, 2016 at 04:37:13PM -0600, Ross Zwisler wrote:
> On Wed, Aug 03, 2016 at 11:11:27AM -0600, Ross Zwisler wrote:
> > On Wed, Aug 03, 2016 at 10:33:54AM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > Just hit a reproducable hang in generic/361. Essentially this on
> > > a 8GB pmem device:
> > > 
> > > mkfs.xfs -f /dev/pmem1
> > > mount -o dax /dev/pmem1 /mnt/scratch
> > > xfs_io -f -c "truncate 1g" test.img
> > > losetup -f --show /mnt/scratch/test.img
> > > mkfs.xfs -f /dev/loop0
> > > 
> > > And the mkfs.xfs command hangs with a discard that never completes:
....
> > > This only reproduces when the underlying filesystem is mounted with
> > > -o dax, so there is a bad interaction with loop devices and DAX
> > > occurring somewhere. generic/361 is a recent test (committed june 14)
> > > so this probably hasn't actually been tested until now.
> > > 
> > > I haven't got time to look at this right now, hence the report.
> > 
> > Cool, thanks for the report.  I've reproduced this with linux/master, and the
> > test passes with v4.7.
> > 
> > Running a bisect...
> 
> This bisected to a commit to the block layer code.  I've sent a bug report to
> the author of the commit.

And the commit id is ...?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
