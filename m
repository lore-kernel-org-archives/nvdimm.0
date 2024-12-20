Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A202921E0A6
	for <nvdimm@lists.linux.dev>; Fri, 20 Dec 2024 18:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734719473; cv=none; b=A7j9yizlVX/GvonGep0SBcfGhJhRmSTgyM/P7NNxzn0Bh2TihkMsQnavDDDLfTccFCZizSMWppq/E8cCBNLEwfGWqEk/ugH50fY95NbGcmm1ZW1iQ0NhEqQW5EVzjEzrFo4cg8qRTdK4setR2rktAymTHj3p1G5GuD4Bs63BGu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734719473; c=relaxed/simple;
	bh=5zqe6KTdOvbJhjCS4/7P40LvEhqzzNyD4usnj91BBp8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ke4aNWUJ+K8J/UKxykcnCyHV3/2Cairlk0p7Ad41Trtevvg0ZGFqZu5An3DMn33zuj/dQix1Lqbi/HG4mYuJvwHxDVpDDBUtTZVToyWEfGs9LqE8DSuHTisSGXUJkxffch/Qy/lVSeoWn2Ih7VSUo00WsmQawz8cQW7M08TTSkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G9XfWqV1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G9XfWqV1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734719470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PN5EVM1NmukZNXj0qpicok/RL7e9UE7DI/QNZtLqqyY=;
	b=G9XfWqV1vKWfWn2FsnDROvwyYNqHWTn/0ZSAGxBMkhrQZC8Gtdfp4sJycozuVve9OWK0A0
	42eP+T5pPxBfq7lFOxkrudwlShoTF9uRcx+fHE7nFxD+uu7z1XImZduE7220IOproXhZGY
	W+5XgYCrzHOIAX4pRPSrVZChKG/f328=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-JbPnjli7N1GoHXhOWGQJnQ-1; Fri, 20 Dec 2024 13:31:07 -0500
X-MC-Unique: JbPnjli7N1GoHXhOWGQJnQ-1
X-Mimecast-MFC-AGG-ID: JbPnjli7N1GoHXhOWGQJnQ
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385df115288so1153420f8f.2
        for <nvdimm@lists.linux.dev>; Fri, 20 Dec 2024 10:31:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734719466; x=1735324266;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PN5EVM1NmukZNXj0qpicok/RL7e9UE7DI/QNZtLqqyY=;
        b=mdGuRM+o1S+ZO5UVlr83QGMVg32uCwBMjNanK/UVsXL8OlAoy2g6Tz9zDiwmPYUDC0
         H6vm+cZFsYGuqHF+G/7erPPjlJ5ETYSIEF7QemSSe90e50qBQc/JL0YM2K4uBHFCOt94
         3fIL0wX0kW/Q5Uf/6NYdZ6fqc7xxiJ+36PKOra5Bgi8rL9S5jJzGUZB69K/60JHncuqH
         8P8eD/5Hx83DLTLicd+OstA+FD5ulgdZEX47aTJSGizojwLVXfYRKezdtA3WZXVMZ/b1
         lvdMFFUXzaqYzWgi5ERCCp1OhNUmNoACWKCMovIIB+QFwLA4T+Jt7P8ZVBuOdfk17bUE
         ekCg==
X-Forwarded-Encrypted: i=1; AJvYcCVKLSOr7PZUnRGy2hw2nrpHIoDNoSB78aAzfT+dVRcaTTTyFZWg/KRM3j6RBpFBtN6e4qiyllQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzl9Hcy7YbuvWMcARa36OV18+gsCa/QegSJxRl4CzyY2DPoud7N
	E6RbdNdg9q7353Cq6E4YNUI/qYk3gDf9IgMFqs3ML4I9+oSQFHUVNuv4X1JQO0utagRnTz3OeJO
	7lXWTOMNUDZCP9rysWdLWc0fZ4u0utNL+M5rLn7m0HbnfzjiFa+6OqA==
