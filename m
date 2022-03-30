Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EA836E
	for <nvdimm@lists.linux.dev>; Wed, 30 Mar 2022 05:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yCZ5d17EFD2aEB3EGnA7ZMwaYGzMjCaqvwamMb8/d/A=; b=FATsTjusksvtlMN1pOJstU1ijI
	IMnbWlp05UKcwa3gWEEqTw6N8GcV5QSf6C1y/3IqRg5rAxSuHtGDN19cfAmfLDTqTHXhVqoa51SPr
	p1X8tLumGNCsMQaxn9Mz5I3Akb7d4fs8GLRIrTjiUWcYH6FQTO4kK+0LMJuxRQj63nI/fJB8uR3hN
	z/j4J39qan+FX7gHBjxu6JEBpIbAzspjMkOE9bFCMTYA9Xl8fnJrkGdNbWYw2IFRd5EUbDItvuZhK
	0jbOcmIegmH+WknmWMSTnY4jhygaaKjh65GyKkfllEuIZPk6hetptPV+FmBF21A/G91xtA0uQAblX
	f6EVCdYQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nZRF4-00ENLP-Ne; Wed, 30 Mar 2022 05:51:38 +0000
Date: Tue, 29 Mar 2022 22:51:38 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v11 6/8] mm: Introduce mf_dax_kill_procs() for fsdax case
Message-ID: <YkPv6ntRlQxDdvBn@infradead.org>
References: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
 <20220227120747.711169-7-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220227120747.711169-7-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Feb 27, 2022 at 08:07:45PM +0800, Shiyang Ruan wrote:
> This function is called at the end of RMAP routine, i.e. filesystem
> recovery function, to collect and kill processes using a shared page of
> DAX file.

I think just throwing RMAP inhere is rather confusing.

> The difference with mf_generic_kill_procs() is, it accepts
> file's (mapping,offset) instead of struct page because different files'
> mappings and offsets may share the same page in fsdax mode.
> It will be called when filesystem's RMAP results are found.

So maybe I'd word the whole log as something like:

This new function is a variant of mf_generic_kill_procs that accepts
a file, offset pair instead o a struct to support multiple files sharing
a DAX mapping.  It is intended to be called by the file systems as
part of the memory_failure handler after the file system performed
a reverse mapping from the storage address to the file and file offset.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

> index 9b1d56c5c224..0420189e4788 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3195,6 +3195,10 @@ enum mf_flags {
>  	MF_SOFT_OFFLINE = 1 << 3,
>  	MF_UNPOISON = 1 << 4,
>  };
> +#if IS_ENABLED(CONFIG_FS_DAX)
> +int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
> +		      unsigned long count, int mf_flags);
> +#endif /* CONFIG_FS_DAX */

No need for the ifdef here, having the stable declaration around is
just fine.

> +#if IS_ENABLED(CONFIG_FS_DAX)

No need for the IS_ENABLED as CONFIG_FS_DAX can't be modular.
A good old #ifdef will do it.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
