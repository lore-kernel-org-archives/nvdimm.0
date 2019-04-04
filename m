From: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v3 3/3] kvm: remove redundant PageReserved() check
Date: Thu, 4 Apr 2019 22:37:17 +0200
Message-ID: <0c4b4dc8-e18d-bf14-3440-d9e29af64154@redhat.com>
References: <20190404202345.133553-1-brho@google.com>
 <20190404202345.133553-4-brho@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190404202345.133553-4-brho@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Barret Rhoden <brho@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yu.c.zhang@intel.com, yi.z.zhang@intel.com
List-Id: linux-nvdimm@lists.01.org

On 04.04.19 22:23, Barret Rhoden wrote:
> kvm_is_reserved_pfn() already checks PageReserved().
> 
> Signed-off-by: Barret Rhoden <brho@google.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 55fe8e20d8fd..c44985375e7f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1782,12 +1782,8 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
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

I guess this one can be picked up right away, right?

-- 

Thanks,

David / dhildenb
