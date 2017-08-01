Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64DAB21D2DCED
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 14:43:25 -0700 (PDT)
Date: Tue, 1 Aug 2017 14:45:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] nvdimm: avoid bogus -Wmaybe-uninitialized warning
Message-Id: <20170801144534.2a1e1def29e68eb6c83e203c@linux-foundation.org>
In-Reply-To: <20170801114926.1171418-1-arnd@arndb.de>
References: <20170801114926.1171418-1-arnd@arndb.de>
Mime-Version: 1.0
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue,  1 Aug 2017 13:48:48 +0200 Arnd Bergmann <arnd@arndb.de> wrote:

> Removing the btt_rw_page/pmem_rw_page functions had a surprising
> side-effect of introducing a false-positive warning in another
> function, due to changed inlining decisions in gcc:
> 
> In file included from drivers/nvdimm/pmem.c:36:0:
> drivers/nvdimm/pmem.c: In function 'pmem_make_request':
> drivers/nvdimm/nd.h:407:2: error: 'start' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> drivers/nvdimm/pmem.c:174:16: note: 'start' was declared here
> In file included from drivers/nvdimm/btt.c:27:0:
> drivers/nvdimm/btt.c: In function 'btt_make_request':
> drivers/nvdimm/nd.h:407:2: error: 'start' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> drivers/nvdimm/btt.c:1202:16: note: 'start' was declared here
> 
> The problem is that gcc fails to track the value of the 'do_acct'
> variable here and has to read it back from stack, but it does
> remember that 'start' may be uninitialized sometimes.
> 
> This shuts up the warning by making nd_iostat_start() always
> initialize the 'start' variable. In those cases that gcc successfully
> tracks the state of the variable, this will have no effect.
> 
> ...
>
> --- a/drivers/nvdimm/nd.h
> +++ b/drivers/nvdimm/nd.h
> @@ -392,8 +392,10 @@ static inline bool nd_iostat_start(struct bio *bio, unsigned long *start)
>  {
>  	struct gendisk *disk = bio->bi_bdev->bd_disk;
>  
> -	if (!blk_queue_io_stat(disk->queue))
> +	if (!blk_queue_io_stat(disk->queue)) {
> +		*start = 0;
>  		return false;
> +	}
>  
>  	*start = jiffies;
>  	generic_start_io_acct(bio_data_dir(bio),

Well that's sad.

The future of btt-remove-btt_rw_page.patch and friends is shrouded in
mystery, but if we proceed that way then yes, I guess we'll need to
work around such gcc glitches.

But let's not leave apparently-unneeded code in place without telling
people why it is in fact needed?

--- a/drivers/nvdimm/nd.h~nvdimm-avoid-bogus-wmaybe-uninitialized-warning-fix
+++ a/drivers/nvdimm/nd.h
@@ -393,7 +393,7 @@ static inline bool nd_iostat_start(struc
 	struct gendisk *disk = bio->bi_bdev->bd_disk;
 
 	if (!blk_queue_io_stat(disk->queue)) {
-		*start = 0;
+		*start = 0;	/* Suppress bogus warning */
 		return false;
 	}
 
_

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
