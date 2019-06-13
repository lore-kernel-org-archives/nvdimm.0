Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr50041.outbound.protection.outlook.com [40.107.5.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DEBBE212966E3
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jun 2019 12:37:30 -0700 (PDT)
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 11/22] memremap: remove the data field in struct
 dev_pagemap
Date: Thu, 13 Jun 2019 19:37:27 +0000
Message-ID: <20190613193722.GV22062@mellanox.com>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-12-hch@lst.de>
In-Reply-To: <20190613094326.24093-12-hch@lst.de>
Content-Language: en-US
Content-ID: <9EE56540715B244EBE0C89B76768CFAF@eurprd05.prod.outlook.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 11:43:14AM +0200, Christoph Hellwig wrote:
> struct dev_pagemap is always embedded into a containing structure, so
> there is no need to an additional private data field.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/nvdimm/pmem.c    | 2 +-
>  include/linux/memremap.h | 3 +--
>  kernel/memremap.c        | 2 +-
>  mm/hmm.c                 | 9 +++++----
>  4 files changed, 8 insertions(+), 8 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
