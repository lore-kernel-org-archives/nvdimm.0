Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBFC33FE
	for <nvdimm@lists.linux.dev>; Wed,  2 Mar 2022 17:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646240780; x=1677776780;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZDYri7lCowU3GJr6M0z1hSFUZr0wdNpx1kXCi+W+DLY=;
  b=MqE0DNwEmwtfpTeySFLdXWki/BYJiIjQ/NiIrXvk+CtXuq0ZI+Iz5FgB
   fipM+FVl8HlDhmRsOTRjZMhSMRju5juXothKStkWvB2Q6ZTfv7/A4Sp48
   OCwJwx47fZ+EUbOqaAthCUZedmry497XoJ2ymxU4iAS1GpgeMjJdJLUG1
   2rI06p2lrzGz+b6tDh0vxZuL8C6F2eO5aTy4AUg4z5hLXMPP3lcfDb286
   ATKeN10rwU57kLLAW0E9iHIOrb5ai86BfVEbGBtbLKS5UqNRkw3olAfL6
   h3LqWmBXx8t29M7GUtgr+R3kWtH7zTgWhzUV1lAar0A0+zOW4TfzITgMx
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="236963386"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="236963386"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 09:04:52 -0800
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="493606916"
Received: from akshatak-mobl.amr.corp.intel.com (HELO localhost) ([10.212.41.96])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 09:04:51 -0800
Date: Wed, 2 Mar 2022 09:04:50 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
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
Subject: Re: [PATCH 06/10] nvdimm-btt: use bvec_kmap_local in btt_rw_integrity
Message-ID: <Yh+jshFsKMt+iI55@iweiny-desk3>
References: <20220222155156.597597-1-hch@lst.de>
 <20220222155156.597597-7-hch@lst.de>
 <Yh2aCi6gtG0naC1r@iweiny-desk3>
 <20220301122042.GB3405@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301122042.GB3405@lst.de>

On Tue, Mar 01, 2022 at 01:20:42PM +0100, Christoph Hellwig wrote:
> On Mon, Feb 28, 2022 at 07:59:06PM -0800, Ira Weiny wrote:
> > On Tue, Feb 22, 2022 at 04:51:52PM +0100, Christoph Hellwig wrote:
> > > Using local kmaps slightly reduces the chances to stray writes, and
> > > the bvec interface cleans up the code a little bit.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  drivers/nvdimm/btt.c | 10 ++++------
> > >  1 file changed, 4 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> > > index cbd994f7f1fe6..9613e54c7a675 100644
> > > --- a/drivers/nvdimm/btt.c
> > > +++ b/drivers/nvdimm/btt.c
> > > @@ -1163,17 +1163,15 @@ static int btt_rw_integrity(struct btt *btt, struct bio_integrity_payload *bip,
> > >  		 */
> > >  
> > >  		cur_len = min(len, bv.bv_len);
> > > -		mem = kmap_atomic(bv.bv_page);
> > > +		mem = bvec_kmap_local(&bv);
> > >  		if (rw)
> > > -			ret = arena_write_bytes(arena, meta_nsoff,
> > > -					mem + bv.bv_offset, cur_len,
> > > +			ret = arena_write_bytes(arena, meta_nsoff, mem, cur_len,
> > 
> > Why drop bv.bv_offset here and below?
> 
> Because bvec_kmap_local includes bv_offset in the pointer that it
> returns.

Ah I missed that.  Thanks,
Ira
