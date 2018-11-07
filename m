Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com
 [209.85.215.196])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12DF22118A5AE
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 16:50:32 -0800 (PST)
Received: by mail-pg1-f196.google.com with SMTP id w7so6567539pgp.13
 for <linux-nvdimm@lists.01.org>; Tue, 06 Nov 2018 16:50:32 -0800 (PST)
Message-ID: <1541551829.196084.206.camel@acm.org>
Subject: Re: [driver-core PATCH v5 2/9] async: Add support for queueing on
 specific NUMA node
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 06 Nov 2018 16:50:29 -0800
In-Reply-To: <154145230954.29224.13087735653265580553.stgit@ahduyck-desk1.jf.intel.com>
References: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
 <154145230954.29224.13087735653265580553.stgit@ahduyck-desk1.jf.intel.com>
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: len.brown@intel.com, linux-pm@vger.kernel.org, rafael@kernel.org, jiangshanlai@gmail.com, linux-nvdimm@lists.01.org, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-11-05 at 13:11 -0800, Alexander Duyck wrote:
> +/**
> + * async_schedule_domain - schedule a function for asynchronous execution within a certain domain
> + * @func: function to execute asynchronously
> + * @data: data pointer to pass to the function
> + * @domain: the domain
> + *
> + * Returns an async_cookie_t that may be used for checkpointing later.
> + * @domain may be used in the async_synchronize_*_domain() functions to
> + * wait within a certain synchronization domain rather than globally.  A
> + * synchronization domain is specified via @domain.
> + * Note: This function may be called from atomic or non-atomic contexts.
> + */

Please leave out "A synchronization domain is specified via @domain." since
that text is redundant due to "@domain: the domain".

> +/**
> + * async_schedule_dev_domain - A device specific version of async_schedule_domain
> + * @func: function to execute asynchronously
> + * @dev: device argument to be passed to function
> + * @domain: the domain
> + *
> + * Returns an async_cookie_t that may be used for checkpointing later.
> + * @dev is used as both the argument for the function and to provide NUMA
> + * context for where to run the function. By doing this we can try to
> + * provide for the best possible outcome by operating on the device on the
> + * CPUs closest to the device.
> + * @domain may be used in the async_synchronize_*_domain() functions to
> + * wait within a certain synchronization domain rather than globally.  A
> + * synchronization domain is specified via @domain.
> + * Note: This function may be called from atomic or non-atomic contexts.
> + */

Same comment here: I think "A synchronization domain is specified via @domain."
is redundant.

> +/**
> + * async_schedule_node_domain - NUMA specific version of async_schedule_domain
> + * @func: function to execute asynchronously
> + * @data: data pointer to pass to the function
> + * @node: NUMA node that we want to schedule this on or close to
> + * @domain: the domain
> + *
> + * Returns an async_cookie_t that may be used for checkpointing later.
> + * @domain may be used in the async_synchronize_*_domain() functions to
> + * wait within a certain synchronization domain rather than globally.  A
> + * synchronization domain is specified via @domain.  Note: This function
> + * may be called from atomic or non-atomic contexts.
> + *
> + * The node requested will be honored on a best effort basis. If the node
> + * has no CPUs associated with it then the work is distributed among all
> + * available CPUs.
> + */

Same comment here: I think that also in the above "A synchronization domain is
specified via @domain." is redundant.

Otherwise this patch looks fine to me.

Bart.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
