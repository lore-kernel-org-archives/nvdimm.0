Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3805F21281EDF
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jun 2019 13:12:33 -0700 (PDT)
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-9-hch@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <d9e24f8e-986d-e7b8-cf1d-9344ba51719e@deltatee.com>
Date: Thu, 13 Jun 2019 14:12:26 -0600
MIME-Version: 1.0
In-Reply-To: <20190613094326.24093-9-hch@lst.de>
Content-Language: en-US
Subject: Re: [PATCH 08/22] memremap: pass a struct dev_pagemap to ->kill
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
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>



On 2019-06-13 3:43 a.m., Christoph Hellwig wrote:
> Passing the actual typed structure leads to more understandable code
> vs the actual references.

Ha, ok, I originally suggested this to Dan when he introduced the
callback[1].

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan

[1]
https://lore.kernel.org/lkml/8f0cae82-130f-8a64-cfbd-fda5fd76bb79@deltatee.com/T/#u

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
