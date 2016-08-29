Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CD24A1A1DEE
 for <linux-nvdimm@lists.01.org>; Mon, 29 Aug 2016 12:30:15 -0700 (PDT)
Date: Mon, 29 Aug 2016 13:30:14 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: DAX can not work on virtual nvdimm device
Message-ID: <20160829193014.GB16738@linux.intel.com>
References: <436d7526-bf06-633d-afce-4333552d9e31@linux.intel.com>
 <CAPcyv4hVgi6Hw8Beg=Nt78+U0QNJN9mBGWEp3V6bg86NaM3Q6Q@mail.gmail.com>
 <20160819183047.GA7216@linux.intel.com>
 <600ac51c-0f61-6e53-9bfa-669c85494d1f@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <600ac51c-0f61-6e53-9bfa-669c85494d1f@linux.intel.com>
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
To: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Cc: Yumei Huang <yuhuang@redhat.com>, KVM <kvm@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, LKML <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 29, 2016 at 03:54:10PM +0800, Xiao Guangrong wrote:
> 
> Hi Ross,
> 
> Sorry for the delay, i just returned back from KVM Forum.
> 
> On 08/20/2016 02:30 AM, Ross Zwisler wrote:
> > On Fri, Aug 19, 2016 at 07:59:29AM -0700, Dan Williams wrote:
> > > On Fri, Aug 19, 2016 at 4:19 AM, Xiao Guangrong
> > > <guangrong.xiao@linux.intel.com> wrote:
> > > > 
> > > > Hi Dan,
> > > > 
> > > > Recently, Redhat reported that nvml test suite failed on QEMU/KVM,
> > > > more detailed info please refer to:
> > > >    https://bugzilla.redhat.com/show_bug.cgi?id=1365721
> > > > 
> > > > The reason for this bug is that the memory region created by mmap()
> > > > on the dax-based file was gone so that the region can not be found
> > > > in /proc/self/smaps during the runtime.
> > > > 
> > > > This is a simple way to trigger this issue:
> > > >    mount -o dax /dev/pmem0 /mnt/pmem/
> > > >    vim /mnt/pmem/xxx
> > > > then 'vim' is crashed due to segment fault.
> > > > 
> > > > This bug can be reproduced on your tree, the top commit is
> > > > 10d7902fa0e82b (dax: unmap/truncate on device shutdown), the kernel
> > > > configure file is attached.
> > > > 
> > > > Your thought or comment is highly appreciated.
> > > 
> > > I'm going to be offline until Tuesday, but I will investigate when I'm
> > > back.  In the meantime if Ross or Vishal had an opportunity to take a
> > > look I wouldn't say "no" :).
> > 
> > I haven't been able to reproduce this vim segfault.  I'm using QEMU v2.6.0,
> > and the kernel commit you mentioned, and your kernel config.
> > 
> > Here's my QEMU command line:
> > 
> > sudo ~/qemu/bin/qemu-system-x86_64 /var/lib/libvirt/images/alara.qcow2 \
> > -machine pc,nvdimm -m 8G,maxmem=100G,slots=100  -object \
> > memory-backend-file,id=mem1,share,mem-path=/dev/pmem0,size=8G -device \
> > nvdimm,memdev=mem1,id=nv1 -smp 6 -machine pc,accel=kvm
> > 
> > With this I'm able to mkfs the guest's /dev/pmem0, mount it with -o dax, and
> > write a file with vim.
> 
> Thanks for your test. That's strange...
> 
> > 
> > Can you reproduce your results with a pmem device created via a memmap kernel
> > command line parameter in the guest?  You'll need to update your kernel
> > config to enable CONFIG_X86_PMEM_LEGACY and CONFIG_X86_PMEM_LEGACY_DEVICE.
> > 
> 
> Okay, i tested it with mmap=6G!10G, it failed too. So it looks like it's a
> filesystem or DAX issue.
> 
> More precisely, i figured out the root case that read() returns a wrong value
> when it reaches the end of the file, following test case can trigger it:
> 
> #include <stdlib.h>
> #include <stdio.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> 
> int main(int argc, char *argv[])
> {
> 	char *filename;
> 
> 	if (argc < 2) {
> 		printf("arg: filename.\n");
> 		return -1;
> 	}
> 
> 	filename = argv[1];
> 	printf("test on %s.\n", filename);
> 
> 	int fd = open(filename, O_RDWR);
> 
> 	if (fd < 0) {
> 		perror("open");
> 		return -1;
> 	}
> 
> 	int count = 0;
> 
> 	while (1) {
> 		ssize_t ret;
> 		char buf;
> 
> 		ret = read(fd, &buf, sizeof(buf));
> 		if (ret < 0) {
> 			perror("READ");
> 			return -1;
> 		}
> 
> 		if (ret == 0)
> 			break;
> 		if (ret != sizeof(buf)) {
> 			printf("Count %x Ret %lx sizeof(buf) %lx.\n",
> 				count, ret, sizeof(buf));
> 			return -1;
> 		}
> 
> 		count++;
> 		printf("%c", buf);
> 	}
> 
> 	printf("\n Good Read.\n");
> 	return 0;
> }
> 
> 
> 
> It will fail at "ret != sizeof(buf)", for example, the error output on my
> test env is:
>       Count 1000 Ret 22f84200 sizeof(buf) 1.

Can you please verify that you are using "usable" memory for your memmap?  All
the details are here:

https://nvdimm.wiki.kernel.org/how_to_choose_the_correct_memmap_kernel_parameter_for_pmem_on_your_system

My guess is that Boaz was correct, and that your memmap is off using addresses
that don't actually map to memory.

- Ross
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
