Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D897821951C80
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 07:05:21 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id j201so1691862oih.2
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 07:05:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493163594.26622.11.camel@hpe.com>
References: <20170425230413.363-1-toshi.kani@hpe.com>
 <CAPcyv4jNpCc=qCsRM0-U3Ov=iFn2e_n53_ZgPdDV3pttS0P9Ew@mail.gmail.com>
 <1493163594.26622.11.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Apr 2017 07:05:20 -0700
Message-ID: <CAPcyv4j97ff6H9Fc7=vVwjBOgjZHyEiEhcf+4PE4MkwLOEoCmg@mail.gmail.com>
Subject: Re: [PATCH] pmem: fix a NULL pointer BUG in nd_pmem_notify
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

On Tue, Apr 25, 2017 at 4:40 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Tue, 2017-04-25 at 16:07 -0700, Dan Williams wrote:
>> On Tue, Apr 25, 2017 at 4:04 PM, Toshi Kani <toshi.kani@hpe.com>
>> wrote:
>> > The following BUG was observed when nd_pmem_notify() was called
>> > for a BTT device.  The use of a pmem_device pointer is not valid
>> > with BTT.
>> >
>> >  BUG: unable to handle kernel NULL pointer dereference at
>> > 0000000000000030
>> >  IP: nd_pmem_notify+0x30/0xf0 [nd_pmem]
>> >  Call Trace:
>> >   nd_device_notify+0x40/0x50
>> >   child_notify+0x10/0x20
>> >   device_for_each_child+0x50/0x90
>> >   nd_region_notify+0x20/0x30
>> >   nd_device_notify+0x40/0x50
>> >   nvdimm_region_notify+0x27/0x30
>> >   acpi_nfit_scrub+0x341/0x590 [nfit]
>> >   process_one_work+0x197/0x450
>> >   worker_thread+0x4e/0x4a0
>> >   kthread+0x109/0x140
>> >
>> > Fix nd_pmem_notify() by setting nd_region and badblocks pointers
>> > properly for BTT.
>> >
>> > Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
>> > Cc: Dan Williams <dan.j.williams@intel.com>
>> > Cc: Vishal Verma <vishal.l.verma@intel.com>
>>
>>
>> Hi Toshi, how did you trigger this? I'd like to get your test into
>> the regression suite.
>
> Hi Dan,
>
> I injected an error and started an ARS scan.  Unfortunately, my test
> steps need to run on our platforms.  I think these error injection
> features can be emulated, though.

Yes, I'll try to come up with something for nfit_test.

Thanks Toshi!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
