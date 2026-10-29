Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793257428;
	b=M6tqlHWG7qMn/MCgH1Iy81gbb0CkebkQDwKoLvncapyDeYwjZE6mSDpoHItUcH1NU6oh
	 uDDJSbf8QdhyRQWq9MQcXY1FgQz3tBwxyit8MaHbXBRyebHY8OqIiAllnyxgRbq0aLILv
	 /ykE2ng3AsqQyK9PI1Zkf+zcRxmGGsbx0Cd3Wz0PQaHO5MBYHgT95PmqA6DCI8xjgV4rY
	 A+JVWZhuI3rXY3yNki4+zWdb6cn7F/6U1DZMPRxVKq0NeKmjbCbasKi7M+jtYc3Y/4+gy
	 uvZfYWbHR3dNdUZz/rMRNTd4jmMWKWjN/Un6YKlwWTO5hGtewdm8cUkJHal9NbrHaLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793257428;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=yl7DWqvy0CCg289e/p2GYHI3s+4vg6zhNzPzSHj/8eU=;
	b=vCuPulZmwAAj1O25kTeSuMV4H80d2l2QuU7FkvIVEdF8x/V5K5YTWcbF6LLFQYBOcC9L
	 DMJVyQnGQQIhXvTd02BdwagKy2gy4EjyJ+sCsxfq2Cg0nLP5NkoNdFdQne3Hj66slxZ4O
	 wfvvrG6S7Iic/H08Bm1/qnhvrTiK2Ym9tHMmvG2xBxBHsE850ExnUyyOuhkj7avs1ZlKG
	 2oBTdhrgbdwqcebDzRJSVekfh/y/agm/qpMildfBDR8s1eYGlUerQfit/eFEGeTlHLJaY
	 0MVr0HJ02JXU4Sh+DCRgOpRpXJ2GyfCThTwNDSc0AnlbbHU4SxCbRL0kqhfjxwaLTGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aXDJX3+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D51606A32D;
	Thu, 29 Oct 2026 07:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aXDJX3+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86371F031EC;
	Thu, 29 Oct 2026 07:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793257427;
	bh=yl7DWqvy0CCg289e/p2GYHI3s+4vg6zhNzPzSHj/8eU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aXDJX3+S9WIGkm05gxDG+G7h6G9o1lZSrnw9kz6XyaMf8koBUlYtvUfzu1qHRZ6lb
	 WG1Xwz8z5yn7HZcnc1Oqd5EwZUfzFzd7B3AyrzdswWtVIbC/yGtzElHATIuW4X6vfF
	 QnvNdzTXm5FIk4QtITgIA/Ou4XrE7x7ydTOqixUsmjt5ZOFE9qu04vTB3GphMWSgFu
	 ugpg2oeWF4xklDA3WStjin0tc4jcUEBi+kT7f9WCnM1hvTDv274SvaZd209AH1SkTF
	 yhzciNJMM2g7i8aMhHeT9f0ULM/8icua8SuvmHAHXBxBj3riVaQ3Z2aD2v7vME9LeD
	 /bH8RVmr3dfbA==
Date: Thu, 29 Oct 2026 09:03:39 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Oscar Salvador <osalvador@suse.de>, Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev
Subject: Re: [PATCH 1/4] mm: generalize vmemmap remap architecture support
Message-ID: <auLvy-8djFBRadho@kernel.org>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-2-songmuchun@bytedance.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903122128.12264-2-songmuchun@bytedance.com>

On Thu, Sep 03, 2026 at 08:21:24PM +0800, Muchun Song wrote:
> ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP is named after its first user, but
> the underlying requirement is not HugeTLB-specific. Generic MM only needs
> to know whether an architecture can safely remap populated vmemmap PTEs at
> run time.
> 
> Rename the architecture opt-in to ARCH_SUPPORTS_VMEMMAP_REMAP and make
> HugeTLB vmemmap optimization depend on that generic capability. This also
> prepares for FS-DAX vmemmap optimization, which relies on the same runtime
> remap support.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/loongarch/Kconfig | 2 +-
>  arch/riscv/Kconfig     | 2 +-
>  arch/x86/Kconfig       | 2 +-
>  fs/Kconfig             | 2 +-
>  mm/Kconfig             | 6 ++++--
>  5 files changed, 8 insertions(+), 6 deletions(-)

-- 
Sincerely yours,
Mike.
