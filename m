Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F30E321CF1CEA
 for <linux-nvdimm@lists.01.org>; Tue, 13 Feb 2018 05:11:49 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v2] libnvdimm: re-enable deep flush for pmem devices
References: <151847194459.58291.11339638808076622981.stgit@djiang5-desk3.ch.intel.com>
 <x49inb1n7kb.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4gt88pEivOyEGdYbTx9H2LV7+mQQ9H1ESWhzM+gpbtW0g@mail.gmail.com>
Date: Tue, 13 Feb 2018 08:17:38 -0500
In-Reply-To: <CAPcyv4gt88pEivOyEGdYbTx9H2LV7+mQQ9H1ESWhzM+gpbtW0g@mail.gmail.com>
 (Dan Williams's message of "Mon, 12 Feb 2018 15:05:10 -0800")
Message-ID: <x49bmgtqb9p.fsf@segfault.boston.devel.redhat.com>
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
Cc: "Zwisler, Ross" <ross.zwisler@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Mon, Feb 12, 2018 at 2:53 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Dave Jiang <dave.jiang@intel.com> writes:
>>
>>> Re-enable deep flush so that users always have a way to be sure that a write
>>> does make it all the way out to the NVDIMM. The PMEM driver writes always
>>> make it "all the way to the NVDIMM", and it relies on the ADR mechanism to
>>> flush the write buffers on power failure. Deep flush is there to explicitly
>>> flush those write buffers to protect against (rare) ADR failure.
>>> This change prevents a regression in deep flush behavior so that applications
>>> can continue to depend on fsync() as a mechanism to trigger deep flush in the
>>> filesystem-dax case.
>>
>> That's still very confusing text.  Specifically, the part where you say
>> that pmem driver writes always make it to the DIMM.  I think the
>> changelog could start with "Deep flush is there to explicitly flush
>> write buffers...."  Anyway, the fix looks right to me.
>
> I ended up changing the commit message to this, let me know if it reads better:

Thanks.  It's still unclear to me what the text, "The PMEM driver writes
always arrive at the NVDIMM" means.  However, it's good enough.

Thanks!
Jeff

>
>     libnvdimm: re-enable deep flush for pmem devices via fsync()
>
>     Re-enable deep flush so that users always have a way to be sure that a
>     write makes it all the way out to media. The PMEM driver writes always
>     arrive at the NVDIMM, and it relies on the ADR (Asynchronous DRAM
>     Refresh) mechanism to flush the write buffers on power failure. Deep
>     flush is there to explicitly flush those write buffers to protect
>     against (rare) ADR failure.  This change prevents a regression in deep
>     flush behavior so that applications can continue to depend on fsync() as
>     a mechanism to trigger deep flush in the filesystem-DAX case.
>
>     Fixes: 06e8ccdab15f4 ("acpi: nfit: Add support for detect platform
> CPU cache...")
>     Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>     Signed-off-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
