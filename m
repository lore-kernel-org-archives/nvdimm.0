Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F48220A5E1;
	Fri, 13 Jun 2025 16:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749831925; cv=none; b=DPIWeid3Wc0m01Mhfic6cNPBJPkrgaDrdoTgcW3JNgjWBv7uSlTcsxRHuzuYGfscvHgFYgEevrXpsT7mgivhWhAHqKmwvPmZx35MlwO/Bs5UT8NvNUEivq/OAZiszk5ac/gmEaulf6JgmWr2WLC28bgW5KZNpIrYTmypeeGbC2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749831925; c=relaxed/simple;
	bh=BM2FgpTzaD2zd78I4ZKBdnv9f+Oc3qCLdtrCliUCFYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n3Z4UK0zifQXmd9rOMClYjOxmeVesA/J1NsKmxkxpE73i/hMD0+EQmosjiachCxUvw6ki40vOEyWABvY/O8Nx3aBmGV4Xj14Cnv0YWFA+xrj3Oy+xGikNiw3Rk9isvMTe1VfUc+uW7n1VMLQBxoqsRLvSPH1Rd0ZxqEKvKYxfs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XA4G0HxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XA4G0HxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E891FC4CEE3;
	Fri, 13 Jun 2025 16:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749831924;
	bh=BM2FgpTzaD2zd78I4ZKBdnv9f+Oc3qCLdtrCliUCFYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XA4G0HxWC+kpGJr1471Z48mcpDBki2o5Fks9nWD72NYir3gCQ4lpKKRWB7kV3mQbZ
	 BN2avrLw1cCppqt+eRCCKaI1LR4/W5aWPXcldBUcfOy5dwmCT1y5SSz7QdgXtyQQAA
	 74KrNz3VfZSNlH0peEMaQwEMfIff4le1hJ/Fx0EEml8Mn93xwC9tKY804nx+61kHf0
	 dCr5cKI8I6xUM0X3aHnmAhPbvoetXBgO+nd/f5/rSWAgvbTMbr0Gos++p31fCrDa8N
	 8WUub7b+9pkQdjgrUauNkHSUZdSOsQQPhob/GcrCjDnHMHC1zrRb8uw0LsK998tcqj
	 w7lHZs+1StGZA==
