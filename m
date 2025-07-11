Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930671DE3C8
	for <nvdimm@lists.linux.dev>; Fri, 11 Jul 2025 18:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752260262; cv=none; b=DJmYaL/WTgtsEVO3OdWAtmfa28ZTZEfIAo6V4gZClMjy/1vLre57ULnEuGMI1iXZufK6CGs969IsK4TguCR7Tz5bFTtvvbdBtf439QV8RxLv4G74K63iChXaq2GxfwJmcni1fbMTJNrTYfJf4ZSZpKjZWIEQwBRNP53ZX29aN0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752260262; c=relaxed/simple;
	bh=R4KOVvt/FCWP6gRCC0GZxjeyZOsKBBBECyJoWTZIt5U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eJCTyYRxJwS1+hRvN4Z3UD+Vg8fhgeA6tnqPk2mI8u3lWr+MoEw2oJRJ00pMInfR+PqDZW3egZLE42ZBJffNxNU7ZA9qND9KgKTJr3xYO2ygYb5GTtL5SOX6t5udbblKjlrhrvCuDLISYAF/+2YNaXyzqE2E/PpJQFY76mG1RH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gALLjl2/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gALLjl2/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752260259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VbL3LlciXrx5usUof/F7sG/X7kZUjQJ0y4avrgolLvM=;
	b=gALLjl2/69KpLdydwNZte7ubVKX4YlwqVCF5pnfGIuhp0/Gm0rQKwtkkeFMca7aC8yNq8J
	TLRhLh9FLJCFfqRW0G+XFg4xUaMJWB6aA7ZnzsT77BIeeQeVL3a3tZusx19PesaXl9/Oio
	wu/YOZ6Uj5kFf7SviP40KSzz/y4POls=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-WbxgShPRM-WNqJob63q-Hg-1; Fri, 11 Jul 2025 14:57:38 -0400
X-MC-Unique: WbxgShPRM-WNqJob63q-Hg-1
X-Mimecast-MFC-AGG-ID: WbxgShPRM-WNqJob63q-Hg_1752260257
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b20f50da27so1663383f8f.0
        for <nvdimm@lists.linux.dev>; Fri, 11 Jul 2025 11:57:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752260257; x=1752865057;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VbL3LlciXrx5usUof/F7sG/X7kZUjQJ0y4avrgolLvM=;
        b=g09vDWjzPuEKyGrzM1IFNS2TqSRnObm9wXQOQGpO0R6WrsIy/2AX2p2tK9PZt9CXSq
         v5vu0iIXT7KHkZV9VId3XaYHTG7T+4DpLvC9/INFVYPHf1It9HL0e4So9HiTcox9h1Jv
         LnscIqUiysUKoAmArvetzYdVQ8YdqoAjMxz5yJIh40Nj05BF39PSjsAPjYt73fy1ilbn
         69kFiZ0oCLvliDpYHFKKLYOwFliiJ3IE2v/8keMxUKF9uKRxHQvLdSj5lWK/VoNnVXvU
         dfAIrz50pBMMe65ShK/PtGzaUSOBMX90+1mGLM98Hfow6vTNJ9Uckre1SrszOyI3GahW
         N7Yw==
X-Forwarded-Encrypted: i=1; AJvYcCXEEzbxp7y+mhSLt3INJmwuBgkj7yDEkiaD3iTgaBBVxWVM0pIiDarEc4wDuzCJysDqMwHgljQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzoc1IxMXvbHxkvE5KePIokuKBERtPK07HbhnFubelDVrlnc9Cr
	vgCey121BULc8acondEhLfde8r/jKPy6eNZVpYAMieSwdxmFSiJmasaUs4QTdk6fNSZtVAt7b5N
	NyuyQ6CHIiEt9Vr/s4ps8pl8sz3VISj8RaQDTq2O8Hg9SwZduNCXVlISyNw==
X-Gm-Gg: ASbGnctrn+1ICWJ8lN+thFB2DM1k2LI7C2KL9XL1VR8G1OXyBdbNEG8VfRytrz6MGhM
	sX3yUGM6BzVmDeswCe7/SvEZNAaI4D2HuucReL0XP03aLsm4UML5DLQrxAxMh0huSryRKJhYKwg
	w9B8P9XanOz8TWYw8gIZTI1MdFauZ+NNK7LuU1xm5EdxdX4dxTp50VNjrrYj4qCnpsNb7wRaK7y
	ODOROqS9/9+23bxiLETIjAVIyE8DZne9o3sjryUhTYFYasaFJ0JKKGy7M8L+GlGf6vuyGiYA75k
	Fuqn23bxwqVrUeRFx2+vCbGAD1N7hrASLtCm+RyGR18k3p3aV7B1yhTVJlLLKE+80Py5tSJr2s9
	y0TQbtCWhSzW9uWzGWakHN5E9xdHWQ9uoNWi+1wNzgsbGKkccdBfvF9qbaoST+ClKsdQ=
