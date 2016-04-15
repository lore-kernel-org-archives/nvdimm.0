Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm0-x244.google.com (mail-wm0-x244.google.com
 [IPv6:2a00:1450:400c:c09::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5B9C21A2087
 for <linux-nvdimm@lists.01.org>; Thu, 14 Apr 2016 23:13:23 -0700 (PDT)
Received: by mail-wm0-x244.google.com with SMTP id l6so3217491wml.3
 for <linux-nvdimm@lists.01.org>; Thu, 14 Apr 2016 23:13:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADJHv_sawA8SXviUX6My5MKeqWMLbWLG=DrM7RCgrjkjGj2f5Q@mail.gmail.com>
References: <CADJHv_sawA8SXviUX6My5MKeqWMLbWLG=DrM7RCgrjkjGj2f5Q@mail.gmail.com>
Date: Fri, 15 Apr 2016 14:13:21 +0800
Message-ID: <CADJHv_uddEvHe0PfYnJPsyUUO=Ud5CdBNeqQOz4aB8_1cMJw2A@mail.gmail.com>
Subject: Re: binary execution from DAX mount hang since next-20160407
From: Xiong Zhou <jencce.kernel@gmail.com>
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
To: Hugh Dickins <hughd@google.com>, Linux-Next <linux-next@vger.kernel.org>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

# cat /proc/cmdline
BOOT_IMAGE=/vmlinuz-4.6.0-rc3-next-20160414+
root=/dev/mapper/xxxxx--01-root ro crashkernel=auto
rd.lvm.lv=xxxxx-01/root rd.lvm.lv=xxxxxx/swap console=ttyS1,115200n81
memmap=10G!5G memmap=15G!15G selinux=0 LANG=en_US.UTF-8

# mkfs.ext4 -V
mke2fs 1.43-WIP (15-Mar-2016)
Using EXT2FS Library version 1.43-WIP

# mkfs.xfs -V
mkfs.xfs version 4.5.0


....
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
