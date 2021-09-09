Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051E63FC8
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 13:09:52 +0000 (UTC)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H4znd6ZyPz67sQ7;
	Thu,  9 Sep 2021 21:07:49 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 9 Sep 2021 15:09:44 +0200
Received: from localhost (10.52.120.64) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 9 Sep 2021
 14:09:43 +0100
Date: Thu, 9 Sep 2021 14:09:42 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <vishal.l.verma@intel.com>,
	<nvdimm@lists.linux.dev>, <ben.widawsky@intel.com>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH v4 03/21] libnvdimm/labels: Introduce the concept of
 multi-range namespace labels
Message-ID: <20210909140942.000025e5@Huawei.com>
In-Reply-To: <163116430804.2460985.5482188351381597529.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
	<163116430804.2460985.5482188351381597529.stgit@dwillia2-desk3.amr.corp.intel.com>
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
X-Originating-IP: [10.52.120.64]
X-ClientProxiedBy: lhreml718-chm.china.huawei.com (10.201.108.69) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Wed, 8 Sep 2021 22:11:48 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The CXL specification defines a mechanism for namespaces to be comprised
> of multiple dis-contiguous ranges. Introduce that concept to the legacy
> NVDIMM namespace implementation with a new nsl_set_nrange() helper, that
> sets the number of ranges to 1. Once the NVDIMM subsystem supports CXL
> labels and updates its namespace capacity provisioning for
> dis-contiguous support nsl_set_nrange() can be updated, but in the
> meantime CXL label validation requires nrange be non-zero.
> 
> Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

(gave tag on v3 and this looks to be the same).

Thanks,

Jonathan

> ---
>  drivers/nvdimm/label.c |    1 +
>  drivers/nvdimm/nd.h    |   13 +++++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index e7fdb718ebf0..7832b190efd7 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -856,6 +856,7 @@ static int __pmem_label_update(struct nd_region *nd_region,
>  	nsl_set_name(ndd, nd_label, nspm->alt_name);
>  	nsl_set_flags(ndd, nd_label, flags);
>  	nsl_set_nlabel(ndd, nd_label, nd_region->ndr_mappings);
> +	nsl_set_nrange(ndd, nd_label, 1);
>  	nsl_set_position(ndd, nd_label, pos);
>  	nsl_set_isetcookie(ndd, nd_label, cookie);
>  	nsl_set_rawsize(ndd, nd_label, resource_size(res));
> diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
> index 036638bdb7e3..d57f95a48fe1 100644
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -164,6 +164,19 @@ static inline void nsl_set_nlabel(struct nvdimm_drvdata *ndd,
>  	nd_label->nlabel = __cpu_to_le16(nlabel);
>  }
>  
> +static inline u16 nsl_get_nrange(struct nvdimm_drvdata *ndd,
> +				 struct nd_namespace_label *nd_label)
> +{
> +	/* EFI labels do not have an nrange field */
> +	return 1;
> +}
> +
> +static inline void nsl_set_nrange(struct nvdimm_drvdata *ndd,
> +				  struct nd_namespace_label *nd_label,
> +				  u16 nrange)
> +{
> +}
> +
>  static inline u64 nsl_get_lbasize(struct nvdimm_drvdata *ndd,
>  				  struct nd_namespace_label *nd_label)
>  {
> 

