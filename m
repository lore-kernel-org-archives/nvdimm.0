Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B743168
	for <nvdimm@lists.linux.dev>; Tue, 14 Dec 2021 15:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Wjypj8Z4Rg2+/h76mxjfwvjNCwkDu0E5brw7BKK/Hgg=; b=tEcA6K5ehWXLXPQsfXCwOObarL
	o9UpZ+PNLeaJUmIx3vlOncBNz490UxrZQ/NmCOjVKIwb5lN4VhmSGPZAwepg/YiyAY4AnACoFxINY
	t8IdsbIknSUucM0SSZD6aszBSZXaJdL4CfYFmAssolfBUEYR+3X723Yu3Fh7clCmsBmi+H04ObrwW
	pyt1MBkpdXUfw8bIez2ZYlkMN6/S1uQsngkzIAYHWskZbmvM8UYMP3MbJ1/arbc7RmVJrqK75epfW
	9LKWCKpFSx2a5XzjKbbj9paf/ciMmgU0TKzYdT4tObMCSI9uwU4uwIB6eskGmkkaWDzH4U8Bh2z9a
	wLYnR0bg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mx9wU-00EjQ3-QS; Tue, 14 Dec 2021 15:42:14 +0000
Date: Tue, 14 Dec 2021 07:42:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dan.j.williams@intel.com, david@fromorbit.com, hch@infradead.org,
	jane.chu@oracle.com
Subject: Re: [PATCH v8 5/9] fsdax: Introduce dax_lock_mapping_entry()
Message-ID: <Ybi7VmfigwLpUrgO@infradead.org>
References: <20211202084856.1285285-1-ruansy.fnst@fujitsu.com>
 <20211202084856.1285285-6-ruansy.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202084856.1285285-6-ruansy.fnst@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 02, 2021 at 04:48:52PM +0800, Shiyang Ruan wrote:
> The current dax_lock_page() locks dax entry by obtaining mapping and
> index in page.  To support 1-to-N RMAP in NVDIMM, we need a new function
> to lock a specific dax entry corresponding to this file's mapping,index.
> And BTW, output the page corresponding to the specific dax entry for
> caller use.

s/BTW, //g

>  /*
> - * dax_lock_mapping_entry - Lock the DAX entry corresponding to a page
> + * dax_lock_page - Lock the DAX entry corresponding to a page
>   * @page: The page whose entry we want to lock
>   *
>   * Context: Process context.

This should probably got into a separate trivial fix.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
