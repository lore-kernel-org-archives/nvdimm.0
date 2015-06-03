Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1433291212-23367-4-git-send-email-toshi.kani@hp.com>
References: <1433291212-23367-1-git-send-email-toshi.kani@hp.com>
	<1433291212-23367-4-git-send-email-toshi.kani@hp.com>
Date: Tue, 2 Jun 2015 18:01:01 -0700
Message-ID: <CAPcyv4hn_YX=atGXXEPaFf1xk2ZzaWgZjeTpPpEsZZdLiQCXAA@mail.gmail.com>
Subject: Re: [PATCH 3/3] libnvdimm: Add sysfs numa_node to NVDIMM devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 2, 2015 at 5:26 PM, Toshi Kani <toshi.kani@hp.com> wrote:
> Since NVDIMMs are installed on memory slots, they expose the NUMA
> topology of a platform.
>
> This patch adds support of sysfs 'numa_node' to the NVDIMM devices
> under /sys/bus/nd/devices, such as regionN, namespaceN.0, and bttN.
> When bttN is not set up, its numa_node returns -1 (NUMA_NO_NODE).
> nmemN/numa_node always returns -1 for now since this device is for
> dimm-ioctl message interface and has little use of NUMA.  It can be
> enhanced later to set a valid value if necessary.
>
> Here is an example of numa_node values on a 2-socket system with
> a single NVDIMM range on each socket.
>   /sys/bus/nd/devices
>   |-- btt0/numa_node:-1
>   |-- btt1/numa_node:0
>   |-- namespace0.0/numa_node:0
>   |-- namespace1.0/numa_node:1
>   |-- nmem0/numa_node:-1
>   |-- nmem1/numa_node:-1
>   |-- region0/numa_node:0
>   |-- region1/numa_node:1
>
> With this change, numactl(8) accepts 'block:' and 'file:' paths of
> pmem and btt devices as shown in the examples below.
>   numactl --preferred block:pmem0 --show
>   numactl --preferred file:/dev/pmem0s --show
>
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/acpi/nfit.c          |    2 ++
>  drivers/nvdimm/btt.c         |    2 ++
>  drivers/nvdimm/bus.c         |   12 ++++++++++++
>  drivers/nvdimm/nd.h          |    1 +
>  drivers/nvdimm/region.c      |    1 +
>  drivers/nvdimm/region_devs.c |    1 +
>  include/linux/libnvdimm.h    |    1 +
>  7 files changed, 20 insertions(+)
>
> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
> index 5731e4a..a255f3a 100644
> --- a/drivers/acpi/nfit.c
> +++ b/drivers/acpi/nfit.c
> @@ -1255,6 +1255,8 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
>         ndr_desc->res = &res;
>         ndr_desc->provider_data = nfit_spa;
>         ndr_desc->attr_groups = acpi_nfit_region_attribute_groups;
> +       ndr_desc->numa_node = acpi_map_pxm_to_node(spa->proximity_domain);
> +
>         list_for_each_entry(nfit_memdev, &acpi_desc->memdevs, list) {
>                 struct acpi_nfit_memory_map *memdev = nfit_memdev->memdev;
>                 struct nd_mapping *nd_mapping;
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 2d7ce9e..3b3e115 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1369,6 +1369,8 @@ static int nd_btt_probe(struct device *dev)
>                 rc = -ENOMEM;
>                 goto err_btt;
>         }
> +
> +       set_dev_node(dev, nd_region->numa_node);
>         dev_set_drvdata(dev, btt);
>
>         return 0;
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index d8a1794..5c34e68 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -339,9 +339,21 @@ static ssize_t devtype_show(struct device *dev, struct device_attribute *attr,
>  }
>  static DEVICE_ATTR_RO(devtype);
>
> +#ifdef CONFIG_NUMA
> +static ssize_t numa_node_show(struct device *dev, struct device_attribute *attr,
> +               char *buf)
> +{
> +       return sprintf(buf, "%d\n", dev->numa_node);
> +}
> +DEVICE_ATTR_RO(numa_node);
> +#endif
> +
>  static struct attribute *nd_device_attributes[] = {
>         &dev_attr_modalias.attr,
>         &dev_attr_devtype.attr,
> +#ifdef CONFIG_NUMA
> +       &dev_attr_numa_node.attr,
> +#endif
>         NULL,
>  };

I'd prefer you define is_visible() in the nd_device_attribute_group
and gate showing this attribute on IS_ENABLED(CONFIG_NUMA) rather than
including these ifdef guards.  The ifdef guards aren't necessary in
the CONFIG_NUMA=n case.
