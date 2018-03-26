Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x244.google.com (mail-pl0-x244.google.com
 [IPv6:2607:f8b0:400e:c01::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BB891225E400B
 for <linux-nvdimm@lists.01.org>; Sun, 25 Mar 2018 20:58:52 -0700 (PDT)
Received: by mail-pl0-x244.google.com with SMTP id 9-v6so11182476ple.11
 for <linux-nvdimm@lists.01.org>; Sun, 25 Mar 2018 21:05:28 -0700 (PDT)
Date: Mon, 26 Mar 2018 15:05:16 +1100
From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 3/6] libnvdimm: Add device-tree based driver
Message-ID: <20180326150516.619a18cb@gmail.com>
In-Reply-To: <20180323081209.31387-3-oohall@gmail.com>
References: <20180323081209.31387-1-oohall@gmail.com>
 <20180323081209.31387-3-oohall@gmail.com>
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 23 Mar 2018 19:12:06 +1100
Oliver O'Halloran <oohall@gmail.com> wrote:

> This patch adds peliminary device-tree bindings for the NVDIMM driver.
> Currently this only supports one bus (created at probe time) which all
> regions are added to with individual regions being created by a platform
> device driver.
> 
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---

It's a good idea to keep a changelog from the previous revisions, but I'm
just nit-picking. The reason I want to bring that up is because this revision
has different bindings from what was proposed earlier.

> I suspect the platform driver should be holding a reference to the
> created region. I left that out here since previously Dan has said
> he'd rather keep the struct device internal to libnvdimm and the only
> other way a region device can disappear is when the bus is unregistered.

I think the previous bindings did not have this issue, but the suggestion
was to move regions to being platform devices so as to avoid custom
code for tracking what is populated and what is not.

Personally I liked the previous binding better, but then I am not a device
tree expert.

> ---
>  MAINTAINERS                |   8 +++
>  drivers/nvdimm/Kconfig     |  10 ++++
>  drivers/nvdimm/Makefile    |   1 +
>  drivers/nvdimm/of_nvdimm.c | 130 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 149 insertions(+)
>  create mode 100644 drivers/nvdimm/of_nvdimm.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4e62756936fa..e3fc47fbfc7a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8035,6 +8035,14 @@ Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
>  S:	Supported
>  F:	drivers/nvdimm/pmem*
>  
> +LIBNVDIMM: DEVICETREE BINDINGS
> +M:	Oliver O'Halloran <oohall@gmail.com>
> +L:	linux-nvdimm@lists.01.org
> +Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
> +S:	Supported
> +F:	drivers/nvdimm/of_nvdimm.c
> +F:	Documentation/devicetree/bindings/nvdimm/nvdimm-bus.txt
> +
>  LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
>  M:	Dan Williams <dan.j.williams@intel.com>
>  L:	linux-nvdimm@lists.01.org
> diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
> index a65f2e1d9f53..505a9bbbe49f 100644
> --- a/drivers/nvdimm/Kconfig
> +++ b/drivers/nvdimm/Kconfig
> @@ -102,4 +102,14 @@ config NVDIMM_DAX
>  
>  	  Select Y if unsure
>  
> +config OF_NVDIMM
> +	tristate "Device-tree support for NVDIMMs"
> +	depends on OF
> +	default LIBNVDIMM
> +	help
> +	  Allows byte addressable persistent memory regions to be described in the
> +	  device-tree.

Again nit-picking, but I thought we supported volatile mappings too.

> +
> +	  Select Y if unsure.
> +
>  endif
> diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
> index 70d5f3ad9909..fd6a5838aa25 100644
> --- a/drivers/nvdimm/Makefile
> +++ b/drivers/nvdimm/Makefile
> @@ -4,6 +4,7 @@ obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
>  obj-$(CONFIG_ND_BTT) += nd_btt.o
>  obj-$(CONFIG_ND_BLK) += nd_blk.o
>  obj-$(CONFIG_X86_PMEM_LEGACY) += nd_e820.o
> +obj-$(CONFIG_OF_NVDIMM) += of_nvdimm.o
>  
>  nd_pmem-y := pmem.o
>  
> diff --git a/drivers/nvdimm/of_nvdimm.c b/drivers/nvdimm/of_nvdimm.c
> new file mode 100644
> index 000000000000..79c28291f420
> --- /dev/null
> +++ b/drivers/nvdimm/of_nvdimm.c
> @@ -0,0 +1,130 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +
> +#define pr_fmt(fmt) "of_nvdimm: " fmt
> +
> +#include <linux/of_platform.h>
> +#include <linux/of_address.h>
> +#include <linux/libnvdimm.h>
> +#include <linux/module.h>
> +#include <linux/ioport.h>
> +#include <linux/slab.h>
> +
> +/*
> + * Container bus stuff.  For now we just chunk regions into a default
> + * bus with no ndctl support. In the future we'll add some mechanism
> + * for dispatching regions into the correct bus type, but this is useful
> + * for now.

I liked that the previous binding handled this better, it looked very
similar to the e820 binding in terms of simplicity.

> + */
> +struct nvdimm_bus_descriptor bus_desc;
> +struct nvdimm_bus *bus;
> +
> +/* region driver */
> +
> +static const struct attribute_group *region_attr_groups[] = {
> +	&nd_region_attribute_group,
> +	&nd_device_attribute_group,
> +	NULL,
> +};
> +
> +static const struct attribute_group *bus_attr_groups[] = {
> +	&nvdimm_bus_attribute_group,
> +	NULL,
> +};
> +
> +static int of_nd_region_probe(struct platform_device *pdev)
> +{
> +	struct nd_region_desc ndr_desc;
> +	struct resource temp_res;
> +	struct nd_region *region;
> +	struct device_node *np;
> +
> +	np = dev_of_node(&pdev->dev);
> +	if (!np)
> +		return -ENXIO;
> +
> +	pr_err("registering region for %pOF\n", np);
> +
> +	if (of_address_to_resource(np, 0, &temp_res)) {
> +		pr_warn("Unable to parse reg[0] for %pOF\n", np);
> +		return -ENXIO;
> +	}
> +
> +	memset(&ndr_desc, 0, sizeof(ndr_desc));
> +	ndr_desc.res = &temp_res;
> +	ndr_desc.of_node = np;
> +	ndr_desc.attr_groups = region_attr_groups;
> +	ndr_desc.numa_node = of_node_to_nid(np);

We probably need an ndr_desc.provider

> +	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> +
> +	/*
> +	 * NB: libnvdimm copies the data from ndr_desc into it's own structures
> +	 * so passing stack pointers is fine.
> +	 */
> +	if (of_get_property(np, "volatile", NULL))
> +		region = nvdimm_volatile_region_create(bus, &ndr_desc);
> +	else
> +		region = nvdimm_pmem_region_create(bus, &ndr_desc);
> +
> +	pr_warn("registered pmem region %px\n", region);
> +	if (!region)
> +		return -ENXIO;
> +
> +	platform_set_drvdata(pdev, region);
> +
> +	return 0;
> +}
> +
> +static int of_nd_region_remove(struct platform_device *pdev)
> +{
> +	struct nd_region *r = platform_get_drvdata(pdev);
> +
> +	nd_region_destroy(r);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id of_nd_region_match[] = {
> +	{ .compatible = "nvdimm-region" },
> +	{ },
> +};
> +
> +static struct platform_driver of_nd_region_driver = {
> +	.probe = of_nd_region_probe,
> +	.remove = of_nd_region_remove,
> +	.driver = {
> +		.name = "of_nd_region",
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_nd_region_match,
> +	},
> +};
> +
> +/* bus wrangling */
> +
> +static int __init of_nvdimm_init(void)
> +{
> +	/* register  */
> +	bus_desc.attr_groups = bus_attr_groups;
> +	bus_desc.provider_name = "of_nvdimm";
> +	bus_desc.module = THIS_MODULE;
> +
> +	/* does parent == NULL work? */
> +	bus = nvdimm_bus_register(NULL, &bus_desc);
> +	if (!bus)
> +		return -ENODEV;
> +
> +	platform_driver_register(&of_nd_region_driver);
> +
> +	return 0;
> +}
> +module_init(of_nvdimm_init);
> +
> +static void __init of_nvdimm_exit(void)
> +{
> +	nvdimm_bus_unregister(bus);
> +	platform_driver_unregister(&of_nd_region_driver);
> +}
> +module_exit(of_nvdimm_exit);
> +
> +MODULE_DEVICE_TABLE(of, of_nd_region_match);
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("IBM Corporation");

Balbir Singh.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
