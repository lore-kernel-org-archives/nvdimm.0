Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com
 [IPv6:2607:f8b0:4864:20::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E2BEC2194D3B9
 for <linux-nvdimm@lists.01.org>; Tue, 18 Dec 2018 21:03:54 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id w13so625301oiw.9
 for <linux-nvdimm@lists.01.org>; Tue, 18 Dec 2018 21:03:54 -0800 (PST)
MIME-Version: 1.0
References: <09b875e0-6ced-5c58-83b8-8ad24f1dd71d@oracle.com>
 <CAPcyv4g5e8a4bXV8UhS9Hr1MwU1h=aMoK=3cpvLg+cuw+ES+vQ@mail.gmail.com>
 <3b844c4b-6329-4336-21db-6207ca2f075c@oracle.com>
In-Reply-To: <3b844c4b-6329-4336-21db-6207ca2f075c@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 18 Dec 2018 21:03:42 -0800
Message-ID: <CAPcyv4hMwBQFti=z=B41-SNxbbGwB3+R0nRCJ7kzBLY9__e_zQ@mail.gmail.com>
Subject: Re: memory_failure_dev_pagemap() missing from System.map file
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
To: Jane Chu <jane.chu@oracle.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 18, 2018 at 8:52 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> On 12/18/2018 6:57 PM, Dan Williams wrote:
>
> On Tue, Dec 18, 2018 at 6:50 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Hi, Dan,
>
> While looking at a kernel Oops in the PMEM poison handling code path,
> I noticed that memory_failure_dev_pagemap() is missing from the
> System.map file in the 4.19 build.
>
> Are you talking about a generic upstream 4.19 build or some other kernel?
>
> Generic upstream 4.19 build.
>
> Are you aware of this?
>
> I would expect this to be the case in general for functions that are
> inlined. In this case I would expect memory_failure() to show up in
> System.map, but not memory_failure_dev_pagemap() since it's not
> exported and nothing outside mm/memory_failure.c consumes it.
>
> Not appear inlined, it is statically declared, refer to
>   https://elixir.bootlin.com/linux/v4.19.10/ident/memory_failure_dev_pagemap
>
> hwpoison_user_mappings() is also statically declared, and it's in System.map.

Right, but static functions are optionally inlined by the compiler, so
it's hit and miss. If you need memory_failure_dev_pagemap() to show in
System.map the only guaranteed ways are to mark it extern so the
compiler assumes it needs to emit a dedicated symbol for it, or leave
it static and mark it nolinline, i.e. __attribute__((__noinline__))
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
