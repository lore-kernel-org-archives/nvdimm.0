Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8EE661A1E3B
 for <linux-nvdimm@lists.01.org>; Tue,  4 Oct 2016 22:50:24 -0700 (PDT)
Date: Wed, 5 Oct 2016 07:50:20 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 10/12] dax: add struct iomap based DAX PMD support
Message-ID: <20161005055020.GB20752@quack2.suse.cz>
References: <1475189370-31634-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475189370-31634-11-git-send-email-ross.zwisler@linux.intel.com>
 <20161003105949.GP6457@quack2.suse.cz>
 <20161003210557.GA28177@linux.intel.com>
 <20161004055557.GB17515@quack2.suse.cz>
 <20161004153948.GA21248@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20161004153948.GA21248@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 04-10-16 09:39:48, Ross Zwisler wrote:
> > The gfp_mask that propagates from __do_fault() or do_page_mkwrite() is fine
> > because at that point it is correct. But once we grab filesystem locks
> > which are not reclaim safe, we should update vmf->gfp_mask we pass further
> > down into DAX code to not contain __GFP_FS (that's a bug we apparently have
> > there). And inside DAX code, we definitely are not generally safe to add
> > __GFP_FS to mapping_gfp_mask(). Maybe we'd be better off propagating struct
> > vm_fault into this function, using passed gfp_mask there and make sure
> > callers update gfp_mask as appropriate.
> 
> Yep, that makes sense to me.  In reviewing your set it also occurred to me that
> we might want to stick a struct vm_area_struct *vma pointer in the vmf, since
> you always need a vma when you are using a vmf, but we pass them as a pair
> everywhere.

Actually, vma pointer will be in struct vm_fault after my DAX
write-protection series. So once that lands, we can clean up whatever
duplicit function parameters...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
