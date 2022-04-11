Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA1E10EC
	for <nvdimm@lists.linux.dev>; Mon, 11 Apr 2022 06:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GJM0jYn00v1gzHURiVOdNItn1NFnRTfjl2UiVvY+3iE=; b=S6U9UkjbII+TZi9sq+N2w7jRIL
	gxayyYr/3ajrps4WfKYqkBXwe+qgjlqpClozl35qB24rRl150bmssg8ghyX0veUlZMGel3yDA4Kg9
	iWtO74ihMEDlS0R4OWRidlpwSmQIAYjobNQuTCSO5FXSaZLumRPx3Mku81oGPVb8uPw2S1jjyPQ3T
	CKyyY/mh11QGYZXGYu8Ob6Yg8bJv5oNBsbfEWCbVc9T4Fyf13ET9sjHS4MQWNx6xg/XYyPQB/ZyUH
	SRYJ1r0yV4Y1xarcJs34friUNfRvATgVUw0N+0cxDzTP5eniAa+K6cI9Qb6cMAlWsKzI3Rh31tirf
	clpm8YTg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1ndnxX-0070Zq-Vb; Mon, 11 Apr 2022 06:55:36 +0000
Date: Sun, 10 Apr 2022 23:55:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v12 7/7] fsdax: set a CoW flag when associate reflink
 mappings
Message-ID: <YlPQ59w4L4pnDYWq@infradead.org>
References: <20220410160904.3758789-1-ruansy.fnst@fujitsu.com>
 <20220410160904.3758789-8-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220410160904.3758789-8-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> + * Set or Update the page->mapping with FS_DAX_MAPPING_COW flag.
> + * Return true if it is an Update.
> + */
> +static inline bool dax_mapping_set_cow(struct page *page)
> +{
> +	if (page->mapping) {
> +		/* flag already set */
> +		if (dax_mapping_is_cow(page->mapping))
> +			return false;
> +
> +		/*
> +		 * This page has been mapped even before it is shared, just
> +		 * need to set this FS_DAX_MAPPING_COW flag.
> +		 */
> +		dax_mapping_set_cow_flag(&page->mapping);
> +		return true;
> +	}
> +	/* Newly associate CoW mapping */
> +	dax_mapping_set_cow_flag(&page->mapping);
> +	return false;

Given that this is the only place calling dax_mapping_set_cow I wonder
if we should just open code it here, and also lift the page->index logic
from the caller into this helper.

static inline void dax_mapping_set_cow(struct page *page)
{
	if ((uintptr_t)page->mapping != PAGE_MAPPING_DAX_COW) {
		/*
		 * Reset the index if the page was already mapped
		 * regularly before.
		 */
		if (page->mapping)
			page->index = 1;
		page->mapping = (void *)PAGE_MAPPING_DAX_COW;
	}
	page->index++;
}

> +		if (!dax_mapping_is_cow(page->mapping)) {
> +			/* keep the CoW flag if this page is still shared */
> +			if (page->index-- > 0)
> +				continue;
> +		} else
> +			WARN_ON_ONCE(page->mapping && page->mapping != mapping);

Isnt the dax_mapping_is_cow check above inverted?
