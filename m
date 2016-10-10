Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 44A551A1E47
 for <linux-nvdimm@lists.01.org>; Mon, 10 Oct 2016 08:50:31 -0700 (PDT)
Date: Mon, 10 Oct 2016 17:50:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 14/17] dax: move RADIX_DAX_* defines to dax.h
Message-ID: <20161010155029.GE19343@lst.de>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
 <1475874544-24842-15-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1475874544-24842-15-git-send-email-ross.zwisler@linux.intel.com>
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
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Oct 07, 2016 at 03:09:01PM -0600, Ross Zwisler wrote:
> The RADIX_DAX_* defines currently mostly live in fs/dax.c, with just
> RADIX_DAX_ENTRY_LOCK being in include/linux/dax.h so it can be used in
> mm/filemap.c.  When we add PMD support, though, mm/filemap.c will also need
> access to the RADIX_DAX_PTE type so it can properly construct a 4k sized
> empty entry.
> 
> Instead of shifting the defines between dax.c and dax.h as they are
> individually used in other code, just move them wholesale to dax.h so
> they'll be available when we need them.

Looks fine, assuming that the macros get cleaned up in the next patches..

Reviewed-by: Christoph Hellwig <hch@lst.de>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
