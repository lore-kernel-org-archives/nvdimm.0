Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 531C722280C29
 for <linux-nvdimm@lists.01.org>; Tue, 26 Dec 2017 21:24:24 -0800 (PST)
Date: Tue, 26 Dec 2017 21:29:10 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 11/18] fs, dax: introduce DEFINE_FSDAX_AOPS
Message-ID: <20171227052910.GE24828@bombadil.infradead.org>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407701943.38751.8997225433943672290.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407701943.38751.8997225433943672290.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Dec 23, 2017 at 04:56:59PM -0800, Dan Williams wrote:
> +int dax_set_page_dirty(struct page *page)
> +{
> +	/*
> +	 * Unlike __set_page_dirty_no_writeback, dax does all dirty
> +	 * tracking in the radix in response to mkwrite faults.

Please stop saying "in the radix".  I think you mean "in the page cache".

> +EXPORT_SYMBOL(dax_set_page_dirty);
> +EXPORT_SYMBOL(dax_direct_IO);
> +EXPORT_SYMBOL(dax_writepage);
> +EXPORT_SYMBOL(dax_readpage);
> +EXPORT_SYMBOL(dax_readpages);
> +EXPORT_SYMBOL(dax_write_begin);
> +EXPORT_SYMBOL(dax_write_end);
> +EXPORT_SYMBOL(dax_invalidatepage);

Exporting all these symbols to modules isn't exactly free.  Are you sure it
doesn't make more sense to put tests for dax in the existing aops?

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
