Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4731C5F25
	for <nvdimm@lists.linux.dev>; Wed,  9 Apr 2025 20:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744230326; cv=none; b=Dp1WLOhtMgeTDxmBc+FemJT0mRRJARYPz+9wrh1CHBRYRblQe0Wdfwp58rBowWuhKiZQDLVMEgmjfAmNi5kUdYqt/+hoRvWJfbCeGmZLZRDst1RMkAAoMieYJ8fJ0/Oi71e9WBM6xSWITY+agDCip9QHNNwy6n9ZF5oZE8diu8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744230326; c=relaxed/simple;
	bh=yduIJc9GeeVh1mLI0fPML8PN4ihKncORi7ZrP4oiBsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rRmmHkS+uZSH8SgublUjTJWFUCUc5gZI+LMUTAg6HR8liuTwwEaPUomrzKSsiih4xPO8qPUM1dZTVICrNLQyizJqoJrfG7QZFfZxlaGsDW2na0pr6uXVadUtIS2cU1a4pZCvMfa4ow3d8i7O7iKW10vpnMq8PQLOxX0m8orL+uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dHRxjxcC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dHRxjxcC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744230323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dEQLXEYc0ubNhBaFSh5idrW5M9ySDyOt2jhBtoy2pio=;
	b=dHRxjxcCt37JWXcwtA8t7ht/nBcoQqEu8bYTCxiD/rZRSZiDlvd0ahn1WChQbfRzR6F1rT
	2g/0XxT+DXToao1QUBjArEkXUIPhDI3rVmQIhbdbzfqLXDzfJkkGwYY6rejhlUbQx9SmSs
	OCp3YOReyOrEO4rli81rWhwAWP+zrIo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-rzmUmSxPM3KT7D80gXWxsg-1; Wed, 09 Apr 2025 16:25:21 -0400
X-MC-Unique: rzmUmSxPM3KT7D80gXWxsg-1
X-Mimecast-MFC-AGG-ID: rzmUmSxPM3KT7D80gXWxsg_1744230320
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3912b54611dso4863f8f.1
        for <nvdimm@lists.linux.dev>; Wed, 09 Apr 2025 13:25:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744230320; x=1744835120;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dEQLXEYc0ubNhBaFSh5idrW5M9ySDyOt2jhBtoy2pio=;
        b=hmtVDTZcBOLLznrSDOtfbiH01UkvGNBiG/Es+T4FQPREkLxsXxKGxQXUqCRVK9fRDT
         fGcmW1KrzVYVAIGMn5p30hUSEgdNJGOIfhrRNoActKHrz1896ht65iPDERlAMgkIdiO/
         bq3G0vs3PX1huZnDxedgyoNTltEAuiX7424CS6rFpoNpVOMbpSKW1wBk/czpBEQeSdT7
         8mFHtj1vrXQTV9nUcEjHiQEFBWmWKHtjRrVFINhCXWhhrDNcOjqiRhFvNq9+FSCflqQu
         814h9VV2/kvCPRusxWG2zQjNoZjtmSh+ZmbOSwKniFg0qluZSGGRgwsj26dvFfRT56oT
         wZzA==
X-Forwarded-Encrypted: i=1; AJvYcCVoS1NP8tB9Xs5pi8ffaa5ARfvR2NcuS5q1XhWEKjTdV3B937hyvaBPya/u2+qhvaY43/HTsy8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4TJe2CBEA6UbAHaBQc8F7fiTq9rpJSqWd3OM6hAu/VZ7GgDyb
	PJ8Ddg/aIv8jFqwSkWdWAeibtOUXlMKdgD6ShQuVZ82PiTn3c8cyxRiGxZC960Q7iC4bNJYIuth
	bKqloW40FEmU59CyHOBhbn3kvPK+ERYmLjNsBLnifTpKRgWl05Tjsog==
X-Gm-Gg: ASbGnctxnlh4KtXVlp7p5bsIaJiYjfZvkkE0gdzAMKQryiekkG005+VHWuCP3/S7eWj
	tWBRKon1I5JgXngtwWyCaZPUEcRId12KkAgJbjNXGIQFzch2PGFOInVBKLtJBhZsF0yo9Yqy/+I
	FKDDxt9CPClX+jFQ5gGkTE88PeamsN3SkZ/WIIslCCmZfwJO/95QQ8Bvd+EA9mj4qFOso/MUzK0
	sFal0Yb5Yu9HdSWVqUkhgY6Qx4hocWF1GFuHNaZKn/lfsn9Ov0Q6zojuFcM/1Q1bg5WhhEw1lVK
	CN5Rg1AWDWjgzX19/X1pngwMbPvAZnbvi5j916t5o7fbgnKjrc7Vxpcc6GazKI/bF274j+RoKrm
	83r9yrDj6BiRiUkr3MSNzO2/cAASRAPCixA==
