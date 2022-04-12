Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BDD469E
	for <nvdimm@lists.linux.dev>; Tue, 12 Apr 2022 05:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xxpfJwOTp0zZ4mEFeo2bEwyNiH/HvBWSwa1t8TxoKCk=; b=1Bp/fmvIlZv8uA/4GoXEweJp/p
	jlJjY7tp9v1H/I5gwNEEO8e0bZ+Pz7kTlrArNY8Qe0bCZY5RqIYP42bATTDtDeCzwmjVWRpAoDz5c
	N1TuusZGVo27oRO9a9kJoTXp3442Y9BfyiVseUegOZXd81cxS7Ei/UsUe98Hysm3X1HJ9bHQnhjrf
	AXHrMIYfxlvEEO8dXxBI45I6AT6iOV5hybD+7tPANpKCYjrdiZ4KnB4YbFOjAE1hnmn4bwv63GFnP
	DnEVvUVr2iAriSepVlr/s9pY6Vlrw4MhRUdh/9HmyVWfHpc/9QkTixdWDnWm+iKqECdmpASOrXPVq
	/kHk02qQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1ne8fR-00Bjrs-9H; Tue, 12 Apr 2022 05:02:17 +0000
Date: Mon, 11 Apr 2022 22:02:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>, david <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Vishal L Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	device-mapper development <dm-devel@redhat.com>,
	"Weiny, Ira" <ira.weiny@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Vivek Goyal <vgoyal@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-xfs <linux-xfs@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v7 4/6] dax: add DAX_RECOVERY flag and .recovery_write
 dev_pgmap_ops
Message-ID: <YlUH2f66hMyXOP1r@infradead.org>
References: <20220405194747.2386619-1-jane.chu@oracle.com>
 <20220405194747.2386619-5-jane.chu@oracle.com>
 <CAPcyv4jpOss6hzPgM913v_QsZ+PB6Jzo1WV=YdUvnKZiwtfjiA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jpOss6hzPgM913v_QsZ+PB6Jzo1WV=YdUvnKZiwtfjiA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 11, 2022 at 09:57:36PM -0700, Dan Williams wrote:
> So how about change 'int flags' to 'enum dax_access_mode mode' where
> dax_access_mode is:
> 
> /**
>  * enum dax_access_mode - operational mode for dax_direct_access()
>  * @DAX_ACCESS: nominal access, fail / trim access on encountering poison
>  * @DAX_RECOVERY_WRITE: ignore poison and provide a pointer suitable
> for use with dax_recovery_write()
>  */
> enum dax_access_mode {
>     DAX_ACCESS,
>     DAX_RECOVERY_WRITE,
> };
> 
> Then the conversions look like this:
> 
>  -       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
>  +       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1,
> DAX_ACCESS, &kaddr, NULL);
> 
> ...and there's less chance of confusion with the @nr_pages argument.

Yes, this might be a little nicer.
