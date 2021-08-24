Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E543FC1
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 05:44:07 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7FCB867357; Tue, 24 Aug 2021 07:44:03 +0200 (CEST)
Date: Tue, 24 Aug 2021 07:44:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 7/9] dax: stub out dax_supported for !CONFIG_FS_DAX
Message-ID: <20210824054403.GA23025@lst.de>
References: <20210823123516.969486-1-hch@lst.de> <20210823123516.969486-8-hch@lst.de> <CAPcyv4hezYrurYEsBZ-7obnNYr0qbdtw+k0NBviOqqgT70ZL+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hezYrurYEsBZ-7obnNYr0qbdtw+k0NBviOqqgT70ZL+w@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 23, 2021 at 02:15:47PM -0700, Dan Williams wrote:
> > +static inline bool dax_supported(struct dax_device *dax_dev,
> > +               struct block_device *bdev, int blocksize, sector_t start,
> > +               sector_t len)
> > +{
> > +       return false;
> > +}
> 
> I've started clang-formatting new dax and nvdimm code:
> 
> static inline bool dax_supported(struct dax_device *dax_dev,
>                                  struct block_device *bdev, int blocksize,
>                                  sector_t start, sector_t len)
> {
>         return false;
> }
> 
> ...but I also don't mind staying consistent with the surrounding code for now.

While Linux has historically used both styles, I find this second one
pretty horrible.  It is hard to read due to the huge amounts of wasted
space, and needs constant realignment when the return type or symbol
name changes.
