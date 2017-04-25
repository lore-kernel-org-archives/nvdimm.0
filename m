Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 73E7121951C81
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 09:38:35 -0700 (PDT)
Received: by mail-oi0-x229.google.com with SMTP id w12so66386392oiw.3
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 09:38:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170425163707.GA11773@linux.intel.com>
References: <149307779085.7155.436029631521340565.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149307780135.7155.11108531648914675756.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20170425163707.GA11773@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Apr 2017 09:38:34 -0700
Message-ID: <CAPcyv4iRPeA=BEx4X+B651amfKt4m4rAXiq3KhAaZ2=rD0bjQA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] libnvdimm, region: sysfs trigger for nvdimm_flush()
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 25, 2017 at 9:37 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Mon, Apr 24, 2017 at 04:50:01PM -0700, Dan Williams wrote:
>> The nvdimm_flush() mechanism helps to reduce the impact of an ADR
>> (asynchronous-dimm-refresh) failure. The ADR mechanism handles flushing
>> platform WPQ (write-pending-queue) buffers when power is removed. The
>> nvdimm_flush() mechanism performs that same function on-demand.
>>
>> When a pmem namespace is associated with a block device, an
>> nvdimm_flush() is triggered with every block-layer REQ_FUA, or REQ_FLUSH
>> request. These requests are typically associated with filesystem
>> metadata updates. However, when a namespace is in device-dax mode,
>> userspace (think database metadata) needs another path to perform the
>> same flushing. In other words this is not required to make data
>> persistent, but in the case of metadata it allows for a smaller failure
>> domain in the unlikely event of an ADR failure.
>>
>> The new 'flush' attribute is visible when the individual DIMMs backing a
>> given interleave-set are described by platform firmware. In ACPI terms
>> this is "NVDIMM Region Mapping Structures" and associated "Flush Hint
>> Address Structures". Reads return "1" if the region supports triggering
>> WPQ flushes on all DIMMs. Reads return "0" the flush operation is a
>> platform nop, and in that case the attribute is read-only.
>>
>> Cc: Jeff Moyer <jmoyer@redhat.com>
>> Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  drivers/nvdimm/region_devs.c |   41 +++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 41 insertions(+)
>>
>> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
>> index 24abceda986a..c48f3eddce2d 100644
>> --- a/drivers/nvdimm/region_devs.c
>> +++ b/drivers/nvdimm/region_devs.c
>> @@ -255,6 +255,35 @@ static ssize_t size_show(struct device *dev,
>>  }
>>  static DEVICE_ATTR_RO(size);
>>
>> +static ssize_t flush_show(struct device *dev,
>> +             struct device_attribute *attr, char *buf)
>> +{
>> +     struct nd_region *nd_region = to_nd_region(dev);
>> +
>> +     /*
>> +      * NOTE: in the nvdimm_has_flush() error case this attribute is
>> +      * not visible.
>> +      */
>> +     return sprintf(buf, "%d\n", nvdimm_has_flush(nd_region));
>> +}
>> +
>> +static ssize_t flush_store(struct device *dev, struct device_attribute *attr,
>> +             const char *buf, size_t len)
>> +{
>> +     bool flush;
>> +     int rc = strtobool(buf, &flush);
>> +     struct nd_region *nd_region = to_nd_region(dev);
>> +
>> +     if (rc)
>> +             return rc;
>> +     if (!flush)
>> +             return -EINVAL;
>
> Is there a benefit to verifying whether the user actually pushed a "1" into
> our flush sysfs entry?  Why have an -EINVAL error case at all?
>
> Flushing is non-destructive and we don't actually need the user to give us any
> data, so it seems simpler to just have this code flush, regardless of what
> input we received.

I want to be specific so that in the future if we decide that we want
to have "0" or some other value have a different meaning of "1" we
won't need to contend with userspace that may be expecting any random
value to work.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
