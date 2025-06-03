Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F4C4C74
	for <nvdimm@lists.linux.dev>; Tue,  3 Jun 2025 21:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748986597; cv=none; b=MQODIvuzHZQNbZQasHs8OSgdQzFA0q8Z/wOTvwo/0Bn2FX3p4Z61erabr8ZnJb8qI79JOI55RqufLxQrvnAHTfVokmxB2Xm6ul1M6X95cIjOBns+Xh5HKXjpZxc/wSrfQpXzfJ0w315elgu7T/vUOkPvRvpHGH2HQS3AS/K4vY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748986597; c=relaxed/simple;
	bh=9iESXUsiowsy5bcAbQrdneF8ZhbHbq1/aJYTuCiIpus=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nEqX95+r10mmrb/2E/A430uLSl4ChAtuf/4HcGp+BLxcLM1Z4dsrTbZ0bJHM7SzSUkxTK6/NcdN750JxCqO6CwHCGgOQAUbtpSRUwmtBNMGCbrR1wWJonOtwYxWUc61k1NM44Z4hOwTaP0wrChV8o/DIPqZSxu6feJSnelXPb+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NiTeAqs3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NiTeAqs3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748986594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2mtt7sFFf6VjoTBYrIWNH56E46FCaFvey590NiPF5fw=;
	b=NiTeAqs3xONdeqRhzndNoC0zgaPKOTflhM3PVzNm2Qny1rj+rMh3KFa+6ubs5U/IiPRopI
	4BEOHwzjqp24lM34Il2xgGiBGcUZPXxjIhIznZSNLBqPJmjOTSdHaHt+vvMOwwBVV4uJL6
	GCY8gkXNaoIlMLBxz7dxCDdVrBJoM20=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-_-hulvEKNuqiKFTDoM_tqA-1; Tue, 03 Jun 2025 17:36:32 -0400
X-MC-Unique: _-hulvEKNuqiKFTDoM_tqA-1
X-Mimecast-MFC-AGG-ID: _-hulvEKNuqiKFTDoM_tqA_1748986592
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-442e0e6eb84so39476465e9.0
        for <nvdimm@lists.linux.dev>; Tue, 03 Jun 2025 14:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748986591; x=1749591391;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2mtt7sFFf6VjoTBYrIWNH56E46FCaFvey590NiPF5fw=;
        b=OHGwl0G6rk/mCRnLalxcWD17adWRgx0fwCel2v0k6k0XZ6X7mv7GmgRiwi3iftOoEq
         P5m4jFtSnbenno/7sU6PybuUUDBW2y7iSs+2zs+d+ZeQYLzqmk9K+YuTlJdHti86hCxf
         PkEL6Wl63oGAZdnqFfeK5WSwUJcPA2xk4t1F6l8yLgx0cieteRHMPC3YlLOXfq263edd
         xaSKsU5M1elCJcPTJO7rS0nYVe+tfHw7faROgJcZbyAPouKkXNWwi99h6IKFfVtWSd++
         W0BfLNGNUCYPAN+Y/dFFvw4e31SikRKLJjbsn5xXN72w2ZbrXsNVelwlTDXhE9scW9om
         XYZQ==
X-Forwarded-Encrypted: i=1; AJvYcCURNa6nidgWuRma3aUgid0CZOwxCbpcM8UjRJCQEf1doqzrms2hE5B7+V67oUNwXuDCtUGI7UM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+ZFjptM7tksJcqOMrjB8/hjHyPGI0E7DV7aDnsnxK9C9/u7sj
	CiOqhEBcEEruetQjD9FQXJfMb3p6hsNLB0KWd28mfnRenw9JIuqVensItM6rBwHBz87LYnoDNQw
	wodzjT48E6gDULEDqog9RzNze+oKWkEl93w3rZsCY8gX/eq5gPQy2qWkbuA==
X-Gm-Gg: ASbGncvVr9Df6lN47wIZvWeaiyIzRmNfOkbap4sCkgtNVvCp+8x1G+g8uORc3nLZXmN
	rb+ps3THHDi5yuYpXcr9ZZPJh5gpl98b3816xtnHFG62HMsbPop5qSonXIeMpv+2mBx217PuhX9
	mpPkMQADOGeadIMePYo4LrtYyetLuXIaixrARENVfSnH2lpMAoG1SkQauxJG9NJESl7Vz7Wba21
	BOCa0pMBjMC6Cysk66M6VBBlCj1+xu0ea7he3RkZdFcR66U8JAwSCDPEDlKjkWt4qeFQvZFfzEL
	pN38XiPU8VKeYp7tu04v5G6Pcn6KKddnXOhBqm873KQpOjK6WHAGewYGse1eJ6lH4rId6QwqVL7
	QQ0b9qA/bh4sc0Lvlb6ZroQf9atjq5xfOqu/gbcw=
X-Received: by 2002:a05:600c:1c29:b0:450:cfa7:5ea1 with SMTP id 5b1f17b1804b1-451f0b156acmr1969185e9.16.1748986591595;
        Tue, 03 Jun 2025 14:36:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdUILqMKnan6FhGr5tfSPLCbuCD83DCR7fT4qWTAi9vJJDwu/bWvBe5am5UhPIPoj1jIniiw==
X-Received: by 2002:a05:600c:1c29:b0:450:cfa7:5ea1 with SMTP id 5b1f17b1804b1-451f0b156acmr1969055e9.16.1748986591233;
        Tue, 03 Jun 2025 14:36:31 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0d:f000:eec9:2b8d:4913:f32a? (p200300d82f0df000eec92b8d4913f32a.dip0.t-ipconnect.de. [2003:d8:2f0d:f000:eec9:2b8d:4913:f32a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d7fa2333sm173757825e9.11.2025.06.03.14.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 14:36:30 -0700 (PDT)
Message-ID: <b80b62dc-76b9-4b3b-b980-7fa3584c9762@redhat.com>
Date: Tue, 3 Jun 2025 23:36:28 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/2] mm/huge_memory: don't mark refcounted pages
 special in vmf_insert_folio_*()
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Alistair Popple <apopple@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Dan Williams <dan.j.williams@intel.com>
References: <20250603211634.2925015-1-david@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250603211634.2925015-1-david@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3Jh4ruQRHFQJN8JhTh68S7oxeAZ0N_cc0vcYKmjnIu0_1748986592
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03.06.25 23:16, David Hildenbrand wrote:
> Based on Linus' master.
> 
> While working on improving vm_normal_page() and friends, I stumbled
> over this issues: refcounted "normal" pages must not be marked
> using pmd_special() / pud_special().
> 
> Fortunately, so far there doesn't seem to be serious damage.
> 
> This is only compile-tested so far. Still looking for an easy way to test
> PMD/PUD mappings with DAX. Any tests I can easily run?

... aaaand I should have waited for the cross compiles.

s390x and loongarch are not happy about pud_mkhuge() and pfn_pud().

Need to fence folio_mk_pud() by CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD.

-- 
Cheers,

David / dhildenb

