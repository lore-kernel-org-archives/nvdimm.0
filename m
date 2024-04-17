Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E8D6A02E
	for <nvdimm@lists.linux.dev>; Wed, 17 Apr 2024 08:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713344040; cv=none; b=hfDFTd5+DekCRNmXkHH5G3TXEPo9F7/POTzoAEeWJaC23PvT1gpw5CIgXMgx+tTHjhOb0o7qGnmQiRIMAkN9ifxW4OpW03DueZUggA41KDosJTxeALHBBjM/KGgmqlnhm3h289ExrDnAHOGtE7mOcJzjI8fOI5AsHyWoR5amLpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713344040; c=relaxed/simple;
	bh=+4T9p/7Vs7cfYNJr41v+pzH1bpwFtSs+2Zmt8xyhrZM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R+des37gHunRWWUhXpr/XBd4NSQYB/pvPj2pMZTDl9y6SOBf/RANe69L5j+XpYmf0je5yXw+ZFUEuTlboJ29ZI/MjSO3JqyF/V+oShDNcxdiyHEHVINwOjLwQUN/z1jXl4cqwWrgNt8jwstc5EIRpDLxvS4cPed/Cs5Q6KDmUY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=kOzAk7Nj; arc=none smtp.client-ip=209.85.219.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="kOzAk7Nj"
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-de45385a1b4so109863276.3
        for <nvdimm@lists.linux.dev>; Wed, 17 Apr 2024 01:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1713344036; x=1713948836; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGwSiMzvAKR+bq3SRViWE8ZoGbeuRmJT21WPOyLk3/o=;
        b=kOzAk7Nj7eRECg19xsyH1RbGOueHpfj/ZShLXcguNOi+1Mi/vNdd6K9dGRIM7pBs89
         /6pyugTGwENYBJSs9uB0JCVwxSfEyea/llyGVC9BIoEp2fpsj2bEbKjxKKHVWb9jnEHf
         g8uuXCB4eIATVY8Z069XYY30oSwsWr4gyK65ffNRbzC3YpK6EM/Hl7sHUvOZtsDRgclp
         n5ADLxyd5CTolmXNFpwyOAXjLa7XchBfZ5dgo+Ns4Hkjomwy3uDyOWw6h8haRjbL5tz+
         3dbbozGi4H4xLO0/926OBpF+hiKyzK9MQPmYHA3B/ssBGpR+Vb1Upar7As1cCa0aJEC/
         4HoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713344036; x=1713948836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OGwSiMzvAKR+bq3SRViWE8ZoGbeuRmJT21WPOyLk3/o=;
        b=RbtBpy/Bl1H6pEaUPnMiZzcF793DhZqpnAdxf363YRzMtddxOC9mdNa2JyHCTmDn1f
         u38wW6RlRop0c92hzAt8qZfCSY1TlCM+aLVIZhaLdOL5JgGSvQ5b0nsXgXHJwGGMVnRQ
         2bjonUXiDqgdfM3VOhSIwuvdcX13k8tk/Lj/vhxtBvBpDSHFe+CKwBmCO7+JkvwKI15b
         wTHcyGgzu45qI8P/lMJUo0eDihW8IFYkYbs+QUnkc6+zjs+6MwsAn8AUTJJJz3I1Dmbc
         gPZOdZe1kOEHHU8XBKRM/QMHKo+vWNZLUQ3KpmLUrCN5/PwwwtWLyNt5XL9GqEZAh7j+
         meSA==
X-Forwarded-Encrypted: i=1; AJvYcCX7o0B3ytoYBanigY6AYTXOz4oOb52yzhd262RPRQxGZrtCd3X0s7uGq+wPC0M2aVTj8QH8p+f96ju7aCyjRhYq8OxkiK1b
X-Gm-Message-State: AOJu0YynGEPmNXms0I5uwRjCoBTsbziLUzkmpqCYlUYoVI3eUR1fvaGs
	tDdo7QPVGU3xNz1s7l/QhUkndW7GzABDnLfXKInP0P0AZvKr2XGg7gJtM4NKNMKETzYufGNzPNX
	nA6mQJbsZNRMKq6GYRtva4NnngOnpKfrrpQEK4g==
