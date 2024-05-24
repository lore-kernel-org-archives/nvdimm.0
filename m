Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3876481F
	for <nvdimm@lists.linux.dev>; Fri, 24 May 2024 00:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716511633; cv=none; b=pcea1K0S/SbgX9Pgug0qfU5R2z08cqWrdcwPG7nsFu2YoemdbCGzsHWG0vRfaCl6DscNF9ESO9dBnENqV/LUINzwy45Zd3Xyu9KcArbF5x2Pe9eQX83Te7j5aH0sHLFvv1wmSApNHh9dCRRpZtT1s41wW/kAUT96DOgegdn3HmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716511633; c=relaxed/simple;
	bh=KLMnBc+W7brKUXqt0eZU0uMPzeOY+z6lS4AmDmnWoLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LG3dE2i9zPXQSmnqlfao1p6pH5Jz2HyE0pSD2WCiN0gtHYSrFHvgeiMPh50clqqNp73wEikXidFYi1tL4YLYKY6RaFFEidiRQFcaSTotLHjpEBmW4qOEBjt1+PiBw4OeIHZBEBl4qIkEMeH3P1G6tTXCRxyGtkz6UHc+eAAVOBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eApERMQj; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eApERMQj"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6f0f07746a4so4402285a34.2
        for <nvdimm@lists.linux.dev>; Thu, 23 May 2024 17:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716511630; x=1717116430; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xhHs76QOp2MGGcphbew3t/rK2bfPPoj+eZPq3AAV6vg=;
        b=eApERMQjYbjylhETmdaC3YErud0qXqtMbrEJGv35EYCjE7lHyozXZh0PwFmaPYRgj3
         0PCklPtlCNLRnaB5gh/vREleVve+XpzIQ8TM1J2Nn0PI2TDpbrR/S7rFMluBmJ/TCcXR
         ipC++Z2jweiXWgKdBXu8UQQAfoA0VMQKR5KdG6E7R80jcvb8XN25oJ+PHQtbXlvPJJyh
         vqs83hYCAtM/FkBCfk/cM86jkOPiurXUp5eCTN5XV0s0JqveeKxTjThWbyGboqha62LI
         JKj3aeCG8tFQkv5cufNoqY8bz6acmIaXAobWX+lQEnRl3TlaPqfaK4uafA7vyy+TZPA1
         kRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716511630; x=1717116430;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xhHs76QOp2MGGcphbew3t/rK2bfPPoj+eZPq3AAV6vg=;
        b=DDs8qjSioK18RgK6lpDFNHjieEvKTnHTZQQ2DrqwGmlhoh9t5rG93o5XbAYiQSQe6C
         AAZmqXqogC6ujTYYxhTCFPO0Hv9Fe4TFHzp6iWkcqc3BLBeY10A6QbUVkCYnxc333xll
         tftTP0q3z0aYr2pH8G+H+eAVzoPR+li0wRbcfMPLY5Ca/W+r5uIf08Q/etdn1Pkc5U5I
         nOraIk7Q9byO6hHxAmHjR7kPOJESQl0/PifyIap/UD56rlD9Gn7BggXZNWCD4uxfocmW
         hmJP38XEnFKZ3+lpjfN7xeQyPX0E4o+JFgmSGi7XGmL5EtH6+6ZwnN0UwJKcUk7J8QXM
         JJ2w==
X-Forwarded-Encrypted: i=1; AJvYcCV5SvyvAlhEF6q7PG3nA8W+0j+OUomgufQRflSrywDcTZaUQBJEe97I1ozq8BDuvtvHde8R/Mp8nDCOjcbBxnEumK6JASn+
X-Gm-Message-State: AOJu0YwZ7PwSmim8kRg+WDy9AE/X9VKeNKpmr+Y5a87ZqAdXZeQ+SknY
	xj9jMjdJx1GN5vjNc3IpBo5Piw2p/KIU5H7/s8hPzcCuKov4Y3qB
X-Google-Smtp-Source: AGHT+IFfirIf8OFRPb3WySkQ+KDQray5kCg1lM30f03akhL+f1lZdNnquwHvOD0fvvHmBd3Df7O8bw==
X-Received: by 2002:a05:6830:121a:b0:6f0:9b4c:9aea with SMTP id 46e09a7af769-6f8d0a99ea4mr931418a34.16.1716511630224;
        Thu, 23 May 2024 17:47:10 -0700 (PDT)
