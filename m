Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3332C21159809
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 17:31:29 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id m11-v6so729497oic.2
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 17:31:29 -0700 (PDT)
MIME-Version: 1.0
References: <20180926214433.13512.30289.stgit@localhost.localdomain>
 <20180926215143.13512.56522.stgit@localhost.localdomain>
In-Reply-To: <20180926215143.13512.56522.stgit@localhost.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Sep 2018 17:31:16 -0700
Message-ID: <CAPcyv4iJOYiM+rHsM4GPifKNJ=X+AtV2MgWTn+f7u0VBzXb2og@mail.gmail.com>
Subject: Re: [RFC workqueue/driver-core PATCH 2/5] async: Add support for
 queueing on specific NUMA node
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
To: alexander.h.duyck@linux.intel.com
Cc: "Brown, Len" <len.brown@intel.com>, Linux-pm mailing list <linux-pm@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, zwisler@kernel.org, Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 26, 2018 at 2:51 PM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> This patch introduces four new variants of the async_schedule_ functions
> that allow scheduling on a specific NUMA node.
>
> The first two functions are async_schedule_near and
> async_schedule_near_domain which end up mapping to async_schedule and
> async_schedule_domain but provide NUMA node specific functionality. They
> replace the original functions which were moved to inline function
> definitions that call the new functions while passing NUMA_NO_NODE.
>
> The second two functions are async_schedule_dev and
> async_schedule_dev_domain which provide NUMA specific functionality when
> passing a device as the data member and that device has a NUMA node other
> than NUMA_NO_NODE.
>
> The main motivation behind this is to address the need to be able to
> schedule device specific init work on specific NUMA nodes in order to
> improve performance of memory initialization.
>
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
[..]
>  /**
> - * async_schedule - schedule a function for asynchronous execution
> + * async_schedule_near - schedule a function for asynchronous execution
>   * @func: function to execute asynchronously
>   * @data: data pointer to pass to the function
> + * @node: NUMA node that we want to schedule this on or close to
>   *
>   * Returns an async_cookie_t that may be used for checkpointing later.
>   * Note: This function may be called from atomic or non-atomic contexts.
>   */
> -async_cookie_t async_schedule(async_func_t func, void *data)
> +async_cookie_t async_schedule_near(async_func_t func, void *data, int node)
>  {
> -       return __async_schedule(func, data, &async_dfl_domain);
> +       return async_schedule_near_domain(func, data, node, &async_dfl_domain);
>  }
> -EXPORT_SYMBOL_GPL(async_schedule);
> +EXPORT_SYMBOL_GPL(async_schedule_near);

Looks good to me. The _near() suffix makes it clear that we're doing a
best effort hint to the work placement compared to the strict
expectations of _on routines.

>
>  /**
> - * async_schedule_domain - schedule a function for asynchronous execution within a certain domain
> + * async_schedule_dev_domain - schedule a function for asynchronous execution within a certain domain
>   * @func: function to execute asynchronously
> - * @data: data pointer to pass to the function
> + * @dev: device that we are scheduling this work for
>   * @domain: the domain
>   *
> - * Returns an async_cookie_t that may be used for checkpointing later.
> - * @domain may be used in the async_synchronize_*_domain() functions to
> - * wait within a certain synchronization domain rather than globally.  A
> - * synchronization domain is specified via @domain.  Note: This function
> - * may be called from atomic or non-atomic contexts.
> + * Device specific version of async_schedule_near_domain that provides some
> + * NUMA awareness based on the device node.
> + */
> +async_cookie_t async_schedule_dev_domain(async_func_t func, struct device *dev,
> +                                        struct async_domain *domain)
> +{
> +       return async_schedule_near_domain(func, dev, dev_to_node(dev), domain);
> +}
> +EXPORT_SYMBOL_GPL(async_schedule_dev_domain);

This seems unnecessary and restrictive. Callers may want to pass
something other than dev as the parameter to the async function, and
dev_to_node() is not on onerous burden to place on callers.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
