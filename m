Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtprelay.hostedemail.com (smtprelay0174.hostedemail.com
 [216.40.44.174])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6A4C981B3E
 for <linux-nvdimm@lists.01.org>; Tue, 10 Jan 2017 20:36:09 -0800 (PST)
Message-ID: <1484109363.12006.19.camel@perches.com>
Subject: Re: [PATCH v4] DAX: enable iostat for read/write
From: Joe Perches <joe@perches.com>
Date: Tue, 10 Jan 2017 20:36:03 -0800
In-Reply-To: <20170111001122.10826-1-toshi.kani@hpe.com>
References: <20170111001122.10826-1-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>, akpm@linux-foundation.org, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, viro@zenihttp.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2017-01-10 at 17:11 -0700, Toshi Kani wrote:
> DAX IO path does not support iostat, but its metadata IO path does.
> Therefore, iostat shows metadata IO statistics only, which has been
> confusing to users.
[]
> diff --git a/fs/dax.c b/fs/dax.c
[]
> @@ -1058,12 +1058,22 @@ dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
[]
> +	if (blk_queue_io_stat(disk->queue)) {
> +		int sec = iov_iter_count(iter) >> 9;
> +
> +		start = jiffies;
> +		generic_start_io_acct(iov_iter_rw(iter),
> +				      (!sec) ? 1 : sec, &disk->part0);
> +	}

There is a signed/unsigned conversion of sec
It may be better to use something like:

		size_t sec  = iov_iter_count(iter) >> 9;
		[...]
		generic_start_io_acct(iov_iter_rw(iter),
				      min_t(unsigned long, 1, sec),
				      &disk->part0);
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
