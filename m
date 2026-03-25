Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8DA2066DE;
	Wed, 25 Mar 2026 07:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774423881; cv=none; b=ULUjpAkdKJOWR95S0ytSK/Q9kSUm6fEO4uaVHfCI4W51gYlCy2Ij7glURUs6dR97tRRQnC0Q1OdV8rgia/mNRNnUEp1OYwy1vX8GZdM48eGLnum3ZifFb4dcTZivoPwl1Hu6iqsyaUKM4uRwYHR0TuOAjQ6NKwsMriCazKO3Jvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774423881; c=relaxed/simple;
	bh=PDpC05xIR6s/4UV5jN3PjFOdu2Q97pVq9psWfxYFyHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K24JhQiVwWT5Uu0pSpneUSdMzatMSEZfY/+SO4J36cMlGwCb0jlWFov5jdB11Fg+lO5qLM7ZLX8mm5Byk3yHL/Ci8MdFIdZH4pjWjdQP/3czgA+UApgMXYmhjqHvPJNC6TWGrNMyfOpfCicYKq+y5gVION8GaivEVnR7DriDO/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nQ1tBcxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nQ1tBcxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BAAC4CEF7;
	Wed, 25 Mar 2026 07:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774423880;
	bh=PDpC05xIR6s/4UV5jN3PjFOdu2Q97pVq9psWfxYFyHw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nQ1tBcxSm01q4n6kTNrYWBbiz6PEozKBxiLI/zRRn9IVJLOFBuiCTBZTV6Ycbv68o
	 oiWSh5L8g+RNHWwPtdhmgn1oKV6wvxKTmlFbkJn31BymWvwaLcilghpF/Kt/e22P+q
	 To61pHOGS02rXG/sHWxWWIOLGtCXLJBQT+6jZQNKx4kBXkP5f8DvFEMIKhLfbKwCRz
	 8lqFvmWOowscszEiyhGCEjWBxzBqyWA5PR4f3CAd2qIwYN8saFjOzhVIqCVJoXxKNz
	 TPC4R2t+1iEuQeBDdvvuzwc1kVUBP5vhdKl/eZDomHm8OIwC74J3M9QLLUmopfkeUj
	 a2GPHfKz7cfEA==
Message-ID: <d0111a86-7fc9-4e2f-b652-9ecbb894ada5@kernel.org>
Date: Wed, 25 Mar 2026 08:31:09 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] mm: add vma_desc_test_all() and use it
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>,
 James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org,
 ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <cover.1772704455.git.ljs@kernel.org>
 <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/5/26 11:50, Lorenzo Stoakes (Oracle) wrote:
> erofs and zonefs are using vma_desc_test_any() twice to check whether all
> of VMA_SHARED_BIT and VMA_MAYWRITE_BIT are set, this is silly, so add
> vma_desc_test_all() to test all flags and update erofs and zonefs to use
> it.
> 
> While we're here, update the helper function comments to be more
> consistent.
> 
> Also add the same to the VMA test headers.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

