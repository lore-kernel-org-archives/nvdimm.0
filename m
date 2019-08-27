Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BD7F20216B9B
 for <linux-nvdimm@lists.01.org>; Tue, 27 Aug 2019 11:22:08 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl: Use the same align value as original namespace
 on reconfigure
Date: Tue, 27 Aug 2019 18:19:59 +0000
Message-ID: <a6f0635109d75489144bd1b5985e8da44110b01b.camel@intel.com>
References: <20190807044416.30799-1-aneesh.kumar@linux.ibm.com>
In-Reply-To: <20190807044416.30799-1-aneesh.kumar@linux.ibm.com>
Content-Language: en-US
Content-ID: <7B769C8AC3A08143A3C537C7F3CE615D@intel.com>
MIME-Version: 1.0
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
To: "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>, Williams, Dan
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2019-08-07 at 10:14 +0530, Aneesh Kumar K.V wrote:
> When using reconfigure command to add a `name` to the namespace we end
> up updating the align attribute. Avoid this by using the value from
> the original namespace. Do this only if we are keeping the namespace mode
> same.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> ---
>  ndctl/namespace.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)

Hi Aneesh,

A few comments below:

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

                             ^trying

> +		 * Use the align details from the origin namespace. Otherwise

s/origin/original/

> +		 * pick the align details from seed namespace
> +		 */
> +		if (ndns && p->mode == ndctl_namespace_get_mode(ndns)) {

Do we need to depend on the mode here?

I'm thinking it should be sufficient to do:
  1. Check We're in 'reconfigure'
  2. Check param.align was not supplied
  3. Get alignment from the pfn/dax personality, and just use that.

Does this make sense (Maybe I'm missing something).

> +			struct ndctl_pfn *ns_pfn = ndctl_namespace_get_pfn(ndns);
> +			struct ndctl_dax *ns_dax = ndctl_namespace_get_dax(ndns);
> +			if (ns_pfn)
> +				p->align = ndctl_pfn_get_align(ns_pfn);
> +			else if (ns_dax)
> +				p->align = ndctl_dax_get_align(ns_dax);
> +			else
> +				p->align = sysconf(_SC_PAGE_SIZE);

Do we need the page size fallback here - there are other checks after
this point that also do a similar fallback, do they not catch the
default case?

> +		} else
>  		/*
>  		 * Use the seed namespace alignment as the default if we need
>  		 * one. If we don't then use PAGE_SIZE so the size_align

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
