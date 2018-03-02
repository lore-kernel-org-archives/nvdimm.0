Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B20B22492750
 for <linux-nvdimm@lists.01.org>; Fri,  2 Mar 2018 01:30:24 -0800 (PST)
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH v3 1/3] mm,
 powerpc: use vma_kernel_pagesize() in vma_mmu_pagesize()
In-Reply-To: <151996254179.27922.2213728278535578744.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151996253609.27922.9983044853291257359.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151996254179.27922.2213728278535578744.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Fri, 02 Mar 2018 20:36:26 +1100
Message-ID: <87lgfa95ut.fsf@concordia.ellerman.id.au>
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
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-nvdimm@lists.01.org, Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> The current powerpc definition of vma_mmu_pagesize() open codes looking
> up the page size via hstate. It is identical to the generic
> vma_kernel_pagesize() implementation.
>
> Now, vma_kernel_pagesize() is growing support for determining the
> page size of Device-DAX vmas in addition to the existing Hugetlbfs page
> size determination.
>
> Ideally, if the powerpc vma_mmu_pagesize() used vma_kernel_pagesize() it
> would automatically benefit from any new vma-type support that is added
> to vma_kernel_pagesize(). However, the powerpc vma_mmu_pagesize() is
> prevented from calling vma_kernel_pagesize() due to a circular header
> dependency that requires vma_mmu_pagesize() to be defined before
> including <linux/hugetlb.h>.
>
> Break this circular dependency by defining the default
> vma_mmu_pagesize() as a __weak symbol to be overridden by the powerpc
> version.
>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/powerpc/include/asm/hugetlb.h |    6 ------
>  arch/powerpc/mm/hugetlbpage.c      |    5 +----
>  mm/hugetlb.c                       |    8 +++-----
>  3 files changed, 4 insertions(+), 15 deletions(-)

This looks OK to me. I was worried switching to a weak symbol would mean
it doesn't get inlined, but it's not inlined today anyway!

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
