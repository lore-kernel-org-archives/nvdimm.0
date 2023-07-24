Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482937C
	for <nvdimm@lists.linux.dev>; Mon, 24 Jul 2023 06:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690178543; x=1721714543;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=hJeqyaPA2/UiA3SdbIjwXePXzRG8vLnfEgD/5hSNAoM=;
  b=f+FjhiMNs3YFPyJvqp1QQh/20dkSQE2zVguid+8DOte5+SYbjC4MwbBr
   NmXeLhxh3MArGeJhghLXUe9g74XiUlgr37uFzFNajSGbCLC282+MxRVSn
   Un52bq3E99VpIOxLwwzJxolBP9a/XGSIe0NMOa9UQDFo3feuBANoPcFCV
   yMApRZNknxckCIvnE2ieKfecGlUNb+TGF3csk6NY37yv4J0bVhEOGmJR2
   EBlXHdMGXqst+z0L5RpUgynih0TKYONCcabRbrcGcmX/O0cqmTagTEqaY
   zx5I5EQJLHZzxjDsQol7wNP/XVjVUEkh7adnj6tadnj93E2I5AlCGyA/3
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="366243574"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="366243574"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 23:02:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="849500142"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="849500142"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2023 23:02:11 -0700
From: "Huang, Ying" <ying.huang@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@redhat.com>,  Oscar Salvador <osalvador@suse.de>,  Dan Williams
 <dan.j.williams@intel.com>,  Dave Jiang <dave.jiang@intel.com>,
  <linux-kernel@vger.kernel.org>,  <linux-mm@kvack.org>,
  <nvdimm@lists.linux.dev>,  <linux-cxl@vger.kernel.org>,  Dave Hansen
 <dave.hansen@linux.intel.com>,  "Aneesh Kumar K.V"
 <aneesh.kumar@linux.ibm.com>,  Jonathan Cameron
 <Jonathan.Cameron@Huawei.com>,  Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2 1/3] mm/memory_hotplug: Export symbol
 mhp_supports_memmap_on_memory()
References: <20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com>
	<20230720-vv-kmem_memmap-v2-1-88bdaab34993@intel.com>
Date: Mon, 24 Jul 2023 14:00:34 +0800
In-Reply-To: <20230720-vv-kmem_memmap-v2-1-88bdaab34993@intel.com> (Vishal
	Verma's message of "Thu, 20 Jul 2023 01:14:22 -0600")
Message-ID: <87sf9d26il.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

Vishal Verma <vishal.l.verma@intel.com> writes:

> In preparation for dax drivers, which can be built as modules,
> to use this interface, export it with EXPORT_SYMBOL_GPL(). Add a #else
> case for the symbol for builds without CONFIG_MEMORY_HOTPLUG.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  include/linux/memory_hotplug.h | 5 +++++
>  mm/memory_hotplug.c            | 1 +
>  2 files changed, 6 insertions(+)
>
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 013c69753c91..fc5da07ad011 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -355,6 +355,11 @@ extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
>  				      struct mhp_params *params);
>  void arch_remove_linear_mapping(u64 start, u64 size);
>  extern bool mhp_supports_memmap_on_memory(unsigned long size);
> +#else
> +static inline bool mhp_supports_memmap_on_memory(unsigned long size)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_MEMORY_HOTPLUG */

It appears that there is no user of mhp_supports_memmap_on_memory() that
may be compiled with !CONFIG_MEMORY_HOTPLUG?

--
Best Regards,
Huang, Ying

>  #endif /* __LINUX_MEMORY_HOTPLUG_H */
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 3f231cf1b410..e9bcacbcbae2 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1284,6 +1284,7 @@ bool mhp_supports_memmap_on_memory(unsigned long size)
>  	       IS_ALIGNED(vmemmap_size, PMD_SIZE) &&
>  	       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT));
>  }
> +EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
>  
>  /*
>   * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
