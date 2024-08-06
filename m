Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AE6158DC0
	for <nvdimm@lists.linux.dev>; Tue,  6 Aug 2024 21:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722980285; cv=none; b=ujNLSB3QJAytfZbOC4j/LEwcJ6Co0dkiSX++lbXqiIp5N64dDLMY1/JYsz39S+3XvwAzIG0G05NJu/FXrHSFay0wxCiHl53XdtVVg9ZpMMxTlbZYHyUzQpNy5wbYHmBf+8FauES2y5iL/2IFji1LHKZBzpgJutCLahhVcHT3VfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722980285; c=relaxed/simple;
	bh=P+LlFXVAR3ni2Q9lpbZyAlQdpPzTbV2ToRmZ+4oEOIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 Cc:Content-Type; b=a2DCUxrKnxuGlOm/nHcxyL4Dbcddg/sfaWP+jUOIzOJZ6nmzVsghlxTAxUqfl0t3IGSy/Kig+sTTEVEJMpP+7OUt3/7HGwxrJsz8yyZD4fQuyo/GNUWCQWOigcGOySOYkZ2UTNaYOCOjPubRazCTkZuHMOPFceD4QMqvyLMusow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b=oXk23stc; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b="oXk23stc"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-44feaa08040so5759581cf.2
        for <nvdimm@lists.linux.dev>; Tue, 06 Aug 2024 14:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1722980283; x=1723585083; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9XmlWe99DKTvSLptoxepSTHSiK1+FbVsnMpcepxt5N8=;
        b=oXk23stcTfZqbWNQBIa9AJZbtVIBYslV2ahI1aUE8WOabyFLhsoPiMLOnfn8lUIee+
         B52B0Rn6mzowiwe54M/2iq7+TIHnDzVtIW+NjAHgj63qfuUWMhQrhWZ6TbZj0IQyt6ck
         pk4Ih7WtbMyQCiG3tASaZh/zn+nnjyAinLceIB004V1RuVh0bIZyGugpsfuP6k77HLPI
         4oZ3fTAK1RieHeaeXzw26B4P9Ba35KuG3T7HwFejrbsYc5xy3i90EDsIHd0F86mi2JQb
         uaBfaV9xrT6t5uOxoN1+D3FASdBs9CQRnUs7rfYKhOdzj+hjAExF1ptDIjTBRRBvHU+/
         hpuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722980283; x=1723585083;
        h=content-transfer-encoding:cc:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9XmlWe99DKTvSLptoxepSTHSiK1+FbVsnMpcepxt5N8=;
        b=i46rUChl+A/wPJJrZj2ujrHF7mDufkh6i8rjGLVa9fKKuDUvm0xE07RMoMGg2Tzww0
         i+WpXi6Km2DZtaXo8hE2DK5756Esp0nZDRhpoGTFF+QmXc+XubJCpjxh2XJdf03aJSyF
         NYi2rnQUw9940YB/K3eGcvTeOcLCsiUWvK0W7cjLDKB1IcwqwWAQZ96MO0uhYdFAk20v
         m+D528UmT0Z9U2QoUEXLWRigBK2t8XmZztcBdhiiPJO21EBh5OZUaS9oU76PeGiyBPJO
         KJu1ELrwC5tinpdsRXem61+1KB13bI8/CHxiLvZKDb8elI8nqq4sn6h8bFtaW7UMLjvu
         onUA==
X-Forwarded-Encrypted: i=1; AJvYcCW5YNf83LyOHDyIjphDgpyAhhu23yiA37FMZo2XbO+sDs0/BLfYbQmUbllQ7f33xLrQTSxl7QlbpG5qqGMS6jJ8dMs88mjj
X-Gm-Message-State: AOJu0YzNHvisr0Sg2S+k6DTkuvqIz+MKthmX/KANHLYXdaI7tr66YR1P
	dqdCYpjnmo8rYjtg/i57skZj32sKCpy8Oe34Nn53Jp1uy0+UMFXbZzTElqSxdyjz4OXE0sVan1m
	Ms6Q669d5UtTJPKUf+tg/Jd+pE8YZ4XvJZcAC5g==
