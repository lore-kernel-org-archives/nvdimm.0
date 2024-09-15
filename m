Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21074414
	for <nvdimm@lists.linux.dev>; Sun, 15 Sep 2024 02:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726369107; cv=none; b=HcW7McSHd5uD+PeYq9cv2JXXdSrO1Ql1FpTz8ZHoD+/H3uLBArKGlurgJqOD7/md7I2gOFSbtBRiLQpqLNqLX1fgO4MWsvLyAImMY/CBolz28M6LAKwx6y+3G3ye28Gz3Bv+/Z3aKEes3z1U7mi30j/AyOzLpmOdoPKM3RtAlck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726369107; c=relaxed/simple;
	bh=z+UqE0U/RSUElanrubdF3dIn6xXTrATxDHndfWc1KTA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=MD1w0b6vfWNgBTsfUNtqVjPYuXoJ9rRbwJK1/B+ApyQxk4erjdwDGoaPS/5g0lePLJP5O1gCcRQAp3DgWY3zQXuHtcvHCSUqkT+NMInBMPrWKhwH+EN/VNZShWHqmFMZAd3T9TvZnu1RoFtG/Ngq/FBXDiMVJDfrhfKpz3k9IDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-39f510b3f81so84563805ab.0
        for <nvdimm@lists.linux.dev>; Sat, 14 Sep 2024 19:58:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726369105; x=1726973905;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hjLUsKGeoVoPKJ3al0/Nz3RmDdv0R6NiXx4KuJWRwHc=;
        b=Usp/yTta76FU5zoQ2npR+xNxW9metvMei0AKrlpnjrTJTc3Uant2YWkcep3aFMd6c+
         pJhYzVygwr64K7vfrZo0eufMEGCd/KpVBKCuZosfp2kncXQv44oRvV6UIP4xn8xJVZjL
         WvsBgE/LDPw2rldaIYUwkxNxeb0NpV7hljzlbDiAyPxFXYxz3Fn6dJFOtz2hRsi4RvV4
         e2UX7hNWcRGsnLyponB5iXdrSknm1Qf+hbsG1sPhYiooJP3Cf1zXg7+ab28K0q2HvUuo
         JSSw1B9AVc4hyikG2TQhxUp4UDXzmDLYyZrh3/ht81H0k0ZHZgBqRQXWAl8U8Y/56PNr
         s7Rw==
X-Forwarded-Encrypted: i=1; AJvYcCUOkXviYNh12iv0xKYZ8G6JhfrVx6I7H/abXCo3TPCAmA2EE8Wugzq0nK44vq5jrIU0CzDEO8c=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCQoTj1d9hyr9Ic+aGwVi0ZuXq6DoC+Tvx30K8wSef6BPaku7V
	LM4PH8UEQivkwBVOXNt2qS3Lc061+5m6Pyy/nmVC6PV6wMoHnXSXP5op7G+fKw58906HTVVzMdK
	9/M8ImxUPxWGFnjdzjYDsmYRb0ZFApjHgKpREywejytTQZPpWugW6iXc=
X-Google-Smtp-Source: AGHT+IESevztk4HmfitvDcTuYMhISYTTN0df7RIpThqtZPTssyZEyA3esCJB2Wm5A9txuzZtra60G1M7IJe02e6OwMyuB5UPqmPD
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:505:b0:3a0:9c04:8047 with SMTP id
 e9e14a558f8ab-3a09c048195mr14619655ab.6.1726369104872; Sat, 14 Sep 2024
 19:58:24 -0700 (PDT)
Date: Sat, 14 Sep 2024 19:58:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003f5a0c06221fa127@google.com>
Subject: [syzbot] [acpi?] [nvdimm?] WARNING in to_nfit_bus_uuid
From: syzbot <syzbot+c80d8dc0d9fa81a3cd8c@syzkaller.appspotmail.com>
To: dan.j.williams@intel.com, dave.jiang@intel.com, ira.weiny@intel.com, 
	lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, rafael@kernel.org, syzkaller-bugs@googlegroups.com, 
	vishal.l.verma@intel.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8d8d276ba2fb Merge tag 'trace-v6.11-rc6' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17987f29980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61d235cb8d15001c
dashboard link: https://syzkaller.appspot.com/bug?extid=c80d8dc0d9fa81a3cd8c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10be6797980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13386100580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-8d8d276b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d23708af23a4/vmlinux-8d8d276b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1aed2837c105/bzImage-8d8d276b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c80d8dc0d9fa81a3cd8c@syzkaller.appspotmail.com

------------[ cut here ]------------
only secondary bus families can be translated
WARNING: CPU: 0 PID: 15821 at drivers/acpi/nfit/core.c:80 to_nfit_bus_uuid+0x6f/0x90 drivers/acpi/nfit/core.c:79
Modules linked in:
CPU: 0 UID: 0 PID: 15821 Comm: syz-executor579 Not tainted 6.11.0-rc7-syzkaller-00020-g8d8d276ba2fb #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:to_nfit_bus_uuid+0x6f/0x90 drivers/acpi/nfit/core.c:79
Code: 01 75 0d e8 23 74 76 fc 31 c0 5b c3 cc cc cc cc e8 16 74 76 fc c6 05 4d 34 e5 0a 01 90 48 c7 c7 40 92 6a 8c e8 32 98 38 fc 90 <0f> 0b 90 90 eb d8 e8 f6 73 76 fc 48 c7 c7 40 9d 0e 8f 48 89 de e8
RSP: 0018:ffffc9000b6cfa90 EFLAGS: 00010246
RAX: 48f74db0fdd0b300 RBX: 0000000000000000 RCX: ffff88801e0e8000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc9000b6cfc90 R08: ffffffff8155b372 R09: 1ffff11003fc519a
R10: dffffc0000000000 R11: ffffed1003fc519b R12: ffff88801df22000
R13: 000000000000000a R14: ffffc9000b6cfc20 R15: 1ffff920016d9f6c
FS:  00007fb39f5416c0(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb39f546d30 CR3: 00000000377e2000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 acpi_nfit_ctl+0x8a9/0x24a0 drivers/acpi/nfit/core.c:489
 __nd_ioctl drivers/nvdimm/bus.c:1186 [inline]
 nd_ioctl+0x184d/0x1fe0 drivers/nvdimm/bus.c:1264
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb39f590b29
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 a1 1d 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb39f541228 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fb39f590b29
RDX: 0000000020000180 RSI: 00000000c008640a RDI: 0000000000000003
RBP: 00007fb39f6143c8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb39f6143c0
R13: 63646e2f7665642f R14: 00007ffd8b32c140 R15: 00007ffd8b32c228
 </TASK>


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
