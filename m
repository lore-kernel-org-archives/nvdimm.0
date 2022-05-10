Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871B223B7
	for <nvdimm@lists.linux.dev>; Tue, 10 May 2022 05:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cpwq/OLvQ6BxCOaH+3pF5HdK307ERk7HHWVvMWH/28U=; b=MpMWT1FEZcXAuLHYaX7QGm59Fe
	+Xe4NR2djbwqu6Z34ULgu3zfo19+scTn4YJGLz7OrHl70yFbLc56gH4uX64lbATYoPth+p+eUitQV
	4XmoTeHkzSxmuwpgLfUhlGBbOYtGZWPmrDznB0zthU+q82QSko6oxaSAfwaDdqEMRdu7fC8mTlvor
	wdXIQKyKGuHGs5dZQp+E+XUMylRxGPsxegf4X0pcAPtE/zjU6m2ywUhMa/I1lQ3zD3KcTxwhttMb/
	WXwuLCw1qiAsRzlJN0vuMF+jIoIUgI9TSodb3Mi3NRWvvNtsrAzV04GtThZUoZLNp18BERtMniMd/
	oefUel2Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1noIgo-00034j-FN; Tue, 10 May 2022 05:45:42 +0000
Date: Mon, 9 May 2022 22:45:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com, rgoldwyn@suse.de, viro@zeniv.linux.org.uk,
	willy@infradead.org, naoya.horiguchi@nec.com, linmiaohe@huawei.com
Subject: Re: [PATCH v11 06/07] xfs: support CoW in fsdax mode
Message-ID: <Ynn8BnZclNoEuzvv@infradead.org>
References: <20220508143620.1775214-1-ruansy.fnst@fujitsu.com>
 <20220508143620.1775214-14-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220508143620.1775214-14-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +#ifdef CONFIG_FS_DAX
> +int
> +xfs_dax_fault(
> +	struct vm_fault		*vmf,
> +	enum page_entry_size	pe_size,
> +	bool			write_fault,
> +	pfn_t			*pfn)
> +{
> +	return dax_iomap_fault(vmf, pe_size, pfn, NULL,
> +			(write_fault && !vmf->cow_page) ?
> +				&xfs_dax_write_iomap_ops :
> +				&xfs_read_iomap_ops);
> +}
> +#endif

Is there any reason this is in xfs_iomap.c and not xfs_file.c?

Otherwise the patch looks good:


Reviewed-by: Christoph Hellwig <hch@lst.de>
