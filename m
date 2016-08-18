Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 97C811A1E04
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 13:30:30 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id f189so37766831oig.3
 for <linux-nvdimm@lists.01.org>; Thu, 18 Aug 2016 13:30:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1471551711.6177.25.camel@intel.com>
References: <1471546104-28520-1-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4ixygjD8St5YP2SjfEJnVeWMsAHjqDTF8xxWPvvDWw_bw@mail.gmail.com>
 <07af328e-d703-fd80-20be-725f00e54812@hpe.com>
 <CAPcyv4gM8SNLGn+ATELbBoOZWqk80_XYu41z-PDTs-3ONCGLeA@mail.gmail.com>
 <1471551711.6177.25.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 18 Aug 2016 13:30:23 -0700
Message-ID: <CAPcyv4g+akm6mcOf9biiTOwWs09QWwgP7XDEG-wNcjaq39T4sA@mail.gmail.com>
Subject: Re: [PATCH] acpi, nfit: fix acpi event notifications for nfit
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "guangrong.xiao@linux.intel.com" <guangrong.xiao@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 18, 2016 at 1:22 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Thu, 2016-08-18 at 12:54 -0700, Dan Williams wrote:
>> On Thu, Aug 18, 2016 at 12:52 PM, Linda Knippers <linda.knippers@hpe.c
>> om> wrote:
>> >
>> >
>> >
>> > On 8/18/2016 3:48 PM, Dan Williams wrote:
>> > >
>> > > On Thu, Aug 18, 2016 at 11:48 AM, Vishal Verma <vishal.l.verma@int
>> > > el.com> wrote:
>> > > >
>> > > > The nfit driver had an acpi event notification handler, but it
>> > > > never
>> > > > would've worked because we weren't setting the
>> > > > ACPI_DRIVER_ALL_NOTIFY_EVENTS flag in acpi_driver.
>> > >
>> > > Let's update the changelog to be helpful for someone implementing
>> > > a
>> > > backport or taking this back to a -stable branch.  Something like:
>> > >
>> > > Subject: acpi, nfit: fix event notifications
>> > >
>> > > Commit 209851649dc4 "acpi: nfit: Add support for hot-add" added
>> > > support for _FIT notifications, but it neglected to set the
>> > > ACPI_DRIVER_ALL_NOTIFY_EVENTS flag that acpi_bus_notify() uses to
>> > > gate
>> > > notification delivery.
>> >
>> > While we're at it, should we update the notifier function to
>> > explicitly check
>> > for event 0x80 before re-evaluating the _FIT?  I'm thinking about
>> > some time
>> > in the future when there might be more than one event.
>>
>> Yes, good idea.
>
> Sounds good, part of the same patch or separately?

Separate.

In general, if you would write the word "also" in a patch description,
that's an indication to make a separate patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
