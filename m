Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03on0601.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe09::601])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5FDBA2126579F
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jun 2019 12:34:35 -0700 (PDT)
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 09/22] memremap: lift the devmap_enable manipulation into
 devm_memremap_pages
Date: Thu, 13 Jun 2019 19:34:31 +0000
Message-ID: <20190613193427.GU22062@mellanox.com>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-10-hch@lst.de>
In-Reply-To: <20190613094326.24093-10-hch@lst.de>
Content-Language: en-US
Content-ID: <2494E1C39D43164DA0596E93A4038E37@eurprd05.prod.outlook.com>
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

On Thu, Jun 13, 2019 at 11:43:12AM +0200, Christoph Hellwig wrote:
> Just check if there is a ->page_free operation set and take care of the
> static key enable, as well as the put using device managed resources.
> diff --git a/mm/hmm.c b/mm/hmm.c
> index c76a1b5defda..6dc769feb2e1 100644
> +++ b/mm/hmm.c
> @@ -1378,8 +1378,6 @@ struct hmm_devmem *hmm_devmem_add(const struct hmm_devmem_ops *ops,
>  	void *result;
>  	int ret;
>  
> -	dev_pagemap_get_ops();
> -

Where was the matching dev_pagemap_put_ops() for this hmm case? This
is a bug fix too?

The nouveau driver is the only one to actually call this hmm function
and it does it as part of a probe function. 

Seems reasonable, however, in the unlikely event that it fails to init
'dmem' the driver will retain a dev_pagemap_get_ops until it unloads.
This imbalance doesn't seem worth worrying about.

Reviewed-by: Christoph Hellwig <hch@lst.de>

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
