Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6952CA2
	for <nvdimm@lists.linux.dev>; Tue, 14 Dec 2021 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oJslFIdA4AG/KSWkHfzHo1CU/K0qEFS2dBN46SW5n4g=; b=wYvLy4OGOn7HEHjGPa6A+bAD+e
	s2Y3bNI2cK7djZ1hk1LY9aL2C45NS2CIw9TQR7ZZQgKANAHvnOPfMGwwldIxh5D8DRr/v6dcZlDiD
	kA8l0UShViFqFQuujYG7QN80xLbTZp1Nm+zEAY3OYxnyVAX7JXP5HKVA/kEWwD9cIgW29SmDGpBAg
	r7WGFuDhamogodiXPQRwQjDD8rLphsjuie+TJYiWW8bfxss7+6/lYC//HTjm3Wnj0iE11p+DhN5Wj
	id7/o7tciiMGv5iJ3X0X3Ry3ooLX7lY8ziGTvWJ4AQnwwoRsE4FHuZU8f02PBxHA2TJGc4X63ndp0
	KhdUsF7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mxA7x-00EkhI-M7; Tue, 14 Dec 2021 15:54:05 +0000
Date: Tue, 14 Dec 2021 07:54:05 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v8 8/9] xfs: Implement ->notify_failure() for XFS
Message-ID: <Ybi+HYoI2i3dVToz@infradead.org>
References: <20211202084856.1285285-1-ruansy.fnst@fujitsu.com>
 <20211202084856.1285285-9-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202084856.1285285-9-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +		// TODO check and try to fix metadata

Please avoid //-style comments.

> +static u64
> +xfs_dax_ddev_offset(
> +	struct xfs_mount	*mp,
> +	struct dax_device	*dax_dev,
> +	u64			disk_offset)
> +{
> +	xfs_buftarg_t *targp;
> +
> +	if (mp->m_ddev_targp->bt_daxdev == dax_dev)
> +		targp = mp->m_ddev_targp;
> +	else if (mp->m_logdev_targp->bt_daxdev == dax_dev)
> +		targp = mp->m_logdev_targp;
> +	else
> +		targp = mp->m_rtdev_targp;
> +
> +	return disk_offset - targp->bt_dax_part_off;

This is only called for the data device.  So I think we can simplify
this and open code the logic in xfs_dax_notify_ddev_failure.


> +void
> +xfs_notify_failure_register(
> +	struct xfs_mount	*mp,
> +	struct dax_device	*dax_dev)
> +{
> +	if (dax_dev && !fs_dax_get_holder(dax_dev))
> +		fs_dax_register_holder(dax_dev, mp, &xfs_dax_holder_operations);
> +}
> +
> +void
> +xfs_notify_failure_unregister(
> +	struct dax_device	*dax_dev)
> +{
> +	if (dax_dev)
> +		fs_dax_unregister_holder(dax_dev);
> +}

Why do we need these wrappers?  Also instead of the fs_dax_get_holder
here, fs_dax_register_holder needs to return an error if there already
is a holder.
