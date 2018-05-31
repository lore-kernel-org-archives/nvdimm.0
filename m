Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 32E772097175C
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 13:41:23 -0700 (PDT)
Date: Thu, 31 May 2018 14:41:22 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2 2/7] dax: change bdev_dax_supported() to support
 boolean returns
Message-ID: <20180531204122.GC28256@linux.intel.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-3-ross.zwisler@linux.intel.com>
 <20180529212510.GJ30110@magnolia>
 <20180529220114.GA13948@linux.intel.com>
 <20180531191332.GB7825@magnolia>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180531191332.GB7825@magnolia>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 31, 2018 at 12:13:32PM -0700, Darrick J. Wong wrote:
> On Tue, May 29, 2018 at 04:01:14PM -0600, Ross Zwisler wrote:
> > On Tue, May 29, 2018 at 02:25:10PM -0700, Darrick J. Wong wrote:
> > > On Tue, May 29, 2018 at 01:51:01PM -0600, Ross Zwisler wrote:
> > > > From: Dave Jiang <dave.jiang@intel.com>
> > > > 
> > > > The function return values are confusing with the way the function is
> > > > named. We expect a true or false return value but it actually returns
> > > > 0/-errno.  This makes the code very confusing. Changing the return values
> > > > to return a bool where if DAX is supported then return true and no DAX
> > > > support returns false.
> > > > 
> > > > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> > > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > > 
> > > Looks ok, do you want me to pull the first two patches through the xfs
> > > tree?
> > > 
> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Thanks for the review.
> > 
> > I'm not sure what's best.  If you do that then Mike will need to have a DM
> > branch for the rest of the series based on your stable commits, yea?
> > 
> > Mike what would you prefer?
> 
> I /was/ about to say that I would pull in the first two patches, but now
> I can't get xfs to mount with pmem at all, and have no way of testing
> this...?
> 
> # echo 'file drivers/dax/* +p' > /sys/kernel/debug/dynamic_debug/control
> # mount /dev/pmem3 -o rtdev=/dev/pmem4,dax /mnt
> # dmesg
> <snip>
> SGI XFS with ACLs, security attributes, realtime, scrub, debug enabled
> XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> pmem3: error: dax support not enabled
> pmem4: error: dax support not enabled
> XFS (pmem3): DAX unsupported by block device. Turning off DAX.
> XFS (pmem3): Mounting V5 Filesystem
> XFS (pmem3): Ending clean mount

This same sequence worked fine in my QEMU setup.

My guess is the issue is that your namespaces are in raw mode:

# ndctl list
[
  {
    "dev":"namespace1.0",
    "mode":"raw",			<< this
    "size":18119393280,
    "sector_size":512,
    "blockdev":"pmem1",
    "numa_node":0
  },
  {
    "dev":"namespace0.0",
    "mode":"raw",			<< this
    "size":18119393280,
    "sector_size":512,
    "blockdev":"pmem0",
    "numa_node":0
  }
]

If so, you can solve this by putting them in fsdax mode with ndctl:

# ndctl create-namespace -f -e namespace0.0 --mode=fsdax
{
  "dev":"namespace0.0",
  "mode":"fsdax",
  "size":"16.61 GiB (17.83 GB)",
  "uuid":"4c193c83-c031-41d4-8f96-2ff5c7b59c69",
  "raw_uuid":"2f785f09-717a-4a5e-9e9d-88d489ef1030",
  "sector_size":512,
  "blockdev":"pmem0",
  "numa_node":0
}

# ndctl create-namespace -f -e namespace1.0 --mode=fsdax
{
  "dev":"namespace1.0",
  "mode":"fsdax",
  "size":"16.61 GiB (17.83 GB)",
  "uuid":"39ec9cc4-a7ef-4f99-8354-60105543bf47",
  "raw_uuid":"403fae76-d4f8-4bed-9a3f-ef40924762be",
  "sector_size":512,
  "blockdev":"pmem1",
  "numa_node":0
}

If that doesn't fix it for you, ping me on freenode and we'll figure it out.

Thanks,
- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
