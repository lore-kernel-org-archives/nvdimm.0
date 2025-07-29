Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B61926B76F
	for <nvdimm@lists.linux.dev>; Tue, 29 Jul 2025 07:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753775562; cv=none; b=ll4w5PzrzLv1EllLBy6B5dWXT/iYWmm10h4mWj+U0MLpk7a5NSt9v3zV6BRyxh+HQszkxGRDyn8mWmjbttJTIf+w44nYdqaORG9Ud7e/mZ07mFZO7Q3jIF7iqlC+Aomr6DqmRw2pexdBWx2Wtrv0oIIY+burT55U0ZmAzYqAv6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753775562; c=relaxed/simple;
	bh=up6yHYGnEFam/C87iS/6Oa+IpVXTrFoTn6clDs9PXaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BqDv/mannIWw8KOP764d5YklFicWmTOnYH45HuTOuoxZagD3E0YW8eoFXa/mvLu2Qgo224SIhRe5NiznTIMF37lVv6VjiKDocYLp3Rv/O4WTaSM5x5LRS/WjemtjeJJEv0z15FqahsrcMB31cCstaiKS7odDbi3umzGrU8I722I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j16H41TZ; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j16H41TZ"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ae0d7b32322so875078666b.2
        for <nvdimm@lists.linux.dev>; Tue, 29 Jul 2025 00:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753775559; x=1754380359; darn=lists.linux.dev;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=smgFHrQGxmFhyoF2rRGKiX2BsEmUYdFGX1JZMpUcdm4=;
        b=j16H41TZZ1xOcpqAjRbrpFGqcbfwB+Ln6j3I28CMGtla33Kdj/AApGouNAfXUlxcWo
         +/yQrUPvgZDWiz/nL+kjcYlVRR5Msi8XUfE7tadITgf+qdjGY91zz8R1x2Jx+4WVF7Sm
         Unj99qhqMGgi3n2XhpqaUaCWo3PgKNjYrGYOJ81h/w/0yx0Cr6XAO35P4mckC6Iyc3Mk
         VA/lz53DeG2Na3faPRVj59RoPo/29g+mbT/sTiRLphdN+8AQ3smtPXBSgIJw99feVXlR
         4HNplyznfqrlRRTJgv6X/tI2RbU0MyTml6eKitOW1Qio+SCAWJJKy0kJcRE9cw0oSy0+
         6+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753775559; x=1754380359;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=smgFHrQGxmFhyoF2rRGKiX2BsEmUYdFGX1JZMpUcdm4=;
        b=QCxInFe/gNCKGq4+DOfcosISzFz2bJk9VJQcSippXIIHupAKMcE/GjYFrWW7H68RLa
         W0xoC3YFtL0U25H37EgN3mOa356J0sKkJyRnPgwkPWUOpAQ+5E08hga6GfCcDIV7s9uw
         iP+BwC4hkqavn7BK5QdowPMSIrIM59gy2MUEnXWB3+G5Y4sHHu4qz/XQ0X+pb/RMMiGl
         EGUnEKTDO2ivqESznMXU8E772seR+iZjE7DU0UDEHYdxS4+LY/lNv3ggHzTC4bi5ITFr
         NCfABTq/z5zQHEorD9IqIO5K1QMftU1uCPr5rW8/FTvjt8ByjPL7ylURdN/oSXGzrFzy
         VZdg==
X-Forwarded-Encrypted: i=1; AJvYcCUvBRQPw715577Wh8XWIKKqsEvaA9xjn06PtP6KDxvy2pulB5iGqE6Ihnx+/6UtrNACMz6x4pw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyfDugc9pBTSBPpOSv4on0VdvS78U6rIFlmqcBBDBWov7uG3hko
	ysFCUD3qazimNELgmIPeiL+uErCNcTtJdDeZim0Mbh7PYgyf2RAc7dKq
X-Gm-Gg: ASbGnctWBsKVRJSwI0a84pIJxKNO8xrSbEnabNvffqk00dqq/xt+Pt6skhrct5GYr8u
	OI8rpHv9yzupt/WV/obqdTG5QbMLi6gm+rtbA7xnkhcu4s7BPrOh+j19s8TrXoOZ8D4xoLUQ/bI
	QCRSnmoE4vYLFXjG8EjTVzify7MRTAOZsQIQuhZZVPQGE8+3DgzLC+qr03tmqN/RWJ640dAmvfY
	U8ITft8a/C3FP6fS0j+VKo7NVWBIBfQlKQEQjLhUYHPDnyj/rH05gMR9IVu5SH7cJzZny0ZcxOt
	bEIb8bVKtNoEE5RWw9QclcQxWJdOoIbGcOd3Ln9bgFUzlVBKIvGdHaihmCOeLDC+ZBVhEoR0JSj
	wAMaD5/Mvyi//WSWRjBApbw==
X-Google-Smtp-Source: AGHT+IEV6FhS7BcuKiy2mmCmExHdPH8UplQNL1+hlnfx7GXoYFJTZHp4rwskMVqcf+8guTBozWXdIg==
X-Received: by 2002:a17:907:6094:b0:aec:5a33:1573 with SMTP id a640c23a62f3a-af619aff33bmr1645989666b.41.1753775559042;
        Tue, 29 Jul 2025 00:52:39 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af6358a1aacsm549963466b.49.2025.07.29.00.52.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 29 Jul 2025 00:52:38 -0700 (PDT)
Date: Tue, 29 Jul 2025 07:52:38 +0000
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
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 8/9] mm: introduce and use vm_normal_page_pud()
Message-ID: <20250729075238.44l3jgz2l6fbss2j@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250717115212.1825089-1-david@redhat.com>
 <20250717115212.1825089-9-david@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250717115212.1825089-9-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, Jul 17, 2025 at 01:52:11PM +0200, David Hildenbrand wrote:
>Let's introduce vm_normal_page_pud(), which ends up being fairly simple
>because of our new common helpers and there not being a PUD-sized zero
>folio.
>
>Use vm_normal_page_pud() in folio_walk_start() to resolve a TODO,
>structuring the code like the other (pmd/pte) cases. Defer
>introducing vm_normal_folio_pud() until really used.
>
>Reviewed-by: Oscar Salvador <osalvador@suse.de>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me
