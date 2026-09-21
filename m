Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB75D3AE1A8;
	Mon, 21 Sep 2026 12:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789995207; cv=none; b=VIOcG7rRSdVNLxsC7skXuGZOq3OZyotHfNyubrw0yf1oiPoNXo05FfPjYpSEKAEYzu5x4ZkMxFl/C+Q5QOUz54g+Lu86O81jDMK6OZ1bL1b2PpZXkdujXryZGsk/WDDf0gVEtGgJYGAPH3hh+U14p1X/0PkvVGge2lD1bHzbYkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789995207; c=relaxed/simple;
	bh=n9rDEJIzZr104TrF0pw5cDt2owmwZL4ewpRRtqUnaqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jh3UceSLlRu0dArrrLhNIstRwFz0KGBywbV5jPv13rMwFoKwtyd96Ah4QY7me4h6d2tE15IMN5mdJ2IUhbRQiVwJLEWgWMxbbEVBwK53btPah1XLwXgOGgjMYP4aAhcqd45T1uwmBCmtSD1vEUaux8gL7Pm+HcgwcARwxZMgcXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dFrt7yys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dFrt7yys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A7F1F000FF;
	Mon, 21 Sep 2026 12:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789995206;
	bh=2DiedpCEs1UwpptAonzE7XEdXRU4rM/b7fTnTmQH/H8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dFrt7yysP9TttxshusGVo+wqV0Pa58hUk2WG6svLyuxuUeTN6Yk5xP10tOPEsLtEC
	 EnWcSnS+rffkxsidpoYgAsl6IafaBtTVk4Lfi2EZvWpntEjoIZwt+BpcRs866RQvGM
	 /XQuKCjWS1arBOebH7Vat0gne4zFqjsHpp2cCCLZg1d1jfgydoBJgOS4gLJJcttl7a
	 DIMXqEEPogHji5Y9xurwB/+uI5r25AlYut4l3h6Jte/XS+yun1Ul5VICrwIOzJE3wR
	 mqkamTH6tFQM4ZS4Q4nI2U/a7WSgZPXBc64svBSZgtQ1OgMskfW19zi+HobOPEYDVm
	 Hvc/dKRCsJ7FA==
Date: Mon, 21 Sep 2026 14:53:18 +0200
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
Subject: Re: [PATCH 2/4] nvdimm/pmem: avoid HWPoison flag updates for clean
 pages
Message-ID: <arEovvqEpquODZ6X@localhost.localdomain>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-3-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903122128.12264-3-songmuchun@bytedance.com>

On Thu, Sep 03, 2026 at 08:21:25PM +0800, Muchun Song wrote:
> pmem_mkpage_present() is called after persistent-memory poison has been
> cleared. It only needs to clear PG_hwpoison and undo the MCE nospec state
> for PFNs that are still marked poisoned.
> 
> For clean PFNs, test_and_clear_pmem_poison() has no semantic effect, but it
> still performs an atomic clear operation against struct page flags. That is
> unnecessary today and conflicts with the FS-DAX vmemmap optimization added
> later in the series, where clean PFNs may be backed by shared read-only
> metadata.
> 
> Check PageHWPoison() first so only poisoned PFNs update the page state.
> Poison recovery keeps the same behavior, while clean PFNs no longer require
> writable per-PFN metadata.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Then change itself looks good to me, so

Reviewed-by: Oscar Salvador <osalvador@suse.de>

but any reason not to hide the PageHWPoison check within test_and_clear_pmem_poison()?

 

-- 
Oscar Salvador
SUSE Labs
