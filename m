Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ACE0E2095DB87
 for <linux-nvdimm@lists.01.org>; Mon, 24 Jul 2017 08:57:10 -0700 (PDT)
Date: Mon, 24 Jul 2017 17:59:06 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 1/5] mm: add mkwrite param to vm_insert_mixed()
Message-ID: <20170724155906.GR652@quack2.suse.cz>
References: <20170721223956.29485-1-ross.zwisler@linux.intel.com>
 <20170721223956.29485-2-ross.zwisler@linux.intel.com>
 <20170724112530.GI652@quack2.suse.cz>
 <20170724152357.GB1639@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170724152357.GB1639@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-doc@vger.kernel.org, David Airlie <airlied@linux.ie>, Dave Chinner <david@fromorbit.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Christoph Hellwig <hch@lst.de>, linux-samsung-soc@vger.kernel.org, Joonyoung Shim <jy0922.shim@samsung.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>, Kyungmin Park <kyungmin.park@samsung.com>, Krzysztof Kozlowski <krzk@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-ext4@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-arm-msm@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Inki Dae <inki.dae@samsung.com>, linux-nvdimm@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-arm-kernel@lists.infradead.org, Theodore Ts'o <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>, Seung-Woo Kim <sw0312.kim@samsung.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Rob Clark <robdclark@gmail.com>, Kukjin Kim <kgene@kernel.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, freedreno@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 24-07-17 09:23:57, Ross Zwisler wrote:
> On Mon, Jul 24, 2017 at 01:25:30PM +0200, Jan Kara wrote:
> > > @@ -1658,14 +1658,28 @@ static int insert_pfn(struct vm_area_struct *vma, unsigned long addr,
> > >  	if (!pte)
> > >  		goto out;
> > >  	retval = -EBUSY;
> > > -	if (!pte_none(*pte))
> > > -		goto out_unlock;
> > > +	if (!pte_none(*pte)) {
> > > +		if (mkwrite) {
> > > +			if (WARN_ON_ONCE(pte_pfn(*pte) != pfn_t_to_pfn(pfn)))
> > 
> > Is the WARN_ON_ONCE() really appropriate here? Your testcase with private
> > mappings has triggered this situation if I'm right...
> 
> Yep, I think this WARN_ON_ONCE() is correct.  The test with private mappings
> had collisions between read-only DAX mappings which were being faulted in via
> insert_pfn(), and read/write COW page cache mappings which were being faulted
> in by wp_page_copy().
> 
> I was hitting a false-positive warning when I had the WARN_ON_ONCE() in
> insert_pfn() outside of the mkwrite case, i.e.:
> 
> 	if (!pte_none(*pte)) {
> 		if (WARN_ON_ONCE(pte_pfn(*pte) != pfn_t_to_pfn(pfn)))
> 			goto out_unlock;
> 		if (mkwrite) {
> 			entry = *pte;
> 			goto out_mkwrite;
> 		} else
> 			goto out_unlock;
> 	}
> 
> This was triggering when one thread was faulting in a read-only DAX mapping
> when another thread had already faulted in a read-write COW page cache page.
> 
> The patches I sent out have the warning in the mkwrite case, which would mean
> that we were getting a fault for a read/write PTE in insert_pfn() and the PFN
> didn't match what was already in the PTE.
> 
> This can't ever happen in the private mapping case because we will never
> install a read/write PTE for normal storage, only for COW page cache pages.
> Essentially I don't think we should ever be able to hit this warning, and if
> we do I'd like to get the bug report so that I can track down how it was
> happening and make sure that it's safe.  It is in the mkwrite path of
> insert_pfn() which is currently only used by the DAX code.
> 
> Does that make sense to you, or would you recommend leaving it out?  (If so,
> why?)

Ah, OK, makes sense. So feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
