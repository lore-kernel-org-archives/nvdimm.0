Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5C2C20215F75
 for <linux-nvdimm@lists.01.org>; Tue, 27 Aug 2019 01:41:38 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x7R8YCUd076604
 for <linux-nvdimm@lists.01.org>; Tue, 27 Aug 2019 04:39:26 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2umxkvw6tx-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 27 Aug 2019 04:39:26 -0400
Received: from localhost
 by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.ibm.com>;
 Tue, 27 Aug 2019 09:39:24 +0100
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH] ndctl: Use the same align value as original namespace on
 reconfigure
In-Reply-To: <20190807044416.30799-1-aneesh.kumar@linux.ibm.com>
References: <20190807044416.30799-1-aneesh.kumar@linux.ibm.com>
Date: Tue, 27 Aug 2019 14:09:18 +0530
MIME-Version: 1.0
Message-Id: <87ftlnm289.fsf@linux.ibm.com>
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
To: dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


Hi Dan/Vishal,

Any update on this?

-aneesh

"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> writes:

> When using reconfigure command to add a `name` to the namespace we end
> up updating the align attribute. Avoid this by using the value from
> the original namespace. Do this only if we are keeping the namespace mode
> same.
>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  ndctl/namespace.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
> index 1f212a2b3a9b..24e51bb35ae1 100644
> --- a/ndctl/namespace.c
> +++ b/ndctl/namespace.c
> @@ -596,6 +596,22 @@ static int validate_namespace_options(struct ndctl_region *region,
>  			return -ENXIO;
>  		}
>  	} else {
> +
> +		/*
> +		 * If we are tryint to reconfigure with the same namespace mode
> +		 * Use the align details from the origin namespace. Otherwise
> +		 * pick the align details from seed namespace
> +		 */
> +		if (ndns && p->mode == ndctl_namespace_get_mode(ndns)) {
> +			struct ndctl_pfn *ns_pfn = ndctl_namespace_get_pfn(ndns);
> +			struct ndctl_dax *ns_dax = ndctl_namespace_get_dax(ndns);
> +			if (ns_pfn)
> +				p->align = ndctl_pfn_get_align(ns_pfn);
> +			else if (ns_dax)
> +				p->align = ndctl_dax_get_align(ns_dax);
> +			else
> +				p->align = sysconf(_SC_PAGE_SIZE);
> +		} else
>  		/*
>  		 * Use the seed namespace alignment as the default if we need
>  		 * one. If we don't then use PAGE_SIZE so the size_align
> -- 
> 2.21.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
