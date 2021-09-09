Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DF43FF0
	for <nvdimm@lists.linux.dev>; Thu,  9 Sep 2021 15:59:00 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="201025664"
X-IronPort-AV: E=Sophos;i="5.85,280,1624345200"; 
   d="scan'208";a="201025664"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 08:58:31 -0700
X-IronPort-AV: E=Sophos;i="5.85,280,1624345200"; 
   d="scan'208";a="525581655"
Received: from ado-mobl1.amr.corp.intel.com (HELO intel.com) ([10.252.129.108])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 08:58:31 -0700
Date: Thu, 9 Sep 2021 08:58:29 -0700
From: Ben Widawsky <ben.widawsky@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	vishal.l.verma@intel.com, nvdimm@lists.linux.dev,
	alison.schofield@intel.com, ira.weiny@intel.com
Subject: Re: [PATCH v4 05/21] libnvdimm/label: Define CXL region labels
Message-ID: <20210909155829.vjqznxbql2fgna3q@intel.com>
References: <163116429183.2460985.5040982981112374615.stgit@dwillia2-desk3.amr.corp.intel.com>
 <163116431893.2460985.4003511000574373922.stgit@dwillia2-desk3.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163116431893.2460985.4003511000574373922.stgit@dwillia2-desk3.amr.corp.intel.com>

On 21-09-08 22:11:58, Dan Williams wrote:
> Add a definition of the CXL 2.0 region label format. Note this is done
> as a separate patch to make the next patch that adds namespace label
> support easier to read.
> 
> Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/nvdimm/label.h |   32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)

Wondering how awkward it's going to be to use this in the cxl region driver. Is
the intent to push all device based reads/writes to labels happen in
drivers/nvdimm?

> 
> diff --git a/drivers/nvdimm/label.h b/drivers/nvdimm/label.h
> index 7fa757d47846..0519aacc2926 100644
> --- a/drivers/nvdimm/label.h
> +++ b/drivers/nvdimm/label.h
> @@ -66,6 +66,38 @@ struct nd_namespace_index {
>  	u8 free[];
>  };
>  
> +/**
> + * struct cxl_region_label - CXL 2.0 Table 211
> + * @type: uuid identifying this label format (region)
> + * @uuid: uuid for the region this label describes
> + * @flags: NSLABEL_FLAG_UPDATING (all other flags reserved)
> + * @nlabel: 1 per interleave-way in the region
> + * @position: this label's position in the set
> + * @dpa: start address in device-local capacity for this label
> + * @rawsize: size of this label's contribution to region
> + * @hpa: mandatory system physical address to map this region
> + * @slot: slot id of this label in label area
> + * @ig: interleave granularity (1 << @ig) * 256 bytes
> + * @align: alignment in SZ_256M blocks
> + * @reserved: reserved
> + * @checksum: fletcher64 sum of this label
> + */
> +struct cxl_region_label {
> +	u8 type[NSLABEL_UUID_LEN];
> +	u8 uuid[NSLABEL_UUID_LEN];
> +	__le32 flags;
> +	__le16 nlabel;
> +	__le16 position;
> +	__le64 dpa;
> +	__le64 rawsize;
> +	__le64 hpa;
> +	__le32 slot;
> +	__le32 ig;
> +	__le32 align;
> +	u8 reserved[0xac];
> +	__le64 checksum;
> +};
> +
>  /**
>   * struct nd_namespace_label - namespace superblock
>   * @uuid: UUID per RFC 4122
> 
