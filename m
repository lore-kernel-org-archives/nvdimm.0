Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 03CE321A070B6
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 10:38:36 -0700 (PDT)
Date: Wed, 24 Apr 2019 10:38:33 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] mm: Fix modifying of page protection by
 insert_pfn_pmd()
Message-ID: <20190424173833.GE19031@bombadil.infradead.org>
References: <20190402115125.18803-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4hzRj5yxVJ5-7AZgzzBxEL02xf2xwhDv-U9_osWFm9kiA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hzRj5yxVJ5-7AZgzzBxEL02xf2xwhDv-U9_osWFm9kiA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Chandan Rajendra <chandan@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 24, 2019 at 10:13:15AM -0700, Dan Williams wrote:
> I think unaligned addresses have always been passed to
> vmf_insert_pfn_pmd(), but nothing cared until this patch. I *think*
> the only change needed is the following, thoughts?
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index ca0671d55aa6..82aee9a87efa 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1560,7 +1560,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct
> vm_fault *vmf, pfn_t *pfnp,
>                 }
> 
>                 trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, entry);
> -               result = vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
> +               result = vmf_insert_pfn_pmd(vma, pmd_addr, vmf->pmd, pfn,
>                                             write);

We also call vmf_insert_pfn_pmd() in dax_insert_pfn_mkwrite() -- does
that need to change too?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
