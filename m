Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004DD14B955
	for <nvdimm@lists.linux.dev>; Tue, 14 Jan 2025 14:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736866780; cv=none; b=sZ7b1NEjvnY5jXVKQ10Aww9Ga2eddIu0gTcICEiZQaCGtS7u878IxRmpEjqMPRvQQ+nKZYUnfQO60BHn1tN4HwmYYauld0prPe2CQ6S1TMhEdoY2eRC7o9dx5k44VRtAmpWWMldwcShQEOteflYbj5F8fhNxe8wyA7Hj7tzHrhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736866780; c=relaxed/simple;
	bh=D5xm3vL9ujW8inQ5mfURHfB5H5PTk4LOQ8S+EKftCv4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CVyMBgnedHvV38g9RNH5KpmbKxcwqI6j5NDQ2Udw3pqyE+fNsp/b1SulOUTdQ/q3bskmvlNespBxCAS3PM3GoqN0TXxunGdNM9dnOIGo/egx/p20iSPsdTdwu0eUh2phb7JTODGDypFzwz+Wg/NSYghQwKlY5BDdXmwi6ifkhuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bKPMq45K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bKPMq45K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736866776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YOOFa4tjOJHbzYzB4ngXxpUasXqbBcdKvOApLshzGmU=;
	b=bKPMq45K0qByIaflpRZoL8+bj5Akep3zt1oagfcfl6cRobI8AX/OtpCSeARywB+U9XaXQW
	kjJgAYsV7Q6s5GUWc09l61vYHMhAI2O+Q91dDSXJc/qNfHDI06Atqj6qm2WxcTbGKCsRwP
	MROVXSjl8Kax8tI5Pu6E4uFzv+p9f1U=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-yxdYod4eOOmBcl24co5L1Q-1; Tue, 14 Jan 2025 09:59:35 -0500
X-MC-Unique: yxdYod4eOOmBcl24co5L1Q-1
X-Mimecast-MFC-AGG-ID: yxdYod4eOOmBcl24co5L1Q
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385d7611ad3so3160313f8f.2
        for <nvdimm@lists.linux.dev>; Tue, 14 Jan 2025 06:59:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736866774; x=1737471574;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YOOFa4tjOJHbzYzB4ngXxpUasXqbBcdKvOApLshzGmU=;
        b=XM+13dwlKj0bTqosUpISJipmMmhIUIp5OLSvaFGhorDSQ59Ai4LCfpTVSa0mv0AWOu
         Vm/dSQDePEBq/gszeC73Jetl4aEwvTU6NvjoiCnlkTPG5f7/SwFFgw2M3DE9DEPv/Oyl
         dNGI4P1ATm8shdtfUZEZkWY0hVPoysGqQJgmgMe1vN1s9Lf0eeTqq3ezh6goh/URnI46
         3j6c9Cy2e2a6SsC9QoNUHEt5MDnhJ4Mx5icW5eY5NDmkzQhtBPd/PG9bjAOnT+yHCeRK
         GWfSWXpyQMPJuBjr356w6aS7fgiRxrfe0Ka6lHJKM7TEplfwC3FeJQtgTBqepL6bUp3J
         ZnOA==
X-Forwarded-Encrypted: i=1; AJvYcCVEHe6y/vJW99cKG3hUwExOsbtsoJaNhQsqJfgBqKCm6SFdUSZxZfid/l1rY2RxqLRa+D1GOBQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOKffG21iSKOV5ocVAoA51GTAeza8NSfA4TMRRdDWFRq1FWZfq
	10JLU1d+r573XcjYvbpORPSuiXSO80CoHVivqkfOkY+Aa7Py0OrquG1D297osGD3TGGNVEnZbzG
	pAuLTs4sTGekvKn7W+zo/HhM6uGLtFzfnt5Ov5depJqeBxpzUrKAkGA==
X-Gm-Gg: ASbGncuFyFlO8FI8VAQnPeMsQ/pN9JL6kwVjX1ow2kVvV6itrQdR4Q+mNUYksbzTqI1
	vnJBc8S9KBPSzEjhBQbsRqLwjs1UbqrMdTSZIRd0xAtaeBkj1bX+SZf1nEE4uDuu7eQekKDEgey
	/TKp4JSfVkwildhASCyfsl/aGyZ403e2hTns9FJaGPTzALTSRB5dYhb0b6Yjrpn+dLVJkBUyqA3
	y+o0ZXs46X8WXYntqVQxAyMF1uR/Vo9UEEoQuOsX+cBpL1wlQI8EjgpFzf45FWNTEtFBV2YCNpR
	kO/tE/tPufrwx15aoFiSUdFbPqRqM0T0xWfHkC4aqgvv3zDrIu9rHVvyrAWe6HQDkgXKjJVzLH5
	EjvalA6Q1
X-Received: by 2002:a5d:64cc:0:b0:38a:86fe:52b3 with SMTP id ffacd0b85a97d-38a872e173emr22802721f8f.22.1736866774378;
        Tue, 14 Jan 2025 06:59:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHz2uZAV+J70P9YucwAztT9JSZ7+2iGUIBmkejGoMGYwNzGwovCPwKhDvjPwFBNmG0N05EWIg==
