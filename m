Return-Path: <owner-linux-mm@kvack.org>
Date: Sun, 11 Oct 2015 14:59:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 01/20] block: generic request_queue reference
	counting
Message-ID: <20151011125935.GA3726@lst.de>
References: <20151010005522.17221.87557.stgit@dwillia2-desk3.jf.intel.com> <20151010005528.17221.4466.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151010005528.17221.4466.stgit@dwillia2-desk3.jf.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Keith Busch <keith.busch@intel.com>, linux-mm@kvack.org, ross.zwisler@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

We could still clean up draing or only release the reference on
bio_done, but let's do that separately and get this infrastructure in
ASAP.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
