Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15405EC5
	for <nvdimm@lists.linux.dev>; Tue, 11 Mar 2025 09:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741685598; cv=none; b=lTrdAUU1pRZx5JuKrdUNtobUPoO6iTVjFhMA+i9FdYW/Rg1e4KutRIggn6s3GDedjLVznqriM3re8+ZUfONt0iNjsK4omd6UvNFO+1YrI3yTIDvIPetw2NBoK5vVWpkQxH//lmTzVqWgsBM04gnm7ksaPR78fg5nh5/CfqF8GIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741685598; c=relaxed/simple;
	bh=mRNEtQhgbvcG/c9JNeEVRUgWt852dyGn4ZIiE2lQQ4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gp+/LjJLubwmBNg0qLkVetK9qOGM6OSzTyWexwdA1g2CPBV1BdJLNBgyr4BhGAI6OZmQR7CtkuxrlMiOvwzmOzN0lqzVv1La9Lo3+Z+IOdKmfkhSRqJGeNKtpvJaDUeYx1Y/Y26nOptzDBHL210eBAkCX1iEXg0el4g8rXKS7vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XOmWAgOD; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XOmWAgOD"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-86d3907524cso2155179241.0
        for <nvdimm@lists.linux.dev>; Tue, 11 Mar 2025 02:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741685596; x=1742290396; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Oci9eEq+toTA4eT0HbbNQG595NfpjyU1+E2PAns3Nzg=;
        b=XOmWAgODYCKwKmr54A86IBO4s2XGahyxxKKJDyZ1hWpSDA7mMLoM+DldZvdwY/m0dq
         WJ4vDN2NEE9DxsC4DSuwXTjCgFOM5kT2h1/c7WvULXSPpEpDhFwjo7gzrhHR1hzekhOP
         fu4jSVU21F60GSgEph419fBT9OdSLiQvEB1ijcxBm+212ma5JWCFqxMV85iOowz618Gt
         aM8mg2XlXp97Dz9hF5zB4Z6loqwdKFgGIf5xHf1bfvdN01Y7zTcINNzfnGKxwWoMHTJA
         KByCYansuiLIJmk2Hq8ZAYz22zmwPiInKZEAB/PUkuoP1UwcQYwfd8pJTeCR1sxL9cYu
         cg+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741685596; x=1742290396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oci9eEq+toTA4eT0HbbNQG595NfpjyU1+E2PAns3Nzg=;
        b=M0u5SYiQIKAjArikPKpZOdFi7HCEy4brSRG3HNR7Izp/s60qY4VbOx7nFSALxq4kOk
         pRGScU88eWY9usRugq2xt+OBVVj4DQURbB4ZFPmk/21PWKfKg2QP872tuuDSmuMvDgJj
         8hR6sPAq4S4pa3wSoKtupUAcbgAhbmILBZBDQsF3sSe20ftLSGN9PQyAhMqZ8Is990oO
         9oOsS434fhPDQIzHIGb+BRHrxXP4sJY0t5IymBdH0SdPjXW8uP/hLrFYhV25WFQ4ElOt
         0096PiYn0lHMaYsGG6z0Bi3WrtC/VCbb1W/e8ShhkGzap+aVLC1gQ98I2MSFeXGHlvg7
         2qrg==
X-Forwarded-Encrypted: i=1; AJvYcCXdiQWSEXou+knKOZ6lr+qpmG1KR0z1rFxdzuUId6Olkfbicy4GoXr6HM4Dp28SFv4Zh/OCi/c=@lists.linux.dev
X-Gm-Message-State: AOJu0YxqAOGZzeLpmI9iitBXdcq3K648U0mn6xcqvFP5Qn+IpXgunI8f
	372vGmYFdXVLsdyoJlJAjzaJtnYUpoq4ekDISfC+3TSPeazhAe5d/71ytmal7ijS8v3c7pOc6iP
	1dBNGplrS66asi88UsATUzcbA1DQ=
X-Gm-Gg: ASbGnctOZxMnsVa6IwMrWHsXv99+7LAAVkEFZafQvdlBXzUP3VNwJrazt48+P5MePC7
	MZlxJvRmL4fLB8l+yLQWoJ0xA2odzIvXxPHhCfAUQcpjcwvM/bphY5AGN5guHlTod+oYBUR70At
	Vj2YqWe/KyAa183HQr6u1DL+AyeKTngAysdcR1
