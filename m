Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E6A68
	for <nvdimm@lists.linux.dev>; Tue, 23 Nov 2021 05:57:47 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id BF5ED68B05; Tue, 23 Nov 2021 06:57:44 +0100 (CET)
Date: Tue, 23 Nov 2021 06:57:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	device-mapper development <dm-devel@redhat.com>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-erofs@lists.ozlabs.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 04/29] dax: simplify the dax_device <-> gendisk
 association
Message-ID: <20211123055742.GB13711@lst.de>
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-5-hch@lst.de> <CAPcyv4ic=Mz_nr5biEoBikTBySJA947ZK3QQ9Mn=KhVb_HiwAA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4ic=Mz_nr5biEoBikTBySJA947ZK3QQ9Mn=KhVb_HiwAA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 22, 2021 at 07:33:06PM -0800, Dan Williams wrote:
> Is it time to add a "DAX" symbol namespace?

What would be the benefit?
