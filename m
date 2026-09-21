Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B311C427F8B;
	Mon, 21 Sep 2026 12:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789993555; cv=none; b=a5d5xHjhNUFzqDeccS1Lw9H5GaO17PU6vfswZ8yGqOjBqlzL1wPOKrnONKzgtN6wGm0lumk0BUEP5Ze6GyQSTmEy0Q9GChbTvDAFiAF+yD6xSFQpnMapTczNpuW8U/jJN6a0L/H8MWZmUj2vqa3zUN7G3E/hkkh8Pjueo8AcojM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789993555; c=relaxed/simple;
	bh=2KCxDgAfRk1E0e6fkZpJQBC1l+rbvo8MkXgXjnUJOJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eMYB8t1nB1ZNligYoHYx7+mshHKmhObPRPhdebjTECPMTr2gRt+DS9BA/NI7RYw83NCewuUOsoGZBQcZsZYbV8nogJCubJBtVXUw+Eoe6bboK0Y3z9SfmQ8OaFHLnxHhRCEs8BCOW9GBMhd4h6eU4TvBoHy2im6e5IvIjsHM1oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=macFNaFB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="macFNaFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02D41F000FF;
	Mon, 21 Sep 2026 12:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789993554;
	bh=ZAdc5FO1i9grgLMSpUoVxK5/k0rBXY6fo8pkrWSvNnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=macFNaFBbpsX9/6u2Pgy1/4vXZApG1r1E4HHNo2+PQpwfaNoImd3nZ/pijk8QyBh7
	 5Qmmt/2tsXtkNyT3ZX/mp9eteN28sUEJEmDNjIpyGk1K07An6f6D/26tKJ55duYBhN
	 zCqlGduHUAwTP0TnBFel3P8TjyNKbEYzYdVUugR6zof6RI8UfXkR+09l4gh1TWYeZb
	 bZTNUyM/IddcMWZC4p3VW9UPLst/pHTnVL6cLIfgInkXwOMdcs7qshacZbTADsBWpj
	 gLRs9iKUiEwPUP7jTRaJGzywvo2PXXqZy//mc/0ujyJsRG83pSEHDtBCqwoS9w55Lr
	 97aZIGomqcakQ==
Date: Mon, 21 Sep 2026 14:25:46 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Ira Weiny <iweiny@kernel.org>, Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev
Subject: Re: [PATCH 1/4] mm: generalize vmemmap remap architecture support
Message-ID: <arEiSiD4-3c5UkHf@localhost.localdomain>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-2-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
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

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs
