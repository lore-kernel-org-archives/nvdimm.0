Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2661D26056E
	for <nvdimm@lists.linux.dev>; Tue,  9 Dec 2025 20:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765311041; cv=none; b=K43ce2/nGx7cD/v2g5E2+IQAoLRLZr+Ap/QnaSRbu/bL4oucsJHtQAtHboDiszmIc+G+s/cTHpAk2gmWKE2MT2bNCed91J0Rn1r0vrNALjct+pRr/iZP++BSn3WnOnFn0LmN4GPM+bS908QqaRcufDgcRS1KO/x0ArtdyIGm5Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765311041; c=relaxed/simple;
	bh=8D4mFsQStzi/FzJeLPf3Bnm2/wkQakF7Wl8TiJblTPM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rGCNs4Jx/EiKUINAls7eBXDoN4ztd8YnZHrVl6wGd1l409EmMGiWFElUY+ojeMlVviM07OFmwUN0oqjdO8gJlRIVnaP3qL2fatL/HWW2xrQRg1iX968cpf9o5cqAa1ZHP1IgbTJwc6Cc+NqIs+m7lUA9sapa6l/j9e6OStjYar8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pZ2YdnHJ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pZ2YdnHJ"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-297e13bf404so42245ad.0
        for <nvdimm@lists.linux.dev>; Tue, 09 Dec 2025 12:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765311039; x=1765915839; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8D4mFsQStzi/FzJeLPf3Bnm2/wkQakF7Wl8TiJblTPM=;
        b=pZ2YdnHJbry986eMeuMhdQNfz7h+V1tMTUXJVkl94kGWW6cOgFsHYJd2ftCQs+BxBb
         1Aev34fY0RoQCr/vrjKALbP8gtAJ0fz/5vn5LpdFjsdETHYF7EAQC37/rCiUrJIQ/cn/
         AI5TEE/7abnjjNVUkvDx6KRQuAwOKmE/SJfB/DznEZbqeL09nV1tq69D6ijdNhWxg9nX
         iIWChfai8NSKfxJiqvtsflMOGOScJXrHv2E2n/DBzFvdOxsnJZGC7EBYB9KBVdCZMHBp
         cYBqf0S1Kho6P9X0CY963Z5PxJcwmAk0Ly2Iu2Gsn6XEpETMj/DehJpUGeuFtV7Ap9Y1
         Gt1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765311039; x=1765915839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8D4mFsQStzi/FzJeLPf3Bnm2/wkQakF7Wl8TiJblTPM=;
        b=tVNPyjxyn0+mSFzMAsQe6HvRKVeCZklbhJHIMEBVBLLMhXGJI0IAlmggDgbv7srxWw
         c3SJcERnqEsnca25Y8B9lIWRW5/lB/651Ha06yoB53WWy+Hw1m8TehySzKQBNNF3GDxO
         9wacUoH6btXGOOm9CfYnokhOJHKGfzmLuvIfo2x4XNiznDlFAvR2nXQpW1PYuohV7Vep
         uCbI43kes76lDoyqnSeMDjd0uQTRIAKuZXMaNVfNWDSN8hfL1Rw9c4jFIICPtNfUTg5q
         SHaLbS5G5aFq1/G40aWOxSnzVdFxvg6B1WPd/jEMjAPgu6hbW1zmsnNVfusJqhY8XD8V
         8wsA==
X-Forwarded-Encrypted: i=1; AJvYcCXHzNWa0zxHziWPxO5aoVhuQ5ez7SlYfld2EYJq0ZmWFs+H1f8n6u3J48D5QLrylyBrZ44Fr9Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YxEswj9EMDj51ZI69L0I0TlrDpcTd3PJQlP8SZ0V8rMQkrMjp8M
	fZTxWz+qVVEUxJm64dDbOVE3qMY1lfE0S/F05MKQT7mzEWw1STD1JXs8THtbqu2i98GzjVUs/WL
	F31GTd0gbbl9RlLTzpT5NGH1D+NS9mMS6j1zWk0m/
