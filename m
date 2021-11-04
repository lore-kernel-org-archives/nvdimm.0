Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FFD2C8B
	for <nvdimm@lists.linux.dev>; Thu,  4 Nov 2021 08:27:50 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9396E68AA6; Thu,  4 Nov 2021 09:17:40 +0100 (CET)
Date: Thu, 4 Nov 2021 09:17:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	dm-devel@redhat.com, linux-xfs@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: futher decouple DAX from block devices
Message-ID: <20211104081740.GA23111@lst.de>
References: <20211018044054.1779424-1-hch@lst.de> <21ff4333-e567-2819-3ae0-6a2e83ec7ce6@sandeen.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21ff4333-e567-2819-3ae0-6a2e83ec7ce6@sandeen.net>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 03, 2021 at 12:59:31PM -0500, Eric Sandeen wrote:
> Christoph, can I ask what the end game looks like, here? If dax is completely
> decoupled from block devices, are there user-visible changes?

Yes.

> If I want to
> run fs-dax on a pmem device - what do I point mkfs at, if not a block device?

The rough plan is to use the device dax character devices.  I'll hopefully
have a draft version in the next days.
