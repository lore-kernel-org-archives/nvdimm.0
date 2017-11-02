Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 2 Nov 2017 21:11:16 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/15] dax: quiet bdev_dax_supported()
Message-ID: <20171102201116.GA5732@lst.de>
References: <150949209290.24061.6283157778959640151.stgit@dwillia2-desk3.amr.corp.intel.com> <150949210033.24061.4289855641340001687.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150949210033.24061.4289855641340001687.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Oct 31, 2017 at 04:21:40PM -0700, Dan Williams wrote:
> Before we add another failure reason, quiet the existing log messages.
> Leave it to the caller to decide if bdev_dax_supported() failures are
> errors worth emitting to the log.
> 
> Reported-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
