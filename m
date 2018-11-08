Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2130.oracle.com (userp2130.oracle.com [156.151.31.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 18E7E21189FB0
 for <linux-nvdimm@lists.01.org>; Thu,  8 Nov 2018 14:43:15 -0800 (PST)
Subject: Re: [driver-core PATCH v6 3/9] device core: Consolidate locking and
 unlocking of parent and device
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170041590.12967.4367086895437513524.stgit@ahduyck-desk1.jf.intel.com>
From: jane.chu@oracle.com
Message-ID: <791408d3-bf97-0f54-adc5-9b06540015c6@oracle.com>
Date: Thu, 8 Nov 2018 14:43:04 -0800
MIME-Version: 1.0
In-Reply-To: <154170041590.12967.4367086895437513524.stgit@ahduyck-desk1.jf.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: len.brown@intel.com, bvanassche@acm.org, linux-nvdimm@lists.01.org, linux-pm@vger.kernel.org, rafael@kernel.org, jiangshanlai@gmail.com, pavel@ucw.cz, zwisler@kernel.org, tj@kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

Hi, Alex,


On 11/08/2018 10:06 AM, Alexander Duyck wrote:
> +/*
> + * __device_driver_lock - release locks needed to manipulate dev->drv

You meant to say __device_driver_unlock, right?

> + * @dev: Device we will update driver info for
> + * @parent: Parent device. Needed if the bus requires parent lock
> + *
> + * This function will release the required locks for manipulating dev->drv.
> + * Normally this will just be the the @dev lock, but when called for a
> + * USB interface, @parent lock will be released as well.
> + */
> +static void __device_driver_unlock(struct device *dev, struct device *parent)
> +{
> +	device_unlock(dev);
> +	if (parent && dev->bus->need_parent_lock)
> +		device_unlock(parent);
> +}

-jane
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
