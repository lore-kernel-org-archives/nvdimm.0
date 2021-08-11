Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8A272
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 18:45:17 +0000 (UTC)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GlJdj4VsCz6BF7l;
	Thu, 12 Aug 2021 02:44:41 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 11 Aug 2021 20:45:14 +0200
Received: from localhost (10.52.123.85) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 11 Aug
 2021 19:45:13 +0100
Date: Wed, 11 Aug 2021 19:44:43 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<ben.widawsky@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 04/23] libnvdimm/labels: Add a checksum calculation
 helper
Message-ID: <20210811194443.00005e60@Huawei.com>
In-Reply-To: <162854808885.1980150.16357075479454603275.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162854808885.1980150.16357075479454603275.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Mon, 9 Aug 2021 15:28:08 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation for LIBNVDIMM to manage labels on CXL devices deploy
> helpers that abstract the label type from the implementation. The CXL
> label format is mostly similar to the EFI label format with concepts /
> fields added, like dynamic region creation and label type guids, and
> other concepts removed like BLK-mode and interleave-set-cookie ids.
> 
> CXL labels support checksums by default, but early versions of the EFI
> labels did not. Add a validate function that can return true in the case
> the label format does not implement a checksum.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/nvdimm/label.c |   68 +++++++++++++++++++++++++-----------------------
>  1 file changed, 35 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index b40a4eda1d89..3f73412dd438 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -346,29 +346,45 @@ static bool preamble_next(struct nvdimm_drvdata *ndd,
>  			free, nslot);
>  }
>  
> +static bool nsl_validate_checksum(struct nvdimm_drvdata *ndd,
> +				  struct nd_namespace_label *nd_label)
> +{
> +	u64 sum, sum_save;
> +
> +	if (!namespace_label_has(ndd, checksum))
> +		return true;
> +
> +	sum_save = nsl_get_checksum(ndd, nd_label);
> +	nsl_set_checksum(ndd, nd_label, 0);
> +	sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
> +	nsl_set_checksum(ndd, nd_label, sum_save);
> +	return sum == sum_save;
> +}
> +
> +static void nsl_calculate_checksum(struct nvdimm_drvdata *ndd,
> +				   struct nd_namespace_label *nd_label)
> +{
> +	u64 sum;
> +
> +	if (!namespace_label_has(ndd, checksum))
> +		return;
> +	nsl_set_checksum(ndd, nd_label, 0);
> +	sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
> +	nsl_set_checksum(ndd, nd_label, sum);
> +}
> +
>  static bool slot_valid(struct nvdimm_drvdata *ndd,
>  		struct nd_namespace_label *nd_label, u32 slot)
>  {
> +	bool valid;
> +
>  	/* check that we are written where we expect to be written */
>  	if (slot != nsl_get_slot(ndd, nd_label))
>  		return false;
> -
> -	/* check checksum */
> -	if (namespace_label_has(ndd, checksum)) {
> -		u64 sum, sum_save;
> -
> -		sum_save = nsl_get_checksum(ndd, nd_label);
> -		nsl_set_checksum(ndd, nd_label, 0);
> -		sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
> -		nsl_set_checksum(ndd, nd_label, sum_save);
> -		if (sum != sum_save) {
> -			dev_dbg(ndd->dev, "fail checksum. slot: %d expect: %#llx\n",
> -				slot, sum);
> -			return false;
> -		}
> -	}
> -
> -	return true;
> +	valid = nsl_validate_checksum(ndd, nd_label);
> +	if (!valid)
> +		dev_dbg(ndd->dev, "fail checksum. slot: %d\n", slot);
> +	return valid;
>  }
>  
>  int nd_label_reserve_dpa(struct nvdimm_drvdata *ndd)
> @@ -812,13 +828,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  		guid_copy(&nd_label->abstraction_guid,
>  				to_abstraction_guid(ndns->claim_class,
>  					&nd_label->abstraction_guid));
> -	if (namespace_label_has(ndd, checksum)) {
> -		u64 sum;
> -
> -		nsl_set_checksum(ndd, nd_label, 0);
> -		sum = nd_fletcher64(nd_label, sizeof_namespace_label(ndd), 1);
> -		nsl_set_checksum(ndd, nd_label, sum);
> -	}
> +	nsl_calculate_checksum(ndd, nd_label);
>  	nd_dbg_dpa(nd_region, ndd, res, "\n");
>  
>  	/* update label */
> @@ -1049,15 +1059,7 @@ static int __blk_label_update(struct nd_region *nd_region,
>  			guid_copy(&nd_label->abstraction_guid,
>  					to_abstraction_guid(ndns->claim_class,
>  						&nd_label->abstraction_guid));
> -
> -		if (namespace_label_has(ndd, checksum)) {
> -			u64 sum;
> -
> -			nsl_set_checksum(ndd, nd_label, 0);
> -			sum = nd_fletcher64(nd_label,
> -					sizeof_namespace_label(ndd), 1);
> -			nsl_set_checksum(ndd, nd_label, sum);
> -		}
> +		nsl_calculate_checksum(ndd, nd_label);
>  
>  		/* update label */
>  		offset = nd_label_offset(ndd, nd_label);
> 

