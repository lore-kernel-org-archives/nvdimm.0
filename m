From: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] Support DAX for device-mapper dm-linear devices
Date: Mon, 20 Jun 2016 15:52:17 -0400
Message-ID: <20160620195217.GB21657@redhat.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
 <20160613225756.GA18417@redhat.com>
 <20160620180043.GA21261@redhat.com>
 <1466446861.3504.243.camel@hpe.com>
 <20160620194026.GA21657@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160620194026.GA21657-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Mon, Jun 20 2016 at  3:40pm -0400,
Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
 
> # dd if=/dev/zero of=/mnt/dax/meh bs=1024K oflag=direct
> [11729.754671] XFS (dm-4): Metadata corruption detected at xfs_agf_read_verify+0x70/0x120 [xfs], xfs_agf block 0x45a808
> [11729.766423] XFS (dm-4): Unmount and run xfs_repair
> [11729.771774] XFS (dm-4): First 64 bytes of corrupted metadata buffer:
> [11729.778869] ffff8800b8038000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [11729.788582] ffff8800b8038010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [11729.798293] ffff8800b8038020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [11729.808002] ffff8800b8038030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> [11729.817715] XFS (dm-4): metadata I/O error: block 0x45a808 ("xfs_trans_read_buf_map") error 117 numblks 8
> 
> When this XFS corruption occurs corruption then also manifests in lvm2's
> metadata:
> 
> # vgremove pmem
> Do you really want to remove volume group "pmem" containing 1 logical volumes? [y/n]: y
> Do you really want to remove active logical volume lv? [y/n]: y
>   Incorrect metadata area header checksum on /dev/pmem0p1 at offset 4096
>   WARNING: Failed to write an MDA of VG pmem.
>   Incorrect metadata area header checksum on /dev/pmem0p2 at offset 4096
>   WARNING: Failed to write an MDA of VG pmem.
>   Failed to write VG pmem.
>   Incorrect metadata area header checksum on /dev/pmem0p2 at offset 4096
>   Incorrect metadata area header checksum on /dev/pmem0p1 at offset 4096
> 
> If I don't use XFS, and only issue IO directly to the /dev/pmem/lv, I
> don't see this corruption.

I did the same test with ext4 instead of xfs and it resulted in the same
type of systemic corruption (lvm2 metadata corrupted too):

[12816.407147] EXT4-fs (dm-4): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
[12816.416123] EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: dax
[12816.766855] EXT4-fs error (device dm-4): ext4_mb_generate_buddy:758: group 9, block bitmap and bg descriptor inconsistent: 32768 vs 32395 free clusters
[12816.782016] EXT4-fs error (device dm-4): ext4_mb_generate_buddy:758: group 10, block bitmap and bg descriptor inconsistent: 32768 vs 16384 free clusters
[12816.797491] JBD2: Spotted dirty metadata buffer (dev = dm-4, blocknr = 0). There's a risk of filesystem corruption in case of system crash.

# vgremove pmem
Do you really want to remove volume group "pmem" containing 1 logical volumes? [y/n]: y
Do you really want to remove active logical volume lv? [y/n]: y
  Incorrect metadata area header checksum on /dev/pmem0p1 at offset 4096
  WARNING: Failed to write an MDA of VG pmem.
  Incorrect metadata area header checksum on /dev/pmem0p2 at offset 4096
  WARNING: Failed to write an MDA of VG pmem.
  Failed to write VG pmem.
  Incorrect metadata area header checksum on /dev/pmem0p2 at offset 4096
  Incorrect metadata area header checksum on /dev/pmem0p1 at offset 4096
