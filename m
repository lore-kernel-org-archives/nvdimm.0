Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com
 [IPv6:2a00:1450:4864:20::436])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7F06E211E0920
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 13:36:36 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id s15so11758463wra.12
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 13:36:36 -0700 (PDT)
MIME-Version: 1.0
From: Dru Nelson <drudru@gmail.com>
Date: Mon, 25 Mar 2019 13:36:23 -0700
Message-ID: <CALqrBYpHMA7zJps8BzpEj2wVKix4Pga63PbPkKwOecZEGtc_pg@mail.gmail.com>
Subject: Question about using NVDIMM for Linux Kernel debugging
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hello,

I am doing Linux kernel work on an AMD Ryzen desktop PC.
In particular, I'm trying to debug some hardware driver issues.
The challenging aspect is that they that pop up daily and (of course...)
randomly.
As you are well aware, this can be painful in a production environment on
actual hardware.
Sometimes the computer just reboots or locks up, so having something
persistent would be ideal.
I would like to track down the issue by having some basic instrumentation
of the kernel.

After doing a little research, this looks like a great application for an
NVDIMM.

I would probably divide the nvdimm with ring buffers for each core of the
CPU to avoid locks. The logging would just be simple fixed size records
with a timestamp.

Does this look doable for a reasonably priced NVDIMM?
Or is there a better solution?

Dru, Redwood City, California
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
