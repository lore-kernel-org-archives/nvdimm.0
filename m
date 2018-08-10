Return-Path: <owner-linux-mm@kvack.org>
Subject: Re: [PATCH V3 1/4] kvm: remove redundant reserved page check
References: <cover.1533811181.git.yi.z.zhang@linux.intel.com>
 <d2345e628a697ee17fdd6e360f7a6790caab10d5.1533811181.git.yi.z.zhang@linux.intel.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <f9732fe0-4401-47f4-6fff-7b308201901b@redhat.com>
Date: Fri, 10 Aug 2018 13:23:29 +0200
MIME-Version: 1.0
In-Reply-To: <d2345e628a697ee17fdd6e360f7a6790caab10d5.1533811181.git.yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Zhang Yi <yi.z.zhang@linux.intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, pbonzini@redhat.com, dan.j.williams@intel.com, jack@suse.cz, hch@lst.de, yu.c.zhang@intel.com
Cc: linux-mm@kvack.org, rkrcmar@redhat.com, yi.z.zhang@intel.com
List-ID: <linux-nvdimm@lists.01.org>

On 09.08.2018 12:52, Zhang Yi wrote:
> PageReserved() is already checked inside kvm_is_reserved_pfn(),
> remove it from kvm_set_pfn_dirty().
> 
> Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yu <yu.c.zhang@linux.intel.com>
> ---
>  virt/kvm/kvm_main.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8b47507f..c44c406 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1690,12 +1690,8 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
>  
>  void kvm_set_pfn_dirty(kvm_pfn_t pfn)
>  {
> -	if (!kvm_is_reserved_pfn(pfn)) {
> -		struct page *page = pfn_to_page(pfn);
> -
> -		if (!PageReserved(page))
> -			SetPageDirty(page);
> -	}
> +	if (!kvm_is_reserved_pfn(pfn))
> +		SetPageDirty(pfn_to_page(pfn));
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
>  
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 

Thanks,

David / dhildenb
