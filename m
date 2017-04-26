Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B3EF21954071
 for <linux-nvdimm@lists.01.org>; Wed, 26 Apr 2017 13:39:05 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3] libnvdimm, region: sysfs trigger for nvdimm_flush()
References: <149307780135.7155.11108531648914675756.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149315140303.23340.14688142799059150805.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Wed, 26 Apr 2017 16:38:54 -0400
In-Reply-To: <149315140303.23340.14688142799059150805.stgit@dwillia2-desk3.amr.corp.intel.com>
 (Dan Williams's message of "Tue, 25 Apr 2017 13:17:37 -0700")
Message-ID: <x49zif23nvl.fsf@segfault.boston.devel.redhat.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> The nvdimm_flush() mechanism helps to reduce the impact of an ADR
> (asynchronous-dimm-refresh) failure. The ADR mechanism handles flushing
> platform WPQ (write-pending-queue) buffers when power is removed. The
> nvdimm_flush() mechanism performs that same function on-demand.
>
> When a pmem namespace is associated with a block device, an
> nvdimm_flush() is triggered with every block-layer REQ_FUA, or REQ_FLUSH
> request. These requests are typically associated with filesystem
> metadata updates. However, when a namespace is in device-dax mode,
> userspace (think database metadata) needs another path to perform the
> same flushing. In other words this is not required to make data
> persistent, but in the case of metadata it allows for a smaller failure
> domain in the unlikely event of an ADR failure.
>
> The new 'flush' attribute is visible when the individual DIMMs backing a
> given interleave-set are described by platform firmware. In ACPI terms
> this is "NVDIMM Region Mapping Structures" and associated "Flush Hint
> Address Structures". Reads return "1" if the region supports triggering
> WPQ flushes on all DIMMs. Reads return "0" the flush operation is a
> platform nop, and in that case the attribute is read-only.

I can make peace with exposing this to userspace, though I am mostly
against its use.  However, sysfs feels like the wrong interface.
Believe it or not, I'd rather see this implemented as an ioctl.

This isn't a NACK, it's me giving my opinion.  Do with it what you will.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
