Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93742C81
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 06:59:41 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2A62068AFE; Wed, 24 Nov 2021 07:59:38 +0100 (CET)
Date: Wed, 24 Nov 2021 07:59:38 +0100
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
Subject: Re: [PATCH 25/29] dax: return the partition offset from
 fs_dax_get_by_bdev
Message-ID: <20211124065938.GB7229@lst.de>
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-26-hch@lst.de> <CAPcyv4jtWzd3c_S1_4fYA1SXTJZfBzP_1xk_OwYkeNp0UhxwSg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jtWzd3c_S1_4fYA1SXTJZfBzP_1xk_OwYkeNp0UhxwSg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 23, 2021 at 06:56:29PM -0800, Dan Williams wrote:
> On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Prepare from removing the block_device from the DAX I/O path by returning
> 
> s/from removing/for the removal of/

Fixed.

> >         td->dm_dev.bdev = bdev;
> > -       td->dm_dev.dax_dev = fs_dax_get_by_bdev(bdev);
> > +       td->dm_dev.dax_dev = fs_dax_get_by_bdev(bdev, &part_off);
> 
> Perhaps allow NULL as an argument for callers that do not care about
> the start offset?

All callers currently care, dm just has another way to get at the
information.  So for now I'd like to not add the NULL special case,
but we can reconsider that as needed if/when more callers show up.
