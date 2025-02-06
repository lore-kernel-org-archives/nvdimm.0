Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064101624E0
	for <nvdimm@lists.linux.dev>; Thu,  6 Feb 2025 14:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738853960; cv=none; b=tzd9Ma8YYQZsOipcFPgB1mrYV5mc/Vsdr1GXbh/4jENVgLznngDm6KWClM7xYXS2RNo4f5BWdxzN6MbIN1NmEi2ljE/DQbYPhGX+JFTM5udmPDWpKveHa/FcpiqNvypXGztZYu/17VGIgFcBLFznhIhvllCmYDvwGIzzo31acx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738853960; c=relaxed/simple;
	bh=U74SGZiAIGmMlazRLhrpYiZ/iTjbN0drFn9h+a0WXAw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILHH5iOHEaE1u1Po3S4vDp+tdCkOe0bUK+UfhE3ZaPnNySRzKcWmPaHYIvByuRdd/7mWItJR1G44hRhwdiIRNnlgJUYhjyBwfZTOxwjPluJAzgMfvRIo7g08aHGK+8p0w61uJcNobLOvz0c5wRzMVGeD3og8xfFZ/L2fM/B1Y6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BdCqkirI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BdCqkirI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738853957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U74SGZiAIGmMlazRLhrpYiZ/iTjbN0drFn9h+a0WXAw=;
	b=BdCqkirIJKZnIsCjuzBtLunX5J96UtsuVh0dB1pI1y90rh3MXWKSEtVMENEJrTFYsO3Qod
	TidMRNNfFwVHPB5nrYB2LZCJCcVkqRhcyrD3Atpxk3EF5ymhBx0D/2Tk5O2QoABedpjkyL
	cMAVADLrEfUPzEHjXQyyZmAd4hjn5tA=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-OaXMP6NyPBG1m1h-trnWrw-1; Thu, 06 Feb 2025 09:59:16 -0500
X-MC-Unique: OaXMP6NyPBG1m1h-trnWrw-1
X-Mimecast-MFC-AGG-ID: OaXMP6NyPBG1m1h-trnWrw
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2fa166cf656so652767a91.2
        for <nvdimm@lists.linux.dev>; Thu, 06 Feb 2025 06:59:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738853955; x=1739458755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U74SGZiAIGmMlazRLhrpYiZ/iTjbN0drFn9h+a0WXAw=;
        b=mCV5Gcxi2NA1LHo0IZ3OLJcM/R9Q0PJx7rFJYo3uM2eaRtXuyESOUjmenCc5uLbFgT
         jKXu/wZLJCAEqIhdYsx7FwIoh6dcFcwu1TpbQ7nKEGHW1RMpgjgVyrknuPmAhz7Nq/rQ
         Opwsqeb7d7MI3yuvCR+fKi52d6E+reAAPi2PrXRZqZiQVkLRaOXg9+AmGQlrubaYHuEL
         bjHt0BvYocToQBuqHxSYs384a/oGPAzrupalDXB/vZJ4u9tqR/Wcoxsi4bX1fyPcr9nL
         ihaRDaBexs/PoBlGhL/Br9qmuT6IkIaFDSOSLg8Z04hOUUKD4TnBveagdDShiebe/vWy
         cQGg==
X-Forwarded-Encrypted: i=1; AJvYcCX2TsbNuIt7hyZbC1wZSxeKt6qHEUpKKQusqBNeAvafhLLAbHhzwMOxUXcUQ4ikB8HFfFGxXts=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9TjJ33U2c4+jX/12t9il4uJq/FlfXiy33hBWx5Ek+5oRgYzHo
	qhIw3FkukUXXUAcSyWO+sYTAgIwkEVu5IF8ZKPGsLbkcImpdpHB27t8Xv6l4V/FUkPYEDHihHOF
	6mwrZR8lYVIvgLSxz2rwY6X5MaWnlP6NuugAhMqX4mxX14fotU25Oe8F08Qz27ZiQQ12vQKj6Hv
	p5uNmhokG9ulfO8K/yeYPQbonPDS+W
X-Gm-Gg: ASbGncvEmc92ei0HyzXaOpleeTai0WDULEc/J/sArFBbVBXSz/1vd7D/DPvqOaNTRjv
	MbxRqlZbceIHGcNZvDNiILnUZlvRGY2HtLxhv55tlWKm6kMgvehxDYQFBQjp3ry6z
