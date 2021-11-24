Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467562C81
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 06:52:31 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5343868AFE; Wed, 24 Nov 2021 07:52:28 +0100 (CET)
Date: Wed, 24 Nov 2021 07:52:28 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 18/29] fsdax: decouple zeroing from the iomap buffered
 I/O code
Message-ID: <20211124065228.GC7075@lst.de>
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-19-hch@lst.de> <20211123225315.GM266024@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123225315.GM266024@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 23, 2021 at 02:53:15PM -0800, Darrick J. Wong wrote:
> > -s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
> > +static loff_t dax_zero_iter(struct iomap_iter *iter, bool *did_zero)
> 
> Shouldn't this return value remain s64 to match iomap_iter.processed?

I'll switch it over.  Given that loff_t is always the same as s64
it shouldn't really matter.

(same for the others)
