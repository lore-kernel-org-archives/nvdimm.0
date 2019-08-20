Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com
 [IPv6:2607:f8b0:4864:20::342])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ECF542020D32A
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 19:26:12 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id c34so3622848otb.7
 for <linux-nvdimm@lists.01.org>; Mon, 19 Aug 2019 19:24:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190818090557.17853-1-hch@lst.de>
 <20190818090557.17853-5-hch@lst.de>
In-Reply-To: <20190818090557.17853-5-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 19 Aug 2019 19:24:39 -0700
Message-ID: <CAPcyv4iy=RGu87Px_6Pr3f8yx5tH1hm58M85n74zYbbUTA299Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] memremap: provide a not device managed memremap_pages
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
> The kvmppc ultravisor code wants a device private memory pool that is
> system wide and not attached to a device.  Instead of faking up one
> provide a low-level memremap_pages for it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
