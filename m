Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7ED7346F
	for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 20:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752783281; cv=none; b=XhetfEtTOZDKxU2E+JDg/P0b3hbxbA6ikVWpbdBGFegnfEpCmxpXMEcrm/2p2UVvwU2nMjpWeuAOugyH+W72GwSiGVDy1ZHZ3L3KxNIbkKcfMFBfI/rL5KfYbQrcrMQQt+uasT8vBlyE8W2JrKdpQEpPvQrxM2xZVaWVs6o2vP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752783281; c=relaxed/simple;
	bh=9dgH0W8+tWamyM2cWuqdarjrgO6ZCJ5nf+a4W42EmOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=chmN0RQZGVwU6OWG3NRqU/EOW4g7nPri7YdgsGs3K7VtrT622EGXikrVNvM92szQiYVnEDajRNugfr4PwcABVipD3kOOXwQVKZwAsUn9w+qtNSnnvJ4bAw/vQevKYxsJkJEO6qH6mvjlVsC1jMWNG7bOPMlGto/7uq3CEsvkYWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XNE0yPlY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XNE0yPlY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752783278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QlYYu3k/BYRc6Kiix2dPUNypQutbN2D0tRZWGefeAe0=;
	b=XNE0yPlYp9iRm06Xm9KSQLYTiZD9enAu+Pq2ysYWnqHrzSTrIGwgsnI2I2HtetYPHV42lh
	qoD39C65lPaQvKK3Psag3wRDYMkXGRlaYcmE4KFElPyuzWJ5Y7UbiiMHbC64XdRvHhRYxO
	eoyOv2dFFtvrpXw6FBhygulcYgvybCk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-ucukA8O0Ov2n_SSnnYdqGA-1; Thu, 17 Jul 2025 16:14:37 -0400
X-MC-Unique: ucukA8O0Ov2n_SSnnYdqGA-1
X-Mimecast-MFC-AGG-ID: ucukA8O0Ov2n_SSnnYdqGA_1752783276
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a5281ba3a4so883868f8f.0
        for <nvdimm@lists.linux.dev>; Thu, 17 Jul 2025 13:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752783276; x=1753388076;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QlYYu3k/BYRc6Kiix2dPUNypQutbN2D0tRZWGefeAe0=;
        b=aQpc4lIlxA18DJN3sDjaxAa8ohb61du5hutHY+qAHUGWU6dGYClXiwRnZxNU06263z
         ycnWfsyrKPylMtYrBVNrvwMDLlLNBEMyJ22AcF2MzFGzqqNjpiEvYsEMvsi9Kd53j95X
         2buneJAbfeQyiJhVIecBsUtUAQUWKkY1PpohYj/NmEuJ3IZmBgEWWZa1R0k+9JdOJVIs
         CU7RpvIzbUruJ9oEqDfVzy0HluFW/qfXwWMypAX00iKUS0xGRf6+nNHWH3kPKNu2Kh50
         /nb2/7MKqWz7zkOcI1WlQMfSDdnek3gr8z1igJgEUy2jOSotiIBmaQhqdfqu9x0DGTFc
         ZzXA==
X-Forwarded-Encrypted: i=1; AJvYcCW3LbCxMXIY8j+CKgUErxysicqOGyjSvr+f7VbdKlBLPSQLRHSexi23t6AUkLJrAMs3k7sL35U=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpWlRQ8qub55OtFL+OI3ziWEV/jNDs+0zAgGmxnOA1Um5TmPNu
	O0Qm3vnATLQBDxItPasKIlMnpJEvycg5beCuoJmA36xnyxXPBRgmn0Vyu7hXvVZK33TKBfd/xx/
	q35eYVlHzLd3e5MxSlpU/0PQtNsZ7gmTBwLEB6F9kmWIh9v+AbdYXdxJBRA==
X-Gm-Gg: ASbGncteWra8OIjqthXqUM4Dge1ZIZy5Qmsw8S9p9sbYCP+rNk+ieiDcoSNn0DHySZC
	ieROwxt/s+J/3wB8z1/FiE02myfE0XMiQy0xRZ/AyBnqIbcbZlZZrXsYp2Y8dneGRe+cWYCEfqW
	BYCFOthmiau9+cEh4qPiBo8y4cp7W6lrNWyjArFRcrqNfcDpVs4MC8HSrxAYSj33WmWSLC4qdaR
	qSZJDw6+eCqlZfzM/7opOqzCuBNa+pdpBbqEoDOvrP6kce5CJUbrBy6+rYpn8qmxwY9H5+aXKPa
	s1Vl/Ovjdb+SJ4m7ZRsTHNdPpXeZM3CDwNXvv34VsGGof6GdrnGTRidJIS4ZJsSSg73bJDhyq04
	QLT4vAJx1oAx8j0hxTav0w39qadebD023rm6WwTx/r2gSu81nM3aDTgjBOzYrxeKJ
X-Received: by 2002:a05:6000:992:b0:3a4:f663:acb9 with SMTP id ffacd0b85a97d-3b61b0ec0dbmr197227f8f.9.1752783276431;
        Thu, 17 Jul 2025 13:14:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEXZyoKOBqIpYS/jO2KmsvWvIMoN9zXhccC8DWWsod9nvdf0NNHfT+L/AueK3GG0g1XLIDWaQ==
X-Received: by 2002:a05:6000:992:b0:3a4:f663:acb9 with SMTP id ffacd0b85a97d-3b61b0ec0dbmr197194f8f.9.1752783275956;
        Thu, 17 Jul 2025 13:14:35 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:2b00:b1a5:704a:6a0c:9ae? (p200300d82f352b00b1a5704a6a0c09ae.dip0.t-ipconnect.de. [2003:d8:2f35:2b00:b1a5:704a:6a0c:9ae])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e8026e4sm59374615e9.11.2025.07.17.13.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 13:14:35 -0700 (PDT)
Message-ID: <fdc7f162-e027-493c-bfa1-3e3905930c24@redhat.com>
Date: Thu, 17 Jul 2025 22:14:33 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] mm: introduce and use vm_normal_page_pud()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
 Lance Yang <lance.yang@linux.dev>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-9-david@redhat.com>
 <4750f39e-279b-4806-9eee-73f9fcc58187@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <4750f39e-279b-4806-9eee-73f9fcc58187@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2tOmsYceWr5CPluv9TTmh8Xfk2rG9kZnhD9VnWTvd24_1752783276
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.07.25 22:03, Lorenzo Stoakes wrote:
> On Thu, Jul 17, 2025 at 01:52:11PM +0200, David Hildenbrand wrote:
>> Let's introduce vm_normal_page_pud(), which ends up being fairly simple
>> because of our new common helpers and there not being a PUD-sized zero
>> folio.
>>
>> Use vm_normal_page_pud() in folio_walk_start() to resolve a TODO,
>> structuring the code like the other (pmd/pte) cases. Defer
>> introducing vm_normal_folio_pud() until really used.
> 
> I mean fine :P but does anybody really use this?

This is a unified PFN walker (!hugetlb + hugetlb), so you can easily run 
into hugetlb PUDs, DAX PUDs and huge pfnmap (vfio) PUDs :)

-- 
Cheers,

David / dhildenb

