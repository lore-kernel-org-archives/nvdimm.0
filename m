Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E45D1F5435
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 07:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749713680; cv=none; b=ASU4/SWh+Jp5xpQw+LpuyyEA/YF9HXTRWnJHPm0ScuIA4tH121i+rI1FI76v93WuqRfHJILjLgxVEsY0BtoURs4XxLN2ysFGbLlFiWgZADQyMm4MhyJe9zEZ8OgwVIYRMUUGCe1yxXUF0KnggMortxvFwC+JsVpbns5hq9IcHGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749713680; c=relaxed/simple;
	bh=O7pyEM0izVRPCeXuDgYSq4asRxZjMzOuStrUn64cft4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ubJdsPIdiT3OqkJC6GZPllMZxbJ/kz3Hdas1Z8jz6w+DXj8+pynYPbIHVlWfOXpAp2M6/N34zLxoIBqb1DCjHWWSx/8oxE+S3LvDYh1LW5sfKsAgbdgIoD+ORtnqgBZpfQNIrHT3R/P+tHfX5h3EqEEasFoA9UYMvBVOZS8QPwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lf+iEm7f; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lf+iEm7f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749713677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p3JenDZmdffOaVYnSVPt/myIgL1tW+jk0aEnlDMO+rw=;
	b=Lf+iEm7ftLqiYUEkG4T+fyxn8q6tIi1xHoN6Ewqz43+jXo7Y+tJrDA1n/ArUyDkMqvxwDN
	DiYW9i92t+3PSsDX8Pi1VvBxaMJyiO92iXwXinI1OnjnNZsLe7liEpp/spzAn7TlYpzvPU
	9ZPjG8DOlJQEIHqvq0fiNQ0THl4KKR4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-hqdEgfLIPgaQs3odcqBVQw-1; Thu, 12 Jun 2025 03:34:36 -0400
X-MC-Unique: hqdEgfLIPgaQs3odcqBVQw-1
X-Mimecast-MFC-AGG-ID: hqdEgfLIPgaQs3odcqBVQw_1749713675
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-450d9f96f61so3819625e9.1
        for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 00:34:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749713675; x=1750318475;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p3JenDZmdffOaVYnSVPt/myIgL1tW+jk0aEnlDMO+rw=;
        b=lKHil857YqM7VTcBwonD5K+V/Ue+vEBN1I+u/cLf2NZtZEgEpXUh/0vD+Qv888L4Po
         smjxEJrSaU/ylgtyNIMCETREJSBVCvAyVKZx9sXImfIn5QL2b19ydLTFwdqyonY9Bclu
         Obc9QnoSMDPvbQneWCBlbE+1/sbge4Hy8EZHzwsyPd/8ohtljkXkDB6eT0kx5uwoSL+G
         GkbjlFnJalgTCvM54Lv1Hmgn8GwS6/FFkZQL0UwlqRBzH7ro2qY9NzKhxKiZqx4ctwfM
         crb/kOT6AMmkHnRnAgOXvLT8NRyK8NYkHWYQ9PuWuIgb6TDv0poWe10sVSZD3wCL2Laj
         R2jw==
X-Forwarded-Encrypted: i=1; AJvYcCW8oKc41wcYOZOQHxmXz8ivi8kf5zg6hgBRZ7219CAlFBDAQ6WPF0StOAILee9M3HdYGQuI5GE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yznse8i/Z+TguATbOwFaGn1Qh3rAMP1pHS0UBLTtw09Y1V29Faz
	gJ7w90APj4//Nd6bd6HDRXjWKfsGEWgbk4JpP6h3gt2XDgxt8Cplp3OKCZ1eEPQqSzjxTi62kkI
	6rI3N7jp3j6oXGSHjpGuK7m2XIrYrjSR2M4RhcwgY4rdxJLLmtAzlUAXJMA==
X-Gm-Gg: ASbGncugEudEHG65p9CEPIsVjgPV6wjtkYKMf1VH/lfB82auFMXzrYu3ktbpxHQkjRT
	AnSq96PxunujJJaunedPBCbUcvdkPuo0t49WDaatD+WkaVq4HUhFtlt2jMfYOYLcUc7sMx8OS5b
	p4jVLyFoz8u7lRj4LOqn8T24cHRDko53vfiWME+4a0YGXvfRZhDG45/y1e3ecBp5ivrECqNqV0V
	Wh4Uc9B+QiJ1P5d1OSr17EEJOYuLWqCwRAzAYv/28M4lAUBhctK4mC9o+eAOqiVC0E7LsL3Pppb
	yfCF3YELe5Q6vwtJSDKnGc7nfVk+/WW6YEsFhaLjCbQcpZaP1bnbZq6ViCi8Jguu5XJ+vB7Rr6a
	r2IEn8CTCf6lNKOqqxOywjMewmaTHqJkNar5eoXxQaaytCoqxaQ==
