Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69BF981C71
 for <linux-nvdimm@lists.01.org>; Thu,  3 Nov 2016 20:46:35 -0700 (PDT)
Date: Fri, 4 Nov 2016 04:46:30 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 02/21] mm: Use vmf->address instead of of
 vmf->virtual_address
Message-ID: <20161104034630.GK24234@quack2.suse.cz>
References: <1478039794-20253-1-git-send-email-jack@suse.cz>
 <1478039794-20253-5-git-send-email-jack@suse.cz>
 <06aa01d234c0$1f85e700$5e91b500$@alibaba-inc.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <06aa01d234c0$1f85e700$5e91b500$@alibaba-inc.com>
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
To: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: 'Jan Kara' <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 'Andrew Morton' <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 02-11-16 12:18:10, Hillf Danton wrote:
> On Wednesday, November 02, 2016 6:36 AM Jan Kara wrote:
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 8e8b76d11bb4..2a4ebe3c67c6 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -297,8 +297,6 @@ struct vm_fault {
> >  	gfp_t gfp_mask;			/* gfp mask to be used for allocations */
> >  	pgoff_t pgoff;			/* Logical page offset based on vma */
> >  	unsigned long address;		/* Faulting virtual address */
> > -	void __user *virtual_address;	/* Faulting virtual address masked by
> > -					 * PAGE_MASK */
> >  	pmd_t *pmd;			/* Pointer to pmd entry matching
> >  					 * the 'address'
> >  					 */
> We have a pmd field currently?
> 
> In  [PATCH 01/20] mm: Change type of vmf->virtual_address we see
> [1] __user * gone,
> [2] no field of address added
> and doubt stray merge occurred.
> 
> btw, s:01/20:01/21: in subject line?

Sorry, I had old version of the series in the directory so things got
messed up. I'll resend the series. Thanks for having a look.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
