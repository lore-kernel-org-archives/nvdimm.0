Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E4B29CA
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 07:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Z1SKDv0bpVZtdYt8dV9PbGHjlVKjS9CGxhne7lpfIKs=; b=HDx06FnTRYyxKVIj4EE9rnXWHR
	oiX3X8ki7OsTBxHU1B468OnIK+t4wbC2mMm+eTg1RE1Izzbtpqk0hEtjppLoUoqXaQVd41SRDycBE
	o+BiRhtMnaVtuAO9mTsT5Co0aSry0x+9DqkE+zoKL2SJg1Kj0UBTHJneqpktcKNdpv0TAw5ehKiou
	Zvhgb22eFOr37nP7j4O8ajg6sgJPLGl8n/kzGFjYxVHF4iJ33mXda1kT1rFtYgKBhc2dB9e4yj5nQ
	+9Nqr1bFfaONIt0aAIpaYOmF+m8p/jHzpk5Z1axhAkUP4gIhwWaHwb2f/zHoww7EzcNMzYFJiZKGi
	qKbQdIww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nBtyv-002VxD-Ad; Mon, 24 Jan 2022 07:41:41 +0000
Date: Sun, 23 Jan 2022 23:41:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
	apopple@nvidia.com, shy828301@gmail.com, rcampbell@nvidia.com,
	hughd@google.com, xiyuyang19@fudan.edu.cn,
	kirill.shutemov@linux.intel.com, zwisler@kernel.org,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/5] dax: fix missing writeprotect the pte entry
Message-ID: <Ye5YNbBbVymwfPB0@infradead.org>
References: <20220121075515.79311-1-songmuchun@bytedance.com>
 <20220121075515.79311-4-songmuchun@bytedance.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121075515.79311-4-songmuchun@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 21, 2022 at 03:55:14PM +0800, Muchun Song wrote:
> Reuse some infrastructure of page_mkclean_one() to let DAX can handle
> similar case to fix this issue.

Can you split out some of the infrastructure changes into proper
well-documented preparation patches?

> +	pgoff_t pgoff_end = pgoff_start + npfn - 1;
>  
>  	i_mmap_lock_read(mapping);
> -	vma_interval_tree_foreach(vma, &mapping->i_mmap, index, index) {
> -		struct mmu_notifier_range range;
> -		unsigned long address;
> -
> +	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff_start, pgoff_end) {

Please avoid the overly long lines here.  Just using start and end
might be an easy option.

