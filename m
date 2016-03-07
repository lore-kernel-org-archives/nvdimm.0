Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 9C7FA1A1F69
 for <linux-nvdimm@lists.01.org>; Mon,  7 Mar 2016 08:08:46 -0800 (PST)
Date: Mon, 7 Mar 2016 09:08:00 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [TRIVIAL PATCH] treewide: Remove unnecessary 0x prefixes before
 %pa extension uses
Message-ID: <20160307160800.GA9185@linux.intel.com>
References: <dcdebc08a17023fac93595312281cb8e91185668.1457162650.git.joe@perches.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <dcdebc08a17023fac93595312281cb8e91185668.1457162650.git.joe@perches.com>
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
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Vinod Koul <vinod.koul@intel.com>, Matt Porter <mporter@kernel.crashing.org>, Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org, Benoit Parrot <bparrot@ti.com>, Alexandre Bounine <alexandre.bounine@idt.com>, linux-nvdimm@lists.01.org, dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 04, 2016 at 11:46:32PM -0800, Joe Perches wrote:
> Since commit 3cab1e711297 ("lib/vsprintf: refactor duplicate code
> to special_hex_number()") %pa uses have been ouput with a 0x prefix.
> 
> These 0x prefixes in the formats are unnecessary.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/dma/at_hdmac_regs.h              | 2 +-
>  drivers/media/platform/ti-vpe/cal.c      | 2 +-
>  drivers/nvdimm/pmem.c                    | 2 +-
>  drivers/rapidio/devices/rio_mport_cdev.c | 4 ++--
>  drivers/rapidio/devices/tsi721.c         | 8 ++++----
>  5 files changed, 9 insertions(+), 9 deletions(-)
<>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 8d0b546..eb619d1 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -172,7 +172,7 @@ static struct pmem_device *pmem_alloc(struct device *dev,
>  
>  	if (!devm_request_mem_region(dev, pmem->phys_addr, pmem->size,
>  			dev_name(dev))) {
> -		dev_warn(dev, "could not reserve region [0x%pa:0x%zx]\n",
> +		dev_warn(dev, "could not reserve region [%pa:0x%zx]\n",
>  				&pmem->phys_addr, pmem->size);
>  		return ERR_PTR(-EBUSY);
>  	}

For the pmem part:
Acked-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
