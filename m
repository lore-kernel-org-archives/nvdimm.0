Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 323E121962301
 for <linux-nvdimm@lists.01.org>; Mon, 21 Jan 2019 16:45:59 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id w13so16022929oiw.9
 for <linux-nvdimm@lists.01.org>; Mon, 21 Jan 2019 16:45:59 -0800 (PST)
MIME-Version: 1.0
References: <154785884329.2202034.3295476681016958230.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190121075102.GA3758@richard> <20190122002915.GA5984@richard>
In-Reply-To: <20190122002915.GA5984@richard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 21 Jan 2019 16:45:46 -0800
Message-ID: <CAPcyv4gANCKeEE5xgC9W99XdiR+rNyN5TEzho18039S2+7TaPA@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: Clarify nd_pfn_init() flow
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
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 21, 2019 at 4:30 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
>
> On Mon, Jan 21, 2019 at 03:51:02PM +0800, Wei Yang wrote:
> >On Fri, Jan 18, 2019 at 04:47:23PM -0800, Dan Williams wrote:
> >>In recent days, 2 engineers, including the original author of
> >>nd_pfn_init(), overlooked the internal call to nd_pfn_validate() and the
> >>implications to memory allocation.
> >>
> >>Clarify this situation to help anyone that reads through this code in
> >>the future.
> >>
> >>Reported-by: Wei Yang <richardw.yang@linux.intel.com>
> >>Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >>---
> >> drivers/nvdimm/btt_devs.c |    5 +++++
> >> drivers/nvdimm/dax_devs.c |    5 +++++
> >> drivers/nvdimm/pfn_devs.c |   21 +++++++++++++++++++++
> >> 3 files changed, 31 insertions(+)
> >>
> >>diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> >>index 795ad4ff35ca..e0a6f2491e57 100644
> >>--- a/drivers/nvdimm/btt_devs.c
> >>+++ b/drivers/nvdimm/btt_devs.c
> >>@@ -354,6 +354,11 @@ int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns)
> >>              put_device(btt_dev);
> >>      }
> >>
> >>+     /*
> >>+      * Successful probe indicates to the caller that an nd_btt
> >>+      * personality device has been registered and the caller can
> >>+      * fail the probe of the baseline namespace device.
> >>+      */
> >>      return rc;
> >> }
> >> EXPORT_SYMBOL(nd_btt_probe);
> >>diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
> >>index 0453f49dc708..65010d955fa7 100644
> >>--- a/drivers/nvdimm/dax_devs.c
> >>+++ b/drivers/nvdimm/dax_devs.c
> >>@@ -136,6 +136,11 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
> >>      } else
> >>              __nd_device_register(dax_dev);
> >>
> >>+     /*
> >>+      * Successful probe indicates to the caller that a device-dax
> >>+      * personality device has been registered and the caller can
> >>+      * fail the probe of the baseline namespace device.
> >>+      */
> >>      return rc;
> >> }
> >> EXPORT_SYMBOL(nd_dax_probe);
> >>diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> >>index 6f22272e8d80..a8783b5a76ba 100644
> >>--- a/drivers/nvdimm/pfn_devs.c
> >>+++ b/drivers/nvdimm/pfn_devs.c
> >>@@ -576,6 +576,11 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
> >>      } else
> >>              __nd_device_register(pfn_dev);
> >>
> >>+     /*
> >>+      * Successful probe indicates to the caller that an nd_pfn
> >>+      * personality device has been registered and the caller can
> >>+      * fail the probe of the baseline namespace device.
> >>+      */
> >>      return rc;
> >> }
> >> EXPORT_SYMBOL(nd_pfn_probe);
> >>@@ -706,6 +711,22 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
> >>              sig = DAX_SIG;
> >>      else
> >>              sig = PFN_SIG;
> >>+
> >>+     /*
> >>+      * Check for an existing 'pfn' superblock before writing a new
> >>+      * one. The intended flow is that on the first probe of an
> >>+      * nd_{pfn,dax} device the superblock is calculated and written
> >>+      * to the namespace. In this case nd_pfn_validate() returns
> >>+      * -ENODEV because no valid superblock exists currently.
> >>+      *
> >>+      * On subsequent probes nd_pfn_validate() will find a valid
> >>+      * superblock and return 0.
> >>+      *
> >>+      * If an assumption of the superblock has been violated, like a
> >>+      * change to the physical alignment of the namespace,
> >>+      * nd_pfn_validate() will return an error other than -ENODEV to
> >>+      * fail probing.
> >>+      */
> >
> >Let me reply in this thread. Sorry for my poor understand, I don't get it
> >clearly now.
> >
> >To be honest, the structure is a little bit complicated, if my understanding
> >is not correct, please forgive my poor understand.
> >
> >Below is a code flow. To simply analysis, I setup kernel parameter memmap to
> >emulate, and configure one namespace to mode devdax. So that we would have the
> >same root for code flow.
> >
> >Let's start with nd_region_driver:
> >
> >    nd_region_probe
> >        nd_region_register_namespaces
> >           create_namespaces
> >       nd_region->btt_seed = nd_btt_create(nd_region);
> >       nd_region->pfn_seed = nd_pfn_create(nd_region);
> >       nd_region->dax_seed = nd_dax_create(nd_region);
>
> May I ask a question about the purpose to create these three device here?
>
> I see nd_pfn_create() doesn't allocate pfn_sb here, and the probe on these
> devices failed. Confused why we need these three devices.

These allow for the namespace creation flow. Namespace creation with
the pfn personality, for example, goes like this:

1/ Find available region capacity

2/ Allocate capacity to a namespace

3/ Assign that namespace to a free pfn instance
echo namespace0.0 > /sys/bus/nd/devices/pfn0.0/namespace

4/ Start the pfn0.0 device
echo pfn0.0 > /sys/bus/nd/drivers/nd_pmem/bind

5/ At this point nd_pfn_validate() returns -ENODEV, so the driver
writes the configuration to the device to be autodetected next time.

This explicit force binding operation is how the driver determines the
difference between the namespace creation case and the namespace
auto-probing case at the next driver load.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
