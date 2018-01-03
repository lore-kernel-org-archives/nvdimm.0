Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4B9722280C30
 for <linux-nvdimm@lists.01.org>; Wed,  3 Jan 2018 08:00:01 -0800 (PST)
Date: Wed, 3 Jan 2018 17:05:03 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 11/18] fs, dax: introduce DEFINE_FSDAX_AOPS
Message-ID: <20180103160503.GM4911@quack2.suse.cz>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407701943.38751.8997225433943672290.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171227052910.GE24828@bombadil.infradead.org>
 <CAPcyv4ibKYi_zE=V2W_aLghtr3LiC30A2ffFq-aPQCrikwgy2w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4ibKYi_zE=V2W_aLghtr3LiC30A2ffFq-aPQCrikwgy2w@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Matthew Wilcox <mawilcox@microsoft.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 02-01-18 12:21:28, Dan Williams wrote:
> >> +EXPORT_SYMBOL(dax_set_page_dirty);
> >> +EXPORT_SYMBOL(dax_direct_IO);
> >> +EXPORT_SYMBOL(dax_writepage);
> >> +EXPORT_SYMBOL(dax_readpage);
> >> +EXPORT_SYMBOL(dax_readpages);
> >> +EXPORT_SYMBOL(dax_write_begin);
> >> +EXPORT_SYMBOL(dax_write_end);
> >> +EXPORT_SYMBOL(dax_invalidatepage);
> >
> > Exporting all these symbols to modules isn't exactly free.  Are you sure it
> > doesn't make more sense to put tests for dax in the existing aops?
> >
> 
> I'd rather have just one global fs_dax_aops instance that all
> filesystems could reference, but ->writepages() is fundamentally an
> address_space_operation. Until we can rework that I'd prefer the
> overhead of the extra exports than sprinkling more IS_DAX checks
> around.

Just for record I agree with what Dave said about this patch. Generic
address_space_operations are not how aops are commonly defined by
filesystems. Just create one structure for each fs as Dave suggested.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
