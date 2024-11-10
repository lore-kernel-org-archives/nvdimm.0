Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E3D152E0C
	for <nvdimm@lists.linux.dev>; Sun, 10 Nov 2024 10:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731236105; cv=none; b=gQz+V4Psq7ygVnqaiiCDiS1+fHWaGgwQSRMtq19O5LEQfqPF04PiVanalwW2xL7VpZa6S/S0crV78kEjhM/MqDbNAMKCZOeid5h2B5MoNF5vD/GdSHcoiZjQ6Cs6Cnhes0Ffeiy3CcJUJAVOR967q7mW8DPRslGAR+EsPkmasBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731236105; c=relaxed/simple;
	bh=qp30AENi8dcgpbgR8q8aWwhedRUsRchicjsEyep+G7E=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MJHDODE7upF/Sp+H+bCd64+znnxhQtSbK10+hr5vDy/TBQRryUx1EjeyqbKrKKMoCF4HBpDgy6x6UspX5xVMG4KIrlcfLy60nqd6gWwRQsjwy6/opet5TBu3q/WqTxqfReHiiKgBCS281JyOc8Ylcyo/CV066krcnsFi3wH4FlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-83abf68e7ffso425652939f.1
        for <nvdimm@lists.linux.dev>; Sun, 10 Nov 2024 02:55:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731236102; x=1731840902;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wkrHgi6tIDZKDVhNeZ89zrLoylCI9aMkz19AD8osQ10=;
        b=eMZxfqf9mJKCY4QH26yPMfhfSn0iPLNJKwgs+i6KsKuj1TbJr3wkWY9AQBDX8qgUIv
         /1n4sb0i5jOZW7m+BMivrGWTaugPBXbxP2BYITSuJ2EqTcTFWrnRoCEihjoSEJlczljZ
         Kk8Vo4ao0epwjoX5xvjndeBqkiaP3g0zXBVIVptH5wxfTw5h79cMrXe0QABHhFRe08tZ
         paVn7wY1B1sEKUTHHxBCTxG3Z4DCaEeIZcGCxUjMauQLd5/REv+sSDdk9cEcpYE7U5+d
         XQ5jfVXjgph0Y6cbT09lggxGmtVFmeGj2/53PUAB/5iAH8WjePfYJeEuMNXXf6qUEevT
         dXqA==
X-Forwarded-Encrypted: i=1; AJvYcCW5HaVICfxD95Krt11PSQePhF0H25dMhKKBo1w8nttBTUKUMQoA117bLJu0aO+TDRh5u8zb2jI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzp1BCg+0qmccfFMXZOAn4e7LPl7gJ2/J0qYYd15FeeUB2pODZn
	NRhpJgxDbHnp3wJQ4A7v+sRV7b7cNQZZXPX4LtUUUE9SSAY3KLjld75YbDS4/WriW1D8to5TJAI
	Qc3An1B6fkXirqEsj3CbvjX9zHlEvWLI2e2iw/Y+lTvBLO0moSt/+4m4=
X-Google-Smtp-Source: AGHT+IFAs92Gwb0aXQftJab7U5XVyZHIVCEeOqd1umax+/Rh6VlSO2sxjsRp1vnO1AhdxCcikj3wrFudLW+Sqm7j3Nry1ZTmiWeN
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a43:b0:3a6:b258:fcd with SMTP id
 e9e14a558f8ab-3a6f19a01c1mr98799655ab.1.1731236102561; Sun, 10 Nov 2024
 02:55:02 -0800 (PST)
Date: Sun, 10 Nov 2024 02:55:02 -0800
In-Reply-To: <CAHiZj8ieKPXqLKx4oO6Vhb0QPU+8hF9B-gaQ=Xinawrqv86==w@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67309106.050a0220.320e73.0322.GAE@google.com>
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

commit:         de2f378f Merge tag 'nfsd-6.12-4' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=102594e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64aa0d9945bd5c1
dashboard link: https://syzkaller.appspot.com/bug?extid=7534f060ebda6b8b51b3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11629ea7980000

Note: testing is done by a robot and is best-effort only.
