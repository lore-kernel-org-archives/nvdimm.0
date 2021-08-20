Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7AF72
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 04:12:07 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9275E6736F; Fri, 20 Aug 2021 06:11:58 +0200 (CEST)
Date: Fri, 20 Aug 2021 06:11:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>, cluster-devel@redhat.com
Subject: Re: [PATCH 11/30] iomap: add the new iomap_iter model
Message-ID: <20210820041158.GA26417@lst.de>
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-12-hch@lst.de> <CAPcyv4hbSYnOC6Pdi1QShRxGjBAteig7nN1h-5cEvsFDX9SuAQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hbSYnOC6Pdi1QShRxGjBAteig7nN1h-5cEvsFDX9SuAQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Aug 19, 2021 at 02:25:52PM -0700, Dan Williams wrote:
> Given most of the iomap_iter users don't care about srcmap, i.e. are
> not COW cases, they are leaving srcmap zero initialized. Should the
> IOMAP types be incremented by one so that there is no IOMAP_HOLE
> confusion? In other words, fold something like this?

A hole really means nothing to read from the source.  The existing code
also relies on that.
