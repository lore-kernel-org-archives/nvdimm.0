Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98DC72
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 18:44:37 +0000 (UTC)
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GlJct1lhFz6GFdC;
	Thu, 12 Aug 2021 02:43:58 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 11 Aug 2021 20:44:35 +0200
Received: from localhost (10.52.123.85) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 11 Aug
 2021 19:44:34 +0100
Date: Wed, 11 Aug 2021 19:44:04 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<ben.widawsky@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 01/23] libnvdimm/labels: Introduce getters for namespace
 label fields
Message-ID: <20210811194404.00004e1b@Huawei.com>
In-Reply-To: <162854807225.1980150.1621800063058284957.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162854807225.1980150.1621800063058284957.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.52.123.85]
X-ClientProxiedBy: lhreml716-chm.china.huawei.com (10.201.108.67) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Mon, 9 Aug 2021 15:27:52 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for LIBNVDIMM to manage labels on CXL devices deploy
> helpers that abstract the label type from the implementation. The CXL
> label format is mostly similar to the EFI label format with concepts /
> fields added, like dynamic region creation and label type guids, and
> other concepts removed like BLK-mode and interleave-set-cookie ids.
> 
> In addition to nsl_get_* helpers there is the nsl_ref_name() helper that
> returns a pointer to a label field rather than copying the data.
> 
> Where changes touch the old whitespace style, update to clang-format
> expectations.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Checked it's a straight forward refactor and lgtm
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/nvdimm/label.c          |   20 ++++++-----
>  drivers/nvdimm/namespace_devs.c |   70 +++++++++++++++++++--------------------
>  drivers/nvdimm/nd.h             |   66 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 110 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 9251441fd8a3..b6d845cfb70e 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -350,14 +350,14 @@ static bool slot_valid(struct nvdimm_drvdata *ndd,
>  		struct nd_namespace_label *nd_label, u32 slot)
>  {
>  	/* check that we are written where we expect to be written */
> -	if (slot != __le32_to_cpu(nd_label->slot))
> +	if (slot != nsl_get_slot(ndd, nd_label))
>  		return false;
>  
>  	/* check checksum */
>  	if (namespace_label_has(ndd, checksum)) {
>  		u64 sum, sum_save;
>  
> -		sum_save = __le64_to_cpu(nd_label->checksum);
> +		sum_save = nsl_get_checksum(ndd, nd_label);
>  		nd_label->checksum = __cpu_to_le64(0);
>  		sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
>  		nd_label->checksum = __cpu_to_le64(sum_save);
> @@ -395,13 +395,13 @@ int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
>  			continue;
>  
>  		memcpy(label_uuid, nd_label->uuid, NSLABEL_UUID_LEN);
> -		flags = __le32_to_cpu(nd_label->flags);
> +		flags = nsl_get_flags(ndd, nd_label);
>  		if (test_bit(NDD_NOBLK, &nvdimm->flags))
>  			flags &= ~NSLABEL_FLAG_LOCAL;
>  		nd_label_gen_id(&label_id, label_uuid, flags);
>  		res = nvdimm_allocate_dpa(ndd, &label_id,
> -				__le64_to_cpu(nd_label->dpa),
> -				__le64_to_cpu(nd_label->rawsize));
> +					  nsl_get_dpa(ndd, nd_label),
> +					  nsl_get_rawsize(ndd, nd_label));
>  		nd_dbg_dpa(nd_region, ndd, res, "reserve\n");
>  		if (!res)
>  			return -EBUSY;
> @@ -548,9 +548,9 @@ int nd_label_active_count(struct nvdimm_drvdata *ndd)
>  		nd_label = to_label(ndd, slot);
>  
>  		if (!slot_valid(ndd, nd_label, slot)) {
> -			u32 label_slot = __le32_to_cpu(nd_label->slot);
> -			u64 size = __le64_to_cpu(nd_label->rawsize);
> -			u64 dpa = __le64_to_cpu(nd_label->dpa);
> +			u32 label_slot = nsl_get_slot(ndd, nd_label);
> +			u64 size = nsl_get_rawsize(ndd, nd_label);
> +			u64 dpa = nsl_get_dpa(ndd, nd_label);
>  
>  			dev_dbg(ndd->dev,
>  				"slot%d invalid slot: %d dpa: %llx size: %llx\n",
> @@ -879,9 +879,9 @@ static struct resource *to_resource(struct nvdimm_drvdata *ndd,
>  	struct resource *res;
>  
>  	for_each_dpa_resource(ndd, res) {
> -		if (res->start != __le64_to_cpu(nd_label->dpa))
> +		if (res->start != nsl_get_dpa(ndd, nd_label))
>  			continue;
> -		if (resource_size(res) != __le64_to_cpu(nd_label->rawsize))
> +		if (resource_size(res) != nsl_get_rawsize(ndd, nd_label))
>  			continue;
>  		return res;
>  	}
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 2403b71b601e..94da804372bf 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1235,7 +1235,7 @@ static int namespace_update_uuid(struct nd_region *nd_region,
>  			if (!nd_label)
>  				continue;
>  			nd_label_gen_id(&label_id, nd_label->uuid,
> -					__le32_to_cpu(nd_label->flags));
> +					nsl_get_flags(ndd, nd_label));
>  			if (strcmp(old_label_id.id, label_id.id) == 0)
>  				set_bit(ND_LABEL_REAP, &label_ent->flags);
>  		}
> @@ -1851,9 +1851,9 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
>  
>  			if (!nd_label)
>  				continue;
> -			isetcookie = __le64_to_cpu(nd_label->isetcookie);
> -			position = __le16_to_cpu(nd_label->position);
> -			nlabel = __le16_to_cpu(nd_label->nlabel);
> +			isetcookie = nsl_get_isetcookie(ndd, nd_label);
> +			position = nsl_get_position(ndd, nd_label);
> +			nlabel = nsl_get_nlabel(ndd, nd_label);
>  
>  			if (isetcookie != cookie)
>  				continue;
> @@ -1923,8 +1923,8 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
>  		 */
>  		hw_start = nd_mapping->start;
>  		hw_end = hw_start + nd_mapping->size;
> -		pmem_start = __le64_to_cpu(nd_label->dpa);
> -		pmem_end = pmem_start + __le64_to_cpu(nd_label->rawsize);
> +		pmem_start = nsl_get_dpa(ndd, nd_label);
> +		pmem_end = pmem_start + nsl_get_rawsize(ndd, nd_label);
>  		if (pmem_start >= hw_start && pmem_start < hw_end
>  				&& pmem_end <= hw_end && pmem_end > hw_start)
>  			/* pass */;
> @@ -1947,14 +1947,16 @@ static int select_pmem_id(struct nd_region *nd_region, u8 *pmem_id)
>   * @nd_label: target pmem namespace label to evaluate
>   */
>  static struct device *create_namespace_pmem(struct nd_region *nd_region,
> -		struct nd_namespace_index *nsindex,
> -		struct nd_namespace_label *nd_label)
> +					    struct nd_mapping *nd_mapping,
> +					    struct nd_namespace_label *nd_label)
>  {
> +	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> +	struct nd_namespace_index *nsindex =
> +		to_namespace_index(ndd, ndd->ns_current);
>  	u64 cookie = nd_region_interleave_set_cookie(nd_region, nsindex);
>  	u64 altcookie = nd_region_interleave_set_altcookie(nd_region);
>  	struct nd_label_ent *label_ent;
>  	struct nd_namespace_pmem *nspm;
> -	struct nd_mapping *nd_mapping;
>  	resource_size_t size = 0;
>  	struct resource *res;
>  	struct device *dev;
> @@ -1966,10 +1968,10 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  		return ERR_PTR(-ENXIO);
>  	}
>  
> -	if (__le64_to_cpu(nd_label->isetcookie) != cookie) {
> +	if (nsl_get_isetcookie(ndd, nd_label) != cookie) {
>  		dev_dbg(&nd_region->dev, "invalid cookie in label: %pUb\n",
>  				nd_label->uuid);
> -		if (__le64_to_cpu(nd_label->isetcookie) != altcookie)
> +		if (nsl_get_isetcookie(ndd, nd_label) != altcookie)
>  			return ERR_PTR(-EAGAIN);
>  
>  		dev_dbg(&nd_region->dev, "valid altcookie in label: %pUb\n",
> @@ -2037,16 +2039,16 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  			continue;
>  		}
>  
> -		size += __le64_to_cpu(label0->rawsize);
> -		if (__le16_to_cpu(label0->position) != 0)
> +		ndd = to_ndd(nd_mapping);
> +		size += nsl_get_rawsize(ndd, label0);
> +		if (nsl_get_position(ndd, label0) != 0)
>  			continue;
>  		WARN_ON(nspm->alt_name || nspm->uuid);
> -		nspm->alt_name = kmemdup((void __force *) label0->name,
> -				NSLABEL_NAME_LEN, GFP_KERNEL);
> +		nspm->alt_name = kmemdup(nsl_ref_name(ndd, label0),
> +					 NSLABEL_NAME_LEN, GFP_KERNEL);
>  		nspm->uuid = kmemdup((void __force *) label0->uuid,
>  				NSLABEL_UUID_LEN, GFP_KERNEL);
> -		nspm->lbasize = __le64_to_cpu(label0->lbasize);
> -		ndd = to_ndd(nd_mapping);
> +		nspm->lbasize = nsl_get_lbasize(ndd, label0);
>  		if (namespace_label_has(ndd, abstraction_guid))
>  			nspm->nsio.common.claim_class
>  				= to_nvdimm_cclass(&label0->abstraction_guid);
> @@ -2237,7 +2239,7 @@ static int add_namespace_resource(struct nd_region *nd_region,
>  		if (is_namespace_blk(devs[i])) {
>  			res = nsblk_add_resource(nd_region, ndd,
>  					to_nd_namespace_blk(devs[i]),
> -					__le64_to_cpu(nd_label->dpa));
> +					nsl_get_dpa(ndd, nd_label));
>  			if (!res)
>  				return -ENXIO;
>  			nd_dbg_dpa(nd_region, ndd, res, "%d assign\n", count);
> @@ -2276,7 +2278,7 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
>  		if (nd_label->isetcookie != __cpu_to_le64(nd_set->cookie2)) {
>  			dev_dbg(ndd->dev, "expect cookie %#llx got %#llx\n",
>  					nd_set->cookie2,
> -					__le64_to_cpu(nd_label->isetcookie));
> +					nsl_get_isetcookie(ndd, nd_label));
>  			return ERR_PTR(-EAGAIN);
>  		}
>  	}
> @@ -2288,7 +2290,7 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
>  	dev->type = &namespace_blk_device_type;
>  	dev->parent = &nd_region->dev;
>  	nsblk->id = -1;
> -	nsblk->lbasize = __le64_to_cpu(nd_label->lbasize);
> +	nsblk->lbasize = nsl_get_lbasize(ndd, nd_label);
>  	nsblk->uuid = kmemdup(nd_label->uuid, NSLABEL_UUID_LEN,
>  			GFP_KERNEL);
>  	if (namespace_label_has(ndd, abstraction_guid))
> @@ -2296,15 +2298,14 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
>  			= to_nvdimm_cclass(&nd_label->abstraction_guid);
>  	if (!nsblk->uuid)
>  		goto blk_err;
> -	memcpy(name, nd_label->name, NSLABEL_NAME_LEN);
> +	nsl_get_name(ndd, nd_label, name);
>  	if (name[0]) {
> -		nsblk->alt_name = kmemdup(name, NSLABEL_NAME_LEN,
> -				GFP_KERNEL);
> +		nsblk->alt_name = kmemdup(name, NSLABEL_NAME_LEN, GFP_KERNEL);
>  		if (!nsblk->alt_name)
>  			goto blk_err;
>  	}
>  	res = nsblk_add_resource(nd_region, ndd, nsblk,
> -			__le64_to_cpu(nd_label->dpa));
> +			nsl_get_dpa(ndd, nd_label));
>  	if (!res)
>  		goto blk_err;
>  	nd_dbg_dpa(nd_region, ndd, res, "%d: assign\n", count);
> @@ -2345,6 +2346,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  	struct device *dev, **devs = NULL;
>  	struct nd_label_ent *label_ent, *e;
>  	struct nd_mapping *nd_mapping = &nd_region->mapping[0];
> +	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
>  	resource_size_t map_end = nd_mapping->start + nd_mapping->size - 1;
>  
>  	/* "safe" because create_namespace_pmem() might list_move() label_ent */
> @@ -2355,7 +2357,7 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  
>  		if (!nd_label)
>  			continue;
> -		flags = __le32_to_cpu(nd_label->flags);
> +		flags = nsl_get_flags(ndd, nd_label);
>  		if (is_nd_blk(&nd_region->dev)
>  				== !!(flags & NSLABEL_FLAG_LOCAL))
>  			/* pass, region matches label type */;
> @@ -2363,9 +2365,9 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  			continue;
>  
>  		/* skip labels that describe extents outside of the region */
> -		if (__le64_to_cpu(nd_label->dpa) < nd_mapping->start ||
> -		    __le64_to_cpu(nd_label->dpa) > map_end)
> -				continue;
> +		if (nsl_get_dpa(ndd, nd_label) < nd_mapping->start ||
> +		    nsl_get_dpa(ndd, nd_label) > map_end)
> +			continue;
>  
>  		i = add_namespace_resource(nd_region, nd_label, devs, count);
>  		if (i < 0)
> @@ -2381,13 +2383,9 @@ static struct device **scan_labels(struct nd_region *nd_region)
>  
>  		if (is_nd_blk(&nd_region->dev))
>  			dev = create_namespace_blk(nd_region, nd_label, count);
> -		else {
> -			struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
> -			struct nd_namespace_index *nsindex;
> -
> -			nsindex = to_namespace_index(ndd, ndd->ns_current);
> -			dev = create_namespace_pmem(nd_region, nsindex, nd_label);
> -		}
> +		else
> +			dev = create_namespace_pmem(nd_region, nd_mapping,
> +						    nd_label);
>  
>  		if (IS_ERR(dev)) {
>  			switch (PTR_ERR(dev)) {
> @@ -2570,7 +2568,7 @@ static int init_active_labels(struct nd_region *nd_region)
>  				break;
>  			label = nd_label_active(ndd, j);
>  			if (test_bit(NDD_NOBLK, &nvdimm->flags)) {
> -				u32 flags = __le32_to_cpu(label->flags);
> +				u32 flags = nsl_get_flags(ndd, label);
>  
>  				flags &= ~NSLABEL_FLAG_LOCAL;
>  				label->flags = __cpu_to_le32(flags);
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 696b55556d4d..61f43f0edabf 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -35,6 +35,72 @@ struct nvdimm_drvdata {
>  	struct kref kref;
>  };
>  
> +static inline const u8 *nsl_ref_name(struct nvdimm_drvdata *ndd,
> +				     struct nd_namespace_label *nd_label)
> +{
> +	return nd_label->name;
> +}
> +
> +static inline u8 *nsl_get_name(struct nvdimm_drvdata *ndd,
> +			       struct nd_namespace_label *nd_label, u8 *name)
> +{
> +	return memcpy(name, nd_label->name, NSLABEL_NAME_LEN);
> +}
> +
> +static inline u32 nsl_get_slot(struct nvdimm_drvdata *ndd,
> +			       struct nd_namespace_label *nd_label)
> +{
> +	return __le32_to_cpu(nd_label->slot);
> +}
> +
> +static inline u64 nsl_get_checksum(struct nvdimm_drvdata *ndd,
> +				   struct nd_namespace_label *nd_label)
> +{
> +	return __le64_to_cpu(nd_label->checksum);
> +}
> +
> +static inline u32 nsl_get_flags(struct nvdimm_drvdata *ndd,
> +				struct nd_namespace_label *nd_label)
> +{
> +	return __le32_to_cpu(nd_label->flags);
> +}
> +
> +static inline u64 nsl_get_dpa(struct nvdimm_drvdata *ndd,
> +			      struct nd_namespace_label *nd_label)
> +{
> +	return __le64_to_cpu(nd_label->dpa);
> +}
> +
> +static inline u64 nsl_get_rawsize(struct nvdimm_drvdata *ndd,
> +				  struct nd_namespace_label *nd_label)
> +{
> +	return __le64_to_cpu(nd_label->rawsize);
> +}
> +
> +static inline u64 nsl_get_isetcookie(struct nvdimm_drvdata *ndd,
> +				     struct nd_namespace_label *nd_label)
> +{
> +	return __le64_to_cpu(nd_label->isetcookie);
> +}
> +
> +static inline u16 nsl_get_position(struct nvdimm_drvdata *ndd,
> +				   struct nd_namespace_label *nd_label)
> +{
> +	return __le16_to_cpu(nd_label->position);
> +}
> +
> +static inline u16 nsl_get_nlabel(struct nvdimm_drvdata *ndd,
> +				 struct nd_namespace_label *nd_label)
> +{
> +	return __le16_to_cpu(nd_label->nlabel);
> +}
> +
> +static inline u64 nsl_get_lbasize(struct nvdimm_drvdata *ndd,
> +				  struct nd_namespace_label *nd_label)
> +{
> +	return __le64_to_cpu(nd_label->lbasize);
> +}
> +
>  struct nd_region_data {
>  	int ns_count;
>  	int ns_active;
> 

