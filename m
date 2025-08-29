Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4E9211479
	for <nvdimm@lists.linux.dev>; Fri, 29 Aug 2025 02:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756435251; cv=none; b=tmJtMdJeOls2xCz0BOneZRisrMiouNehDJjwMCvctCpwsp8f/iahsh6OsDe3bMxCi6SCqDuVLEaJMd2DfneHyh+4X3SSCVi2xb3FMrPytfmEwn0aV2GIs2lZ2TSnRKCKssZ+Jnw3J3YVLBtr6nEMZxKZTUP3SK9/CWYAj7hfE5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756435251; c=relaxed/simple;
	bh=1rc25cTIqjjOz8QUgkVtPyp6ikf2DOOaXB7T4eWd4qo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jjBnRfY69aM8ss/p6kp6ayMzpinz2I4RLhAiVvIxMuDnWu1wBXyciOmq5kyZon0sxJHYwXfrl+dug4DuBxePn2jP6o4f9otuTgvIiWGqH5EJUuFZJ/Bg8WBamP9B1JWaKSrCRkDgEJaF3XoZZEsp7DScpx1YBJcCHlPlac9/POQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=i4aiwDmb; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="i4aiwDmb"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b28184a8b3so18821421cf.1
        for <nvdimm@lists.linux.dev>; Thu, 28 Aug 2025 19:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1756435248; x=1757040048; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Zy6qlRujNRvsanVAYiBzYvZ4C5MT/ROGnbV1WkURNs=;
        b=i4aiwDmbS4gTqNiWxB6TKVsQukZYPgvuROmHcOojNNOtdmlsesopEZyN4370zZ5OqG
         NdAWExYXz3Ygi8ZuK5sjA8264EucZtnEwDMLJpMN/O7CRDKlqpeaN7Rah2UTN+7U6Iw0
         cCDceXp8VeSH5leOTifsBJPvTbSuST2uP42su8u6ggHWWJkK4d0D5+Pox8x6rewYz0W7
         vlMvGU0uv9I0pl6p86N0Etzvx+X6o4ubVcNAH7un+fiYlf57ks73/TqVqaa6n+GJvlzP
         YZBLIJi7gGsa47x64u28VOX7C60V2CIRyGaVniVydxtTMo5wvWxbszn1529H2Q5coB7E
         Rm/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756435248; x=1757040048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Zy6qlRujNRvsanVAYiBzYvZ4C5MT/ROGnbV1WkURNs=;
        b=cYmT2MXUz7XRU1szboP5JpS83JeJieXngZADBr5kYP6i9Z58EnDSA3yLqA1+bjHz3J
         wxOTnaP2xvPCUJkgCN6uZtdjZfgeOFhuooWLsG1OdPcFXp6FuL6/UdYnzwINdzqqoeXL
         RPudfKiMF3331ihUS4n80CDjF/DROF7m1qHr/ugellfApw7iCznEbSJg3EgCoPhMCS6g
         8vmGz4uCBaMA+PHPV8/XA71y1ilJbBUtBSIRHTwtHJg9vJr/VRQ+Ey5da7q4GZt7TBOj
         UKlnhJph7qE01Y3IVPHI58J6DoaR46s4q4F9OXOtI3N6nCRmEdMSdnop7Waof5T9nxuN
         VWbw==
X-Forwarded-Encrypted: i=1; AJvYcCVfjF+4aB1h8pMJ8lGqzpP70p8BfACv3+y5YwHB7Pr4CUrViqjOYBsNB3P+TBKUmajidq/UT1A=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwkEGBm9RaN3q8sVQe58+vagNXssK3J+IOYs1OzMt1OCM5SAtT
	jryC9V/zRkeTQ08ScvL+ycKkwJWkySZmd2KQ1oL6exefa+kB/BKvmUmWskGR+/PlFoC46MuZblD
	UBkD++qN0o3gj+L6LBSptUBsrncWt48/FD20c95q40g==
X-Gm-Gg: ASbGnctlaJUYtxCS1vzVH1KZoymHNBnSpVhqjQZiTfdzdb3+9x9v73Wh87L6yeQoXar
	LtwHDkMshg5U7YahKCuto7PEhHN2RaNsIh1fjsHQh10kqPYQwfkF3G0SruLprlFynI/Rpt1bX7k
	TGOrNLBcPVvBP5PBkCxXx5mhfzAqlEIlM/g3zELVHo4vxp/GG8U6JF6j+gGk8GqxjHRaC9aqYsh
	NEV