X-Google-Smtp-Source: AGHT+IFZRZdQbGM2QETddK5D0uyMD/72MA62SJVOkINntmHAAG+laCqSBzT6nP80eg1XWB0b95YnHzUb7Sadw2HRYNM=
X-Received: by 2002:a25:ac42:0:b0:de4:2bc:c715 with SMTP id
 r2-20020a25ac42000000b00de402bcc715mr4797289ybd.8.1713344036496; Wed, 17 Apr
 2024 01:53:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240405000707.2670063-1-horenchuang@bytedance.com>
 <20240405000707.2670063-3-horenchuang@bytedance.com> <20240405150244.00004b49@Huawei.com>
 <CAKPbEqpGM_nR+LKbsoFTviBZaKUKYqJ3zbJp9EOCJAGvuPy6aQ@mail.gmail.com>
 <20240409171204.00001710@Huawei.com> <CAKPbEqry55fc51hQ8oUC8so=PD_wWoJMEPiR-eq03BgB5q86Yw@mail.gmail.com>
 <20240410175114.00001e1e@Huawei.com>
In-Reply-To: <20240410175114.00001e1e@Huawei.com>
From: "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com>
Date: Wed, 17 Apr 2024 01:53:45 -0700
Message-ID: <CAKPbEqqbTdyGy_q4P9QeB0x6qzx_XZvnP-oED=A1VW407JabDw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v11 2/2] memory tier: create CPUless memory
 tiers after obtaining HMAT info
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, Gregory Price <gourry.memverge@gmail.com>, 
	aneesh.kumar@linux.ibm.com, mhocko@suse.com, tj@kernel.org, 
	john@jagalactic.com, Eishan Mirakhur <emirakhur@micron.com>, 
	Vinicius Tavares Petrucci <vtavarespetr@micron.com>, Ravis OpenSrc <Ravis.OpenSrc@micron.com>, 
	Alistair Popple <apopple@nvidia.com>, Srinivasulu Thanneeru <sthanneeru@micron.com>, 
	SeongJae Park <sj@kernel.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Linux Memory Management List <linux-mm@kvack.org>, "Ho-Ren (Jack) Chuang" <horenc@vt.edu>, 
	"Ho-Ren (Jack) Chuang" <horenchuang@gmail.com>, qemu-devel@nongnu.org, 
	Hao Xiang <hao.xiang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 10, 2024 at 9:51=E2=80=AFAM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Tue, 9 Apr 2024 12:02:31 -0700
> "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com> wrote:
>
> > Hi Jonathan,
> >
> > On Tue, Apr 9, 2024 at 9:12=E2=80=AFAM Jonathan Cameron
> > <Jonathan.Cameron@huawei.com> wrote:
> > >
> > > On Fri, 5 Apr 2024 15:43:47 -0700
> > > "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com> wrote:
> > >
> > > > On Fri, Apr 5, 2024 at 7:03=E2=80=AFAM Jonathan Cameron
> > > > <Jonathan.Cameron@huawei.com> wrote:
> > > > >
> > > > > On Fri,  5 Apr 2024 00:07:06 +0000
> > > > > "Ho-Ren (Jack) Chuang" <horenchuang@bytedance.com> wrote:
> > > > >
> > > > > > The current implementation treats emulated memory devices, such=
 as
> > > > > > CXL1.1 type3 memory, as normal DRAM when they are emulated as n=
ormal memory
> > > > > > (E820_TYPE_RAM). However, these emulated devices have different
> > > > > > characteristics than traditional DRAM, making it important to
> > > > > > distinguish them. Thus, we modify the tiered memory initializat=
ion process
> > > > > > to introduce a delay specifically for CPUless NUMA nodes. This =
delay
> > > > > > ensures that the memory tier initialization for these nodes is =
deferred
> > > > > > until HMAT information is obtained during the boot process. Fin=
ally,
> > > > > > demotion tables are recalculated at the end.
> > > > > >
> > > > > > * late_initcall(memory_tier_late_init);
> > > > > > Some device drivers may have initialized memory tiers between
> > > > > > `memory_tier_init()` and `memory_tier_late_init()`, potentially=
 bringing
