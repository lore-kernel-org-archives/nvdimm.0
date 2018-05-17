Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5DEB021BADAB2
 for <linux-nvdimm@lists.01.org>; Thu, 17 May 2018 12:32:08 -0700 (PDT)
Received: by mail-ot0-x243.google.com with SMTP id t1-v6so6345729ott.13
 for <linux-nvdimm@lists.01.org>; Thu, 17 May 2018 12:32:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180517183711.GE26718@bombadil.infradead.org>
References: <20180517183711.GE26718@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 17 May 2018 12:32:07 -0700
Message-ID: <CAPcyv4jXaEMW-41yU8eu11-g53apPUX3hg70aQCuwot6kyApUw@mail.gmail.com>
Subject: Re: [PATCH] dax: Fix use of zero page
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
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 17, 2018 at 11:37 AM, Matthew Wilcox <willy@infradead.org> wrote:
>
> I plucked this patch from my XArray work.  It seems self-contained enough
> that it could go into the DAX tree for merging this cycle.
>
> From 8cb56f4ba36af38814ca7b8ba030a66384e59a21 Mon Sep 17 00:00:00 2001
> From: Matthew Wilcox <mawilcox@microsoft.com>
> Date: Thu, 29 Mar 2018 22:41:18 -0400
> Subject: [PATCH] dax: Fix use of zero page
>
> Use my_zero_pfn instead of ZERO_PAGE, and pass the vaddr to it so it
> works on MIPS and s390.
>
> Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

I'm being thick and / or lazy, what's the user visible effect of this fix?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
