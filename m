Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE0B2C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9Y0/ZIsrpET3FVw7VpZ/9vRsg+aIfvroPnh8qxTrCd8=; b=ErgESFhR8qvnZzyk8aoYj90ffS
	08hHFCQjXxZ9UT7d/pFVfdQbIk9gJ1njQr6F7Za0Qmh98RNaKF8ybi9lPxQ8tsiEuS7hBU61SJFFE
	Obh99T9fnHg03teXAY1/v2vRDp8rzSOh60y/liD0yxLfdaQC5ZoauOZoprN9f9UA8AL29+NRJC6Z2
	eIxya7OamoH/weKZwkhV2gPg1igTpSm0pVJF4XfgzIQO2b8FFj88PgZLhE1QuMQM2qRZ02szxRbl6
	k/j6Ng5jiK21ARzKbYpF8vhiBeTwnl0/nR1lsj6Ix0TG4JqUY0KnSf42sG9QvNx5OsqOEjHbjyT5v
	/tJUkiDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1migP3-009eQi-Ed; Thu, 04 Nov 2021 17:19:53 +0000
Date: Thu, 4 Nov 2021 10:19:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>
Subject: Re: qemu-emulated nfit devices disappeared
Message-ID: <YYQWOU//1oz0EMIu@infradead.org>
References: <YYOLRW7yx9IFn9mG@infradead.org>
 <CAPcyv4hU+dFYc3fXnGhBPAsid03yFYZSym_sTBjHeUUrt6s5gQ@mail.gmail.com>
 <YYQEfxpVlxWjXgAU@infradead.org>
 <CAPcyv4hZ1+pEd0A1y2oqSsMjCh2phJxukBB8ZBwbN0ax-Gni9Q@mail.gmail.com>
 <YYQVq80QS77KkFV0@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYQVq80QS77KkFV0@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Nov 04, 2021 at 10:17:31AM -0700, Christoph Hellwig wrote:
> On Thu, Nov 04, 2021 at 10:09:37AM -0700, Dan Williams wrote:
> > Hmm, so the driver has 2 modes "labeled" and "label-less", in the
> > labeled mode it waits for an explicit:
> > 
> >     ndctl create-namespace
> > 
> > ...to provision region capacity into a namespace. In label-less mode
> > it just assumes that the boundaries of the region are the boundaries
> > of the namespace. In this case it looks like the driver found a label
> > index block with no namespaces defined so it's waiting for one to be
> > created. Are you saying that the only thing you changed from a working
> > config with defined namespace to this one was a kernel change? I.e.
> > the content of those memory-backend files has not changed?
> 
> Well, the config change is the only thing I though of as relevant.
> The content of those files actually changes all the time, as I also
> use them as the backing store for my qemu configs that use block
> devices.  E.g. the previous run they did show up as NVMe devices.

Ok, blowing the files away and recreating them makes the pmem
devices show up again.
