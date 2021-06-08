Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFB872
	for <nvdimm@lists.linux.dev>; Tue,  8 Jun 2021 05:36:36 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 23B5C67373; Tue,  8 Jun 2021 07:36:28 +0200 (CEST)
Date: Tue, 8 Jun 2021 07:36:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, Sachin Sant <sachinp@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	Ulf Hansson <ulf.hansson@linaro.org>, nvdimm@lists.linux.dev,
	linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2] libnvdimm/pmem: Fix blk_cleanup_disk() usage
Message-ID: <20210608053627.GB14116@lst.de>
References: <162310861219.1571453.6561642225122047071.stgit@dwillia2-desk3.amr.corp.intel.com> <162310994435.1571616.334551212901820961.stgit@dwillia2-desk3.amr.corp.intel.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162310994435.1571616.334551212901820961.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Thanks Dan, this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Jens, can you quickly pick this up?
