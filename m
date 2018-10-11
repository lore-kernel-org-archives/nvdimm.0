Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BBA5D21A07A80
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 21:48:19 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id e17-v6so5993923oib.4
 for <linux-nvdimm@lists.01.org>; Wed, 10 Oct 2018 21:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20181010233428.12228.26106.stgit@localhost.localdomain>
In-Reply-To: <20181010233428.12228.26106.stgit@localhost.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 10 Oct 2018 21:48:07 -0700
Message-ID: <CAPcyv4iwQwEpNGqFS6KtQiW5F7Ab9N6K1XpYQh871CU=cX3ZUA@mail.gmail.com>
Subject: Re: [nvdimm PATCH 0/6] Label initialization time optimizations
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
To: alexander.h.duyck@linux.intel.com
Cc: zwisler@kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 10, 2018 at 4:36 PM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> This patch set is intended to improve NVDIMM label read times by first
> increasing the upper limit on the label read/write size, and then
> reducing the number of reads by making use of the free label bitmap in
> the index to determine what labels are actually populated and only read
> those labels. In my testing on a system populated with 24 NVDIMM modules
> I see the total label init time drop from about 24 seconds down to 2 to
> 3 seconds.
>
> In the process of coding this up I came across a few minor issues that
> I felt should be addressed so I have added a few patches for those fixes
> along the way.

Thanks, this all looks good to me, the split looks good, and the
commentary in patch6 made it easy to review.

I quibble with "Remove empty if statement" because I find positive
logic easier to read than negative logic, but removing more lines than
it adds made me reserve that quibble for another time.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
