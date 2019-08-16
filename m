Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 98527202B75F7
 for <linux-nvdimm@lists.01.org>; Fri, 16 Aug 2019 14:02:46 -0700 (PDT)
Date: Fri, 16 Aug 2019 14:00:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] memremap: provide a not device managed memremap_pages
Message-Id: <20190816140057.c1ab8b41b9bfff65b7ea83ba@linux-foundation.org>
In-Reply-To: <20190816065434.2129-5-hch@lst.de>
References: <20190816065434.2129-1-hch@lst.de>
 <20190816065434.2129-5-hch@lst.de>
Mime-Version: 1.0
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.ibm.com>, linux-mm@kvack.org, Jason Gunthorpe <jgg@mellanox.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 16 Aug 2019 08:54:34 +0200 Christoph Hellwig <hch@lst.de> wrote:

> The kvmppc ultravisor code wants a device private memory pool that is
> system wide and not attached to a device.  Instead of faking up one
> provide a low-level memremap_pages for it.  Note that this function is
> not exported, and doesn't have a cleanup routine associated with it to
> discourage use from more driver like users.

Confused. Which function is "not exported"?

> +EXPORT_SYMBOL_GPL(memunmap_pages);
> +EXPORT_SYMBOL_GPL(memremap_pages);
>  EXPORT_SYMBOL_GPL(devm_memremap_pages);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
