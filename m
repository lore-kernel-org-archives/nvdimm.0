Return-Path: <owner-linux-mm@kvack.org>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-8-hch@lst.de>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <4ff7926e-7021-7b7f-93b4-c745055d06b5@deltatee.com>
Date: Thu, 13 Jun 2019 14:14:58 -0600
MIME-Version: 1.0
In-Reply-To: <20190613094326.24093-8-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 07/22] memremap: move dev_pagemap callbacks into a
 separate structure
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>
Cc: linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, nouveau@lists.freedesktop.org
List-ID: <linux-nvdimm@lists.01.org>



On 2019-06-13 3:43 a.m., Christoph Hellwig wrote:
> The dev_pagemap is a growing too many callbacks.  Move them into a
> separate ops structure so that they are not duplicated for multiple
> instances, and an attacker can't easily overwrite them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/device.c              |  6 +++++-
>  drivers/nvdimm/pmem.c             | 18 +++++++++++++-----
>  drivers/pci/p2pdma.c              |  5 ++++-
>  include/linux/memremap.h          | 29 +++++++++++++++--------------
>  kernel/memremap.c                 | 12 ++++++------
>  mm/hmm.c                          |  8 ++++++--
>  tools/testing/nvdimm/test/iomap.c |  2 +-
>  7 files changed, 50 insertions(+), 30 deletions(-)

Looks good to me,

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan
