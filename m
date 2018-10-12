Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E6ABA21A09130
 for <linux-nvdimm@lists.01.org>; Thu, 11 Oct 2018 18:35:39 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id s69-v6so8651288oie.10
 for <linux-nvdimm@lists.01.org>; Thu, 11 Oct 2018 18:35:39 -0700 (PDT)
MIME-Version: 1.0
References: <20181010233428.12228.26106.stgit@localhost.localdomain>
 <20181010233926.12228.65663.stgit@localhost.localdomain>
In-Reply-To: <20181010233926.12228.65663.stgit@localhost.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Oct 2018 18:35:25 -0700
Message-ID: <CAPcyv4hw6xQ5nvGpf3Kd_86STXqEEd3pj3u0LEZ1fP+d2e8+Cg@mail.gmail.com>
Subject: Re: [nvdimm PATCH 6/6] nvdimm: Use namespace index data to reduce
 number of label reads needed
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

On Wed, Oct 10, 2018 at 4:51 PM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> This patch adds logic that is meant to make use of the namespace index data
> to reduce the number of reads that are needed to initialize a given
> namespace. The general idea is that once we have enough data to validate
> the namespace index we do so and then proceed to fetch only those labels
> that are not listed as being "free". By doing this I am seeing a total time
> reduction from about 4-5 seconds to 2-3 seconds for 24 NVDIMM modules each
> with 128K of label config area.
>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>  drivers/nvdimm/dimm.c  |    4 --
>  drivers/nvdimm/label.c |   93 +++++++++++++++++++++++++++++++++++++++++++++---
>  drivers/nvdimm/label.h |    3 --
>  3 files changed, 88 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/nvdimm/dimm.c b/drivers/nvdimm/dimm.c
> index 07bf96948553..9899c97138a3 100644
> --- a/drivers/nvdimm/dimm.c
> +++ b/drivers/nvdimm/dimm.c
> @@ -452,7 +455,87 @@ int nd_label_data_init(struct nvdimm_drvdata *ndd)
[..]
> +       /* Loop through the free list pulling in any active labels */
> +       for (i = 0; i < nsindex->nslot; i++, offset += ndd->nslabel_size) {

0day points out a sparse warning on that usage of nslot which is an
__le32. I'll append a fixup.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