X-Gm-Gg: ASbGncsqv7+7k74HH7v2HUlTOSw4ZSYmUoK1f8pSjP1+QcDVdNPhJNces1j5uBp59PQ
	PqPFaNQVbaZ1nlY52MnqmSV8twP0A8Uq1okL9CJRNS2kDTOxWBfQKVj5kquD7G+PfRJYYOpfB1X
	D6M7PbQRUCI1tqBLnqKi2sWHFTnUU+HfUo4owicZpuNXE6dI6jguwQTYTNL8J3tcbtqo6fu9oWm
	PmVc3Kqr6N8QVGDfCej0Mi9n9yAcJBgxjLM1ddLYod1u8twLMU+UnuEK0XOfWHD9rwcYmPk58dK
	nf7D0w3TgFZ4kbyLmexW/I8Zf1+VttpDuolKjxsQa9+2ngD4EpXJFf3sGramtOkaO3Gloh3Z6Tw
	FZDPIBgj5
X-Received: by 2002:a5d:64c2:0:b0:386:366d:5d0b with SMTP id ffacd0b85a97d-38a22408e8amr3824135f8f.55.1734719466301;
        Fri, 20 Dec 2024 10:31:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IElxiFyJ9qIUioQdUCoDL6NC0K4joEuaDrLW1M/n6klr2NWFr2HJs9ZJNS8OQoynugK8eIYkQ==
X-Received: by 2002:a5d:64c2:0:b0:386:366d:5d0b with SMTP id ffacd0b85a97d-38a22408e8amr3824083f8f.55.1734719465905;
        Fri, 20 Dec 2024 10:31:05 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:9d00:edd9:835b:4bfb:2ce3? (p200300cbc7089d00edd9835b4bfb2ce3.dip0.t-ipconnect.de. [2003:cb:c708:9d00:edd9:835b:4bfb:2ce3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c829348sm4641303f8f.22.2024.12.20.10.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2024 10:31:05 -0800 (PST)
Message-ID: <107dacce-87dc-457b-a2e1-e5a4699d66af@redhat.com>
Date: Fri, 20 Dec 2024 19:31:03 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/25] rmap: Add support for PUD sized mappings to rmap
To: Alistair Popple <apopple@nvidia.com>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, linux-mm@kvack.org,
 lina@asahilina.net, zhang.lyra@gmail.com, gerald.schaefer@linux.ibm.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, logang@deltatee.com,
 bhelgaas@google.com, jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com,
 will@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
 dave.hansen@linux.intel.com, ira.weiny@intel.com, willy@infradead.org,
 djwong@kernel.org, tytso@mit.edu, linmiaohe@huawei.com, peterx@redhat.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 david@fromorbit.com
References: <cover.18cbcff3638c6aacc051c44533ebc6c002bf2bd9.1734407924.git-series.apopple@nvidia.com>
 <7f739c9e9f0a25cafb76a482e31e632c8f72102e.1734407924.git-series.apopple@nvidia.com>
 <4b5768b7-96e0-4864-9dbe-88fd1f0e87b8@redhat.com>
 <volhyxjxlbsflldgs36ghzartel2tu625ubz3kfed2gdwrsamt@cpfsfhdpc4rp>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <volhyxjxlbsflldgs36ghzartel2tu625ubz3kfed2gdwrsamt@cpfsfhdpc4rp>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i1VJitUEfCgzijHyFt81WzoUg8P_yMz8j2V72OhUOF8_1734719466
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>>>    				return -EBUSY;
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index c6c4d4e..39d0439 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -1203,6 +1203,11 @@ static __always_inline unsigned int __folio_add_rmap(struct folio *folio,
>>>    		}
>>>    		atomic_inc(&folio->_large_mapcount);
>>>    		break;
>>> +	case RMAP_LEVEL_PUD:
>>> +		/* We only support entire mappings of PUD sized folios in rmap */
>>> +		atomic_inc(&folio->_entire_mapcount);
>>> +		atomic_inc(&folio->_large_mapcount);
>>> +		break;
>>
>>
>> This way you don't account the pages at all as mapped, whereby PTE-mapping it
>> would? And IIRC, these PUD-sized pages can be either mapped using PTEs or
>> using a single PUD.
> 
> Oh good point. I was thinking that because we don't account PUD mappings today
> that it would be fine to ignore them. But of course this series means we start
> accounting them if mapped with PTEs so agree we should be consistent.
>   
>> I suspect what you want is to
> 
> Yes, I think so. Thanks for the hint. I will be out over the Christmas break but
> will do a respin to incorporate this before then.

I'll be on PTO starting ... well now. But I'll try to give the other 
parts a quick peek if anything urgent jumps at me. (bad habit of reading 
mails while on PTO ...)

In any case, happy holidays to you!

-- 
Cheers,

David / dhildenb