X-Received: by 2002:a5d:64cc:0:b0:38a:86fe:52b3 with SMTP id ffacd0b85a97d-38a872e173emr22802666f8f.22.1736866773899;
        Tue, 14 Jan 2025 06:59:33 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38428bsm15089893f8f.37.2025.01.14.06.59.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 06:59:33 -0800 (PST)
Message-ID: <927f9cef-3f97-4bef-b6d8-53e6ef1b78a8@redhat.com>
Date: Tue, 14 Jan 2025 15:59:31 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/26] mm: Allow compound zone device pages
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
 dan.j.williams@intel.com, linux-mm@kvack.org
Cc: alison.schofield@intel.com, lina@asahilina.net, zhang.lyra@gmail.com,
 gerald.schaefer@linux.ibm.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, logang@deltatee.com, bhelgaas@google.com,
 jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com, will@kernel.org,
 mpe@ellerman.id.au, npiggin@gmail.com, dave.hansen@linux.intel.com,
 ira.weiny@intel.com, willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
 linmiaohe@huawei.com, peterx@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jhubbard@nvidia.com,
 hch@lst.de, david@fromorbit.com, chenhuacai@kernel.org, kernel@xen0n.name,
 loongarch@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.11189864684e31260d1408779fac9db80122047b.1736488799.git-series.apopple@nvidia.com>
 <9210f90866fef17b54884130fb3e55ab410dd015.1736488799.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <9210f90866fef17b54884130fb3e55ab410dd015.1736488799.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VkfnvfE5kvK_L1LUn2SWjgMhNdmirToQnIGqasi99k8_1736866774
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.01.25 07:00, Alistair Popple wrote:
> Zone device pages are used to represent various type of device memory
> managed by device drivers. Currently compound zone device pages are
> not supported. This is because MEMORY_DEVICE_FS_DAX pages are the only
> user of higher order zone device pages and have their own page
> reference counting.
> 
> A future change will unify FS DAX reference counting with normal page
> reference counting rules and remove the special FS DAX reference
> counting. Supporting that requires compound zone device pages.
> 
> Supporting compound zone device pages requires compound_head() to
> distinguish between head and tail pages whilst still preserving the
> special struct page fields that are specific to zone device pages.
> 
> A tail page is distinguished by having bit zero being set in
> page->compound_head, with the remaining bits pointing to the head
> page. For zone device pages page->compound_head is shared with
> page->pgmap.
> 
> The page->pgmap field is common to all pages within a memory section.
> Therefore pgmap is the same for both head and tail pages and can be
> moved into the folio and we can use the standard scheme to find
> compound_head from a tail page.

The more relevant thing is that the pgmap field must be common to all 
pages in a folio, even if a folio exceeds memory sections (e.g., 128 MiB 
on x86_64 where we have 1 GiB folios).

 > > Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> ---
> 
> Changes for v4:
>   - Fix build breakages reported by kernel test robot
> 
> Changes since v2:
> 
>   - Indentation fix
>   - Rename page_dev_pagemap() to page_pgmap()
>   - Rename folio _unused field to _unused_pgmap_compound_head
>   - s/WARN_ON/VM_WARN_ON_ONCE_PAGE/
> 
> Changes since v1:
> 
>   - Move pgmap to the folio as suggested by Matthew Wilcox
> ---

[...]

>   static inline bool folio_is_device_coherent(const struct folio *folio)
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 29919fa..61899ec 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -205,8 +205,8 @@ struct migrate_vma {
>   	unsigned long		end;
>   
>   	/*
> -	 * Set to the owner value also stored in page->pgmap->owner for
> -	 * migrating out of device private memory. The flags also need to
> +	 * Set to the owner value also stored in page_pgmap(page)->owner
> +	 * for migrating out of device private memory. The flags also need to
>   	 * be set to MIGRATE_VMA_SELECT_DEVICE_PRIVATE.
>   	 * The caller should always set this field when using mmu notifier
>   	 * callbacks to avoid device MMU invalidations for device private
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index df8f515..54b59b8 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -129,8 +129,11 @@ struct page {
>   			unsigned long compound_head;	/* Bit zero is set */
>   		};
>   		struct {	/* ZONE_DEVICE pages */
> -			/** @pgmap: Points to the hosting device page map. */
> -			struct dev_pagemap *pgmap;
> +			/*
> +			 * The first word is used for compound_head or folio
> +			 * pgmap
> +			 */
> +			void *_unused_pgmap_compound_head;
>   			void *zone_device_data;
>   			/*
>   			 * ZONE_DEVICE private pages are counted as being
> @@ -299,6 +302,7 @@ typedef struct {
>    * @_refcount: Do not access this member directly.  Use folio_ref_count()
>    *    to find how many references there are to this folio.
>    * @memcg_data: Memory Control Group data.
> + * @pgmap: Metadata for ZONE_DEVICE mappings
>    * @virtual: Virtual address in the kernel direct map.
>    * @_last_cpupid: IDs of last CPU and last process that accessed the folio.
>    * @_entire_mapcount: Do not use directly, call folio_entire_mapcount().
> @@ -337,6 +341,7 @@ struct folio {
>   	/* private: */
>   				};
>   	/* public: */
> +				struct dev_pagemap *pgmap;

Agreed, that should work.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

