Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 662271A1E48
 for <linux-nvdimm@lists.01.org>; Tue,  6 Sep 2016 08:06:26 -0700 (PDT)
Date: Tue, 6 Sep 2016 17:06:20 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: DAX can not work on virtual nvdimm device
Message-ID: <20160906150620.GJ28922@quack2.suse.cz>
References: <436d7526-bf06-633d-afce-4333552d9e31@linux.intel.com>
 <CAPcyv4hVgi6Hw8Beg=Nt78+U0QNJN9mBGWEp3V6bg86NaM3Q6Q@mail.gmail.com>
 <20160819183047.GA7216@linux.intel.com>
 <600ac51c-0f61-6e53-9bfa-669c85494d1f@linux.intel.com>
 <20160829193014.GB16738@linux.intel.com>
 <61d5c470-a8bf-86d5-d1fe-b4b577a85967@linux.intel.com>
 <CAPcyv4hrFSxNcmmVLVZT4fK3+hspPCDKW0rVBj1=3GkJRgZ29Q@mail.gmail.com>
 <25098f37-53f7-6d5d-0b1a-8469bab51a9f@linux.intel.com>
 <20160902025738.GA26108@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160902025738.GA26108@linux.intel.com>
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
Cc: Yumei Huang <yuhuang@redhat.com>, Jan Kara <jack@suse.cz>, KVM <kvm@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, LKML <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Stefan Hajnoczi <stefanha@redhat.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 01-09-16 20:57:38, Ross Zwisler wrote:
> On Wed, Aug 31, 2016 at 04:44:47PM +0800, Xiao Guangrong wrote:
> > On 08/31/2016 01:09 AM, Dan Williams wrote:
> > > 
> > > Can you post your exact reproduction steps?  This test is not failing for me.
> > > 
> > 
> > Sure.
> > 
> > 1. make the guest kernel based on your tree, the top commit is
> >    10d7902fa0e82b (dax: unmap/truncate on device shutdown) and
> >    the config file can be found in this thread.
> > 
> > 2. add guest kernel command line: memmap=6G!10G
> > 
> > 3: start the guest:
> >    x86_64-softmmu/qemu-system-x86_64 -machine pc,nvdimm --enable-kvm \
> >    -smp 16 -m 32G,maxmem=100G,slots=100 /other/VMs/centos6.img -monitor stdio
> > 
> > 4: in guest:
> >    mkfs.ext4 /dev/pmem0
> >    mount -o dax /dev/pmem0  /mnt/pmem/
> >    echo > /mnt/pmem/xxx
> >    ./mmap /mnt/pmem/xxx
> >    ./read /mnt/pmem/xxx
> > 
> >   The source code of mmap and read has been attached in this mail.
> > 
> >   Hopefully, you can detect the error triggered by read test.
> > 
> > Thanks!
> 
> Okay, I think I've isolated this issue.  Xiao's VM was an old CentOS 6 system,
> and for some reason ext4+DAX with the old tools found in that VM fails.  I was
> able to reproduce this failure with a freshly installed CentOS 6.8 VM.
> 
> You can see the failure with his tests, or perhaps more easily with this
> series of commands:
> 
>   # mkfs.ext4 /dev/pmem0
>   # mount -o dax /dev/pmem0  /mnt/pmem/
>   # touch /mnt/pmem/x
>   # md5sum /mnt/pmem/x
>   md5sum: /mnt/pmem/x: Bad address
> 
> This sequence of commands works fine in the old CentOS 6 system if you use XFS
> instead of ext4, and it works fine with both ext4 and XFS in CentOS 7 and
> with recent versions of Fedora.
> 
> I've added the ext4 folks to this mail in case they care, but my guess is that
> the tools in CentOS 6 are so old that it's not worth worrying about.  For
> reference, the kernel in CentOS 6 is based on 2.6.32.  :)  DAX was introduced
> in v4.0.

Hum, can you post 'dumpe2fs -h /dev/pmem0' output from that system when the
md5sum fails? Because the only idea I have is that mkfs.ext4 in CentOS 6
creates the filesystem with a different set of features than more recent
e2fsprogs and so we hit some untested path...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
