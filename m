Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5759D20304301
 for <linux-nvdimm@lists.01.org>; Wed, 14 Aug 2019 04:27:45 -0700 (PDT)
Date: Wed, 14 Aug 2019 13:25:35 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/5] memremap: provide a not device managed memremap_pages
Message-ID: <20190814112535.GA2339@lst.de>
References: <20190811081247.22111-1-hch@lst.de>
 <20190811081247.22111-6-hch@lst.de> <20190812145058.GA16950@in.ibm.com>
 <20190812150012.GA12700@lst.de> <20190813045611.GB16950@in.ibm.com>
 <20190814061150.GA24835@lst.de> <20190814085826.GB8784@in.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190814085826.GB8784@in.ibm.com>
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
To: Bharata B Rao <bharata@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 14, 2019 at 02:28:26PM +0530, Bharata B Rao wrote:
> >     http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/pgmap-remove-dev
> > 
> > works for you fully before I resend?
> 
> Yes, this works for us. This and migrate-vma-cleanup series helps to
> really simplify the kvmppc secure pages management code. Thanks.

Thanks.  I'm going to resend it once we've made a bit of progress
on the migrate_vma series that I resent this morning.  There are
a few more lose ends in this area with implications for the driver
API, so I might have a few more patches for you to test in a bit.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
