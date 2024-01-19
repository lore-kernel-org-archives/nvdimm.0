Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581361367
	for <nvdimm@lists.linux.dev>; Fri, 19 Jan 2024 01:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705629151; cv=none; b=NdEvbbldlw9oBGVF5aThFndzBMosv/hM2xeA5bcEIqVGAHjZiP6DoVkOkFbsAsf1FH7OYLK/V7IW2vXmJZHHMLysVKdjNVX9UH3qflmWOjoCswv18vgCJiHRb9Pg3E5k1sYj7wJpAFbKmkebdsS9+ZpbWeMYMeCSa6vHGRlVzEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705629151; c=relaxed/simple;
	bh=KKAckyFHILR6vGPJE8IIJu6rlRnjNzDvOA7mk1PirOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G23/eYwWCwKaYr/DvVqQwRkjFprtAgI4gyxZgefa41wPvQn5frR+shfv1v4BJXQ8dEO1pgxQKLRwShw/SREym+uOi+W7zO29FBaPvZLdClXZSbprmUDqTKdbk/EwdjmQCL5Bfe/LRP9rnwwDdkZTjxijTt427ktUPtXmHXcXoFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; arc=none smtp.client-ip=68.232.139.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="148252832"
X-IronPort-AV: E=Sophos;i="6.05,203,1701097200"; 
   d="scan'208";a="148252832"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2024 10:52:19 +0900
Received: from oym-m3.gw.nic.fujitsu.com (oym-nat-oym-m3.gw.nic.fujitsu.com [192.168.87.60])
	by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id D847CD9D90
	for <nvdimm@lists.linux.dev>; Fri, 19 Jan 2024 10:52:16 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 0DB3ED9499
	for <nvdimm@lists.linux.dev>; Fri, 19 Jan 2024 10:52:16 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 91B8D68957
	for <nvdimm@lists.linux.dev>; Fri, 19 Jan 2024 10:52:15 +0900 (JST)
Received: from [10.193.128.195] (unknown [10.193.128.195])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id B5F391A0072;
	Fri, 19 Jan 2024 09:52:14 +0800 (CST)
Message-ID: <777a7472-4eb1-4152-a648-2da5bfd39d16@fujitsu.com>
Date: Fri, 19 Jan 2024 09:52:14 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fsdax: cleanup tracepoints
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, willy@infradead.org, ira.weiny@intel.com
References: <20240104104925.3496797-1-ruansy.fnst@fujitsu.com>
 <20240104122647.ynowpqfmhrvftfss@quack3>
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <20240104122647.ynowpqfmhrvftfss@quack3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28128.003
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28128.003
X-TMASE-Result: 10--8.087500-10.000000
X-TMASE-MatchedRID: mZljRXDwq+6PvrMjLFD6eHchRkqzj/bEC/ExpXrHizwlr4zMriiW6Qc1
	kKhUHbFIo8Py93uwvr+bvdUVlY5ZkOkXbVjiLTkdvTzgeOt8UBJpeZ1cXZibx7cIt210bWgI6Ch
	K9oqyX+Qi+t+0AiFaYvL3NxFKQpq19IaoJGJ/0IvTCZHfjFFBz0fLPdsHmQbnqU5CNByvM6UHzY
	bIalkde90atarVue7jCXCP8eg7wMI1jBhMSgBKwZ4CIKY/Hg3AWQy9YC5qGvwCwwGD+AF1Ue52O
	dZcC6tPJ0RPnyOnrZJR+Gx7dNGeLJ8u0LcbU3GBLhx6qKRbj2b5pTj8Mu3F7bz4GVkvLBAaJkGI
	ggAHozDJWwCFatBBoymZPCsmJrgD+EqL+Loa93tlJCOsB4awXOVV62x4Nv+CWHt/4pqKiNrUEwC
	0VA4Efc/9za0y1DHl
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0


在 2024/1/4 20:26, Jan Kara 写道:
> On Thu 04-01-24 18:49:25, Shiyang Ruan wrote:
>> Restore the tracepoint that was accidentally deleted before, and rename
>> to dax_insert_entry().  Also, since we are using XArray, rename
>> 'radix_entry' to 'xa_entry'.
>>
>> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> 
> Looks good. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thank you~


