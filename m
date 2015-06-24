Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1435166053.11808.302.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 2/3] libnvdimm: Set numa_node to NVDIMM devices
From: Toshi Kani <toshi.kani@hp.com>
Date: Wed, 24 Jun 2015 11:14:13 -0600
In-Reply-To: <CAPcyv4joZNvmUF9s=honCAMXm8Wf__S+UdP6TwhwDdPjbXAzGw@mail.gmail.com>
References: <1434737914-18466-1-git-send-email-toshi.kani@hp.com>
	 <1434737914-18466-3-git-send-email-toshi.kani@hp.com>
	 <CAPcyv4gC7fKq9ic7fuVO1vrNMMFwtxkwoBc6ABVFbBO1tRMF1A@mail.gmail.com>
	 <1435165532.11808.300.camel@misato.fc.hp.com>
	 <CAPcyv4joZNvmUF9s=honCAMXm8Wf__S+UdP6TwhwDdPjbXAzGw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2015-06-24 at 10:08 -0700, Dan Williams wrote:
> On Wed, Jun 24, 2015 at 10:05 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> > On Wed, 2015-06-24 at 09:50 -0700, Dan Williams wrote:
> >> On Fri, Jun 19, 2015 at 11:18 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> >> > ACPI NFIT table has System Physical Address Range Structure
> >> > entries that describe a proximity ID of each range when
> >> > ACPI_NFIT_PROXIMITY_VALID is set in the flags.
> >> >
> >> > Change acpi_nfit_register_region() to map a proximity ID to its
> >> > node ID, and set it to a new numa_node field of nd_region_desc,
> >> > which is then conveyed to nd_region.
> >> >
> >> > nd_region_probe() and nd_btt_probe() set the numa_node of nd_region
> >> > to their device object being probed.  A namespace device inherits
> >> > the numa_node from the parent region device.
> >> >
> >> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> >> > ---
> >> >  drivers/acpi/nfit.c          |    6 ++++++
> >> >  drivers/nvdimm/btt.c         |    2 ++
> >> >  drivers/nvdimm/nd.h          |    1 +
> >> >  drivers/nvdimm/region.c      |    1 +
> >> >  drivers/nvdimm/region_devs.c |    1 +
> >> >  include/linux/libnvdimm.h    |    1 +
> >> >  6 files changed, 12 insertions(+)
> >> >
> >> > diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> >> > index 5f64582..5997753 100644
> >> > --- a/drivers/acpi/nfit.c
> >> > +++ b/drivers/acpi/nfit.c
> >> > @@ -1392,6 +1392,12 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
> >> >         ndr_desc->res = &res;
> >> >         ndr_desc->provider_data = nfit_spa;
> >> >         ndr_desc->attr_groups = acpi_nfit_region_attribute_groups;
> >> > +       if (spa->flags & ACPI_NFIT_PROXIMITY_VALID)
> >> > +               ndr_desc->numa_node = acpi_map_pxm_to_online_node(
> >> > +                                               spa->proximity_domain);
> >> > +       else
> >> > +               ndr_desc->numa_node = NUMA_NO_NODE;
> >> > +
> >> >         list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
> >> >                 struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
> >> >                 struct nd_mapping *nd_mapping;
> >> > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> >> > index 57d3b27..ab082e5 100644
> >> > --- a/drivers/nvdimm/btt.c
> >> > +++ b/drivers/nvdimm/btt.c
> >> > @@ -1495,6 +1495,8 @@ static int nd_btt_probe(struct device *dev)
> >> >                 rc = -ENOMEM;
> >> >                 goto err_btt;
> >> >         }
> >> > +
> >> > +       set_dev_node(dev, nd_region->numa_node);
> >> >         dev_set_drvdata(dev, btt);
> >> >
> >> >         return 0;
> >> > diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> >> > index 011d7c5..0bfd20a 100644
> >> > --- a/drivers/nvdimm/nd.h
> >> > +++ b/drivers/nvdimm/nd.h
> >> > @@ -93,6 +93,7 @@ struct nd_region {
> >> >         u64 ndr_size;
> >> >         u64 ndr_start;
> >> >         int id, num_lanes;
> >> > +       int numa_node;
> >> >         void *provider_data;
> >> >         struct nd_interleave_set *nd_set;
> >> >         struct nd_mapping mapping[0];
> >> > diff --git a/drivers/nvdimm/region.c b/drivers/nvdimm/region.c
> >> > index d9d82e7..a764ca6 100644
> >> > --- a/drivers/nvdimm/region.c
> >> > +++ b/drivers/nvdimm/region.c
> >> > @@ -123,6 +123,7 @@ static int nd_region_probe(struct device *dev)
> >> >
> >> >         num_ns->active = rc;
> >> >         num_ns->count = rc + err;
> >> > +       set_dev_node(dev, nd_region->numa_node);
> >> >         dev_set_drvdata(dev, num_ns);
> >> >
> >> >         if (err == 0)
> >> > diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> >> > index bb9f329..703dfae 100644
> >> > --- a/drivers/nvdimm/region_devs.c
> >> > +++ b/drivers/nvdimm/region_devs.c
> >> > @@ -632,6 +632,7 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
> >> >         nd_region->provider_data = ndr_desc->provider_data;
> >> >         nd_region->nd_set = ndr_desc->nd_set;
> >> >         nd_region->num_lanes = ndr_desc->num_lanes;
> >> > +       nd_region->numa_node = ndr_desc->numa_node;
> >>
> >> Why introduce nd_region->numa_node?  Why not do set_dev_node() directly here?
> >>
> >> I can make this change locally if you agree, we don't need to wait
> >> until probe to set these.
> >
> > dev->numa_node cannot be set here because nd_region_create() then calls
> > nd_device_register() -> device_initialize() -> set_dev_node(dev, -1).
> > So, it gets overwritten with -1.
> 
> Ah, ok.
> 
> Still I'd rather set this permanent property of a device at create
> time, so I'll re-work create to initialize the device and set the node
> before registering.

I agree, it is cleaner in that way.

Thanks,
-Toshi


