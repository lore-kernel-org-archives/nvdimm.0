Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8339230AAA8
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 13:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755178066; cv=none; b=Lo6IweFhBzV1oTSvOpSAU3Pav1cqcFbShJaMHLQ2yZKrrhTErcjgGc3+8Rj4N1xk9bBXXk0/3RQ/I/zXikRHMpNI12+ATV1shRsCpxMtLJ2+KyqzKo9Y73lV7xH08hKRslMcmnzfohTDN/VT28553nu+HWSCqBBdeuc2/V0d9eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755178066; c=relaxed/simple;
	bh=rKjVUqpwl17P+KMTSKwInqH48WkuPopBFLrzR8IYqTc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TpFdjo5J7pJTSKMKT8dU+KlT+GBe16HKwmqfJXWX3R3RzfdaNv4kwPd/CCuxX+n0WJnOjtRTkvIfNiqDsMGCDRGOj7fildpbe9zgG4VBXFZZbLCTe9AJrz7aqnx1QETEdIW4nQhzFe1B54o50eUUvUR0l7B52525TFpFnCk6iTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UZlMIpsn; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UZlMIpsn"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-618076fd48bso8385a12.1
        for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 06:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755178063; x=1755782863; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rKjVUqpwl17P+KMTSKwInqH48WkuPopBFLrzR8IYqTc=;
        b=UZlMIpsn1B20oXNux+lsdUyz4tjpOQdNxkyYQ2TFJ2tSTZd8og63CZIcRVUCVLL9TP
         wzZQcqGPEuuYfP2VZBIPi8tCHX3E+xShigTGTJ6A//kzSvfky2AfGCwKMnGrSjdFMxcm
         eFQLNYMlYEsT0SDPL1HzEZ4QHGCfordysK2yYh0Gg4MqqlYefRFIqJFZXUvOJTNPGsbh
         xUIJJ30kCGDtWA3Vta1ljpmIYSBrswW3rR5YaSlJxjgit9SNDSiNLIu92aEAuCenzswe
         TGmMWdueJc31iMfs25PaabMrTxzue/zjiGhVrKqRr04SSZCQulaWSc9JJYhOjnbPiIhk
         bjQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755178063; x=1755782863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rKjVUqpwl17P+KMTSKwInqH48WkuPopBFLrzR8IYqTc=;
        b=jOiDU5LhgYq/aShCstZo3eBfLl0inG3QGuJ6/aTi7uYp/K1xEB5OJbCqq8d50INHxg
         SKNIGe3TOACL6ums6xf880kUaoSUMphcrRUyLijfQqREj4xxW8InC7Tq68kMlkXNKrcQ
         Hhh/XYpm05I+MZzZ/P5nxrEVNZjvl6uR7s+frwzYg3EZdVY8tDFdiF/f2LM+MW0kTRVZ
         sdoGZPwz8Z0VR4hLkgTiGHCe4JdGeaUBExukBpWqQXR20JoEcFVZhSIm7pXxyct0R9lP
         1qc+ukPwyrqa6ucRJqSiIu+K1zU+CPniCH5EJlrwbpb6yegewFWiXcOixTREiEvazln8
         arcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtAiDMCC46vi7+q9IpVht+LkHenXkrqEdtBHhVa7dw5qX3w1EL9OzNPR7idaM+XgbngOZmvgk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxAmXy7cp+7/cYRiEpNlp7qeNRk2NQnfPb+ObeUZK9ebu+4I/Pe
	q68Z6tb08iguap7GvD2Vy9rCBIVlaUCbx7+RnWVUUT6Gz5lcuxMrrBslmwY1BKWX0IEVxkj8OK/
	mqfDck/i5T4zpbnwsKYukka45Fvi/KSrE/hKN7u/G
