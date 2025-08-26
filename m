Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7774F31A55D
	for <nvdimm@lists.linux.dev>; Tue, 26 Aug 2025 16:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756226262; cv=none; b=KB7DAzWe/FvA49n8A7FEoQ2vaaZXKgWrbhW3DNOtUCrVI5qTEL38IxHrk7GyfrtWGGlwlmijW+D2jmAlcM1FaYnioMJlugS6BlZXGYxfDXtPLo/FbL4yDJnZyJdXY0R4NH8xNUUV/ixY7nsmPHujH1+/tBmvSBvAZrNx/0cUiQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756226262; c=relaxed/simple;
	bh=AEdKHjzMg9eUTtDLSUEGj/0UGdfhDJa9ocC7lXKnb8w=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References:
	 MIME-Version:Content-Type; b=g9V4AdypVcTZ2wiJCLIzdPhHr2vk3S9dhYEIf7LjDhGateiJJ9WHYGoaW6PcbWBqlCSbAUf0u3Q4RebQash7fyAGCyk+f2rwQsdiRUXn8gb3Stkm4ShTl0h1KIdlvkfIJu24JYoCoNYnJxuUGdaXqA/RZtkApBIajMuTVT3XWVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Es7F9EcH; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Es7F9EcH"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b47174c8e45so5627452a12.2
        for <nvdimm@lists.linux.dev>; Tue, 26 Aug 2025 09:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756226261; x=1756831061; darn=lists.linux.dev;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jyPF/dL+2YqZRv98PVCshXGneATY8Fvhth5O4vhMkWc=;
        b=Es7F9EcHLwr9bQoN9EghlLXVJEuPnoKWkGmXqJKXt1nBDIAfsxBhcU/lNX2kEreS9W
         rCUdjPNbusTZwdEGNMc2ZTtCQPkuiXt8vGPno7l+WzsqEei4FOvSMk8rdYQbZkjRtWd4
         iLDNs6P6WQPyAHPppILu8UoafRACxExuhjFclrTuDMkJqeD08iaaU+jqjPVHvHNtXKmt
         ipsaWRog4Md/oYmn0vhBahPbp8IPCygnxP/b+ujxpR7bhvT3CHO/dK+nHCUMmrOP1I3K
         NsFQLXIcxOWZHLciKwIg/gDS8EdbfxVawPHmZA7elMEwjU+zF+bZMA4u4834SN7rXFUm
         NMjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756226261; x=1756831061;
        h=mime-version:references:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jyPF/dL+2YqZRv98PVCshXGneATY8Fvhth5O4vhMkWc=;
        b=H5gFfjd2OpaD7Xkmg2FQ6bUDdibsvQmkEPIDtDKjhfLonnJ/xLjGMS9plk6/sZcM/7
         lwZz8Rr6cSCs5nqZpxYJ91x4r8VHLOL5nxk2h8xXAcpC92XjEFUF+N9ZL9SEWfWChjzF
         bw0eME0l33VnLn/BH43hlVztfnT/deluXD0v5yxpKNkGYOfjvd2g6VBSXBz8y9zyGtQL
         t30rvMonO8174ENpn534UJbwEIRR7ijUfg4fOmkGIcBIFT69zOHZ/XUIHWCyNRgi5Wa+
         czHOwFNDSKQ5QhZhUF6HAzC7Xe6ThZCxcfHfZYxy0u/A3ZNqZDbnRt9djuNLfD4YnPoZ
         DY9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWCZZfhrYCagNVQU5RMcRwpwiYlF2gi1+kvIi9c6/jHVZBgXGCmi0R14oNxjBFQx+SJmfw34EE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx26cinjJ+0xENaSaMwRw3AFO/YDMDu4wpKX/jYi8RoiSWAWFit
	AzHJw4RW3AODrHDovHoW4Y/AGlaOxbWJia1yQcuTFzaW0E6U4YKM/7R5
X-Gm-Gg: ASbGnctsCQHpLm+PlsUiweImFdhTLlryNefN8VHmUslxWDmBWTGUPijhvcf+XHB4IcY
	OkvbZbmMm+ZEMTwIErU1JWi4PLP0G0n0DyoYzTJksgaUmXhkgdrmkHgZcCGDJu3GS1bXIQqGyE9
	inlpy0psoCrre2bpYsLIRDKhFzkWrE7MQieJu+oCWxglRlmNuB78GRnLGbRBmUp2Ttb7F/CFyXg
	X/CKqqkdBk6hUnvHxmj9OrCHG4bmzrzfNbE6lRUKLhD1e6ZPqB+I3t6xEnvHjskXc28NCYXMP8D
	Gb8ash4uUGJHq+Yk3N7NzbWeKcJOksnY/7xXC+S1zgSfyepQkoG2eZ/2g/bb+7Hc7UuBaQrL6vj
	cpIfkl2hpWsLsXg==
