Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACF41F1909
	for <nvdimm@lists.linux.dev>; Wed, 25 Jun 2025 10:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750846496; cv=none; b=bsEY2auRA7S4KaPjX/dwDQkGBMgh9yCPu71QFne4bdnojwbUC0lVXDljaikCnB/5wlrtyZzm8OopIvjKGSiRAnTZOu9ok1Av9lZrRnNJ4pwQQe8o1DmT3LzPtC7P6CEpq78sY/SK9EtLXM07tl+lGW3A5EBsCXwaGRCkyMKMMu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750846496; c=relaxed/simple;
	bh=PzO6ztBfNimSyfx64qkZBXAUmYb+kTXD/55VqloyB5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AlBx7A7hUx91AC1wSiTsmDEFWWB03dC38ZcQBMpk17BQtjo501tP2hkZAsIYqb8vETmTPHV4IWM92nAm7Q8Af2AZWZg06R96bSdAE12Wto5u31Py28oI9qMKQW4zhBwSxeaBVzZBQPkvalRtp9B7SpI2ou71OqAiWI3W3wFO8ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L/wtGTNC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L/wtGTNC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750846494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=XjdslU0hJ7FdAOMc0fmPmVs8CPi2M/vDu4x7gBoGlaw=;
	b=L/wtGTNCF1/yqGhXCRQJRYiDUb66NXlDfCvEyadVfl04hwwrNR6iM1ilqR1fjV047UGksW
	lt7z6ut7RPi1O6hkd1RAGZnjOT0PKZO4W7XY2saU8XG+ZuUHZlR38weKEaI5an/16sMNSM
	bYviktckhVH5JmQZoNLn1nqOb+UtPkQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-GVEdR1-tPfC6rr2evT4zLA-1; Wed, 25 Jun 2025 06:14:53 -0400
X-MC-Unique: GVEdR1-tPfC6rr2evT4zLA-1
X-Mimecast-MFC-AGG-ID: GVEdR1-tPfC6rr2evT4zLA_1750846492
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-451ac1b43c4so7807875e9.0
        for <nvdimm@lists.linux.dev>; Wed, 25 Jun 2025 03:14:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750846492; x=1751451292;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XjdslU0hJ7FdAOMc0fmPmVs8CPi2M/vDu4x7gBoGlaw=;
        b=dz1wJYETKOpYl8+GjU1C3o1qKU9Tn+J02T2xws0+NlIGZw+Ryfaf9NOqnw7NFHmlNN
         siyvQVK3vItSkOMA+drB9mxZ9BQ37xDd04vfYKGu4MBw0WmhM3Wr6Ayz53j6hSC6urka
         Up/ssDg/3WKl3iTiAUTJ+GE/XXiOmQXO+hGnQKFDW1eY7UwjoNEodFTprpM7Tsjv0pas
         HLF+3PSAkD8SW20ao3zpDj5j732QoOAwAxZ1SMVJTaJm5+DfKGEg0JbwVxEaQfiFqR37
         dh5VVRSusjzbQo2bMsh2N3JCSL3+3QN7J1rjvnleVNqrLpgCxZJm0kEEOmppDnIPctJA
         SwMA==
X-Forwarded-Encrypted: i=1; AJvYcCWcC1E9QsIp4kpMBVUZsg9jS78S3vTt0bNohRjt4awp6pf4Egz5DmwY/vZcFrexPMahjvL/rhM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMAhsD+mN29NOpyXIpC9mrnqar4BTKftOddUScdqY+hhCY9nAe
	+8q9qBY860sgI45BF2avWKGwtQvj6g+gcb5wEDOL3ZDFB5g8IVjFDy8u7P+Z95rLhuH6Qls6620
	1TjW6IX4w6cvHOo1XJ+dyRf0zYtPlxG1FxiYOGivtDUC5FNf7WMCqNwkvWQ==
X-Gm-Gg: ASbGncv4FTrEsTbj6grDyWkG3n/xWyoAXMgPN9kMj/yY28s92uSIYm+JY28YYIpv4kR
	3WiOjfRwlEiYzRtNU2drFCindTRxl40ocGnBEs/rlAFCYNKextygJZ2rQfc8GLLCDIxq+vcMezE
	rMJLaZND1Ham+XpAvExtuiw+mLrVrmUekLbllD7Wl5IRsI7ex3UyHrn9aHbatWqFgljchxb89k9
	l1N1BEpsLFBSUM9rdVCsGXu5Z3WG8zSyBFbR0e7hiFEvuGabeFDfMcnolF9NshLxNrSraMYBymo
	ojzc9J+/D2yrxhoL06tMGrDvepXeyV3DR5QHnn21tugk3OGBOoDkzw==
X-Received: by 2002:a05:600c:348f:b0:450:d00d:588b with SMTP id 5b1f17b1804b1-45381ac2563mr24960715e9.9.1750846491755;
        Wed, 25 Jun 2025 03:14:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFH9JVXQGzeiIaOJETPwD0mhFgfVQwPa4nS7QJxUmuEV97nlCNLYTvAiF9sgliseCzUuOgbUg==
X-Received: by 2002:a05:600c:348f:b0:450:d00d:588b with SMTP id 5b1f17b1804b1-45381ac2563mr24960365e9.9.1750846491347;
        Wed, 25 Jun 2025 03:14:51 -0700 (PDT)
Received: from [192.168.3.141] (p57a1abde.dip0.t-ipconnect.de. [87.161.171.222])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453835798acsm10471655e9.10.2025.06.25.03.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 03:14:50 -0700 (PDT)
Message-ID: <77dc3ddb-f748-48bf-8dc4-b8f904611f98@redhat.com>
Date: Wed, 25 Jun 2025 12:14:48 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/14] mm/memory: factor out common code from
 vm_normal_page_*()
To: Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
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
 Pedro Falcato <pfalcato@suse.de>
References: <20250617154345.2494405-1-david@redhat.com>
 <20250617154345.2494405-11-david@redhat.com>
 <aFu5Bn2APcr2sf7k@localhost.localdomain>
 <1ea2de52-7684-4e27-a8e9-233390f63eeb@redhat.com>
 <aFu_VeTRSk4Pz-ZL@localhost.localdomain>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <aFu_VeTRSk4Pz-ZL@localhost.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PfvWatRn--9c8tqID7ZSNuRhKyAOTwbq0DZpWPxgQjw_1750846492
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25.06.25 11:20, Oscar Salvador wrote:
> On Wed, Jun 25, 2025 at 10:57:39AM +0200, David Hildenbrand wrote:
>> I don't think that comment is required anymore -- we do exactly what
>> vm_normal_page() does + documents,
>>
>> What the current users are is not particularly important anymore.
>>
>> Or why do you think it would still be important?
> 
> Maybe the current users are not important, but at least a comment directing
> to vm_normal_page like "See comment in vm_normal_page".
> Here, and in vm_normal_page_pud().
> 
> Just someone has it clear why we're only checking for X and Y when we find a
> pte/pmd/pud special.
> 
> But not really a strong opinion here, just I think that it might be helpful.

I was already debating with myself whether to add full kerneldoc for 
these functions ... but yeah, to me the link to "vm_normal_page()" is 
obvious, but we can just spell it out "see vm_normal_page()".

-- 
Cheers,

David / dhildenb

