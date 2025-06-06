Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453361EF39F
	for <nvdimm@lists.linux.dev>; Fri,  6 Jun 2025 18:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749235282; cv=none; b=FdNI2adFwt9Oi1JcNXabK22TJ5Zp20Q1eHn1+7QMyyhDapE1AJcpJt2q+U1ipEPt56fWWxt99kOYfKPoRX3exi/wpFBRhN0mYrAsoA8LYGWKRXznMQcPmz6KOBoQWfYWGbqgAgNgqaMFSku8BoYu2gwtateqXm3DdgKcQt+U24w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749235282; c=relaxed/simple;
	bh=VwcS2Z8io2o0cY3xmV6ZCIZl/itPdgGtnMt2d7h2C7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E8lbjDYyoXL7fuNz5jFi+yRJxT3ep5PbwKE1O32CVojtuqmksHF8Ot50h5PbUU+8n8JfcX9bpvNDc6JMhVn6NyAaguwIGgT1v6YetI4UTvHlE4s4BcOamqU5IeSQYw2wv6ewDizrx3oggHsQG8qMZ5OcCYMI2dlm7g2FdXXCOQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fi+dJnM6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fi+dJnM6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749235280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tkX4uYhgyu0xrtO7ADEiny3gzIp95LCIRO3lMgtzOQs=;
	b=fi+dJnM65BHYHHGuC9+JO4bDPeZq3KetkZ+hjVd7GqFD6+aqaUHTpLZPX6Dj1I6dsMmBdg
	qsmXTwLLM5yO9OItBPtU70YBj/c44lqFsD3ej1uD/nJPqNClcV33srRN7hlJ86lYAudRYH
	efsByrir/i20EAuegyk85ABRFojNojo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-HZsVJl16Pyq0xZZlJg5IEA-1; Fri, 06 Jun 2025 14:41:18 -0400
X-MC-Unique: HZsVJl16Pyq0xZZlJg5IEA-1
X-Mimecast-MFC-AGG-ID: HZsVJl16Pyq0xZZlJg5IEA_1749235278
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a50816ccc6so1640975f8f.1
        for <nvdimm@lists.linux.dev>; Fri, 06 Jun 2025 11:41:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749235277; x=1749840077;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tkX4uYhgyu0xrtO7ADEiny3gzIp95LCIRO3lMgtzOQs=;
        b=moShYZKIDKKipknNrrsAEsYVV2EpMZnRIztLgkMp0d/jrvJSht7K3yR7BIRPcTTbwo
         oHACj2zYQj6dcNP/pcJB+Oevb+P06oFFgWx77L0dSF2ihGe3PKjN9DHMqnV5zWKmxXZX
         pvmbVfjTGuWVRFsT5sOCZv4wu7pyG7F1NDfgN7p+c5dHaC0jdlzT39bVljzfMb/HlJFx
         tqRithyKVoy2vv8da3ecNK1nBaMZM62EGmtRfAxo3iGvItb9+PT23zII92R90lNfDpjc
         ecwycCdMhhzF3lPZpi2iSaCGLOKDK+u0v423YSVQ6ZGeotFHy7wonHfPGgndjRB9mO1V
         39PQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQd4H9oiplppRdUhsL3C/KOmBekvdr9k+MYy3qNr8ptdTcuugfd2UBj4YIRal6gmHWmjs4ET4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzjw0y5jvohqnG0w/k98pfyL7pwFZO+aFQLbSn0dllKuL5LRwj5
	4MKolSCvNYfm4Jop27jpZOwjN23eTsgDKSBLKlcnktRMeIZSJ9ZPxOlNmd7+9JCo218kI6/cUcv
	pKjatOWBmyOCYTnnGg7SlkD8NCBVyxpTemU2xCFcYmhbalMzNicyIWgUQcQ==
X-Gm-Gg: ASbGncsBvAEHD0I2/6pGqj8fD23UchLWHncKYNTehb6LtYjGxpiw1fBAxoR/kcJvZ5P
	bLrJGfqLYcp3pUso5sE9krtxnsR1/9ZmPgBZb75Nz6uXCR/MtcZ7MZ6MEd+vRXgLU1Um7FYQ/LM
	veqTikToGVlQbwmvIVfQ1x0HibA0YC9J3Qb41u+grfJs8HxsH29ueM45J5k+pLgpkZfXH8Z8Eg/
	vZ377dm6hRYq3HTaz5Ft/UHUi+Uv5/WPytMBLNjzZqfhcGC39nf9hdJMeONUaW387lW0LdLVvDL
	0ERYdHZ7gGa6mMQRDrA4eHDc+UjlWLunbttLN8rc2sIyrANMig8bSasiGKmw+R8YBWzPlqCRnMn
	t2mkC0rVXG8M9JzzI3E2xb8HNhINoPlU=
X-Received: by 2002:a05:6000:2382:b0:3a5:300d:ead0 with SMTP id ffacd0b85a97d-3a531cdd5a0mr3790790f8f.43.1749235277486;
        Fri, 06 Jun 2025 11:41:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECTH6YhYvW6ZH1CMtqGX1UnVUl20ogDcBS5RnIYh0ZPNAA1XAMq5p/2Szxsq9CZSwnHVZ/TQ==
X-Received: by 2002:a05:6000:2382:b0:3a5:300d:ead0 with SMTP id ffacd0b85a97d-3a531cdd5a0mr3790768f8f.43.1749235277116;
        Fri, 06 Jun 2025 11:41:17 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:9c00:568:7df7:e1:293d? (p200300d82f199c0005687df700e1293d.dip0.t-ipconnect.de. [2003:d8:2f19:9c00:568:7df7:e1:293d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a532468360sm2571480f8f.100.2025.06.06.11.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 11:41:16 -0700 (PDT)
Message-ID: <965a6d13-e97b-450f-9d4c-d53cf08f9315@redhat.com>
Date: Fri, 6 Jun 2025 20:41:15 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] mm/huge_memory: don't mark refcounted pages
 special in vmf_insert_folio_pmd()
To: Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Dan Williams <dan.j.williams@intel.com>
References: <20250603211634.2925015-1-david@redhat.com>
 <20250603211634.2925015-2-david@redhat.com>
 <aEKkvdSAplmukcXz@localhost.localdomain>
 <b6a1b97b-39d9-4c9e-ba95-190684fc4074@redhat.com>
 <aEKmOfWDIy14Ub6n@localhost.localdomain>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aEKmOfWDIy14Ub6n@localhost.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yoVgVFoqaZM-r6jugVPlMQJA2AtLjN43UgcZoUvLvAk_1749235278
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06.06.25 10:26, Oscar Salvador wrote:
> On Fri, Jun 06, 2025 at 10:23:11AM +0200, David Hildenbrand wrote:
>> See my reply to Dan.
>>
>> Yet another boolean, yuck. Passing the folio and the pfn, yuck.
>>
>> (I have a strong opinion here ;) )
> 
> ok, I see it was already considered. No more questions then ;-)

Okay, change of plans, let me try to unify both functions in a clean way :)

I'll only have to find a clean way to make the other stuff I have 
planned with these functions work ...

-- 
Cheers,

David / dhildenb

