Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3EC5464E
	for <nvdimm@lists.linux.dev>; Thu, 13 Mar 2025 03:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741837956; cv=none; b=DrQihnHq4qcY5gfKE78I2/oL9XTrUHuM74cxWNbck4VDNJF6oxlJM0wqohX48gejyvDCsoKpnGxQ0jkIi/Lvu2DrZQElHLlE4p7vQNfuge4twUgtddd3zgNF+Y03bBo17JzOirP1T3KHB66RGEQixEj/N/Seia0YuZOjy2bBphg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741837956; c=relaxed/simple;
	bh=CAK6VJsQ4Lt/XG3e6oAlqT4JOIEJttj6FNNZIocFiw8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P4QNOOMWEBceJkZiTlvk38HVnGOZ+uJekh/xoRuQENMUEowHIH0Ns31A3U8KFUoWnCGMXhZDAaGh+RneK6h1DHW4UMZDbRB43bKesQ+5ziPFc67RAKo0Uml7wGscCyA6WeHua7YvmM0g7GewzWeWDRiwQ67AoPKQ5zsl/tJAqrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nm4/fIii; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nm4/fIii"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-86929964ed3so520610241.0
        for <nvdimm@lists.linux.dev>; Wed, 12 Mar 2025 20:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741837954; x=1742442754; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dixt0o39GPmiD7R1LFsj4ci5HN2s7q23k30NE+Mi48k=;
        b=Nm4/fIiianRaAYH72oGi8X0R6veQqMzLwMU0A6TysjCazhsbgZfkKrvlvvuLfvy5E/
         LKx1NgvHmtMJmYz5iIZ3wOeaMeIoxYcUH/yZYLM5FvtXjIdTqFoV0FLARI+5NoM602pT
         LzL+rdPyBils4zUA/hZqYXx3TnllW1yQC4YuRzhUBHL/SbHipNpfeo0Ezq1yx3KI/CKr
         AMgJYhTzLFeyRpSA2uXcHWTjpWmjXdYncMIqUC6lhg98HdTk3p4QeOzLXV9XCut8ao8S
         SZLwSdkwtWkxgR7trqHuHWAkqT15jvCcJhZHMyz1zl11JiUOSzLG/79TH0tD47cbBHve
         sBGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741837954; x=1742442754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dixt0o39GPmiD7R1LFsj4ci5HN2s7q23k30NE+Mi48k=;
        b=ZnAcDacqRKy8eNjiOMkL33MXHjGHeh4U2tzh96MvcwIQxtCNnLsoUkYN7wopSnXRXK
         GzI+mzrIePwoZ1J37eMTQuUXFiSNYwrUJOXrtH5Wq8X8kbLD5aN8yvu6VjdPo6dMdJYu
         Q0JSK6vi1jiwG4ap8uu+QPCynBbxBLsW8frRCfnf9kC2QfRulsZhh5XWzZWnNBPChwkt
         g3PD1EVvwabNqaGX0jP40s82237kCmvXKj0i/O6KIMURcQQL3D5faJsRafuYxWTi8cJ7
         TImPLAJXAkJR4IwyV7wC3IDY4thPQsWUJGOVQV+YahkpG2BshQ5bTAABWV2KHuQZcTUg
         pm7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVTXb8oVdhaL5hp12FxCytDIh3rW+8eGeqPWfB2Hwgp1NcLtBTge0gfrOzsgkI5eS/pzGnlKSs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAnihuaevg4E8LK1mDz93AcRdutY1dHNS2hIbhzsusEu5A36UP
	2BihJJiCXFq8jW0TmslSCc9PcWqD57pQCOkFJVwGyZ5NuX4DOV5eTvAaABFVILJr3xZVUWOh/8B
	5UoVJ7kbXwiIMT7QyODJnqoD5FWw=
X-Gm-Gg: ASbGncu25K6/8kdAmNz3PVudPlXU8s+51YXyWOrxrsNLdxrWoNvOG9ArB92qiDseCk6
	OIWHupbGMeawy1kHXaN0DPMueOg/oRJODGEu2kwpbBS+SaZaDfzZnpCqw9YLPzHMIResYrdhBe5
	1BgIAe5xhgzRmrFJ0ml6ncjfeOhpr7+daPMxLGFA==
X-Google-Smtp-Source: AGHT+IElZnLD1RtQvQ1Xa/HL9SBtcFTvUikPJzrreCJkAkwTjpXP1UpN4dl74wMUECd2sr+yNxTt2PDKxbQqviHf2Wo=
X-Received: by 2002:a05:6102:41a8:b0:4bb:c24b:b61a with SMTP id
 ada2fe7eead31-4c30a6d23e9mr19456122137.19.1741837954156; Wed, 12 Mar 2025
 20:52:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250307120141.1566673-1-qun-wei.lin@mediatek.com>
 <Z9HOavSkFf01K9xh@google.com> <5gqqbq67th4xiufiw6j3ewih6htdepa4u5lfirdeffrui7hcdn@ly3re3vgez2g>
In-Reply-To: <5gqqbq67th4xiufiw6j3ewih6htdepa4u5lfirdeffrui7hcdn@ly3re3vgez2g>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 13 Mar 2025 16:52:22 +1300
X-Gm-Features: AQ5f1JrExyj5F0Vah_a1_rjhnAnivAK4d453p9csn5RazKNq_dZhJV200JGLGds
Message-ID: <CAGsJ_4yw17rLJPgS6CNXfXNVQnv2pf0PnLSA4UVAR1sUWDhP5Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] Improve Zram by separating compression context from kswapd
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>, Qun-Wei Lin <qun-wei.lin@mediatek.com>, 
	Jens Axboe <axboe@kernel.dk>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
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

On Thu, Mar 13, 2025 at 4:09=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (25/03/12 11:11), Minchan Kim wrote:
> > On Fri, Mar 07, 2025 at 08:01:02PM +0800, Qun-Wei Lin wrote:
> > > This patch series introduces a new mechanism called kcompressd to
> > > improve the efficiency of memory reclaiming in the operating system. =
The
> > > main goal is to separate the tasks of page scanning and page compress=
ion
> > > into distinct processes or threads, thereby reducing the load on the
> > > kswapd thread and enhancing overall system performance under high mem=
ory
> > > pressure conditions.
> > >
> > > Problem:
> > >  In the current system, the kswapd thread is responsible for both
> > >  scanning the LRU pages and compressing pages into the ZRAM. This
> > >  combined responsibility can lead to significant performance bottlene=
cks,
> > >  especially under high memory pressure. The kswapd thread becomes a
> > >  single point of contention, causing delays in memory reclaiming and
> > >  overall system performance degradation.
> >
> > Isn't it general problem if backend for swap is slow(but synchronous)?
> > I think zram need to support asynchrnous IO(can do introduce multiple
> > threads to compress batched pages) and doesn't declare it's
> > synchrnous device for the case.
>
> The current conclusion is that kcompressd will sit above zram,
> because zram is not the only compressing swap backend we have.

also. it is not good to hack zram to be aware of if it is kswapd
, direct reclaim , proactive reclaim and block device with
mounted filesystem.

so i am thinking sth as below

page_io.c

if (sync_device or zswap_enabled())
   schedule swap_writepage to a separate per-node thread

btw,  ran the current patchset with one thread(not default 4)
on phones and saw 50%+ allocstall reduction. so the idea
looks like a good direction to go.

Thanks
Barry
