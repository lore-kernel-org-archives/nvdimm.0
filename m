Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC9FC2194EB7D
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 13:57:07 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id y84so8148131oia.12
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 13:57:07 -0700 (PDT)
MIME-Version: 1.0
References: <CALqrBYpHMA7zJps8BzpEj2wVKix4Pga63PbPkKwOecZEGtc_pg@mail.gmail.com>
In-Reply-To: <CALqrBYpHMA7zJps8BzpEj2wVKix4Pga63PbPkKwOecZEGtc_pg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Mar 2019 13:56:51 -0700
Message-ID: <CAPcyv4h+44Ymcwh-q76knp_Mv3UOG2o6pu6wmRYDRV5sb+KOAw@mail.gmail.com>
Subject: Re: Question about using NVDIMM for Linux Kernel debugging
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
To: Dru Nelson <drudru@gmail.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 25, 2019 at 1:36 PM Dru Nelson <drudru@gmail.com> wrote:
>
> Hello,
>
> I am doing Linux kernel work on an AMD Ryzen desktop PC.
> In particular, I'm trying to debug some hardware driver issues.
> The challenging aspect is that they that pop up daily and (of course...)
> randomly.
> As you are well aware, this can be painful in a production environment on
> actual hardware.
> Sometimes the computer just reboots or locks up, so having something
> persistent would be ideal.
> I would like to track down the issue by having some basic instrumentation
> of the kernel.
>
> After doing a little research, this looks like a great application for an
> NVDIMM.
>
> I would probably divide the nvdimm with ring buffers for each core of the
> CPU to avoid locks. The logging would just be simple fixed size records
> with a timestamp.
>
> Does this look doable for a reasonably priced NVDIMM?
> Or is there a better solution?

I'd recommend taking a look at ramoops, but that said I've not tried
hooking it up to an NVDIMM backend.

https://github.com/torvalds/linux/blob/master/Documentation/admin-guide/ramoops.rst
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