> > > > > > online memory nodes and configuring memory tiers. They should b=
e excluded
> > > > > > in the late init.
> > > > > >
> > > > > > * Handle cases where there is no HMAT when creating memory tier=
s
> > > > > > There is a scenario where a CPUless node does not provide HMAT =
information.
> > > > > > If no HMAT is specified, it falls back to using the default DRA=
M tier.
> > > > > >
> > > > > > * Introduce another new lock `default_dram_perf_lock` for adist=
 calculation
> > > > > > In the current implementation, iterating through CPUlist nodes =
requires
> > > > > > holding the `memory_tier_lock`. However, `mt_calc_adistance()` =
will end up
> > > > > > trying to acquire the same lock, leading to a potential deadloc=
k.
> > > > > > Therefore, we propose introducing a standalone `default_dram_pe=
rf_lock` to
> > > > > > protect `default_dram_perf_*`. This approach not only avoids de=
adlock
> > > > > > but also prevents holding a large lock simultaneously.
> > > > > >
> > > > > > * Upgrade `set_node_memory_tier` to support additional cases, i=
ncluding
> > > > > >   default DRAM, late CPUless, and hot-plugged initializations.
> > > > > > To cover hot-plugged memory nodes, `mt_calc_adistance()` and
> > > > > > `mt_find_alloc_memory_type()` are moved into `set_node_memory_t=
ier()` to
> > > > > > handle cases where memtype is not initialized and where HMAT in=
formation is
> > > > > > available.
> > > > > >
> > > > > > * Introduce `default_memory_types` for those memory types that =
are not
> > > > > >   initialized by device drivers.
> > > > > > Because late initialized memory and default DRAM memory need to=
 be managed,
> > > > > > a default memory type is created for storing all memory types t=
hat are
> > > > > > not initialized by device drivers and as a fallback.
> > > > > >
> > > > > > Signed-off-by: Ho-Ren (Jack) Chuang <horenchuang@bytedance.com>
> > > > > > Signed-off-by: Hao Xiang <hao.xiang@bytedance.com>
> > > > > > Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
> > > > >
> > > > > Hi - one remaining question. Why can't we delay init for all node=
s
> > > > > to either drivers or your fallback late_initcall code.
> > > > > It would be nice to reduce possible code paths.
> > > >
> > > > I try not to change too much of the existing code structure in
> > > > this patchset.
> > > >
> > > > To me, postponing/moving all memory tier registrations to
> > > > late_initcall() is another possible action item for the next patchs=
et.
> > > >
> > > > After tier_mem(), hmat_init() is called, which requires registering
> > > > `default_dram_type` info. This is when `default_dram_type` is neede=
d.
> > > > However, it is indeed possible to postpone the latter part,
> > > > set_node_memory_tier(), to `late_init(). So, memory_tier_init() can
> > > > indeed be split into two parts, and the latter part can be moved to
> > > > late_initcall() to be processed together.
> > > >
> > > > Doing this all memory-type drivers have to call late_initcall() to
> > > > register a memory tier. I=E2=80=99m not sure how many they are?
> > > >
> > > > What do you guys think?
> > >
> > > Gut feeling - if you are going to move it for some cases, move it for
> > > all of them.  Then we only have to test once ;)
> > >
> > > J
> >
> > Thank you for your reminder! I agree~ That's why I'm considering
> > changing them in the next patchset because of the amount of changes.
> > And also, this patchset already contains too many things.
>
> Makes sense.  (Interestingly we are reaching the same conclusion
> for the thread that motivated suggesting bringing them all together
> in the first place!)
>
> Get things work in a clean fashion, then consider moving everything to
> happen at the same time to simplify testing etc.
Hi Jonathan,

Thank you and I will do! Could you please take another look and see if
there are any further changes needed for this patchset? If everything
looks good to you, could you please also provide a 'Reviewed-by' for
this patch?

Per discussion, I'm going to prepare another patchset "memory tier
initialization path optimization" and will send it out once ready.

>
> Jonathan

--=20
Best regards,
Ho-Ren (Jack) Chuang
=E8=8E=8A=E8=B3=80=E4=BB=BB
