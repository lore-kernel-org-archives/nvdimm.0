Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A761F7B
	for <nvdimm@lists.linux.dev>; Thu, 30 Jun 2022 18:05:00 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id F278868AA6; Thu, 30 Jun 2022 20:04:55 +0200 (CEST)
Date: Thu, 30 Jun 2022 20:04:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org, hch@lst.de,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH] pmem: fix a name collision
Message-ID: <20220630180455.GA17898@lst.de>
References: <20220630175155.3144222-1-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630175155.3144222-1-jane.chu@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 30, 2022 at 11:51:55AM -0600, Jane Chu wrote:
> -static phys_addr_t to_phys(struct pmem_device *pmem, phys_addr_t offset)
> +static phys_addr_t _to_phys(struct pmem_device *pmem, phys_addr_t offset)

I'd rather call this pmem_to_phys as that is a much nicer name.
