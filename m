Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id C27A61A1F2F
 for <linux-nvdimm@lists.01.org>; Mon,  7 Mar 2016 06:46:42 -0800 (PST)
Date: Mon, 7 Mar 2016 20:20:37 +0530
From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [TRIVIAL PATCH] treewide: Remove unnecessary 0x prefixes before
 %pa extension uses
Message-ID: <20160307145037.GF11154@localhost>
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
Cc: Jiri Kosina <trivial@kernel.org>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Matt Porter <mporter@kernel.crashing.org>, Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org, Benoit Parrot <bparrot@ti.com>, Alexandre Bounine <alexandre.bounine@idt.com>, linux-nvdimm@lists.01.org, dmaengine@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 04, 2016 at 11:46:32PM -0800, Joe Perches wrote:
> Since commit 3cab1e711297 ("lib/vsprintf: refactor duplicate code
> to special_hex_number()") %pa uses have been ouput with a 0x prefix.
> 
> These 0x prefixes in the formats are unnecessary.
> 

For this:
>  drivers/dma/at_hdmac_regs.h              | 2 +-

Acked-by: Vinod Koul <vinod.koul@intel.com>

-- 
~Vinod
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
