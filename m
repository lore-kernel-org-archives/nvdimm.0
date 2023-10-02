Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175ABC2C0
	for <nvdimm@lists.linux.dev>; Mon,  2 Oct 2023 09:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696238934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AJJ/7KPwaOb8i7teRUVDmyTyd/EZIX0vx+LShsb9z+w=;
	b=e9ithvt72YBZRXEnvs6w8zv4M9WdSamTM+XPbYUy4vNZOoetYfo4Zx5fNvZvIJo6RoADDm
	1dpR8w+aE+RWK9kqwh4inPKeshbPZrliThySM0qtUC3nadw9Su/V9+mlG6+05VIJoqLQ1v
	QMGYGxWHC6iSTPyJ6PFNNhaDjPpLlVg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-MqHtYVvdPM-GliDpNM5r-w-1; Mon, 02 Oct 2023 05:28:48 -0400
X-MC-Unique: MqHtYVvdPM-GliDpNM5r-w-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f42bcef2acso134465255e9.2
        for <nvdimm@lists.linux.dev>; Mon, 02 Oct 2023 02:28:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696238927; x=1696843727;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AJJ/7KPwaOb8i7teRUVDmyTyd/EZIX0vx+LShsb9z+w=;
        b=wvSHBtfkaa4rphctZM3fxkXrojV0OpVq6ixyWD04PWgFsSdHDpTYWUMFV2SI7MS3Hy
         83fziXcBlRMi+E8jqSxQ9ExSJlaby9BN9pfk2cCf+DGMepKIk7STJ5Wc8ZEBWjVmCxKF
         FoqSoD6hn4aHsDxEtTSwtadiMYZc3XZnLFKeS+45KfrydyGoBL2jGctTeL5HssziqWzB
         yi+hJJkcRHBvFCN1lnUi++ooBKFbT2QM0Fp4Ieu9cd/msczeht2qDJAMkMFTL8WKetWW
         TgVaIFOT0K/yATi+xFQQgOUIGHWGHWK8fY4ZHjQirp+sE/vNqkun9besfzzzt+Rwj0C0
         9opw==
X-Gm-Message-State: AOJu0YwmXWCXtTN0AlBybQCCI/YTORDvL35bWLcYg78uTu83roEVjiqu
	E05fMzA+hAmbgdGFGyz/k1oo3ulond9vDsqYFbFbkUyj3UT0GnkjPNPOIgxtdjWxc67CRj7TjFp
	iOQ2BUg//tNbMrU/G
X-Received: by 2002:a7b:cbc8:0:b0:3ff:ca80:eda3 with SMTP id n8-20020a7bcbc8000000b003ffca80eda3mr8982368wmi.10.1696238927132;
        Mon, 02 Oct 2023 02:28:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmhn8B8uW4T+AICrNUjuxaqcAcDPKrxy0MVMZxpv82pLtYtPKE8QMU+0CJ7y3jMcfBPVswXw==
X-Received: by 2002:a7b:cbc8:0:b0:3ff:ca80:eda3 with SMTP id n8-20020a7bcbc8000000b003ffca80eda3mr8982347wmi.10.1696238926766;
        Mon, 02 Oct 2023 02:28:46 -0700 (PDT)
Received: from ?IPV6:2003:cb:c735:f200:cb49:cb8f:88fc:9446? (p200300cbc735f200cb49cb8f88fc9446.dip0.t-ipconnect.de. [2003:cb:c735:f200:cb49:cb8f:88fc:9446])
        by smtp.gmail.com with ESMTPSA id j17-20020a05600c489100b003fc16ee2864sm6835636wmp.48.2023.10.02.02.28.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 02:28:46 -0700 (PDT)
Message-ID: <efe2acfd-f22f-f856-cd2a-32374af2053a@redhat.com>
Date: Mon, 2 Oct 2023 11:28:44 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 1/2] mm/memory_hotplug: split memmap_on_memory requests
 across memblocks
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
References: <20230928-vv-kmem_memmap-v4-0-6ff73fec519a@intel.com>
 <20230928-vv-kmem_memmap-v4-1-6ff73fec519a@intel.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230928-vv-kmem_memmap-v4-1-6ff73fec519a@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


> +
> +static int __ref try_remove_memory(u64 start, u64 size)
> +{
> +	int rc, nid = NUMA_NO_NODE;
> +
> +	BUG_ON(check_hotplug_memory_range(start, size));
> +
> +	/*
> +	 * All memory blocks must be offlined before removing memory.  Check
> +	 * whether all memory blocks in question are offline and return error
> +	 * if this is not the case.
> +	 *
> +	 * While at it, determine the nid. Note that if we'd have mixed nodes,
> +	 * we'd only try to offline the last determined one -- which is good
> +	 * enough for the cases we care about.
> +	 */
> +	rc = walk_memory_blocks(start, size, &nid, check_memblock_offlined_cb);
> +	if (rc)
> +		return rc;
> +
> +	/*
> +	 * For memmap_on_memory, the altmaps could have been added on
> +	 * a per-memblock basis. Loop through the entire range if so,
> +	 * and remove each memblock and its altmap.
> +	 */
> +	if (mhp_memmap_on_memory()) {
> +		unsigned long memblock_size = memory_block_size_bytes();
> +		u64 cur_start;
> +
> +		for (cur_start = start; cur_start < start + size;
> +		     cur_start += memblock_size)
> +			__try_remove_memory(nid, cur_start, memblock_size);
> +	} else {
> +		__try_remove_memory(nid, start, size);
> +	}
> +
>   	return 0;
>   }

Why is the firmware, memblock and nid handling not kept in this outer 
function?

We really shouldn't be doing per memory block what needs to be done per 
memblock: remove_memory_block_devices() and arch_remove_memory().


-- 
Cheers,

David / dhildenb

