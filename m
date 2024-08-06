Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BB440875
	for <nvdimm@lists.linux.dev>; Tue,  6 Aug 2024 18:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722967235; cv=none; b=LmaAErphxbG+2G3uW6oOvis6NrzrdfQyl69oHvJpjVVajBxvXQZdOLn+IBCupki7BHByWGVvtPWNLvZa8nVqZvFv6may/Neuqz5FatLwWDYuNHEC3KhWcP1nHO9m3aQiWRkadM6EK5EbgJ+VGMK9Xu0earpMbNJ5HPA7QtnSTkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722967235; c=relaxed/simple;
	bh=f2XjQVAFOMEyAF2He6DfOX7B9yvspDnOResmomHSCGY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iD1eBQgffz8OZMKx5asv0WvUu0Hldwg32J9Enuyt6cdYxJtl8OBUVg7rJy79DNHVpxejyU13067Jjs55Z+BErH8m6E6EvyjaYTv8gOVmiK45T4uqFWmplv3dRbGM58QxkCiDCAe5Y+Cb8EEwaKGSq4Wuxa8T5r7c+cyizZMhsBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b=mVCB/Ta8; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen-com.20230601.gappssmtp.com header.i=@soleen-com.20230601.gappssmtp.com header.b="mVCB/Ta8"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3daf0e73a5bso528975b6e.0
        for <nvdimm@lists.linux.dev>; Tue, 06 Aug 2024 11:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1722967233; x=1723572033; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QfBptZsetpueoOKsFuJCrA1Xpgd48fPSsjBhDKcmpWw=;
        b=mVCB/Ta8iyQtdOaadXma905wNHnjZrcesljUt3LtmM3qLfl5WEle3vzMUVgaHzIaiY
         GA/asCJzw262oElTXA20cww2k3nfnSXH/AmC3NsxzXfo3wdCnqX/zQ4QD+YC6w9Xi7J6
         Rx3FZAGJsrpqotGRTsn6pgVejpNVBkj+FqPLe/ysG/rzbk3lC91TYkf/iHaXjDBEWlfQ
         DiPG2FQNgDZqoID2Zc6HHTDdDWzNrnwTN86rKEBg38WQoROrJ8PxoUfJsMmuQusSA3r0
         yzJsmzRqmWHMD8VRPU/k7WBYl5K9/EWh5C9kyloHvrkmejFSbWYZLdO3vY35HHsGhZtU
         OT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722967233; x=1723572033;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QfBptZsetpueoOKsFuJCrA1Xpgd48fPSsjBhDKcmpWw=;
        b=sqogFAZWyIRquwnssor2vzdi8GPMogPhp8IHE7W2moYd8d+dYe4a0SkZMVDOuDpKYK
         DPsJPlHx0B4M4qiHO8kqLJUZb191CFgJVou39w9f0rYIHPwMtDvjQ96jmQeiB4226NhW
         P4q+qCx55PUmzwQ/OEV9ZicFoKuJ9Tj6OoXfbgU4pHSsWBdFzKm9m2639fvOrt7NRTad
         6kX+GjRU1FlPpFOHoAdaEK58sma01JrM+CKF0eVaYmTukPcFoZUCnFy+htj+FYVatwue
         W+chW/G9h4zTKtMZrgATe3DypcdpFYPuW2GmshmywOthRPPLUhgf4s7mobARq2oh8OoO
         PY9w==
X-Forwarded-Encrypted: i=1; AJvYcCXKBuFXxjzqNEeDx/+3+9ghQ4jvpsXAHmd06N2kZoK6z1rgOcaXHEnGClbbwsuYwtWa4bxfpvcp4ZtXkGKVItPF8GjhGjNk
X-Gm-Message-State: AOJu0YxrRcSUmhiO/dJ6I5vj0aGMSdLUsM9P449ENDrO79jEuVpITze9
	YVCHKfrI/z7akH1h5E/iD7MDtwyAxWTFEEI3XoqLqrRUm8TiNLvg83LQJezPL9FqRLSQGCLZeSi
	ym7oqMKmDso9o/a/A4MPHWnHnAQbeKbnZmiNznA==
