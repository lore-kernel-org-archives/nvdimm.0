Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 96C842034C0A1
 for <linux-nvdimm@lists.01.org>; Fri, 20 Oct 2017 00:44:12 -0700 (PDT)
Date: Fri, 20 Oct 2017 09:47:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 00/13] dax: fix dma vs truncate and remove
 'page-less' support
Message-ID: <20171020074750.GA13568@lst.de>
References: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Dave Hansen <dave.hansen@linux.intel.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Paul Mackerras <paulus@samba.org>, Jeff Layton <jlayton@poochiereds.net>, hch@lst.de, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Sean Hefty <sean.hefty@intel.com>, Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Gerald Schaefer <gerald.schaefer@de.ibm.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@linux-foundation.org, "Darrick J. Wong" <darrick.wong@oracle.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

> The solution presented is not pretty. It creates a stream of leases, one
> for each get_user_pages() invocation, and polls page reference counts
> until DMA stops. We're missing a reliable way to not only trap the
> DMA-idle event, but also block new references being taken on pages while
> truncate is allowed to progress. "[PATCH v3 12/13] dax: handle truncate of
> dma-busy pages" presents other options considered, and notes that this
> solution can only be viewed as a stop-gap.

I'd like to brainstorm how we can do something better.

How about:

If we hit a page with an elevated refcount in truncate / hole puch
etc for a DAX file system we do not free the blocks in the file system,
but add it to the extent busy list.  We mark the page as delayed
free (e.g. page flag?) so that when it finally hits refcount zero we
call back into the file system to remove it from the busy list.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
