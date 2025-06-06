Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD7B2853E6
	for <nvdimm@lists.linux.dev>; Fri,  6 Jun 2025 08:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749199980; cv=none; b=eZz3U3z/v8T1PIUgdKxs24Ofk/3uLPiJZXXf21ymL5AhuGO3iSJoziwzjGg6/FmTC3bDSoR4Uji09xEHaCgSmcunEpjwOu/HIUg9z/S1NXaPEa7T7GIQdqcIjQswW8oUnS1mg7rUITifNHl10BAVS9APBN+XeRpGk/rdaxwg8h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749199980; c=relaxed/simple;
	bh=BvkazH4Zt1ZtWTeemCng4toclrnCOAdUWK+91s1GkYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vi+1W5RY8eSUtF0dC8VCyNlBcEdoc/SdcTK4tC8QpBZ/85P6dXg0H+Qz0CoxlpZhjs3yQmZsyBrFFe3kmk7N4Qo1+ntELMcUccbuYLLOlbyS9OFCGbrY/CRKqLqfi+M+1VJQ595T7KK7hwFcc+SLMAO71jgw8rP2cBzb7MejP7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fUM/u55L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fUM/u55L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749199977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BSNIELC8nNKrkXIMtRqAiZPiLFomBjrC8F+yQdB52u4=;
	b=fUM/u55LEKE00n306kWabsgs6eq9TKlj8mM7rTBqkbP9smWA+/wuEAXw4+sTjyIP0w9WKW
	6WQqX5UAurZyxjYRpKhtWAd1fDDed8VUEpjr/BzPMvgP5p/dgZxqzZloaSaPxpJEgPuET9
	wj7oZ8/yHt0+3uQ/C1KGJxf6zN1hzaM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-8D8oh9WUM3Wecp4k3EJvJA-1; Fri, 06 Jun 2025 04:52:56 -0400
X-MC-Unique: 8D8oh9WUM3Wecp4k3EJvJA-1
X-Mimecast-MFC-AGG-ID: 8D8oh9WUM3Wecp4k3EJvJA_1749199975
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-450cb902173so10156605e9.1
        for <nvdimm@lists.linux.dev>; Fri, 06 Jun 2025 01:52:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749199975; x=1749804775;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BSNIELC8nNKrkXIMtRqAiZPiLFomBjrC8F+yQdB52u4=;
        b=BfAXFcLFMq2Cdjqwb+kJ8CrysftpqZuZM+SimyxjIICW6JyEqcSgTIR3NfcKDF+W5N
         3CDIrxHcd1fdOVs+QBZqWVvHUwnCjfi/QnYh7p+eCRqREBe50TWP00EhiTWiq3LjA/gz
         It55rJNeop57NOmOW05SX9XBUSOQ5hQZOJozIAJD/a70/oRu6ieXPQUSm6twtpry76tl
         DnWxxOD7CvwvyxH/yr5g7hwpt9JwE3dMTyy8rMUeogyZApFMKbYmbsRUXdhP0f/a0Xjr
         F9qeXtHYufAcflSnBNVE8pbOZj2nTFpsrKN0vy2mOR/KvW1796AnHx60/SvWdrm9cFI8
         pcWQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1hRFwZvfrW/V82lmejLJM+TrlQNqABxrB9M2AQrJyhj7lrAIIp7mruUZB+3sHLu0FV4CqoXM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrdqbhM8+xzOK6nVeGlFF5DSRA2vzeEmRQEEo++vnhlzX2bGrG
	UgY/Q4wW14lIFlKZgE+wz3it/7BklTobrHiIMcRJLTI6zWI5w9Gb1430BuLmRfaY36iY7dBSP5K
	Jp4RgvVH5pHOCnjURj/kpI4bWDMbZIBnQmEIuffTtzZk2Udujm6gW0sEe7w==
X-Gm-Gg: ASbGncsoqa5msHENdfpXnBv01TLaWV+OxcLWqgd5jRvu4O1+X5reJn5X2DNrU1SWRF1
	EWogOup7YULqZg4ssvvxdeUlVBomeYqADwroetNqlKZH3Mf9UYuCWzJuuUBQNHHkC1Jgs/Wd1/m
	ANhpl6LjaqYRl0N1ISGDmGLusd8XBuyNE13ANFjcxBtf8iz3Cvb5tXHxQbPyNP4yMTxeHSOguq5
	LHCNsvw/XwboHk05xbTEvC3UlNb5v0VOs9L+9RDGqQRPFrlF+PxC+RzEtzayBAdrh29aAHO24kf
	HjQa0847RNrpkk+wNXnSg49oEqQJM3ud0BIeF8c6fFQ0UKrr3Q1F0AMVsRwcEBWRgFZKp0a5oiT
	KE7iNdyodB/lVpQedVXkdZcYaXUIwII4=
X-Received: by 2002:a05:600c:1d05:b0:43b:c592:7e16 with SMTP id 5b1f17b1804b1-451f844f896mr71608105e9.3.1749199974960;
        Fri, 06 Jun 2025 01:52:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMNS7e3m8Ldb89F+T85l6hGoyO36C/NX/9a6I0ZGg63okF2E2lORvWNNQqjZJAPa3vHAB3qw==
X-Received: by 2002:a05:600c:1d05:b0:43b:c592:7e16 with SMTP id 5b1f17b1804b1-451f844f896mr71607845e9.3.1749199974576;
        Fri, 06 Jun 2025 01:52:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f19:9c00:568:7df7:e1:293d? (p200300d82f199c0005687df700e1293d.dip0.t-ipconnect.de. [2003:d8:2f19:9c00:568:7df7:e1:293d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4521375b60fsm16912665e9.40.2025.06.06.01.52.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 01:52:54 -0700 (PDT)
Message-ID: <b0aeba3a-6ecc-4cd5-9787-e1d3eb4222c0@redhat.com>
Date: Fri, 6 Jun 2025 10:52:52 +0200
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
X-Mimecast-MFC-PROC-ID: TJC_Ah0Sx2ixsuPfziCg0nPoDPdt98-stMRC6V9mNwM_1749199975
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

Yeah, the first version I had did exactly that (second boolean), and I 
concluded that we are simply not "inserting PFNs".

Especially the second patch is much clearer on the pud_none() handling 
(similar to insert_page_into_pte_locked() where we only have exactly one 
such check)

I'll have some follow-up patches planned that will add more pfn-specific 
and folio-specific sanity checks.

-- 
Cheers,

David / dhildenb

