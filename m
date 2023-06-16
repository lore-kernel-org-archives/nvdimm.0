Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D817D63C4
	for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 07:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686901672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oXBh3WfPI9MVT50Pe8Afg210FLgWLd3bSOuVVKJkhWo=;
	b=GGYSTifETgP3+pUjBKDfzSms1GiEoolCrPMJkh8G6UsGeN36q4mTJa8DYIm7+bEXzL+Pzo
	EFIucchrOYywiJYThzjIsPx84XLZvtdlgub7+n2cp+OAldJj1a52Ba/4DvNeVXZXcHdzT8
	sZ/9dfcd2DBBnsRdDdXrMa+H4OUNSb0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-xKEiDFYwOXiLEMBBj258IA-1; Fri, 16 Jun 2023 03:47:50 -0400
X-MC-Unique: xKEiDFYwOXiLEMBBj258IA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f81dda24d3so6451745e9.1
        for <nvdimm@lists.linux.dev>; Fri, 16 Jun 2023 00:47:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686901669; x=1689493669;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oXBh3WfPI9MVT50Pe8Afg210FLgWLd3bSOuVVKJkhWo=;
        b=PFT9232XqS3uVL7gA7QoBwkwYGc0Ye7l5Ek6oBIsrH0pPOi5Pg3j0Kds+Pj0JRHShI
         RKOM1CaVCLqmIzCrPcL+LsKSLyrUsBiGgyXBgXPsfcUuo9/hM/PdHLo4qGYwnxRbnitE
         NOdL1LvltIdwSxgdP0QdAsYi2gq/ueY6rk9BcaskG6PWWXre52Mu7mXET7OMVNkKBE01
         CriQhoJgjwyxCRVKhaHQPFyFyiVVnZ2RAo+ElIoKKIxAOcNGrB5W4rAZhuE6ZE7RCshs
         9s+EUSF6ROzq/+SZEKAvbh9EYuQFXUDzWkZr48Et6EPKgYJRIlWByJlRUwfAB/PvZegy
         d/iA==
X-Gm-Message-State: AC+VfDxVF4TFNJ2XJaIu/6iDe+zlRf8QK+yMb8jJrWjNGLk/xuz4cek+
	wQKUPXQectUP7G4sx+Catxh1PBcRKrkhiROhv2sLJh7B+9FEx8bTEDUCR4W+4CmmN+8wkM5rFju
	/cl90l/+jXuStenaP
X-Received: by 2002:a1c:4b0d:0:b0:3f7:f544:4993 with SMTP id y13-20020a1c4b0d000000b003f7f5444993mr1141180wma.20.1686901669252;
        Fri, 16 Jun 2023 00:47:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ55p+WG27rh5UmhzCo3TJhy6HQkGnC87778glLxQLQ6ZCU8vj9Eo1KqLOUz62TTGAYz/uhrHA==
X-Received: by 2002:a1c:4b0d:0:b0:3f7:f544:4993 with SMTP id y13-20020a1c4b0d000000b003f7f5444993mr1141163wma.20.1686901669008;
        Fri, 16 Jun 2023 00:47:49 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:9800:59ba:1006:9052:fb40? (p200300cbc707980059ba10069052fb40.dip0.t-ipconnect.de. [2003:cb:c707:9800:59ba:1006:9052:fb40])
        by smtp.gmail.com with ESMTPSA id f13-20020a7bcd0d000000b003f7ba52eeccsm1427266wmj.7.2023.06.16.00.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 00:47:48 -0700 (PDT)
Message-ID: <a40fe0a5-589f-0c65-ba57-9eb18cf54730@redhat.com>
Date: Fri, 16 Jun 2023 09:47:47 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 2/3] mm/memory_hotplug: Export symbol
 mhp_supports_memmap_on_memory()
To: Vishal Verma <vishal.l.verma@intel.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Dan Williams <dan.j.williams@intel.com>,
 Dave Jiang <dave.jiang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 Huang Ying <ying.huang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>
References: <20230613-vv-kmem_memmap-v1-0-f6de9c6af2c6@intel.com>
 <20230613-vv-kmem_memmap-v1-2-f6de9c6af2c6@intel.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230613-vv-kmem_memmap-v1-2-f6de9c6af2c6@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.06.23 00:00, Vishal Verma wrote:
> In preparation for the dax/kmem driver, which can be built as a module,
> to use this interface, export it with EXPORT_SYMBOL_GPL().
> 
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>   mm/memory_hotplug.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index bb3845830922..92922080d3fa 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1328,6 +1328,7 @@ bool mhp_supports_memmap_on_memory(unsigned long size, mhp_t mhp_flags)
>   		       IS_ALIGNED(remaining_size, (pageblock_nr_pages << PAGE_SHIFT));
>   	return false;
>   }
> +EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
>   
>   /*
>    * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

