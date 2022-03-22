Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C4AA31
	for <nvdimm@lists.linux.dev>; Tue, 22 Mar 2022 08:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JN566uKc3ktadTMCdQh9ajk9oRH/gQn83cevsJDA16g=; b=WzTG+Kri6NXIKO65agZ9YL1KcE
	+7l44pyNx6KCZIn8yUvwbZMvNBC6PeA/dLZt+Q7+sJKDDpXGG72Deis+K8Gb+YpdPx7MhIy5Rj16K
	12BQVMeSiB1l6m1N3VmF3OkfDOfsmnKDu+o78MaIv/BzBUQ9VqjDTGL39pkUHNiWEoPbe9jl1bnZR
	Kfhb3/4qI99IGspiAwFRqssW8Ml56Da8TNNxH7CQWQ8+COZd/JO2pchMUQfT6zB3aFJelGuZ6nABd
	KM223BOwIOxhuL+eBB9cGjdnzlnLzc/a9cv4jjGRp3CVtNavfeyWAGX/2+WfZ+rRyflLC7Q4D6TLN
	Zg51C/Cw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nWa6M-00ASLb-Cr; Tue, 22 Mar 2022 08:42:50 +0000
Date: Tue, 22 Mar 2022 01:42:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 2/6] x86/mce: relocate set{clear}_mce_nospec()
 functions
Message-ID: <YjmMCjDuakvTzRRc@infradead.org>
References: <20220319062833.3136528-1-jane.chu@oracle.com>
 <20220319062833.3136528-3-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220319062833.3136528-3-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +EXPORT_SYMBOL(set_mce_nospec);

No need for this export at all.

> +
> +/* Restore full speculative operation to the pfn. */
> +int clear_mce_nospec(unsigned long pfn)
> +{
> +	return set_memory_wb((unsigned long) pfn_to_kaddr(pfn), 1);
> +}
> +EXPORT_SYMBOL(clear_mce_nospec);

And this should be EXPORT_SYMBOL_GPL.
