Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22CC62119F047
 for <linux-nvdimm@lists.01.org>; Tue, 18 Dec 2018 20:52:34 -0800 (PST)
Subject: Re: memory_failure_dev_pagemap() missing from System.map file
References: <09b875e0-6ced-5c58-83b8-8ad24f1dd71d@oracle.com>
 <CAPcyv4g5e8a4bXV8UhS9Hr1MwU1h=aMoK=3cpvLg+cuw+ES+vQ@mail.gmail.com>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <3b844c4b-6329-4336-21db-6207ca2f075c@oracle.com>
Date: Tue, 18 Dec 2018 20:52:30 -0800
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g5e8a4bXV8UhS9Hr1MwU1h=aMoK=3cpvLg+cuw+ES+vQ@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 12/18/2018 6:57 PM, Dan Williams wrote:

> On Tue, Dec 18, 2018 at 6:50 PM Jane Chu <jane.chu@oracle.com> wrote:
>> Hi, Dan,
>>
>> While looking at a kernel Oops in the PMEM poison handling code path,
>> I noticed that memory_failure_dev_pagemap() is missing from the
>> System.map file in the 4.19 build.
> Are you talking about a generic upstream 4.19 build or some other kernel?

Generic upstream 4.19 build.

>> Are you aware of this?
> I would expect this to be the case in general for functions that are
> inlined. In this case I would expect memory_failure() to show up in
> System.map, but not memory_failure_dev_pagemap() since it's not
> exported and nothing outside mm/memory_failure.c consumes it.

Not appear inlined, it is statically declared, refer to
   https://elixir.bootlin.com/linux/v4.19.10/ident/memory_failure_dev_pagemap

hwpoison_user_mappings() is also statically declared, and it's in System.map.

thanks,
-jane

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
