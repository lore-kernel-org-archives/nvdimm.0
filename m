Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 40E1520214B40
 for <linux-nvdimm@lists.01.org>; Sun, 18 Aug 2019 23:31:50 -0700 (PDT)
Date: Mon, 19 Aug 2019 08:30:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: add a not device managed memremap_pages v3
Message-ID: <20190819063015.GA20248@lst.de>
References: <20190818090557.17853-1-hch@lst.de>
 <20190819052752.GD8784@in.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190819052752.GD8784@in.ibm.com>
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

On Mon, Aug 19, 2019 at 10:57:52AM +0530, Bharata B Rao wrote:
> On Sun, Aug 18, 2019 at 11:05:53AM +0200, Christoph Hellwig wrote:
> > Hi Dan and Jason,
> > 
> > Bharata has been working on secure page management for kvmppc guests,
> > and one I thing I noticed is that he had to fake up a struct device
> > just so that it could be passed to the devm_memremap_pages
> > instrastructure for device private memory.
> > 
> > This series adds non-device managed versions of the
> > devm_request_free_mem_region and devm_memremap_pages functions for
> > his use case.
> 
> Tested kvmppc ultravisor patchset with migrate_vma changes and this
> patchset. (Had to manually patch mm/memremap.c instead of kernel/memremap.c
> though)

Oh.  I rebased to the hmm tree, and that didn't have the rename yet.
And I didn't even notice that as git handled it transparently.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
