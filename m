Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x231.google.com (mail-pl0-x231.google.com
 [IPv6:2607:f8b0:400e:c01::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AA7D922135D5F
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 09:13:03 -0800 (PST)
Received: by mail-pl0-x231.google.com with SMTP id w22-v6so5572708pll.2
 for <linux-nvdimm@lists.01.org>; Fri, 09 Mar 2018 09:19:20 -0800 (PST)
Subject: Re: [PATCH] loop: Fix lost writes caused by missing flag
References: <20180212230558.5546-1-ross.zwisler@linux.intel.com>
 <20180309002048.GA22835@linux.intel.com>
 <81204608-a436-c16b-6846-947573e6ee3c@kernel.dk>
 <92dc07f1-dfbd-2449-ce76-502455f56136@kernel.dk>
 <20180309163554.GA485@linux.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <fa45f4eb-7003-bd6a-471c-fbfe16abcd72@kernel.dk>
Date: Fri, 9 Mar 2018 10:19:16 -0700
MIME-Version: 1.0
In-Reply-To: <20180309163554.GA485@linux.intel.com>
Content-Language: en-US
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
Cc: stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 3/9/18 9:35 AM, Ross Zwisler wrote:
> On Fri, Mar 09, 2018 at 08:38:57AM -0700, Jens Axboe wrote:
>> On 3/9/18 8:38 AM, Jens Axboe wrote:
>>> On 3/8/18 5:20 PM, Ross Zwisler wrote:
>>>> This has gotten Reviewed-by tags from Christoph and Ming Lei.
>>>>
>>>> Al, are you the right person to merge this?  Or is the correct person Jens,
>>>> whom I accidentally didn't include when I sent this out?
>>>>
>>>> Just wanted to make sure this got merged, and to see whether it was targeting
>>>> v4.16 or v4.17.
>>>
>>> I'm the right guy, but I don't see patches if I'm not cc'ed on them...
>>> I have queued this up for 4.16, thanks.
>>
>> I do see patches sent to linux-block aswell, but you didn't CC that one
>> either.
> 
> I figure out who to CC on my patches by using scripts/get_maintainer.pl, and
> it didn't know about you or linux-block because drivers/block wasn't covered
> in MAINTAINERS.  I'll send a patch to fix this.

I'm the first person for a check on drivers/block/ or
drivers/block/loop.c, though...

> As it was I just CC'd the folks involved in the original patch, and that one
> went up through Al.
> 
> Thanks for picking this up.

No problem, glad it worked out.

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
