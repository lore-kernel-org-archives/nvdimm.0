Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39193FC4
	for <nvdimm@lists.linux.dev>; Mon, 23 Aug 2021 12:57:25 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id E108167357; Mon, 23 Aug 2021 14:57:15 +0200 (CEST)
Date: Mon, 23 Aug 2021 14:57:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	linux-xfs <linux-xfs@vger.kernel.org>, david <david@fromorbit.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>,
	Goldwyn Rodrigues <rgoldwyn@suse.com>,
	Ritesh Harjani <riteshh@linux.ibm.com>
Subject: Re: [PATCH v7 3/8] fsdax: Replace mmap entry in case of CoW
Message-ID: <20210823125715.GA15536@lst.de>
References: <20210816060359.1442450-1-ruansy.fnst@fujitsu.com> <20210816060359.1442450-4-ruansy.fnst@fujitsu.com> <CAPcyv4iOSxoy-qGfAd3i4uzwfDX0t1xTmyM0pNd+-euVMDUwrQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iOSxoy-qGfAd3i4uzwfDX0t1xTmyM0pNd+-euVMDUwrQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Aug 19, 2021 at 03:54:01PM -0700, Dan Williams wrote:
> 
> static void *dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
>                               const struct iomap_iter *iter, void
> *entry, pfn_t pfn,
>                               unsigned long flags)
> 
> 
> >  {
> > +       struct address_space *mapping = vmf->vma->vm_file->f_mapping;
> >         void *new_entry = dax_make_entry(pfn, flags);
> > +       bool dirty = insert_flags & DAX_IF_DIRTY;
> > +       bool cow = insert_flags & DAX_IF_COW;
> 
> ...and then calculate these flags from the source data. I'm just
> reacting to "yet more flags".

Except for the overly long line above that seems like a good idea.
The iomap_iter didn't exist for most of the time this patch has been
around.
