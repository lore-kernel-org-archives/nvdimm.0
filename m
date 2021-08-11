Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C1172
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 18:46:37 +0000 (UTC)
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GlJgB1rRXz6GDtn;
	Thu, 12 Aug 2021 02:45:58 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 11 Aug 2021 20:46:35 +0200
Received: from localhost (10.52.123.85) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 11 Aug
 2021 19:46:34 +0100
Date: Wed, 11 Aug 2021 19:46:05 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<ben.widawsky@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 07/23] libnvdimm/labels: Add type-guid helpers
Message-ID: <20210811194605.00003c46@Huawei.com>
In-Reply-To: <162854810459.1980150.1781727637396465986.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162854810459.1980150.1781727637396465986.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Mon, 9 Aug 2021 15:28:24 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for CXL label support, which does not have the type-guid
> concept, wrap the existing users with nsl_set_type_guid, and
> nsl_validate_type_guid. Recall that the type-guid is a value in the ACPI
> NFIT table to indicate how the memory range is used / should be
> presented to upper layers.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/nvdimm/label.c          |   26 ++++++++++++++++++++++----
>  drivers/nvdimm/namespace_devs.c |   19 ++++---------------
>  drivers/nvdimm/nd.h             |    2 ++
>  3 files changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 7188675c0955..294ffc3cb582 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -772,6 +772,26 @@ static void reap_victim(struct nd_mapping *nd_mapping,
>  	victim->label = NULL;
>  }
>  
> +static void nsl_set_type_guid(struct nvdimm_drvdata *ndd,
> +			      struct nd_namespace_label *nd_label, guid_t *guid)
> +{
> +	if (namespace_label_has(ndd, type_guid))
> +		guid_copy(&nd_label->type_guid, guid);
> +}
> +
> +bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
> +			    struct nd_namespace_label *nd_label, guid_t *guid)
> +{
> +	if (!namespace_label_has(ndd, type_guid))
> +		return true;
> +	if (!guid_equal(&nd_label->type_guid, guid)) {
> +		dev_dbg(ndd->dev, "expect type_guid %pUb got %pUb\n", guid,
> +			&nd_label->type_guid);
> +		return false;
> +	}
> +	return true;
> +}
> +
>  static int __pmem_label_update(struct nd_region *nd_region,
>  		struct nd_mapping *nd_mapping, struct nd_namespace_pmem *nspm,
>  		int pos, unsigned long flags)
> @@ -822,8 +842,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	nsl_set_lbasize(ndd, nd_label, nspm->lbasize);
>  	nsl_set_dpa(ndd, nd_label, res->start);
>  	nsl_set_slot(ndd, nd_label, slot);
> -	if (namespace_label_has(ndd, type_guid))
> -		guid_copy(&nd_label->type_guid, &nd_set->type_guid);
> +	nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
>  	if (namespace_label_has(ndd, abstraction_guid))
>  		guid_copy(&nd_label->abstraction_guid,
>  				to_abstraction_guid(ndns->claim_class,
> @@ -1091,8 +1110,7 @@ static int __blk_label_update(struct nd_region *nd_region,
>  		nsl_set_rawsize(ndd, nd_label, resource_size(res));
>  		nsl_set_lbasize(ndd, nd_label, nsblk->lbasize);
>  		nsl_set_slot(ndd, nd_label, slot);
> -		if (namespace_label_has(ndd, type_guid))
> -			guid_copy(&nd_label->type_guid, &nd_set->type_guid);
> +		nsl_set_type_guid(ndd, nd_label, &nd_set->type_guid);
>  		if (namespace_label_has(ndd, abstraction_guid))
>  			guid_copy(&nd_label->abstraction_guid,
>  					to_abstraction_guid(ndns->claim_class,
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index fbd0c2fcea4a..af5a31dd3147 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1859,14 +1859,9 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
>  			if (memcmp(nd_label->uuid, uuid, NSLABEL_UUID_LEN) != 0)
>  				continue;
>  
> -			if (namespace_label_has(ndd, type_guid)
> -					&& !guid_equal(&nd_set->type_guid,
> -						&nd_label->type_guid)) {
> -				dev_dbg(ndd->dev, "expect type_guid %pUb got %pUb\n",
> -						&nd_set->type_guid,
> -						&nd_label->type_guid);
> +			if (!nsl_validate_type_guid(ndd, nd_label,
> +						    &nd_set->type_guid))
>  				continue;
> -			}
>  
>  			if (found_uuid) {
>  				dev_dbg(ndd->dev, "duplicate entry for uuid\n");
> @@ -2265,14 +2260,8 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
>  	struct device *dev = NULL;
>  	struct resource *res;
>  
> -	if (namespace_label_has(ndd, type_guid)) {
> -		if (!guid_equal(&nd_set->type_guid, &nd_label->type_guid)) {
> -			dev_dbg(ndd->dev, "expect type_guid %pUb got %pUb\n",
> -					&nd_set->type_guid,
> -					&nd_label->type_guid);
> -			return ERR_PTR(-EAGAIN);
> -		}
> -	}
> +	if (!nsl_validate_type_guid(ndd, nd_label, &nd_set->type_guid))
> +		return ERR_PTR(-EAGAIN);
>  	if (!nsl_validate_blk_isetcookie(ndd, nd_label, nd_set->cookie2))
>  		return ERR_PTR(-EAGAIN);
>  
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 2a9a608b7f17..f3c364df9449 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -179,6 +179,8 @@ static inline void nsl_set_lbasize(struct nvdimm_drvdata *ndd,
>  bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
>  				 struct nd_namespace_label *nd_label,
>  				 u64 isetcookie);
> +bool nsl_validate_type_guid(struct nvdimm_drvdata *ndd,
> +			    struct nd_namespace_label *nd_label, guid_t *guid);
>  
>  struct nd_region_data {
>  	int ns_count;
> 

