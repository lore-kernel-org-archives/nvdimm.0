Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <20151011125935.GA3726@lst.de>
References: <20151010005522.17221.87557.stgit@dwillia2-desk3.jf.intel.com>
	<20151010005528.17221.4466.stgit@dwillia2-desk3.jf.intel.com>
	<20151011125935.GA3726@lst.de>
Date: Mon, 12 Oct 2015 17:09:08 -0700
Message-ID: <CAPcyv4ht4y7_ed92U+GpS6M-Ei+95FTAMW+owPM7S5FCLip2og@mail.gmail.com>
Subject: Re: [PATCH v2 01/20] block: generic request_queue reference counting
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Keith Busch <keith.busch@intel.com>, Linux MM <linux-mm@kvack.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Oct 11, 2015 at 5:59 AM, Christoph Hellwig <hch@lst.de> wrote:
> Looks good,
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> We could still clean up draing or only release the reference on
> bio_done, but let's do that separately and get this infrastructure in
> ASAP.

Thanks Christoph.

Jens, do you want to take this, or ok for me to take this through nvdimm.git?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
