Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5A7D221E11D8E
 for <linux-nvdimm@lists.01.org>; Wed,  9 Aug 2017 07:17:10 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Daemon of NVDIMM event notification/monitoring(Re:
 Standardization of ACPI NVDIMM DSMs)
References: <d77f5643-7cd2-8f0f-02b7-118d0305e547@hpe.com>
 <20170710171649.731E.E1E9C6FF@jp.fujitsu.com>
 <20170724145040.8409.E1E9C6FF@jp.fujitsu.com>
Date: Wed, 09 Aug 2017 10:19:17 -0400
In-Reply-To: <20170724145040.8409.E1E9C6FF@jp.fujitsu.com> (Yasunori Goto's
 message of "Mon, 24 Jul 2017 14:50:44 +0900")
Message-ID: <x49wp6cbz8a.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Yasunori Goto <y-goto@jp.fujitsu.com> writes:

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
>
>
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
>
> c) udev
>    Udev can kick any programs if udev.rules is created.
>    However, there is no uevent for the event of over-threshold currently.
>    In addition, I'm not sure that udev fits this type of event notification.
>
>
> d) make a new tiny daemon in ndctl tree
>    This may be simpler way. 
>    It can use ndctl_dimm_get_health_eventfd() and poll()/select().
>     
>    But, ndctl may be included in kernel source,
>    and I don't know whether kernel includes other daemon tools or not.

e) acpid

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
