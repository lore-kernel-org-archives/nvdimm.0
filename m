Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22c.google.com (mail-yw0-x22c.google.com
 [IPv6:2607:f8b0:4002:c05::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C94B521AEB0BE
 for <linux-nvdimm@lists.01.org>; Wed,  9 Aug 2017 13:46:52 -0700 (PDT)
Received: by mail-yw0-x22c.google.com with SMTP id s143so47332005ywg.1
 for <linux-nvdimm@lists.01.org>; Wed, 09 Aug 2017 13:49:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <598B5BE7.8050705@hpe.com>
References: <d77f5643-7cd2-8f0f-02b7-118d0305e547@hpe.com>
 <20170710171649.731E.E1E9C6FF@jp.fujitsu.com>
 <20170724145040.8409.E1E9C6FF@jp.fujitsu.com>
 <x49wp6cbz8a.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4gg6xXY9c8iNccVQCr-OUqWgBDqKsj=VEuAig=g_QtxBQ@mail.gmail.com>
 <598B5BE7.8050705@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Aug 2017 13:49:09 -0700
Message-ID: <CAPcyv4gu+CXwfqkN8BYurysUt8-bOAS+06MnOhG9r7eU0Ek7yw@mail.gmail.com>
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 9, 2017 at 12:00 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 08/09/2017 02:30 PM, Dan Williams wrote:
>> On Wed, Aug 9, 2017 at 7:19 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>>> Yasunori Goto <y-goto@jp.fujitsu.com> writes:
>>>
>>>> Hi,
>>>>
>>>>>>   Another approach could be to integrate NVDIMM event
>>>>>> monitoring into some other utility, like the rasdaemon.  I'm interested in
>>>>>> your thoughts.
>>>>>
>>>>> Though I'm not sure which (existing or new) utility is appropriate yet.
>>>>> I prefer this way. So, I'll think about it.
>>>>
>>>> I investigated the issue that notification/monitoring feature of over-
>>>> threshold event with my co-worker. Here is current our understandings.
>>>>
>>>>
>>>> a) rasdaemon
>>>>   It is good tools for machine check error, and if machine check occurs on
>>>>   NVDIMM, I suppose it will work not only traditional RAM but also NVDIMM.
>>>>   But, it may not fit the purpose of notification/monitoring threshold event.
>>>>
>>>>
>>>> b) smartmontools (https://www.smartmontools.org/)
>>>>   This tool may fit the purpose of notification/monitoring of health of NVDIMMs.
>>>>   However, it may a bit troublesome due to the followings.
>>>>
>>>>     - The smartd seems to check smart values of each devices with
>>>>       ioctl() periodically (In other words, "polling").
>>>>       Probably, other devices does not have the
>>>>       notification interface like "ndctl_dimm_get_health_eventfd()
>>>>       and poll()/select()".
>>>>
>>>>     - smartmontools supports many OSs (Windows, darwin, xxxBSDs, os2(!)).
>>>>       I'm not sure other OSs have similar notification interface like Linux.
>>>>       So, it may need to "polling" like other devices.
>>>>
>>>> c) udev
>>>>    Udev can kick any programs if udev.rules is created.
>>>>    However, there is no uevent for the event of over-threshold currently.
>>>>    In addition, I'm not sure that udev fits this type of event notification.
>>>>
>>>>
>>>> d) make a new tiny daemon in ndctl tree
>>>>    This may be simpler way.
>>>>    It can use ndctl_dimm_get_health_eventfd() and poll()/select().
>>>>
>>>>    But, ndctl may be included in kernel source,
>>>>    and I don't know whether kernel includes other daemon tools or not.
>>>
>>> e) acpid
>>
>> Except acpid is ACPI specific, and the event sources that libnvdimm
>> generates are generic. For example, we may be getting an Open Firmware
>> libnvdimm bus in the next merge window.
>
> Can you say more about that?  It seems that the notifications we're worried
> about here and the interface for getting information about the notification
> are both ACPI-specific.

Capturing the raw acpi events is not that interesting because we'll
immediately want to turn around and ask what those mean to Linux
kernel objects, so might as well monitor those objects directly.

> We haven't talked much about iwhat a daemon would do once it gets a
> notification from whatever the source is.  That might help us determine
> the right tool.  Is it just logging?

Yes, logging, and maybe a simple framework to call external helper
applications when a given events fires, or fires too many times within
a certain threshold.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
