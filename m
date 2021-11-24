Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F60F2C81
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 06:50:54 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id E12D568AFE; Wed, 24 Nov 2021 07:50:50 +0100 (CET)
Date: Wed, 24 Nov 2021 07:50:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-erofs@lists.ozlabs.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 18/29] fsdax: decouple zeroing from the iomap buffered
 I/O code
Message-ID: <20211124065050.GB7075@lst.de>
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-19-hch@lst.de> <CAPcyv4hDG9-BQHjuJnQUQLJhq=xmrNi+w-uiu6TnV4Rcf0VDfQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hDG9-BQHjuJnQUQLJhq=xmrNi+w-uiu6TnV4Rcf0VDfQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 23, 2021 at 01:46:35PM -0800, Dan Williams wrote:
> > +               const struct iomap_ops *ops)
> > +{
> > +       unsigned int blocksize = i_blocksize(inode);
> > +       unsigned int off = pos & (blocksize - 1);
> > +
> > +       /* Block boundary? Nothing to do */
> > +       if (!off)
> > +               return 0;
> 
> It took me a moment to figure out why this was correct. I see it was
> also copied from iomap_truncate_page(). It makes sense for DAX where
> blocksize >= PAGE_SIZE so it's always the case that the amount of
> capacity to zero relative to a page is from @pos to the end of the
> block. Is there something else that protects the blocksize < PAGE_SIZE
> case outside of DAX?
> 
> Nothing to change for this patch, just a question I had while reviewing.

This is a helper for truncate ->setattr, where everything outside the
block is deallocated.  So zeroing is only needed inside the block.
