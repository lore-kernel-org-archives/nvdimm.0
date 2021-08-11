Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7447772
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 18:45:40 +0000 (UTC)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GlJf62n6vz6G9JB;
	Thu, 12 Aug 2021 02:45:02 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 11 Aug 2021 20:45:37 +0200
Received: from localhost (10.52.123.85) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 11 Aug
 2021 19:45:37 +0100
Date: Wed, 11 Aug 2021 19:45:07 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<ben.widawsky@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 05/23] libnvdimm/labels: Add blk isetcookie set /
 validation helpers
Message-ID: <20210811194507.00000555@Huawei.com>
In-Reply-To: <162854809395.1980150.5182046005884745099.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162854809395.1980150.5182046005884745099.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Mon, 9 Aug 2021 15:28:14 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for LIBNVDIMM to manage labels on CXL devices deploy
> helpers that abstract the label type from the implementation. The CXL
> label format is mostly similar to the EFI label format with concepts /
> fields added, like dynamic region creation and label type guids, and
> other concepts removed like BLK-mode and interleave-set-cookie ids.
> 
> Given BLK-mode is not even supported on CXL push hide the BLK-mode
> specific details inside the helpers.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/nvdimm/label.c          |   30 ++++++++++++++++++++++++++++--
>  drivers/nvdimm/namespace_devs.c |    9 ++-------
>  drivers/nvdimm/nd.h             |    4 ++++
>  3 files changed, 34 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index 3f73412dd438..d1a7f399cfe4 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -898,6 +898,33 @@ static struct resource *to_resource(struct nvdimm_drvdata *ndd,
>  	return NULL;
>  }
>  
> +static void nsl_set_blk_isetcookie(struct nvdimm_drvdata *ndd,
> +				   struct nd_namespace_label *nd_label,
> +				   u64 isetcookie)
> +{
> +	if (namespace_label_has(ndd, type_guid)) {
> +		nsl_set_isetcookie(ndd, nd_label, isetcookie);
> +		return;
> +	}
> +	nsl_set_isetcookie(ndd, nd_label, 0); /* N/A */
> +}
> +
> +bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
> +				 struct nd_namespace_label *nd_label,
> +				 u64 isetcookie)
> +{
> +	if (!namespace_label_has(ndd, type_guid))
> +		return true;
> +
> +	if (nsl_get_isetcookie(ndd, nd_label) != isetcookie) {
> +		dev_dbg(ndd->dev, "expect cookie %#llx got %#llx\n", isetcookie,
> +			nsl_get_isetcookie(ndd, nd_label));
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
>  /*
>   * 1/ Account all the labels that can be freed after this update
>   * 2/ Allocate and write the label to the staging (next) index
> @@ -1042,12 +1069,11 @@ static int __blk_label_update(struct nd_region *nd_region,
>  				nsl_set_nlabel(ndd, nd_label, 0xffff);
>  				nsl_set_position(ndd, nd_label, 0xffff);
>  			}
> -			nsl_set_isetcookie(ndd, nd_label, nd_set->cookie2);
>  		} else {
>  			nsl_set_nlabel(ndd, nd_label, 0); /* N/A */
>  			nsl_set_position(ndd, nd_label, 0); /* N/A */
> -			nsl_set_isetcookie(ndd, nd_label, 0); /* N/A */
>  		}
> +		nsl_set_blk_isetcookie(ndd, nd_label, nd_set->cookie2);
>  
>  		nsl_set_dpa(ndd, nd_label, res->start);
>  		nsl_set_rawsize(ndd, nd_label, resource_size(res));
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index fb9e080ce654..fbd0c2fcea4a 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -2272,14 +2272,9 @@ static struct device *create_namespace_blk(struct nd_region *nd_region,
>  					&nd_label->type_guid);
>  			return ERR_PTR(-EAGAIN);
>  		}
> -
> -		if (nd_label->isetcookie != __cpu_to_le64(nd_set->cookie2)) {
> -			dev_dbg(ndd->dev, "expect cookie %#llx got %#llx\n",
> -					nd_set->cookie2,
> -					nsl_get_isetcookie(ndd, nd_label));
> -			return ERR_PTR(-EAGAIN);
> -		}
>  	}
> +	if (!nsl_validate_blk_isetcookie(ndd, nd_label, nd_set->cookie2))
> +		return ERR_PTR(-EAGAIN);
>  
>  	nsblk = kzalloc(sizeof(*nsblk), GFP_KERNEL);
>  	if (!nsblk)
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 416846fe7818..2a9a608b7f17 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -176,6 +176,10 @@ static inline void nsl_set_lbasize(struct nvdimm_drvdata *ndd,
>  	nd_label->lbasize = __cpu_to_le64(lbasize);
>  }
>  
> +bool nsl_validate_blk_isetcookie(struct nvdimm_drvdata *ndd,
> +				 struct nd_namespace_label *nd_label,
> +				 u64 isetcookie);
> +
>  struct nd_region_data {
>  	int ns_count;
>  	int ns_active;
> 

