Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 797E720945B7A
 for <linux-nvdimm@lists.01.org>; Fri, 15 Sep 2017 17:13:08 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id r20so377044oie.0
 for <linux-nvdimm@lists.01.org>; Fri, 15 Sep 2017 17:16:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1505511004.5511.52.camel@hpe.com>
References: <1505511004.5511.52.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 15 Sep 2017 17:16:07 -0700
Message-ID: <CAPcyv4hMdFrbu0qfCHJGe4OS7E22evj5tPPYY1pE-uQ-Q9vo_g@mail.gmail.com>
Subject: Re: ndctl-58 causing kernel panic w/ latest kernel
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
To: "Saldivar, Maurice A." <maurice.a.saldivar@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 15, 2017 at 2:41 PM, Saldivar, Maurice A.
<maurice.a.saldivar@hpe.com> wrote:
> Testing ndctl-58 on our NVDIMM-Ns with the latest kernel (4.13.2)
> causes a panic when configuring a pmem device from raw to sector mode.
>
> ndctl create-namespace -f -e namespace0.0 -m sector
>
> I was not able to reproduce this issue using ndctl-57. Below is the
> stack trace from configuring a pmem device from raw to sector mode.
>
> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000028
> IP: holder_class_store+0x253/0x2b0 [libnvdimm]

Can you translate this to a line number? Try the following, and send the output:

$ gdb drivers/nvdimm/libnvdimm.ko
(gdb) li *(holder_class_store+0x253)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
