Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1ED177
	for <nvdimm@lists.linux.dev>; Tue, 29 Jun 2021 11:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cL/xYeDGSOOq6GehMead9WT6za7RednhXlwnl3lBZ1c=; b=UJY9KjIL7mnbS95nK+aQtN4TNO
	3LOzuuk00vShr1RzEBAF5ktTgmCGYQyFg27kqspYsu9CqVD6WYt4Y8GegqWeVmu0/V7xIOb5GcHng
	qB3FpA68Q2a0jMBSBnQSNwtfz97XBAy/yRDwKOj0fEnzSAn47qKcGtbk+fPuUohuSJ6VUYOOKtVqh
	SbAW57gFaVN5MHS4IaKKoGAffGEeAP6uWHNXtDIIBYedISUPYfCWzCukQYIa30Tlbk0yiAxGAi9xI
	iijHpCxdJcTr4L6fU360399XSyjQ9mDx+yfh3umTWqbPBhs4MfcuTgoA8J0w0ywoXrrixc2/VZVVf
	Qq1DfAeg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1lyCCI-0043Q8-DZ; Tue, 29 Jun 2021 11:46:40 +0000
Date: Tue, 29 Jun 2021 12:46:34 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "ruansy.fnst@fujitsu.com" <ruansy.fnst@fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"darrick.wong@oracle.com" <darrick.wong@oracle.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"hch@lst.de" <hch@lst.de>, "agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"rgoldwyn@suse.de" <rgoldwyn@suse.de>
Subject: Re: [PATCH v5 5/9] mm: Introduce mf_dax_kill_procs() for fsdax case
Message-ID: <YNsIGid6CwtH/h1Z@casper.infradead.org>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
 <20210628000218.387833-6-ruansy.fnst@fujitsu.com>
 <YNm3VeeWuI0m4Vcx@casper.infradead.org>
 <OSBPR01MB292012F7C264076E9AA645C3F4029@OSBPR01MB2920.jpnprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSBPR01MB292012F7C264076E9AA645C3F4029@OSBPR01MB2920.jpnprd01.prod.outlook.com>

On Tue, Jun 29, 2021 at 07:49:24AM +0000, ruansy.fnst@fujitsu.com wrote:
> > But I think this is unnecessary; why not just pass the PFN into mf_dax_kill_procs?
> 
> Because the mf_dax_kill_procs() is called in filesystem recovery function, which is at the end of the RMAP routine.  And the PFN has been translated to disk offset in pmem driver in order to do RMAP search in filesystem.  So, if we have to pass it, every function in this routine needs to add an argument for this PFN.  I was hoping I can avoid passing PFN through the whole stack with the help of this dax_load_pfn().

OK, I think you need to create:

struct memory_failure {
	phys_addr_t start;
	phys_addr_t end;
	unsigned long flags;
};

(a memory failure might not be an entire page, so working in pfns isn't
the best approach)

Then that can be passed to ->memory_failure() and then deeper to
->notify_failure(), and finally into xfs_corrupt_helper().
