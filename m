Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22a.google.com (mail-io0-x22a.google.com
 [IPv6:2607:f8b0:4001:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 40AD221A13482
 for <linux-nvdimm@lists.01.org>; Wed,  3 May 2017 14:48:54 -0700 (PDT)
Received: by mail-io0-x22a.google.com with SMTP id p80so200355959iop.3
 for <linux-nvdimm@lists.01.org>; Wed, 03 May 2017 14:48:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493837209.30303.47.camel@hpe.com>
References: <20170503153103.30756-1-toshi.kani@hpe.com>
 <CAPcyv4hu9iW-EEaggOj4ax_P6=Y28adi5Hb7Rp1Q1xBTWenJuQ@mail.gmail.com>
 <1493827750.30303.44.camel@hpe.com>
 <CAPcyv4gthc8Gc7SUyxqecDrd+dtOfOzY19bs5sY1qMepQKh=kQ@mail.gmail.com>
 <1493837209.30303.47.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 May 2017 14:48:52 -0700
Message-ID: <CAPcyv4ifW-tpo=WzhL8W4pxfv6XWw=QSxCApXtcXnhbK3Nf6YQ@mail.gmail.com>
Subject: Re: [RFC PATCH] dax: add badblocks check to Device DAX
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 3, 2017 at 11:46 AM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Wed, 2017-05-03 at 09:30 -0700, Dan Williams wrote:
>> On Wed, May 3, 2017 at 9:09 AM, Kani, Toshimitsu <toshi.kani@hpe.com>
>> wrote:
>> > On Wed, 2017-05-03 at 08:52 -0700, Dan Williams wrote:
>> > > On Wed, May 3, 2017 at 8:31 AM, Toshi Kani <toshi.kani@hpe.com>
>> > > wrote:
>> > > > This is a RFC patch for seeking suggestions.  It adds support
>> > > > of badblocks check in Device DAX by using region-level
>> > > > badblocks list.  This patch is only briefly tested.
>> > > >
>> > > > device_dax is a well-isolated self-contained module as it calls
>> > > > alloc_dax() with dev_dax, which is private to device_dax.  For
>> > > > checking badblocks, it needs to call dax_pmem to check with
>> > > > region-level badblocks.
>> > > >
>> > > > This patch attempts to keep device_dax self-contained.  It adds
>> > > > check_error() to dax_operations, and dax_check_error() as a
>> > > > stub with *dev_dax and *dev pointers to convey it to
>> > > > dax_pmem.  I am wondering if this is the right direction, or we
>> > > > should change the modularity to let dax_pmem call alloc_dax()
>> > > > with its dax_pmem (or I completely missed something).
>> > >
>> > > The problem is that device-dax guarantees a given fault
>> > > granularity. To make that guarantee we can't fallback from 1G or
>> > > 2M mappings due to an error. We also can't reasonably go the
>> > > other way and fail mappings that contain a badblock because that
>> > > would change the blast radius of a media error to the fault size.
>> >
>> > Does it mean we expect users to have CPUs with MCE recovery for
>> > Device DAX?  Can we add an attributes like allow error-check &
>> > fall-back?
>>
>> Yes, without MCE recovery device-dax mappings that consume errors
>> will reboot. If an application needs the kernel protection it should
>> be using filesystem-dax.
>
> Understood.  Are we going to provide sysfs "badblocks" for Device DAX
> as it is also needed for ndctl clear-error?

No, I had started that way, but badblocks really needs write(2) or
fallocate(PUNCH_HOLE) support for clearing errors. Since we don't want
to support write(2) and were NAKd from supporting fallocate() the only
interface that was left was sending clear-error-DSM ioctls directly to
 the nvdimm bus. Since that is a very libnvdimm specific interface it
made sense to then add badblocks at the libnvdimm-region level. The
"ndctl clear-error" command is there to do the translation of error
offsets in user space and supersedes the need for the kernel to carry
a badblocks file for device-dax.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
