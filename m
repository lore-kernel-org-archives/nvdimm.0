Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D8E58032B
 for <linux-nvdimm@lists.01.org>; Wed,  8 Mar 2017 12:49:24 -0800 (PST)
Subject: Re: device dax fails with alignments other than 1GB
References: <x49lgsfqzeb.fsf@segfault.boston.devel.redhat.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <5e517d8e-ab1e-af9f-b2a6-e23f243b53d6@intel.com>
Date: Wed, 8 Mar 2017 13:49:23 -0700
MIME-Version: 1.0
In-Reply-To: <x49lgsfqzeb.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>, "Dan J. Williams" <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>


On 03/08/2017 01:36 PM, Jeff Moyer wrote:
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

I'll take a look. I know I ran fio tests around the time I submitted the
dev-dax ioengine and did not run into that. But you are saying it's
failing even before the 1G support went in?


> 
> Cheers,
> Jeff
> 
> [global]
> ioengine=dev-dax
> direct=0
> filename=/dev/dax0.0
> bs=2m
> 
> [write]
> rw=write
> 
> [read]
> stonewall
> rw=read
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