X-Received: by 2002:a05:6000:2c0f:b0:3a5:3993:3427 with SMTP id ffacd0b85a97d-3b5f1e95fb8mr4724521f8f.26.1752260257154;
        Fri, 11 Jul 2025 11:57:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHGwKEUQLbh/zY6545eP9xFg7a7s2kPU1xUA4JG52ouaTweDCumvMrk6zcF1Opz8ywnEmQoVg==
X-Received: by 2002:a05:6000:2c0f:b0:3a5:3993:3427 with SMTP id ffacd0b85a97d-3b5f1e95fb8mr4724490f8f.26.1752260256647;
        Fri, 11 Jul 2025 11:57:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0a:2e00:89cb:c7f0:82f2:e43c? (p200300d82f0a2e0089cbc7f082f2e43c.dip0.t-ipconnect.de. [2003:d8:2f0a:2e00:89cb:c7f0:82f2:e43c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e1e8b1sm5171588f8f.82.2025.07.11.11.57.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jul 2025 11:57:35 -0700 (PDT)
Message-ID: <aad59217-0763-473e-bdc8-d0d47bec35bf@redhat.com>
Date: Fri, 11 Jul 2025 20:57:33 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 01/14] mm/memory: drop highest_memmap_pfn sanity check
 in vm_normal_page()
To: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, nvdimm@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Dan Williams <dan.j.williams@intel.com>, Alistair Popple
 <apopple@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Lance Yang <ioworker0@gmail.com>
References: <20250617154345.2494405-1-david@redhat.com>
 <20250617154345.2494405-2-david@redhat.com>
 <aFVZCvOpIpBGAf9w@localhost.localdomain>
 <c88c29d2-d887-4c5a-8b4e-0cf30e71d596@redhat.com>
 <CABzRoyZtxBgJUZK4p0V1sPAqbNr=6S-aE1S68u8tKo=cZ2ELSw@mail.gmail.com>
 <5e5e8d79-61b1-465d-ab5a-4fa82d401215@redhat.com>
 <aa977869-f93f-4c2b-a189-f90e2d3bc7da@linux.dev>
 <b6d79033-b887-4ce7-b8f2-564cad7ec535@redhat.com>
 <b0984e6e-eabd-ed71-63c3-4c4d362553e8@google.com>
 <36dd6b12-f683-48a2-8b9c-c8cd0949dfdc@redhat.com>
 <0b1cb496-4e50-252e-5bcf-74a89a78a8c0@google.com>
 <056787ba-eed1-4517-89cd-20c7cc9935dc@redhat.com>
 <5e439af4-6281-43b2-cbd2-616f5d115fdf@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <5e439af4-6281-43b2-cbd2-616f5d115fdf@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8srzB2t3veR5TMkXoxFpv_DiPyCy6DdMJ-pPRWoQEs0_1752260257
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.07.25 20:49, Hugh Dickins wrote:
> On Fri, 11 Jul 2025, David Hildenbrand wrote:
>> On 08.07.25 04:52, Hugh Dickins wrote:
>>>
>>> Of course it's limited in what it can catch (and won't even get called
>>> if the present bit was not set - a more complete patch might unify with
>>> those various "Bad swap" messages). Of course. But it's still useful for
>>> stopping pfn_to_page() veering off the end of the memmap[] (in some
>>> configs).
>>
>> Right, probably in the configs we both don't care that much about nowadays :)
> 
> I thought it was the other way round: it's useful for stopping
> pfn_to_page() veering off the end of the memmap[] if it's a memory model
> where pfn_to_page() is a simple linear conversion.
> 
> As with SPARSEMEM_VMEMMAP, which I thought was the favourite nowadays.

Yes, you're right, I had the !SPARSEMEM model in mind, but obviously, 
the same applies for the SPARSEMEM_VMEMMAP case as well.

Only the SPARSEMEM && !SPARSEMEM_VMEMMAP model is weird. IIRC, it will 
dereference NULL when given a non-existant PFN. (__nr_to_section 
returning NULL and pfn_to_section_nr() not beeing happy about that)

-- 
Cheers,

David / dhildenb