Received: from Borg-10.local (syn-070-114-203-196.res.spectrum.com. [70.114.203.196])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f8d0daf4a4sm119022a34.28.2024.05.23.17.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 17:47:09 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 23 May 2024 19:47:08 -0500
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [RFC PATCH 00/20] Introduce the famfs shared-memory file system
Message-ID: <sq6fbx5jpzkjw43wyr7zmfnvcw45ah5f4vtz6wtanjai3t4cvk@awxlk72xzzkm>
References: <cover.1708709155.git.john@groves.net>
 <CAOQ4uxiPc5ciD_zm3jp5sVQaP4ndb40mApw5hx2DL+8BZNd==A@mail.gmail.com>
 <CAJfpegv8XzFvty_x00UehUQxw9ai8BytvGNXE8SL03zfsTN6ag@mail.gmail.com>
 <CAOQ4uxg9WyQ_Ayh7Za_PJ2u_h-ncVUafm5NZqT_dt4oHBMkFQg@mail.gmail.com>
 <kejfka5wyedm76eofoziluzl7pq3prys2utvespsiqzs3uxgom@66z2vs4pe22v>
 <CAJfpegvQefgKOKMWC8qGTDAY=qRmxPvWkg2QKzNUiag1+q5L+Q@mail.gmail.com>
 <l2zbsuyxzwcozrozzk2ywem7beafmidzp545knnrnkxlqxd73u@itmqyy4ao43i>
 <CAJfpegsr-5MU-S4obTsu89=SazuG8zXmO6ymrjn5_BLofSRXdg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegsr-5MU-S4obTsu89=SazuG8zXmO6ymrjn5_BLofSRXdg@mail.gmail.com>

On 24/05/23 03:57PM, Miklos Szeredi wrote:
> [trimming CC list]
> 
> On Thu, 23 May 2024 at 04:49, John Groves <John@groves.net> wrote:
> 
> > - memmap=<size>!<hpa_offset> will reserve a pretend pmem device at <hpa_offset>
> > - memmap=<size>$<hpa_offset> will reserve a pretend dax device at <hpa_offset>
> 
> Doesn't get me a /dev/dax or /dev/pmem
> 
> Complete qemu command line:
> 
> qemu-kvm -s -serial none -parallel none -kernel
> /home/mszeredi/git/linux/arch/x86/boot/bzImage -drive
> format=raw,file=/home/mszeredi/root_fs,index=0,if=virtio -drive
> format=raw,file=/home/mszeredi/images/ubd1,index=1,if=virtio -chardev
> stdio,id=virtiocon0,signal=off -device virtio-serial -device
> virtconsole,chardev=virtiocon0 -cpu host -m 8G -net user -net
> nic,model=virtio -fsdev local,security_model=none,id=fsdev0,path=/home
> -device virtio-9p-pci,fsdev=fsdev0,mount_tag=hostshare -device
> virtio-rng-pci -smp 4 -append 'root=/dev/vda console=hvc0
> memmap=4G$4G'
> 
> root@kvm:~/famfs# scripts/chk_efi.sh
> This system is neither Ubuntu nor Fedora. It is identified as debian.
> /sys/firmware/efi not found; probably not efi
>  not found; probably nof efi
> /boot/efi/EFI not found; probably not efi
> /boot/efi/EFI/BOOT not found; probably not efi
> /boot/efi/EFI/ not found; probably not efi
> /boot/efi/EFI//grub.cfg not found; probably nof efi
> Probably not efi; errs=6
> 
> Thanks,
> Miklos


Apologies, but I'm short on time at the moment - going into a long holiday
weekend in the US with family plans. I should be focused again by middle of
next week.

But can you check /proc/cmdline to see of the memmap arg got through without
getting mangled? The '$' tends to get fubar'd. You might need \$, or I've seen
the need for \\\$. If it's un-mangled, there should be a dax device.

If that doesn't work, it's worth trying '!' instead, which I think would give
you a pmem device - if the arg gets through (but ! is less likely to get
horked). That pmem device can be converted to devdax...

Regards,
John

