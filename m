Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA1629B77B
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 16:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749744066; cv=none; b=bxNCuRLZGoukjI4MlN4GkcGTVAYHd07klQP7qZt96iGvA1PRt6VpMNuiCJzz4ZUjhqHjES9D9+GAXMfCgyqnsb/wRGCMJh/gXshf94z7+HGzvplorTZDbs3xb7yQwpTCxNcYDKl9zolK0o93tHaxZNJcPdZLpZrCwWrlzLvo66U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749744066; c=relaxed/simple;
	bh=jIQiFi0PX4dZQUf66u/K4k+1NatEWdckgH+Lm1D15eY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sY9sQdtiekJzAnKPC5lzfyKRqTfDY4gyOLGjB06jI1C+QF20QCdCmuDHhpoI7h7TDJ8VKdCORanATIGZLu2fvjKzdJplR8M3WzOg3jBgN9kQ5oW4BwBgxFR/Sl+O4NrthQb39M/aOZjx+W6ZV/fGcxZKFf3A4cIXd95zUOm17dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AR77BKyz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AR77BKyz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749744062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1+3oax1J1i7ak04ZkCE12qfZ9Apo/D3V00Ng4YzGTGw=;
	b=AR77BKyzTbtFTJvJ3aeIQ1YlFjOoCrgB+gzNvMktwetPa99WKAPpuxuaso5V+2IvJdnN8J
	CXBVZlCI6pE5SAZfScsSqfSqep4xQRqDiFcXE+LL9BFDzPhECR676k09h3n5wG1oTC3VyH
	BWQmrwReLax8fMHkl5OTYHqgQUF7Noc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-iE3qEZm5NGeoH4_2drCYDw-1; Thu, 12 Jun 2025 12:01:01 -0400
X-MC-Unique: iE3qEZm5NGeoH4_2drCYDw-1
X-Mimecast-MFC-AGG-ID: iE3qEZm5NGeoH4_2drCYDw_1749744060
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-453018b4ddeso5807905e9.3
        for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 09:01:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749744060; x=1750348860;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1+3oax1J1i7ak04ZkCE12qfZ9Apo/D3V00Ng4YzGTGw=;
        b=RBrYDXluLSvQBnv2A+Yjb6lXE0jjcti+namFy1A3iqtrXal2xfTAJBObzVO4onYOcZ
         lw+H5L04fZ6+w2w4DfirR1Qad8+ZhqilwzNz+UyCtwbz/hmr7N8ZGaxi6C8zDqKsBVvV
         /YOBNBlkWfHEhOiWM1mWdoecPpi0x5AAts7KP9CSjId3QS2lNgc1UjbpZruhToi6/Lba
         MN7J/UD+nH8GBhoUBABYSRRFHYzU77txIk8Lt0p9dpneRQY8IR/yDQglWy7Wbco+M3md
         fXxElavdPjaCXWdoH+g29E8K1m/kj9X9FZKuKKbLynvUHG2s0M+OIZE4Stph5dY2Ja4G
         xbxg==
X-Forwarded-Encrypted: i=1; AJvYcCXL6ESQsvpJrg0Oqt/J4rh+Ou913OnWRBBnrTVkf97Rm3Uw2l1JtMeOSp66Rw0W3daUzt2B1us=@lists.linux.dev
X-Gm-Message-State: AOJu0YyY6Htt0P74rkU43V6IfnJUqfgvUbedEeUIgU4n64b8VgW3QsfJ
	L2hdbpdeIAv7oWcvZ50afEqbbNMW6hYFGNKcFfHaFpDE1S1eEVWxeluu3R7KOsxP4v8PG8/cu4z
	3UAuqziwGZmIXLSRo0Z2BrJOvaIkuklkZ49JwzSJCIdMMxaBVN9/hGvrY6g==
