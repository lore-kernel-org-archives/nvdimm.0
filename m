Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CABD621A02937
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 18:48:16 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id m6so6304142oig.11
 for <linux-nvdimm@lists.01.org>; Mon, 26 Nov 2018 18:48:16 -0800 (PST)
MIME-Version: 1.0
References: <154170028986.12967.2108024712555179678.stgit@ahduyck-desk1.jf.intel.com>
 <154170043123.12967.3591757325647337726.stgit@ahduyck-desk1.jf.intel.com>
In-Reply-To: <154170043123.12967.3591757325647337726.stgit@ahduyck-desk1.jf.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 26 Nov 2018 18:48:05 -0800
Message-ID: <CAPcyv4g0LNJZ38NKMXsBY+GgmGbHR4VrTM1gkm3m4bg6fOrfsw@mail.gmail.com>
Subject: Re: [driver-core PATCH v6 6/9] driver core: Probe devices
 asynchronously instead of the driver
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
Cc: "Brown, Len" <len.brown@intel.com>, bvanassche@acm.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, jiangshanlai@gmail.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>, zwisler@kernel.org, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Nov 8, 2018 at 10:07 AM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> Probe devices asynchronously instead of the driver. This results in us
> seeing the same behavior if the device is registered before the driver or
> after. This way we can avoid serializing the initialization should the
> driver not be loaded until after the devices have already been added.
>
> The motivation behind this is that if we have a set of devices that
> take a significant amount of time to load we can greatly reduce the time to
> load by processing them in parallel instead of one at a time. In addition,
> each device can exist on a different node so placing a single thread on one
> CPU to initialize all of the devices for a given driver can result in poor
> performance on a system with multiple nodes.

Do you have numbers on effects of this change individually? Is this
change necessary for the libnvdimm init speedup, or is it independent?

> I am using the driver_data member of the device struct to store the driver
> pointer while we wait on the deferred probe call. This should be safe to do
> as the value will either be set to NULL on a failed probe or driver load
> followed by unload, or the driver value itself will be set on a successful
> driver load. In addition I have used the async_probe flag to add additional
> protection as it will be cleared if someone overwrites the driver_data
> member as a part of loading the driver.

I would not put it past a device-driver to call dev_get_drvdata()
before dev_set_drvdata(), to check "has this device already been
initialized". So I don't think it is safe to assume that the core can
stash this information in ->driver_data. Why not put this
infrastructure in struct device_private?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
