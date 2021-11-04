Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501002C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 17:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=AGMyPyrv5eQO9nzYM0nk2jjXlzRa+IHX0ekjNRpF8w8=; b=tQMOOoz7u1ALT9YukpqhMQaN5E
	9oJRTuR+suN9c0n0g99hqCJVLl2xw5xq5/zTOc8RNid8M4y4wx8PzOjNZzz1RaMGG3N+EcZwXSsNY
	dDHnTKJG2sDDeqkIoOHBgq6KRLYfeOOSOunI9VN1S3A/2U3wGgYeD22SyJ6pHo1wO6UahfADRMOv9
	YECnu+WeMmG3z4sWo2pu+kmA7TW94hHHiV4VYwvZNNIe4MhL57K6JpXwr34lcwInVVdbzpQQyD9a4
	2rGm8v5kHpZ4PLMTcAp7eAIiqd5v95vy8ym9SSXKlD/ULBMr8yaEg0GiVKi1ssjCAL/Y5WU0HcYbZ
	NZExxWJQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1migMl-009dYV-8o; Thu, 04 Nov 2021 17:17:31 +0000
Date: Thu, 4 Nov 2021 10:17:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>
Subject: Re: qemu-emulated nfit devices disappeared
Message-ID: <YYQVq80QS77KkFV0@infradead.org>
References: <YYOLRW7yx9IFn9mG@infradead.org>
 <CAPcyv4hU+dFYc3fXnGhBPAsid03yFYZSym_sTBjHeUUrt6s5gQ@mail.gmail.com>
 <YYQEfxpVlxWjXgAU@infradead.org>
 <CAPcyv4hZ1+pEd0A1y2oqSsMjCh2phJxukBB8ZBwbN0ax-Gni9Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hZ1+pEd0A1y2oqSsMjCh2phJxukBB8ZBwbN0ax-Gni9Q@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 04, 2021 at 10:09:37AM -0700, Dan Williams wrote:
> Hmm, so the driver has 2 modes "labeled" and "label-less", in the
> labeled mode it waits for an explicit:
> 
>     ndctl create-namespace
> 
> ...to provision region capacity into a namespace. In label-less mode
> it just assumes that the boundaries of the region are the boundaries
> of the namespace. In this case it looks like the driver found a label
> index block with no namespaces defined so it's waiting for one to be
> created. Are you saying that the only thing you changed from a working
> config with defined namespace to this one was a kernel change? I.e.
> the content of those memory-backend files has not changed?

Well, the config change is the only thing I though of as relevant.
The content of those files actually changes all the time, as I also
use them as the backing store for my qemu configs that use block
devices.  E.g. the previous run they did show up as NVMe devices.
