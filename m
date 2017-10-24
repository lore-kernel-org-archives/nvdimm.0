Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9FFC0203525FF
 for <linux-nvdimm@lists.01.org>; Tue, 24 Oct 2017 06:04:27 -0700 (PDT)
Date: Tue, 24 Oct 2017 15:08:08 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/17] mm: introduce MAP_SHARED_VALIDATE, a mechanism to
 safely define new mmap flags
Message-ID: <20171024130808.GC8556@quack2.suse.cz>
References: <20171019125817.11580-1-jack@suse.cz>
 <20171019125817.11580-2-jack@suse.cz>
 <20171020072707.GA18000@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171020072707.GA18000@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri 20-10-17 00:27:07, Christoph Hellwig wrote:
> >  	if (file) {
> >  		struct inode *inode = file_inode(file);
> > +		unsigned long flags_mask = file->f_op->mmap_supported_flags;
> > +
> > +		if (!flags_mask)
> > +			flags_mask = LEGACY_MAP_MASK;
> >  
> >  		switch (flags & MAP_TYPE) {
> >  		case MAP_SHARED:
> > +			/*
> > +			 * Silently ignore unsupported flags - MAP_SHARED has
> > +			 * traditionally behaved like that and we don't want
> > +			 * to break compatibility.
> > +			 */
> > +			flags &= flags_mask;
> > +			/*
> > +			 * Force use of MAP_SHARED_VALIDATE with non-legacy
> > +			 * flags. E.g. MAP_SYNC is dangerous to use with
> > +			 * MAP_SHARED as you don't know which consistency model
> > +			 * you will get.
> > +			 */
> > +			flags &= LEGACY_MAP_MASK;
> > +			/* fall through */
> > +		case MAP_SHARED_VALIDATE:
> > +			if (flags & ~flags_mask)
> > +				return -EOPNOTSUPP;
> 
> Hmmm.  I'd expect this to worth more like:
> 
> 		case MAP_SHARED:
> 			/* Ignore all new flags that need validation: */
> 			flags &= LEGACY_MAP_MASK;
> 			/*FALLTHROUGH*/
> 		case MAP_SHARED_VALIDATE:
> 			if (flags & ~file->f_op->mmap_supported_flags)
> 				return -EOPNOTSUPP;
> 
> with the legacy mask always implicitly support as indicated in my
> comment to the XFS patch.

I was thinking about this. Originally I thought that mmap_supported_flags
would allow also to declare some legacy flags as unsupported and also it
seemed as a nicer symmetric interface to me. But I guess the need to mask
out legacy flags is mostly theoretical so I'm fine giving that up. So I'll
change this as you suggest.

> Although even the ignoring in MAP_SHARED seems dangerous, but I guess
> we need that to keep strict backwards compatibility.  In world I'd
> rather do
> 
> 	case MAP_SHARED:
> 		if (flags & ~LEGACY_MAP_MASK)
> 			return -EINVAL;

Yes, I think just ignoring new flags for MAP_SHARED is safer...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
