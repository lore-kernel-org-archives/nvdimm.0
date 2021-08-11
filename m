Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688602FAD
	for <nvdimm@lists.linux.dev>; Wed, 11 Aug 2021 18:42:05 +0000 (UTC)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GlJYv698Sz6GDpl;
	Thu, 12 Aug 2021 02:41:23 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 11 Aug 2021 20:42:00 +0200
Received: from localhost (10.52.123.85) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 11 Aug
 2021 19:42:00 +0100
Date: Wed, 11 Aug 2021 19:41:30 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<ben.widawsky@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH 11/23] libnvdimm/labels: Introduce CXL labels
Message-ID: <20210811194130.00006076@Huawei.com>
In-Reply-To: <162854812641.1980150.4928659819619856243.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162854806653.1980150.3354618413963083778.stgit@dwillia2-desk3.amr.corp.intel.com>
	<162854812641.1980150.4928659819619856243.stgit@dwillia2-desk3.amr.corp.intel.com>
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

On Mon, 9 Aug 2021 15:28:46 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Now that all of use sites of label data have been converted to nsl_*
> helpers, introduce the CXL label format. The ->cxl flag in
> nvdimm_drvdata indicates the label format the device expects. A
> follow-on patch allows a bus provider to select the label style.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

A few trivial things inline. Nothing that actually 'needs' changing though.
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> index e6e77691dbec..71ffde56fac0 100644
> --- a/drivers/nvdimm/label.h
> +++ b/drivers/nvdimm/label.h
> @@ -64,40 +64,77 @@ struct nd_namespace_index {
>  	u8 free[];
>  };
>  
> -/**
> - * struct nd_namespace_label - namespace superblock
> - * @uuid: UUID per RFC 4122
> - * @name: optional name (NULL-terminated)
> - * @flags: see NSLABEL_FLAG_*
> - * @nlabel: num labels to describe this ns
> - * @position: labels position in set
> - * @isetcookie: interleave set cookie
> - * @lbasize: LBA size in bytes or 0 for pmem
> - * @dpa: DPA of NVM range on this DIMM
> - * @rawsize: size of namespace
> - * @slot: slot of this label in label area
> - * @unused: must be zero
> - */
>  struct nd_namespace_label {
> +	union {
Cross reference might be a nice thing to include?
Table 212 I think...
> +		struct nvdimm_cxl_label {
> +			uuid_t type;
> +			uuid_t uuid;
> +			u8 name[NSLABEL_NAME_LEN];
> +			__le32 flags;
> +			__le16 nlabel;

Perhaps call out nlabel is nrange in the spec?

> +			__le16 position;
> +			__le64 dpa;
> +			__le64 rawsize;
> +			__le32 slot;
> +			__le32 align;
> +			uuid_t region_uuid;
> +			uuid_t abstraction_uuid;
> +			__le16 lbasize;
> +			u8 reserved[0x56];
> +			__le64 checksum;
> +		} cxl;
> +		/**
> +		 * struct nvdimm_efi_label - namespace superblock
> +		 * @uuid: UUID per RFC 4122
> +		 * @name: optional name (NULL-terminated)
> +		 * @flags: see NSLABEL_FLAG_*
> +		 * @nlabel: num labels to describe this ns
> +		 * @position: labels position in set
> +		 * @isetcookie: interleave set cookie
> +		 * @lbasize: LBA size in bytes or 0 for pmem
> +		 * @dpa: DPA of NVM range on this DIMM
> +		 * @rawsize: size of namespace
> +		 * @slot: slot of this label in label area
> +		 * @unused: must be zero
> +		 */
> +		struct nvdimm_efi_label {
> +			uuid_t uuid;
> +			u8 name[NSLABEL_NAME_LEN];
> +			__le32 flags;
> +			__le16 nlabel;
> +			__le16 position;
> +			__le64 isetcookie;
> +			__le64 lbasize;
> +			__le64 dpa;
> +			__le64 rawsize;
> +			__le32 slot;
> +			/*
> +			 * Accessing fields past this point should be
> +			 * gated by a efi_namespace_label_has() check.
> +			 */
> +			u8 align;
> +			u8 reserved[3];
> +			guid_t type_guid;
> +			guid_t abstraction_guid;
> +			u8 reserved2[88];
> +			__le64 checksum;
> +		} efi;
> +	};
> +};
> +
> +struct cxl_region_label {

Perhaps separate this out to another patch so the diff ends up less confusing?

> +	uuid_t type;
>  	uuid_t uuid;
> -	u8 name[NSLABEL_NAME_LEN];
>  	__le32 flags;
>  	__le16 nlabel;
>  	__le16 position;
> -	__le64 isetcookie;
> -	__le64 lbasize;
>  	__le64 dpa;
>  	__le64 rawsize;
> +	__le64 hpa;
>  	__le32 slot;
> -	/*
> -	 * Accessing fields past this point should be gated by a
> -	 * namespace_label_has() check.
> -	 */
> -	u8 align;
> -	u8 reserved[3];
> -	guid_t type_guid;
> -	guid_t abstraction_guid;
> -	u8 reserved2[88];
> +	__le32 ig;
> +	__le32 align;
> +	u8 reserved[0xac];
>  	__le64 checksum;
>  };