X-Received: by 2002:a05:600c:314b:b0:442:e9eb:cba2 with SMTP id 5b1f17b1804b1-453247d6b1dmr66212265e9.0.1749713674671;
        Thu, 12 Jun 2025 00:34:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpm8FZysBhfK5FdgNbKwxCA9LHHmCOsPng7ME2OaJNGz/MWqAuec3iQWqzq++f2gekcuzJ2Q==
X-Received: by 2002:a05:600c:314b:b0:442:e9eb:cba2 with SMTP id 5b1f17b1804b1-453247d6b1dmr66211895e9.0.1749713674264;
        Thu, 12 Jun 2025 00:34:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2c:1e00:1e1e:7a32:e798:6457? (p200300d82f2c1e001e1e7a32e7986457.dip0.t-ipconnect.de. [2003:d8:2f2c:1e00:1e1e:7a32:e798:6457])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4532e2384cesm11371905e9.16.2025.06.12.00.34.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 00:34:33 -0700 (PDT)
Message-ID: <a4566c51-7a4e-4371-9922-b819cf2b11dc@redhat.com>
Date: Thu, 12 Jun 2025 09:34:31 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] mm/huge_memory: vmf_insert_folio_*() and
 vmf_insert_pfn_pud() fixes
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, Alistair Popple <apopple@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Dan Williams <dan.j.williams@intel.com>,
 Oscar Salvador <osalvador@suse.de>
References: <20250611120654.545963-1-david@redhat.com>
 <20250611160804.89bc8b8cb570101e51b522e4@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250611160804.89bc8b8cb570101e51b522e4@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: c5Fp1rA5BdSgfCDcgpGYuCtqTjqk679B0WXYBhurqnU_1749713675
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12.06.25 01:08, Andrew Morton wrote:
> On Wed, 11 Jun 2025 14:06:51 +0200 David Hildenbrand <david@redhat.com> wrote:
> 
>> While working on improving vm_normal_page() and friends, I stumbled
>> over this issues: refcounted "normal" pages must not be marked
>> using pmd_special() / pud_special().
> 
> Why is this?

The two patches for that refer to the rules documented for 
vm_normal_page(), how it could mislead pmd_special()/pud_special() 
users, and how the harm so far is fortunately still limited.

It's all about how we identify refcounted folios vs. pfn mappings / 
decide what's normal and what's special.

> 
>>
>> ...
>>
>> I spent too much time trying to get the ndctl tests mentioned by Dan
>> running (.config tweaks, memmap= setup, ... ), without getting them to
>> pass even without these patches. Some SKIP, some FAIL, some sometimes
>> suddenly SKIP on first invocation, ... instructions unclear or the tests
>> are shaky. This is how far I got:
> 
> I won't include this in the [0/N] - it doesn't seem helpful for future
> readers of the patchset.

Yes, trim it down to "ran ndctl tests, tests are shaky and ahrd to run, 
but the results indicate that the relevant stuff seems to keep working".

... combined with the Tested-by by Dan.

> 
> I'll give the patchset a run in mm-new, but it feels like some more
> baking is needed?

Fortunately Dan and Alistair managed to get the tests run properly. So I 
don't have to waste another valuable 4 hours of my life on testing some 
simple fixes that only stand in between me and doing the actual work in 
that area I want to get done.

> 
> The [1/N] has cc:stable but there's nothing in there to explain this
> decision.  How does the issues affect userspace?

My reasoning was: Getting cachemodes in page table entries wrong sounds 
... bad? At least to me :)

PAT code is confusing (when/how we could we actually mess up the 
cachemode?), so it's hard to decide when this actually hits, and what 
the exact results in which scenario would be. I tried to find out, but 
cannot spend another hour digging through that horrible code.

So if someone has a problem with "stable" here, we can drop it. But the 
fix is simple.

-- 
Cheers,

David / dhildenb

