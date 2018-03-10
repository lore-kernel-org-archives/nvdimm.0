Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7716C21E08286
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 01:40:17 -0800 (PST)
Date: Sat, 10 Mar 2018 10:46:33 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 02/11] xfs, dax: introduce xfs_dax_aops
Message-ID: <20180310094633.GA31604@lst.de>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066489984.40260.2215636951958334858.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152066489984.40260.2215636951958334858.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

> +int dax_set_page_dirty(struct page *page)
> +{
> +	/*
> +	 * Unlike __set_page_dirty_no_writeback that handles dirty page
> +	 * tracking in the page object, dax does all dirty tracking in
> +	 * the inode address_space in response to mkwrite faults. In the
> +	 * dax case we only need to worry about potentially dirty CPU
> +	 * caches, not dirty page cache pages to write back.
> +	 *
> +	 * This callback is defined to prevent fallback to
> +	 * __set_page_dirty_buffers() in set_page_dirty().
> +	 */
> +	return 0;
> +}

Make this a generic noop_set_page_dirty maybe?

> +EXPORT_SYMBOL(dax_set_page_dirty);
> +
> +void dax_invalidatepage(struct page *page, unsigned int offset,
> +		unsigned int length)
> +{
> +	/*
> +	 * There is no page cache to invalidate in the dax case, however
> +	 * we need this callback defined to prevent falling back to
> +	 * block_invalidatepage() in do_invalidatepage().
> +	 */
> +}

Same here.

> +EXPORT_SYMBOL(dax_invalidatepage);

And EXPORT_SYMBOL_GPL for anything dax-related, please.

> +const struct address_space_operations xfs_dax_aops = {
> +	.writepages		= xfs_vm_writepages,

Please split out the DAX case from xfs_vm_writepages.

This patch should probably also split into VFS and XFS parts.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
