Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 26 May 2015 15:31:47 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [Linux-nvdimm] [GIT PULL] PMEM driver for v4.1
Message-ID: <20150526193147.GF2729@linux.intel.com>
References: <20150413093309.GA30219@gmail.com>
 <20150525181654.GE2729@linux.intel.com>
 <556431C5.2030704@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <556431C5.2030704@plexistor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 26, 2015 at 11:41:41AM +0300, Boaz Harrosh wrote:
> I would please like to help. What is the breakage you
> see with DAX.
> 
> I'm routinely testing with DAX so it is a surprise,
> Though I'm testing with my version with pages and
> __copy_from_user_nocache, and so on.
> Or I might have missed it. What test are you failing?

generic/019 fails in several fun ways.

The first way, which I fixed yesterday, is that the test was using
the wrong way to find the 'make-it-fail' switch for the block device.
That's now in xfstests.  The messages from xfstests were unnecessarily
worrying; they were complaining about an inconsistent filesystem, which
might be expected as the test had failed to abort cleanly and left a
couple of tasks actively writing to the filesystem.

(I hadn't seen the problem before because I was using two devices pmem0
and pmem1; with the new pmem driver, I got one device and partitioned
it instead.  The problem only occurs when using partitions, not when
using entire devices).

The second way is that we hit two BUG/WARN messages.  The first (which
we hit simultaneously on three CPUs in this run!) is:
WARNING: CPU: 7 PID: 2922 at fs/buffer.c:1143 mark_buffer_dirty+0x19e/0x270()

The stack trace probably isn't useful, and anyway it's horribly corrupted
due to triggering the stack trace simultaneously on three CPUs.

The second one we hit was this one:

 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 2930 at fs/block_dev.c:56 __blkdev_put+0xc5/0x210()
 Modules linked in: ext4 crc16 jbd2 pmem binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc snd_hda_codec_hdmi iTCO_wdt iTCO_vendor_support evdev x86_pkg_temp_thermal coretemp kvm_intel kvm crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd psmouse serio_raw pcspkr i2c_i801 snd_hda_codec_realtek snd_hda_codec_generic lpc_ich mfd_core mei_me mei i915 snd_hda_intel i2c_algo_bit snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_hda_core loop video drm_kms_helper fuse snd_timer snd drm soundcore button processor parport_pc ppdev lp parport sg sd_mod ehci_pci ehci_hcd ahci libahci crc32c_intel libata fan scsi_mod xhci_pci nvme xhci_hcd e1000e ptp pps_core usbcore usb_common thermal thermal_sys
 CPU: 0 PID: 2930 Comm: umount Tainted: G        W       4.1.0-rc4+ #10
 Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Q87M-D2H, BIOS F6 08/03/2013
  ffffffff81a04063 ffff8800a58e3d98 ffffffff81653644 0000000000000000
  0000000000000000 ffff8800a58e3dd8 ffffffff81081fea 0000000000000000
  ffff880236580880 ffff880236580ae8 ffff880236580a60 ffff880236580898
 Call Trace:
  [<ffffffff81653644>] dump_stack+0x4c/0x65
  [<ffffffff81081fea>] warn_slowpath_common+0x8a/0xc0
  [<ffffffff810820da>] warn_slowpath_null+0x1a/0x20
  [<ffffffff81260475>] __blkdev_put+0xc5/0x210
  [<ffffffff81260f72>] blkdev_put+0x52/0x180
  [<ffffffff8121e631>] kill_block_super+0x41/0x80
  [<ffffffff8121ea94>] deactivate_locked_super+0x44/0x80
  [<ffffffff8121ef0c>] deactivate_super+0x6c/0x80
  [<ffffffff81242133>] cleanup_mnt+0x43/0xa0
  [<ffffffff812421e2>] __cleanup_mnt+0x12/0x20
  [<ffffffff810a7104>] task_work_run+0xc4/0xf0
  [<ffffffff8101bdd9>] do_notify_resume+0x59/0x80
  [<ffffffff8165cd66>] int_signal+0x12/0x17
 ---[ end trace 73da47765ccceacf ]---

I suspect these are generic ext4 problems that will occur without DAX.
DAX just makes them more likely to occur since only metadata I/O now
goes through the 'likely to fail' path.

Are you skipping generic/019 or just not seeing these failures?
