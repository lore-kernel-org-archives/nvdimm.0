Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEFCE72
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 18:44:56 +0000 (UTC)
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GlJdF5zVSz6GFfb;
	Thu, 12 Aug 2021 02:44:17 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Wed, 11 Aug 2021 20:44:54 +0200
Received: from localhost (10.52.123.85) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 11 Aug
 2021 19:44:54 +0100
Date: Wed, 11 Aug 2021 19:44:24 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<ben.widawsky@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 02/23] libnvdimm/labels: Add isetcookie validation
 helper
Message-ID: <20210811194424.00007b6c@Huawei.com>
In-Reply-To: <162854807792.1980150.8842369662740914960.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162854807792.1980150.8842369662740914960.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Mon, 9 Aug 2021 15:27:57 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> In preparation to handle CXL labels with the same code that handles EFI
> labels, add a specific interleave-set-cookie validation helper
> rather than a getter since the CXL label type does not support this
> concept. The answer for CXL labels will always be true.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/nvdimm/namespace_devs.c |    8 +++-----
>  drivers/nvdimm/nd.h             |    7 +++++++
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 94da804372bf..f33245c27cc4 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1847,15 +1847,13 @@ static bool has_uuid_at_pos(struct nd_region *nd_region, u8 *uuid,
>  		list_for_each_entry(label_ent, &nd_mapping->labels, list) {
>  			struct nd_namespace_label *nd_label = label_ent->label;
>  			u16 position, nlabel;
> -			u64 isetcookie;
>  
>  			if (!nd_label)
>  				continue;
> -			isetcookie = nsl_get_isetcookie(ndd, nd_label);
>  			position = nsl_get_position(ndd, nd_label);
>  			nlabel = nsl_get_nlabel(ndd, nd_label);
>  
> -			if (isetcookie != cookie)
> +			if (!nsl_validate_isetcookie(ndd, nd_label, cookie))
>  				continue;
>  
>  			if (memcmp(nd_label->uuid, uuid, NSLABEL_UUID_LEN) != 0)
> @@ -1968,10 +1966,10 @@ static struct device *create_namespace_pmem(struct nd_region *nd_region,
>  		return ERR_PTR(-ENXIO);
>  	}
>  
> -	if (nsl_get_isetcookie(ndd, nd_label) != cookie) {
> +	if (!nsl_validate_isetcookie(ndd, nd_label, cookie)) {
>  		dev_dbg(&nd_region->dev, "invalid cookie in label: %pUb\n",
>  				nd_label->uuid);
> -		if (nsl_get_isetcookie(ndd, nd_label) != altcookie)
> +		if (!nsl_validate_isetcookie(ndd, nd_label, altcookie))
>  			return ERR_PTR(-EAGAIN);
>  
>  		dev_dbg(&nd_region->dev, "valid altcookie in label: %pUb\n",
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 61f43f0edabf..b3feaf3699f7 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -83,6 +83,13 @@ static inline u64 nsl_get_isetcookie(struct nvdimm_drvdata *ndd,
>  	return __le64_to_cpu(nd_label->isetcookie);
>  }
>  
> +static inline bool nsl_validate_isetcookie(struct nvdimm_drvdata *ndd,
> +					   struct nd_namespace_label *nd_label,
> +					   u64 cookie)
> +{
> +	return cookie == __le64_to_cpu(nd_label->isetcookie);
> +}
> +
>  static inline u16 nsl_get_position(struct nvdimm_drvdata *ndd,
>  				   struct nd_namespace_label *nd_label)
>  {
> 

