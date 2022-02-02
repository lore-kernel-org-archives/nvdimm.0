Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEB32CA5
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 13:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=g4vUH6EzyLT2vaGYwlen5+OHvw9Zb7oDiztQ44k8gOY=; b=taz5SADOs9Pfi14hGDnEcDNHDC
	qPdeN8oYaj1zKm1GTA8AvbbszJ99pctasgAt+q64guHYT/RAxDVg1543f4Fkgb64xN1y7CYxxfR/z
	X/WEwPUQmi/0ZWKYb9iSzDz2OHM1dxmGFYDQ+67c8IZ4ZNdPTQ/t7zhx5KrHrFPEgk4YqIbmeITIG
	/iNDlc2pDVeJXerurYMgHnhflHW1/wZRcXuX5c8LGZjufWsrG593L6XNNCwmawN2pdoQ3EvjXD+j+
	5rliuRKcexGGJexwyWQz4oDlGocfsFbHyFPEijUawPGjyE8Oe0G5Vyg07U4/rmtLwKJA1TDwAC+6l
	mQE48Q3Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nFFvW-00FNmE-0j; Wed, 02 Feb 2022 13:44:02 +0000
Date: Wed, 2 Feb 2022 05:44:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: david@fromorbit.com, djwong@kernel.org, dan.j.williams@intel.com,
	hch@infradead.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com,
	ira.weiny@intel.com, willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 6/7] dax: add recovery_write to dax_iomap_iter in
 failure path
Message-ID: <YfqKoZ79CqvW8eLq@infradead.org>
References: <20220128213150.1333552-1-jane.chu@oracle.com>
 <20220128213150.1333552-7-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128213150.1333552-7-jane.chu@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jan 28, 2022 at 02:31:49PM -0700, Jane Chu wrote:
> +typedef size_t (*iter_func_t)(struct dax_device *dax_dev, pgoff_t pgoff,
> +		void *addr, size_t bytes, struct iov_iter *i);
>  static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>  		struct iov_iter *iter)
>  {
> @@ -1210,6 +1212,7 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>  	ssize_t ret = 0;
>  	size_t xfer;
>  	int id;
> +	iter_func_t write_func = dax_copy_from_iter;

This use of a function pointer causes indirect call overhead.  A simple
"bool in_recovery" or do_recovery does the trick in a way that is
both more readable and generates faster code.

> +		if ((map_len == -EIO) && (iov_iter_rw(iter) == WRITE)) {

No need for the braces.

>  		if (iov_iter_rw(iter) == WRITE)
> -			xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
> -					map_len, iter);
> +			xfer = write_func(dax_dev, pgoff, kaddr, map_len, iter);
>  		else
>  			xfer = dax_copy_to_iter(dax_dev, pgoff, kaddr,
>  					map_len, iter);

i.e.

		if (iov_iter_rw(iter) == READ)
			xfer = dax_copy_to_iter(dax_dev, pgoff, kaddr,
					map_len, iter);
		else if (unlikely(do_recovery))
			xfer = dax_recovery_write(dax_dev, pgoff, kaddr,
					map_len, iter);
		else
			xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
					map_len, iter);
