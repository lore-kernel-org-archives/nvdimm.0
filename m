Return-Path: <owner-linux-mm@kvack.org>
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 17/22] mm: remove hmm_devmem_add
Date: Thu, 13 Jun 2019 19:42:43 +0000
Message-ID: <20190613194239.GX22062@mellanox.com>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-18-hch@lst.de>
In-Reply-To: <20190613094326.24093-18-hch@lst.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <4271DAA2E22D344AB96571BECBECE6B2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 11:43:20AM +0200, Christoph Hellwig wrote:
> There isn't really much value add in the hmm_devmem_add wrapper.  Just
> factor out a little helper to find the resource, and otherwise let the
> driver implement the dev_pagemap_ops directly.

Was this commit message written when other patches were squashed in
here? I think the helper this mentions was from an earlier patch

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/vm/hmm.rst |  26 --------
>  include/linux/hmm.h      | 129 ---------------------------------------
>  mm/hmm.c                 | 115 ----------------------------------
>  3 files changed, 270 deletions(-)

I looked for in-flight patches that might be using these APIs and
found nothing. To be sent patches can use the new API with no loss in
functionality...

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
