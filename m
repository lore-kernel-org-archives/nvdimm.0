Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22e.google.com (mail-yw0-x22e.google.com
 [IPv6:2607:f8b0:4002:c05::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2AA002095DB9B
 for <linux-nvdimm@lists.01.org>; Mon, 24 Jul 2017 09:09:06 -0700 (PDT)
Received: by mail-yw0-x22e.google.com with SMTP id i6so18334164ywb.1
 for <linux-nvdimm@lists.01.org>; Mon, 24 Jul 2017 09:11:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170724145040.8409.E1E9C6FF@jp.fujitsu.com>
References: <d77f5643-7cd2-8f0f-02b7-118d0305e547@hpe.com>
 <20170710171649.731E.E1E9C6FF@jp.fujitsu.com>
 <20170724145040.8409.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 24 Jul 2017 09:11:05 -0700
Message-ID: <CAPcyv4hH179pa128Lq9jgBUufO=aS8za48FAj6ZmDR4qVvRxfg@mail.gmail.com>
Subject: Re: Daemon of NVDIMM event notification/monitoring(Re:
 Standardization of ACPI NVDIMM DSMs)
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jul 23, 2017 at 10:50 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> Hi,
>
>> >   Another approach could be to integrate NVDIMM event
>> > monitoring into some other utility, like the rasdaemon.  I'm interested in
>> > your thoughts.
>>
>> Though I'm not sure which (existing or new) utility is appropriate yet.
>> I prefer this way. So, I'll think about it.
>
> I investigated the issue that notification/monitoring feature of over-
> threshold event with my co-worker. Here is current our understandings.
>
>
> a) rasdaemon
>   It is good tools for machine check error, and if machine check occurs on
>   NVDIMM, I suppose it will work not only traditional RAM but also NVDIMM.
>   But, it may not fit the purpose of notification/monitoring threshold event.

My concern with rasdaemon is that its heuristics are built for
off-lining volatile system-ram, not managing persistent media errors.

> b) smartmontools (https://www.smartmontools.org/)
>   This tool may fit the purpose of notification/monitoring of health of NVDIMMs.
>   However, it may a bit troublesome due to the followings.
>
>     - The smartd seems to check smart values of each devices with
>       ioctl() periodically (In other words, "polling").
>       Probably, other devices does not have the
>       notification interface like "ndctl_dimm_get_health_eventfd()
>       and poll()/select()".
>
>     - smartmontools supports many OSs (Windows, darwin, xxxBSDs, os2(!)).
>       I'm not sure other OSs have similar notification interface like Linux.
>       So, it may need to "polling" like other devices.

One of the explicit goals of ndctl vs smartmontools is trying to make
sure that vendor-specific details don't leak into the output data
format. ndctl is also built to leverage the Linux specific
capabilities of the libnvdimm sub-system vs some
lowest-common-denominator implementation that results from trying to
be cross-OS compatible with an abstraction layer.

> c) udev
>    Udev can kick any programs if udev.rules is created.
>    However, there is no uevent for the event of over-threshold currently.
>    In addition, I'm not sure that udev fits this type of event notification.

There are some drivers that use uevents for logging, I prefer poll(2)
capable sysfs files.

> d) make a new tiny daemon in ndctl tree
>    This may be simpler way.
>    It can use ndctl_dimm_get_health_eventfd() and poll()/select().
>
>    But, ndctl may be included in kernel source,
>    and I don't know whether kernel includes other daemon tools or not.

The kernel does include a few daemons in the tools/ directory, so I
don't see this being a problem. Now, that said, Linus still has the
prerogative to not pull ndctl into the kernel for 4.14, but at this
point I feel more likely than not that the next version of ndctl will
be v4.14-rc1 instead of v58.

> Though I feel like selecting d) now.....
> Any thoughts?

I'm also in favor of d).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
