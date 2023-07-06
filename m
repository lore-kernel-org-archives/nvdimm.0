Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF16F7E8
	for <nvdimm@lists.linux.dev>; Thu,  6 Jul 2023 06:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688625960; x=1720161960;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=mRVVHAmFZ45/3wNp4nf90MXw/IuSIO9dhVaqP8s/mB0=;
  b=GmC+OpbhVVb6pIYMDxkCnq5zzGS/OpwVlmJOahBAyQ4XZzZLSgVBlDSD
   vLUwz/IHwkFTk7P8C9dvltE9qxmzRnsvU4BwcT+JWsoA0njEghXubB2LS
   WRz1GEOko/MVjhxaNOVpJHMfWYNEDsSD1Gh935yvKRClGA0EgPaEsdXuS
   eFpoYKEJdrI8k3SYuad26QoFtjDb9qkStcxt59Nhi38Egai4k6pTMGf/E
   /z2owcq3RDSXrHabTE3dW9J1ax63xyA+2q8vLreYSyau9ZbiHrSNo/wQw
   u7UGN8C0YwBDnjYH5FZ73f6wzzMawTEyHGwf/nRHdKvhJYdkbyGhSYSse
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="360994587"
X-IronPort-AV: E=Sophos;i="6.01,185,1684825200"; 
   d="scan'208";a="360994587"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 23:45:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="1049969094"
X-IronPort-AV: E=Sophos;i="6.01,185,1684825200"; 
   d="scan'208";a="1049969094"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 23:45:57 -0700
From: "Huang, Ying" <ying.huang@intel.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: <akpm@linux-foundation.org>,  <dan.j.williams@intel.com>,
  <vishal.l.verma@intel.com>,  <dave.jiang@intel.com>,
  <nvdimm@lists.linux.dev>,  <linux-cxl@vger.kernel.org>, Aneesh Kumar K.V
 <aneesh.kumar@linux.ibm.com>,
  <linux-mm@kvack.org>,  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memory tier: rename destroy_memory_type() to
 put_memory_type()
In-Reply-To: <20230706063905.543800-1-linmiaohe@huawei.com> (Miaohe Lin's
	message of "Thu, 6 Jul 2023 14:39:05 +0800")
References: <20230706063905.543800-1-linmiaohe@huawei.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Date: Thu, 06 Jul 2023 14:44:12 +0800
Message-ID: <87o7kph743.fsf@yhuang6-desk2.ccr.corp.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

Miaohe Lin <linmiaohe@huawei.com> writes:

> It appears that destroy_memory_type() isn't a very good name because
> we usually will not free the memory_type here. So rename it to a more
> appropriate name i.e. put_memory_type().
>
> Suggested-by: Huang, Ying <ying.huang@intel.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

LGTM, Thanks!

Reviewed-by: "Huang, Ying" <ying.huang@intel.com>

> ---
>  drivers/dax/kmem.c           | 4 ++--
>  include/linux/memory-tiers.h | 4 ++--
>  mm/memory-tiers.c            | 6 +++---
>  3 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 898ca9505754..c57acb73e3db 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -264,7 +264,7 @@ static int __init dax_kmem_init(void)
>  	return rc;
>  
>  error_dax_driver:
> -	destroy_memory_type(dax_slowmem_type);
> +	put_memory_type(dax_slowmem_type);
>  err_dax_slowmem_type:
>  	kfree_const(kmem_name);
>  	return rc;
> @@ -275,7 +275,7 @@ static void __exit dax_kmem_exit(void)
>  	dax_driver_unregister(&device_dax_kmem_driver);
>  	if (!any_hotremove_failed)
>  		kfree_const(kmem_name);
> -	destroy_memory_type(dax_slowmem_type);
> +	put_memory_type(dax_slowmem_type);
>  }
>  
>  MODULE_AUTHOR("Intel Corporation");
> diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
> index fc9647b1b4f9..437441cdf78f 100644
> --- a/include/linux/memory-tiers.h
> +++ b/include/linux/memory-tiers.h
> @@ -33,7 +33,7 @@ struct memory_dev_type {
>  #ifdef CONFIG_NUMA
>  extern bool numa_demotion_enabled;
>  struct memory_dev_type *alloc_memory_type(int adistance);
> -void destroy_memory_type(struct memory_dev_type *memtype);
> +void put_memory_type(struct memory_dev_type *memtype);
>  void init_node_memory_type(int node, struct memory_dev_type *default_type);
>  void clear_node_memory_type(int node, struct memory_dev_type *memtype);
>  #ifdef CONFIG_MIGRATION
> @@ -68,7 +68,7 @@ static inline struct memory_dev_type *alloc_memory_type(int adistance)
>  	return NULL;
>  }
>  
> -static inline void destroy_memory_type(struct memory_dev_type *memtype)
> +static inline void put_memory_type(struct memory_dev_type *memtype)
>  {
>  
>  }
> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> index 1719fa3bcf02..c49ab03f49b1 100644
> --- a/mm/memory-tiers.c
> +++ b/mm/memory-tiers.c
> @@ -560,11 +560,11 @@ struct memory_dev_type *alloc_memory_type(int adistance)
>  }
>  EXPORT_SYMBOL_GPL(alloc_memory_type);
>  
> -void destroy_memory_type(struct memory_dev_type *memtype)
> +void put_memory_type(struct memory_dev_type *memtype)
>  {
>  	kref_put(&memtype->kref, release_memtype);
>  }
> -EXPORT_SYMBOL_GPL(destroy_memory_type);
> +EXPORT_SYMBOL_GPL(put_memory_type);
>  
>  void init_node_memory_type(int node, struct memory_dev_type *memtype)
>  {
> @@ -586,7 +586,7 @@ void clear_node_memory_type(int node, struct memory_dev_type *memtype)
>  	 */
>  	if (!node_memory_types[node].map_count) {
>  		node_memory_types[node].memtype = NULL;
> -		destroy_memory_type(memtype);
> +		put_memory_type(memtype);
>  	}
>  	mutex_unlock(&memory_tier_lock);
>  }
