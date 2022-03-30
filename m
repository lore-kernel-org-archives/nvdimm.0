Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F8F36E
	for <nvdimm@lists.linux.dev>; Wed, 30 Mar 2022 05:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XYYGWYlGuqIll3206prQVGyP0v/a7w+dmLgKcE4zaws=; b=jHHEU4mvd0H5k2hZQ2Oh1VIDR3
	ZsbE/wCHfCB3yo6Tv3WBxleJOBG5ac3ibd3V6uBxVQCqrxXmSfZyD6hLBU7jrd4ZYlnTDcbU4X3EA
	4qzEE0C1hDU3VdFrAO0w5xxIA/+PsG8trZyx992Le9Grzq1a36f3m07Dbvj1SXjQqr/UZP70leQTg
	HrTR85viFYLEBCb4gcSTqrZvQq2/1kGUszwuEO7eefI/g0/2iJ/crGr9oCCfcZiVisT/j39xzcLh0
	XcnL1oWNCPc0aLsQEryrtCXzxkh2yA0drzYSof6Xj0pKdU8LsIL60mtA3sY6JyhsWwkaUIoB7ZNHF
	KTpo10vg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nZR5i-00EMe6-R7; Wed, 30 Mar 2022 05:41:58 +0000
Date: Tue, 29 Mar 2022 22:41:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux MM <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	Jane Chu <jane.chu@oracle.com>
Subject: Re: [PATCH v11 1/8] dax: Introduce holder for dax_device
Message-ID: <YkPtptNljNcJc1g/@infradead.org>
References: <20220227120747.711169-1-ruansy.fnst@fujitsu.com>
 <20220227120747.711169-2-ruansy.fnst@fujitsu.com>
 <CAPcyv4jAqV7dZdmGcKrG=f8sYmUXaL7YCQtME6GANywncwd+zg@mail.gmail.com>
 <4fd95f0b-106f-6933-7bc6-9f0890012b53@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fd95f0b-106f-6933-7bc6-9f0890012b53@fujitsu.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 16, 2022 at 09:46:07PM +0800, Shiyang Ruan wrote:
> > Forgive me if this has been discussed before, but since dax_operations
> > are in terms of pgoff and nr pages and memory_failure() is in terms of
> > pfns what was the rationale for making the function signature byte
> > based?
> 
> Maybe I didn't describe it clearly...  The @offset and @len here are
> byte-based.  And so is ->memory_failure().

Yes, but is there a good reason for that when the rest of the DAX code
tends to work in page chunks?
