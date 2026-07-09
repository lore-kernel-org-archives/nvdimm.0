Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6552E413
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 00:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555574; cv=pass; b=ScPCXLaSjvIGu7M9bkbEBgfCjTxencvoEVhFiDFIRl69OXCI0yJIl7q94KGMUrYVYqaWTfxWr820vpgrSS/IFw8ePOK1F6/aBJW8XHZQLcniQPJNvt0ZC4OG4uWyenPt6PMH59u/gtf+cJCWWVYFydXshrC7a8sDiyrF8TYv8lw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555574; c=relaxed/simple;
	bh=4EuRdo8+QeN+yDW6A3X+o12IBSIMc42jYmwxuetdwEg=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fMd2yOmStY8nFDasfbUN811LLnxgF1KaoH7huAelGw+MxkHKRIOQoi6xHl2nYaInOJsonI4A4EM7k2TW1/1I6EIfro8A3QxuJB4SVQahNjBQP/GYOHMi74zPstN6R5nBQgM3CHWoAEHLR6meYaHUqwKIq+7OAluDoIvUR0WBeA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XKtvWcaU; arc=pass smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XKtvWcaU"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-36b9d265355so1214170a91.2
        for <nvdimm@lists.linux.dev>; Wed, 08 Jul 2026 17:06:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783555572; cv=none;
        d=google.com; s=arc-20260327;
        b=d8e9M6zqvf9lPQiAXnzUMfvmZqJOwMBxnO49IdIGO52wlsMBNaJ8D1gZhnpMVmNUjB
         0Owpq7z0oKQky7aQNyD0eP2baxx+PIFL9g0u6Be0RL098ofu7fU+5fKmuJmYTnkVNBez
         HczAfXfebmqemgdz92T1gxSfCxxqPiOOejF/MZM8GfIA4OF8FfqPVqMVluuhgdFMP4wa
         3IQf/XlkUwgA1nkgjRnMdJOAyIPgJF2T0c2TE0CkccCC1fDeCHxsyNfrIPj/C3+tiG+O
         WVzLmWMEfoVeoP78OmR79vExu8nQ3n3tB7RrrpCtwRphspYA6FkRvyIcOIc5heQfDVmT
         smgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=LGyVs/ziq+v8OBPSx6ZOv0f1yGdel9dIe8uNrAG5/8g=;
        fh=ZpvQx6Nlg8j2TYiNWnVAb/AXMSnEk3ILndwiowGoe30=;
        b=DWTFNmqzAQkMtCHx3NTAyVbZC6m5uBlytMjwCgzFcgkgUZAV8E3oDrDoolxQ4TM3+P
         nxPzZ/R60+36jpFE2SjV08BOh24gYe1+M2N+PHKGwpr+wJ6ohUXpzQLIRMvE9wfd0p3a
         +dW7VaGuggUTDWB/9mcpXcVbz06r+vsK+rIqY81Iip4k/VakdV5Cu8Uhqa4/9va0g965
         S2W5owRSjl811zYxCQJVSTKqQ9oeex2NXCqIwRN4nuanhn5nCMJ9unS2JtqIRnX1eAiz
         sVO7rD3IgHtTQy1jftmilcumFxM8bwHjhH2x0Y9DwnVSe/evgX2+W4ZdZMeObpYH5yBY
         nScg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783555572; x=1784160372; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LGyVs/ziq+v8OBPSx6ZOv0f1yGdel9dIe8uNrAG5/8g=;
        b=XKtvWcaUeMg37vNhALFpyIhrbaZf5r2T1KGTcH7mIQ88xMehpr+Gv0Tu31bihIsb5x
         OMdZXajFAnXwtfczv8SHsVuP6JGoBo34OJljB03Zqn807vm5XGFW/H3M1bNtOsF4jlOt
         ZDMpvdPf3EE5xH4HRvdmUu+/jHSuJ7uxHfuboG2vNnR0csggcQ9d77WKp0EBx8AtuEab
         A6X1aIyPJ7KzhdXh880J6ld2TfyJ5r02PHuzlwThux4aajKFIA4mfJH1R2ZJk+jf8vHv
         +u2ol16KYg/zpSVPxjez1KKyQPicmonSuyfwCky1NVRsp/sFx/USbFABsb7lgtCIaE1O
         DuuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555572; x=1784160372;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LGyVs/ziq+v8OBPSx6ZOv0f1yGdel9dIe8uNrAG5/8g=;
        b=nlxPMSBOM7/lwPOLOKqxq8Bv9Id24iuAdEzRo4JNLkdQ39dBa3uKvyGoCxJbHIEAPM
         hiOOAMrKuDjxQY+Pk30wE7zWdHrj5Bi3y6/BbRTkWw6gQo8P95+ynx1B41PD7fsuvSko
         IYJhRYJnitoBL6LkCa4y5Xh7VfPhZ140GM1lmkDM+BfZcvzx9MSfkZG7hi2MusXYo0Rh
         UqsWES0KmqgSGF9/6R629MLfglHpyhYQbCl9zZ7+aEI2ldOT74pDLCQwl8cvG2ZydEcj
         wlAuP2qNpim2uxnsz7aBoEFvh97IXR2xeWIltwypS5evs61X2wmVe4W6K/2LzbkFjLDA
         aXtg==
