Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com
 [IPv6:2607:f8b0:4864:20::32d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B37E21194D28
 for <linux-nvdimm@lists.01.org>; Tue, 18 Dec 2018 18:57:13 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id n8so17772532otl.6
 for <linux-nvdimm@lists.01.org>; Tue, 18 Dec 2018 18:57:13 -0800 (PST)
MIME-Version: 1.0
References: <09b875e0-6ced-5c58-83b8-8ad24f1dd71d@oracle.com>
In-Reply-To: <09b875e0-6ced-5c58-83b8-8ad24f1dd71d@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 18 Dec 2018 18:57:02 -0800
Message-ID: <CAPcyv4g5e8a4bXV8UhS9Hr1MwU1h=aMoK=3cpvLg+cuw+ES+vQ@mail.gmail.com>
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

On Tue, Dec 18, 2018 at 6:50 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Hi, Dan,
>
> While looking at a kernel Oops in the PMEM poison handling code path,
> I noticed that memory_failure_dev_pagemap() is missing from the
> System.map file in the 4.19 build.

Are you talking about a generic upstream 4.19 build or some other kernel?

> Are you aware of this?

I would expect this to be the case in general for functions that are
inlined. In this case I would expect memory_failure() to show up in
System.map, but not memory_failure_dev_pagemap() since it's not
exported and nothing outside mm/memory_failure.c consumes it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
