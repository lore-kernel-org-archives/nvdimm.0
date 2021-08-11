Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8D517F
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 18:13:52 +0000 (UTC)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GlHxP1vSnz6GFdC;
	Thu, 12 Aug 2021 02:13:13 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 11 Aug 2021 20:13:50 +0200
Received: from localhost (10.52.123.85) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 11 Aug
 2021 19:13:49 +0100
Date: Wed, 11 Aug 2021 19:13:19 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, <nvdimm@lists.linux.dev>,
	<ben.widawsky@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 10/23] libnvdimm/labels: Add uuid helpers
Message-ID: <20210811191319.00006d64@Huawei.com>
In-Reply-To: <162854812073.1980150.8157116233571368158.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162854812073.1980150.8157116233571368158.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Mon, 9 Aug 2021 15:28:40 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for CXL labels that move the uuid to a different offset
> in the label, add nsl_{ref,get,validate}_uuid(). These helpers use the
> proper uuid_t type. That type definition predated the libnvdimm
> subsystem, so now is as a good a time as any to convert all the uuid
> handling in the subsystem to uuid_t to match the helpers.
> 
> As for the whitespace changes, all new code is clang-format compliant.
> 
> Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

There are a few interesting corners where you have cleaned out a pointless
copy before validating uuids. Perhaps call that out as a change in here
as it isn't as simple as just replacing like with like?
Perhaps I'm missing some reason that was needed in the code before this
patch.

All LGTM.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/nvdimm/btt.c            |   11 +++--
>  drivers/nvdimm/btt.h            |    4 +-
>  drivers/nvdimm/btt_devs.c       |   12 +++---
>  drivers/nvdimm/core.c           |   40 ++-----------------
>  drivers/nvdimm/label.c          |   34 +++++++---------
>  drivers/nvdimm/label.h          |    3 -
>  drivers/nvdimm/namespace_devs.c |   83 ++++++++++++++++++++-------------------
>  drivers/nvdimm/nd-core.h        |    5 +-
>  drivers/nvdimm/nd.h             |   37 ++++++++++++++++-
>  drivers/nvdimm/pfn_devs.c       |    2 -
>  include/linux/nd.h              |    4 +-
>  11 files changed, 115 insertions(+), 120 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index 92dec4952297..1cdfbadb7408 100644

> @@ -1050,7 +1050,6 @@ static int __blk_label_update(struct nd_region *nd_region,
>  	unsigned long *free, *victim_map = NULL;
>  	struct resource *res, **old_res_list;
>  	struct nd_label_id label_id;
> -	u8 uuid[NSLABEL_UUID_LEN];
>  	int min_dpa_idx = 0;
>  	LIST_HEAD(list);
>  	u32 nslot, slot;
> @@ -1088,8 +1087,7 @@ static int __blk_label_update(struct nd_region *nd_region,
>  		/* mark unused labels for garbage collection */
>  		for_each_clear_bit_le(slot, free, nslot) {
>  			nd_label = to_label(ndd, slot);
> -			memcpy(uuid, nd_label->uuid, NSLABEL_UUID_LEN);
> -			if (memcmp(uuid, nsblk->uuid, NSLABEL_UUID_LEN) != 0)
> +			if (!nsl_validate_uuid(ndd, nd_label, nsblk->uuid))
>  				continue;

The original code here was 'unusual'. I'm not sure why it couldn't always be
validated in place. 

>  			res = to_resource(ndd, nd_label);
>  			if (res && is_old_resource(res, old_res_list,
> @@ -1158,7 +1156,7 @@ static int __blk_label_update(struct nd_region *nd_region,
>  
>  		nd_label = to_label(ndd, slot);
>  		memset(nd_label, 0, sizeof_namespace_label(ndd));
> -		memcpy(nd_label->uuid, nsblk->uuid, NSLABEL_UUID_LEN);

> +		nsl_set_uuid(ndd, nd_label, nsblk->uuid);
>  		nsl_set_name(ndd, nd_label, nsblk->alt_name);
>  		nsl_set_flags(ndd, nd_label, NSLABEL_FLAG_LOCAL);
>  
> @@ -1206,8 +1204,7 @@ static int __blk_label_update(struct nd_region *nd_region,
>  		if (!nd_label)
>  			continue;
>  		nlabel++;
> -		memcpy(uuid, nd_label->uuid, NSLABEL_UUID_LEN);
> -		if (memcmp(uuid, nsblk->uuid, NSLABEL_UUID_LEN) != 0)
> +		if (!nsl_validate_uuid(ndd, nd_label, nsblk->uuid))
>  			continue;
>  		nlabel--;
>  		list_move(&label_ent->list, &list);
> @@ -1237,8 +1234,7 @@ static int __blk_label_update(struct nd_region *nd_region,
>  	}
>  	for_each_clear_bit_le(slot, free, nslot) {
>  		nd_label = to_label(ndd, slot);
> -		memcpy(uuid, nd_label->uuid, NSLABEL_UUID_LEN);
> -		if (memcmp(uuid, nsblk->uuid, NSLABEL_UUID_LEN) != 0)
> +		if (!nsl_validate_uuid(ndd, nd_label, nsblk->uuid))
>  			continue;
>  		res = to_resource(ndd, nd_label);
>  		res->flags &= ~DPA_RESOURCE_ADJUSTED;
> @@ -1318,12 +1314,11 @@ static int init_labels(struct nd_mapping *nd_mapping, int num_labels)
>  	return max(num_labels, old_num_labels);
>  }
