Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x230.google.com (mail-ua0-x230.google.com
 [IPv6:2607:f8b0:400c:c08::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 423FF209589F4
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 11:05:40 -0700 (PDT)
Received: by mail-ua0-x230.google.com with SMTP id k43so10558908uaf.3
 for <linux-nvdimm@lists.01.org>; Tue, 01 Aug 2017 11:07:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170801180017.GC20061@linux.intel.com>
References: <20170801114926.1171418-1-arnd@arndb.de>
 <20170801180017.GC20061@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 1 Aug 2017 11:07:48 -0700
Message-ID: <CAPcyv4iWzd6fwaJY+U8YrSTMFA1RS_Q2pyOC7bZAo5DVhjVarw@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: avoid bogus -Wmaybe-uninitialized warning
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 1, 2017 at 11:00 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Tue, Aug 01, 2017 at 01:48:48PM +0200, Arnd Bergmann wrote:
>> Removing the btt_rw_page/pmem_rw_page functions had a surprising
>> side-effect of introducing a false-positive warning in another
>> function, due to changed inlining decisions in gcc:
>>
>> In file included from drivers/nvdimm/pmem.c:36:0:
>> drivers/nvdimm/pmem.c: In function 'pmem_make_request':
>> drivers/nvdimm/nd.h:407:2: error: 'start' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>> drivers/nvdimm/pmem.c:174:16: note: 'start' was declared here
>> In file included from drivers/nvdimm/btt.c:27:0:
>> drivers/nvdimm/btt.c: In function 'btt_make_request':
>> drivers/nvdimm/nd.h:407:2: error: 'start' may be used uninitialized in this function [-Werror=maybe-uninitialized]
>> drivers/nvdimm/btt.c:1202:16: note: 'start' was declared here
>>
>> The problem is that gcc fails to track the value of the 'do_acct'
>> variable here and has to read it back from stack, but it does
>> remember that 'start' may be uninitialized sometimes.
>>
>> This shuts up the warning by making nd_iostat_start() always
>> initialize the 'start' variable. In those cases that gcc successfully
>> tracks the state of the variable, this will have no effect.
>>
>> Fixes: 503a5e89b1de ("drivers/nvdimm/btt.c: remove btt_rw_page()")
>> Fixes: 58100d6e735e ("drivers/nvdimm/pmem.c: remove pmem_rw_page()")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> This change looks fine:
>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>
> I believe the patches removing the btt_rw_page() and btt_rw_page() are on hold
> until I can get some performance numbers to justify them.
>
> Dan, do you want to take this as is, or do you want me to include it in my
> larger rw_page() series if/when that gets revived?

I'd say include it with your set.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
