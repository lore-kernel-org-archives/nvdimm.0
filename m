Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 55CFE2095B9D8
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 00:24:21 -0700 (PDT)
Date: Thu, 24 Aug 2017 09:26:54 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 09/13] dax: Allow dax_iomap_fault() to return pfn
Message-ID: <20170824072654.GD20465@quack2.suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-10-jack@suse.cz>
 <20170823183400.GG13778@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170823183400.GG13778@infradead.org>
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
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, Boaz Harrosh <boazh@netapp.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 23-08-17 11:34:00, Christoph Hellwig wrote:
> > @@ -1416,6 +1416,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
> >   * @vmf: The description of the fault
> >   * @pe_size: Size of the page to fault in
> >   * @ops: Iomap ops passed from the file system
> > + * @pfnp: PFN to insert for synchronous faults if fsync is required
> >   *
> >   * When a page fault occurs, filesystems may call this helper in
> >   * their fault handler for DAX files. dax_iomap_fault() assumes the caller
> > @@ -1423,13 +1424,13 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
> >   * successfully.
> >   */
> >  int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
> > -		    const struct iomap_ops *ops)
> > +		    const struct iomap_ops *ops, pfn_t *pfnp)
> 
> Please keep the iomap_ops argument the last one for the exported
> function (and probably all others for consistency).

Hum, I wanted the output argument to be the last one. But I don't care
much. Swapped.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
