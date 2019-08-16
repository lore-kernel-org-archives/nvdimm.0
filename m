Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-eopbgr60041.outbound.protection.outlook.com [40.107.6.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1AF23202C80AC
 for <linux-nvdimm@lists.01.org>; Fri, 16 Aug 2019 05:42:23 -0700 (PDT)
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: add a not device managed memremap_pages v2
Date: Fri, 16 Aug 2019 12:40:30 +0000
Message-ID: <20190816124024.GF5412@mellanox.com>
References: <20190816065434.2129-1-hch@lst.de>
 <20190816123356.GE5412@mellanox.com> <20190816123607.GA22681@lst.de>
In-Reply-To: <20190816123607.GA22681@lst.de>
Content-Language: en-US
Content-ID: <49CFD18A4DCBF442B6C7AF0837F23DC5@eurprd05.prod.outlook.com>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bharata B Rao <bharata@linux.ibm.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 16, 2019 at 02:36:07PM +0200, Christoph Hellwig wrote:
> > > Changes since v1:
> > >  - don't overload devm_request_free_mem_region
> > >  - export the memremap_pages and munmap_pages as kvmppc can be a module
> > 
> > What tree do we want this to go through? Dan are you running a pgmap
> > tree still? Do we know of any conflicts?
> 
> The last changes in this area went through the hmm tree.  There are
> now known conflicts, and the kvmppc drivers that needs this already
> has a dependency on the hmm tree for the migrate_vma_* changes.

OK by me, Dan can you ack or review? Thanks

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
