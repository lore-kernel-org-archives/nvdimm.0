Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 11AF02194D397
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 13:04:25 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id y11so14338107oie.0
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 13:04:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49bmrj9cqj.fsf@segfault.boston.devel.redhat.com>
References: <149307779085.7155.436029631521340565.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149307779612.7155.12969380677038292861.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49bmrj9cqj.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Apr 2017 13:04:23 -0700
Message-ID: <CAPcyv4g8Y_h3AmgPWBBK7=FOOschc+Z3Nh-9Otx8mAoBthv3=Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] libnvdimm, region: fix flush hint detection crash
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 26, 2017 at 12:43 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> In the case where a dimm does not have any associated flush hints the
>> ndrd->flush_wpq array may be uninitialized leading to crashes with the
>> following signature:
>>
>>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
>>  IP: region_visible+0x10f/0x160 [libnvdimm]
>>
>>  Call Trace:
>>   internal_create_group+0xbe/0x2f0
>>   sysfs_create_groups+0x40/0x80
>>   device_add+0x2d8/0x650
>>   nd_async_device_register+0x12/0x40 [libnvdimm]
>>   async_run_entry_fn+0x39/0x170
>>   process_one_work+0x212/0x6c0
>>   ? process_one_work+0x197/0x6c0
>>   worker_thread+0x4e/0x4a0
>>   kthread+0x10c/0x140
>>   ? process_one_work+0x6c0/0x6c0
>>   ? kthread_create_on_node+0x60/0x60
>>   ret_from_fork+0x31/0x40
>
> Sorry for being dense, but I'm having a tough time connecting the dots,
> here.  How does region_visible trip over the missing (not uninitialized,
> you're actually walking off the end of the structure) wpq_flush array?

So, you're not dense, or you're at least as equally dense as me,
because I didn't immediately understand where this failure was coming
from either. I just happened to trigger it while running patch2 and
thought the current code just looked unsafe by inspection.

> Anyway, the fix looks valid.
>
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
