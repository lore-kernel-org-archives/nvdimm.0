Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CDD20487F
	for <nvdimm@lists.linux.dev>; Mon, 10 Feb 2025 18:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212780; cv=none; b=s+9Ol4yv+6XTek3boH7l4GrmxN899jGNg1PXfNahzDEkrLWd8xzzj0G9MK3H3xT88nsr4Jrmil4KaKmKcCTvlp+EHxUGKQF8Llxt9l+we4WMWNFwKoONbh2VAv7XhXEvH9cryx/q6qWWdlXEedAG7Yn2/a4FSaUMreOfi7J7jbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212780; c=relaxed/simple;
	bh=x/sZGvUzfxRrq9nYLFJINjPTLTHbf/GtI9WuU9nK5ys=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oQvtL2+gm41w+nTWguF7OH/aqb28pZrStSLceP4cYwiSwLcKAnIdzDoLd3sRbS4/B+/ZgK5pbk0iYq6BI6BgRFl5lKzmDLFu7alTSE4L/Emei1iaOFxVRxyRawyqyNFG8l/rWn/KtJfBcVCTFhPuee0p7R9OOT6Iy01uVszYEx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B2rs4NTG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B2rs4NTG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739212777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uYWKjcQduNIKs9dJZokUUBWiThkKPtNIV6gvjS6SD6Q=;
	b=B2rs4NTGdHoIQkIY0EFl9QvgmvMgc85hLzyHtjTlmz+DTPBQEgVRW224WssO28UDhc0LNI
	i/3Fz9WoBX1sN1A8LjjJ16UVTyL+sSWTYsdC+FwOy1aIy8eSOi8FWYXV6IxH0JTlDYv9dK
	faj3/cVj0UqZPw0Gu7BzJ4i7ouEFJnA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-6LULOS62ORu6rWd66IJduA-1; Mon, 10 Feb 2025 13:39:35 -0500
X-MC-Unique: 6LULOS62ORu6rWd66IJduA-1
X-Mimecast-MFC-AGG-ID: 6LULOS62ORu6rWd66IJduA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43628594d34so27730735e9.2
        for <nvdimm@lists.linux.dev>; Mon, 10 Feb 2025 10:39:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739212774; x=1739817574;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uYWKjcQduNIKs9dJZokUUBWiThkKPtNIV6gvjS6SD6Q=;
        b=KKgCSVMBBHCBbrMbRV0cd4T9hIbpZgjSs/llPP2Dd2X71YIgbat7dGjBJZb9Robpci
         O7S/OzEKYzOZDm51dOYnKi1aCEIGznlpuV2bHQWgM140bbbwgJ7EVuHMgRTdKqwBKdvI
         1DWNEiVuT1QChpijIWXHRENY8gMIh+k1oS/knExbpyTNfZWFouY7MgUHSoKd7Dsd4cBu
         1y1utaiCkQ3W7/75hO0ESsh71GqzXQZazr6Xxaep+hJkLrNQykyBN5axpEDdnnusaYtP
         EnUjE2iwujRQ6mZMAd5ElN1vbWlR/bCkk9SpkNeWaJ6t82EvGBEeRX7tXxZE9SxRsd+5
         G42w==
X-Forwarded-Encrypted: i=1; AJvYcCULcHKFIRMKdY83yZI1Mq0cARwYQ1114cJJIAJMVGkVvU/8PKf5z1Svq8nJiIigjR+AESLiFMs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUxtWb1UZ0qmNvN/PcF/AFaJ21AXAxzs2f6O3PJoSYNz81Tsie
	bBNN1caJyI7ugRwXtq/2unUXkSX4xx1471ru5SkBpUvXZNe6P5ypoOfpJoP+685a53xUAv0xwRE
	j+dBK5rJ5YuFgEWT3GZxOlaEreZb2v4+NGhhF0VP9wuuYoDoYpp3sfQ==
X-Gm-Gg: ASbGncsWtG1tPvZF85Jf/6rUsLQIApDRm8xIXGkKKtFZN56GJwILMrsJ7qszWNnZo0r
	Di678r6xYRIjE5WHisQZgkEK5QE67qZ8PaV3iw+YlMkMv6o6dJraQM37bCSDR4L9vjAPSkqXLsR
	I5TCZfzhGDzuTmlIZbDutpR8X9BPCUS+9IZ1v1CQQEwjEB+5KDc9k97kqWk7LL2YmfRPMAHfTlW
	1563XrdmY4KqWVSroggqBoYJtBtqlliibxMaA/W6gpCi4AEn6GqV8pwNTI9+gdnRVlzQTl4aF3U
	yz3LYgEzfXTetwlsBrXaCvGU3SABu72Yb3E=
X-Received: by 2002:a05:6000:1fad:b0:38d:ce70:8bdf with SMTP id ffacd0b85a97d-38dce708d90mr10228207f8f.37.1739212774668;
        Mon, 10 Feb 2025 10:39:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGvxARJ76HOuGFHzWjgTSgJca+XchsbC+N32+KUziB434soeJwYLOC+oL+ipLCoVO9VZXSzlQ==
X-Received: by 2002:a05:6000:1fad:b0:38d:ce70:8bdf with SMTP id ffacd0b85a97d-38dce708d90mr10228169f8f.37.1739212774160;
        Mon, 10 Feb 2025 10:39:34 -0800 (PST)
Received: from [192.168.3.141] (p5b0c6c7f.dip0.t-ipconnect.de. [91.12.108.127])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38dd2e0765esm7764114f8f.82.2025.02.10.10.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Feb 2025 10:39:32 -0800 (PST)
Message-ID: <48dec767-3e14-480e-a3df-1298315894f6@redhat.com>
Date: Mon, 10 Feb 2025 19:39:30 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 12/20] mm/memory: Enhance insert_page_into_pte_locked()
 to create writable mappings
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
 dan.j.williams@intel.com, linux-mm@kvack.org
Cc: Alison Schofield <alison.schofield@intel.com>, lina@asahilina.net,
 zhang.lyra@gmail.com, gerald.schaefer@linux.ibm.com,
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
 david@fromorbit.com, chenhuacai@kernel.org, kernel@xen0n.name,
 loongarch@lists.linux.dev
References: <cover.472dfc700f28c65ecad7591096a1dc7878ff6172.1738709036.git-series.apopple@nvidia.com>
 <7db953c8cc5a066b4aa23dbdf049c6f35cce7b99.1738709036.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <7db953c8cc5a066b4aa23dbdf049c6f35cce7b99.1738709036.git-series.apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kpeJGyNYqpCGa3OUFvEFaAErEkmVFJ7EcdGbWn7ofOk_1739212775
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.02.25 23:48, Alistair Popple wrote:
> In preparation for using insert_page() for DAX, enhance
> insert_page_into_pte_locked() to handle establishing writable
> mappings.  Recall that DAX returns VM_FAULT_NOPAGE after installing a
> PTE which bypasses the typical set_pte_range() in finish_fault.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb

