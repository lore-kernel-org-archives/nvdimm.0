Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Message-ID: <1410376957.23970.4.camel@rzwisler-mobl1.amr.corp.intel.com>
Subject: Re: [PATCH] SQUASHME: pmem: Add MODULE_ALIAS
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Date: Wed, 10 Sep 2014 13:22:37 -0600
In-Reply-To: <54108F64.9080201@plexistor.com>
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
	 <540F1EC6.4000504@plexistor.com> <54108F64.9080201@plexistor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fsdevel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2014-09-10 at 20:50 +0300, Boaz Harrosh wrote:
> From: Boaz Harrosh <boaz@plexistor.com>
> 
> This is customary and will become useful soon with udev and events
> 
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> ---
>  drivers/block/pmem.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/block/pmem.c b/drivers/block/pmem.c
> index 4a9d65e..f63cb31 100644
> --- a/drivers/block/pmem.c
> +++ b/drivers/block/pmem.c
> @@ -432,5 +430,6 @@ static void __exit pmem_exit(void)
>  
>  MODULE_AUTHOR("Ross Zwisler <ross.zwisler@linux.intel.com>");
>  MODULE_LICENSE("GPL");
> +MODULE_ALIAS("pmem");
>  module_init(pmem_init);
>  module_exit(pmem_exit);

Umm...but the module is *already* named pmem?

Let's not set up an alias that is the same as our real name for code that
isn't written yet?

- Ross



