Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 47EE11A1E06
 for <linux-nvdimm@lists.01.org>; Fri, 19 Aug 2016 11:30:48 -0700 (PDT)
Date: Fri, 19 Aug 2016 12:30:47 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: DAX can not work on virtual nvdimm device
Message-ID: <20160819183047.GA7216@linux.intel.com>
References: <436d7526-bf06-633d-afce-4333552d9e31@linux.intel.com>
 <CAPcyv4hVgi6Hw8Beg=Nt78+U0QNJN9mBGWEp3V6bg86NaM3Q6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hVgi6Hw8Beg=Nt78+U0QNJN9mBGWEp3V6bg86NaM3Q6Q@mail.gmail.com>
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
Cc: Yumei Huang <yuhuang@redhat.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, KVM <kvm@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, LKML <linux-kernel@vger.kernel.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 19, 2016 at 07:59:29AM -0700, Dan Williams wrote:
> On Fri, Aug 19, 2016 at 4:19 AM, Xiao Guangrong
> <guangrong.xiao@linux.intel.com> wrote:
> >
> > Hi Dan,
> >
> > Recently, Redhat reported that nvml test suite failed on QEMU/KVM,
> > more detailed info please refer to:
> >    https://bugzilla.redhat.com/show_bug.cgi?id=1365721
> >
> > The reason for this bug is that the memory region created by mmap()
> > on the dax-based file was gone so that the region can not be found
> > in /proc/self/smaps during the runtime.
> >
> > This is a simple way to trigger this issue:
> >    mount -o dax /dev/pmem0 /mnt/pmem/
> >    vim /mnt/pmem/xxx
> > then 'vim' is crashed due to segment fault.
> >
> > This bug can be reproduced on your tree, the top commit is
> > 10d7902fa0e82b (dax: unmap/truncate on device shutdown), the kernel
> > configure file is attached.
> >
> > Your thought or comment is highly appreciated.
> 
> I'm going to be offline until Tuesday, but I will investigate when I'm
> back.  In the meantime if Ross or Vishal had an opportunity to take a
> look I wouldn't say "no" :).

I haven't been able to reproduce this vim segfault.  I'm using QEMU v2.6.0,
and the kernel commit you mentioned, and your kernel config.

Here's my QEMU command line:

sudo ~/qemu/bin/qemu-system-x86_64 /var/lib/libvirt/images/alara.qcow2 \
-machine pc,nvdimm -m 8G,maxmem=100G,slots=100  -object \
memory-backend-file,id=mem1,share,mem-path=/dev/pmem0,size=8G -device \
nvdimm,memdev=mem1,id=nv1 -smp 6 -machine pc,accel=kvm 

With this I'm able to mkfs the guest's /dev/pmem0, mount it with -o dax, and
write a file with vim.

Can you reproduce your results with a pmem device created via a memmap kernel
command line parameter in the guest?  You'll need to update your kernel
config to enable CONFIG_X86_PMEM_LEGACY and CONFIG_X86_PMEM_LEGACY_DEVICE.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
