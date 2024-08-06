Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA782170A14
	for <nvdimm@lists.linux.dev>; Tue,  6 Aug 2024 22:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722983565; cv=none; b=HIVpVyLsccfToRS6fs2wP0+zLVe5xoZnRt86vQoFM6VFngkd282OfqZk6aXNQR2fBavINbuaBvF+sfhLZT659FxT2myj+VO4sUb68IJEQao0buSy7YZzTfq8BTi+6/lrk62fWQfJpww+qJsBCzk0hmLIZtAOSzCbS5iZ1LyTwMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722983565; c=relaxed/simple;
	bh=AIFgqGTPqAlr+l3ZC0h5bu/U53+G2p+tdAkS9Efnj9s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 Cc:Content-Type; b=YX/KM2KDdrZD/5wTEivLbD1hykK6B/VqTKPXzaU13aGe3w7yw20ejlKFxj3GFRocxYQCSBqgzfcv6+HyUSgOCCnqSJ5L+n16dZGPhBmUGk/T4xIaGZ6AA2wMjjEjBnU/gqJZUgzzFXgsluPxw1YeER+6KKGOUzXlZNh+Ky5D8ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b=mmnZMxjP; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b="mmnZMxjP"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-44ff6f3c427so5479271cf.1
        for <nvdimm@lists.linux.dev>; Tue, 06 Aug 2024 15:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1722983562; x=1723588362; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEKrh9oASaBtp3LjejtNI1CdLoHRrZQ/LRepCSn8ys0=;
        b=mmnZMxjPiFbUVYHAn1a6GrvoXXuOjNqEJucp2RdwVshfwIeAFgoNi1YBHpzYIwRi3e
         XvBwzO1QKOJvNyVbKqkGq+ek/eJcFCLZmTDyBTVngOGdKrZkpsAVjDeCvV2qm1ofG7BS
         Wzbn9dBdV8mvpSLXZVB2FK0JERMBbVmfXLGCLtZCOhyV7HlYeZhMH9LiFBQ8rKqJ2+80
         bMzZT6SsRD2R+F4dKWZMdr7u3KPW8XGUcA8kZ9SMCmwJfrXIGcWqUDx0GxXyibH49ikq
         ++yW0N5l6bvWKvmFnqhPIdweCwTroO8dlBHzOkH19S+PQ2g/livbO3yY4bgg24wQzvQi
         zXfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722983562; x=1723588362;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GEKrh9oASaBtp3LjejtNI1CdLoHRrZQ/LRepCSn8ys0=;
        b=VLDsO8B1hVOjrBvaUKmM6z0LbRi1xBf+zc5MrQ3nfbkz6hzfnmJPH2Vl8s/+flt366
         jv8I3EDBV9kcBiWeXarUx2+uaKHq/KMXceFwLVW0WgDAmiGubHttgl4lrBtBhIKuKsLN
         DNL88NYI6KC043InrUyxVmBRCNiy+m0XjF+Rwn/ArweHRMUoi6o0adw1LsgrEJ3vACrh
         5pPzPNzmOoZ5HyP+1bTy/P4Xb9KU4Z4xYzl2zaPA03nPjqCivIXlx9dRPekTqbhoUW4X
         etJyKLuGt9WY9vQ1CRMmcEsaH8lZ7BlgkQw7eNxzGT0BOK5cylJdnYWJ0lN/wCDCgtn6
         ohMg==
X-Forwarded-Encrypted: i=1; AJvYcCWUGa45+8sN2GleIOQ3vrqLsk9ocSOohvW6e0YAiDeSG9jgTpnIWbp6CnUb29hUefAoz2phirpQ64H/uOE2wyPa9z0aCr91
X-Gm-Message-State: AOJu0YwAeqPlNxsKtDa2/mvcXc5QPLDl8xN+Z9Lc4H2p5VkYd1xKtJpb
	j3CAfCR7iKWG+q4uZWFypsxfpZYDQoVDJ/gXrjPnq1ixuGJg4StGZTaX2evXkhJSFgQm1Z7aq1a
	EmZWrkkLgL2F1UfNB+vIiKQEPVUqzNLF5sFBiVA==
