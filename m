Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DBE0D1A1DEC
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 07:37:26 -0700 (PDT)
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 12/13] libnvdimm, pmem, pfn: move pfn setup to the core
Date: Thu, 24 Mar 2016 15:36:58 +0100
Message-ID: <1658644.DHCClzV6Cd@c203>
In-Reply-To: <20160324012624.21436.9035.stgit@dwillia2-desk3.jf.intel.com>
References: <20160324012520.21436.22505.stgit@dwillia2-desk3.jf.intel.com>
 <20160324012624.21436.9035.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mittwoch, 23. M=E4rz 2016 18:26:24 CET Dan Williams wrote:
> Now that pmem internals have been disentangled from pfn setup, that code
> can move to the core.  This is in preparation for adding another user of
> the pfn-device capabilities.
> =

> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/nvdimm/nd.h       |    7 ++
>  drivers/nvdimm/pfn_devs.c |  183
> +++++++++++++++++++++++++++++++++++++++++++++ drivers/nvdimm/pmem.c     | =

> 184 --------------------------------------------- 3 files changed, 190
> insertions(+), 184 deletions(-)
> =

> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index a42c823c0a67..8e563c4a3e8c 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -272,9 +272,16 @@ const char *nvdimm_namespace_disk_name(struct
> nd_namespace_common *ndns, void nvdimm_badblocks_populate(struct nd_region
> *nd_region,
>  		struct badblocks *bb, const struct resource *res);
>  #if IS_ENABLED(CONFIG_ND_CLAIM)
> +struct vmem_altmap *nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
> +		struct resource *res, struct vmem_altmap *altmap);
>  int devm_nsio_enable(struct device *dev, struct nd_namespace_io *nsio);
>  void devm_nsio_disable(struct device *dev, struct nd_namespace_io *nsio);
>  #else
> +static inline struct vmem_altmap *nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
> +		struct resource *res, struct vmem_altmap *altmap)
> +{
> +	return ERR_PTR(-ENXIO);
> +}
>  static inline int devm_nsio_enable(struct device *dev,
>  		struct nd_namespace_io *nsio)
>  {
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index f8fd379501bf..51a214ee75a7 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -10,6 +10,7 @@
>   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>   * General Public License for more details.
>   */
> +#include <linux/memremap.h>
>  #include <linux/blkdev.h>
>  #include <linux/device.h>
>  #include <linux/genhd.h>
> @@ -441,3 +442,185 @@ int nd_pfn_probe(struct device *dev, struct
> nd_namespace_common *ndns) return rc;
>  }
>  EXPORT_SYMBOL(nd_pfn_probe);
> +
> +/*
> + * We hotplug memory at section granularity, pad the reserved area from
> + * the previous section base to the namespace base address.
> + */
> +static unsigned long init_altmap_base(resource_size_t base)
> +{
> +	unsigned long base_pfn =3D PHYS_PFN(base);
> +
> +	return PFN_SECTION_ALIGN_DOWN(base_pfn);
> +}
> +
> +static unsigned long init_altmap_reserve(resource_size_t base)
> +{
> +	unsigned long reserve =3D PHYS_PFN(SZ_8K);
> +	unsigned long base_pfn =3D PHYS_PFN(base);
> +
> +	reserve +=3D base_pfn - PFN_SECTION_ALIGN_DOWN(base_pfn);
> +	return reserve;
> +}
> +
> +static struct vmem_altmap *__nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
> +		struct resource *res, struct vmem_altmap *altmap)
> +{
> +	struct nd_pfn_sb *pfn_sb =3D nd_pfn->pfn_sb;
> +	u64 offset =3D le64_to_cpu(pfn_sb->dataoff);
> +	u32 start_pad =3D __le32_to_cpu(pfn_sb->start_pad);
> +	u32 end_trunc =3D __le32_to_cpu(pfn_sb->end_trunc);
> +	struct nd_namespace_common *ndns =3D nd_pfn->ndns;
> +	struct nd_namespace_io *nsio =3D to_nd_namespace_io(&ndns->dev);
> +	resource_size_t base =3D nsio->res.start + start_pad;
> +	struct vmem_altmap __altmap =3D {
> +		.base_pfn =3D init_altmap_base(base),
> +		.reserve =3D init_altmap_reserve(base),
> +	};
> +
> +	memcpy(res, &nsio->res, sizeof(*res));
> +	res->start +=3D start_pad;
> +	res->end -=3D end_trunc;
> +
> +	nd_pfn->mode =3D le32_to_cpu(nd_pfn->pfn_sb->mode);
> +	if (nd_pfn->mode =3D=3D PFN_MODE_RAM) {
> +		if (offset < SZ_8K)
> +			return ERR_PTR(-EINVAL);
> +		nd_pfn->npfns =3D le64_to_cpu(pfn_sb->npfns);
> +		altmap =3D NULL;
> +	} else if (nd_pfn->mode =3D=3D PFN_MODE_PMEM) {
> +		nd_pfn->npfns =3D (resource_size(res) - offset) / PAGE_SIZE;
> +		if (le64_to_cpu(nd_pfn->pfn_sb->npfns) > nd_pfn->npfns)
> +			dev_info(&nd_pfn->dev,
> +					"number of pfns truncated from %lld to %ld\n",
> +					le64_to_cpu(nd_pfn->pfn_sb->npfns),
> +					nd_pfn->npfns);
> +		memcpy(altmap, &__altmap, sizeof(*altmap));
> +		altmap->free =3D PHYS_PFN(offset - SZ_8K);
> +		altmap->alloc =3D 0;
> +	} else
> +		return ERR_PTR(-ENXIO);
> +
> +	return altmap;
> +}
> +
> +static int nd_pfn_init(struct nd_pfn *nd_pfn)
> +{
> +	struct nd_namespace_common *ndns =3D nd_pfn->ndns;
> +	u32 start_pad =3D 0, end_trunc =3D 0;
> +	resource_size_t start, size;
> +	struct nd_namespace_io *nsio;
> +	struct nd_region *nd_region;
> +	struct nd_pfn_sb *pfn_sb;
> +	unsigned long npfns;
> +	phys_addr_t offset;
> +	u64 checksum;
> +	int rc;
> +
> +	pfn_sb =3D devm_kzalloc(&nd_pfn->dev, sizeof(*pfn_sb), GFP_KERNEL);
> +	if (!pfn_sb)
> +		return -ENOMEM;
> +
> +	nd_pfn->pfn_sb =3D pfn_sb;
> +	rc =3D nd_pfn_validate(nd_pfn);
> +	if (rc =3D=3D -ENODEV)
> +		/* no info block, do init */;
> +	else
> +		return rc;

Why not:
if (rc !=3D -ENODEV)
	return  rc;
/* no info block, do init */


> +
> +	nd_region =3D to_nd_region(nd_pfn->dev.parent);
> +	if (nd_region->ro) {
> +		dev_info(&nd_pfn->dev,
> +				"%s is read-only, unable to init metadata\n",
> +				dev_name(&nd_region->dev));
> +		return -ENXIO;
> +	}
> +
> +	memset(pfn_sb, 0, sizeof(*pfn_sb));
> +
> +	/*
> +	 * Check if pmem collides with 'System RAM' when section aligned and
> +	 * trim it accordingly
> +	 */
> +	nsio =3D to_nd_namespace_io(&ndns->dev);
> +	start =3D PHYS_SECTION_ALIGN_DOWN(nsio->res.start);
> +	size =3D resource_size(&nsio->res);
> +	if (region_intersects(start, size, IORESOURCE_SYSTEM_RAM,
> +				IORES_DESC_NONE) =3D=3D REGION_MIXED) {
> +
> +		start =3D nsio->res.start;
> +		start_pad =3D PHYS_SECTION_ALIGN_UP(start) - start;
> +	}
> +
> +	start =3D nsio->res.start;
> +	size =3D PHYS_SECTION_ALIGN_UP(start + size) - start;
> +	if (region_intersects(start, size, IORESOURCE_SYSTEM_RAM,
> +				IORES_DESC_NONE) =3D=3D REGION_MIXED) {
> +		size =3D resource_size(&nsio->res);
> +		end_trunc =3D start + size - PHYS_SECTION_ALIGN_DOWN(start + size);
> +	}
> +
> +	if (start_pad + end_trunc)
> +		dev_info(&nd_pfn->dev, "%s section collision, truncate %d bytes\n",
> +				dev_name(&ndns->dev), start_pad + end_trunc);
> +
> +	/*
> +	 * Note, we use 64 here for the standard size of struct page,
> +	 * debugging options may cause it to be larger in which case the
> +	 * implementation will limit the pfns advertised through
> +	 * ->direct_access() to those that are included in the memmap.
> +	 */
> +	start +=3D start_pad;
> +	size =3D resource_size(&nsio->res);
> +	npfns =3D (size - start_pad - end_trunc - SZ_8K) / SZ_4K;
> +	if (nd_pfn->mode =3D=3D PFN_MODE_PMEM)
> +		offset =3D ALIGN(start + SZ_8K + 64 * npfns, nd_pfn->align)
> +			- start;
> +	else if (nd_pfn->mode =3D=3D PFN_MODE_RAM)
> +		offset =3D ALIGN(start + SZ_8K, nd_pfn->align) - start;
> +	else
> +		return -ENXIO;
> +
> +	if (offset + start_pad + end_trunc >=3D size) {
> +		dev_err(&nd_pfn->dev, "%s unable to satisfy requested alignment\n",
> +				dev_name(&ndns->dev));
> +		return -ENXIO;
> +	}
> +
> +	npfns =3D (size - offset - start_pad - end_trunc) / SZ_4K;
> +	pfn_sb->mode =3D cpu_to_le32(nd_pfn->mode);
> +	pfn_sb->dataoff =3D cpu_to_le64(offset);
> +	pfn_sb->npfns =3D cpu_to_le64(npfns);
> +	memcpy(pfn_sb->signature, PFN_SIG, PFN_SIG_LEN);
> +	memcpy(pfn_sb->uuid, nd_pfn->uuid, 16);
> +	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
> +	pfn_sb->version_major =3D cpu_to_le16(1);
> +	pfn_sb->version_minor =3D cpu_to_le16(1);
> +	pfn_sb->start_pad =3D cpu_to_le32(start_pad);
> +	pfn_sb->end_trunc =3D cpu_to_le32(end_trunc);
> +	checksum =3D nd_sb_checksum((struct nd_gen_sb *) pfn_sb);
> +	pfn_sb->checksum =3D cpu_to_le64(checksum);
> +
> +	return nvdimm_write_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb));
> +}
> +
> +/*
> + * Determine the effective resource range and vmem_altmap from an nd_pfn
> + * instance.
> + */
> +struct vmem_altmap *nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
> +		struct resource *res, struct vmem_altmap *altmap)
> +{
> +	int rc;
> +
> +	if (!nd_pfn->uuid || !nd_pfn->ndns)
> +		return ERR_PTR(-ENODEV);
> +
> +	rc =3D nd_pfn_init(nd_pfn);
> +	if (rc)
> +		return ERR_PTR(rc);
> +
> +	/* we need a valid pfn_sb before we can init a vmem_altmap */
> +	return __nvdimm_setup_pfn(nd_pfn, res, altmap);
> +}
> +EXPORT_SYMBOL_GPL(nvdimm_setup_pfn);
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 03bfb3422da1..616a16cd655b 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -182,9 +182,6 @@ void pmem_release_disk(void *disk)
>  	put_disk(disk);
>  }
> =

