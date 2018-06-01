Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmailnode02.adl6.internode.on.net
 (ipmailnode02.adl6.internode.on.net [150.101.137.148])
 by ml01.01.org (Postfix) with ESMTP id 5D4D0210E0F9F
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 19:24:20 -0700 (PDT)
Date: Fri, 1 Jun 2018 12:24:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/7] dax: change bdev_dax_supported() to support
 boolean returns
Message-ID: <20180601022418.GR10363@dastard>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-3-ross.zwisler@linux.intel.com>
 <20180529212510.GJ30110@magnolia>
 <20180529220114.GA13948@linux.intel.com>
 <20180531191332.GB7825@magnolia> <20180601012657.GQ10363@dastard>
 <CAPcyv4g6dv9sG9dR-iY+aEfSi2r3ey1dXGbX-nexKsN72t0QMw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g6dv9sG9dR-iY+aEfSi2r3ey1dXGbX-nexKsN72t0QMw@mail.gmail.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 31, 2018 at 06:57:33PM -0700, Dan Williams wrote:
> On Thu, May 31, 2018 at 6:26 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, May 31, 2018 at 12:13:32PM -0700, Darrick J. Wong wrote:
> >> On Tue, May 29, 2018 at 04:01:14PM -0600, Ross Zwisler wrote:
> >> > On Tue, May 29, 2018 at 02:25:10PM -0700, Darrick J. Wong wrote:
> >> > > On Tue, May 29, 2018 at 01:51:01PM -0600, Ross Zwisler wrote:
> >> > > > From: Dave Jiang <dave.jiang@intel.com>
> >> > > >
> >> > > > The function return values are confusing with the way the function is
> >> > > > named. We expect a true or false return value but it actually returns
> >> > > > 0/-errno.  This makes the code very confusing. Changing the return values
> >> > > > to return a bool where if DAX is supported then return true and no DAX
> >> > > > support returns false.
> >> > > >
> >> > > > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >> > > > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> >> > >
> >> > > Looks ok, do you want me to pull the first two patches through the xfs
> >> > > tree?
> >> > >
> >> > > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> >> >
> >> > Thanks for the review.
> >> >
> >> > I'm not sure what's best.  If you do that then Mike will need to have a DM
> >> > branch for the rest of the series based on your stable commits, yea?
> >> >
> >> > Mike what would you prefer?
> >>
> >> I /was/ about to say that I would pull in the first two patches, but now
> >> I can't get xfs to mount with pmem at all, and have no way of testing
> >> this...?
> >
> > I have similar problems, too, but:
> >
> > $ ndctl list
> > [
> >   {
> >     "dev":"namespace1.0",
> >     "mode":"raw",
> >     "size":8589934592,
> >     "sector_size":512,
> >     "blockdev":"pmem1"
> >   },
> >   {
> >     "dev":"namespace0.0",
> >     "mode":"raw",
> >     "size":8589934592,
> >     "sector_size":512,
> >     "blockdev":"pmem0"
> >   }
> > ]
> > $ sudo ndctl create-namespace -f -e namespace0.0 --mode=fsdax
> >   Error: operation failed, region0 fsdax mode not available
> >
> > failed to reconfigure namespace: Invalid argument
> > $
> >
> > I can't make head or tail of what is going wrong here - how am I
> > supposed to debug this and get it working again?
> >
> > FWIW, XFS+DAX used to just work on this setup (I hadn't even
> > installed ndctl until this morning!) but after changing the kernel
> > it no longer works. That would make it a regression, yes?
> 
> This commit caused the behavior change:
> 
>     569d0365f571 dax: require 'struct page' by default for filesystem dax
> 
> The justification is in that patch, but the short summary is we killed
> off "pageless" dax because it had so many incomplete holes and
> surprise behaviors. It needed to die on the path to making dax not
> experimental, i.e. to close safety holes, and be feature complete for
> all the ways userspace expects to use mappings (direct-io, fork,
> poison handling, etc).
> 
> I suspect your kernel does not have CONFIG_ZONE_DEVICE enabled which
> has the following dependencies:
> 
>         depends on MEMORY_HOTPLUG
>         depends on MEMORY_HOTREMOVE
>         depends on SPARSEMEM_VMEMMAP

Filesystem DAX now has a dependency on memory hotplug?

Fmeh. No wonder I never enabled CONFIG_ZONE_DEVICE. It's described in
menuconfig as "Device memory (pmem, HMM, etc...) hotplug support".
This isn't for hotplug support - it required for basic DAX
functionality. I've never enabled memory hotplug in any of my test
kernel configs, because the VMs I run the kernels on don't ever get
memory hotplugged....

OK, works now I've found the magic config incantantions to turn
everything I now need on.

Can we get this rationalised to a single top level config
option in the filesystems menu "Enable Filesystem DAX" that turns
on every knob that is required?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