X-Google-Smtp-Source: AGHT+IHwXj+LBZuJEcqAH63FcF7Bf6gg8caP9O+PnQGOchIvb5/XFjh6XaIc3WnVFKQjw020TTzcQhZZqWvU0FReMKg=
X-Received: by 2002:ac8:5e49:0:b0:4b2:9ac2:686e with SMTP id
 d75a77b69052e-4b2aab4a159mr308961841cf.77.1756435247854; Thu, 28 Aug 2025
 19:40:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250612114210.2786075-1-mclapinski@google.com>
 <685c67525ba79_2c35442945@iweiny-mobl.notmuch> <CAAi7L5cq9OqRGdyZ07rHhsA8GRh2xVXYGh7n20UoTCRfQK03WA@mail.gmail.com>
 <CAAi7L5djEJCVzWWjDMO7WKbXgx6Geba6bku=Gjj2DnBtysQC4A@mail.gmail.com> <68b0f92761d25_293b329449@iweiny-mobl.notmuch>
In-Reply-To: <68b0f92761d25_293b329449@iweiny-mobl.notmuch>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 28 Aug 2025 22:40:11 -0400
X-Gm-Features: Ac12FXwmgsLWCvC9t_zrDymTIu_H7ymCFDa4DGCwoCVIx5lOzsb8sPf1krkiuUE
Message-ID: <CA+CK2bAPJR00j3eFZtF7WgvgXuqmmOtqjc8xO70bGyQUSKTKGg@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] libnvdimm/e820: Add a new parameter to configure
 many regions per e820 entry
To: Ira Weiny <ira.weiny@intel.com>
Cc: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, 
	"Paul E. McKenney" <paulmck@kernel.org>, Thomas Huth <thuth@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Ard Biesheuvel <ardb@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mike Rapoport <rppt@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 28, 2025 at 8:48=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wro=
te:
>
> Micha=C5=82 C=C5=82api=C5=84ski wrote:
> > On Tue, Jul 1, 2025 at 2:05=E2=80=AFPM Micha=C5=82 C=C5=82api=C5=84ski =
<mclapinski@google.com> wrote:
> > >
> > > On Wed, Jun 25, 2025 at 11:16=E2=80=AFPM Ira Weiny <ira.weiny@intel.c=
om> wrote:
> > > >
> > > > Michal Clapinski wrote:
> > > > > This includes:
> > > > > 1. Splitting one e820 entry into many regions.
> > > > > 2. Conversion to devdax during boot.
> > > > >
> > > > > This change is needed for the hypervisor live update. VMs' memory=
 will
> > > > > be backed by those emulated pmem devices. To support various VM s=
hapes
> > > > > I want to create devdax devices at 1GB granularity similar to hug=
etlb.
> > > > > Also detecting those devices as devdax during boot speeds up the =
whole
> > > > > process. Conversion in userspace would be much slower which is
> > > > > unacceptable while trying to minimize
> > > >
> > > > Did you explore the NFIT injection strategy which Dan suggested?[1]
> > > >
> > > > [1] https://lore.kernel.org/all/6807f0bfbe589_71fe2944d@dwillia2-xf=
h.jf.intel.com.notmuch/
> > > >
> > > > If so why did it not work?
> > >
> > > I'm new to all this so I might be off on some/all of the things.
> > >
> > > My issues with NFIT:
> > > 1. I can either go with custom bios or acpi nfit injection. Custom
> > > bios sounds rather aggressive to me and I'd prefer to avoid this. The
> > > NFIT injection is done via initramfs, right? If a system doesn't use
> > > initramfs at the moment, that would introduce another step in the boo=
t
> > > process. One of the requirements of the hypervisor live update projec=
t
> > > is that the boot process has to be blazing fast and I'm worried
> > > introducing initramfs would go against this requirement.
> > > 2. If I were to create an NFIT, it would have to contain thousands of
> > > entries. That would have to be parsed on every boot. Again, I'm
> > > worried about the performance.
> > >
> > > Do you think an NFIT solution could be as fast as the simple command
> > > line solution?
> >
> > Hello,
> > just a follow up email. I'd like to receive some feedback on this.
>
> Apologies.  I'm not keen on adding kernel parameters so I'm curious what
> you think about Mike's new driver?[1]

Hi Ira,

Mike's proposal and our use case are different.

What we're proposing is a way to automatically convert emulated PMEM
into DAX/FSDAX during boot and subdivide it into page-aligned chunks
(e.g., 1G/2M). We have a userspace agent that then manages these
devdax devices, similar to how HugeTLB pages are handled, allowing the
chunks to be used in a cloud environment to support guest memory for
live updates.

To be clear, we are not trying to make the carved-out PMEM region
scalable. The hypervisor's memory allocation stays the same, and these
PMEM/DAX devices are used exclusively for running VMs. This approach
isn't intended for the general-purpose, scalable persistent memory use
case that Mike's driver addresses.

Pasha
