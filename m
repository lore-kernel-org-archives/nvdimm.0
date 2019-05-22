Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3EE5E2126D822
 for <linux-nvdimm@lists.01.org>; Wed, 22 May 2019 02:17:05 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x4M92WTX013913
 for <linux-nvdimm@lists.01.org>; Wed, 22 May 2019 05:17:04 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2sn37y154j-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Wed, 22 May 2019 05:17:03 -0400
Received: from localhost
 by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <sathnaga@linux.vnet.ibm.com>;
 Wed, 22 May 2019 10:17:02 +0100
Date: Wed, 22 May 2019 14:46:56 +0530
From: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V2 3/3] mm/nvdimm: Use correct #defines instead of
 opencoding
References: <20190522082701.6817-1-aneesh.kumar@linux.ibm.com>
 <20190522082701.6817-3-aneesh.kumar@linux.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190522082701.6817-3-aneesh.kumar@linux.ibm.com>
Message-Id: <20190522091656.GA19800@sathnaga86.d4t-in.ibmmobiledemo.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 22, 2019 at 01:57:01PM +0530, Aneesh Kumar K.V wrote:
> The nfpn related change is needed to fix the kernel message
> 
> "number of pfns truncated from 2617344 to 163584"
> 
> The change makes sure the nfpns stored in the superblock is right value.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  drivers/nvdimm/label.c       | 2 +-
>  drivers/nvdimm/pfn_devs.c    | 6 +++---
>  drivers/nvdimm/region_devs.c | 8 ++++----
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
> index f3d753d3169c..bc6de8fb0153 100644
> --- a/drivers/nvdimm/label.c
> +++ b/drivers/nvdimm/label.c
> @@ -361,7 +361,7 @@ static bool slot_valid(struct nvdimm_drvdata *ndd,
> 
>  	/* check that DPA allocations are page aligned */
>  	if ((__le64_to_cpu(nd_label->dpa)
> -				| __le64_to_cpu(nd_label->rawsize)) % SZ_4K)
> +				| __le64_to_cpu(nd_label->rawsize)) % PAGE_SIZE)
>  		return false;
> 
>  	/* check checksum */
> diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
> index 39fa8cf8ef58..9fc2e514e28a 100644
> --- a/drivers/nvdimm/pfn_devs.c
> +++ b/drivers/nvdimm/pfn_devs.c
> @@ -769,8 +769,8 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>  		 * when populating the vmemmap. This *should* be equal to
>  		 * PMD_SIZE for most architectures.
>  		 */
> -		offset = ALIGN(start + reserve + 64 * npfns,
> -				max(nd_pfn->align, PMD_SIZE)) - start;
> +		offset = ALIGN(start + reserve + sizeof(struct page) * npfns,
> +			       max(nd_pfn->align, PMD_SIZE)) - start;
>  	} else if (nd_pfn->mode == PFN_MODE_RAM)
>  		offset = ALIGN(start + reserve, nd_pfn->align) - start;
>  	else
> @@ -782,7 +782,7 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
>  		return -ENXIO;
>  	}
> 
> -	npfns = (size - offset - start_pad - end_trunc) / SZ_4K;
> +	npfns = (size - offset - start_pad - end_trunc) / PAGE_SIZE;
>  	pfn_sb->mode = cpu_to_le32(nd_pfn->mode);
>  	pfn_sb->dataoff = cpu_to_le64(offset);
>  	pfn_sb->npfns = cpu_to_le64(npfns);
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index b4ef7d9ff22e..2d8facea5a03 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -994,10 +994,10 @@ static struct nd_region *nd_region_create(struct nvdimm_bus *nvdimm_bus,
>  		struct nd_mapping_desc *mapping = &ndr_desc->mapping[i];
>  		struct nvdimm *nvdimm = mapping->nvdimm;
> 
> -		if ((mapping->start | mapping->size) % SZ_4K) {
> -			dev_err(&nvdimm_bus->dev, "%s: %s mapping%d is not 4K aligned\n",
> -					caller, dev_name(&nvdimm->dev), i);
> -
> +		if ((mapping->start | mapping->size) % PAGE_SIZE) {
> +			dev_err(&nvdimm_bus->dev,
> +				"%s: %s mapping%d is not 4K aligned\n",

s/not 4K aligned/not PAGE_SIZE aligned ?

hope the error msg need to be changed as well..

Regards,
-Satheesh.
> +				caller, dev_name(&nvdimm->dev), i);
>  			return NULL;
>  		}
> 
> -- 
> 2.21.0
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
