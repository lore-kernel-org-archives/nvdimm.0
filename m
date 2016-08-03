Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DCAFF1A1E1B
 for <linux-nvdimm@lists.01.org>; Tue,  2 Aug 2016 17:59:31 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id j185so260449566oih.0
 for <linux-nvdimm@lists.01.org>; Tue, 02 Aug 2016 17:59:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160803003354.GP16044@dastard>
References: <20160803003354.GP16044@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Aug 2016 17:59:30 -0700
Message-ID: <CAPcyv4gmMwBpbCj+U3gzeTAi3bgMXz-Va=8gP_9Jf9D=9O8Hgg@mail.gmail.com>
Subject: Re: [4.8 hang] xfstests generic/361 hangs on dax enabled filesystems
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 2, 2016 at 5:33 PM, Dave Chinner <david@fromorbit.com> wrote:
> Hi folks,
>
> Just hit a reproducable hang in generic/361. Essentially this on
> a 8GB pmem device:
>
> mkfs.xfs -f /dev/pmem1
> mount -o dax /dev/pmem1 /mnt/scratch
> xfs_io -f -c "truncate 1g" test.img
> losetup -f --show /mnt/scratch/test.img
> mkfs.xfs -f /dev/loop0
>
> And the mkfs.xfs command hangs with a discard that never completes:
>
> [  243.413918] INFO: task mkfs.xfs:5708 blocked for more than 120 seconds.
> [  243.415678]       Not tainted 4.7.0-dgc+ #862
> [  243.416772] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  243.418769] mkfs.xfs        D ffff880835143c18 13848  5708   5441 0x00000000
> [  243.420620]  ffff880835143c18 ffff880835143c20 ffff88083a244780 ffff8808358ba3c0
> [  243.422636]  ffff88023aa20000 ffff880835144000 7fffffffffffffff 7fffffffffffffff
> [  243.424586]  ffff8808358ba3c0 00000000024000c0 ffff880835143c30 ffffffff81e5e38c
> [  243.426466] Call Trace:
> [  243.427050]  [<ffffffff81e5e38c>] schedule+0x3c/0x90
> [  243.428224]  [<ffffffff81e62be5>] schedule_timeout+0x265/0x330
> [  243.429563]  [<ffffffff8109f125>] ? kvm_clock_read+0x25/0x40
> [  243.430896]  [<ffffffff8109f149>] ? kvm_clock_get_cycles+0x9/0x10
> [  243.432360]  [<ffffffff81125edc>] ? ktime_get+0x3c/0xb0
> [  243.433556]  [<ffffffff81e5db54>] io_schedule_timeout+0xa4/0x110
> [  243.434932]  [<ffffffff81e5eed6>] wait_for_completion_io+0xd6/0x110
> [  243.436297]  [<ffffffff810decd0>] ? wake_up_q+0x70/0x70
> [  243.437436]  [<ffffffff817d6f06>] submit_bio_wait+0x56/0x70
> [  243.438671]  [<ffffffff817e851a>] blkdev_issue_discard+0x6a/0xb0
> [  243.439980]  [<ffffffff810dab69>] ? __might_sleep+0x49/0x80
> [  243.441182]  [<ffffffff817eea87>] blk_ioctl_discard+0x97/0xb0
> [  243.442370]  [<ffffffff817ef7bb>] blkdev_ioctl+0x7eb/0x9a0
> [  243.443485]  [<ffffffff81236a1d>] block_ioctl+0x3d/0x50
> [  243.444552]  [<ffffffff812100df>] do_vfs_ioctl+0x8f/0x670
> [  243.445630]  [<ffffffff81002434>] ? exit_to_usermode_loop+0x94/0xb0
> [  243.446902]  [<ffffffff81210739>] SyS_ioctl+0x79/0x90
> [  243.447927]  [<ffffffff81002bc5>] ? syscall_return_slowpath+0xf5/0x190
> [  243.449236]  [<ffffffff81e63d32>] entry_SYSCALL_64_fastpath+0x1a/0xa4
>
> This only reproduces when the underlying filesystem is mounted with
> -o dax, so there is a bad interaction with loop devices and DAX
> occurring somewhere. generic/361 is a recent test (committed june 14)
> so this probably hasn't actually been tested until now.
>
> I haven't got time to look at this right now, hence the report.
>

Thanks Dave, we'll take a look.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
