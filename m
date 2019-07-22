Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by ml01.01.org (Postfix) with ESMTP id DAC0D21962301
 for <linux-nvdimm@lists.01.org>; Mon, 22 Jul 2019 02:53:15 -0700 (PDT)
Subject: Re: [PATCH] memremap: move from kernel/ to mm/
References: <20190722094143.18387-1-hch@lst.de>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <9cd09b82-ec86-b0c0-79d5-e26ed5ed0b23@arm.com>
Date: Mon, 22 Jul 2019 15:21:23 +0530
MIME-Version: 1.0
In-Reply-To: <20190722094143.18387-1-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>, dan.j.williams@intel.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 07/22/2019 03:11 PM, Christoph Hellwig wrote:
> memremap.c implements MM functionality for ZONE_DEVICE, so it really
> should be in the mm/ directory, not the kernel/ one.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This always made sense.

FWIW

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
