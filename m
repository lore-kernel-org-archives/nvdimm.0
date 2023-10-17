Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E78842C00
	for <nvdimm@lists.linux.dev>; Tue, 17 Oct 2023 14:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dn1oftD7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1697553551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bSH+w3rTE+Pz2hrnXmquLWhpkJX2eVVDKFyhnXENtfM=;
	b=dn1oftD7F2Fi1gAhndm/Pj/D6wcLrCLUOQ0H77S6Tzbtgb5UE+duqDiXw97B36kp5A3lTS
	OHrWa23oySvxxEJ+p31ilOPIQNcu29ZGk/9WexAzprUBZ30E140e5n3tAIqdC9DYvqCKUs
	rUuFNJwxKNiJHeWe1Qa2AwvDjTPOJvs=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203--cS1VnO_NbuJBxUcVMJ-1g-1; Tue, 17 Oct 2023 10:39:09 -0400
X-MC-Unique: -cS1VnO_NbuJBxUcVMJ-1g-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2c51d0f97e3so23911611fa.0
        for <nvdimm@lists.linux.dev>; Tue, 17 Oct 2023 07:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697553548; x=1698158348;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSH+w3rTE+Pz2hrnXmquLWhpkJX2eVVDKFyhnXENtfM=;
        b=bIEFNDD7Wk6/hzPrZpu6q9zMKIWUVTWF078OoCXVFAjERJaXLgFZrYLduxx2iIvpHn
         r//gA1Ots/LJGFB07HT05XwqvMaKCv5nsCfstxjF8IqhJZeZm4RkuiBCGGB9yGoI5/vv
         z7HOMJZeyindkDAKAeWENS4cRAMv/1Cf5aYjbVrrfrcT3UZmidff3JY2bMT+urQ1QAps
         2kERFO/L1JP8nPwL05zFTlZi6+jOmt+qWEXa4NFr9iF5PfLaG9mmTffTQRjT85mOcm2D
         MdSCalR/B6VuL9CBm9JN3LcpGQKFGy8lsj3U3RF1OWHyLJDLPyN3MgriAsk8+ZsF2E5p
         +UoQ==
X-Gm-Message-State: AOJu0Ywn1hbdo/9IDlL+0ZrFZEJrbBf+EkPseuQ4LT7T/z01r3z6H8Ha
	Kx5fD9z46Uk+l0a2Cu/3eAq3YYSEOTWG1+WUZ3dq9RnspfRNqU6EHbCDqr59nRoPQFLDvgEImSm
	UY06LvKs0jMsQvmT1
X-Received: by 2002:a2e:5411:0:b0:2c5:d3c:8f4d with SMTP id i17-20020a2e5411000000b002c50d3c8f4dmr1717282ljb.13.1697553548160;
        Tue, 17 Oct 2023 07:39:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeceyQoPLiG2ln4ABhwORc+ArpMpSl7lmpoS7xFx4O4tt+9zctlS/qeDjtsG4WynsxDTQVVw==
X-Received: by 2002:a2e:5411:0:b0:2c5:d3c:8f4d with SMTP id i17-20020a2e5411000000b002c50d3c8f4dmr1717260ljb.13.1697553547724;
        Tue, 17 Oct 2023 07:39:07 -0700 (PDT)
Received: from ?IPV6:2003:cb:c743:5100:93b1:f654:ad11:cd81? (p200300cbc743510093b1f654ad11cd81.dip0.t-ipconnect.de. [2003:cb:c743:5100:93b1:f654:ad11:cd81])
        by smtp.gmail.com with ESMTPSA id l4-20020a05600c4f0400b00405959469afsm2125712wmq.3.2023.10.17.07.39.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Oct 2023 07:39:07 -0700 (PDT)
Message-ID: <3f46eefa-6415-4d7a-af91-eef898d4f77a@redhat.com>
Date: Tue, 17 Oct 2023 16:39:05 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/3] mm/memory_hotplug: replace an open-coded kmemdup()
 in add_memory_resource()
To: Vishal Verma <vishal.l.verma@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Dan Williams <dan.j.williams@intel.com>,
 Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
 Michal Hocko <mhocko@suse.com>,
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
 Jeff Moyer <jmoyer@redhat.com>
References: <20231016-vv-kmem_memmap-v6-0-078f0d3c0371@intel.com>
 <20231016-vv-kmem_memmap-v6-1-078f0d3c0371@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20231016-vv-kmem_memmap-v6-1-078f0d3c0371@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.10.23 07:44, Vishal Verma wrote:
> A review of the memmap_on_memory modifications to add_memory_resource()
> revealed an instance of an open-coded kmemdup(). Replace it with
> kmemdup().
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>   mm/memory_hotplug.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index f8d3e7427e32..6be7de9efa55 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1439,11 +1439,11 @@ int __ref add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
>   	if (mhp_flags & MHP_MEMMAP_ON_MEMORY) {
>   		if (mhp_supports_memmap_on_memory(size)) {
>   			mhp_altmap.free = memory_block_memmap_on_memory_pages();
> -			params.altmap = kmalloc(sizeof(struct vmem_altmap), GFP_KERNEL);
> +			params.altmap = kmemdup(&mhp_altmap,
> +						sizeof(struct vmem_altmap),
> +						GFP_KERNEL);
>   			if (!params.altmap)
>   				goto error;
> -
> -			memcpy(params.altmap, &mhp_altmap, sizeof(mhp_altmap));
>   		}
>   		/* fallback to not using altmap  */
>   	}
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

