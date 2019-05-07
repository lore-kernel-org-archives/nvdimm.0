Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D38D32122C318
 for <linux-nvdimm@lists.01.org>; Tue,  7 May 2019 04:50:04 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x47Bkosj009825
 for <linux-nvdimm@lists.01.org>; Tue, 7 May 2019 07:50:04 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2sb6b2rqsd-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 07 May 2019 07:50:04 -0400
Received: from localhost
 by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Tue, 7 May 2019 12:50:01 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH v2] drivers/dax: Allow to include DEV_DAX_PMEM as builtin
In-Reply-To: <20190401051421.17878-1-aneesh.kumar@linux.ibm.com>
References: <20190401051421.17878-1-aneesh.kumar@linux.ibm.com>
Date: Tue, 07 May 2019 06:49:55 -0500
MIME-Version: 1.0
Message-Id: <87pnoumql8.fsf@linux.ibm.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


Hi Dan,

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> This move the dependency to DEV_DAX_PMEM_COMPAT such that only
> if DEV_DAX_PMEM is built as module we can allow the compat support.
>
> This allows to test the new code easily in a emulation setup where we
> often build things without module support.
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

Any update on this. Can we merge this?

> ---
> Changes from V1:
> * Make sure we only build compat code as module
>
>  drivers/dax/Kconfig | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
> index 5ef624fe3934..a59f338f520f 100644
> --- a/drivers/dax/Kconfig
> +++ b/drivers/dax/Kconfig
> @@ -23,7 +23,6 @@ config DEV_DAX
>  config DEV_DAX_PMEM
>  	tristate "PMEM DAX: direct access to persistent memory"
>  	depends on LIBNVDIMM && NVDIMM_DAX && DEV_DAX
> -	depends on m # until we can kill DEV_DAX_PMEM_COMPAT
>  	default DEV_DAX
>  	help
>  	  Support raw access to persistent memory.  Note that this
> @@ -50,7 +49,7 @@ config DEV_DAX_KMEM
>  
>  config DEV_DAX_PMEM_COMPAT
>  	tristate "PMEM DAX: support the deprecated /sys/class/dax interface"
> -	depends on DEV_DAX_PMEM
> +	depends on m && DEV_DAX_PMEM=m
>  	default DEV_DAX_PMEM
>  	help
>  	  Older versions of the libdaxctl library expect to find all
> -- 
> 2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
