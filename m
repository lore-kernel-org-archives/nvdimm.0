Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F775A12
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 12:28:21 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id CD72668AFE; Tue,  1 Mar 2022 13:19:26 +0100 (CET)
Date: Tue, 1 Mar 2022 13:19:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Justin Sanders <justin@coraid.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Denis Efremov <efremov@linux.com>, Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>, Coly Li <colyli@suse.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org,
	drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 03/10] zram: use memcpy_to_bvec in zram_bvec_read
Message-ID: <20220301121926.GA3405@lst.de>
References: <20220222155156.597597-1-hch@lst.de> <20220222155156.597597-4-hch@lst.de> <Yh1ycd3S/FKAtnuD@iweiny-desk3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh1ycd3S/FKAtnuD@iweiny-desk3>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 28, 2022 at 05:10:09PM -0800, Ira Weiny wrote:
> On Tue, Feb 22, 2022 at 04:51:49PM +0100, Christoph Hellwig wrote:
> > Use the proper helper instead of open coding the copy.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks fine but I don't see a reason to keep the other operation atomic.  Could
> the src map also use kmap_local_page()?

That switch obviously makes sense, but in this series I've focussed on
the bio_vec maps so far.
