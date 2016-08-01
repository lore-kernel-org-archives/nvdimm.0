Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x22c.google.com (mail-io0-x22c.google.com
 [IPv6:2607:f8b0:4001:c06::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E79601A1E27
 for <linux-nvdimm@lists.01.org>; Mon,  1 Aug 2016 07:44:53 -0700 (PDT)
Received: by mail-io0-x22c.google.com with SMTP id 38so184988321iol.0
 for <linux-nvdimm@lists.01.org>; Mon, 01 Aug 2016 07:44:53 -0700 (PDT)
Subject: Re: [PATCH] block: fix bdi vs gendisk lifetime mismatch
References: <146998891350.29275.1589003488607819550.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6dcd18c9-94db-6d4f-32a0-1e8909252ed0@kernel.dk>
Date: Mon, 1 Aug 2016 08:44:47 -0600
MIME-Version: 1.0
In-Reply-To: <146998891350.29275.1589003488607819550.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, axboe@fb.com
Cc: linux-block@vger.kernel.org, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 07/31/2016 12:15 PM, Dan Williams wrote:
> The name for a bdi of a gendisk is derived from the gendisk's devt.
> However, since the gendisk is destroyed before the bdi it leaves a
> window where a new gendisk could dynamically reuse the same devt while a
> bdi with the same name is still live.  Arrange for the bdi to hold a
> reference against its "owner" disk device while it is registered.
> Otherwise we can hit sysfs duplicate name collisions like the following:
>
>  WARNING: CPU: 10 PID: 2078 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x64/0x80
>  sysfs: cannot create duplicate filename '/devices/virtual/bdi/259:1'
>
>  Hardware name: HP ProLiant DL580 Gen8, BIOS P79 05/06/2015
>   0000000000000286 0000000002c04ad5 ffff88006f24f970 ffffffff8134caec
>   ffff88006f24f9c0 0000000000000000 ffff88006f24f9b0 ffffffff8108c351
>   0000001f0000000c ffff88105d236000 ffff88105d1031e0 ffff8800357427f8
>  Call Trace:
>   [<ffffffff8134caec>] dump_stack+0x63/0x87
>   [<ffffffff8108c351>] __warn+0xd1/0xf0
>   [<ffffffff8108c3cf>] warn_slowpath_fmt+0x5f/0x80
>   [<ffffffff812a0d34>] sysfs_warn_dup+0x64/0x80
>   [<ffffffff812a0e1e>] sysfs_create_dir_ns+0x7e/0x90
>   [<ffffffff8134faaa>] kobject_add_internal+0xaa/0x320
>   [<ffffffff81358d4e>] ? vsnprintf+0x34e/0x4d0
>   [<ffffffff8134ff55>] kobject_add+0x75/0xd0
>   [<ffffffff816e66b2>] ? mutex_lock+0x12/0x2f
>   [<ffffffff8148b0a5>] device_add+0x125/0x610
>   [<ffffffff8148b788>] device_create_groups_vargs+0xd8/0x100
>   [<ffffffff8148b7cc>] device_create_vargs+0x1c/0x20
>   [<ffffffff811b775c>] bdi_register+0x8c/0x180
>   [<ffffffff811b7877>] bdi_register_dev+0x27/0x30
>   [<ffffffff813317f5>] add_disk+0x175/0x4a0
>
> Cc: <stable@vger.kernel.org>
> Reported-by: Yi Zhang <yizhan@redhat.com>
> Tested-by: Yi Zhang <yizhan@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Added for 4.8, thanks Dan.

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