X-Received: by 2002:a17:90b:2786:b0:2ee:e518:c1d8 with SMTP id 98e67ed59e1d1-2f9e082f33emr11110529a91.30.1738853955738;
        Thu, 06 Feb 2025 06:59:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFWpQlGfjL4+bcsd9CXoOi/pDbHuiuuwkJUWCLm8Y4KSWCpEnRWVj/utErs2ioiglleYEOHWPatBsG9+Rhw180=
X-Received: by 2002:a17:90b:2786:b0:2ee:e518:c1d8 with SMTP id
 98e67ed59e1d1-2f9e082f33emr11110445a91.30.1738853955312; Thu, 06 Feb 2025
 06:59:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.11189864684e31260d1408779fac9db80122047b.1736488799.git-series.apopple@nvidia.com>
 <bfae590045c7fc37b7ccef10b9cec318012979fd.1736488799.git-series.apopple@nvidia.com>
 <Z6NhkR8ZEso4F-Wx@redhat.com> <67a3fde7da328_2d2c2942b@dwillia2-xfh.jf.intel.com.notmuch>
 <Z6S7A-51SdPco_3Z@redhat.com> <20250206143032.GA400591@fedora>
In-Reply-To: <20250206143032.GA400591@fedora>
From: Albert Esteve <aesteve@redhat.com>
Date: Thu, 6 Feb 2025 15:59:03 +0100
X-Gm-Features: AWEUYZm-M5VdAvcj3hSDqRtWWsY2KSl-UpKtCd6mALNvZQI6X9XPfCW9uUgmKYc
Message-ID: <CADSE00+2o5Ma0W6FBLHwpUaKut9Tf74GKLCU-377qgxr08EeoQ@mail.gmail.com>
Subject: Re: [PATCH v6 01/26] fuse: Fix dax truncate/punch_hole fault path
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Dan Williams <dan.j.williams@intel.com>, 
	Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	alison.schofield@intel.com, lina@asahilina.net, zhang.lyra@gmail.com, 
	gerald.schaefer@linux.ibm.com, vishal.l.verma@intel.com, dave.jiang@intel.com, 
	logang@deltatee.com, bhelgaas@google.com, jack@suse.cz, jgg@ziepe.ca, 
	catalin.marinas@arm.com, will@kernel.org, mpe@ellerman.id.au, 
	npiggin@gmail.com, dave.hansen@linux.intel.com, ira.weiny@intel.com, 
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu, linmiaohe@huawei.com, 
	david@redhat.com, peterx@redhat.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jhubbard@nvidia.com, 
	hch@lst.de, david@fromorbit.com, chenhuacai@kernel.org, kernel@xen0n.name, 
	loongarch@lists.linux.dev, Hanna Czenczek <hreitz@redhat.com>, 
	German Maglione <gmaglione@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WLlvH14QUY4gBAgw5aLbE2Se9Ip-ND1003yvR6t-QpQ_1738853956
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi!

On Thu, Feb 6, 2025 at 3:30=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.com=
> wrote:
>
> On Thu, Feb 06, 2025 at 08:37:07AM -0500, Vivek Goyal wrote:
> > And then there are challenges at QEMU level. virtiofsd needs additional
> > vhost-user commands to implement DAX and these never went upstream in
> > QEMU. I hope these challenges are sorted at some point of time.
>
> Albert Esteve has been working on QEMU support:
> https://lore.kernel.org/qemu-devel/20240912145335.129447-1-aesteve@redhat=
.com/
>
> He has a viable solution. I think the remaining issue is how to best
> structure the memory regions. The reason for slow progress is not
> because it can't be done, it's probably just because this is a
> background task.

It is partially that, indeed. But what has me blocked for now on posting th=
e
next version is that I was reworking a bit the MMAP strategy.
Following David comments, I am relying more on RAMBlocks and
subregions for mmaps. But this turned out more difficult than anticipated.

I hope I can make it work this month and then post the next version.
If there are no major blockers/reworks, further iterations on the
patch shall go smoother.

I have a separate patch for the vhost-user spec which could
iterate faster, if that'd help.

BR,
Albert.

>
> Please discuss with Albert if QEMU support is urgent.
>
> Stefan

