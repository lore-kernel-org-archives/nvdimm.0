Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AC37A21954066
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 10:07:13 -0700 (PDT)
Received: by mail-oi0-x22b.google.com with SMTP id w12so30631663oiw.3
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 10:07:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <58FE2FCA.5050702@hpe.com>
References: <149281853758.22910.2919981036906495309.stgit@dwillia2-desk3.amr.corp.intel.com>
 <58FE2FCA.5050702@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 24 Apr 2017 10:07:12 -0700
Message-ID: <CAPcyv4hwAseE1NR75Zs9VMM3jiYszLFn9w6z9tzMYOFA4Dgpmw@mail.gmail.com>
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 24, 2017 at 10:03 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 04/21/2017 07:48 PM, Dan Williams wrote:
>> The nvdimm_flush() mechanism helps to reduce the impact of an ADR
>> (asynchronous-dimm-refresh) failure. The ADR mechanism handles flushing
>> platform WPQ (write-pending-queue) buffers when power is removed. The
>> nvdimm_flush() mechanism performs that same function on-demand.
>>
>> When a pmem namespace is associated with a block device, an
>> nvdimm_flush() is triggered with every block-layer REQ_FUA, or REQ_FLUSH
>> request. However, when a namespace is in device-dax mode, or namespaces
>> are disabled, userspace needs another path.
>
> Why would a user need to flush a disabled namespace?

For an application that wants to shutdown and sync. Basically I wanted
to make it clear that with this interface the buffers can be synced
regardless of any downstream namespace configuration or state.

>
>> The new 'flush' attribute is visible when it can be determined that the
>> interleave-set either does, or does not have DIMMs that expose WPQ-flush
>> addresses, "flush-hints" in ACPI NFIT terminology. It returns "1" and
>> flushes DIMMs, or returns "0" the flush operation is a platform nop.
>
> It seems a little odd to me that reading a read-only attribute both
> tells you that the device has flush hints and also triggers a flush.
> This means that anyone at any time can cause a flush.  Do we want that?

No, I'm making the change that Masayoshi-san suggested to move the
flush to a write operation... assuming we move forward given Jeff's
concern.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
