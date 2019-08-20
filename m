Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A3892020D32A
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 19:24:15 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id g17so3629301otl.2
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 19:22:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190818090557.17853-1-hch@lst.de>
 <20190818090557.17853-4-hch@lst.de>
In-Reply-To: <20190818090557.17853-4-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Aug 2019 19:22:41 -0700
Message-ID: <CAPcyv4h9Bp=D4oHEb-v9U7-aZE3VazmsTK3Ou3iC3s3FTYc4Dg@mail.gmail.com>
Subject: Re: [PATCH 3/4] memremap: don't use a separate devm action for
 devmap_managed_enable_get
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Bharata B Rao <bharata@linux.ibm.com>, Linux MM <linux-mm@kvack.org>, Jason Gunthorpe <jgg@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Aug 18, 2019 at 2:12 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Just clean up for early failures and then piggy back on
> devm_memremap_pages_release.  This helps with a pending not device
> managed version of devm_memremap_pages.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
