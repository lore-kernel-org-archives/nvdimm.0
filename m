Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11971FF5F9
	for <nvdimm@lists.linux.dev>; Wed, 13 Nov 2024 12:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731500825; cv=none; b=kF0Et3zw99KpKspSPoPhFR8FvZ3c4gMnVyDLihh8fSDda0s7E/X0ZDt1uAVEvwT78vRyhb0o0g9aGBqPGbSLx5YIpsnCOZliYgB8Bld2Jw/ZoXR3sluwt7DH1eiJsnK9G3fTdm32oLtW/96BG8k+EBTl7/rmm+McK0oUAlw53p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731500825; c=relaxed/simple;
	bh=xiNg5znueipvPFwimPHq7hUeF96APnXAhZtTEakQbl8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Zf01N2ate7te4E9NDZumgtrYBkS5pvwp7Mh4GUKsIyiImc2CW4pxiS2uhYloybz1a+NqOTMfmRpuEWR9pOVRkPf9c6REyIP7FQS8VlAWvExJmQ/QBQ2SGTB0H8YtD0y/RY2NTUgY7LLu/p5TpNY647wJA+e/eSzckyNrwBUFvwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-83ab4cadf05so760804439f.1
        for <nvdimm@lists.linux.dev>; Wed, 13 Nov 2024 04:27:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731500823; x=1732105623;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WkcdwbKwC54ksa1xeYHfLKc13WBWF+TVFlXOuA4rNF0=;
        b=dbCgJNeqjWP82x5dCqKChJYB08gqPNCqZh3xqiPN40rtG82It24UqARvpfUP21KYls
         XwR17ImjWK+CqlA2ji6DMQSHcj+Zzv3AvoMjKRq2v1Aw4Pb1EI/+RE7qBWioHs/34AgN
         wSAqBtvCwq3oQUTJ/ZTrCBAPRgP+PtuW6bjm2qXcArfVi4RtLyFh5VBUYCHnJNnbar6Q
         k4XcJuEV+8KdvVRTXYmH4FHwtNRVUX5OtvJCB4yZw4YIZRAKnybVy0a62Db6UbGIa5j9
         bCKzScv0WGHi8U2BX0E6bJms6vVo1/Ca67AP+wsfKlUjHQTxGQG83Xu6+BGduI6ZO9dz
         Bhcw==
X-Forwarded-Encrypted: i=1; AJvYcCUjInhIL3oGSROVZiF6R4tPDaQC3u3TCbMLtS6Z3nys3KNzTo0idJ8CLptT0IaRyl9xBCwlItg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy8Na4WQ/FEtZKHSgf+oI31CIoKtvjcYH5GKMvgDoQqkoHZ7Gwl
	An+9FHQaBbAk5wJ0RdUEUu4zm+nsSgq6jnxrynSWH+/C7lsskwps/lTVRhaYEwefRT58zHSDXVl
	PyBOC5Nc0yr5Ujrhd/h0Hkg28bJMBgK8BYMqG/7cfIsaS8Vf8eBNvcnw=
X-Google-Smtp-Source: AGHT+IH3YeeJ2wjRzyTxUBU/Fz7blpElgbrjvFEVwsIv4HlOM4uInB40FGzuJCij+kZxQsisXAtEUePo4IU5xrL3FSdx7sDQuG9E
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6e:b0:3a3:b5ba:bfba with SMTP id
 e9e14a558f8ab-3a6f1a6440dmr210634735ab.15.1731500822810; Wed, 13 Nov 2024
 04:27:02 -0800 (PST)
Date: Wed, 13 Nov 2024 04:27:02 -0800
In-Reply-To: <CAHiZj8j+=3paytYbPMDqof6cVYxSFjjaev1PTc0EUsNz8hXExg@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67349b16.050a0220.2a2fcc.000c.GAE@google.com>
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

commit:         f1b785f4 Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17ca8df7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aeec8c0b2e420c
dashboard link: https://syzkaller.appspot.com/bug?extid=7534f060ebda6b8b51b3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=11d20b5f980000

Note: testing is done by a robot and is best-effort only.
