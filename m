Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FAF92021C1B7
 for <linux-nvdimm@lists.01.org>; Sun, 18 Aug 2019 02:06:16 -0700 (PDT)
Date: Sun, 18 Aug 2019 11:04:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/4] memremap: provide a not device managed memremap_pages
Message-ID: <20190818090437.GB20462@lst.de>
References: <20190816065434.2129-1-hch@lst.de>
 <20190816065434.2129-5-hch@lst.de>
 <20190816140057.c1ab8b41b9bfff65b7ea83ba@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190816140057.c1ab8b41b9bfff65b7ea83ba@linux-foundation.org>
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

On Fri, Aug 16, 2019 at 02:00:57PM -0700, Andrew Morton wrote:
> On Fri, 16 Aug 2019 08:54:34 +0200 Christoph Hellwig <hch@lst.de> wrote:
> 
> > The kvmppc ultravisor code wants a device private memory pool that is
> > system wide and not attached to a device.  Instead of faking up one
> > provide a low-level memremap_pages for it.  Note that this function is
> > not exported, and doesn't have a cleanup routine associated with it to
> > discourage use from more driver like users.
> 
> Confused. Which function is "not exported"?

Leftover from v1 and dropped now.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
