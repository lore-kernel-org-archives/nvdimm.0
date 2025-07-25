Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E940233D9C
	for <nvdimm@lists.linux.dev>; Fri, 25 Jul 2025 02:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753412171; cv=none; b=au51qppN0H/Ka9IV7cPZUAfEkA4CiUsya20NrYVQliuVBuhpHl6zxHLgvo65YWE+CPfqh9s/bRtnpLQW+dzq4ubRGjg3nv9RK3wjTks0OG/Qk9BPYte3f/VqTB/RdPR8zldA6nh1zoj66DlLielz2GiHABSU54ElwlZBN8pT0w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753412171; c=relaxed/simple;
	bh=e7r351WHBKXYVy/qybPJUX5Acqx5iciPw/mxGw6enRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R4U5s3Fd1urDz3ejrqvwdjmw8Et/8DZzcooFYlgEmoZ11U+TzWrUt7NTt76u5KxpZOv/zfubKeuwYRk9hchbfA4vf+W/9AsLOm1kcO/wELA7bHLTLLAR+7rqa4qpPTo6N/FaBH9Q7SihPPtn7NRByGydYsSPC5k/RDNxX78/vJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zl3e26aJ; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zl3e26aJ"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-60bfcada295so2724532a12.1
        for <nvdimm@lists.linux.dev>; Thu, 24 Jul 2025 19:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753412168; x=1754016968; darn=lists.linux.dev;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FzGOuzDhEi3TMJulLXZr4GFUL3lm8OH7E+i1imGtL3w=;
        b=Zl3e26aJHng5xZ6UUoQgeRNdWKYxMJt1HgUsIBVo2rkJt+HDiPCdDrfercOnOR+1Y+
         vZyqODesPWhGSooqMNVJfmn1T7X0FQgjkLP0SUG48FxyEsr0aUsl8eZEhgENgkVC4LR5
         BeJPlsq22SfVCgqJlvMZq9kR/REkINTbRt5H3elmMExuxlsb4hqSNxWrTRreGjZYzYJ+
         zc3I8KWyRj28j+vtQVNi/e/1mm4Srm7H22gvQCoZ5/Iuf2d5plLf6QL8M+iwNxkSqi5B
         kDTgSkHxxvoAdM6Pnj5xGh+x+YSPD5/7IbDUzLr2yedLUNt05VX4xexRIrLknym8kGCZ
         LJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753412168; x=1754016968;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FzGOuzDhEi3TMJulLXZr4GFUL3lm8OH7E+i1imGtL3w=;
        b=dBmfdWGDWE40Ez4lH+0amdCxdX5UZNE8F/0lzu3Amf9C5EoMnBqtgqXXySkL2ssJPn
         xS2CnCxdxVQXDoD37K4XfuD6NpOQzZ1GmLSG0oj/GQTDETMv6mIjjGdp+BAPFWiYxk21
         5zNwkYjF+Z6OsloWl0OcDXVeO4drqcOt0iGPHr55dpw5e0qFchK3lJWObkanPpzynCQY
         2g9W/R36OV1B/eeoelStTfvLV+FAqMznQ+Ud9BtDURpc1V8PEzQj1TmRRNUyzGTPdQRm
         ZWq2UyAYPBUCeC84ZZJMdLtva1OqNtRJXj+2OoEzP3932BZ6SZwPYF6fSvhaYfwzO7UI
         6/rg==
X-Forwarded-Encrypted: i=1; AJvYcCV2f7u7g3ANsENEomlt4/a1i7u7TDrDIaWGPwCyM0GLyRopwLST9xa5KOsRZNnNq58iOJ9jwZ0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZvaB8misgPsmR5nvFbi9rlXWrvIak/CU4AaQyfCrt8VFEb1jv
	Y0t+5c6gdroO5Z/mXrJRXKtSPss0VMsA0xcyirSoGbzDjLDQT01AKM5u
X-Gm-Gg: ASbGncsolnJsPCM2OhBb1YEM5KFwW1gHzRF6r0x6WeufliriHU62mN2RllWt8WAfVFd
	iecbWXU/zXEU6uf83qbCyup9ocsIBrjJFTHNQ/KOV1NZxuE4v5kdas3oUQIq+ziFZZo6R9RpbNg
	CNCmqdCoGaYx83NeeAFY0+ipGyjd+m7fPqdGrdzGRto3Jv/zvfWeUlhEwxv6Tbwa8Fyow2ad9JT
	EoHq9ZKBjV953uv3qNRhNrqB2MA12FXMHNdTlc7H7e9PbAxgP8m+ff0cu38VXvo8XCqHksxQupS
	xH8gSYQshi5CkP6+kyezPcY2REP/xPKyulQFhOuoaZpy3kWgCfJ71TwfZuWEyb6nI1q0d0Qu1EA
	SQCNus2c4jfoufGUfU8OdJe2mZn/+qGZw
X-Google-Smtp-Source: AGHT+IHhkClQ6+YPICgV57QIRUaI7tNGak2Dw44PbpFkJLABqr49v5gkdZqRJ5Z7WHZCF0LZz7A43Q==
X-Received: by 2002:a17:907:3e1d:b0:ade:4593:d7cd with SMTP id a640c23a62f3a-af61c8a6743mr34848666b.13.1753412167981;
        Thu, 24 Jul 2025 19:56:07 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af47f44d85esm196204966b.89.2025.07.24.19.56.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jul 2025 19:56:07 -0700 (PDT)
Date: Fri, 25 Jul 2025 02:56:07 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>, Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>,
	Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH v2 2/9] mm/huge_memory: move more common code into
 insert_pud()
Message-ID: <20250725025607.vi7n6wvwmzajcv3q@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-3-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717115212.1825089-3-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Jul 17, 2025 at 01:52:05PM +0200, David Hildenbrand wrote:
>Let's clean it all further up.
>
>No functional change intended.
>
>Reviewed-by: Oscar Salvador <osalvador@suse.de>
>Reviewed-by: Alistair Popple <apopple@nvidia.com>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me
