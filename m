Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806202EA171
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 16:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177099; cv=none; b=pt/COGtaAwRo9ArEZFiYs/XRvRncsOajnxrcet53WbjSjYE+X2mMWZqdwEXOZMol+r2YAs8XpIrO2d7J4P4iydD2THkb+ZuypEHfcRveR1HTy+lVpc45VmoCToIAYmGDsqWUX4JTY1ICpwAeCv/MLGoR4Wh21ZY9y0ukwrSi3EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177099; c=relaxed/simple;
	bh=EV4z8OrdAmsdvSsal+Eul/nlTIQTkqoRdK7bUO8Fg3o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EiXSnptbQz00HipDUj4ORLaAAp3ALWW4tUGd89qE+E83gVh88hYdfEEwO1tigilTJhuXfeuq0RZmWzYSBEj41xcdZBO43mrbfe7Xv8eTWP0f1cNMgGvZfRbGk8PROtSELM0FsTz30dQv3NJsfcBlZo23q/t0rpYuZ6e8Pi+0xaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FC0D4iz4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FC0D4iz4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750177095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ggyx/jOc4d7bYwabgJy5rrVWttDhaySL1H54el9rbuo=;
	b=FC0D4iz4C/KPhLMKQy29UEmBDHAOdhfsNKl7A8isXPtvGaP7oahYSqEa+dmmDCgE2fqzgP
	p97kVneaUDHrN7BZ/Z0s67Cq60FVx/RcJXBkcu2OkzzCgsE5d0uCBbCS27JmQnodb+Up55
	2toA7uj6DUh8OSXMbV3xIQ7LwtCGbxE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-IE4nxhG1M0uyvP3y8VmFHQ-1; Tue, 17 Jun 2025 12:18:14 -0400
X-MC-Unique: IE4nxhG1M0uyvP3y8VmFHQ-1
X-Mimecast-MFC-AGG-ID: IE4nxhG1M0uyvP3y8VmFHQ_1750177093
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f7f1b932so3671308f8f.2
        for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 09:18:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750177093; x=1750781893;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ggyx/jOc4d7bYwabgJy5rrVWttDhaySL1H54el9rbuo=;
        b=Ofz7rsgd0BMocU7VUslHcykpTfgUn+oQZpAQPs5nD9IIVEaNK0XE2AVr791JefR3ds
         YK2Tolwp8EyO0HF/cbNqbtg5zKHvi9t1L6YhGIkSa7cD1fp8v3cr8gnJ7XVuXICiXcBw
         QVvlJCDkvB17Yyz+8Yrxjwst37R7oKTRC3i6TwrP0xjTfgUr0M5fuzEQ2uyOCxrPFTIv
         RvRsbvLWLet67hETKkKdOTI/+Ua/Hk9HC5O6Ai54XxJdgEERo/PwrZXERApoVJa1jCI4
         fq7CXWtbqfU7zRLtsrATDNHhHTuyO0I04JcuMIRHTDRnCT5WY6bY07/v+U6hMy1vyGbf
         xQ6g==
X-Forwarded-Encrypted: i=1; AJvYcCXnCMY7KFXuYNANtU+lLZOPMRDsmg+0dTZFEqzZxQFWiDNheb+LW/0uk+m9KW3pCLHyZ+2KIX0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWB6YLk7DwfiPT+phhO2lpRpfik6TDgnRykKGVqCBzNerR5IL0
	L0IWsCrhJUkJQHtj8d9RrsZDZa7g12NnUqlHskarBXK93kiCAADeYoS4T1Px/LtDUq6B6wvUlQH
	BbNRS+lZUftKtJ7y8m964slbcxYy/tcsur9KJEclwOuwuWzow/bXv7RBZk34ONq2m0e57
X-Gm-Gg: ASbGncvjrPnzwT4eq3yeZJk+aunOHDi4QLk7IFFQS8JUXpo33P42zyYHA6a7NOlpYHs
	gCxDW/1aavtIPWGDPSUbfmoc/cd+hEvVbWlkh5t1myUQjlFlyU6gPwnLjYA6qpRBG7D2xMEmLVv
	zSC3JMOZBVY5YQZuS59+OvdteV8UFDabYq+hle/oge3BP+8F1UCApCFh1lP/bMgWzSKgiUN0U4j
	Wc3LdmKDs/A7uENmHIoe1WEbMHjs8pJQK6rujmHPVl+KNPYFp5WP3WSGsmzy0iTgZ2U1yZEJk9R
	Nm7n3SIV/zmcimDzKNgEKODwlhkoKITi18NyY7eUzQBMlbHIPTY4kbXiORjj207ATI0wokf5ObU
	LyiGF4gVL2a6LaB0sm5x0TArJt0Tzniy2n6g+oXkDlrk/PhE=
X-Received: by 2002:a05:6000:310d:b0:3a4:e7b7:3851 with SMTP id ffacd0b85a97d-3a572e69d13mr12381481f8f.58.1750177093171;
        Tue, 17 Jun 2025 09:18:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGy6w26SNF8JRiuV5RMogom+yqNk+oRLR2pX8ZZtPy7a4e3of9FalfrLKf1qQuD1a20chDIUg==
X-Received: by 2002:a05:6000:310d:b0:3a4:e7b7:3851 with SMTP id ffacd0b85a97d-3a572e69d13mr12381435f8f.58.1750177092692;
        Tue, 17 Jun 2025 09:18:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f31:700:3851:c66a:b6b9:3490? (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b087f8sm14640954f8f.53.2025.06.17.09.18.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 09:18:12 -0700 (PDT)
Message-ID: <e7a6b0de-3f2a-4584-bc77-078569f69f55@redhat.com>
Date: Tue, 17 Jun 2025 18:18:10 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 00/14] mm: vm_normal_page*() + CoW PFNMAP improvements
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250617154345.2494405-1-david@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2u1q-fSEHx8r6yZlZNovzQtObVdtxlmo_XNylwq8OBs_1750177093
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.06.25 17:43, David Hildenbrand wrote:
> RFC because it's based on mm-new where some things might still change
> around the devmap removal stuff.
> 
> While removing support for CoW PFNMAPs is a noble goal, I am not even sure
> if we can remove said support for e.g., /dev/mem that easily.
> 
> In the end, Cow PFNMAPs are pretty simple: everything is "special" except
> CoW'ed anon folios, that are "normal".
> 
> The only complication is: how to identify such pages without pte_special().
> Because with pte_special(), it's easy.
> 
> Well, of course, one day all architectures might support pte_special() ...
> either because we added support for pte_special() or removed support for
> ... these architectures from Linux.
> 
> No need to wait for that day. Let's do some cleanups around
> vm_normal_page()/vm_normal_page_pmd() and handling of the huge zero folio,
> and remove the "horrible special case to handle copy-on-write behaviour"
> that does questionable things in remap_pfn_range() with a VMA, simply by
> 
> ... looking for anonymous folios in CoW PFNMAPs to identify anonymous
> folios? I know, sounds crazy ;)

I'll mention one corner case that just occurred to me: assume someone 
maps arbitrary /dev/mem that is actually used by the kernel for user 
space, and then some of that memory gets allocated as anonymous memory, 
it would probably be a problem.

Hmm, I'll have to think about that, and the interaction with 
CONFIG_STRICT_DEVMEM.

-- 
Cheers,

David / dhildenb

