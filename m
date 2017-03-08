Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6FA18032B
 for <linux-nvdimm@lists.01.org>; Wed,  8 Mar 2017 12:44:21 -0800 (PST)
Received: by mail-oi0-x22b.google.com with SMTP id 62so26560440oih.2
 for <linux-nvdimm@lists.01.org>; Wed, 08 Mar 2017 12:44:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <x49lgsfqzeb.fsf@segfault.boston.devel.redhat.com>
References: <x49lgsfqzeb.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Mar 2017 12:44:20 -0800
Message-ID: <CAPcyv4iEexnUuR4JrSkbcUKDhMtOhBn1-TzvhzQ=unwp5reAaQ@mail.gmail.com>
Subject: Re: device dax fails with alignments other than 1GB
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 8, 2017 at 12:36 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Hi,
>
> With a device dax alignment of 4KB or 2MB, I get sigbus when running the
> attached fio job file for the current kernel (4.11.0-rc1+).  If I
> specify an alignment of 1GB, it works.
>
> I turned on debug output, and saw that it was failing in the huge fault
> code.
>
> [ 4614.138357] dax dax1.0: dax_open
> [ 4614.154838] dax dax1.0: dax_mmap
> [ 4614.171898] dax dax1.0: dax_dev_huge_fault: fio: write (0x7f08f0a00000 - 0x7f0ce0800000)
> [ 4614.211720] dax dax1.0: __dax_dev_pud_fault: phys_to_pgoff(0xffffffffcf600) failed
> [ 4614.568911] dax dax1.0: dax_release
>
> Note that the printk is backwards: it's not phys_to_pgoff but rather
> pgoff_to_phys that fails.
>
> I don't have time to dig into this right now, so I figured I'd report it
> in case others do.
>
> This does make me wonder how much testing device dax receives.  I tried
> 3 different kernels (a 4.10-rc, this one, and then a version just before
> the huge page support went in) and they all broke in different ways.
> This test is pretty simple.  Dan, can we add it to whatever regression
> tests you guys run for each of 4KB, 2MB and 1GB alignments?

Yes, we do have a basic regression test [1], but it's obviously
missing this. Will fix, thanks for the report!

[1]: https://github.com/pmem/ndctl/blob/master/test/device-dax.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
