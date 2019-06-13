Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-eopbgr20066.outbound.protection.outlook.com [40.107.2.66])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C31E32129641B
 for <linux-nvdimm@lists.01.org>; Thu, 13 Jun 2019 13:04:06 -0700 (PDT)
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH 22/22] mm: don't select MIGRATE_VMA_HELPER from HMM_MIRROR
Date: Thu, 13 Jun 2019 20:04:03 +0000
Message-ID: <20190613200357.GC22062@mellanox.com>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-23-hch@lst.de>
In-Reply-To: <20190613094326.24093-23-hch@lst.de>
Content-Language: en-US
Content-ID: <DC6C94E2B8591541A7B0CC844A612312@eurprd05.prod.outlook.com>
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

On Thu, Jun 13, 2019 at 11:43:25AM +0200, Christoph Hellwig wrote:
> The migrate_vma helper is only used by noveau to migrate device private
> pages around.  Other HMM_MIRROR users like amdgpu or infiniband don't
> need it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/gpu/drm/nouveau/Kconfig | 1 +
>  mm/Kconfig                      | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)

Yes, the thing that calls migrate_vma() should be the thing that has
the kconfig stuff.

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
