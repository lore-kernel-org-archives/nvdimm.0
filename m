Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3AD6F1A1E83
 for <linux-nvdimm@lists.01.org>; Mon,  3 Oct 2016 07:58:05 -0700 (PDT)
Date: Mon, 3 Oct 2016 16:58:02 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/6] dax: Avoid page invalidation races and unnecessary
 radix tree traversals
Message-ID: <20161003145802.GD14183@quack2.suse.cz>
References: <1474994615-29553-1-git-send-email-jack@suse.cz>
 <1474994615-29553-7-git-send-email-jack@suse.cz>
 <20160928002034.GF9806@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160928002034.GF9806@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed 28-09-16 10:20:34, Dave Chinner wrote:
> On Tue, Sep 27, 2016 at 06:43:35PM +0200, Jan Kara wrote:
> > @@ -1410,6 +1422,17 @@ iomap_dax_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
> >  	if (WARN_ON_ONCE(iomap->type != IOMAP_MAPPED))
> >  		return -EIO;
> >  
> > +	/*
> > +	 * Write can allocate block for an area which has a hole page mapped
> > +	 * into page tables. We have to tear down these mappings so that data
> > +	 * written by write(2) is visible in mmap.
> > +	 */
> > +	if (iomap->flags & IOMAP_F_NEW && inode->i_mapping->nrpages) {
> 
> gcc should be throwing warnings about that:
> 
> 	if ((iomap->flags & IOMAP_F_NEW) && inode->i_mapping->nrpages) {

Actually the bitwise '&' takes precedense over the logical '&&' so the
evaluation order ends up being correct. But I agree it's better to be
explicit with parenthesis here. Fixed.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
