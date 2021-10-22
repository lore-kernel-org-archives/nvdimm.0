Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9952C81
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 05:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xcBYXoniZzY7ZLTTZ2jfTzgN29460ApB4jiwLahdOXs=; b=wi8pPE/qofJdTPE+Mth0DB7fNI
	rLPT6fRiQAjOngtkmahECmF4xzDu8RZ+I/Bq734xorg82BkoG4CBsYixbbryGpWiTbMGMW53DukOP
	YTn3+gU8/n5KPFtd5gq+hgqf8YPpCjFqy6j+Flp4pEEuq2my4/sz0/BIdeXcDe+Z7fioDGk77K1si
	QlkDEAuPF2HNERwYHk7orbA89KtEJOGSzrBOzpoZh72/Pb863SQdM1QLRqbOnjHw00yWQLJywtl+N
	V+3W/8U+69VhnkaEcfn7BnEWN0S9AvZaE3zTOp7odX3xsFVaAhE5U0RUMtrOqpTqi2gqYoORmRq1g
	/XqKfgQg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mdnBN-009lTo-6z; Fri, 22 Oct 2021 05:33:33 +0000
Date: Thu, 21 Oct 2021 22:33:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"vgoyal@redhat.com" <vgoyal@redhat.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 4/6] dm,dax,pmem: prepare dax_copy_to/from_iter() APIs
 with DAXDEV_F_RECOVERY
Message-ID: <YXJNLTmcPaShrLoT@infradead.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
 <20211021001059.438843-5-jane.chu@oracle.com>
 <YXFOlKWUuwFUJxUZ@infradead.org>
 <325baeaf-54f6-dea0-ed2b-6be5a2ec47db@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <325baeaf-54f6-dea0-ed2b-6be5a2ec47db@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 22, 2021 at 12:49:15AM +0000, Jane Chu wrote:
> I've looked through your "futher decouple DAX from block devices" series 
> and likes the use of xarray in place of the host hash list.
> Which upstream version is the series based upon?
> If it's based on your development repo, I'd be happy to take a clone
> and rebase my patches on yours if you provide a link. Please let me
> know the best way to cooperate.

It is based on linux-next from when it was posted.  A git tree is here:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-block-cleanup

> That said, I'm unclear at what you're trying to suggest with respect
> to the 'DAXDEV_F_RECOVERY' flag.  The flag came from upper dax-fs
> call stack to the dm target layer, and the dm targets are equipped
> with handling pmem driver specific task, so it appears that the flag 
> would need to be passed down to the native pmem layer, right?
> Am I totally missing your point?

We'll need to pass it through (assuming we want to keep supporting
dm, see the recent discussion with Dan).

FYI, here is a sketch where I'd like to move to, but this isn't properly
tested yet:

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dax-devirtualize

To support something like DAXDEV_F_RECOVERYwe'd need a separate
dax_operations methods.  Which to me suggest it probably should be
a different operation (fallocate / ioctl / etc) as Darrick did earlier.