X-Gm-Gg: ASbGnctZ7ND55jNUFExy9tgAah+6oQG7gkSnPMxAtssAjq42WlHDA0tdV3ghE9CnJ29
	brTP+vdbpD2wQBlPOmKzNndvamxinCv6hMZJ7BGfDhnk8MXdj3us76GR4yLe3peyMiS/9SKCklY
	M430c2Mr44bZXVKfSgirs20Zz//BcNqnTtPJI3NslHdr5DMtnMC7ZwdXKKCViqq4xr67aoN5DEe
	kTF52+Z/oPNo7c0s6MItSPDWrIY18xJ+D614gEZzxt/MdcRGByjBZgD/c9xEh8ve+G09j2cNZCD
	8aDklia2tjcjQT290ZMDYp3LL/kVSVLY3djZ+JKVHY2bPpgDpGXuaNMG2hfHQz3EskHWsnaOccT
	sn+9wx9HqzNuBq74/ScNczht24JMDtDNTYP1JE88aXAKYRZBcVQ==
X-Received: by 2002:a05:600c:154c:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-453248b0ee1mr89059895e9.10.1749744059142;
        Thu, 12 Jun 2025 09:00:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0KtUKkeA/MUPEemOjB1IBDhV6fF8nnUrAFkhywiGcZIhXOz4QfMznW4XH/6cl0sFuqudtsg==
X-Received: by 2002:a05:600c:154c:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-453248b0ee1mr89057685e9.10.1749744057159;
        Thu, 12 Jun 2025 09:00:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2c:1e00:1e1e:7a32:e798:6457? (p200300d82f2c1e001e1e7a32e7986457.dip0.t-ipconnect.de. [2003:d8:2f2c:1e00:1e1e:7a32:e798:6457])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e24420csm24149245e9.20.2025.06.12.09.00.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 09:00:56 -0700 (PDT)
Message-ID: <e7d36cdc-9d12-4cd3-9480-d84422f9665e@redhat.com>
Date: Thu, 12 Jun 2025 18:00:54 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/huge_memory: don't ignore queried cachemode in
 vmf_insert_pfn_pud()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Dan Williams <dan.j.williams@intel.com>,
 Oscar Salvador <osalvador@suse.de>, stable@vger.kernel.org
References: <20250611120654.545963-1-david@redhat.com>
 <20250611120654.545963-2-david@redhat.com>
 <02d6a55b-52fd-4dae-ba7a-1cccf72386aa@lucifer.local>
 <c6c1924b-54ae-4d75-95f7-30d3e428e3e7@redhat.com>
 <dfab0736-4a62-4e2f-889e-3d6fdb4564be@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <dfab0736-4a62-4e2f-889e-3d6fdb4564be@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HeitsSn2Tq6pwX-y_K8kx_6vxspoFzjGLEGdpHyxcWU_1749744060
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12.06.25 17:59, Lorenzo Stoakes wrote:
> On Thu, Jun 12, 2025 at 05:36:35PM +0200, David Hildenbrand wrote:
>> On 12.06.25 17:28, Lorenzo Stoakes wrote:
>>> On Wed, Jun 11, 2025 at 02:06:52PM +0200, David Hildenbrand wrote:
>>>> We setup the cache mode but ... don't forward the updated pgprot to
>>>> insert_pfn_pud().
>>>>
>>>> Only a problem on x86-64 PAT when mapping PFNs using PUDs that
>>>> require a special cachemode.
>>>>
>>>> Fix it by using the proper pgprot where the cachemode was setup.
>>>>
>>>> Identified by code inspection.
>>>>
>>>> Fixes: 7b806d229ef1 ("mm: remove vmf_insert_pfn_xxx_prot() for huge page-table entries")
> 
> Ha! I don't even remember doing that patch... hm did I introduce this -ignoring
> cache- thing? Sorry! :P

:)

> 
>>>> Cc: <stable@vger.kernel.org>
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>
>>> Nice catch!
>>>
>>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>
>> Thanks! What's your opinion on stable? Really hard to judge the impact ...
> 
> I think it makes sense? This is currently incorrect so let's do the right thing
> and backport.
> 
> I think as per Dan it's probably difficult to picture this causing a problem,
> but on principle I think this is correct, and I don't see any harm in
> backporting?

Same opinion, thanks!

-- 
Cheers,

David / dhildenb

