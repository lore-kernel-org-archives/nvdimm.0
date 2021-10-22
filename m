Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3745A2C81
	for <nvdimm@lists.linux.dev>; Fri, 22 Oct 2021 05:55:25 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 53E8368BEB; Fri, 22 Oct 2021 07:55:16 +0200 (CEST)
Date: Fri, 22 Oct 2021 07:55:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: Adam Borowski <kilobyte@angband.pl>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Jens Axboe <axboe@kernel.dk>, Yi Zhang <yi.zhang@redhat.com>,
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/2] memremap: remove support for external pgmap
 refcounts
Message-ID: <20211022055515.GA21767@lst.de>
References: <20211019073641.2323410-1-hch@lst.de> <20211019073641.2323410-3-hch@lst.de> <YXFtwcAC0WyxIWIC@angband.pl>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXFtwcAC0WyxIWIC@angband.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Oct 21, 2021 at 03:40:17PM +0200, Adam Borowski wrote:
> This breaks at least drivers/pci/p2pdma.c:222

Indeed.  I've updated this patch, but the fix we need to urgently
get into 5.15-rc is the first one only anyway.

nvdimm maintainers, can you please act on it ASAP?
