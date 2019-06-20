Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 20 Jun 2019 21:26:48 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 18/22] mm: mark DEVICE_PUBLIC as broken
Message-ID: <20190620192648.GI12083@dhcp22.suse.cz>
References: <20190613094326.24093-1-hch@lst.de>
 <20190613094326.24093-19-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613094326.24093-19-hch@lst.de>
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, linux-mm@kvack.org, nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-nvdimm@lists.01.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 13-06-19 11:43:21, Christoph Hellwig wrote:
> The code hasn't been used since it was added to the tree, and doesn't
> appear to actually be usable.  Mark it as BROKEN until either a user
> comes along or we finally give up on it.

I would go even further and simply remove all the DEVICE_PUBLIC code.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Anyway
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0d2ba7e1f43e..406fa45e9ecc 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -721,6 +721,7 @@ config DEVICE_PRIVATE
>  config DEVICE_PUBLIC
>  	bool "Addressable device memory (like GPU memory)"
>  	depends on ARCH_HAS_HMM
> +	depends on BROKEN
>  	select HMM
>  	select DEV_PAGEMAP_OPS
>  
> -- 
> 2.20.1

-- 
Michal Hocko
SUSE Labs