X-Gm-Gg: ASbGncuIPixsrEjMGVfKP/njY+5ioKQxp3ndyMwQsH9M9g0/EL/apr61ogWa+ispBj4
	Y4jPs+souvClhSXZD0r8EjqfVj0Q4OMVARSNA9efhxcZIcyk6gRl/Bjcc24gMwaHM96EP+ZHJ3d
	IOrWKRhT0+17Y7I3t06qTWzl3emqjSN9NVAvfNG55yQMC0k89EP5U49Z9mspl3V31WZGHiPbuek
	WRRpKMOdGgrEZwiy3AOzPzHoHlom5mfdXYuKgYh3AjNYCAkIY+X
X-Google-Smtp-Source: AGHT+IEu9U0pbzMYFCpXzMGkMdfavpp0q0i1lIx9CK73KOosqb3zwB/n5//3FMTW4AWTjYRn2/rUlEjYnuedieOKxqk=
X-Received: by 2002:a05:6402:c1a:b0:617:b4c9:4f90 with SMTP id
 4fb4d7f45d1cf-618928d1bcemr49916a12.5.1755178062489; Thu, 14 Aug 2025
 06:27:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250612114210.2786075-1-mclapinski@google.com>
 <685c67525ba79_2c35442945@iweiny-mobl.notmuch> <CAAi7L5cq9OqRGdyZ07rHhsA8GRh2xVXYGh7n20UoTCRfQK03WA@mail.gmail.com>
In-Reply-To: <CAAi7L5cq9OqRGdyZ07rHhsA8GRh2xVXYGh7n20UoTCRfQK03WA@mail.gmail.com>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Thu, 14 Aug 2025 15:27:31 +0200
X-Gm-Features: Ac12FXyHou1fyJhNDgAZDR7CRUt48o6SkCf0niifqm0hDvHBUXmlc4ifrrlM40Q
Message-ID: <CAAi7L5djEJCVzWWjDMO7WKbXgx6Geba6bku=Gjj2DnBtysQC4A@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] libnvdimm/e820: Add a new parameter to configure
 many regions per e820 entry
To: Ira Weiny <ira.weiny@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, 
	"Paul E. McKenney" <paulmck@kernel.org>, Thomas Huth <thuth@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Ard Biesheuvel <ardb@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 1, 2025 at 2:05=E2=80=AFPM Micha=C5=82 C=C5=82api=C5=84ski <mcl=
apinski@google.com> wrote:
>
> On Wed, Jun 25, 2025 at 11:16=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> =
wrote:
> >
> > Michal Clapinski wrote:
> > > This includes:
> > > 1. Splitting one e820 entry into many regions.
> > > 2. Conversion to devdax during boot.
> > >
> > > This change is needed for the hypervisor live update. VMs' memory wil=
l
> > > be backed by those emulated pmem devices. To support various VM shape=
s
> > > I want to create devdax devices at 1GB granularity similar to hugetlb=
.
> > > Also detecting those devices as devdax during boot speeds up the whol=
e
> > > process. Conversion in userspace would be much slower which is
> > > unacceptable while trying to minimize
> >
> > Did you explore the NFIT injection strategy which Dan suggested?[1]
> >
> > [1] https://lore.kernel.org/all/6807f0bfbe589_71fe2944d@dwillia2-xfh.jf=
.intel.com.notmuch/
> >
> > If so why did it not work?
>
> I'm new to all this so I might be off on some/all of the things.
>
> My issues with NFIT:
> 1. I can either go with custom bios or acpi nfit injection. Custom
> bios sounds rather aggressive to me and I'd prefer to avoid this. The
> NFIT injection is done via initramfs, right? If a system doesn't use
> initramfs at the moment, that would introduce another step in the boot
> process. One of the requirements of the hypervisor live update project
> is that the boot process has to be blazing fast and I'm worried
> introducing initramfs would go against this requirement.
> 2. If I were to create an NFIT, it would have to contain thousands of
> entries. That would have to be parsed on every boot. Again, I'm
> worried about the performance.
>
> Do you think an NFIT solution could be as fast as the simple command
> line solution?

Hello,
just a follow up email. I'd like to receive some feedback on this.
