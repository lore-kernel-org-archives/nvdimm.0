Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D745CAD
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 12:56:45 +0000 (UTC)
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.206])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NC30B0jN6z6HJbh;
	Wed, 16 Nov 2022 20:54:18 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 13:56:41 +0100
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 16 Nov
 2022 12:56:41 +0000
Date: Wed, 16 Nov 2022 12:56:40 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: <alison.schofield@intel.com>
CC: Dan Williams <dan.j.williams@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Ben Widawsky <bwidawsk@kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH 1/5] libcxl: add interfaces for GET_POISON_LIST
 mailbox commands
Message-ID: <20221116125640.00006a68@Huawei.com>
In-Reply-To: <73b2edf5ded979cb3164bcf2b76c4f300cdf2250.1668133294.git.alison.schofield@intel.com>
References: <cover.1668133294.git.alison.schofield@intel.com>
	<73b2edf5ded979cb3164bcf2b76c4f300cdf2250.1668133294.git.alison.schofield@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Thu, 10 Nov 2022 19:20:04 -0800
alison.schofield@intel.com wrote:

> From: Alison Schofield <alison.schofield@intel.com>
> 
> CXL devices maintain a list of locations that are poisoned or result
> in poison if the addresses are accessed by the host.
> 
> Per the spec (CXL 3.0 8.2.9.8.4.1), the device returns this Poison
> list as a set of  Media Error Records that include the source of the
> error, the starting device physical address and length.
> 
> Trigger the retrieval of the poison list by writing to the device
> sysfs attribute: trigger_poison_list.
> 
> Retrieval is offered by memdev or by region:
> int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
> int cxl_region_trigger_poison_list(struct cxl_region *region);
> 
> This interface triggers the retrieval of the poison list from the
> devices and logs the error records as kernel trace events named
> 'cxl_poison'.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Trivial comment inline + I haven't been tracking closely development
of this tool closely so hopefully this will get other eyes on it who
are more familiar.  With that in mind:

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  cxl/lib/libcxl.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym |  6 ++++++
>  cxl/libcxl.h       |  2 ++
>  3 files changed, 52 insertions(+)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index e8c5d4444dd0..1a8a8eb0ffcb 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1331,6 +1331,50 @@ CXL_EXPORT int cxl_memdev_disable_invalidate(struct cxl_memdev *memdev)
>  	return 0;
>  }
>  
> +CXL_EXPORT int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev)
> +{
> +	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> +	char *path = memdev->dev_buf;
> +	int len = memdev->buf_len, rc;
> +
> +	if (snprintf(path, len, "%s/trigger_poison_list", memdev->dev_path) >=
> +	    len) {

Ugly line break choice to break mid argument..
	if (snprintf(path, len, "%s/trigger_poison_list",
		     memdev->dev_path) >= len) {
would be better.

> +		err(ctx, "%s: buffer too small\n",
> +		    cxl_memdev_get_devname(memdev));
> +		return -ENXIO;
> +	}
> +	rc = sysfs_write_attr(ctx, path, "1\n");
> +	if (rc < 0) {
> +		fprintf(stderr,
> +			"%s: Failed write sysfs attr trigger_poison_list\n",
> +			cxl_memdev_get_devname(memdev));
> +		return rc;
> +	}
> +	return 0;
> +}
> +
> +CXL_EXPORT int cxl_region_trigger_poison_list(struct cxl_region *region)
> +{
> +	struct cxl_ctx *ctx = cxl_region_get_ctx(region);
> +	char *path = region->dev_buf;
> +	int len = region->buf_len, rc;
> +
> +	if (snprintf(path, len, "%s/trigger_poison_list", region->dev_path) >=
> +	    len) {
as above.

> +		err(ctx, "%s: buffer too small\n",
> +		    cxl_region_get_devname(region));
> +		return -ENXIO;
> +	}
> +	rc = sysfs_write_attr(ctx, path, "1\n");
> +	if (rc < 0) {
> +		fprintf(stderr,
> +			"%s: Failed write sysfs attr trigger_poison_list\n",
> +			cxl_region_get_devname(region));
> +		return rc;
> +	}
> +	return 0;
> +}
> +
>  CXL_EXPORT int cxl_memdev_enable(struct cxl_memdev *memdev)
>  {
>  	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index 8bb91e05638b..ecf98e6c7af2 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -217,3 +217,9 @@ global:
>  	cxl_decoder_get_max_available_extent;
>  	cxl_decoder_get_region;
>  } LIBCXL_2;
> +
> +LIBCXL_4 {
> +global:
> +	cxl_memdev_trigger_poison_list;
> +	cxl_region_trigger_poison_list;
> +} LIBCXL_3;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index 9fe4e99263dd..5ebdf0879325 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -375,6 +375,8 @@ enum cxl_setpartition_mode {
>  
>  int cxl_cmd_partition_set_mode(struct cxl_cmd *cmd,
>  		enum cxl_setpartition_mode mode);
> +int cxl_memdev_trigger_poison_list(struct cxl_memdev *memdev);
> +int cxl_region_trigger_poison_list(struct cxl_region *region);
>  
>  #ifdef __cplusplus
>  } /* extern "C" */

