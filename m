From: Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [RFC PATCH 4/5] acpi/hmat: Register special purpose memory as a
 device
Date: Fri, 5 Apr 2019 12:18:57 +0100
Message-ID: <20190405121857.0000718a@huawei.com>
References: <155440490809.3190322.15060922240602775809.stgit@dwillia2-desk3.amr.corp.intel.com>
        <155440492988.3190322.4475460421334178449.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <155440492988.3190322.4475460421334178449.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Keith Busch <keith.busch@intel.com>, vishal.l.verma@intel.com, x86@kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org
List-Id: linux-nvdimm@lists.01.org

On Thu, 4 Apr 2019 12:08:49 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Memory that has been tagged EFI_SPECIAL_PURPOSE, and has performance
> properties described by the ACPI HMAT is expected to have an application
> specific consumer.
> 
> Those consumers may want 100% of the memory capacity to be reserved from
> any usage by the kernel. By default, with this enabling, a platform
> device is created to represent this differentiated resource.
> 
> A follow on change arranges for device-dax to claim these devices by
> default and provide an mmap interface for the target application.
> However, if the administrator prefers that some or all of the special
> purpose memory is made available to the core-mm the device-dax hotplug
> facility can be used to online the memory with its own numa node.
> 
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Hi Dan,

Great to see you getting this discussion going so fast and in
general the approach makes sense to me.

I'm a little confused why HMAT has anything to do with this.
SPM is defined either via the attribute in SRAT SPA entries,
EF_MEMORY_SP or via the EFI memory map.

Whether it is in HMAT or not isn't all that relevant.
Back in the days of the reservation hint (so before yesterday :)
it was relevant obviously but that's no longer true.

So what am I missing?

Thanks,

Jonathan


> ---
>  drivers/acpi/hmat/Kconfig |    1 +
>  drivers/acpi/hmat/hmat.c  |   63 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/memregion.h |    3 ++
>  3 files changed, 67 insertions(+)
> 
> diff --git a/drivers/acpi/hmat/Kconfig b/drivers/acpi/hmat/Kconfig
> index 95a29964dbea..4fcf76e8aa1d 100644
> --- a/drivers/acpi/hmat/Kconfig
> +++ b/drivers/acpi/hmat/Kconfig
> @@ -3,6 +3,7 @@ config ACPI_HMAT
>  	bool "ACPI Heterogeneous Memory Attribute Table Support"
>  	depends on ACPI_NUMA
>  	select HMEM_REPORTING
> +	select MEMREGION
>  	help
>  	 If set, this option has the kernel parse and report the
>  	 platform's ACPI HMAT (Heterogeneous Memory Attributes Table),
> diff --git a/drivers/acpi/hmat/hmat.c b/drivers/acpi/hmat/hmat.c
> index e7ae44c8d359..482360004ea0 100644
> --- a/drivers/acpi/hmat/hmat.c
> +++ b/drivers/acpi/hmat/hmat.c
> @@ -13,6 +13,9 @@
>  #include <linux/device.h>
>  #include <linux/init.h>
>  #include <linux/list.h>
> +#include <linux/mm.h>
> +#include <linux/memregion.h>
> +#include <linux/platform_device.h>
>  #include <linux/list_sort.h>
>  #include <linux/node.h>
>  #include <linux/sysfs.h>
> @@ -612,6 +615,65 @@ static __init void hmat_register_target_perf(struct memory_target *target)
>  	node_set_perf_attrs(mem_nid, &target->hmem_attrs, 0);
>  }
>  
> +static __init void hmat_register_target_device(struct memory_target *target)
> +{
> +	struct memregion_info info;
> +	struct resource res = {
> +		.start = target->start,
> +		.end = target->start + target->size - 1,
> +		.flags = IORESOURCE_MEM,
> +		.desc = IORES_DESC_APPLICATION_RESERVED,
> +	};
> +	struct platform_device *pdev;
> +	int rc, id;
> +
> +	if (region_intersects(target->start, target->size, IORESOURCE_MEM,
> +				IORES_DESC_APPLICATION_RESERVED)
> +			!= REGION_INTERSECTS)
> +		return;
> +
> +	id = memregion_alloc();
> +	if (id < 0) {
> +		pr_err("acpi/hmat: memregion allocation failure for %pr\n", &res);
> +		return;
> +	}
> +
> +	pdev = platform_device_alloc("hmem", id);
> +	if (!pdev) {
> +		pr_err("acpi/hmat: hmem device allocation failure for %pr\n", &res);
> +		goto out_pdev;
> +	}
> +
> +	pdev->dev.numa_node = acpi_map_pxm_to_online_node(target->processor_pxm);
> +	info = (struct memregion_info) {
> +		.target_node = acpi_map_pxm_to_node(target->memory_pxm),
> +	};
> +	rc = platform_device_add_data(pdev, &info, sizeof(info));
> +	if (rc < 0) {
> +		pr_err("acpi/hmat: hmem memregion_info allocation failure for %pr\n", &res);
> +		goto out_pdev;
> +	}
> +
> +	rc = platform_device_add_resources(pdev, &res, 1);
> +	if (rc < 0) {
> +		pr_err("acpi/hmat: hmem resource allocation failure for %pr\n", &res);
> +		goto out_resource;
> +	}
> +
> +	rc = platform_device_add(pdev);
> +	if (rc < 0) {
> +		dev_err(&pdev->dev, "acpi/hmat: device add failed for %pr\n", &res);
> +		goto out_resource;
> +	}
> +
> +	return;
> +
> +out_resource:
> +	put_device(&pdev->dev);
> +out_pdev:
> +	memregion_free(id);
> +}
> +
>  static __init void hmat_register_targets(void)
>  {
>  	struct memory_target *target;
> @@ -619,6 +681,7 @@ static __init void hmat_register_targets(void)
>  	list_for_each_entry(target, &targets, node) {
>  		hmat_register_target_initiators(target);
>  		hmat_register_target_perf(target);
> +		hmat_register_target_device(target);
>  	}
>  }
>  
> diff --git a/include/linux/memregion.h b/include/linux/memregion.h
> index 99fa47793b49..5de2ac7fcf5e 100644
> --- a/include/linux/memregion.h
> +++ b/include/linux/memregion.h
> @@ -1,6 +1,9 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #ifndef _MEMREGION_H_
>  #define _MEMREGION_H_
> +struct memregion_info {
> +	int target_node;
> +};
>  int memregion_alloc(void);
>  void memregion_free(int id);
>  #endif /* _MEMREGION_H_ */
> 
