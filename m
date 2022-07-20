Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F72E1FBC
	for <nvdimm@lists.linux.dev>; Wed, 20 Jul 2022 06:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SndvjC4mXCOfnIgSVsBR8b+W8bbqQ1IMcQ6jMecUudQ=; b=4zznECM+HMH0Hk6ES+KOvOfxv2
	jMdgL4Qmr6EY/V6Zlyt3VmywHu/zxUmwJ3j2xipcqu/XBI3hiJaPsnkpasPSfKL76KOZXClUX71RQ
	tHqFsVoj22NM29X6830xtRmazvwjOWGpwS7aPWX4OQASj1CMfwzU+EYDYYU7HeZPGiN+SYrBzswX8
	vWNFuIFrH28aQODSrhWmC/nzHxGHioCgk4aXmN1gK9lCJOgNrZ10iHNlFRVgOfKVMrE8IQksPVTTj
	17Gz4D08W8+z654LyEOcJiXRklx055U+QYWmhpb1afzC6ahmgpzR6WbjDgUafCH2SzJC9YLSVGSEb
	w/2357kg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1oE38J-001FUl-Om; Wed, 20 Jul 2022 06:24:31 +0000
Date: Tue, 19 Jul 2022 23:24:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Dennis.Wu" <dennis.wu@intel.com>, nvdimm@lists.linux.dev,
	vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com
Subject: Re: [PATCH] ACPI/NFIT: Add no_deepflush param to dynamic control
 flush operation
Message-ID: <YtefnyIvY9OdrVU5@infradead.org>
References: <20220629083118.8737-1-dennis.wu@intel.com>
 <YrxvR6zDZymsQCQl@infradead.org>
 <62ce1f0a57b84_6070c294a@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62ce1f0a57b84_6070c294a@dwillia2-xfh.jf.intel.com.notmuch>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jul 12, 2022 at 06:25:30PM -0700, Dan Williams wrote:
> > This goes back to my question from years ago:  why do we ever
> > do this deep flush in the Linux nvdimm stack to start with?
> 
> The rationale is to push the data to smaller failure domain. Similar to
> flushing disk write-caches.

Flushing disk caches is not about a smaller failure domain.  Flushing
disk caches is about making data durable _at _all_.

> Otherwise, if you trust your memory power
> supplies like you trust your disks then just rely on them to take care
> of the data.

Well, it seems like all the benchmarketing schemes around pmem seem to
trust it.  Why would kernel block I/O be different from device dax,
MAP_SYNC?

> Otherwise, by default the kernel should default to taking as much care
> as possible to push writes to the smallest failure domain possible.

In which case we need remve the device dax direct map and MAP_SYNC.
Reducing the failure domain is not what fsync or REQ_OP_FLUSH are
about, they are about making changes durable.  How durable is up to
your device implementation.  But if you trust it only a little you
should not offer that half way option to start with.