> -static struct vmem_altmap *nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
> -		struct resource *res, struct vmem_altmap *altmap);
> -
>  static int pmem_attach_disk(struct device *dev,
>  		struct nd_namespace_common *ndns)
>  {
> @@ -296,187 +293,6 @@ static int pmem_attach_disk(struct device *dev,
>  	return 0;
>  }
> =

> -static int nd_pfn_init(struct nd_pfn *nd_pfn)
> -{
> -	struct pmem_device *pmem =3D dev_get_drvdata(&nd_pfn->dev);
> -	struct nd_namespace_common *ndns =3D nd_pfn->ndns;
> -	u32 start_pad =3D 0, end_trunc =3D 0;
> -	resource_size_t start, size;
> -	struct nd_namespace_io *nsio;
> -	struct nd_region *nd_region;
> -	struct nd_pfn_sb *pfn_sb;
> -	unsigned long npfns;
> -	phys_addr_t offset;
> -	u64 checksum;
> -	int rc;
> -
> -	pfn_sb =3D devm_kzalloc(&nd_pfn->dev, sizeof(*pfn_sb), GFP_KERNEL);
> -	if (!pfn_sb)
> -		return -ENOMEM;
> -
> -	nd_pfn->pfn_sb =3D pfn_sb;
> -	rc =3D nd_pfn_validate(nd_pfn);
> -	if (rc =3D=3D -ENODEV)
> -		/* no info block, do init */;
> -	else
> -		return rc;
> -
> -	nd_region =3D to_nd_region(nd_pfn->dev.parent);
> -	if (nd_region->ro) {
> -		dev_info(&nd_pfn->dev,
> -				"%s is read-only, unable to init metadata\n",
> -				dev_name(&nd_region->dev));
> -		return -ENXIO;
> -	}
> -
> -	memset(pfn_sb, 0, sizeof(*pfn_sb));
> -
> -	/*
> -	 * Check if pmem collides with 'System RAM' when section aligned and
> -	 * trim it accordingly
> -	 */
> -	nsio =3D to_nd_namespace_io(&ndns->dev);
> -	start =3D PHYS_SECTION_ALIGN_DOWN(nsio->res.start);
> -	size =3D resource_size(&nsio->res);
> -	if (region_intersects(start, size, IORESOURCE_SYSTEM_RAM,
> -				IORES_DESC_NONE) =3D=3D REGION_MIXED) {
> -
> -		start =3D nsio->res.start;
> -		start_pad =3D PHYS_SECTION_ALIGN_UP(start) - start;
> -	}
> -
> -	start =3D nsio->res.start;
> -	size =3D PHYS_SECTION_ALIGN_UP(start + size) - start;
> -	if (region_intersects(start, size, IORESOURCE_SYSTEM_RAM,
> -				IORES_DESC_NONE) =3D=3D REGION_MIXED) {
> -		size =3D resource_size(&nsio->res);
> -		end_trunc =3D start + size - PHYS_SECTION_ALIGN_DOWN(start + size);
> -	}
> -
> -	if (start_pad + end_trunc)
> -		dev_info(&nd_pfn->dev, "%s section collision, truncate %d bytes\n",
> -				dev_name(&ndns->dev), start_pad + end_trunc);
> -
> -	/*
> -	 * Note, we use 64 here for the standard size of struct page,
> -	 * debugging options may cause it to be larger in which case the
> -	 * implementation will limit the pfns advertised through
> -	 * ->direct_access() to those that are included in the memmap.
> -	 */
> -	start +=3D start_pad;
> -	npfns =3D (pmem->size - start_pad - end_trunc - SZ_8K) / SZ_4K;
> -	if (nd_pfn->mode =3D=3D PFN_MODE_PMEM)
> -		offset =3D ALIGN(start + SZ_8K + 64 * npfns, nd_pfn->align)
> -			- start;
> -	else if (nd_pfn->mode =3D=3D PFN_MODE_RAM)
> -		offset =3D ALIGN(start + SZ_8K, nd_pfn->align) - start;
> -	else
> -		return -ENXIO;
> -
> -	if (offset + start_pad + end_trunc >=3D pmem->size) {
> -		dev_err(&nd_pfn->dev, "%s unable to satisfy requested alignment\n",
> -				dev_name(&ndns->dev));
> -		return -ENXIO;
> -	}
> -
> -	npfns =3D (pmem->size - offset - start_pad - end_trunc) / SZ_4K;
> -	pfn_sb->mode =3D cpu_to_le32(nd_pfn->mode);
> -	pfn_sb->dataoff =3D cpu_to_le64(offset);
> -	pfn_sb->npfns =3D cpu_to_le64(npfns);
> -	memcpy(pfn_sb->signature, PFN_SIG, PFN_SIG_LEN);
> -	memcpy(pfn_sb->uuid, nd_pfn->uuid, 16);
> -	memcpy(pfn_sb->parent_uuid, nd_dev_to_uuid(&ndns->dev), 16);
> -	pfn_sb->version_major =3D cpu_to_le16(1);
> -	pfn_sb->version_minor =3D cpu_to_le16(1);
> -	pfn_sb->start_pad =3D cpu_to_le32(start_pad);
> -	pfn_sb->end_trunc =3D cpu_to_le32(end_trunc);
> -	checksum =3D nd_sb_checksum((struct nd_gen_sb *) pfn_sb);
> -	pfn_sb->checksum =3D cpu_to_le64(checksum);
> -
> -	return nvdimm_write_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb));
> -}
> -
> -/*
> - * We hotplug memory at section granularity, pad the reserved area from
> - * the previous section base to the namespace base address.
> - */
> -static unsigned long init_altmap_base(resource_size_t base)
> -{
> -	unsigned long base_pfn =3D PHYS_PFN(base);
> -
> -	return PFN_SECTION_ALIGN_DOWN(base_pfn);
> -}
> -
> -static unsigned long init_altmap_reserve(resource_size_t base)
> -{
> -	unsigned long reserve =3D PHYS_PFN(SZ_8K);
> -	unsigned long base_pfn =3D PHYS_PFN(base);
> -
> -	reserve +=3D base_pfn - PFN_SECTION_ALIGN_DOWN(base_pfn);
> -	return reserve;
> -}
> -
> -static struct vmem_altmap *__nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
> -		struct resource *res, struct vmem_altmap *altmap)
> -{
> -	struct nd_pfn_sb *pfn_sb =3D nd_pfn->pfn_sb;
> -	u64 offset =3D le64_to_cpu(pfn_sb->dataoff);
> -	u32 start_pad =3D __le32_to_cpu(pfn_sb->start_pad);
> -	u32 end_trunc =3D __le32_to_cpu(pfn_sb->end_trunc);
> -	struct nd_namespace_common *ndns =3D nd_pfn->ndns;
> -	struct nd_namespace_io *nsio =3D to_nd_namespace_io(&ndns->dev);
> -	resource_size_t base =3D nsio->res.start + start_pad;
> -	struct vmem_altmap __altmap =3D {
> -		.base_pfn =3D init_altmap_base(base),
> -		.reserve =3D init_altmap_reserve(base),
> -	};
> -
> -	memcpy(res, &nsio->res, sizeof(*res));
> -	res->start +=3D start_pad;
> -	res->end -=3D end_trunc;
> -
> -	nd_pfn->mode =3D le32_to_cpu(nd_pfn->pfn_sb->mode);
> -	if (nd_pfn->mode =3D=3D PFN_MODE_RAM) {
> -		if (offset < SZ_8K)
> -			return ERR_PTR(-EINVAL);
> -		nd_pfn->npfns =3D le64_to_cpu(pfn_sb->npfns);
> -		altmap =3D NULL;
> -	} else if (nd_pfn->mode =3D=3D PFN_MODE_PMEM) {
> -		nd_pfn->npfns =3D (resource_size(res) - offset) / PAGE_SIZE;
> -		if (le64_to_cpu(nd_pfn->pfn_sb->npfns) > nd_pfn->npfns)
> -			dev_info(&nd_pfn->dev,
> -					"number of pfns truncated from %lld to %ld\n",
> -					le64_to_cpu(nd_pfn->pfn_sb->npfns),
> -					nd_pfn->npfns);
> -		memcpy(altmap, &__altmap, sizeof(*altmap));
> -		altmap->free =3D PHYS_PFN(offset - SZ_8K);
> -		altmap->alloc =3D 0;
> -	} else
> -		return ERR_PTR(-ENXIO);
> -
> -	return altmap;
> -}
> -
> -/*
> - * Determine the effective resource range and vmem_altmap from an nd_pfn
> - * instance.
> - */
> -static struct vmem_altmap *nvdimm_setup_pfn(struct nd_pfn *nd_pfn,
> -		struct resource *res, struct vmem_altmap *altmap)
> -{
> -	int rc;
> -
> -	if (!nd_pfn->uuid || !nd_pfn->ndns)
> -		return ERR_PTR(-ENODEV);
> -
> -	rc =3D nd_pfn_init(nd_pfn);
> -	if (rc)
> -		return ERR_PTR(rc);
> -
> -	/* we need a valid pfn_sb before we can init a vmem_altmap */
> -	return __nvdimm_setup_pfn(nd_pfn, res, altmap);
> -}
> -
>  static int nd_pmem_probe(struct device *dev)
>  {
>  	struct nd_namespace_common *ndns;
> =

> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm


-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