X-Google-Smtp-Source: AGHT+IH+na8ZogFWe0lTnYO7BkcAEVsw1QVu/V+B8Fzmh/sUyWoO/L5FA9/YCLYS61YqWW8tMcQfLCj95kNJZH2NdC8=
X-Received: by 2002:a05:6870:15d5:b0:261:1ad0:5fd1 with SMTP id
 586e51a60fabf-26891a96625mr20245193fac.12.1722967233054; Tue, 06 Aug 2024
 11:00:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240605222751.1406125-1-souravpanda@google.com>
 <Zq0tPd2h6alFz8XF@aschofie-mobl2> <CA+CK2bAfgamzFos1M-6AtozEDwRPJzARJOmccfZ=uzKyJ7w=kQ@mail.gmail.com>
 <66b15addf1a80_c144829473@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66b15addf1a80_c144829473@dwillia2-xfh.jf.intel.com.notmuch>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 6 Aug 2024 13:59:54 -0400
Message-ID: <CA+CK2bC1ZsT3cuAMDAAUonys3BUxbb2JdnZXs1Ps3NbYZt5W2Q@mail.gmail.com>
Subject: Re: [PATCH v13] mm: report per-page metadata information
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>, Sourav Panda <souravpanda@google.com>, corbet@lwn.net, 
	gregkh@linuxfoundation.org, rafael@kernel.org, akpm@linux-foundation.org, 
	mike.kravetz@oracle.com, muchun.song@linux.dev, rppt@kernel.org, 
	david@redhat.com, rdunlap@infradead.org, chenlinxuan@uniontech.com, 
	yang.yang29@zte.com.cn, tomas.mudrunka@gmail.com, bhelgaas@google.com, 
	ivan@cloudflare.com, yosryahmed@google.com, hannes@cmpxchg.org, 
	shakeelb@google.com, kirill.shutemov@linux.intel.com, 
	wangkefeng.wang@huawei.com, adobriyan@gmail.com, vbabka@suse.cz, 
	Liam.Howlett@oracle.com, surenb@google.com, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	willy@infradead.org, weixugc@google.com, David Rientjes <rientjes@google.com>, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, yi.zhang@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 5, 2024 at 7:06=E2=80=AFPM Dan Williams <dan.j.williams@intel.c=
om> wrote:
>
> Pasha Tatashin wrote:
> [..]
> > Thank you for the heads up. Can you please attach a full config file,
> > also was anyone able to reproduce this problem in qemu with emulated
> > nvdimm?
>
> Yes, I can reproduce the crash just by trying to reconfigure the mode of
> a pmem namespace:
>
> # ndctl create-namespace -m raw -f -e namespace0.0
>
> ...where namespace0.0 results from:
>
>     memmap=3D4G!4G
>
> ...passed on the kernel command line.
>
> Kernel config here:
>
> https://gist.github.com/djbw/143705077103d43a735c179395d4f69a

Excellent, I was able to reproduce this problem.

The problem appear to be caused by this code:

Calling page_pgdat() in depopulate_section_memmap():

static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_p=
ages,
                struct vmem_altmap *altmap)
{
        unsigned long start =3D (unsigned long) pfn_to_page(pfn);
        unsigned long end =3D start + nr_pages * sizeof(struct page);

        mod_node_page_state(page_pgdat(pfn_to_page(pfn)), NR_MEMMAP,
<<<< We cannot do it.
                            -1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
        vmemmap_free(start, end, altmap);
}

The page_pgdat() returns NULL starting from:
pageunmap_range()
    remove_pfn_range_from_zone() <- page is removed from the zone.

Pasha
