Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E3541A1DEC
 for <linux-nvdimm@lists.01.org>; Wed, 31 Aug 2016 01:50:11 -0700 (PDT)
Subject: Re: DAX can not work on virtual nvdimm device
References: <436d7526-bf06-633d-afce-4333552d9e31@linux.intel.com>
 <CAPcyv4hVgi6Hw8Beg=Nt78+U0QNJN9mBGWEp3V6bg86NaM3Q6Q@mail.gmail.com>
 <20160819183047.GA7216@linux.intel.com>
 <600ac51c-0f61-6e53-9bfa-669c85494d1f@linux.intel.com>
 <20160829193014.GB16738@linux.intel.com>
 <61d5c470-a8bf-86d5-d1fe-b4b577a85967@linux.intel.com>
 <CAPcyv4hrFSxNcmmVLVZT4fK3+hspPCDKW0rVBj1=3GkJRgZ29Q@mail.gmail.com>
From: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Message-ID: <25098f37-53f7-6d5d-0b1a-8469bab51a9f@linux.intel.com>
Date: Wed, 31 Aug 2016 16:44:47 +0800
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hrFSxNcmmVLVZT4fK3+hspPCDKW0rVBj1=3GkJRgZ29Q@mail.gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Yumei Huang <yuhuang@redhat.com>, KVM <kvm@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, LKML <linux-kernel@vger.kernel.org>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>



On 08/31/2016 01:09 AM, Dan Williams wrote:

>
> Can you post your exact reproduction steps?  This test is not failing for me.
>

Sure.

1. make the guest kernel based on your tree, the top commit is
    10d7902fa0e82b (dax: unmap/truncate on device shutdown) and
    the config file can be found in this thread.

2. add guest kernel command line: memmap=6G!10G

3: start the guest:
    x86_64-softmmu/qemu-system-x86_64 -machine pc,nvdimm --enable-kvm \
    -smp 16 -m 32G,maxmem=100G,slots=100 /other/VMs/centos6.img -monitor stdio

4: in guest:
    mkfs.ext4 /dev/pmem0
    mount -o dax /dev/pmem0  /mnt/pmem/
    echo > /mnt/pmem/xxx
    ./mmap /mnt/pmem/xxx
    ./read /mnt/pmem/xxx

   The source code of mmap and read has been attached in this mail.

   Hopefully, you can detect the error triggered by read test.

Thanks!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
