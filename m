Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E7A72
	for <nvdimm@lists.linux.dev>; Thu, 12 Aug 2021 06:50:32 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 53CFE68AFE; Thu, 12 Aug 2021 08:50:30 +0200 (CEST)
Date: Thu, 12 Aug 2021 08:50:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	nvdimm@lists.linux.dev, cluster-devel@redhat.com
Subject: Re: [PATCH v2.1 19/30] iomap: switch iomap_bmap to use iomap_iter
Message-ID: <20210812065029.GB27145@lst.de>
References: <20210809061244.1196573-1-hch@lst.de> <20210809061244.1196573-20-hch@lst.de> <20210811191800.GH3601443@magnolia>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811191800.GH3601443@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 11, 2021 at 12:18:00PM -0700, Darrick J. Wong wrote:
> +	while ((ret = iomap_iter(&iter, ops)) > 0) {
> +		if (iter.iomap.type == IOMAP_MAPPED)
> +			bno = iomap_sector(&iter.iomap, iter.pos) >> blkshift;
> +		/* leave iter.processed unset to abort loop */
> +	}

This looks ok, thanks.
