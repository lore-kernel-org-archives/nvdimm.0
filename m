Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B09366
	for <nvdimm@lists.linux.dev>; Wed, 30 Mar 2022 09:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JOUQtjOVGnzMTvrAXciZzi4fdOwU/6lDJpYr4hVgSSA=; b=giUiOmZYZCJ1HxXTcMFX1ql0TH
	ixZddAicQAT4cAynhD/AArtRj4bwqDhIeBsfuE2ctVonugmaQdKTiVVZ6J/BYkmbBJmV9LpE4BkTb
	jRLYyZAa7O5Y17OHjGq72atju9rbeeUAz6RHq719Sbz2fXF/5SodeNit+8aOWvcOXAFziSoFBTuQ6
	lxCR7gcPfd7x7BQVl9ZbbslVn01uiY5ZEiosthLA0TlCujWP3FL24NhLCnp8Og20b/dyO90oyqPyH
	tcYYmFJwmGzh8bsYB/uIhrufspLgLCETvpxjx+201yTx/KjSALTKGQf/9UHt8Vqq/azrQo9wSnCaH
	WqFW4EsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nZUCI-00Eu94-NA; Wed, 30 Mar 2022 09:00:58 +0000
Date: Wed, 30 Mar 2022 02:00:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Yang Shi <shy828301@gmail.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Hugh Dickins <hughd@google.com>,
	Xiyu Yang <xiyuyang19@fudan.edu.cn>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Ross Zwisler <zwisler@kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Xiongchun duan <duanxiongchun@bytedance.com>,
	Muchun Song <smuchun@gmail.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: Re: [PATCH v6 3/6] mm: rmap: introduce pfn_mkclean_range() to cleans
 PTEs
Message-ID: <YkQcSusH9GCB0zLk@infradead.org>
References: <20220329134853.68403-1-songmuchun@bytedance.com>
 <20220329134853.68403-4-songmuchun@bytedance.com>
 <YkPu7XjYzkQLVMw/@infradead.org>
 <CAMZfGtWOn0a1cGd6shognp0w1HUqHoEy2eHSWHvVxh6sb4=utQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZfGtWOn0a1cGd6shognp0w1HUqHoEy2eHSWHvVxh6sb4=utQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 30, 2022 at 03:31:37PM +0800, Muchun Song wrote:
> I saw Shiyang is ready to rebase onto this patch.  So should I
> move it to linux/mm.h or let Shiyang does?

Good question.  I think Andrew has this series in -mm and ready to go
to Linus, so maybe it is best if we don't change too much.

Andrew, can you just fold in the trivial comment fix?
