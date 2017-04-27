Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x235.google.com (mail-io0-x235.google.com
 [IPv6:2607:f8b0:4001:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6C40E2195406C
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 15:26:50 -0700 (PDT)
Received: by mail-io0-x235.google.com with SMTP id r16so38571127ioi.2
 for <linux-nvdimm@lists.01.org>; Thu, 27 Apr 2017 15:26:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493331874.30303.1.camel@hpe.com>
References: <149333101097.4714.1923436715100717938.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1493331874.30303.1.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Apr 2017 15:26:49 -0700
Message-ID: <CAPcyv4jFk2nAdhViv_3CWQ7UxE=OCYro-d2OW-yAFAsxVUQWZw@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm, pmem: fix badblocks notification crash
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
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 27, 2017 at 3:25 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Thu, 2017-04-27 at 15:10 -0700, Dan Williams wrote:
>> The nd_pmem_notify() routine is called whenever an ARS
>> (address-range-scrub) completes to communicate results to the
>> per-namespace badblocks instances.
>>
>> When the namespace is in btt mode we crash because we do not allocate
>> a struct pmem_device instance in that case. Resulting in the
>> following crash signature:
>>
>>  BUG: unable to handle kernel NULL pointer dereference at
>> 0000000000000030
>>  IP: nd_pmem_notify+0x30/0xf0 [nd_pmem]
>>  Call Trace:
>>   nd_device_notify+0x40/0x50
>>   child_notify+0x10/0x20
>>   device_for_each_child+0x50/0x90
>>   nd_region_notify+0x20/0x30
>>   nd_device_notify+0x40/0x50
>>   nvdimm_region_notify+0x27/0x30
>>   acpi_nfit_scrub+0x341/0x590 [nfit]
>>   process_one_work+0x197/0x450
>>   worker_thread+0x4e/0x4a0
>>   kthread+0x109/0x140
>>
>> Given that we don't even populate the btt badblocks instance, just
>> return early and skip the device to region lookup.
>
> We populate the btt badblocks into nsio->bb, and check/clear them in
> nsio_rw_bytes().

Argh, yes, we don't populate them out to the disk badblocks. I'll go
with your patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
