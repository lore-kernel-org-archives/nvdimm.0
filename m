Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CBBDF46
	for <nvdimm@lists.linux.dev>; Wed,  2 Aug 2023 12:30:15 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3BE1868AA6; Wed,  2 Aug 2023 14:30:11 +0200 (CEST)
Date: Wed, 2 Aug 2023 14:30:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, axboe@kernel.dk,
	linux-block@vger.kernel.org
Subject: Re: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
Message-ID: <20230802123010.GB30792@lst.de>
References: <20230731224617.8665-1-kch@nvidia.com> <20230731224617.8665-2-kch@nvidia.com> <x491qgmwzuv.fsf@segfault.boston.devel.redhat.com> <20230801155943.GA13111@lst.de> <x49wmyevej2.fsf@segfault.boston.devel.redhat.com> <0a2d86d6-34a1-0c8d-389c-1dc2f886f108@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a2d86d6-34a1-0c8d-389c-1dc2f886f108@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Given that pmem simply loops over an arbitrarily large bio I think
we also need a threshold for which to allow nowait I/O.  While it
won't block for giant I/Os, doing all of them in the submitter
context isn't exactly the idea behind the nowait I/O.

I'm not really sure what a good theshold would be, though.

Btw, please also always add linux-block to the Cc list for block
driver patches that are even the slightest bit about the block
layer interface.