I thought I saw David review all of the series and so focused on other
stuff, didn't notice he skipped this one :)

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  fs/erofs/data.c                 |  3 +--
>  fs/zonefs/file.c                |  3 +--
>  include/linux/mm.h              | 24 ++++++++++++++++++++----
>  tools/testing/vma/include/dup.h |  9 +++++++++
>  4 files changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 6774d9b5ee82..b33dd4d8710e 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
> @@ -473,8 +473,7 @@ static int erofs_file_mmap_prepare(struct vm_area_desc *desc)
>  	if (!IS_DAX(file_inode(desc->file)))
>  		return generic_file_readonly_mmap_prepare(desc);
>  
> -	if (vma_desc_test_any(desc, VMA_SHARED_BIT) &&
> -	    vma_desc_test_any(desc, VMA_MAYWRITE_BIT))
> +	if (vma_desc_test_all(desc, VMA_SHARED_BIT, VMA_MAYWRITE_BIT))
>  		return -EINVAL;
>  
>  	desc->vm_ops = &erofs_dax_vm_ops;
> diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
> index 9f9273ecf71a..5ada33f70bb4 100644
> --- a/fs/zonefs/file.c
> +++ b/fs/zonefs/file.c
> @@ -333,8 +333,7 @@ static int zonefs_file_mmap_prepare(struct vm_area_desc *desc)
>  	 * ordering between msync() and page cache writeback.
>  	 */
>  	if (zonefs_inode_is_seq(file_inode(file)) &&
> -	    vma_desc_test_any(desc, VMA_SHARED_BIT) &&
> -	    vma_desc_test_any(desc, VMA_MAYWRITE_BIT))
> +	    vma_desc_test_all(desc, VMA_SHARED_BIT, VMA_MAYWRITE_BIT))
>  		return -EINVAL;
>  
>  	file_accessed(file);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index db738a567637..9a052eedcdf4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1178,7 +1178,7 @@ static inline void vma_set_flags_mask(struct vm_area_struct *vma,
>  #define vma_set_flags(vma, ...) \
>  	vma_set_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
>  
> -/* Helper to test all VMA flags in a VMA descriptor. */
> +/* Helper to test any VMA flags in a VMA descriptor. */
>  static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
>  		vma_flags_t flags)
>  {
> @@ -1186,8 +1186,8 @@ static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
>  }
>  
>  /*
> - * Helper macro for testing VMA flags for an input pointer to a struct
> - * vm_area_desc object describing a proposed VMA, e.g.:
> + * Helper macro for testing whether any VMA flags are set in a VMA descriptor,
> + * e.g.:
>   *
>   * if (vma_desc_test_any(desc, VMA_IO_BIT, VMA_PFNMAP_BIT,
>   *		VMA_DONTEXPAND_BIT, VMA_DONTDUMP_BIT)) { ... }
> @@ -1195,6 +1195,22 @@ static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
>  #define vma_desc_test_any(desc, ...) \
>  	vma_desc_test_any_mask(desc, mk_vma_flags(__VA_ARGS__))
>  
> +/* Helper to test all VMA flags in a VMA descriptor. */
> +static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
> +		vma_flags_t flags)
> +{
> +	return vma_flags_test_all_mask(&desc->vma_flags, flags);
> +}
> +
> +/*
> + * Helper macro for testing whether ALL VMA flags are set in a VMA descriptor,
> + * e.g.:
> + *
> + * if (vma_desc_test_all(desc, VMA_READ_BIT, VMA_MAYREAD_BIT)) { ... }
> + */
> +#define vma_desc_test_all(desc, ...) \
> +	vma_desc_test_all_mask(desc, mk_vma_flags(__VA_ARGS__))
> +
>  /* Helper to set all VMA flags in a VMA descriptor. */
>  static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
>  		vma_flags_t flags)
> @@ -1207,7 +1223,7 @@ static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
>   * vm_area_desc object describing a proposed VMA, e.g.:
>   *
>   * vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
> - * 		VMA_DONTDUMP_BIT);
> + *		VMA_DONTDUMP_BIT);
>   */
>  #define vma_desc_set_flags(desc, ...) \
>  	vma_desc_set_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
> index c46b523e428d..59788bc14d75 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -922,6 +922,15 @@ static inline bool vma_desc_test_any_mask(const struct vm_area_desc *desc,
>  #define vma_desc_test_any(desc, ...) \
>  	vma_desc_test_any_mask(desc, mk_vma_flags(__VA_ARGS__))
>  
> +static inline bool vma_desc_test_all_mask(const struct vm_area_desc *desc,
> +		vma_flags_t flags)
> +{
> +	return vma_flags_test_all_mask(&desc->vma_flags, flags);
> +}
> +
> +#define vma_desc_test_all(desc, ...) \
> +	vma_desc_test_all_mask(desc, mk_vma_flags(__VA_ARGS__))
> +
>  static inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
>  					   vma_flags_t flags)
>  {

