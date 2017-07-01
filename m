Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 428ED21A00AD1
 for <linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 17:40:04 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: RE: [PATCH v2] libnvdimm, pmem: Add sysfs notifications to badblocks
Date: Sat, 1 Jul 2017 00:41:32 +0000
Message-ID: <DF4PR84MB01052029BEB89DF70A067FAC82D00@DF4PR84MB0105.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170612222511.22030-1-toshi.kani@hpe.com>
 <CAPcyv4gL-C2exjbZDibnFU59S267EEmV8d6uoLtH_RndtvEy=w@mail.gmail.com>
In-Reply-To: <CAPcyv4gL-C2exjbZDibnFU59S267EEmV8d6uoLtH_RndtvEy=w@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> > Sysfs "badblocks" information may be updated during run-time that:
> >  - MCE, SCI, and sysfs "scrub" may add new bad blocks
> >  - Writes and ioctl() may clear bad blocks
> >
> > Add support to send sysfs notifications to sysfs "badblocks" file
> > under region and pmem directories when their badblocks information
> > is re-evaluated (but is not necessarily changed) during run-time.
> >
> > Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Vishal Verma <vishal.l.verma@intel.com>
> > Cc: Linda Knippers <linda.knippers@hpe.com>
> > ---
> > v2: Send notifications for the clearing case
> > ---
> >  drivers/nvdimm/bus.c    |    3 +++
> >  drivers/nvdimm/nd.h     |    1 +
> >  drivers/nvdimm/pmem.c   |   14 ++++++++++++++
> >  drivers/nvdimm/pmem.h   |    1 +
> >  drivers/nvdimm/region.c |   12 ++++++++++--
> >  5 files changed, 29 insertions(+), 2 deletions(-)
> >
> [..]
> > diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> > index c544d46..6c14c72 100644
> > --- a/drivers/nvdimm/pmem.c
> > +++ b/drivers/nvdimm/pmem.c
> [..]
> > @@ -377,6 +379,13 @@ static int pmem_attach_disk(struct device *dev,
> >
> >         revalidate_disk(disk);
> >
> > +       pmem->bb_state = sysfs_get_dirent(disk_to_dev(disk)->kobj.sd,
> > +                                         "badblocks");
> > +       if (pmem->bb_state)
> > +               sysfs_put(pmem->bb_state);
> 
> Sorry I missed this on the first review, but this looks broken. We
> need to hold the reference for as long as we might trigger
> notifications, so the sysfs_put() should wait until
> pmem_release_disk().

I see.
 
> [..]
> > diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
> > index 869a886..ca94029 100644
> > --- a/drivers/nvdimm/region.c
> > +++ b/drivers/nvdimm/region.c
> > @@ -58,10 +58,16 @@ static int nd_region_probe(struct device *dev)
> >
> >                 if (devm_init_badblocks(dev, &nd_region->bb))
> >                         return -ENODEV;
> > +               nd_region->bb_state = sysfs_get_dirent(nd_region->dev.kobj.sd,
> > +                                                      "badblocks");
> > +               if (nd_region->bb_state)
> > +                       sysfs_put(nd_region->bb_state);
> 
> ...same here. This should wait until we tear down the region.
> 
> I'll take a look at an incremental fix patch.

Thanks Dan!
-Toshi

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
