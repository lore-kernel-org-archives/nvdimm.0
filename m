Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB1F52021C1B7
 for <linux-nvdimm@lists.01.org>; Sun, 18 Aug 2019 02:05:15 -0700 (PDT)
Date: Sun, 18 Aug 2019 11:03:34 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] resource: add a not device managed
 request_free_mem_region variant
Message-ID: <20190818090334.GA20462@lst.de>
References: <20190816065434.2129-1-hch@lst.de>
 <20190816065434.2129-2-hch@lst.de>
 <20190816140134.1f3225bed9bf2734c03341b1@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190816140134.1f3225bed9bf2734c03341b1@linux-foundation.org>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>, linux-mm@kvack.org, Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 16, 2019 at 02:01:34PM -0700, Andrew Morton wrote:
> On Fri, 16 Aug 2019 08:54:31 +0200 Christoph Hellwig <hch@lst.de> wrote:
> 
> > Just add a simple macro that passes a NULL dev argument to
> > dev_request_free_mem_region, and call request_mem_region in the
> > function for that particular case.
> 
> Nit:
> 
> > +struct resource *request_free_mem_region(struct resource *base,
> > +		unsigned long size, const char *name);
> 
> This isn't a macro ;)

Oops, the changelog needs updating vs the first version of course.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