X-Forwarded-Encrypted: i=1; AHgh+RoZ/lc1P6dhnuNUKSqxLbEA9b897WjaqTAeezgx75+Jpf962g/XlXFrpXEAlCK04qW/aA+vL4g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxIuwY3ApW9cxaB//itIGG9AlYYiphBmkEQA2+YK6NEKDZXBF2D
	8EJE0ddPnEskyM/ugCkpyat8GZeNyxZxGdz6CWKqkZmgu1L/01wbW4tbApni4Ex2KWk1zCEhda1
	zZYjHgXmd5Jza1qIPWUXOnXLejeyU+TiDKnDL/Wwy
X-Gm-Gg: AfdE7cnwqyAq9xfZVZKwqfj2LTQ3UoNzhCD0s7ePV558lU40r/MuLDUQ03C3GZIAKWz
	3ZOSsgsnD2HTrQS/cau0W1QCeKFUdnSpekp6PG7Y9JOni0sJBxwy3j9pqzFnFDNsSw5JvwfTRnO
	cIBril/SSf11IuCRFqEJeWpXFNFbvmgYLILGERwBnu2h2NQvM2fLv9vYnB+dKtdK9S8wRHryWzh
	beKAdXWlIV07fjKc9vKXMKBLgHKeq6HYDm687Z3VaM0HS0LKCZ2VmajNorkcz74Eg5LQVs1Fupq
	23I0UrpxB1WcTNXFeGAcWOdtDxN9tUsfHFKQTDLFvDKxDbuy2F9dYN4o/XA=
X-Received: by 2002:a05:6a21:1f88:b0:3c0:9c19:b27b with SMTP id
 adf61e73a8af0-3c0bcce9940mr4979424637.73.1783555571036; Wed, 08 Jul 2026
 17:06:11 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Jul 2026 17:06:10 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Jul 2026 17:06:09 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <bf56e2e98b512962a2fb88900d535a0e9e6769d8.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org> <bf56e2e98b512962a2fb88900d535a0e9e6769d8.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 8 Jul 2026 17:06:09 -0700
X-Gm-Features: AVVi8CdcseowPqFId5ObGoqB8gTqCLO4QEXGH1ZjH1-pjTCLGI84NpwTLe_LrAc
Message-ID: <CAEvNRgEV9VkWHULS4g5hVHu3T6=YZ89HJmkv6rS0+hK=5UFu6Q@mail.gmail.com>
Subject: Re: [PATCH 19/30] mm: use linear_page_[index, delta]() consistently
To: Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Ian Abbott <abbotti@mev.co.uk>, H Hartley Sweeten <hsweeten@visionengravers.com>, 
	Lucas Stach <l.stach@pengutronix.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Rob Clark <robin.clark@oss.qualcomm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
	Thierry Reding <thierry.reding@kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, 
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-mm@kvack.org, iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"

Lorenzo Stoakes <ljs@kernel.org> writes:

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index db57c5766ab6..f0e5da490866 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -440,7 +440,7 @@ static int kvm_gmem_set_policy(struct vm_area_struct *vma, struct mempolicy *mpo
>  static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
>  					     unsigned long addr, pgoff_t *ilx)
>  {
> -	pgoff_t pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
> +	pgoff_t pgoff = linear_page_index(vma, addr);
>  	struct inode *inode = file_inode(vma->vm_file);
>
>  	*ilx = inode->i_ino;
> --
> 2.54.0

For the guest_memfd change:

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

Thank you!
