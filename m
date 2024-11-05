Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7301D5AD7
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730820507; cv=none; b=CuoZnfRQFFBjNJeo0Mcj5QVTR9k3iBbxL4BCqvVOUuVkQ/Qw+tW+FZ6sLN5Dwyrvp+vwBkZOfJJEQR9dbM4f27JdsSHPBVZdc39fWKBt2kj+M0GFz0P+vcZBL/Z0rbrfoBJfP6oZ+TyUYx587PRCq+YJcx81gjtDGhYpPwY2D+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730820507; c=relaxed/simple;
	bh=Umw7hHA8NJTxEHzeXs3EOA1ZOePD3R18UEvNQTEolbE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JNnLs5HEgOw7pjzEE9WzsG1xLa6EIL5Q+HD5H0M2u3GmzXnFg0CUKcDL8KoWxn5yBqu79pRmGUzBUbesqQHhM+1zKpob3/u71sgK4FFYP01J8E2A8tgNbUooiUJVDuZLiL+v9TCZbmmB9ROn97fWip8vvIpelWY6q0kT3kVo1WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3c4554d29so58746055ab.1
        for <nvdimm@lists.linux.dev>; Tue, 05 Nov 2024 07:28:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730820505; x=1731425305;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZIKcuIWij1X8qx5ncDl/9Nkjue6MvSRLjlDnhaH0nBI=;
        b=aEdwsnEvLFFuoK6FeveLLaH4MYvT9/EuHoPDykdOsvMz5gfmTIMiqx/sUYWhXfEVGq
         Bv8aF0gNGR/7IOUmQ/hJA6722iDHz+Q2fulnUW0IV/Mqf6YquJxGllfl9EYupH44mkaK
         IqlR7GET97yYZT2Q2uoTZyTAZmJMLkeId7jQxLKvymdtR9ybJd7/7pcF6leRGjkqAfFN
         vnM6JrU0TOjUmPE8QbZjrWaBAucV9L4JX7IdAW5mCkRm+E/v3+e+3bTGI4lrP/XKFQur
         LHcBeL4dT8kggrHIw/d66G+F0II+xHA6j6JGL9FQR5DVCWzVQgMqOs+HnPM5/ytNzwoO
         2zUA==
X-Forwarded-Encrypted: i=1; AJvYcCUSjnupMECqPBrL6k4XOK2BNei9SRyv+R2qPhdFTHX7963zV64cNQvnUjbgFSoPdWj9NunOpDs=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYaz+bnBol9otRJyMq5mo+ZMolnu2fTGH6igKcX35+EE9ZZfuS
	FciozFeM52OTkMVaVnXyuPQDghIx2QI33jcK4z95hwTiINxcZZvxEIJvCzDq8dN/DXxIXmhrQf+
	Caz+rD9alOOFH8V3J8HuwzppqOmOoReOx+cXyCKOw8yaMR6b1d/aNrj4=
X-Google-Smtp-Source: AGHT+IFf2xLDkeIymMV//zMPJ+Qh/bFah2TWKmNKzhqPOPB5abQc7nAM5rKTtIVA89Blnq3YBaAsdpKhD1ZPv6zhQYeUMv12q6Gd
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:216e:b0:3a4:ecdb:d61d with SMTP id
 e9e14a558f8ab-3a6b02c72e1mr174793385ab.8.1730820503195; Tue, 05 Nov 2024
 07:28:23 -0800 (PST)
Date: Tue, 05 Nov 2024 07:28:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672a3997.050a0220.2a847.11f7.GAE@google.com>
Subject: [syzbot] [acpi?] [nvdimm?] KASAN: vmalloc-out-of-bounds Read in
 acpi_nfit_ctl (2)
From: syzbot <syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com>
To: dan.j.williams@intel.com, dave.jiang@intel.com, ira.weiny@intel.com, 
	lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, rafael@kernel.org, syzkaller-bugs@googlegroups.com, 
	vishal.l.verma@intel.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2e1b3cc9d7f7 Merge tag 'arm-fixes-6.12-2' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12418e30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=11254d3590b16717
