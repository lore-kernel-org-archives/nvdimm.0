Return-Path: <owner-linux-mm@kvack.org>
Date: Sun, 1 Oct 2017 09:57:01 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 0/4] dax: require 'struct page' and other fixups
Message-ID: <20171001075701.GB11554@lst.de>
References: <150664806143.36094.11882924009668860273.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150664806143.36094.11882924009668860273.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

While this looks like a really nice cleanup of the code and removes
nasty race conditions I'd like to understand the tradeoffs.

This now requires every dax device that is used with a file system
to have a struct page backing, which means not only means we'd
break existing setups, but also a sharp turn from previous policy.

Unless I misremember it was you Intel guys that heavily pushed for
the page-less version, so I'd like to understand why you've changed
your mind.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
