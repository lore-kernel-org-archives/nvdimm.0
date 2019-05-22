Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [RFC PATCH 1/3] mm/nvdimm: Add PFN_MIN_VERSION support
References: <20190522062057.26581-1-aneesh.kumar@linux.ibm.com>
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Date: Wed, 22 May 2019 12:05:45 +0530
MIME-Version: 1.0
In-Reply-To: <20190522062057.26581-1-aneesh.kumar@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Message-Id: <27bcf0e4-ba1d-2a7e-c181-ff60a9413bce@linux.ibm.com>
Sender: owner-linux-mm@kvack.org
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
List-ID: <linux-nvdimm@lists.01.org>

On 5/22/19 11:50 AM, Aneesh Kumar K.V wrote:
> This allows us to make changes in a backward incompatible way. I have
> kept the PFN_MIN_VERSION in this patch '0' because we are not introducing
> any incompatible changes in this patch. We also may want to backport this
> to older kernels.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>   drivers/nvdimm/pfn.h      |  9 ++++++++-
>   drivers/nvdimm/pfn_devs.c |  4 ++++
>   drivers/nvdimm/pmem.c     | 26 ++++++++++++++++++++++----
>   3 files changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/nvdimm/pfn.h b/drivers/nvdimm/pfn.h
> index dde9853453d3..1b10ae5773b6 100644
> --- a/drivers/nvdimm/pfn.h
> +++ b/drivers/nvdimm/pfn.h
> @@ -20,6 +20,12 @@
>   #define PFN_SIG_LEN 16
>   #define PFN_SIG "NVDIMM_PFN_INFO\0"
>   #define DAX_SIG "NVDIMM_DAX_INFO\0"
> +/*
> + * increment this when we are making changes such that older
> + * kernel should fail to initialize that namespace.
> + */
> +
> +#define PFN_MIN_VERSION 0
>   
>   struct nd_pfn_sb {
>   	u8 signature[PFN_SIG_LEN];
> @@ -36,7 +42,8 @@ struct nd_pfn_sb {
>   	__le32 end_trunc;
>   	/* minor-version-2 record the base alignment of the mapping */
>   	__le32 align;
> -	u8 padding[4000];
> +	__le16 min_verison;
> +	u8 padding[3998];
>   	__le64 checksum;
>   };
>   
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 01f40672507f..3250de70a7b3 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -439,6 +439,9 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn, const char *sig)
>   	if (nvdimm_read_bytes(ndns, SZ_4K, pfn_sb, sizeof(*pfn_sb), 0))
>   		return -ENXIO;
>   
> +	if (le16_to_cpu(pfn_sb->min_version > PFN_MIN_VERSION))
> +		return -EOPNOTSUPP;

+	if (le16_to_cpu(pfn_sb->min_version) > PFN_MIN_VERSION)
+		return -EOPNOTSUPP;



-aneesh
