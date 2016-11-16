Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1ECC381EC3
 for <linux-nvdimm@lists.01.org>; Tue, 15 Nov 2016 16:15:02 -0800 (PST)
Subject: Re: [PATCH] mm: add ZONE_DEVICE statistics to smaps
References: <147881591739.39198.1358237993213024627.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <1c6d61ef-2331-e517-d0d8-d4eefea8b18a@intel.com>
Date: Tue, 15 Nov 2016 16:15:05 -0800
MIME-Version: 1.0
In-Reply-To: <147881591739.39198.1358237993213024627.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 11/10/2016 02:11 PM, Dan Williams wrote:
> @@ -774,6 +778,8 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
>  		   "ShmemPmdMapped: %8lu kB\n"
>  		   "Shared_Hugetlb: %8lu kB\n"
>  		   "Private_Hugetlb: %7lu kB\n"
> +		   "Device:         %8lu kB\n"
> +		   "DeviceHugePages: %7lu kB\n"
>  		   "Swap:           %8lu kB\n"
>  		   "SwapPss:        %8lu kB\n"
>  		   "KernelPageSize: %8lu kB\n"

So, a couple of nits...

smaps is getting a bit big, and the fields that get added in this patch
are going to be pretty infrequently used.  Is it OK if smaps grows
forever, even if most of them items are "0 kB"?

IOW, Could we make it output Device* only for DAX VMAs?  All the parsers
have to handle that field being there or not (for old kernels).

The other thing missing for DAX is the page size.  DAX mappings support
mixed page sizes, so MMUPageSize in this context is pretty worthless.
What will we do in here for 1GB DAX pages?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
