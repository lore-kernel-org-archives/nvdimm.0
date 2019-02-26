Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] mm/resource: return real error codes from walk
 failures
References: <20190225185727.BCBD768C@viggo.jf.intel.com>
 <20190225185730.D8AA7812@viggo.jf.intel.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <87f914ce-c9e8-7fc5-d048-702fa809013f@c-s.fr>
Date: Tue, 26 Feb 2019 08:41:39 +0100
MIME-Version: 1.0
In-Reply-To: <20190225185730.D8AA7812@viggo.jf.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: mhocko@suse.com, tiwai@suse.de, keith.busch@intel.com, linux-mm@kvack.org, paulus@samba.org, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, dave.jiang@intel.com, linux-nvdimm@lists.01.org, ying.huang@intel.com, bp@suse.de, thomas.lendacky@amd.com, jglisse@redhat.com, bhelgaas@google.com, dan.j.williams@intel.com, vishal.l.verma@intel.com, akpm@linux-foundation.org, fengguang.wu@intel.com, linuxppc-dev@lists.ozlabs.org
List-ID: <linux-nvdimm@lists.01.org>



Le 25/02/2019 à 19:57, Dave Hansen a écrit :
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> walk_system_ram_range() can return an error code either becuase
> *it* failed, or because the 'func' that it calls returned an
> error.  The memory hotplug does the following:
> 
> 	ret = walk_system_ram_range(..., func);
>          if (ret)
> 		return ret;
> 
> and 'ret' makes it out to userspace, eventually.  The problem
> s, walk_system_ram_range() failues that result from *it* failing
> (as opposed to 'func') return -1.  That leads to a very odd
> -EPERM (-1) return code out to userspace.
> 
> Make walk_system_ram_range() return -EINVAL for internal
> failures to keep userspace less confused.
> 
> This return code is compatible with all the callers that I
> audited.
> 
> This changes both the generic mm/ and powerpc-specific
> implementations to have the same return value.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Ross Zwisler <zwisler@kernel.org>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: linux-nvdimm@lists.01.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Jerome Glisse <jglisse@redhat.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Keith Busch <keith.busch@intel.com>
> ---
> 
>   b/arch/powerpc/mm/mem.c |    2 +-

walk_system_ram_range() was droped in commit 
https://git.kernel.orghttps://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=26b523356f49a0117c8f9e32ca98aa6d6e496e1a

Christophe

>   b/kernel/resource.c     |    4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff -puN arch/powerpc/mm/mem.c~memory-hotplug-walk_system_ram_range-returns-neg-1 arch/powerpc/mm/mem.c
> --- a/arch/powerpc/mm/mem.c~memory-hotplug-walk_system_ram_range-returns-neg-1	2019-02-25 10:56:47.452908034 -0800
> +++ b/arch/powerpc/mm/mem.c	2019-02-25 10:56:47.458908034 -0800
> @@ -189,7 +189,7 @@ walk_system_ram_range(unsigned long star
>   	struct memblock_region *reg;
>   	unsigned long end_pfn = start_pfn + nr_pages;
>   	unsigned long tstart, tend;
> -	int ret = -1;
> +	int ret = -EINVAL;
>   
>   	for_each_memblock(memory, reg) {
>   		tstart = max(start_pfn, memblock_region_memory_base_pfn(reg));
> diff -puN kernel/resource.c~memory-hotplug-walk_system_ram_range-returns-neg-1 kernel/resource.c
> --- a/kernel/resource.c~memory-hotplug-walk_system_ram_range-returns-neg-1	2019-02-25 10:56:47.454908034 -0800
> +++ b/kernel/resource.c	2019-02-25 10:56:47.459908034 -0800
> @@ -382,7 +382,7 @@ static int __walk_iomem_res_desc(resourc
>   				 int (*func)(struct resource *, void *))
>   {
>   	struct resource res;
> -	int ret = -1;
> +	int ret = -EINVAL;
>   
>   	while (start < end &&
>   	       !find_next_iomem_res(start, end, flags, desc, first_lvl, &res)) {
> @@ -462,7 +462,7 @@ int walk_system_ram_range(unsigned long
>   	unsigned long flags;
>   	struct resource res;
>   	unsigned long pfn, end_pfn;
> -	int ret = -1;
> +	int ret = -EINVAL;
>   
>   	start = (u64) start_pfn << PAGE_SHIFT;
>   	end = ((u64)(start_pfn + nr_pages) << PAGE_SHIFT) - 1;
> _
> 
