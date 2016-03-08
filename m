Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x243.google.com (mail-wm0-x243.google.com
 [IPv6:2a00:1450:400c:c09::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 608971A1E9F
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 04:03:11 -0800 (PST)
Received: by mail-wm0-x243.google.com with SMTP id p65so3619548wmp.1
 for <linux-nvdimm@lists.01.org>; Tue, 08 Mar 2016 04:02:58 -0800 (PST)
Date: Tue, 8 Mar 2016 13:02:53 +0100
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2-UPDATE 3/4] resource: Add device-managed
 insert/remove_resource()
Message-ID: <20160308120253.GA3599@gmail.com>
References: <1457108082-4610-1-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1457108082-4610-1-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-nvdimm@lists.01.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, bp@suse.de, Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>


* Toshi Kani <toshi.kani@hpe.com> wrote:

> +/**
> + * devm_insert_resource() - insert an I/O or memory resource
> + * @dev: device for which to produce the resource
> + * @root: root of the resource tree
> + * @new: descriptor of the new resource
> + *
> + * This is a device-managed version of insert_resource(). There is usually
> + * no need to release resources requested by this function explicitly since

s/explicitly since
 /explicitly, since

> + * that will be taken care of when the device is unbound from its bus driver.
> + * If for some reason the resource needs to be released explicitly, because
> + * of ordering issues for example, bus drivers must call devm_remove_resource()
> + * rather than the regular remove_resource().
> + *
> + * devm_insert_resource() is intended for producers of resources, such as
> + * FW modules and bus drivers.
> + *
> + * Returns 0 on success or a negative error code on failure.
> + */
> +int devm_insert_resource(struct device *dev, struct resource *root,
> +			  struct resource *new)
> +{
> +	struct resource **ptr;
> +	int ret;
> +
> +	ptr = devres_alloc(__devm_remove_resource, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return -ENOMEM;
> +
> +	*ptr = new;
> +
> +	ret = insert_resource(root, new);
> +	if (ret) {
> +		dev_err(dev, "unable to insert resource: %pR (%d)\n", new, ret);
> +		devres_free(ptr);
> +		return -EBUSY;

Why not return 'ret' here, instead of -EBUSY?

> +	}
> +
> +	devres_add(dev, ptr);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(devm_insert_resource);
> +
> +/**
> + * devm_remove_resource() - remove a previously inserted resource
> + * @dev: device for which to remove the resource
> + * @old: descriptor of the resource
> + *
> + * Remove a resource previously inserted using devm_insert_resource().
> + *
> + * devm_remove_resource() is intended for producers of resources, such as
> + * FW modules and bus drivers.
> + */
> +void devm_remove_resource(struct device *dev, struct resource *old)
> +{
> +	WARN_ON(devres_release(dev, __devm_remove_resource, devm_resource_match,
> +			       old));

So generally we don't put functions with side effects into WARN_ON()s. Just like 
BUG_ON(), in the future it might be disabled on certain Kconfigs, etc. - and it's 
also bad for readability.

Also, please use WARN_ON_ONCE().

> +}
> +EXPORT_SYMBOL_GPL(devm_remove_resource);
> +
> +/*
>   * Called from init/main.c to reserve IO ports.
>   */
>  #define MAXRESERVE 4

Looks good to me otherwise.

Thanks,

	Ingo
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
