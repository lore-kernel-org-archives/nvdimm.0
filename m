Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 443DA223DB103
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 01:49:42 -0800 (PST)
Date: Sat, 10 Mar 2018 10:55:58 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 11/11] xfs, dax: introduce xfs_break_dax_layouts()
Message-ID: <20180310095558.GC31604@lst.de>
References: <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152066494840.40260.6478694186268933246.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152066494840.40260.6478694186268933246.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

> +static int xfs_wait_dax_page(
> +		atomic_t                *count,
> +		unsigned int            mode)
> +{

Normal XFS style would be:

static int
xfs_wait_dax_page(
	atomic_t		*count,
	unsigned int		mode)
{

> +	struct page             *page = refcount_to_page(count);
> +	struct address_space    *mapping = page->mapping;
> +	struct inode            *inode = mapping->host;
> +	struct xfs_inode        *ip = XFS_I(inode);

Looks we don't really need the mapping and inode variables:

	struct page		*page = refcount_to_page(count);
	struct xfs_inode	*ip = XFS_I(page->mapping->host);

> +	do {
> +		if (flags & XFS_BREAK_REMOTE)
> +			ret = xfs_break_leased_layouts(inode, iolock);
> +		if (ret)
> +			return ret;
> +		if (flags & XFS_BREAK_MAPS)
> +			ret = xfs_break_dax_layouts(inode, *iolock);
> +		/*
> +		 * EBUSY indicates that we dropped locks and waited for
> +		 * the dax layout to be released. When that happens we
> +		 * need to revalidate that no new leases or pinned dax
> +		 * mappings have been established.
> +		 */
> +	} while (ret == -EBUSY);

Maybe instead of the flags argument this should be a type argument
of something like

enum layout_break_reason {
	BREAK_WRITE,		/* write to file */
	BREAK_TRUNCATE,		/* truncate or hole punch */
};

as that makes the intent more clear?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
