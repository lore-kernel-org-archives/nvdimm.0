Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5390E272815
	for <nvdimm@lists.linux.dev>; Tue,  1 Jul 2025 12:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751371593; cv=none; b=kPGl/iNLUExIy5OzJ5L0HXp9CJYFFY+HLjjohwSA4yXHKqOIAU+U8Ak9GbIwxQQWAIs19WFaCv29r3wry8mDo2nD3SyFWR61VjLv/1eid8Gx8o/3tv/UMibEnId5MDaI1V65jyMHwSFGahFI/kkBAMjH+eJVC6Ll11CKMJ1HTXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751371593; c=relaxed/simple;
	bh=fwZQhFulCtk6W9St9reCgVe3JkeISDZLWskJCaogHtY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gdwFi9eQLXtLKOkb1/sHxyKpihA86/2ybrvMLQhTR0Ziv7hQfmfrURbYQqNgfve6SwPNpgOIBuyizsGm8p+mQUQgt6kU1Ry0uS4y75gZ0wFkmF9S0wi0aByxMB8xTIeSEOA/neRIV7NjG9ffLEZ9Aoiv7p6ZLnXb+TaaFPC+B54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eKlY/yg1; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eKlY/yg1"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2357c61cda7so114245ad.1
        for <nvdimm@lists.linux.dev>; Tue, 01 Jul 2025 05:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751371592; x=1751976392; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fwZQhFulCtk6W9St9reCgVe3JkeISDZLWskJCaogHtY=;
        b=eKlY/yg1cUhyQcH5EQF2rw/osxkm9ll97drDqIYdHMCl+EHm1rFmxckLG2WVs1SCEd
         xVSfooMGvcHsqJVh3t8N3nj+Dfp7HXhqvGxvlcLKUCmhlb+XbiGWsX+ML7Be89Rkaqlb
         0eVD/kV9pGchmt2YYNYCZq6+ycNQg3vBIHAhAB5C00sPE1LzrhVOn//7dZAGpYBVGp4K
         hyeBmCMiAeWsQsly+HoiUFaBV5j808K17mkgWg/idWV0lSbSzuJikrQcBPw3fOr33ejk
         V2xn6XsedL3/9Yumdm6RtzhYwxglQ5qWP8JDDAgbVDdSrRz8zJ348MPUwZ5FUfFu288o
         S3vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751371592; x=1751976392;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fwZQhFulCtk6W9St9reCgVe3JkeISDZLWskJCaogHtY=;
        b=vvikXtObCRdufZZuLa+rjyNJFlD5UaYi9/eNmJFEm2DRJQRzzrVEiJE4IQCNKOwu9V
         AhJRRgUILv+D06rJTwADc3uCJZcTQtcvmNgBGccXPvkutAY4/p1f0XqBtHao7hgWFV9+
         h7vzyiNivSnjUJJz3J0270wYvAcXB3Jn41Sd414eOhqK1MF6G/xS8d1FQ2n+/BtrHi7+
         ERUrZhZcZ+3jwDx2n4yJG2dkv+ny6QI2mCVkyxxq8G2ZEf8e5U8Eva/IMZJfYZx10/Hc
         4UBjIIw+vhraZzCnq6R+52xINXRlAhnA6ltbz0IJaBcATkf+GFhgMjTIbZd0deCuZvvB
         R9DQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKM2sIsvc3Z+SHbxDy8E74Smwd2QAfSr2Qo/djbOEnM/FzKRG8NEWS5L3XVs9v+dYU6Lrxmlc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyhjRFDdObZiBTh7PpsejRTtkItLA4XKeWqhIw4zpZj5zCQv1kt
	A78XWiIX0dppLqbsUWLYYSEcs4XWvY2/JUsvRAyb8MEe9TJztdkdCY3KLPkTrG+NuC497DqmLAi
	xDG7VPDO9P+Jqmus29JRRcDr4XI2Q+kFLhcEdBpUm
X-Gm-Gg: ASbGncsEjsgrJDILL6hhh65cqlUOxt9Z2iF1ifk64Zzhnr+lNkXtFK1aeV96RFyxgH3
	p2XyI78MLXipHyJkpw2ngSVwdY/fipmsujrTPsqqwdEcUmGZ/9JzPSCA6qZ2mg3nRn7VIc0Xbbn
	Lyt1+PlQVSbxnD/DG1Cu1q5vWa5UF615r1Lk/VCVLGDA==
X-Google-Smtp-Source: AGHT+IGFAwjulo/i4stzSeDZyvangI+UZ0rJXA7wz0l2gf+G3c7FdoUDkNvfVQlKGJ7tNf7XQG97q/uJgkbiheh/1nA=
X-Received: by 2002:a17:903:110d:b0:23c:5f63:b67 with SMTP id
 d9443c01a7336-23c5fef26b2mr2103895ad.4.1751371591226; Tue, 01 Jul 2025
 05:06:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250612114210.2786075-1-mclapinski@google.com> <685c67525ba79_2c35442945@iweiny-mobl.notmuch>
In-Reply-To: <685c67525ba79_2c35442945@iweiny-mobl.notmuch>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Tue, 1 Jul 2025 14:05:59 +0200
X-Gm-Features: Ac12FXxGIEan-Q08VvikT9LVQKRxgvs42efMWiz53YaKommHJZr1vh6fiZw9HYE
Message-ID: <CAAi7L5cq9OqRGdyZ07rHhsA8GRh2xVXYGh7n20UoTCRfQK03WA@mail.gmail.com>
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

On Wed, Jun 25, 2025 at 11:16=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wr=
ote:
>
> Michal Clapinski wrote:
> > This includes:
> > 1. Splitting one e820 entry into many regions.
> > 2. Conversion to devdax during boot.
> >
> > This change is needed for the hypervisor live update. VMs' memory will
> > be backed by those emulated pmem devices. To support various VM shapes
> > I want to create devdax devices at 1GB granularity similar to hugetlb.
> > Also detecting those devices as devdax during boot speeds up the whole
> > process. Conversion in userspace would be much slower which is
> > unacceptable while trying to minimize
>
> Did you explore the NFIT injection strategy which Dan suggested?[1]
>
> [1] https://lore.kernel.org/all/6807f0bfbe589_71fe2944d@dwillia2-xfh.jf.i=
ntel.com.notmuch/
>
> If so why did it not work?

I'm new to all this so I might be off on some/all of the things.

My issues with NFIT:
1. I can either go with custom bios or acpi nfit injection. Custom
bios sounds rather aggressive to me and I'd prefer to avoid this. The
NFIT injection is done via initramfs, right? If a system doesn't use
initramfs at the moment, that would introduce another step in the boot
process. One of the requirements of the hypervisor live update project
is that the boot process has to be blazing fast and I'm worried
introducing initramfs would go against this requirement.
2. If I were to create an NFIT, it would have to contain thousands of
entries. That would have to be parsed on every boot. Again, I'm
worried about the performance.

Do you think an NFIT solution could be as fast as the simple command
line solution?

[snip]
