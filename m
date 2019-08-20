Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CF9382020D334
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 19:27:45 -0700 (PDT)
Date: Tue, 20 Aug 2019 04:26:19 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] resource: add a not device managed
 request_free_mem_region variant
Message-ID: <20190820022619.GA23225@lst.de>
References: <20190818090557.17853-1-hch@lst.de>
 <20190818090557.17853-2-hch@lst.de>
 <CAPcyv4iaNtmvU5e8_8SV9XsmVCfnv8e7_YfMi46LfOF4W155zg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iaNtmvU5e8_8SV9XsmVCfnv8e7_YfMi46LfOF4W155zg@mail.gmail.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Bharata B Rao <bharata@linux.ibm.com>, Linux MM <linux-mm@kvack.org>, Jason Gunthorpe <jgg@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 19, 2019 at 06:28:30PM -0700, Dan Williams wrote:
> 
> Previously we would loudly crash if someone passed NULL to
> devm_request_free_mem_region(), but now it will silently work and the
> result will leak. Perhaps this wants a:

We'd still instantly crash due to the dev_name dereference, right?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