X-Google-Smtp-Source: AGHT+IHkpBzdMdA7eE7qfwfc1lxqW0m87+LkJnM6/YhAHtUnIYSPMtiSiZLKGMu2nLQJcFkeNv4YGw==
X-Received: by 2002:a17:903:32c8:b0:248:79d4:939b with SMTP id d9443c01a7336-24879d4978cmr26372675ad.54.1756226260428;
        Tue, 26 Aug 2025 09:37:40 -0700 (PDT)
Received: from dw-tp ([171.76.82.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-248681adacdsm21450705ad.10.2025.08.26.09.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 09:37:39 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, xen-devel@lists.xenproject.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, David Hildenbrand <david@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Dan Williams <dan.j.williams@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 06/11] powerpc/ptdump: rename "struct pgtable_level" to "struct ptdump_pglevel"
In-Reply-To: <20250811112631.759341-7-david@redhat.com>
Date: Tue, 26 Aug 2025 21:58:09 +0530
Message-ID: <87a53mqc86.fsf@gmail.com>
References: <20250811112631.759341-1-david@redhat.com> <20250811112631.759341-7-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

David Hildenbrand <david@redhat.com> writes:

> We want to make use of "pgtable_level" for an enum in core-mm. Other
> architectures seem to call "struct pgtable_level" either:
> * "struct pg_level" when not exposed in a header (riscv, arm)
> * "struct ptdump_pg_level" when expose in a header (arm64)
>
> So let's follow what arm64 does.
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  arch/powerpc/mm/ptdump/8xx.c      | 2 +-
>  arch/powerpc/mm/ptdump/book3s64.c | 2 +-
>  arch/powerpc/mm/ptdump/ptdump.h   | 4 ++--
>  arch/powerpc/mm/ptdump/shared.c   | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)


As mentioned in commit msg mostly a mechanical change to convert 
"struct pgtable_level" to "struct ptdump_pg_level" for aforementioned purpose.. 

The patch looks ok and compiles fine on my book3s64 and ppc32 platform. 

I think we should fix the subject line.. s/ptdump_pglevel/ptdump_pg_level

Otherwise the changes looks good to me. So please feel free to add - 
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>



>
> diff --git a/arch/powerpc/mm/ptdump/8xx.c b/arch/powerpc/mm/ptdump/8xx.c
> index b5c79b11ea3c2..4ca9cf7a90c9e 100644
> --- a/arch/powerpc/mm/ptdump/8xx.c
> +++ b/arch/powerpc/mm/ptdump/8xx.c
> @@ -69,7 +69,7 @@ static const struct flag_info flag_array[] = {
>  	}
>  };
>  
> -struct pgtable_level pg_level[5] = {
> +struct ptdump_pg_level pg_level[5] = {
>  	{ /* pgd */
>  		.flag	= flag_array,
>  		.num	= ARRAY_SIZE(flag_array),
> diff --git a/arch/powerpc/mm/ptdump/book3s64.c b/arch/powerpc/mm/ptdump/book3s64.c
> index 5ad92d9dc5d10..6b2da9241d4c4 100644
> --- a/arch/powerpc/mm/ptdump/book3s64.c
> +++ b/arch/powerpc/mm/ptdump/book3s64.c
> @@ -102,7 +102,7 @@ static const struct flag_info flag_array[] = {
>  	}
>  };
>  
> -struct pgtable_level pg_level[5] = {
> +struct ptdump_pg_level pg_level[5] = {
>  	{ /* pgd */
>  		.flag	= flag_array,
>  		.num	= ARRAY_SIZE(flag_array),
> diff --git a/arch/powerpc/mm/ptdump/ptdump.h b/arch/powerpc/mm/ptdump/ptdump.h
> index 154efae96ae09..4232aa4b57eae 100644
> --- a/arch/powerpc/mm/ptdump/ptdump.h
> +++ b/arch/powerpc/mm/ptdump/ptdump.h
> @@ -11,12 +11,12 @@ struct flag_info {
>  	int		shift;
>  };
>  
> -struct pgtable_level {
> +struct ptdump_pg_level {
>  	const struct flag_info *flag;
>  	size_t num;
>  	u64 mask;
>  };
>  
> -extern struct pgtable_level pg_level[5];
> +extern struct ptdump_pg_level pg_level[5];
>  
>  void pt_dump_size(struct seq_file *m, unsigned long delta);
> diff --git a/arch/powerpc/mm/ptdump/shared.c b/arch/powerpc/mm/ptdump/shared.c
> index 39c30c62b7ea7..58998960eb9a4 100644
> --- a/arch/powerpc/mm/ptdump/shared.c
> +++ b/arch/powerpc/mm/ptdump/shared.c
> @@ -67,7 +67,7 @@ static const struct flag_info flag_array[] = {
>  	}
>  };
>  
> -struct pgtable_level pg_level[5] = {
> +struct ptdump_pg_level pg_level[5] = {
>  	{ /* pgd */
>  		.flag	= flag_array,
>  		.num	= ARRAY_SIZE(flag_array),
> -- 
> 2.50.1
