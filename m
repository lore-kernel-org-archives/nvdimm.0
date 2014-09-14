Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <54157B30.5000605@plexistor.com>
Date: Sun, 14 Sep 2014 14:25:36 +0300
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/9] SQUASHME: pmem: Request from fdisk 4k alignment
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>	 <540F1EC6.4000504@plexistor.com> <540F1FBB.2000706@plexistor.com> <1410460745.2424.1.camel@rzwisler-mobl1.amr.corp.intel.com>
In-Reply-To: <1410460745.2424.1.camel@rzwisler-mobl1.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 09/11/2014 09:39 PM, Ross Zwisler wrote:
<>
> 
> I've tested this a bit using the version of fdisk found in Fedora (fdisk from
> util-linux 2.24.2), which I believe is what you are using.
> 
> So far I can't come up with a case where fdisk does the wrong thing without
> this patch and the right thing with it.  Can you please provide me more
> details on the use case that you are trying to fix?
> 

Try 4M disk for one.

And have you really tested? Do you always get a start sector aligned on 8 (4k) ?
Well I do not, I easily get partition start sectors not aligned on 8.

Note that fdisk will allow me to set none-4k-aligened start and size but at least
with this patch it will not suggest them

> - Ross
> 
> 

Thanks
Boaz

