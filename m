Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x236.google.com (mail-oi0-x236.google.com
 [IPv6:2607:f8b0:4003:c06::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6985F1A1E05
 for <linux-nvdimm@lists.01.org>; Fri, 19 Aug 2016 07:59:30 -0700 (PDT)
Received: by mail-oi0-x236.google.com with SMTP id c15so66892869oig.0
 for <linux-nvdimm@lists.01.org>; Fri, 19 Aug 2016 07:59:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <436d7526-bf06-633d-afce-4333552d9e31@linux.intel.com>
References: <436d7526-bf06-633d-afce-4333552d9e31@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 19 Aug 2016 07:59:29 -0700
Message-ID: <CAPcyv4hVgi6Hw8Beg=Nt78+U0QNJN9mBGWEp3V6bg86NaM3Q6Q@mail.gmail.com>
Subject: Re: DAX can not work on virtual nvdimm device
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

On Fri, Aug 19, 2016 at 4:19 AM, Xiao Guangrong
<guangrong.xiao@linux.intel.com> wrote:
>
> Hi Dan,
>
> Recently, Redhat reported that nvml test suite failed on QEMU/KVM,
> more detailed info please refer to:
>    https://bugzilla.redhat.com/show_bug.cgi?id=1365721
>
> The reason for this bug is that the memory region created by mmap()
> on the dax-based file was gone so that the region can not be found
> in /proc/self/smaps during the runtime.
>
> This is a simple way to trigger this issue:
>    mount -o dax /dev/pmem0 /mnt/pmem/
>    vim /mnt/pmem/xxx
> then 'vim' is crashed due to segment fault.
>
> This bug can be reproduced on your tree, the top commit is
> 10d7902fa0e82b (dax: unmap/truncate on device shutdown), the kernel
> configure file is attached.
>
> Your thought or comment is highly appreciated.

I'm going to be offline until Tuesday, but I will investigate when I'm
back.  In the meantime if Ross or Vishal had an opportunity to take a
look I wouldn't say "no" :).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
