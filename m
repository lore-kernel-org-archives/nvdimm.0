Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C6014AD0D
	for <nvdimm@lists.linux.dev>; Thu, 23 May 2024 13:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716472643; cv=none; b=VvRCa2Lyar7I379iMXFxLcX/wES/GfWXuIkiWKn2s/5fWN0gO+E/UXWkbgsfKhqnYe7K7ldzodzwsCVw7tdaVL8OoRfjx7ngSOT/dHFovmr9Hadco8uPL7/4/tJVRM37nf6l+iQux3Etf5mYw/h0E4l7fq8d1dkQxjFDFI25/Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716472643; c=relaxed/simple;
	bh=tuKuhB5jKCD9ovubFiP3ySRu6UTcL+RGfPwzZ6vpe1s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K9qwfC5NXUftzJfXAD2oudBQ3hQLDQCqIgEnBy4UL+TvSkhOhAAeIfX28MDUl89MBZSYEwSUoV4baE+AF9FRs4Q/5hc4xLqT9kOW+7u9gT0ZtOa3Wjt03hfzJuKp6N+QPsplcGBgdF7H8ZhCql9CWjF9tUeCzWv2FnszRP6kp7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=ftyecAro; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ftyecAro"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a59ad344f7dso925863966b.0
        for <nvdimm@lists.linux.dev>; Thu, 23 May 2024 06:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1716472639; x=1717077439; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tuKuhB5jKCD9ovubFiP3ySRu6UTcL+RGfPwzZ6vpe1s=;
        b=ftyecArowgB1GBP/yZncN8me9H1xYnX8xp9ls601rYTOtYpaTsaA/tqsW8RCo3A3+S
         Tvdmj5oNWMav10i97ky2mBgKcEz9lqTapDp0P9GGFrZYDgAyjLZ0Xujw2JVchlEWBYH2
         12Gm/O8OeF5O/MeUCGuxz9nXh6JzshVkeBc5g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716472639; x=1717077439;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tuKuhB5jKCD9ovubFiP3ySRu6UTcL+RGfPwzZ6vpe1s=;
        b=q2c0YmCvk1BsMGukZW3bX6uieZEnROgCJmnUpEx0h6r5yEpmCZxp1fkhI5UqVyFDiZ
         i8DmE2cxLKf/CN7Qk6Vm3KJ1Is7ytZGYKZYmchMBX1UdKkT6zQXsuDXB0a6TakvrUxB4
         G0lnhVOwWJdqAM+qNLXpw6Zg4ST36dICbGj8IEvaQAta/lkwLqWAIx/rG+sRpxbJQ9DE
         xVDwZQliWb84RfBeNZQ9poym/sjprzVGxRcRxs7IcF4KHqszjG4kloMIEEqBa0DN0zN+
         9n6qtDG1HsFayni+UnAUOR63Trw3WG0FNeNgOSH32J7NhWCnoZyfqriDE92rNNX9LEaF
         zcbg==
X-Forwarded-Encrypted: i=1; AJvYcCUGUX+dhjg4Rl/ACWtZqPp1uJh10zdVaiFPiAn6dZbX65J+KI473CD6yXDkJZjoGLul+sjcGHclMWaoDi8HZ4Aalhy0AsNd
X-Gm-Message-State: AOJu0Yz8921MpiVjz4p5bNr2ykb2R5uvjbSNNLCuIV97bgQQG/gPOkL7
	TlTkRyMMo7y1ysu1/eDCeMyfkSQAuehTzQqf8aFW7ZlE1SMwEgIKUcs6HxGRDAf1Ah1gGeYKOlO
	woevp9Nw33GUqRGRR7auh2kJqQM4eSeqG/Q0QjA==
X-Google-Smtp-Source: AGHT+IGwv/ScwkgRjHdhiQCyyMyxcHqcpFc8OI2A5ZkS8UBdb6YncY2x/XHvnylSUc6CgnNomJmj0gUZnl/IESJ46A4=
X-Received: by 2002:a17:906:b202:b0:a59:c23d:85d2 with SMTP id
 a640c23a62f3a-a622814319bmr302308266b.55.1716472639470; Thu, 23 May 2024
 06:57:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1708709155.git.john@groves.net> <CAOQ4uxiPc5ciD_zm3jp5sVQaP4ndb40mApw5hx2DL+8BZNd==A@mail.gmail.com>
 <CAJfpegv8XzFvty_x00UehUQxw9ai8BytvGNXE8SL03zfsTN6ag@mail.gmail.com>
 <CAOQ4uxg9WyQ_Ayh7Za_PJ2u_h-ncVUafm5NZqT_dt4oHBMkFQg@mail.gmail.com>
 <kejfka5wyedm76eofoziluzl7pq3prys2utvespsiqzs3uxgom@66z2vs4pe22v>
 <CAJfpegvQefgKOKMWC8qGTDAY=qRmxPvWkg2QKzNUiag1+q5L+Q@mail.gmail.com> <l2zbsuyxzwcozrozzk2ywem7beafmidzp545knnrnkxlqxd73u@itmqyy4ao43i>
In-Reply-To: <l2zbsuyxzwcozrozzk2ywem7beafmidzp545knnrnkxlqxd73u@itmqyy4ao43i>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 23 May 2024 15:57:07 +0200
Message-ID: <CAJfpegsr-5MU-S4obTsu89=SazuG8zXmO6ymrjn5_BLofSRXdg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/20] Introduce the famfs shared-memory file system
To: John Groves <John@groves.net>
Cc: linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

[trimming CC list]

On Thu, 23 May 2024 at 04:49, John Groves <John@groves.net> wrote:

> - memmap=<size>!<hpa_offset> will reserve a pretend pmem device at <hpa_offset>
> - memmap=<size>$<hpa_offset> will reserve a pretend dax device at <hpa_offset>

Doesn't get me a /dev/dax or /dev/pmem

Complete qemu command line:

qemu-kvm -s -serial none -parallel none -kernel
/home/mszeredi/git/linux/arch/x86/boot/bzImage -drive
format=raw,file=/home/mszeredi/root_fs,index=0,if=virtio -drive
format=raw,file=/home/mszeredi/images/ubd1,index=1,if=virtio -chardev
stdio,id=virtiocon0,signal=off -device virtio-serial -device
virtconsole,chardev=virtiocon0 -cpu host -m 8G -net user -net
nic,model=virtio -fsdev local,security_model=none,id=fsdev0,path=/home
-device virtio-9p-pci,fsdev=fsdev0,mount_tag=hostshare -device
virtio-rng-pci -smp 4 -append 'root=/dev/vda console=hvc0
memmap=4G$4G'

root@kvm:~/famfs# scripts/chk_efi.sh
This system is neither Ubuntu nor Fedora. It is identified as debian.
/sys/firmware/efi not found; probably not efi
 not found; probably nof efi
/boot/efi/EFI not found; probably not efi
/boot/efi/EFI/BOOT not found; probably not efi
/boot/efi/EFI/ not found; probably not efi
/boot/efi/EFI//grub.cfg not found; probably nof efi
Probably not efi; errs=6

Thanks,
Miklos
