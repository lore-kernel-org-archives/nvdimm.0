Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 85DB022361E47
 for <linux-nvdimm@lists.01.org>; Mon, 12 Feb 2018 14:59:22 -0800 (PST)
Received: by mail-oi0-x241.google.com with SMTP id e15so12477759oiy.2
 for <linux-nvdimm@lists.01.org>; Mon, 12 Feb 2018 15:05:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <x49inb1n7kb.fsf@segfault.boston.devel.redhat.com>
References: <151847194459.58291.11339638808076622981.stgit@djiang5-desk3.ch.intel.com>
 <x49inb1n7kb.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 12 Feb 2018 15:05:10 -0800
Message-ID: <CAPcyv4gt88pEivOyEGdYbTx9H2LV7+mQQ9H1ESWhzM+gpbtW0g@mail.gmail.com>
Subject: Re: [PATCH v2] libnvdimm: re-enable deep flush for pmem devices
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
Cc: "Zwisler, Ross" <ross.zwisler@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 12, 2018 at 2:53 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dave Jiang <dave.jiang@intel.com> writes:
>
>> Re-enable deep flush so that users always have a way to be sure that a write
>> does make it all the way out to the NVDIMM. The PMEM driver writes always
>> make it "all the way to the NVDIMM", and it relies on the ADR mechanism to
>> flush the write buffers on power failure. Deep flush is there to explicitly
>> flush those write buffers to protect against (rare) ADR failure.
>> This change prevents a regression in deep flush behavior so that applications
>> can continue to depend on fsync() as a mechanism to trigger deep flush in the
>> filesystem-dax case.
>
> That's still very confusing text.  Specifically, the part where you say
> that pmem driver writes always make it to the DIMM.  I think the
> changelog could start with "Deep flush is there to explicitly flush
> write buffers...."  Anyway, the fix looks right to me.

I ended up changing the commit message to this, let me know if it reads better:


    libnvdimm: re-enable deep flush for pmem devices via fsync()

    Re-enable deep flush so that users always have a way to be sure that a
    write makes it all the way out to media. The PMEM driver writes always
    arrive at the NVDIMM, and it relies on the ADR (Asynchronous DRAM
    Refresh) mechanism to flush the write buffers on power failure. Deep
    flush is there to explicitly flush those write buffers to protect
    against (rare) ADR failure.  This change prevents a regression in deep
    flush behavior so that applications can continue to depend on fsync() as
    a mechanism to trigger deep flush in the filesystem-DAX case.

    Fixes: 06e8ccdab15f4 ("acpi: nfit: Add support for detect platform
CPU cache...")
    Signed-off-by: Dave Jiang <dave.jiang@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
