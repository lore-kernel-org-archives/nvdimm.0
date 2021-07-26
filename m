Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7A770
	for <nvdimm@lists.linux.dev>; Mon, 26 Jul 2021 08:12:26 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id B8C8067373; Mon, 26 Jul 2021 10:12:17 +0200 (CEST)
Date: Mon, 26 Jul 2021 10:12:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH 03/27] iomap: mark the iomap argument to iomap_sector
 const
Message-ID: <20210726081217.GA14853@lst.de>
References: <20210719103520.495450-1-hch@lst.de> <20210719103520.495450-4-hch@lst.de> <20210719160820.GE22402@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719160820.GE22402@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 19, 2021 at 09:08:20AM -0700, Darrick J. Wong wrote:
> IMHO, constifiying functions is a good way to signal to /programmers/
> that they're not intended to touch the arguments, so

Yes, that is the point here.  Basically the iomap and iter should
be pretty much const, and we almost get there except for the odd
size changed flag for gfs2.