X-Received: by 2002:a5d:64ee:0:b0:391:1923:5a91 with SMTP id ffacd0b85a97d-39d8f4fcca5mr89532f8f.55.1744230319964;
        Wed, 09 Apr 2025 13:25:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwb7aa0vGZfYphUXGrT7UzBVhYPY67/ggKAkxF3k7fCu+SMUy5RtKfga0GRh+ctdIq464Lvg==
X-Received: by 2002:a5d:64ee:0:b0:391:1923:5a91 with SMTP id ffacd0b85a97d-39d8f4fcca5mr89524f8f.55.1744230319532;
        Wed, 09 Apr 2025 13:25:19 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70d:8400:ed9b:a3a:88e5:c6a? (p200300cbc70d8400ed9b0a3a88e50c6a.dip0.t-ipconnect.de. [2003:cb:c70d:8400:ed9b:a3a:88e5:c6a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39d893630fbsm2611442f8f.15.2025.04.09.13.25.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 13:25:19 -0700 (PDT)
Message-ID: <edf48c4b-1652-4500-a2e0-1cb98a1f0477@redhat.com>
Date: Wed, 9 Apr 2025 22:25:18 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG Report] 6.15-rc1 RIP:
 0010:__lruvec_stat_mod_folio+0x7e/0x250
To: Dan Williams <dan.j.williams@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev
References: <Z_W9Oeg-D9FhImf3@aschofie-mobl2.lan>
 <322e93d6-3fe2-48e9-84a9-c387cef41013@redhat.com>
 <89c869fe-6552-4c7b-ae32-f8179628cade@redhat.com>
 <67f6d3a52f77e_71fe294f0@dwillia2-xfh.jf.intel.com.notmuch>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <67f6d3a52f77e_71fe294f0@dwillia2-xfh.jf.intel.com.notmuch>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: q0K-CX8ezX2n1V2Kh6xblaf7xi56SSEc1m8qWT5H0FY_1744230320
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09.04.25 22:08, Dan Williams wrote:
> David Hildenbrand wrote:
> [..]
>>> Maybe there is something missing in ZONE_DEVICE freeing/splitting code
>>> of large folios, where we should do the same, to make sure that all
>>> page->memcg_data is actually 0?
>>>
>>> I assume so. Let me dig.
>>>
>>
>> I suspect this should do the trick:
>>
>> diff --git a/fs/dax.c b/fs/dax.c
>> index af5045b0f476e..8dffffef70d21 100644
>> --- a/fs/dax.c
>> +++ b/fs/dax.c
>> @@ -397,6 +397,10 @@ static inline unsigned long dax_folio_put(struct folio *folio)
>>           if (!order)
>>                   return 0;
>>    
>> +#ifdef NR_PAGES_IN_LARGE_FOLIO
>> +       folio->_nr_pages = 0;
>> +#endif
> 
> I assume this new fs/dax.c instance of this pattern motivates a
> folio_set_nr_pages() helper to hide the ifdef?

Hm, not sure. We do have folio_set_order() but we WARN on order=0" for 
good reasons. ... and having folio_set_nr_pages() that doesn't set the 
order is also weird ...

In the THP case we handle it now by propagating the folio->memcg_data to 
all new_folio->memcg_data.

Maybe we should simply allow setting order=0 for folio_set_order(), 
adding a comment that it is for reset-before split.

Let me think about that.

> 
> While it is concerning that fs/dax.c misses common expectations like
> this, but I think that is the nature of bypassing the page allocator to
> get folios().

It was a bit unfortunate that Alistair's work and my work went into 
mm-unstable and upstream shortly after each other.

> 
> However, raises the question if fixing it here is sufficient for other
> ZONE_DEVICE folio cases. I did not immediately find a place where other
> ZONE_DEVICE users might be calling prep_compound_page() and leaving
> stale tail page metadata lying around. Alistair?

We only have to consider this when splitting folios (putting buddy 
freeing aside). clear_compound_head() is what to search for.

We don't need it in mm/hugetlb.c because we'll only demote large folios 
to smaller-large folios and effectively reset the order/nr_pages for all 
involved folios.


Let me send an official patch tomorrow; maybe Alison can comment until 
then if that fixes the issue.

>> diff --git a/fs/dax.c b/fs/dax.c
>> index af5045b0f476e..a1e354b748522 100644
>> --- a/fs/dax.c
>> +++ b/fs/dax.c
>> @@ -412,6 +412,9 @@ static inline unsigned long dax_folio_put(struct folio *folio)
>>                    */
>>                   new_folio->pgmap = pgmap;
>>                   new_folio->share = 0;
>> +#ifdef CONFIG_MEMCG
>> +               new_folio->memcg_data = 0;
>> +#endif
> 
> This looks correct, but I like the first option because I would never
> expect a dax-page to need to worry about being part of a memcg.

Right.

-- 
Cheers,

David / dhildenb