To nvdimm list:
Could this be merged?  Or any other comment?


--
Thanks
Ruan.

> 
> 								Honza
> 
>> ---
>>   fs/dax.c                      |  2 ++
>>   include/trace/events/fs_dax.h | 47 +++++++++++++++++------------------
>>   2 files changed, 25 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/dax.c b/fs/dax.c
>> index 3380b43cb6bb..7e7aabec91d8 100644
>> --- a/fs/dax.c
>> +++ b/fs/dax.c
>> @@ -1684,6 +1684,8 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
>>   	if (dax_fault_is_synchronous(iter, vmf->vma))
>>   		return dax_fault_synchronous_pfnp(pfnp, pfn);
>>   
>> +	trace_dax_insert_entry(iter->inode, vmf, *entry);
>> +
>>   	/* insert PMD pfn */
>>   	if (pmd)
>>   		return vmf_insert_pfn_pmd(vmf, pfn, write);
>> diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
>> index 97b09fcf7e52..2ec2dcc8f66a 100644
>> --- a/include/trace/events/fs_dax.h
>> +++ b/include/trace/events/fs_dax.h
>> @@ -62,15 +62,14 @@ DEFINE_PMD_FAULT_EVENT(dax_pmd_fault_done);
>>   
>>   DECLARE_EVENT_CLASS(dax_pmd_load_hole_class,
>>   	TP_PROTO(struct inode *inode, struct vm_fault *vmf,
>> -		struct page *zero_page,
>> -		void *radix_entry),
>> -	TP_ARGS(inode, vmf, zero_page, radix_entry),
>> +		struct page *zero_page, void *xa_entry),
>> +	TP_ARGS(inode, vmf, zero_page, xa_entry),
>>   	TP_STRUCT__entry(
>>   		__field(unsigned long, ino)
>>   		__field(unsigned long, vm_flags)
>>   		__field(unsigned long, address)
>>   		__field(struct page *, zero_page)
>> -		__field(void *, radix_entry)
>> +		__field(void *, xa_entry)
>>   		__field(dev_t, dev)
>>   	),
>>   	TP_fast_assign(
>> @@ -79,40 +78,40 @@ DECLARE_EVENT_CLASS(dax_pmd_load_hole_class,
>>   		__entry->vm_flags = vmf->vma->vm_flags;
>>   		__entry->address = vmf->address;
>>   		__entry->zero_page = zero_page;
>> -		__entry->radix_entry = radix_entry;
>> +		__entry->xa_entry = xa_entry;
>>   	),
>>   	TP_printk("dev %d:%d ino %#lx %s address %#lx zero_page %p "
>> -			"radix_entry %#lx",
>> +			"xa_entry %#lx",
>>   		MAJOR(__entry->dev),
>>   		MINOR(__entry->dev),
>>   		__entry->ino,
>>   		__entry->vm_flags & VM_SHARED ? "shared" : "private",
>>   		__entry->address,
>>   		__entry->zero_page,
>> -		(unsigned long)__entry->radix_entry
>> +		(unsigned long)__entry->xa_entry
>>   	)
>>   )
>>   
>>   #define DEFINE_PMD_LOAD_HOLE_EVENT(name) \
>>   DEFINE_EVENT(dax_pmd_load_hole_class, name, \
>>   	TP_PROTO(struct inode *inode, struct vm_fault *vmf, \
>> -		struct page *zero_page, void *radix_entry), \
>> -	TP_ARGS(inode, vmf, zero_page, radix_entry))
>> +		struct page *zero_page, void *xa_entry), \
>> +	TP_ARGS(inode, vmf, zero_page, xa_entry))
>>   
>>   DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole);
>>   DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole_fallback);
>>   
>>   DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
>>   	TP_PROTO(struct inode *inode, struct vm_fault *vmf,
>> -		long length, pfn_t pfn, void *radix_entry),
>> -	TP_ARGS(inode, vmf, length, pfn, radix_entry),
>> +		long length, pfn_t pfn, void *xa_entry),
>> +	TP_ARGS(inode, vmf, length, pfn, xa_entry),
>>   	TP_STRUCT__entry(
>>   		__field(unsigned long, ino)
>>   		__field(unsigned long, vm_flags)
>>   		__field(unsigned long, address)
>>   		__field(long, length)
>>   		__field(u64, pfn_val)
>> -		__field(void *, radix_entry)
>> +		__field(void *, xa_entry)
>>   		__field(dev_t, dev)
>>   		__field(int, write)
>>   	),
>> @@ -124,10 +123,10 @@ DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
>>   		__entry->write = vmf->flags & FAULT_FLAG_WRITE;
>>   		__entry->length = length;
>>   		__entry->pfn_val = pfn.val;
>> -		__entry->radix_entry = radix_entry;
>> +		__entry->xa_entry = xa_entry;
>>   	),
>>   	TP_printk("dev %d:%d ino %#lx %s %s address %#lx length %#lx "
>> -			"pfn %#llx %s radix_entry %#lx",
>> +			"pfn %#llx %s xa_entry %#lx",
>>   		MAJOR(__entry->dev),
>>   		MINOR(__entry->dev),
>>   		__entry->ino,
>> @@ -138,15 +137,15 @@ DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
>>   		__entry->pfn_val & ~PFN_FLAGS_MASK,
>>   		__print_flags_u64(__entry->pfn_val & PFN_FLAGS_MASK, "|",
>>   			PFN_FLAGS_TRACE),
>> -		(unsigned long)__entry->radix_entry
>> +		(unsigned long)__entry->xa_entry
>>   	)
>>   )
>>   
>>   #define DEFINE_PMD_INSERT_MAPPING_EVENT(name) \
>>   DEFINE_EVENT(dax_pmd_insert_mapping_class, name, \
>>   	TP_PROTO(struct inode *inode, struct vm_fault *vmf, \
>> -		long length, pfn_t pfn, void *radix_entry), \
>> -	TP_ARGS(inode, vmf, length, pfn, radix_entry))
>> +		long length, pfn_t pfn, void *xa_entry), \
>> +	TP_ARGS(inode, vmf, length, pfn, xa_entry))
>>   
>>   DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping);
>>   
>> @@ -194,14 +193,14 @@ DEFINE_PTE_FAULT_EVENT(dax_load_hole);
>>   DEFINE_PTE_FAULT_EVENT(dax_insert_pfn_mkwrite_no_entry);
>>   DEFINE_PTE_FAULT_EVENT(dax_insert_pfn_mkwrite);
>>   
>> -TRACE_EVENT(dax_insert_mapping,
>> -	TP_PROTO(struct inode *inode, struct vm_fault *vmf, void *radix_entry),
>> -	TP_ARGS(inode, vmf, radix_entry),
>> +TRACE_EVENT(dax_insert_entry,
>> +	TP_PROTO(struct inode *inode, struct vm_fault *vmf, void *xa_entry),
>> +	TP_ARGS(inode, vmf, xa_entry),
>>   	TP_STRUCT__entry(
>>   		__field(unsigned long, ino)
>>   		__field(unsigned long, vm_flags)
>>   		__field(unsigned long, address)
>> -		__field(void *, radix_entry)
>> +		__field(void *, xa_entry)
>>   		__field(dev_t, dev)
>>   		__field(int, write)
>>   	),
>> @@ -211,16 +210,16 @@ TRACE_EVENT(dax_insert_mapping,
>>   		__entry->vm_flags = vmf->vma->vm_flags;
>>   		__entry->address = vmf->address;
>>   		__entry->write = vmf->flags & FAULT_FLAG_WRITE;
>> -		__entry->radix_entry = radix_entry;
>> +		__entry->xa_entry = xa_entry;
>>   	),
>> -	TP_printk("dev %d:%d ino %#lx %s %s address %#lx radix_entry %#lx",
>> +	TP_printk("dev %d:%d ino %#lx %s %s address %#lx xa_entry %#lx",
>>   		MAJOR(__entry->dev),
>>   		MINOR(__entry->dev),
>>   		__entry->ino,
>>   		__entry->vm_flags & VM_SHARED ? "shared" : "private",
>>   		__entry->write ? "write" : "read",
>>   		__entry->address,
>> -		(unsigned long)__entry->radix_entry
>> +		(unsigned long)__entry->xa_entry
>>   	)
>>   )
>>   
>> -- 
>> 2.34.1
>>