X-Received: by 2002:ac8:5d0f:0:b0:447:ea77:6de0 with SMTP id
 d75a77b69052e-4518926f297mt189646951cf.13.1722983562494; Tue, 06 Aug 2024
 15:32:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240605222751.1406125-1-souravpanda@google.com>
 <Zq0tPd2h6alFz8XF@aschofie-mobl2> <CA+CK2bAfgamzFos1M-6AtozEDwRPJzARJOmccfZ=uzKyJ7w=kQ@mail.gmail.com>
 <66b15addf1a80_c144829473@dwillia2-xfh.jf.intel.com.notmuch>
 <CA+CK2bC1ZsT3cuAMDAAUonys3BUxbb2JdnZXs1Ps3NbYZt5W2Q@mail.gmail.com>
 <ZrKNKRfaH7GliS3C@iweiny-mobl> <CA+CK2bDnJsgjK-7H-8qJjdeejKJk7E7m-SDnwXatH4FHr4R0_g@mail.gmail.com>
In-Reply-To: <CA+CK2bDnJsgjK-7H-8qJjdeejKJk7E7m-SDnwXatH4FHr4R0_g@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 6 Aug 2024 18:32:05 -0400
Message-ID: <CA+CK2bChNfuFR3jnFo-iyHiJ0inUGNBgtLXC7o5pgfCN-534AA@mail.gmail.com>
Subject: Re: [PATCH v13] mm: report per-page metadata information
Cc: Dan Williams <dan.j.williams@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Sourav Panda <souravpanda@google.com>, corbet@lwn.net, gregkh@linuxfoundation.org, 
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
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, yi.zhang@redhat.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 5:37=E2=80=AFPM Pasha Tatashin <pasha.tatashin@solee=
n.com> wrote:
>
> On Tue, Aug 6, 2024 at 4:53=E2=80=AFPM Ira Weiny <iweiny@iweiny-mobl> wro=
te:
> >
> > On Tue, Aug 06, 2024 at 01:59:54PM -0400, Pasha Tatashin wrote:
> > > On Mon, Aug 5, 2024 at 7:06=E2=80=AFPM Dan Williams <dan.j.williams@i=
ntel.com> wrote:
> > > >
> > > > Pasha Tatashin wrote:
> > > > [..]
> > > > > Thank you for the heads up. Can you please attach a full config f=
ile,
> > > > > also was anyone able to reproduce this problem in qemu with emula=
ted
> > > > > nvdimm?
> > > >
> > > > Yes, I can reproduce the crash just by trying to reconfigure the mo=
de of
> > > > a pmem namespace:
> > > >
> > > > # ndctl create-namespace -m raw -f -e namespace0.0
> > > >
> > > > ...where namespace0.0 results from:
> > > >
> > > >     memmap=3D4G!4G
> > > >
> > > > ...passed on the kernel command line.
> > > >
> > > > Kernel config here:
> > > >
> > > > https://gist.github.com/djbw/143705077103d43a735c179395d4f69a
> > >
> > > Excellent, I was able to reproduce this problem.
> > >
> > > The problem appear to be caused by this code:
> > >
> > > Calling page_pgdat() in depopulate_section_memmap():
> > >
> > > static void depopulate_section_memmap(unsigned long pfn, unsigned lon=
g nr_pages,
> > >                 struct vmem_altmap *altmap)
> > > {
> > >         unsigned long start =3D (unsigned long) pfn_to_page(pfn);
> > >         unsigned long end =3D start + nr_pages * sizeof(struct page);
> > >
> > >         mod_node_page_state(page_pgdat(pfn_to_page(pfn)), NR_MEMMAP,
> > > <<<< We cannot do it.
> > >                             -1L * (DIV_ROUND_UP(end - start, PAGE_SIZ=
E)));
> > >         vmemmap_free(start, end, altmap);
> > > }
> > >
> > > The page_pgdat() returns NULL starting from:
> > > pageunmap_range()
> > >     remove_pfn_range_from_zone() <- page is removed from the zone.
> >
> > Is there any idea on a fix?  I'm seeing the same error.
> >
> > [  561.867431]  ? mod_node_page_state+0x11/0xa0
> > [  561.867963]  section_deactivate+0x2a0/0x2c0
> > [  561.868496]  __remove_pages+0x59/0x90
> > [  561.868975]  arch_remove_memory+0x1a/0x40
> > [  561.869491]  memunmap_pages+0x206/0x3d0
> > [  561.869972]  devres_release_all+0xa8/0xe0
> > [  561.870466]  device_unbind_cleanup+0xe/0x70
> > [  561.870960]  device_release_driver_internal+0x1ca/0x210
> > [  561.871529]  driver_detach+0x47/0x90
> > [  561.871981]  bus_remove_driver+0x6c/0xf0
> >
> > Shall we revert this patch until we figure out a fix?
>
> I am working on a fix, and will send it out in a couple hours.

Patch is posted:
https://lore.kernel.org/all/20240806221454.1971755-2-pasha.tatashin@soleen.=
com/#r

>
> Pasha
