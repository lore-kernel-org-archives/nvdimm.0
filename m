Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C1452095DB8B
 for <linux-nvdimm@lists.01.org>; Tue,  8 Aug 2017 06:14:05 -0700 (PDT)
Subject: Re: [PATCH v4 3/8] dmaengine: Add DMA_MEMCPY_SG transaction op
References: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
 <150212397144.23722.92320326335988578.stgit@djiang5-desk3.ch.intel.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <6015c583-9f9f-f21e-590a-4ff9184c3a8f@codeaurora.org>
Date: Tue, 8 Aug 2017 09:16:18 -0400
MIME-Version: 1.0
In-Reply-To: <150212397144.23722.92320326335988578.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
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
To: Dave Jiang <dave.jiang@intel.com>, vinod.koul@intel.com, dan.j.williams@intel.com
Cc: dmaengine@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dave,

On 8/7/2017 12:39 PM, Dave Jiang wrote:
> Adding a dmaengine transaction operation that allows copy to/from a
> scatterlist and a flat buffer.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/dmaengine/provider.txt |    3 +++
>  drivers/dma/dmaengine.c              |    2 ++
>  include/linux/dmaengine.h            |    6 ++++++
>  3 files changed, 11 insertions(+)
> 

I was wondering if you could add a test like DMA_SG to dmatest so that we
also have a validation suite as well.

Sinan

-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
