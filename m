Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x22e.google.com (mail-pg0-x22e.google.com
 [IPv6:2607:f8b0:400e:c05::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB0B0224DCA40
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 07:32:04 -0800 (PST)
Received: by mail-pg0-x22e.google.com with SMTP id y26so3682927pgv.4
 for <linux-nvdimm@lists.01.org>; Fri, 09 Mar 2018 07:38:21 -0800 (PST)
Subject: Re: [PATCH] loop: Fix lost writes caused by missing flag
References: <20180212230558.5546-1-ross.zwisler@linux.intel.com>
 <20180309002048.GA22835@linux.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <81204608-a436-c16b-6846-947573e6ee3c@kernel.dk>
Date: Fri, 9 Mar 2018 08:38:13 -0700
MIME-Version: 1.0
In-Reply-To: <20180309002048.GA22835@linux.intel.com>
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

On 3/8/18 5:20 PM, Ross Zwisler wrote:
> This has gotten Reviewed-by tags from Christoph and Ming Lei.
> 
> Al, are you the right person to merge this?  Or is the correct person Jens,
> whom I accidentally didn't include when I sent this out?
> 
> Just wanted to make sure this got merged, and to see whether it was targeting
> v4.16 or v4.17.

I'm the right guy, but I don't see patches if I'm not cc'ed on them...
I have queued this up for 4.16, thanks.

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
