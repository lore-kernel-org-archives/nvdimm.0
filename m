Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE812C99
	for <nvdimm@lists.linux.dev>; Mon, 13 Dec 2021 08:27:19 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8C12868BFE; Mon, 13 Dec 2021 09:27:15 +0100 (CET)
Date: Mon, 13 Dec 2021 09:27:15 +0100
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
Subject: Re: [PATCH 1/5] uio: remove copy_from_iter_flushcache() and
 copy_mc_to_iter()
Message-ID: <20211213082715.GD21462@lst.de>
References: <20211209063828.18944-1-hch@lst.de> <20211209063828.18944-2-hch@lst.de> <CAPcyv4gwfVi389e+cES=E6O13+y36OffZPCe+iZguCT_gpjmZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gwfVi389e+cES=E6O13+y36OffZPCe+iZguCT_gpjmZA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Dec 12, 2021 at 06:22:20AM -0800, Dan Williams wrote:
> > - * Use the 'no check' versions of copy_from_iter_flushcache() and
> > - * copy_mc_to_iter() to bypass HARDENED_USERCOPY overhead. Bounds
> > + * Use the 'no check' versions of _copy_from_iter_flushcache() and
> > + * _copy_mc_to_iter() to bypass HARDENED_USERCOPY overhead. Bounds
> >   * checking, both file offset and device offset, is handled by
> >   * dax_iomap_actor()
> >   */
> 
> This comment change does not make sense since it is saying why pmem is
> using the "_" versions. However, I assume this whole comment goes away
> in a later patch.

It does not go away in this series.
