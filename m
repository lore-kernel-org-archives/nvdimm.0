Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1AB27466
	for <nvdimm@lists.linux.dev>; Tue, 22 Apr 2025 13:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745327479; cv=none; b=BkcTCrPii9BSnFRY3/z+mtYIuWVFIPXXyZQuKYR4yvn07/opE2z1GeGJOXQHuLOXdrVzPrrUbsdokBo4Z05SsjIOQWNnd1f7/zb1yGkEPGlpW4uRlzr4Uj0ToD6XeLOjaJeYNVHGDuoxi+GJpdDll32YNHfeI578UMtjRwyYnAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745327479; c=relaxed/simple;
	bh=5VUtM3MlpqncXQIwvD7wi3URCc9M4jwjzUC4MjA9r/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Me0Ya+EGl/yGDnHICPEOyDNHgUk7prOk6biF8aocLfDOyDFJpRZTajXVcMbuiiHd3C5RzMo6jbpB6gGdkciUWXsMNuFtk7cRSE1dL/q+WT7MAV92WQh03rtpUI4q6QHEiTOh4ShXmEYbLGVoWAxLBoQKUQv/MZdw7nkNRGgsZLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b=h6FhjcBh; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b="h6FhjcBh"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4772f48f516so60034751cf.1
        for <nvdimm@lists.linux.dev>; Tue, 22 Apr 2025 06:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1745327477; x=1745932277; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5VUtM3MlpqncXQIwvD7wi3URCc9M4jwjzUC4MjA9r/s=;
        b=h6FhjcBhqhpAopRAYh0Ew3or5T7zPzrWOHqxRobxx12atnU+BVd6oY6DLgrZc4OqFR
         VqSny7A1grSWgbWucUqLplFdaHMQqhYaLV82HBzgZ5nnxa27Or5CkhMXnulrcjp07huR
         rvl28RyqrN4EPL0oy7oFyHoQgTbmmu8mRlB8tfx7VGPoJWfrevgtQTwDuIzBD4Fx7QQJ
         geJC7XBbEsiRAfXUeZx7bc5K5xvPlLrDM/nEql72vtbiOEK3axllzZweeDCCqFtwdXUt
         npEpdTNnX5gmSBuL6V6juPqIVmgd7u1BmM6v+RY2bcpoSxoaYRP6z+WGCvG+ubqGn3Pb
         6GPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745327477; x=1745932277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5VUtM3MlpqncXQIwvD7wi3URCc9M4jwjzUC4MjA9r/s=;
        b=azxrSMPii8GELawDISEdLD72Nf1gP3WQhrvk4wSbZbO/l3CxeTvBRH8Hhmng6Qt++D
         iIjqymem1y+3zjNvAwW8VbFO4xxmBaLNfDAx8bIrMPUjwRLdCYkOTeXgudva/BqGev+g
         malm05FkQOMYCzFVkcaJZhM2GKPHp7A0DjtNZBAHoZA0hQZC13NaPbqmZqMHJdfuT0vT
         h1mzGuJQo3cAc+bpjeEXy0M0D7Lk5leqbwkdTgU3f4gVqZqPepiONcgMc+wp0e6jBQrU
         gKzbh4ydVRemfitXbyWNQIkWP0ZgjHAjDSqA0wmHKgz1GLs4t4xlCXKN9PK4+iHyHjyR
         27FQ==
X-Forwarded-Encrypted: i=1; AJvYcCXloRr1wvMzgiRh0sulwsp1U3PuhrnCTAntnptXXExyKT+ABLth7+2Czh4PZFni6dlBebw/0Cs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz82pKDcFm8aDwR5FCmfXM2rNy2hpqYa+4GpjH6r//7Ts+ypTxz
	UkdSSho72rS8aPEa+TNkst2yqNnMcmOHsyYe1nDcB6OWm3plv5HH2NjmHwoGQJvuAHIRajGlCwa
	rSz/M0ZE/xKASV2yP6HuUnKxCaoW9e48EGK60vw==
X-Gm-Gg: ASbGnctdTrhFS6HmQSZyJd4vxee9tbHvvVN0gddXALlxDvFA0IZ1OgTkez9xSjiGf65
	1KYwy2mnWfdNMCUVUBBDw9/IjxWDh8nLBxHkkI7Cw4hFZfbKpLfoRW9Z1pqZxksOEBjHoMnvdgq
	iUZEmuEZ2GRX3Shxv5m+0=
