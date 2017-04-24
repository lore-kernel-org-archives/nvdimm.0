Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x243.google.com (mail-wm0-x243.google.com
 [IPv6:2a00:1450:400c:c09::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E30222195407C
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 00:04:25 -0700 (PDT)
Received: by mail-wm0-x243.google.com with SMTP id y10so4029583wmh.0
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 00:04:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170424143104.4517.61FB500B@jp.fujitsu.com>
References: <149281853758.22910.2919981036906495309.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170424143104.4517.61FB500B@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 24 Apr 2017 00:04:23 -0700
Message-ID: <CAA9_cmd4mihnee6HARww=Lrtd87fNwqShNDeJ5GG7dmyohamuA@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm, region: sysfs trigger for nvdimm_flush()
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
To: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Apr 23, 2017 at 10:31 PM, Masayoshi Mizuma
<m.mizuma@jp.fujitsu.com> wrote:
> On Fri, 21 Apr 2017 16:48:57 -0700 Dan Williams wrote:
>> The nvdimm_flush() mechanism helps to reduce the impact of an ADR
>> (asynchronous-dimm-refresh) failure. The ADR mechanism handles flushing
>> platform WPQ (write-pending-queue) buffers when power is removed. The
>> nvdimm_flush() mechanism performs that same function on-demand.
>>
>> When a pmem namespace is associated with a block device, an
>> nvdimm_flush() is triggered with every block-layer REQ_FUA, or REQ_FLUSH
>> request. However, when a namespace is in device-dax mode, or namespaces
>> are disabled, userspace needs another path.
>>
>> The new 'flush' attribute is visible when it can be determined that the
>> interleave-set either does, or does not have DIMMs that expose WPQ-flush
>> addresses, "flush-hints" in ACPI NFIT terminology. It returns "1" and
>> flushes DIMMs, or returns "0" the flush operation is a platform nop.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/nvdimm/region_devs.c |   17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
>> index 8de5a04644a1..3495b4c23941 100644
>> --- a/drivers/nvdimm/region_devs.c
>> +++ b/drivers/nvdimm/region_devs.c
>> @@ -255,6 +255,19 @@ static ssize_t size_show(struct device *dev,
>>  }
>>  static DEVICE_ATTR_RO(size);
>>
>> +static ssize_t flush_show(struct device *dev,
>> +             struct device_attribute *attr, char *buf)
>> +{
>> +     struct nd_region *nd_region = to_nd_region(dev);
>> +
>> +     if (nvdimm_has_flush(nd_region)) {
>
> nvdimm_has_flush() also returns as -ENXIO, so
>
> if (nvdimm_has_flush(nd_region) == 1)

If it returns -ENXIO then region_visible() will hide the attribute.

>
>> +             nvdimm_flush(nd_region);
>> +             return sprintf(buf, "1\n");
>> +     }
>> +     return sprintf(buf, "0\n");
>> +}
>> +static DEVICE_ATTR_RO(flush);
>> +
>
> I think separating show and store is better because
> users may only check wheter the device has the flush capability or not.

Makes sense, I'll separate. Thanks for the review.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