X-Received: by 2002:a05:622a:1825:b0:447:dc9a:1cea with SMTP id
 d75a77b69052e-451892561c8mt209894091cf.13.1722980282606; Tue, 06 Aug 2024
 14:38:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240605222751.1406125-1-souravpanda@google.com>
 <Zq0tPd2h6alFz8XF@aschofie-mobl2> <CA+CK2bAfgamzFos1M-6AtozEDwRPJzARJOmccfZ=uzKyJ7w=kQ@mail.gmail.com>
 <66b15addf1a80_c144829473@dwillia2-xfh.jf.intel.com.notmuch>
 <CA+CK2bC1ZsT3cuAMDAAUonys3BUxbb2JdnZXs1Ps3NbYZt5W2Q@mail.gmail.com> <ZrKNKRfaH7GliS3C@iweiny-mobl>
In-Reply-To: <ZrKNKRfaH7GliS3C@iweiny-mobl>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 6 Aug 2024 17:37:24 -0400
Message-ID: <CA+CK2bDnJsgjK-7H-8qJjdeejKJk7E7m-SDnwXatH4FHr4R0_g@mail.gmail.com>
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

On Tue, Aug 6, 2024 at 4:53=E2=80=AFPM Ira Weiny <iweiny@iweiny-mobl> wrote=
:
>
> On Tue, Aug 06, 2024 at 01:59:54PM -0400, Pasha Tatashin wrote:
> > On Mon, Aug 5, 2024 at 7:06=E2=80=AFPM Dan Williams <dan.j.williams@int=
el.com> wrote:
> > >
> > > Pasha Tatashin wrote:
> > > [..]
> > > > Thank you for the heads up. Can you please attach a full config fil=
e,
> > > > also was anyone able to reproduce this problem in qemu with emulate=
d
> > > > nvdimm?
> > >
> > > Yes, I can reproduce the crash just by trying to reconfigure the mode=
 of
> > > a pmem namespace:
> > >
> > > # ndctl create-namespace -m raw -f -e namespace0.0
> > >
> > > ...where namespace0.0 results from:
> > >
> > >     memmap=3D4G!4G
> > >
> > > ...passed on the kernel command line.
> > >
> > > Kernel config here:
> > >
> > > https://gist.github.com/djbw/143705077103d43a735c179395d4f69a
> >
> > Excellent, I was able to reproduce this problem.
> >
> > The problem appear to be caused by this code:
> >
> > Calling page_pgdat() in depopulate_section_memmap():
> >
> > static void depopulate_section_memmap(unsigned long pfn, unsigned long =
nr_pages,
> >                 struct vmem_altmap *altmap)
> > {
> >         unsigned long start =3D (unsigned long) pfn_to_page(pfn);
> >         unsigned long end =3D start + nr_pages * sizeof(struct page);
> >
> >         mod_node_page_state(page_pgdat(pfn_to_page(pfn)), NR_MEMMAP,
> > <<<< We cannot do it.
> >                             -1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)=
));
> >         vmemmap_free(start, end, altmap);
> > }
> >
> > The page_pgdat() returns NULL starting from:
> > pageunmap_range()
> >     remove_pfn_range_from_zone() <- page is removed from the zone.
>
> Is there any idea on a fix?  I'm seeing the same error.
>
> [  561.867431]  ? mod_node_page_state+0x11/0xa0
> [  561.867963]  section_deactivate+0x2a0/0x2c0
> [  561.868496]  __remove_pages+0x59/0x90
> [  561.868975]  arch_remove_memory+0x1a/0x40
> [  561.869491]  memunmap_pages+0x206/0x3d0
> [  561.869972]  devres_release_all+0xa8/0xe0
> [  561.870466]  device_unbind_cleanup+0xe/0x70
> [  561.870960]  device_release_driver_internal+0x1ca/0x210
> [  561.871529]  driver_detach+0x47/0x90
> [  561.871981]  bus_remove_driver+0x6c/0xf0
>
> Shall we revert this patch until we figure out a fix?

I am working on a fix, and will send it out in a couple hours.

Pasha
