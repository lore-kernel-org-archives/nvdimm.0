Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2E721D5D
	for <nvdimm@lists.linux.dev>; Tue, 25 Jul 2023 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690300462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LoAQxhzmL5AVllS8wiqRHiXap/Dk/xuzfK4mG1WLfl0=;
	b=CsrEGT2iWGXo0uNZqHwKWZrrRLtT31v7kwf6yQRv6Y26WlpoTZWhv6KKzHRy2Wv9N1naGS
	kp0eczGEpvZ/mDkJ2YIDwmF9+ZnHMWlM1oxRqRn4FXUdRNR71Ncz7kHGet4tjgMDcxcVT7
	oi8Swd1FdJiJdk3dtUn4nI5O36N4hNs=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-aNgfkTThOau6ZEFmA2RfJQ-1; Tue, 25 Jul 2023 11:54:21 -0400
X-MC-Unique: aNgfkTThOau6ZEFmA2RfJQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4fb774de2d4so4990780e87.1
        for <nvdimm@lists.linux.dev>; Tue, 25 Jul 2023 08:54:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690300460; x=1690905260;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LoAQxhzmL5AVllS8wiqRHiXap/Dk/xuzfK4mG1WLfl0=;
        b=UE3MxLjddlBi3KTkU2XHbvzxExQehGaHNFjBchEMtBdC2Ceyry6JJ3K3pfcaqF3DVf
         pUa/euyePBtlFsI4ToK1BiIbkSNerEKilO/BFQUZYb5kpJC/yxqlnE7QEugcnraTBGQb
         BOyt00520w6ZQBt3gAdU0j2hbTceQOeNhxf21JsNxTw6L0/yGyPqjoaU3+QK0lsrxvj0
         QfzNe5vc6DVPCkS6gJPj94SIOgfjAJfCHYN1GHk3Bc/xBzQCECKUmhnHpgtOx+tN3UWg
         COchBcRQkTNLAvXREWu7iB4QiwsaOlz+sE+eis+c8cEuYNpzTGB2ZVfxiuAvFFzk/QaX
         JYUg==
X-Gm-Message-State: ABy/qLZgRfEUQ6G8Q0qpAoU/AZ/qtsFDo27qvcoku/CMPjBTJ9GeSHDb
	YIGMoFh4jCyVHZKctXy7vuq4x5kF2HxkIrp8puumjgGZcJ68BBdrZSjP14GWSDfBUU8Cy5U6sPy
	zJ9ohn8soUc6+nuut
X-Received: by 2002:a05:6512:39ca:b0:4fb:8b78:4a93 with SMTP id k10-20020a05651239ca00b004fb8b784a93mr8787204lfu.7.1690300459907;
        Tue, 25 Jul 2023 08:54:19 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEmywcP+QkHkkim2d5HtgePDiVNCjDAFUns2tMfnkaP9vtk0/KS0KMhtX1iT9iXaInLa2ug6Q==
X-Received: by 2002:a05:6512:39ca:b0:4fb:8b78:4a93 with SMTP id k10-20020a05651239ca00b004fb8b784a93mr8787187lfu.7.1690300459532;
        Tue, 25 Jul 2023 08:54:19 -0700 (PDT)
Received: from ?IPV6:2003:cb:c73f:e900:3b0d:87a6:2953:20d1? (p200300cbc73fe9003b0d87a6295320d1.dip0.t-ipconnect.de. [2003:cb:c73f:e900:3b0d:87a6:2953:20d1])
        by smtp.gmail.com with ESMTPSA id x17-20020adfffd1000000b003141f3843e6sm16751602wrs.90.2023.07.25.08.54.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jul 2023 08:54:19 -0700 (PDT)
Message-ID: <1c3f737e-f5c6-b974-3b36-c4a3ada14422@redhat.com>
Date: Tue, 25 Jul 2023 17:54:17 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 0/3] mm: use memmap_on_memory semantics for dax/kmem
To: Vishal Verma <vishal.l.verma@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Dan Williams <dan.j.williams@intel.com>,
 Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
 Jeff Moyer <jmoyer@redhat.com>
References: <20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230720-vv-kmem_memmap-v2-0-88bdaab34993@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20.07.23 09:14, Vishal Verma wrote:
> The dax/kmem driver can potentially hot-add large amounts of memory
> originating from CXL memory expanders, or NVDIMMs, or other 'device
> memories'. There is a chance there isn't enough regular system memory
> available to fit the memmap for this new memory. It's therefore
> desirable, if all other conditions are met, for the kmem managed memory
> to place its memmap on the newly added memory itself.
> 
> The main hurdle for accomplishing this for kmem is that memmap_on_memory
> can only be done if the memory being added is equal to the size of one
> memblock. To overcome this,allow the hotplug code to split an add_memory()
> request into memblock-sized chunks, and try_remove_memory() to also
> expect and handle such a scenario.
> 
> Patch 1 exports mhp_supports_memmap_on_memory() so it can be used by the
> kmem driver.
> 
> Patch 2 teaches the memory_hotplug code to allow for splitting
> add_memory() and remove_memory() requests over memblock sized chunks.
> 
> Patch 3 adds a sysfs control for the kmem driver that would
> allow an opt-out of using memmap_on_memory for the memory being added.
> 

It might be reasonable to rebase this on Aneesh's work. For example, 
patch #1 might not be required anymore.

-- 
Cheers,

David / dhildenb