dashboard link: https://syzkaller.appspot.com/bug?extid=7534f060ebda6b8b51b3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12170f40580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16418e30580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-2e1b3cc9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2f2588b04ae9/vmlinux-2e1b3cc9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2c9324cf16df/bzImage-2e1b3cc9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: vmalloc-out-of-bounds in cmd_to_func drivers/acpi/nfit/core.c:416 [inline]
BUG: KASAN: vmalloc-out-of-bounds in acpi_nfit_ctl+0x20e8/0x24a0 drivers/acpi/nfit/core.c:459
Read of size 4 at addr ffffc90000e0e038 by task syz-executor229/5316

CPU: 0 UID: 0 PID: 5316 Comm: syz-executor229 Not tainted 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 cmd_to_func drivers/acpi/nfit/core.c:416 [inline]
 acpi_nfit_ctl+0x20e8/0x24a0 drivers/acpi/nfit/core.c:459
 __nd_ioctl drivers/nvdimm/bus.c:1186 [inline]
 nd_ioctl+0x1844/0x1fd0 drivers/nvdimm/bus.c:1264
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb399ccda79
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 c1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcf6cb8d88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb399ccda79
RDX: 0000000020000180 RSI: 00000000c008640a RDI: 0000000000000003
RBP: 00007fb399d405f0 R08: 0000000000000006 R09: 0000000000000006
R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000000001
R13: 431bde82d7b634db R14: 0000000000000001 R15: 0000000000000001
 </TASK>

The buggy address belongs to the virtual mapping at
 [ffffc90000e0e000, ffffc90000e10000) created by:
 __nd_ioctl drivers/nvdimm/bus.c:1169 [inline]
 nd_ioctl+0x1594/0x1fd0 drivers/nvdimm/bus.c:1264

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880401b9a80 pfn:0x401b9
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
raw: 04fff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: ffff8880401b9a80 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2cc2(GFP_KERNEL|__GFP_HIGHMEM|__GFP_NOWARN), pid 5316, tgid 5316 (syz-executor229), ts 69039468240, free_ts 68666765389
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0x303f/0x3190 mm/page_alloc.c:3457
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4733
 alloc_pages_bulk_noprof+0x729/0xd40 mm/page_alloc.c:4681
 alloc_pages_bulk_array_mempolicy_noprof+0x8ea/0x1600 mm/mempolicy.c:2556
 vm_area_alloc_pages mm/vmalloc.c:3542 [inline]
 __vmalloc_area_node mm/vmalloc.c:3646 [inline]
 __vmalloc_node_range_noprof+0x752/0x13f0 mm/vmalloc.c:3828
 __vmalloc_node_noprof mm/vmalloc.c:3893 [inline]
 vmalloc_noprof+0x79/0x90 mm/vmalloc.c:3926
 __nd_ioctl drivers/nvdimm/bus.c:1169 [inline]
 nd_ioctl+0x1594/0x1fd0 drivers/nvdimm/bus.c:1264
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5312 tgid 5312 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_page+0xcfb/0xf20 mm/page_alloc.c:2638
 __folio_put+0x2c7/0x440 mm/swap.c:126
 pipe_buf_release include/linux/pipe_fs_i.h:219 [inline]
 pipe_update_tail fs/pipe.c:224 [inline]
 pipe_read+0x6ed/0x13e0 fs/pipe.c:344
 new_sync_read fs/read_write.c:488 [inline]
 vfs_read+0x991/0xb70 fs/read_write.c:569
 ksys_read+0x183/0x2b0 fs/read_write.c:712
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffffc90000e0df00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc90000e0df80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>ffffc90000e0e000: 00 00 00 00 00 00 00 03 f8 f8 f8 f8 f8 f8 f8 f8
                                        ^
 ffffc90000e0e080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc90000e0e100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
