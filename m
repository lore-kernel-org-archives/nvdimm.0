Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B5C4DC61
	for <nvdimm@lists.linux.dev>; Tue,  1 Aug 2023 15:59:52 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 78A186732D; Tue,  1 Aug 2023 17:59:43 +0200 (CEST)
Date: Tue, 1 Aug 2023 17:59:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com,
	hch@lst.de, nvdimm@lists.linux.dev
Subject: Re: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
Message-ID: <20230801155943.GA13111@lst.de>
References: <20230731224617.8665-1-kch@nvidia.com> <20230731224617.8665-2-kch@nvidia.com> <x491qgmwzuv.fsf@segfault.boston.devel.redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x491qgmwzuv.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 01, 2023 at 11:23:36AM -0400, Jeff Moyer wrote:
> I am slightly embarrassed to have to ask this question, but what are the
> implications of setting this queue flag?  Is the submit_bio routine
> expected to never block?

Yes, at least not significantly.

> Is the I/O expected to be performed
> asynchronously?

Not nessecarily if it is fast enough..

