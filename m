Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092DE15F3F8
	for <nvdimm@lists.linux.dev>; Mon,  5 Aug 2024 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722883288; cv=none; b=Cwznf2KDNE+XSraz1qR5fHVbQrsvTpMrfaBY23ae1BRqKtwuB3GMYZrMqSiyawrAwyzeLdfo9WeRzfvA05JZDgu3bAolEpXMsmeLhOk5rGhaxUSkFT6E8sBaNjl8eHwuL608xXj627J3G0puHkG7KvG60xpWqBCuqie4aqwWtBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722883288; c=relaxed/simple;
	bh=Ys/t/CdNVJJmv2lzAuDmT1M/s6j0A9XtgN3oc62Jk5I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qx0bDz+MSIT8X2csDmrh3h4RivmWMwiQqR2pOaY6kauEzuNUCoffy8SlJaqGQN3ppRgX4+D0SLuhECv5tIwiPvcrbKhyuaQGUKPhujNI7ZjKsTMIxdqqR4QlFAn7vOaeEbH320gYVJS04vScMFSxKhRheesnWJvYk9f87Xs7Gtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b=KSEZEEBI; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b="KSEZEEBI"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3db1d4dab7fso6612532b6e.1
        for <nvdimm@lists.linux.dev>; Mon, 05 Aug 2024 11:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1722883285; x=1723488085; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nXDR7qiLrGhxm4QaBcXkbXKBNxx4m/1amTQ3OxtKpcA=;
        b=KSEZEEBIB7hgVsh0/8B0GspfpnPHDHChbR1eedomXx/dL3KLxOKDjOLYL4UKGrF7Le
         +6NvAjlMj2FGkFbN/EzL94n4nnm3hVd10tDuxvsAolz8tEXIZhjDNbaZuGPwaiAzVkEB
         9LvsXtYYvIfjxLbSGtNg5aMtQzl0FuAvI7QxQNs3fxUkhnyDuAYWmdAdiUR/EWr5JMIo
         PtwHQIqQuz/cr2nCuiN3sSVuwY4BVIn/uXcJ37RKwzuiGt8Os2jypOKYuhKoggUs6LWa
         F7fn1gSd2P1nPwPiTJ4qQakvnabRT7ceCBIReFbOzHg3D66ToKLlDDFdvtJUtZaoHgWq
         k4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722883285; x=1723488085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nXDR7qiLrGhxm4QaBcXkbXKBNxx4m/1amTQ3OxtKpcA=;
        b=RfLb/mNdpT6QEif3hbgGq6Ff/uGcUo/ozZ4xB7+z05YA9e877EtwH41HFxXJjkdJSe
         +uCoCjn3JNWUcZzI9+E5Bmqi1s7ah8x46KbPzL5Cp95Qq12bs4hhbPk5b7x/XA2BQhTU
         QbD2e4eSxIPBt5HmHdFtOaDluS0Hlx9fFBhbL+ni2I6OzL2pvyzqWnIw63B2lYXE/O8z
         GluMxJJileW1DxnEPvvNH7Mq+56Wud7BbWIfub3cur4KAOCYmo32fS8FoT7ivIfUKu74
         TVDntCtzUDmzymEL/XRJ0upG4jL1iojP/mewpmtvns8mtFS4SVf79fJ2ONCZqJGuNGi2
         wq/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXpQdH8X3Yjx8QvxXh+xgFawyqwnJVAmc4niccHvj9T5S7qDjNLPaX2nIp/T4kO0mEmTrMqzxDY+8lCYUr7nZ6o1/vVFHyp
X-Gm-Message-State: AOJu0YyT31HiObBHoVztMZkil85VdNBmCjzer73e7LCI2/Jlgd6MTDcl
	QaG/yind37nZHGv0TOZetS8E+Em5M+z7Mp8xD7IYQCQVPGbbsidyGlql77wy+0Z/gfOiyLEvdRS
	CWjyr0pBFgykOsktWC7bng0lNMxgRig0ehdSd3Q==
X-Google-Smtp-Source: AGHT+IELiX1V707IcRryP1iDqdmXzsN+eMp7QFXOkdeEr9fYlKlUd987VH8uQ7e08ycHl28xM7Hu7WLB3uBVe3WBGzg=
X-Received: by 2002:a05:6808:191a:b0:3da:e02f:eb8e with SMTP id
 5614622812f47-3db5583e3e9mr18020289b6e.43.1722883285128; Mon, 05 Aug 2024
 11:41:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240605222751.1406125-1-souravpanda@google.com> <Zq0tPd2h6alFz8XF@aschofie-mobl2>
