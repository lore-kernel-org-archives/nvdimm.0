Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E372A21196218
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 14:10:14 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id x202so24005588oif.13
 for <linux-nvdimm@lists.01.org>; Wed, 28 Nov 2018 14:10:14 -0800 (PST)
MIME-Version: 1.0
References: <1536654669-23828-1-git-send-email-oceanhehy@gmail.com>
In-Reply-To: <1536654669-23828-1-git-send-email-oceanhehy@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 28 Nov 2018 14:10:02 -0800
Message-ID: <CAPcyv4g0aT5VrVQBP-HnZ5Ybg245ao6Y6sS-CPU81AP81G3gcQ@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: recover from failed namespace creation
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
To: Ocean He <oceanhehy@gmail.com>
Cc: Ocean HY1 He <hehy1@lenovo.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 11, 2018 at 1:34 AM <oceanhehy@gmail.com> wrote:
>
> From: Ocean He <hehy1@lenovo.com>
>
> When namespace creation failure occurs, the consumed namespace (seed or 0th
> idle) and pfn/dax seed would block next namespace creation. A recovery is
> needed to handle this type failure.
>
> A symptom example (section size is 128MB) based on kernel 4.19-rc2 and
> ndctl v62:
>         # ndctl create-namespace -r region1 -s 100m -t pmem -m fsdax
>         {
>           "dev":"namespace1.0",
>           "mode":"fsdax",
>           "map":"dev",
>           "size":"96.00 MiB (100.66 MB)",
>           "uuid":"ef9a0556-a610-40b5-8c71-43991765a2cc",
>           "raw_uuid":"177b22e2-b7e8-482f-a063-2b8de876d979",
>           "sector_size":512,
>           "blockdev":"pmem1",
>           "numa_node":1
>         }
>         # ndctl create-namespace -r region1 -s 100m -t pmem -m fsdax
>         libndctl: ndctl_pfn_enable: pfn1.1: failed to enable
>           Error: namespace1.1: failed to enable
>         failed to create namespace: No such device or address
>         # ndctl destroy-namespace namespace1.0 -f
>         destroyed 1 namespace
>         # ndctl create-namespace -r region1 -s 128m -t pmem -m fsdax
>         failed to create namespace: Device or resource busy
>
> Signed-off-by: Ocean He <hehy1@lenovo.com>

Apologies, this got lost in my inbox. Looks good, and tests ok as well.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
