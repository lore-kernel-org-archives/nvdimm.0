Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA43A1D53C
	for <nvdimm@lists.linux.dev>; Tue, 26 Mar 2024 03:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423974; cv=none; b=C2q/PrvAQ1LrTkYQsn9Yvr4AwkIPS+Tgt0vMgJtW3HWtnmRyuYQELjMoSj2/g6DFllowNDuYfN/UCwsxbpvom/D0C2NlI4qnI4RIqDYeVFOB7VFxH4FzHn0I+cJ8yyMng51OKHXeQ9EH5zunK2ayJb1PerdxbOWvul6Fzgq2Kdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423974; c=relaxed/simple;
	bh=f5P7jXuaPxF8gxKTJOiUPKZMuLKQpBGNZmyCMdfpQew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W8AGvVYmbVUe2apVdz2PsqbPJLgZQSM/KTAOfUD01iaYVo2ZMihkLuX9HAWNCoMwYKUsWAoNAQKu8LyM3KyBqleOwEy0bpgzUuPxFU//s0GFX3sbIuqmt9ji0GzmL1Uffn5h8/1Mg/sa7QspryVqnCUKldOdm70XjBWKMZOhlbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cwfF4zYJ; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cwfF4zYJ"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-341808b6217so3174798f8f.3
        for <nvdimm@lists.linux.dev>; Mon, 25 Mar 2024 20:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711423971; x=1712028771; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lA5o6h754u6ODWqcXZI/yfZmhgXKlz5ceCEo4tpQucE=;
        b=cwfF4zYJt2O1RninzlfroUoMSHcuXfg8POCAcDEH9ZbHLqAXqXTJYQCoQ2hDeMTU29
         JPPKh5fhvIwiU/St0aJWCoJwTmJ1R4WdP8B8D0HUWfoyNIJUJFan9M9ohDZEqkgNeCWS
         ii/1L+SwNjO1bHzkaemfAm4FIobDo77YWrw0GdzVWMUoYL6mpTRFJ0Lxi39K0WvjGiKc
         kkNO+9uIr2q11ESZU4ARwVY5ejqjzvkp1mcH/lbIYbHG1+NIRaZyc8bJrtqSjheICJRj
         FpPL+9A1X22AslS8SRlQUVx9m9btc3Nd7/XHErunxyaha3TIZ8xWztr7tvvcjMxLDKhh
         rfXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711423971; x=1712028771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lA5o6h754u6ODWqcXZI/yfZmhgXKlz5ceCEo4tpQucE=;
        b=DLLm2Cjl0K4xUYur5yU+jyqLXtXmv4VvXfegUqHtM6RyB3CqVygyQa4PwtJwX2kIfc
         2zGWDYU4oYtb54wSaPrt+8LDec76MzygG+ZV53B3gpdfFvVUA/11wTtnAvg/yDEdFkWd
         AUe6r/B+ezrSnh6p0VGhqxehP+QcITiExr4zv/LKpnU+6qYA97dPWq2Y7fF/TnTd6e2w
         kqZxkHAd67Ntp+iGHcPJ85t90m4t+mcKs+jPUuEIcZK58mb0WJ+PfN4nyWVTuQiy5oil
         3Nt06thm/hy4Xr59VUkAoGvamI+CMXu0tVOEKy5vZEh9I39Iqhe8qF8yWDLHrP3Oablc
         5M6A==
X-Forwarded-Encrypted: i=1; AJvYcCUM83ZtvSRPnUd0+LTvjJ5BTZ8/VQxIggFPY5fCSyZmzW9quGrciTrN13a271j0QIbL64BT6VkUzCY8TxdkPsEkv1Qhftbd
X-Gm-Message-State: AOJu0YzUJYl1nmwKz3iancM3OQTL/7vDw87dZpNbYn0dKT88iT/gj4i3
	25t8UAe1gBA8E8z/Hv5wcmvc6RZ8vncgdcPqazn4mhubLDmkrsfsl098nN9uhoE2E+y4v4MesUp
	2XorZv6BKb1WqM/PrTfI6l+UPTUA=
X-Google-Smtp-Source: AGHT+IFQ9mbx3pz3lWDfK2p6wsj2aDG+6I6RjpqCge2Sd5poBB31E3vi/9DrtwhPj4IF4gJiiqaho8oQ5gTSaHJ4YJE=
X-Received: by 2002:a05:6000:120d:b0:33e:a5e1:eccc with SMTP id
 e13-20020a056000120d00b0033ea5e1ecccmr5218777wrx.68.1711423971122; Mon, 25
 Mar 2024 20:32:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240326021656.202649-1-rick.p.edgecombe@intel.com> <20240326021656.202649-3-rick.p.edgecombe@intel.com>
In-Reply-To: <20240326021656.202649-3-rick.p.edgecombe@intel.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Mon, 25 Mar 2024 20:32:40 -0700
Message-ID: <CAADnVQKHtRX2WS9c2qcMUJTmNNda+attkXoiNurFyMKvHNfa=A@mail.gmail.com>
Subject: Re: [PATCH v4 02/14] mm: Switch mm->get_unmapped_area() to a flag
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Liam.Howlett@oracle.com, Andrew Morton <akpm@linux-foundation.org>, 
	Borislav Petkov <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>, 
	debug@rivosinc.com, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, linux-s390 <linux-s390@vger.kernel.org>, 
	sparclinux@vger.kernel.org, linux-sgx@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, 
	io-uring@vger.kernel.org, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2024 at 7:17=E2=80=AFPM Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
>
>
> diff --git a/mm/util.c b/mm/util.c
> index 669397235787..8619d353a1aa 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -469,17 +469,17 @@ void arch_pick_mmap_layout(struct mm_struct *mm, st=
ruct rlimit *rlim_stack)
>
>         if (mmap_is_legacy(rlim_stack)) {
>                 mm->mmap_base =3D TASK_UNMAPPED_BASE + random_factor;
> -               mm->get_unmapped_area =3D arch_get_unmapped_area;
> +               clear_bit(MMF_TOPDOWN, &mm->flags);
>         } else {
>                 mm->mmap_base =3D mmap_base(random_factor, rlim_stack);
> -               mm->get_unmapped_area =3D arch_get_unmapped_area_topdown;
> +               set_bit(MMF_TOPDOWN, &mm->flags);
>         }
>  }
>  #elif defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
>  void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_sta=
ck)
>  {
>         mm->mmap_base =3D TASK_UNMAPPED_BASE;
> -       mm->get_unmapped_area =3D arch_get_unmapped_area;
> +       clear_bit(MMF_TOPDOWN, &mm->flags);
>  }
>  #endif

Makes sense to me.
Acked-by: Alexei Starovoitov <ast@kernel.org>
for the idea and for bpf bits.
