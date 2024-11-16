Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B96A1946B1
	for <nvdimm@lists.linux.dev>; Sat, 16 Nov 2024 10:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731753485; cv=none; b=WriQSTm6tybEzhlZmUPvJpHGWP7AxXv/IBW5ZCKT9OMFqpfHXtmevitgHsTYe9iRGK5L5mV3zrU8/SoBX7AN1R9ZtUzQmwfUAHVUUViJagleOHIS03JED/PKP3QJsr4unEAakYvsHKrmFx+4ROad0efSopQfBqbesRRHrIAKsJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731753485; c=relaxed/simple;
	bh=nnqogNynXOMA0QadwMHnOAX0FSBNZm1yoF39BZbwnJU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=cthC22mNAQbrlxT96Imu79PefFEAiHXWTf8b4mMPAFaKmMuomJ1dgem3sYLGAykakqyxK8vn4qmvrpqwgx9vF4EljltfAgyERqLtVJ3mThyrBTbdiP9jviftWGofvIJDFtGqWhv/G7cyfPj4io3CyplhQYbUGPrRIVbQV0Zni3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a6b563871eso32745975ab.1
        for <nvdimm@lists.linux.dev>; Sat, 16 Nov 2024 02:38:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731753482; x=1732358282;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OAueTxdgAoViJAt82uzda7JpmlwOQ7bg6ANECTjo1xQ=;
        b=X5I9VvcxRiIjWclvqurL3pYFgUurdrhhf2B+dpGfpi8ADPPj79HcT+PmCHBXNCJj/8
         +Ky99gHSP+S+kdVc42OJk7FMkpB22tDZl2qdLUX9w1sDOr8ISAdfno6IiaYlg6Z9mb3s
         mJrLHmd6zmr7H0CJJoP/Gf0tXyzVx0NeLNu4NnuWv5VrOOJOc0NEgj5UOIlbpnRwMWZf
         Oey2Uvh9IWThXcTD2QZFvCsriK3dDsX56f4lapMhKr7ytSE7otGcu0piROCsE0hMsVuT
         N1CLzjRUrfKBBHsxhVlCM4jVjrtSGG6RXP0bY9Wt0MTbauxffAH5ODbi5AkmtIJ3vwlx
         HLmg==
X-Forwarded-Encrypted: i=1; AJvYcCXJxhxbfWORPWhgNct2PHEJhpRXWCBQft3hyRe7qFLmDTarBIIYtl8KyZLP4lsZJIccpjZOrlg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx62cZOw+1hwaCLDdytn4SRWV7z973c72wgbw+wY1/IxkBLpeSk
	JZYNyEO/qM3J1OVjVU2+DGt3UK7lLVWIh4xOfdIebt0mFx056QLOdeKKsyXYNvsb2lg+5iXq/GW
	jcXGOgPYYOxfo+PIPU0mv8Mt2e9bX+ZiGL6Kh6Payd1s8iRmtuvpniBg=
X-Google-Smtp-Source: AGHT+IFSqWbqPsFEJebjAPbB7M739W1+clCtsyBBoGxheG+D53bEoWaGQu5RBakPUDdg7o7J/5mS77EwdkNCTo3Ay9S9BoKA0K48
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:368f:b0:3a2:7651:9846 with SMTP id
 e9e14a558f8ab-3a748023851mr61926845ab.13.1731753482730; Sat, 16 Nov 2024
 02:38:02 -0800 (PST)
Date: Sat, 16 Nov 2024 02:38:02 -0800
In-Reply-To: <CAHiZj8iv2WBFHDdamhnOg+KTNqWrmNpDxshpEX7h4QdtF0Wb_g@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6738760a.050a0220.bb738.0006.GAE@google.com>
Subject: Re: [syzbot] [acpi?] [nvdimm?] KASAN: vmalloc-out-of-bounds Read in
 acpi_nfit_ctl (2)
From: syzbot <syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com>
To: dan.j.williams@intel.com, dave.jiang@intel.com, ira.weiny@intel.com, 
	lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, rafael@kernel.org, surajsonawane0215@gmail.com, 
	syzkaller-bugs@googlegroups.com, vishal.l.verma@intel.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com
Tested-by: syzbot+7534f060ebda6b8b51b3@syzkaller.appspotmail.com

Tested on:

commit:         e8bdb3c8 Merge tag 'riscv-for-linus-6.12-rc8' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12a112c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aeec8c0b2e420c
dashboard link: https://syzkaller.appspot.com/bug?extid=7534f060ebda6b8b51b3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=109e12c0580000

Note: testing is done by a robot and is best-effort only.
