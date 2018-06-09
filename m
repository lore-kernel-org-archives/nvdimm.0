Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22e.google.com (mail-it0-x22e.google.com
 [IPv6:2607:f8b0:4001:c0b::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F1B4221103DDB
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 17:19:16 -0700 (PDT)
Received: by mail-it0-x22e.google.com with SMTP id 188-v6so3538973ita.5
 for <linux-nvdimm@lists.01.org>; Fri, 08 Jun 2018 17:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <1528502307.25740.14.camel@intel.com>
In-Reply-To: <1528502307.25740.14.camel@intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 8 Jun 2018 17:19:05 -0700
Message-ID: <CA+55aFy_fiF2bwW=0gL4g8uL5099hWarL4+Q9djmDEuwRR2KKw@mail.gmail.com>
Subject: Re: [GIT PULL] libnvdimm for 4.18
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 8, 2018 at 4:58 PM Williams, Dan J <dan.j.williams@intel.com> wrote:
>
> Not included in this pull, but still targeting this cycle, is support
> for handling memory media errors (poison) consumed via userspace dax
> mappings.

Note that since I'm going to be traveling much of next week, I'm going
to be even less open to late pull requests than usual.

If I get stuff that looks at all complex at the end of the merge
window, I will just cackle unpleasantly while I press the big 'D' key
on my keyboard.

          Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