In-Reply-To: <Zq0tPd2h6alFz8XF@aschofie-mobl2>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 5 Aug 2024 14:40:48 -0400
Message-ID: <CA+CK2bAfgamzFos1M-6AtozEDwRPJzARJOmccfZ=uzKyJ7w=kQ@mail.gmail.com>
Subject: Re: [PATCH v13] mm: report per-page metadata information
To: Alison Schofield <alison.schofield@intel.com>
Cc: Sourav Panda <souravpanda@google.com>, corbet@lwn.net, gregkh@linuxfoundation.org, 
	rafael@kernel.org, akpm@linux-foundation.org, mike.kravetz@oracle.com, 
	muchun.song@linux.dev, rppt@kernel.org, david@redhat.com, 
	rdunlap@infradead.org, chenlinxuan@uniontech.com, yang.yang29@zte.com.cn, 
	tomas.mudrunka@gmail.com, bhelgaas@google.com, ivan@cloudflare.com, 
	yosryahmed@google.com, hannes@cmpxchg.org, shakeelb@google.com, 
	kirill.shutemov@linux.intel.com, wangkefeng.wang@huawei.com, 
	adobriyan@gmail.com, vbabka@suse.cz, Liam.Howlett@oracle.com, 
	surenb@google.com, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	willy@infradead.org, weixugc@google.com, David Rientjes <rientjes@google.com>, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, yi.zhang@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 2, 2024 at 3:02=E2=80=AFPM Alison Schofield
<alison.schofield@intel.com> wrote:
>
> ++ nvdimm, linux-cxl, Yu Zhang
>
> On Wed, Jun 05, 2024 at 10:27:51PM +0000, Sourav Panda wrote:
> > Today, we do not have any observability of per-page metadata
> > and how much it takes away from the machine capacity. Thus,
> > we want to describe the amount of memory that is going towards
> > per-page metadata, which can vary depending on build
> > configuration, machine architecture, and system use.
> >
> > This patch adds 2 fields to /proc/vmstat that can used as shown
> > below:
> >
> > Accounting per-page metadata allocated by boot-allocator:
> >       /proc/vmstat:nr_memmap_boot * PAGE_SIZE
> >
> > Accounting per-page metadata allocated by buddy-allocator:
> >       /proc/vmstat:nr_memmap * PAGE_SIZE
> >
> > Accounting total Perpage metadata allocated on the machine:
> >       (/proc/vmstat:nr_memmap_boot +
> >        /proc/vmstat:nr_memmap) * PAGE_SIZE
> >
> > Utility for userspace:
> >
> > Observability: Describe the amount of memory overhead that is
> > going to per-page metadata on the system at any given time since
> > this overhead is not currently observable.
> >
> > Debugging: Tracking the changes or absolute value in struct pages
> > can help detect anomalies as they can be correlated with other
> > metrics in the machine (e.g., memtotal, number of huge pages,
> > etc).
> >
> > page_ext overheads: Some kernel features such as page_owner
> > page_table_check that use page_ext can be optionally enabled via
> > kernel parameters. Having the total per-page metadata information
> > helps users precisely measure impact. Furthermore, page-metadata
> > metrics will reflect the amount of struct pages reliquished
> > (or overhead reduced) when hugetlbfs pages are reserved which
> > will vary depending on whether hugetlb vmemmap optimization is
> > enabled or not.
> >
> > For background and results see:
> > lore.kernel.org/all/20240220214558.3377482-1-souravpanda@google.com
> >
> > Acked-by: David Rientjes <rientjes@google.com>
> > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> This patch is leading to Oops in 6.11-rc1 when CONFIG_MEMORY_HOTPLUG
> is enabled. Folks hitting it have had success with reverting this patch.
> Disabling CONFIG_MEMORY_HOTPLUG is not a long term solution.
>
> Reported here:
> https://lore.kernel.org/linux-cxl/CAHj4cs9Ax1=3DCoJkgBGP_+sNu6-6=3D6v=3D_=
L-ZBZY0bVLD3wUWZQg@mail.gmail.com/

Thank you for the heads up. Can you please attach a full config file,
also was anyone able to reproduce this problem in qemu with emulated
nvdimm?

Pasha
