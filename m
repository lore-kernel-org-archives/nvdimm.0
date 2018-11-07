Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com
 [209.85.215.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C74AA2118A593
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 16:22:45 -0800 (PST)
Received: by mail-pg1-f193.google.com with SMTP id r9-v6so6555381pgv.6
 for <linux-nvdimm@lists.01.org>; Tue, 06 Nov 2018 16:22:45 -0800 (PST)
Message-ID: <1541550162.196084.199.camel@acm.org>
Subject: Re: [driver-core PATCH v5 6/9] driver core: Probe devices
 asynchronously instead of the driver
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 06 Nov 2018 16:22:42 -0800
In-Reply-To: <154145232994.29224.4383053368766089653.stgit@ahduyck-desk1.jf.intel.com>
References: <154145223352.29224.8912797012647157172.stgit@ahduyck-desk1.jf.intel.com>
 <154145232994.29224.4383053368766089653.stgit@ahduyck-desk1.jf.intel.com>
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

On Mon, 2018-11-05 at 13:12 -0800, Alexander Duyck wrote:
> diff --git a/include/linux/device.h b/include/linux/device.h
> index fc7091d436c2..4d9a39769081 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> [ ... ]
> +static inline struct device_driver *dev_get_drv_async(const struct device *dev)
> +{
> +	return dev->async_probe ? dev->driver_data : NULL;
> +}
> +
> +static inline void dev_set_drv_async(struct device *dev,
> +				     struct device_driver *drv)
> +{
> +	/*
> +	 * Set async_probe to true indicating we are waiting for this data to be
> +	 * loaded as a potential driver.
> +	 */
> +	dev->driver_data = drv;
> +	dev->async_probe = true;
> +}

Since these two new functions are only used in the driver core please move
their definition into the driver core.

Thanks,

Bart.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
