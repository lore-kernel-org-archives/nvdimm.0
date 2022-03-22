Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0F762A
	for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 08:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PE57yUUD9SrPCLBbUCyjgGk3MoukBa6T3fWyxi6SrV4=; b=s4AgvJNu5YIQCv3TC7zPFv8LNc
	GOgCI8kFvtUZqetr9c7bbfPL/wm2WY8OyeCTJPq5sVwINdEfD/F4nGJFm0MabHV1YxcMEPtDq5zMr
	aVWK94ftsDERQs4M1s8xykXQawIODQJ9/VSlAgwubD7+E6Sqa4WDLYKo06Ro+ChAVSet2WNSLsSC6
	p6G/kzHL7j2VVuoLbwN11wdfYSKokrgs8oU2giY8hUecYj32X8sgq7c5q0jrLfSnVVeZxkOSaV7/U
	LxTy4v+4V2YJ02TfzcvxBS33MjniXU/wWIVFBSN3kOt9VkbctOH5d632AysD2xG3MX6FkIINtg44/
	dp39V0LQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nWZxz-00AQur-4e; Tue, 22 Mar 2022 08:34:11 +0000
Date: Tue, 22 Mar 2022 01:34:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
	apopple@nvidia.com, shy828301@gmail.com, rcampbell@nvidia.com,
	hughd@google.com, xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com, zwisler@kernel.org,
	hch@infradead.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, duanxiongchun@bytedance.com, smuchun@gmail.com
Subject: Re: [PATCH v5 1/6] mm: rmap: fix cache flush on THP pages
Message-ID: <YjmKAxH8y2cjcJrP@infradead.org>
References: <20220318074529.5261-1-songmuchun@bytedance.com>
 <20220318074529.5261-2-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220318074529.5261-2-songmuchun@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 18, 2022 at 03:45:24PM +0800, Muchun Song wrote:
> The flush_cache_page() only remove a PAGE_SIZE sized range from the cache.
> However, it does not cover the full pages in a THP except a head page.
> Replace it with flush_cache_range() to fix this issue. At least, no
> problems were found due to this. Maybe because the architectures that
> have virtual indexed caches is less.
> 
> Fixes: f27176cfc363 ("mm: convert page_mkclean_one() to use page_vma_mapped_walk()")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Yang Shi <shy828301@gmail.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
