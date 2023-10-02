Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C45A468B
	for <nvdimm@lists.linux.dev>; Mon,  2 Oct 2023 09:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696238510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9SMs8mHNoKs8/KwUwp2IfY8WHFPaduo12w1Xi37QfxA=;
	b=F7mBxVAFQGRBo/Izhsf9Xz1z5AUd4No666aFLrWvRdet+Ngp0xqqJDRRsxi3Afdrcwkg1t
	QclE8DdcUMaK0F+635o8L85wD3zGopy2TNgd8gnsegIZW9o+R0CMlKK+YkODfwblI73da3
	7Q1HWtAz01PJmslA8M6GcMVJO7ifp9g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-Jv1AaCvEPWWkJ6HJ0GrDSQ-1; Mon, 02 Oct 2023 05:21:49 -0400
X-MC-Unique: Jv1AaCvEPWWkJ6HJ0GrDSQ-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4059475c174so106717085e9.0
        for <nvdimm@lists.linux.dev>; Mon, 02 Oct 2023 02:21:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696238508; x=1696843308;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9SMs8mHNoKs8/KwUwp2IfY8WHFPaduo12w1Xi37QfxA=;
        b=BV5CECcAB/CDoc1ZTX4FG4+au9xANPeY9cwuJpxgwzvVA5gKqsPK1f2O/kYCF61rfz
         YLWu9C4Zhx/7Q3LnyfRUFMz/BY7T8ibJOQzLStC4GeX01VJGwiC0y7lGk/kkr8UAS8+a
         6jqLIXXvLPkzQ093CMw5VeXdzfllvslrQ+RmUgiSuH45FRF4q6QF0VV6RMnz+y+Bo2dT
         hoeKiGQoWB1YbSPOlCXBP6yUInzLrtAwXHGp/88VTPv3XWuJyHCayHk0CVzk10eExus4
         EyzqkRSRv9hBjm7+psGCRkvAM+qArtL1n02GBvzB1yYSbD2Ud1RteLtLkuv8HaJJMM7q
         RHbA==
X-Gm-Message-State: AOJu0YyAt98b13l4asMcpM4Ile9cJUfx5zLlS5RPyAhNHIbEaFXPJUMz
	AISrLYJlvtCUBiyE94xhMjfuYz3cWyiZ0dm9hPV2ADm4JkyY1fNa3DAngF7EEF4j6jyoZupyIYW
	YjtH8TDMf1aswaugC
X-Received: by 2002:a1c:f215:0:b0:401:8225:14ee with SMTP id s21-20020a1cf215000000b00401822514eemr9384952wmc.41.1696238508091;
        Mon, 02 Oct 2023 02:21:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGpoIYDU+1jiVcXrF63R4snLKaA9DHdUaPschGkCCIHkpc4jwwbfh1yuXRNn7DbT9sCTvXBqw==
X-Received: by 2002:a1c:f215:0:b0:401:8225:14ee with SMTP id s21-20020a1cf215000000b00401822514eemr9384934wmc.41.1696238507655;
        Mon, 02 Oct 2023 02:21:47 -0700 (PDT)
Received: from ?IPV6:2003:cb:c735:f200:cb49:cb8f:88fc:9446? (p200300cbc735f200cb49cb8f88fc9446.dip0.t-ipconnect.de. [2003:cb:c735:f200:cb49:cb8f:88fc:9446])
        by smtp.gmail.com with ESMTPSA id p8-20020a7bcc88000000b003fbe4cecc3bsm6791845wma.16.2023.10.02.02.21.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Oct 2023 02:21:47 -0700 (PDT)
Message-ID: <0b6f739b-723a-bc53-03a3-f4a793f339b4@redhat.com>
Date: Mon, 2 Oct 2023 11:21:46 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 2/2] dax/kmem: allow kmem to add memory with
 memmap_on_memory
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
 <20230928-vv-kmem_memmap-v4-2-6ff73fec519a@intel.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230928-vv-kmem_memmap-v4-2-6ff73fec519a@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 28.09.23 22:30, Vishal Verma wrote:
> Large amounts of memory managed by the kmem driver may come in via CXL,
> and it is often desirable to have the memmap for this memory on the new
> memory itself.
> 
> Enroll kmem-managed memory for memmap_on_memory semantics if the dax
> region originates via CXL. For non-CXL dax regions, retain the existing
> default behavior of hot adding without memmap_on_memory semantics.
> 
> Add a sysfs override under the dax device to control this behavior and
> override either default.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

