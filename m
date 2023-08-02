Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4918BFB
	for <nvdimm@lists.linux.dev>; Wed,  2 Aug 2023 16:25:21 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id EE95968AA6; Wed,  2 Aug 2023 18:25:11 +0200 (CEST)
Date: Wed, 2 Aug 2023 18:25:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
	"dave.jiang@intel.com" <dave.jiang@intel.com>,
	"ira.weiny@intel.com" <ira.weiny@intel.com>,
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	linux-block@vger.kernel.org
Subject: Re: [PATCH V2 1/1] pmem: set QUEUE_FLAG_NOWAIT
Message-ID: <20230802162511.GA3520@lst.de>
References: <20230731224617.8665-1-kch@nvidia.com> <20230731224617.8665-2-kch@nvidia.com> <x491qgmwzuv.fsf@segfault.boston.devel.redhat.com> <20230801155943.GA13111@lst.de> <x49wmyevej2.fsf@segfault.boston.devel.redhat.com> <0a2d86d6-34a1-0c8d-389c-1dc2f886f108@nvidia.com> <20230802123010.GB30792@lst.de> <17c5d907-d276-bffc-17ca-d796156a2b78@kernel.dk>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17c5d907-d276-bffc-17ca-d796156a2b78@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 02, 2023 at 09:36:32AM -0600, Jens Axboe wrote:
> You can do a LOT of looping over a giant bio and still come out way
> ahead compared to needing to punt to a different thread. So I do think
> it's the right choice. But I'm making assumptions here on what it looks
> like, as I haven't seen the patch...

"a LOT" is relative.  A GB or two will block the submission thread for
quite a while.