X-Google-Smtp-Source: AGHT+IEgeN5s3ZfRGLUDH5gOqfcD4s6TEi5D0C2g77HjKlzUHwkH9XonjRLYuHi/ar2d9oTr5N5VxEPTjm/oRIIx8No=
X-Received: by 2002:a05:622a:1c19:b0:477:84f5:a0b with SMTP id
 d75a77b69052e-47ae96515c1mr280374181cf.2.1745327476964; Tue, 22 Apr 2025
 06:11:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250417142525.78088-1-mclapinski@google.com> <6806d2d6f2aed_71fe294ed@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <6806d2d6f2aed_71fe294ed@dwillia2-xfh.jf.intel.com.notmuch>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 22 Apr 2025 09:10:39 -0400
X-Gm-Features: ATxdqUHTas6nxRBSgtwdGV4WIXumv0Kkcfrqb-O571C2uYrggyHxMo9DW-cOmcA
Message-ID: <CA+CK2bD9QF-8dxd92UBoyvO0rBJ3uTN27pXzO2bALw4v_2D_8g@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] libnvdimm/e820: Add a new parameter to configure
 many regions per e820 entry
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Clapinski <mclapinski@google.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 21, 2025 at 7:21=E2=80=AFPM Dan Williams <dan.j.williams@intel.=
com> wrote:
>
> Michal Clapinski wrote:
> > Currently, the user has to specify each memory region to be used with
> > nvdimm via the memmap parameter. Due to the character limit of the
> > command line, this makes it impossible to have a lot of pmem devices.
> > This new parameter solves this issue by allowing users to divide
> > one e820 entry into many nvdimm regions.
> >
> > This change is needed for the hypervisor live update. VMs' memory will
> > be backed by those emulated pmem devices. To support various VM shapes
> > I want to create devdax devices at 1GB granularity similar to hugetlb.
>
> This looks fairly straightforward, but if this moves forward I would
> explicitly call the parameter something like "split" instead of "pmem"
> to align it better with its usage.
>
> However, while this is expedient I wonder if you would be better
> served with ACPI table injection to get more control and configuration
> options...
>
> > It's also possible to expand this parameter in the future,
> > e.g. to specify the type of the device (fsdax/devdax).
>
> ...for example, if you injected or customized your BIOS to supply an
> ACPI NFIT table you could get to deeper degrees of customization without
> wrestling with command lines. Supply an ACPI NFIT that carves up a large
> memory-type range into an aribtrary number of regions. In the NFIT there
> is a natural place to specify whether the range gets sent to PMEM. See
> call to nvdimm_pmem_region_create() near NFIT_SPA_PM in
> acpi_nfit_register_region()", and "simply" pick a new guid to signify
> direct routing to device-dax. I say simply, but that implies new ACPI
> NFIT driver plumbing for the new mode.
>
> Another overlooked detail about NFIT is that there is an opportunity to
> determine cases where the platform might have changed the physical
> address map from one boot to the next. In other words, I cringe at the
> fragility of memmap=3D, but I understand that it has the benefit of being
> simple. See the "nd_set cookie" concept in
> acpi_nfit_init_interleave_set().

I also dislike the potential fragility of the memmap=3D parameter;
however, in our environment, kernel parameters are specifically
crafted for target machine configurations and supplied separately from
the kernel binary, giving us good control.

Regarding the ACPI NFIT suggestion: Our use case involves reusing the
same physical machines (with unchanged firmware) for various
configurations (similar to loaning them out). An advantage for us is
that switching the machine's role only requires changing the kernel
parameters. The ACPI approach, potentially requiring firmware changes,
would break this dynamic reconfiguration.

As I understand, using ACPI injection instead of firmware change
doesn't eliminate fragility concerns either. We would still need to
carefully reserve the specific physical range for a particular machine
configuration, and it also adds a dependency on managing and packaging
an external NFIT injection file and process. We have a process for
kernel parameters but doing this externally would complicate things
for us.

Also, I might be missing something, but I haven't found a standard way
to automatically create devdax devices using NFIT injection. Our
current plan is to expand the proposed kernel parameter. We are
working on making it default to creating either fsdax or devdax type
regions, without requiring explicit labels, and ensuring these regions
remain stable across kexec as long as the kernel parameter itself
doesn't change (in a way kernel parameters take the role of the
labels).

Pasha
