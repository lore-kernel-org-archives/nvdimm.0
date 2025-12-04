Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6BA2C21DD
	for <nvdimm@lists.linux.dev>; Thu,  4 Dec 2025 15:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764862357; cv=none; b=LRUGXy8qxDxQEpcpR0FhUSYaD7JZdIlZjbaHvnUhKWF5+ykwJImk2hWuV0/jip09lXZZHyUi50zh9nkxutrEm0wFYqHTpiLfhNaWkaa2YfItPWbujV43aOo26j46ekgchjUpoNdj+qeBq3M4foueU/qoYoZMIXJPkFrKTnrAejc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764862357; c=relaxed/simple;
	bh=S6CAhs5LxH2D5Nbs4QFFYkkL04204rFH7m5ZkCPVqZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s/8b6gW405Icr+GspBOeM30N/UE5rdatazigFEwACCLibIkXEEIhT+NDzh7X57bC4UH58hcgOCTqYdGNKgHgIlPyRXXt0XClym4YAZxpE86ta2AOnIfWvy39mWlb32ZPxsDrb8nDvieCG6l+YMmHVSbFaJ2gAP5cmwZQ4C7HKVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cJMjhyKp; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cJMjhyKp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764862355; x=1796398355;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=S6CAhs5LxH2D5Nbs4QFFYkkL04204rFH7m5ZkCPVqZg=;
  b=cJMjhyKpNh1MQ8wzQL04G8HcG7IemcsBYexTN542Q3fMDxLOQBa3dTsh
   ga3KH6bdhVOPq0OzB+Aq0w/yzqSMZdeogQT8UAEQbSXvsRLf6jPug19Wd
   dzBEZI98GIlHARGGln08lL3iwiRM+u5iZNQiCqFRXAISBFkHVX/VzF/Dk
   4Waq3dXi7yItGqUISTxKm95zVbN4Av4cWYNplKICIVuiMKAYmvh8lDVlu
   bV2OmBYCn1ZM/bFj3ejk+vlZCb8bTqYlkMTawroFYYJLhWLbrJsmxTiJe
   ALdiFLkv0sHLzxWidlH033U/3so7AgVFODUx8RH70ZNiaRN8Wq14syb0c
   w==;
X-CSE-ConnectionGUID: 3Exr2CghTl+V8tjY9epojA==
X-CSE-MsgGUID: u+gFxgazRTGOl9zSf131ug==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="66926590"
X-IronPort-AV: E=Sophos;i="6.20,249,1758610800"; 
   d="scan'208";a="66926590"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 07:32:35 -0800
X-CSE-ConnectionGUID: ppOQBGvSQseNVmBI1B5B4Q==
X-CSE-MsgGUID: duhnSg0ASyy0ZkWfkwEkQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,249,1758610800"; 
   d="scan'208";a="194289050"
Received: from schen9-mobl4.amr.corp.intel.com (HELO [10.125.108.95]) ([10.125.108.95])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 07:32:34 -0800
Message-ID: <6225d231-1d9f-474b-9003-a3a56d528545@intel.com>
Date: Thu, 4 Dec 2025 08:32:33 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] drivers/nvdimm: Use local kmaps
To: Davidlohr Bueso <dave@stgolabs.net>, vishal.l.verma@intel.com,
 dan.j.williams@intel.com, ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20251128212303.2170933-1-dave@stgolabs.net>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20251128212303.2170933-1-dave@stgolabs.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/28/25 2:23 PM, Davidlohr Bueso wrote:
> Replace the now deprecated kmap_atomic() with kmap_local_page().
> 
> Optimizing nvdimm/pmem for highmem makes no sense as this is always
> 64bit, and the mapped regions for both btt and pmem do not require
> disabling preemption and pagefaults. Specifically, kmap does not care
> about the caller's atomic context (such as reads holding the btt arena
> spinlock) or NVDIMM_IO_ATOMIC semantics to avoid error handling when
> accessing the btt arena in general. Same for the memcpy cases. kmap
> local temporary mappings will hold valid across any context switches.
> 
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>> ---
>  drivers/nvdimm/btt.c  | 12 ++++++------
>  drivers/nvdimm/pmem.c |  8 ++++----
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index a933db961ed7..237edfa1c624 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -1104,10 +1104,10 @@ static int btt_data_read(struct arena_info *arena, struct page *page,
>  {
>  	int ret;
>  	u64 nsoff = to_namespace_offset(arena, lba);
> -	void *mem = kmap_atomic(page);
> +	void *mem = kmap_local_page(page);
>  
>  	ret = arena_read_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
> -	kunmap_atomic(mem);
> +	kunmap_local(mem);
>  
>  	return ret;
>  }
> @@ -1117,20 +1117,20 @@ static int btt_data_write(struct arena_info *arena, u32 lba,
>  {
>  	int ret;
>  	u64 nsoff = to_namespace_offset(arena, lba);
> -	void *mem = kmap_atomic(page);
> +	void *mem = kmap_local_page(page);
>  
>  	ret = arena_write_bytes(arena, nsoff, mem + off, len, NVDIMM_IO_ATOMIC);
> -	kunmap_atomic(mem);
> +	kunmap_local(mem);
>  
>  	return ret;
>  }
>  
>  static void zero_fill_data(struct page *page, unsigned int off, u32 len)
>  {
> -	void *mem = kmap_atomic(page);
> +	void *mem = kmap_local_page(page);
>  
>  	memset(mem + off, 0, len);
> -	kunmap_atomic(mem);
> +	kunmap_local(mem);
>  }
>  
>  #ifdef CONFIG_BLK_DEV_INTEGRITY
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 05785ff21a8b..92c67fbbc1c8 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -128,10 +128,10 @@ static void write_pmem(void *pmem_addr, struct page *page,
>  	void *mem;
>  
>  	while (len) {
> -		mem = kmap_atomic(page);
> +		mem = kmap_local_page(page);
>  		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
>  		memcpy_flushcache(pmem_addr, mem + off, chunk);
> -		kunmap_atomic(mem);
> +		kunmap_local(mem);
>  		len -= chunk;
>  		off = 0;
>  		page++;
> @@ -147,10 +147,10 @@ static blk_status_t read_pmem(struct page *page, unsigned int off,
>  	void *mem;
>  
>  	while (len) {
> -		mem = kmap_atomic(page);
> +		mem = kmap_local_page(page);
>  		chunk = min_t(unsigned int, len, PAGE_SIZE - off);
>  		rem = copy_mc_to_kernel(mem + off, pmem_addr, chunk);
> -		kunmap_atomic(mem);
> +		kunmap_local(mem);
>  		if (rem)
>  			return BLK_STS_IOERR;
>  		len -= chunk;

