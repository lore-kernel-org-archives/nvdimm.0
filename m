Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ZXSHCAS02.zhaoxin.com (unknown [180.169.121.82])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C814D1A2121
 for <linux-nvdimm@lists.01.org>; Wed, 13 Apr 2016 06:45:38 -0700 (PDT)
From: Eric Shang <EricShang@zhaoxin.com>
Subject: ext4 error 
Date: Wed, 13 Apr 2016 13:44:55 +0000
Message-ID: <0255994B402DE243B1DFC1057A00655201AC6F@ZXSHMBX02.zhaoxin.com>
Content-Language: zh-CN
MIME-Version: 1.0
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
To: Matthew Wilcox <willy@linux.intel.com>, Toshi Kani <toshi.kani@hpe.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "david@fromorbit.com" <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "tytso@mit.edu" <tytso@mit.edu>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

HI All:
  I meet an ext4 error, following is the error log. After panic, I check the emmc by the tool debufs, the inode 69878 i_nlink is not zero. And this inode don't belong to parent dir 6987, it belong to other file(this inode belong to two files when check by debugfs ncheck), I guess than this inode has beed deleted in memory and already used by other file. But the parent dentry buff_head not flush to emmc. But when lookup this dentry can't find it' in dentry cache, and then lookup_real, read the dentry from emmc, get the file inode which already be deleted. 
  Can any give me some help how to check this issue. My kernel version is 3.18 form Android . I thinks something wrong with dentry cache flush and dirty buff_head flush to emmc. Thanks all!

:Sending Trackball (ACTION_MOVE): 0:(-[44802.841647] EXT4-fs error (device mmcblk0p16): ext4_lookup:1417: inode #69877: comm installd: deleted inode referenced: 69878
5.0[44802.853210] Aborting journal on device mmcblk0p16-8.
,2.[44802.858345] Kernel panic - not syncing: EXT4-fs (device mmcblk0p16): panic forced after error
[44802.858345] 
[44802.868322] CPU: 1 PID: 216 Comm: installd Tainted: P           O   3.18.0-94.02.04 #1
[44802.876223] [<c0016874>] (unwind_backtrace) from [<c00123e8>] (show_stack+0x10/0x14)
[44802.883927] [<c00123e8>] (show_stack) from [<c07af1b0>] (dump_stack+0x70/0xbc)
[44802.891117] [<c07af1b0>] (dump_stack) from [<c07ab328>] (panic+0xa4/0x218)
[44802.897965] [<c07ab328>] (panic) from [<c01c2fa4>] (ext4_handle_error+0x6c/0xa8)
[44802.905330] [<c01c2fa4>] (ext4_handle_error) from [<c01c323c>] (__ext4_error_inode+0x6c/0x114)
[44802.913909] [<c01c323c>] (__ext4_error_inode) from [<c01b2e18>] (ext4_lookup+0xf0/0x148)
[44802.921970] [<c01b2e18>] (ext4_lookup) from [<c0130148>] (lookup_real+0x20/0x50)
[44802.929336] [<c0130148>] (lookup_real) from [<c0130c60>] (__lookup_hash+0x34/0x44)
[44802.936873] [<c0130c60>] (__lookup_hash) from [<c0131f98>] (lookup_slow+0x38/0x9c)
[44802.944414] [<c0131f98>] (lookup_slow) from [<c0132a34>] (path_lookupat+0x228/0x728)
[44802.952127] [<c0132a34>] (path_lookupat) from [<c0132f54>] (filename_lookup+0x20/0xbc)
[44802.960013] [<c0132f54>] (filename_lookup) from [<c0136128>] (user_path_at_empty+0x50/0x78)
[44802.968334] [<c0136128>] (user_path_at_empty) from [<c0136164>] (user_path_at+0x14/0x1c)
[44802.976394] [<c0136164>] (user_path_at) from [<c012c52c>] (vfs_fstatat+0x48/0x8c)
[44802.983847] [<c012c52c>] (vfs_fstatat) from [<c012c820>] (SyS_fstatat64+0x14/0x30)
[44802.991389] [<c012c820>] (SyS_fstatat64) from [<c000eae0>] (ret_fast_syscall+0x0/0x48)

Best Regards
EricShang	
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
