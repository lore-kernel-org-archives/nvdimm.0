Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4A35A12
	for <nvdimm@lists.linux.dev>; Tue,  1 Mar 2022 12:20:46 +0000 (UTC)
Received: by verein.lst.de (Postfix, from userid 2407)
	id DB11D68BEB; Tue,  1 Mar 2022 13:20:42 +0100 (CET)
Date: Tue, 1 Mar 2022 13:20:42 +0100
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
Subject: Re: [PATCH 06/10] nvdimm-btt: use bvec_kmap_local in
 btt_rw_integrity
Message-ID: <20220301122042.GB3405@lst.de>
References: <20220222155156.597597-1-hch@lst.de> <20220222155156.597597-7-hch@lst.de> <Yh2aCi6gtG0naC1r@iweiny-desk3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yh2aCi6gtG0naC1r@iweiny-desk3>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 28, 2022 at 07:59:06PM -0800, Ira Weiny wrote:
> On Tue, Feb 22, 2022 at 04:51:52PM +0100, Christoph Hellwig wrote:
> > Using local kmaps slightly reduces the chances to stray writes, and
> > the bvec interface cleans up the code a little bit.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/nvdimm/btt.c | 10 ++++------
> >  1 file changed, 4 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> > index cbd994f7f1fe6..9613e54c7a675 100644
> > --- a/drivers/nvdimm/btt.c
> > +++ b/drivers/nvdimm/btt.c
> > @@ -1163,17 +1163,15 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
> >  		 */
> >  
> >  		cur_len = min(len, bv.bv_len);
> > -		mem = kmap_atomic(bv.bv_page);
> > +		mem = bvec_kmap_local(&bv);
> >  		if (rw)
> > -			ret = arena_write_bytes(arena, meta_nsoff,
> > -					mem + bv.bv_offset, cur_len,
> > +			ret = arena_write_bytes(arena, meta_nsoff, mem, cur_len,
> 
> Why drop bv.bv_offset here and below?

Because bvec_kmap_local includes bv_offset in the pointer that it
returns.
