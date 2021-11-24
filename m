Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D5E29CA
	for <nvdimm@lists.linux.dev>; Wed, 24 Nov 2021 06:55:04 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 70B4A68AFE; Wed, 24 Nov 2021 07:55:01 +0100 (CET)
Date: Wed, 24 Nov 2021 07:55:01 +0100
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
Subject: Re: [PATCH 21/29] xfs: move dax device handling into
 xfs_{alloc,free}_buftarg
Message-ID: <20211124065501.GA7229@lst.de>
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-22-hch@lst.de> <CAPcyv4hY4g82PrjMPO=1kiM5sL=3=yR66r6LeG8RS3Ha2k1eUw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hY4g82PrjMPO=1kiM5sL=3=yR66r6LeG8RS3Ha2k1eUw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 23, 2021 at 06:40:47PM -0800, Dan Williams wrote:
> On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Hide the DAX device lookup from the xfs_super.c code.
> >
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> That's an interesting spelling of "Signed-off-by", but patch looks
> good to me too. I would have expected a robot to complain about
> missing sign-off?

Hah.  I'll fix it up.