X-Gm-Gg: ASbGnctvbUyfwgKUXfbF+OIgb6AzCCmpsW0hU5HOkgSnZRZ6s8xm1Z0FxURZ1FESa6d
	NBuVKh51gmX8ggRJT3cZLv0YqgUNv0UYXaWZMCMV5l7CmW8BR+oCAc0Bqarg8awIQ9+Vl8KcrLp
	VJYs3BQcTWVzQ/wJpgRTVTNyHV1JcauHlzlrWmNVN0tQ6+WMmWuexHCzqoVAd5MW2/Ym2YeVZ+C
	bB2zglxYqSfk9At9Rr1IyicKwHTCLPS2SzwcdI7anw+YFGumiupvdXSemngBouZhIwdHQ==
X-Google-Smtp-Source: AGHT+IFw/k7gbvtVpscKoefLI/XK9+Oadwqqt+EbGAokBNr+rjqNop6AHWfyOXfekk7UzYjSd9kYkCNvWrhm90Ktgd8=
X-Received: by 2002:a05:7022:4582:b0:119:e55a:8084 with SMTP id
 a92af1059eb24-11f28f23d24mr33422c88.1.1765311039019; Tue, 09 Dec 2025
 12:10:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250826080430.1952982-1-rppt@kernel.org> <20250826080430.1952982-2-rppt@kernel.org>
 <68b0f8a31a2b8_293b3294ae@iweiny-mobl.notmuch> <aLFdVX4eXrDnDD25@kernel.org>
 <CAAi7L5eWB33dKTuNQ26Dtna9fq2ihiVCP_4NoTFjmFFrJzWtGQ@mail.gmail.com>
 <68d3465541f82_105201005@dwillia2-mobl4.notmuch> <CAAi7L5esz-vxbbP-4ay-cCfc1osXLkvGDx5thijuBXFBQNwiug@mail.gmail.com>
 <68d6df3f410de_1052010059@dwillia2-mobl4.notmuch> <CAAi7L5dWpzfodg3J4QqGP564qDnLmqPCKHJ-1BTmzwMUhz6rLg@mail.gmail.com>
 <68ddab118dcd4_1fa21007f@dwillia2-mobl4.notmuch>
In-Reply-To: <68ddab118dcd4_1fa21007f@dwillia2-mobl4.notmuch>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Tue, 9 Dec 2025 21:10:26 +0100
X-Gm-Features: AQt7F2qF5yKsbKM_shbfmlc22M4xEH5Jtq7qhNbGcqj80uFGn8ayiwixjvgqnwg
Message-ID: <CAAi7L5cpkYrf5KjKdX0tsRS2Q=3B_6NZ4urNG6EfjNYADqhYSA@mail.gmail.com>
Subject: Re: [PATCH 1/1] nvdimm: allow exposing RAM carveouts as NVDIMM DIMM devices
To: dan.j.williams@intel.com
Cc: Mike Rapoport <rppt@kernel.org>, Ira Weiny <ira.weiny@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, jane.chu@oracle.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Tyler Hicks <code@tyhicks.com>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 2, 2025 at 12:28=E2=80=AFAM <dan.j.williams@intel.com> wrote:
>
> Micha=C5=82 C=C5=82api=C5=84ski wrote:
> > On Fri, Sep 26, 2025 at 8:45=E2=80=AFPM <dan.j.williams@intel.com> wrot=
e:
> > >
> > > Micha=C5=82 C=C5=82api=C5=84ski wrote:
> > > [..]
> > > > > As Mike says you would lose 128K at the end, but that indeed beco=
mes
> > > > > losing that 1GB given alignment constraints.
> > > > >
> > > > > However, I think that could be solved by just separately vmalloc'=
ing the
> > > > > label space for this. Then instead of kernel parameters to sub-di=
vide a
> > > > > region, you just have an initramfs script to do the same.
> > > > >
> > > > > Does that meet your needs?
> > > >
> > > > Sorry, I'm having trouble imagining this.
> > > > If I wanted 500 1GB chunks, I would request a region of 500GB+space
> > > > for the label? Or is that a label and info-blocks?
> > >
> > > You would specify an memmap=3D range of 500GB+128K*.
> > >
> > > Force attach that range to Mike's RAMDAX driver.
> > >
> > > [ modprobe -r nd_e820, don't build nd_820, or modprobe policy blocks =
nd_e820 ]
> > > echo ramdax > /sys/bus/platform/devices/e820_pmem/driver_override
> > > echo e820_pmem > /sys/bus/platform/drivers/ramdax
> > >
> > > * forget what I said about vmalloc() previously, not needed
> > >
> > > > Then on each boot the kernel would check if there is an actual
> > > > label/info-blocks in that space and if yes, it would recreate my
> > > > devices (including the fsdax/devdax type)?
> > >
> > > Right, if that range is persistent the kernel would automatically par=
se
> > > the label space each boot and divide up the 500GB region space into
> > > namespaces.
> > >
> > > 128K of label spaces gives you 509 potential namespaces.
> >
> > That's not enough for us. We would need ~1 order of magnitude more.
> > Sorry I'm being vague about this but I can't discuss the actual
> > machine sizes.
>
> Sure, then make it 1280K of label space. There's no practical limit in
> the implementation.

