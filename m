Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC374203D85E7
 for <linux-nvdimm@lists.01.org>; Mon, 12 Aug 2019 00:42:56 -0700 (PDT)
Date: Mon, 12 Aug 2019 09:40:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] resource: add a not device managed
 request_free_mem_region variant
Message-ID: <20190812074029.GA4709@lst.de>
References: <20190811081247.22111-1-hch@lst.de>
 <20190811081247.22111-3-hch@lst.de> <20190811225252.GB15116@mellanox.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190811225252.GB15116@mellanox.com>
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
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bharata B Rao <bharata@linux.ibm.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Aug 11, 2019 at 10:52:58PM +0000, Jason Gunthorpe wrote:
> It is a bit jarring to have something called devm_* that doesn't
> actually do the devm_ part on some paths.
> 
> Maybe this function should be called __request_free_mem_region() with
> another name wrapper macro?

Seems like a little more churn than required, but I could do it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