X-Google-Smtp-Source: AGHT+IFjbF2BT/V8wuSBTDQZbf6t/hT/Znk/xR8O11b3YilMHbEGP/m6CvuSuPbsGl833OZDuyeAqkTBH4Ybr+MgCeE=
X-Received: by 2002:a05:6102:509f:b0:4c1:9e65:f904 with SMTP id
 ada2fe7eead31-4c30a718b91mr8809313137.23.1741685595784; Tue, 11 Mar 2025
 02:33:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <CAKEwX=NfKrisQL-DBcNxBwK2ErK-u=MSzHNpETcuWWNBh9s9Bg@mail.gmail.com>
 <CAGsJ_4ysL1xV=902oNM3vBfianF6F_iqDgyck6DGzFrZCtOprw@mail.gmail.com> <dubgo2s3xafoitc2olyjqmkmroiowxbpbswefhdioaeupxoqs2@z3s4uuvojvyu>
In-Reply-To: <dubgo2s3xafoitc2olyjqmkmroiowxbpbswefhdioaeupxoqs2@z3s4uuvojvyu>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 11 Mar 2025 22:33:04 +1300
X-Gm-Features: AQ5f1JpaKY-TJruiEfKLncijqOvg19zgNrZm_fVI7uamNPGD1sBBaPT6nlX2PNg
Message-ID: <CAGsJ_4wbgEGKDdUqa8Kpw952qiM_H5V-3X+BH6SboJMh8k2sRg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve Zram by separating compression context from kswapd
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Qun-Wei Lin <qun-wei.lin@mediatek.com>, Nhat Pham <nphamcs@gmail.com>, 
	Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Chris Li <chrisl@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, "Huang, Ying" <ying.huang@intel.com>, 
	Kairui Song <kasong@tencent.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
	Casper Li <casper.li@mediatek.com>, Chinwen Chang <chinwen.chang@mediatek.com>, 
	Andrew Yang <andrew.yang@mediatek.com>, James Hsu <james.hsu@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2025 at 5:58=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (25/03/08 18:41), Barry Song wrote:
> > On Sat, Mar 8, 2025 at 12:03=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> > > On Fri, Mar 7, 2025 at 4:02=E2=80=AFAM Qun-Wei Lin <qun-wei.lin@media=
tek.com> wrote:
> > > >
> > > > This patch series introduces a new mechanism called kcompressd to
> > > > improve the efficiency of memory reclaiming in the operating system=
. The
> > > > main goal is to separate the tasks of page scanning and page compre=
ssion
> > > > into distinct processes or threads, thereby reducing the load on th=
e
> > > > kswapd thread and enhancing overall system performance under high m=
emory
> > > > pressure conditions.
> > >
> > > Please excuse my ignorance, but from your cover letter I still don't
> > > quite get what is the problem here? And how would decouple compressio=
n
> > > and scanning help?
> >
> > My understanding is as follows:
> >
> > When kswapd attempts to reclaim M anonymous folios and N file folios,
> > the process involves the following steps:
> >
> > * t1: Time to scan and unmap anonymous folios
> > * t2: Time to compress anonymous folios
> > * t3: Time to reclaim file folios
> >
> > Currently, these steps are executed sequentially, meaning the total tim=
e
> > required to reclaim M + N folios is t1 + t2 + t3.
> >
> > However, Qun-Wei's patch enables t1 + t3 and t2 to run in parallel,
> > reducing the total time to max(t1 + t3, t2). This likely improves the
> > reclamation speed, potentially reducing allocation stalls.
>
> If compression kthread-s can run (have CPUs to be scheduled on).
> This looks a bit like a bottleneck.  Is there anything that
> guarantees forward progress?  Also, if compression kthreads
> constantly preempt kswapd, then it might not be worth it to
> have compression kthreads, I assume?

Thanks for your critical insights, all of which are valuable.

Qun-Wei is likely working on an Android case where the CPU is
relatively idle in many scenarios (though there are certainly cases
where all CPUs are busy), but free memory is quite limited.
We may soon see benefits for these types of use cases. I expect
Android might have the opportunity to adopt it before it's fully
ready upstream.

If the workload keeps all CPUs busy, I suppose this async thread
won=E2=80=99t help, but at least we might find a way to mitigate regression=
.

We likely need to collect more data on various scenarios=E2=80=94when
CPUs are relatively idle and when all CPUs are busy=E2=80=94and
determine the proper approach based on the data, which we
currently lack :-)

>
> If we have a pagefault and need to map a page that is still in
> the compression queue (not compressed and stored in zram yet, e.g.
> dut to scheduling latency + slow compression algorithm) then what
> happens?

This is happening now even without the patch?  Right now we are
having 4 steps:
1. add_to_swap: The folio is added to the swapcache.
2. try_to_unmap: PTEs are converted to swap entries.
3. pageout: The folio is written back.
4. Swapcache is cleared.

If a swap-in occurs between 2 and 4, doesn't that mean
we've already encountered the case where we hit
the swapcache for a folio undergoing compression?

It seems we might have an opportunity to terminate
compression if the request is still in the queue and
compression hasn=E2=80=99t started for a folio yet? seems
quite difficult to do?

Thanks
Barry
