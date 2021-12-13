Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0872C99
	for <nvdimm@lists.linux.dev>; Mon, 13 Dec 2021 08:24:23 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 60ABF68BFE; Mon, 13 Dec 2021 09:24:20 +0100 (CET)
Date: Mon, 13 Dec 2021 09:24:20 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Matthew Wilcox <willy@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 4/5] dax: remove the copy_from_iter and copy_to_iter
 methods
Message-ID: <20211213082420.GC21462@lst.de>
References: <20211209063828.18944-1-hch@lst.de> <20211209063828.18944-5-hch@lst.de> <CAPcyv4gZjkVW0vwNLChXCCBVF8CsSZityzSVmcGAk79-mt9yOw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gZjkVW0vwNLChXCCBVF8CsSZityzSVmcGAk79-mt9yOw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Dec 12, 2021 at 06:39:16AM -0800, Dan Williams wrote:
> >         /* flag to check if device supports synchronous flush */
> >         DAXDEV_SYNC,
> > +       /* do not use uncached operations to write data */
> > +       DAXDEV_CACHED,
> > +       /* do not use mcsafe operations to read data */
> > +       DAXDEV_NOMCSAFE,
> 
> Linus did not like the mcsafe name, and this brings it back. Let's
> flip the polarity to positively indicate which routine to use, and to
> match the 'nofault' style which says "copy and handle faults".
> 
> /* do not leave the caches dirty after writes */
> DAXDEV_NOCACHE
> 
> /* handle CPU fetch exceptions during reads */
> DAXDEV_NOMC
> 
> ...and then flip the use cases around.

Sure we can do that.  But let's finish the discussion if we actually
need the virtiofs special casing, as it seems pretty fishy in many
aspects.
