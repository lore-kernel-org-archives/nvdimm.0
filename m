Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5575A81F03
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jan 2017 10:42:17 -0800 (PST)
From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: [PATCH] dax: put back __GFP_IO in the dax fault handler
Date: Tue, 24 Jan 2017 18:42:16 +0000
Message-ID: <112A412BB11A1242B37129D931BCE53472BD2294@fmsmsx116.amr.corp.intel.com>
References: <148521639006.25631.4184774582309071957.stgit@djiang5-desk3.ch.intel.com>
 <20170124183146.GA28860@linux.intel.com>
In-Reply-To: <20170124183146.GA28860@linux.intel.com>
Content-Language: en-US
MIME-Version: 1.0
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Ross Zwisler [mailto:ross.zwisler@linux.intel.com]
> Sent: Tuesday, January 24, 2017 11:32 AM
> To: Jiang, Dave <dave.jiang@intel.com>
> Cc: Williams, Dan J <dan.j.williams@intel.com>; ross.zwisler@linux.intel.com; linux-nvdimm@lists.01.org
> Subject: Re: [PATCH] dax: put back __GFP_IO in the dax fault handler
> 
> On Mon, Jan 23, 2017 at 05:06:30PM -0700, Dave Jiang wrote:
> > __GFP_IO got accidentally dropped in the dax fault handler during the
> > vmf parameter conversion. Putting it back.
> >
> > Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> 
> I don't see why this is needed?  We already have an overly generous gfp_mask
> that explicitly includes both __GFP_FS (which is probably wrong), and
> __GFP_IO.  I ran a quick test to verify this, and when I get a PMD fault my
> mask does indeed include both __GFP_IO and __GFP_FS.  The test was done with
> the current mmots/master and this patch.
> 
> The mask is set up in __handle_mm_fault() => __get_fault_gfp_mask().
> 
> So, no need to mess with the mask.  Also, the patch is wrong because if
> __GFP_IO *was* already part of the gfp_mask, this patch would re-add it, then
> unconditionally remove it.  So, with the current code we would end up with a
> more restrictive mask when we exited the PMD fault handler.  Really if we
> wanted to do something like this we would need to save and restore, not just
> OR in a value and then mask it back out.

Ok I'll drop the patch.

> 
> > ---
> >  fs/dax.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/fs/dax.c b/fs/dax.c
> > index 2e90f7a..20e9db8 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -1332,6 +1332,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, struct iomap_ops *ops)
> >  	loff_t pos;
> >  	int error;
> >
> > +	vmf->gfp_mask |= __GFP_IO;
> >  	/*
> >  	 * Check whether offset isn't beyond end of file now. Caller is
> >  	 * supposed to hold locks serializing us with truncate / punch hole so
> > @@ -1423,6 +1424,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf, struct iomap_ops *ops)
> >  	}
> >  out:
> >  	trace_dax_pmd_fault_done(inode, vmf, max_pgoff, result);
> > +	vmf->gfp_mask &= ~__GFP_IO;
> >  	return result;
> >  }
> >  #else
> >
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