Hi Dan,
I just had the time to try this out. So I modified the code to
increase the label space to 2M and I was able to create the
namespaces. It put the metadata in volatile memory.

But the infoblocks are still within the namespaces, right? If I try to
create a 3G namespace with alignment set to 1G, its actual usable size
is 2G. So I can't divide the whole pmem into 1G devices with 1G
alignment.

If I modify the code to remove the infoblocks, the namespace mode
won't be persistent, right? In my solution I get that information from
the kernel command line, so I don't need the infoblocks.

> > > > One of the requirements for live update is that the kexec reboot ha=
s
> > > > to be fast. My solution introduced a delay of tens of milliseconds
> > > > since the actual device creation is asynchronous. Manually dividing=
 a
> > > > region into thousands of devices from userspace would be very slow =
but
> > >
> > > Wait, 500GB Region / 1GB Namespace =3D thousands of Namespaces?
> >
> > I was talking about devices and AFAIK 1 namespace equals 5 devices for
> > us currently (nd/{namespace, pfn, btt, dax}, dax/dax). Though the
> > device creation is asynchronous so I guess the actual device count is
> > not important.
>
> I do not see how it is relevant. You also get 1000s of devices with
> plain memory block devices.
>
> > > > I would have to do that only on the first boot, right?
> > >
> > > Yes, the expectation is only incur that overhead once. It also allows
> > > for VMs to be able to lookup their capacity by name. So you do not ne=
ed
> > > a separate mapping of 1GB Namepsace blocks to VMs. Just give some VMs
> > > bigger Namespaces than others by name.
> >
> > Sure, I can do that at first. But after some time fragmentation will
> > happen, right?
>
> Why would fragementation be more of a problem with labels vs command
> line if the expectation is maintaining a persistent namespace layout
> over time?
>
> > At some point I will have to give VMs a bunch of smaller namespaces
> > here and there.
> >
> > Btw. one more thing I don't understand. Why are maintainers so much
> > against adding new kernel parameters?
>
> This label code is already written and it is less burden to maintain a
> new use of existing code vs new mechanism for a niche use case. Also,
> memmap=3D has long been a footgun, making that problem worse for
> questionable benefit to wider Linux project does not feel like the right
> tradeoff.
>
> The other alternative to labels is ACPI NFIT table injection. Again the
> tradeoff is that is just another reuse of an existing well worn
> mechanism for delineating PMEM.
