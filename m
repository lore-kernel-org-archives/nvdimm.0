Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CB510EC
	for <nvdimm@lists.linux.dev>; Mon, 11 Apr 2022 06:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M09IzlW+N1WwFLRoKBoXQhmkTfiayS6+tKZLiDRa9cM=; b=vuYRGKESL2/4qm8Aezet9aPx4W
	+nyvgXHqbKV8O/sdkchzpTN0JP8s+Z+FPEBDRwarRsRbFqp2ZnRDOyu+W9z93H5iHy2pdUCD9XgL3
	j7TJH2gQyaMfCoijPZqyy5a9A4X+cKOMX2LVS1qbnbXimkEvdbeLgdSU0uGUXBoSp0UoshnrLBNEm
	A/V/RaLAeZrpWRq7OuusbYUJ2NFL4+Fm393i7D+mawqNJ0cZ0W9Uz48YBYQIZej1ogcwGrA+cmV8c
	eyCdR0EJm5AqpL54XYS32PcZLYDLrDaTkXXtTvDQIk+fBd3Enmi4giwIWOQcO0B1zHVJALhjFWIxv
	y1SlBf+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1ndniQ-006xNn-5v; Mon, 11 Apr 2022 06:39:58 +0000
Date: Sun, 10 Apr 2022 23:39:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v12 6/7] xfs: Implement ->notify_failure() for XFS
Message-ID: <YlPNPn9uSfFwrPlQ@infradead.org>
References: <20220410160904.3758789-1-ruansy.fnst@fujitsu.com>
 <20220410160904.3758789-7-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410160904.3758789-7-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> --- a/fs/xfs/xfs_super.h
> +++ b/fs/xfs/xfs_super.h
> @@ -93,6 +93,7 @@ extern xfs_agnumber_t xfs_set_inode_alloc(struct xfs_mount *,
>  extern const struct export_operations xfs_export_operations;
>  extern const struct xattr_handler *xfs_xattr_handlers[];
>  extern const struct quotactl_ops xfs_quotactl_operations;


> +extern const struct dax_holder_operations xfs_dax_holder_operations;

This needs to be defined to NULL if at least one of CONFIG_FS_DAX or
CONFIG_MEMORY_FAILURE is not set.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
