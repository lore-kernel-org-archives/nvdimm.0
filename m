Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EEC2CA0
	for <nvdimm@lists.linux.dev>; Tue, 21 Dec 2021 08:33:53 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 405B168AFE; Tue, 21 Dec 2021 09:27:44 +0100 (CET)
Date: Tue, 21 Dec 2021 09:27:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, "Darrick J. Wong" <djwong@kernel.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] iomap: Fix error handling in iomap_zero_iter()
Message-ID: <20211221082744.GA5889@lst.de>
References: <20211221044450.517558-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221044450.517558-1-willy@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 21, 2021 at 04:44:50AM +0000, Matthew Wilcox (Oracle) wrote:
> iomap_write_end() does not return a negative errno to indicate an
> error, but the number of bytes successfully copied.  It cannot return
> an error today, so include a debugging assertion like the one in
> iomap_unshare_iter().

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
