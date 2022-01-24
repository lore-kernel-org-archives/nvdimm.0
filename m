Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ECF29CA
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 07:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Mao8rTEmKkOjo8x2Hq6UPTus4x5HRQqleMU3/f2v4+8=; b=qiBZvvlnUtQQViXRuVHdJLEMSn
	LuQ8hWvmiZgXfqsC2sEzmF6F/M+KQVWbWsM6OeHkqN2hAC0K3f9pwMeLzSDXLugK2u45lX4LpCpIU
	3ROynwEKKjABNmroBa6YEkliJ2VEdtUi4QJS25QfrKLg8mMC+Si9d6Zwx1DBZoAIFyp6/n6xgege5
	0gLvXaCaa99dSE/FNpRFhobv4zHMObTVBj3OBct0EExWPzYmyIsToiBIb0VSFW5Wn+PxppQs5QLNW
	+3XLvax0B5gM97OxIAydjae+D9VkwunjkEG/uZx8AsTcJEImQcDOrFzTV1mlqw2MALuo77JEW6pta
	FwWPVy6g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nBtuD-002VGp-9U; Mon, 24 Jan 2022 07:36:49 +0000
Date: Sun, 23 Jan 2022 23:36:49 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
	apopple@nvidia.com, shy828301@gmail.com, rcampbell@nvidia.com,
	hughd@google.com, xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com, zwisler@kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/5] mm: page_vma_mapped: support checking if a pfn is
 mapped into a vma
Message-ID: <Ye5XEeMYt8c7/iMV@infradead.org>
References: <20220121075515.79311-1-songmuchun@bytedance.com>
 <20220121075515.79311-3-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121075515.79311-3-songmuchun@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 21, 2022 at 03:55:13PM +0800, Muchun Song wrote:
> +	if (pvmw->pte && ((pvmw->flags & PVMW_PFN_WALK) || !PageHuge(pvmw->page)))

Please avoid the overly long line here and in a few other places.

> +/*
> + * Then at what user virtual address will none of the page be found in vma?

Doesn't parse, what is this trying to say?