Date: Fri, 13 Jun 2025 19:25:18 +0300
From: Mike Rapoport <rppt@kernel.org>
To: jane.chu@oracle.com
Cc: Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Tyler Hicks <code@tyhicks.com>, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [RFC PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM
 DIMM devices
Message-ID: <aExQ7nSejklEeVn0@kernel.org>
References: <20250612083153.48624-1-rppt@kernel.org>
 <20250612083153.48624-2-rppt@kernel.org>
 <9d75cf8a-42ae-4e61-90e9-6ddd937ddb01@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d75cf8a-42ae-4e61-90e9-6ddd937ddb01@oracle.com>

On Thu, Jun 12, 2025 at 02:12:42PM -0700, jane.chu@oracle.com wrote:
> 
> On 6/12/2025 1:31 AM, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > There are use cases, for example virtual machine hosts, that create
> > "persistent" memory regions using memmap= option on x86 or dummy
> > pmem-region device tree nodes on DT based systems.
> > 
> > Both these options are inflexible because they create static regions and
> > the layout of the "persistent" memory cannot be adjusted without reboot.
> > 
> > Add a ramdax driver that allows creation of DIMM devices on top of
> > E820_TYPE_PRAM regions and devicetree pmem-region nodes.
> > 
> > The DIMMs support label space management on the "device" and provide a
> > flexible way to access RAM using fsdax and devdax.
> 
> Just curious, how does the new driver work with Michal Clapinski's recent
> patch that adds
> "nd_e820.pmem=ss[KMG],nn[KMG][,mode=fsdax/devdax,align=aa[KMG]]" kernel
> parameter ?

The new driver and nd_e820 are mutually exclusive. 
 
> thanks,
> -jane
> 
> > 
> > Signed-off-by: Mike Rapoport (Mircosoft) <rppt@kernel.org>
> > ---
> >   drivers/nvdimm/Kconfig  |  15 +++
> >   drivers/nvdimm/Makefile |   1 +
> >   drivers/nvdimm/ramdax.c | 279 ++++++++++++++++++++++++++++++++++++++++
> >   3 files changed, 295 insertions(+)
> >   create mode 100644 drivers/nvdimm/ramdax.c
> > 
> > diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
> > index fde3e17c836c..7aae74a29f10 100644
> > --- a/drivers/nvdimm/Kconfig
> > +++ b/drivers/nvdimm/Kconfig
> > @@ -97,6 +97,21 @@ config OF_PMEM
> >   	  Select Y if unsure.
> > +config RAMDAX
> > +	tristate "Support persistent memory interfaces on RAM carveouts"
> > +	depends on OF || (X86 && X86_PMEM_LEGACY=n)
> > +	select X86_PMEM_LEGACY_DEVICE
> > +	default LIBNVDIMM
> > +	help
> > +	  Allows creation of DAX devices on RAM carveouts.
> > +
> > +	  Memory ranges that are manually specified by the
> > +	  'memmap=nn[KMG]!ss[KMG]' kernel command line or defined by dummy
> > +	  pmem-region device tree nodes would be managed by this driver as DIMM
> > +	  devices with support for dynamic layout of namespaces.
> > +
> > +	  Select N if unsure.
> > +
> >   config NVDIMM_KEYS
> >   	def_bool y
> >   	depends on ENCRYPTED_KEYS
> > diff --git a/drivers/nvdimm/Makefile b/drivers/nvdimm/Makefile
> > index ba0296dca9db..8c268814936c 100644
> > --- a/drivers/nvdimm/Makefile
> > +++ b/drivers/nvdimm/Makefile
> > @@ -5,6 +5,7 @@ obj-$(CONFIG_ND_BTT) += nd_btt.o
> >   obj-$(CONFIG_X86_PMEM_LEGACY) += nd_e820.o
> >   obj-$(CONFIG_OF_PMEM) += of_pmem.o
> >   obj-$(CONFIG_VIRTIO_PMEM) += virtio_pmem.o nd_virtio.o
> > +obj-$(CONFIG_RAMDAX) += ramdax.o
> >   nd_pmem-y := pmem.o
> > diff --git a/drivers/nvdimm/ramdax.c b/drivers/nvdimm/ramdax.c
> > new file mode 100644
> > index 000000000000..67b0a240c0ae
> > --- /dev/null
> > +++ b/drivers/nvdimm/ramdax.c
> > @@ -0,0 +1,279 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Copyright (c) 2015, Mike Rapoport, Microsoft
> > + *
> > + * Based on e820 pmem driver:
> > + * Copyright (c) 2015, Christoph Hellwig.
> > + * Copyright (c) 2015, Intel Corporation.
> > + */
> > +#include <linux/platform_device.h>
> > +#include <linux/memory_hotplug.h>
> > +#include <linux/libnvdimm.h>
> > +#include <linux/module.h>
> > +#include <linux/numa.h>
> > +#include <linux/io.h>
> > +#include <linux/of.h>
> > +
> > +#include <uapi/linux/ndctl.h>
> > +
> > +#define LABEL_AREA_SIZE	SZ_128K
> > +
> > +struct ramdax_dimm {
> > +	struct nvdimm *nvdimm;
> > +	void *label_area;
> > +};
> > +
> > +static void ramdax_remove(struct platform_device *pdev)
> > +{
> > +	struct nvdimm_bus *nvdimm_bus = platform_get_drvdata(pdev);
> > +
> > +	/* FIXME: cleanup dimm and region devices */
> > +
> > +	nvdimm_bus_unregister(nvdimm_bus);
> > +}
> > +
> > +static int ramdax_register_region(struct resource *res,
> > +				    struct nvdimm *nvdimm,
> > +				    struct nvdimm_bus *nvdimm_bus)
> > +{
> > +	struct nd_mapping_desc mapping;
> > +	struct nd_region_desc ndr_desc;
> > +	struct nd_interleave_set *nd_set;
> > +	int nid = phys_to_target_node(res->start);
> > +
> > +	nd_set = kzalloc(sizeof(*nd_set), GFP_KERNEL);
> > +	if (!nd_set)
> > +		return -ENOMEM;
> > +
> > +	nd_set->cookie1 = get_random_u64();
> > +	nd_set->cookie2 = nd_set->cookie1;
> > +
> > +	memset(&mapping, 0, sizeof(mapping));
> > +	mapping.nvdimm = nvdimm;
> > +	mapping.start = 0;
> > +	mapping.size = resource_size(res) - LABEL_AREA_SIZE;
> > +
> > +	memset(&ndr_desc, 0, sizeof(ndr_desc));
> > +	ndr_desc.res = res;
> > +	ndr_desc.numa_node = numa_map_to_online_node(nid);
> > +	ndr_desc.target_node = nid;
> > +	ndr_desc.num_mappings = 1;
> > +	ndr_desc.mapping = &mapping;
> > +	ndr_desc.nd_set = nd_set;
> > +
> > +	if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
> > +		goto err_free_nd_set;
> > +
> > +	return 0;
> > +
> > +err_free_nd_set:
> > +	kfree(nd_set);
> > +	return -ENXIO;
> > +}
> > +
> > +static int ramdax_register_dimm(struct resource *res, void *data)
> > +{
> > +	resource_size_t start = res->start;
> > +	resource_size_t size = resource_size(res);
> > +	unsigned long flags = 0, cmd_mask = 0;
> > +	struct nvdimm_bus *nvdimm_bus = data;
> > +	struct ramdax_dimm *dimm;
> > +	int err;
> > +
> > +	dimm = kzalloc(sizeof(*dimm), GFP_KERNEL);
> > +	if (!dimm)
> > +		return -ENOMEM;
> > +
> > +	dimm->label_area = memremap(start + size - LABEL_AREA_SIZE,
> > +				    LABEL_AREA_SIZE, MEMREMAP_WB);
> > +	if (!dimm->label_area)
> > +		goto err_free_dimm;
> > +
> > +	set_bit(NDD_LABELING, &flags);
> > +	set_bit(NDD_REGISTER_SYNC, &flags);
> > +	set_bit(ND_CMD_GET_CONFIG_SIZE, &cmd_mask);
> > +	set_bit(ND_CMD_GET_CONFIG_DATA, &cmd_mask);
> > +	set_bit(ND_CMD_SET_CONFIG_DATA, &cmd_mask);
> > +	dimm->nvdimm = nvdimm_create(nvdimm_bus, dimm,
> > +				     /* dimm_attribute_groups */ NULL,
> > +				     flags, cmd_mask, 0, NULL);
> > +	if (!dimm->nvdimm) {
> > +		err = -ENOMEM;
> > +		goto err_unmap_label;
> > +	}
> > +
> > +	err = ramdax_register_region(res, dimm->nvdimm, nvdimm_bus);
> > +	if (err)
> > +		goto err_remove_nvdimm;
> > +
> > +	return 0;
> > +
> > +err_remove_nvdimm:
> > +	nvdimm_delete(dimm->nvdimm);
> > +err_unmap_label:
> > +	memunmap(dimm->label_area);
> > +err_free_dimm:
> > +	kfree(dimm);
> > +	return err;
> > +}
> > +
> > +static int ramdax_get_config_size(struct nvdimm *nvdimm, int buf_len,
> > +				    struct nd_cmd_get_config_size *cmd)
> > +{
> > +	if (sizeof(*cmd) > buf_len)
> > +		return -EINVAL;
> > +
> > +	*cmd = (struct nd_cmd_get_config_size){
> > +		.status = 0,
> > +		.config_size = LABEL_AREA_SIZE,
> > +		.max_xfer = 8,
> > +	};
> > +
> > +	return 0;
> > +}
> > +
> > +static int ramdax_get_config_data(struct nvdimm *nvdimm, int buf_len,
> > +				    struct nd_cmd_get_config_data_hdr *cmd)
> > +{
> > +	struct ramdax_dimm *dimm = nvdimm_provider_data(nvdimm);
> > +
> > +	if (sizeof(*cmd) > buf_len)
> > +		return -EINVAL;
> > +	if (struct_size(cmd, out_buf, cmd->in_length) > buf_len)
> > +		return -EINVAL;
> > +	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
> > +		return -EINVAL;
> > +
> > +	memcpy(cmd->out_buf, dimm->label_area + cmd->in_offset, buf_len);
> > +
> > +	return 0;
> > +}
> > +
> > +static int ramdax_set_config_data(struct nvdimm *nvdimm, int buf_len,
> > +				    struct nd_cmd_set_config_hdr *cmd)
> > +{
> > +	struct ramdax_dimm *dimm = nvdimm_provider_data(nvdimm);
> > +
> > +	if (sizeof(*cmd) > buf_len)
> > +		return -EINVAL;
> > +	if (struct_size(cmd, in_buf, cmd->in_length) > buf_len)
> > +		return -EINVAL;
> > +	if (cmd->in_offset + cmd->in_length > LABEL_AREA_SIZE)
> > +		return -EINVAL;
> > +
> > +	memcpy(dimm->label_area + cmd->in_offset, cmd->in_buf, buf_len);
> > +
> > +	return 0;
> > +}
> > +
> > +static int ramdax_nvdimm_ctl(struct nvdimm *nvdimm, unsigned int cmd,
> > +			       void *buf, unsigned int buf_len)
> > +{
> > +	unsigned long cmd_mask = nvdimm_cmd_mask(nvdimm);
> > +
> > +	if (!test_bit(cmd, &cmd_mask))
> > +		return -ENOTTY;
> > +
> > +	switch (cmd) {
> > +	case ND_CMD_GET_CONFIG_SIZE:
> > +		return ramdax_get_config_size(nvdimm, buf_len, buf);
> > +	case ND_CMD_GET_CONFIG_DATA:
> > +		return ramdax_get_config_data(nvdimm, buf_len, buf);
> > +	case ND_CMD_SET_CONFIG_DATA:
> > +		return ramdax_set_config_data(nvdimm, buf_len, buf);
> > +	default:
> > +		return -ENOTTY;
> > +	}
> > +}
> > +
> > +static int ramdax_ctl(struct nvdimm_bus_descriptor *nd_desc,
> > +			 struct nvdimm *nvdimm, unsigned int cmd, void *buf,
> > +			 unsigned int buf_len, int *cmd_rc)
> > +{
> > +	/*
> > +	 * No firmware response to translate, let the transport error
> > +	 * code take precedence.
> > +	 */
> > +	*cmd_rc = 0;
> > +
> > +	if (!nvdimm)
> > +		return -ENOTTY;
> > +	return ramdax_nvdimm_ctl(nvdimm, cmd, buf, buf_len);
> > +}
> > +
> > +static int ramdax_probe_of(struct platform_device *pdev,
> > +			     struct nvdimm_bus *bus, struct device_node *np)
> > +{
> > +	int err;
> > +
> > +	for (int i = 0; i < pdev->num_resources; i++) {
> > +		err = ramdax_register_dimm(&pdev->resource[i], bus);
> > +		if (err)
> > +			goto err_unregister;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_unregister:
> > +	/*
> > +	 * FIXME: should we unregister the dimms that were registered
> > +	 * successfully
> > +	 */
> > +	return err;
> > +}
> > +
> > +static int ramdax_probe(struct platform_device *pdev)
> > +{
> > +	static struct nvdimm_bus_descriptor nd_desc;
> > +	struct device *dev = &pdev->dev;
> > +	struct nvdimm_bus *nvdimm_bus;
> > +	struct device_node *np;
> > +	int rc = -ENXIO;
> > +
> > +	nd_desc.provider_name = "ramdax";
> > +	nd_desc.module = THIS_MODULE;
> > +	nd_desc.ndctl = ramdax_ctl;
> > +	nvdimm_bus = nvdimm_bus_register(dev, &nd_desc);
> > +	if (!nvdimm_bus)
> > +		goto err;
> > +
> > +	np = dev_of_node(&pdev->dev);
> > +	if (np)
> > +		rc = ramdax_probe_of(pdev, nvdimm_bus, np);
> > +	else
> > +		rc = walk_iomem_res_desc(IORES_DESC_PERSISTENT_MEMORY_LEGACY,
> > +					 IORESOURCE_MEM, 0, -1, nvdimm_bus,
> > +					 ramdax_register_dimm);
> > +	if (rc)
> > +		goto err;
> > +
> > +	platform_set_drvdata(pdev, nvdimm_bus);
> > +
> > +	return 0;
> > +err:
> > +	nvdimm_bus_unregister(nvdimm_bus);
> > +	return rc;
> > +}
> > +
> > +#ifdef CONFIG_OF
> > +static const struct of_device_id ramdax_of_matches[] = {
> > +	{ .compatible = "pmem-region", },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, ramdax_of_matches);
> > +#endif
> > +
> > +static struct platform_driver ramdax_driver = {
> > +	.probe = ramdax_probe,
> > +	.remove = ramdax_remove,
> > +	.driver = {
> > +		.name = "e820_pmem",
> > +		.of_match_table = of_match_ptr(ramdax_of_matches),
> > +	},
> > +};
> > +
> > +module_platform_driver(ramdax_driver);
> > +
> > +MODULE_DESCRIPTION("NVDIMM support for e820 type-12 memory and OF pmem-region");
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Microsoft Corporation");
> 

-- 
Sincerely yours,
Mike.
