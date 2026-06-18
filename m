Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACF8312834
	for <nvdimm@lists.linux.dev>; Thu, 18 Jun 2026 05:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781761929; cv=none; b=RCDx7jytdKN45I6YFZwNs93rsZ+mvLQt5VqGBQTtP4q1aTorl28plwYFLIMouqXhu+EviXPAcy5Fi0nRATvVvt7fBhhzbnXIZuJ8vZwOMXlOdKA2HIOwV1WXBM7Y5Q9vQc3/NIgcg58hiC5eWxLbYVZnygN/EurR5s5JT2S5kmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781761929; c=relaxed/simple;
	bh=Roc6jFBtRQ/L7AkcFCDl2Mo7X9RLH3mFsVpZO/wwArc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rYaYM9i1UdxWZKfnf4kr3y+2fk7bbB2eYzh+7hMPyRTpQqYLyf3YUW1BwGVUFQcUvLrCnvSwXFsE9MGoOQgm0Tadvt4qSJkBMI5NlXlpK9GunJxtPi1lfaeGr5kkzeH+f2l7IP/PUpI5quQduSsn2zbjgRQissG5ZW3ih3+2FP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dm0bAPHD; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dm0bAPHD"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-30bc871ecdfso692760eec.1
        for <nvdimm@lists.linux.dev>; Wed, 17 Jun 2026 22:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781761927; x=1782366727; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RVcrgdyxAFY0JrdBQcLjQ6NN4IVLGqhuG6k48kJCsJI=;
        b=dm0bAPHDaoOiN6CpH+/Gdo5d6QKa5ZQxM1FZm0QEpfinoGHQYD+7dbBwKVcVg9L5KP
         a7uJvj1rcNVacdZX0+BU92147fDYjLwP0Snbh/VmC+GwXofxgXEH2mnj084/GqFetvXl
         teAXmwtNqBt3AaVM34pKpI6HKvk8CSVzGrJbWWP9Qaimm4XZbKQlPK0z7vt6tgE8qL0l
         r8XNozrPvOpgKzqyIBqFOGHAbyiNt446bibuzWqKMV6Za6r1D7CypOTMzbiR4j51K0Bu
         7Be49zvVKg1Xoi49gEs59XDbVtr4yW/GEalIvH3SF5LENAraJF9SHNPKPRJO+JryB6Rw
         d2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781761927; x=1782366727;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RVcrgdyxAFY0JrdBQcLjQ6NN4IVLGqhuG6k48kJCsJI=;
        b=qcEEKANsYRh8RPVSp3sk/TPsBPMYYI+GKZrPvkKvDseFzHzyi1A7K8BAI4oqthzaWx
         70HWH87RmfOW+f8LBYYO04P0iPnYJGvXA+yJjZQPLC8+MIOv+ZGB33Vs9K5ekj4xJoyA
         EkNDiM4dO3HEOCdXOyOHBB2byBkptc2nnJfKnQWivXRtp2wSc/Y0tijh7McLAeNWSTHG
         0tbWO7X3Cy53mPFisOmCMaC4nWuYTOSQr+JClPw/ekrXqsWammUWCSKtWzUIpWpj8iL+
         iVJXklhynSoFeiEhdzRiOdXJma8G/C4//i7fGzekOyO2ZDAv+yLHjBUk79PRWaA7Lu0G
         gEYA==
X-Forwarded-Encrypted: i=1; AFNElJ899wbfksNkK6/2mdkbZudTj4ZNSRksktb2WMThgLzejusVrHRq5WtELNn2PuE9Xqr5/RzLYJc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKwM1PnRW05+lAtPbjHUmo95Zy/HnbCNL03qdm4Oqcc3OvA7bq
	y+V0HyiNyu6e4tZvThhkVfycfCu4ub7DYjJ+L7Wb1keJ53Kl45saSM/X
X-Gm-Gg: AfdE7cljxk+0lTQ3+7FluqwTdI3LL3rOKlHOJYQUtgB9ciDa2WiimG5RWh4WxFRsBYk
	EjYjVlTEjQe4fjebLGGM/cT3lPK8ObYCJKUBtgal7QZAZwgSIx0L143zEKE870HHZvLsvRFy2+j
	sJplNWFb1j0H+hPfBVrg4VPawN48p1RHEj3qGfDZyHq2jdAJ2vaRQjOSd9+ieqjjttkDLYdRu1A
	BxCjkTVzfAYdNZYICEkvsGbwCxhym62QiYxr8v263/q7VLMbE9odFsMS94YbREj3u+d8GE33qRg
	AOTv7Uf5si8K/C2MH8SAoH96OxsA+nCwsbF4SM9Qj7NnJSVz4xTeRQIe7LMPnzvYbW1EQmqkaic
	2zHcC2pw/+4ThWAWHnkC4pT4mLBcMCdA5dXms2FcSP+mcAoy37GySFNywZWnMFs7fyV3YFy6dQ3
	SGD6bkomFVuzQogPRPETihgEB7yG7ILqlGGgq/9azmW1n8ddz6jRN8iGHSN6RoSyr8qmHCpl5Jh
	3c8JLE=
X-Received: by 2002:a05:7300:4356:b0:2da:2ec2:64fe with SMTP id 5a478bee46e88-30bca082050mr4530581eec.24.1781761926706;
        Wed, 17 Jun 2026 22:52:06 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30bbbd636fasm7130687eec.22.2026.06.17.22.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 22:52:06 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 17 Jun 2026 22:52:04 -0700
To: Alison Schofield <alison.schofield@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <iweiny@kernel.org>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>
Subject: Re: [PATCH v6 0/7] ndctl: Dynamic Capacity additions for cxl-cli
Message-ID: <ajOHhP7hX8r2ptKC@AnisaLaptop.localdomain>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <aiJh7vcs2u1fMDX4@aschofie-mobl2.lan>
 <ajJITxBewsUuQGzp@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ajJITxBewsUuQGzp@aschofie-mobl2.lan>

On Wed, Jun 17, 2026 at 12:10:07AM -0700, Alison Schofield wrote:
> On Thu, Jun 04, 2026 at 10:43:10PM -0700, Alison Schofield wrote:
> > On Sat, May 23, 2026 at 02:50:35AM -0700, Anisa Su wrote:
> > > CXL Dynamic Capacity Device (DCD) support has continued to evolve in the
> > > upstream kernel since Ira's v5 posting [1].  The kernel side has settled
> > > on a uuid-driven claim model for sparse DAX devices: dax_resources carry
> > > the tag delivered with each extent, and userspace selects which ones to
> > > claim by writing a UUID to the dax device's sysfs 'uuid' attribute (or
> > > "0" to claim a single untagged resource).  Size on a sparse region is
> > > determined by the claim, not requested up-front.
> > > 
> > > This series brings cxl-cli and daxctl in line with that model and
> > > extends cxl_test to exercise the new paths end-to-end.
> > 
> > Hi Anisa,
> > 
> > I just now picked this up with the kernel side and took it for a quick
> > test drive. Based on what's been touched, first meaningful finding is
> > all the DAX unit tests pass, and then for CXL unit tests, all but these
> > 2 pass: cxl-security.sh and cxl-dcd.sh
> > 
> > Please let me know if there are known problems with either of those
> > before I explore further.
> 
> Hi Anisa,
> 
> Good news, DCD exposed a long hidden bug that made cxl-security.sh
> fail. It is not an issue w DCD patches.
> 
> Found that DCD set changes which mock memdev the test happens to
> land on, and that's enough to uncover a latent hex/decimal bug in
> CXL nvdimm code. We use to always land on id '1', but now this patch:
> 
> tools/testing/cxl: Add DC Regions to mock mem data
> 
> reorders the sorted dimm list, so the test selects a dimm with
> serial 10 (0xa), and there's the hex/decimal mismatch.
> 
> The renumbering is harmless in itself but it just changed the
> serial the test exercises and tripped over the old bug.
> 
> I'll send a separate fixup patch for the hex/dec cleanup.
> 
> (No answer on cxl-dcd.sh yet)
> 
> -- Alison
> 
Thanks for looking into this! I can also look into what might be going
on with cxl-dcd.sh if you let me know the base commit you applied the
dcd patches onto? :)

Thanks,
Anisa

> > 
> > Question below about dependency....
> > 
> > > 
> > > The corresponding kernel patchset is here:
> > > https://lore.kernel.org/linux-cxl/cover.1779528761.git.anisa.su@samsung.com/T/#t
> > > 
> > > Picked up unchanged from v5 (Ira):
> > > 
> > >   libcxl: Add Dynamic RAM A partition mode support
> > >   cxl/region: Add cxl-cli support for dynamic RAM A
> > >   libcxl: Add extent functionality to DC regions
> > >   cxl/region: Add extent output to region query
> > > 
> > > New in v6:
> > > 
> > >   daxctl: Add --uuid option to create-device for DC DAX regions
> > >     - Plumbs writes to the new dax 'uuid' sysfs attribute through a new
> > >       daxctl_dev_set_uuid() helper (LIBDAXCTL_11).
> > >     - --uuid is mutually exclusive with --size; pass "0" to claim a
> > >       single untagged dax_resource.  An unmatched UUID surfaces ENOENT
> > >       from the kernel and leaves the device at size 0.
> > >     - Documents the option in the man page.
> > > 
> > >   cxl/test: Add Dynamic Capacity tests (rewritten on top of Ira's
> > >   original patch to track the post-redesign kernel)
> > >     - Routes untagged claims via --uuid "0" so daxctl exercises the
> > >       kernel uuid_store path; tagged claims use real UUID strings.
> > >     - Asserts that for DC regions, size-grow returns -EOPNOTSUPP (real grow is
> > >       --uuid only) and that tag reuse across More-chains is rejected
> > >       by the cross-More uniqueness gate.
> > >     - Adds coverage for the new validators: test_uuid_no_match,
> > >       test_uuid_no_match_seed_intact, test_uuid_show,
> > >       test_cross_more_uniqueness, test_alignment_rejection.
> > >     - Sharable-partition coverage (test_shared_extent_inject,
> > >       test_seq_integrity_gap) is routed at runtime to a dedicated mock
> > >       memdev that tools/testing/cxl stamps with serial 0xDCDC, so a
> > >       single cxl_test module load exercises both regimes.
> > >     - Localizes positional-arg assignments in every helper so functions
> > >       no longer clobber caller globals (the previous behavior leaked
> > >       the sharable memdev into later tests).
> > >     - test_reject_overlapping arithmetic now lands an actual overlap
> > >       inside the DC region (the prior math landed past the end).
> > > 
> > > Depends on the kernel DCD/sparse-DAX series; without it the new tests
> > > will skip and 'cxl list -r N -Nu' will simply report no extents.
> > 
> > What is this dependency- DCD/sparse-DAX series ?
> > 
> > > 
> > > The branch is also available at:
> > > 
> > >   https://github.com/anisa-su993/anisa-ndctl/tree/dcd-2026-05-21
> > > 
> > > Based on pmem/pending commit:
> > > 
> > >   bbd403a test/cxl-sanitize: avoid sanitize submit/wait race
> > > 
> > > [1] https://lore.kernel.org/nvdimm/20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com/
> > > 
> > > ---
> > > Changes in v6:
> > > - anisa: New patch — daxctl --uuid option + daxctl_dev_set_uuid() helper
> > > - anisa: Rewrite cxl/test DCD tests against the post-redesign kernel
> > >          (uuid sysfs claim, tag-group atomic release, cross-More
> > >          uniqueness, alignment rejection, DC size-grow refusal)
> > > - anisa: Rebase onto bbd403a (pmem/pending)
> > > - Link to v5: https://lore.kernel.org/nvdimm/20250413-dcd-region2-v5-0-fbd753a2e0e8@intel.com/
> > > 
> > > Changes in v5:
> > > - iweiny: Adjust all code to view only the dynamic RAM A partition
> > > - Alison: s/tag/uuid/ in region query extent output
> > > - Link to v4: https://patch.msgid.link/20241214-dcd-region2-v4-0-36550a97f8e2@intel.com
> > > 
> > > Anisa Su (1):
> > >   daxctl: Add --uuid option to create-device for DC regions
> > > 
> > > Ira Weiny (6):
> > >   ndctl: Dynamic Capacity additions for cxl-cli
> > >   libcxl: Add Dynamic RAM A partition mode support
> > >   cxl/region: Add cxl-cli support for dynamic RAM A
> > >   libcxl: Add extent functionality to DC regions
> > >   cxl/region: Add extent output to region query
> > >   cxl/test: Add Dynamic Capacity tests
> > > 
> > >  Documentation/cxl/cxl-list.txt                |   29 +
> > >  Documentation/cxl/lib/libcxl.txt              |   33 +-
> > >  Documentation/daxctl/daxctl-create-device.txt |   12 +
> > >  cxl/filter.h                                  |    3 +
> > >  cxl/json.c                                    |   67 +
> > >  cxl/json.h                                    |    3 +
> > >  cxl/lib/libcxl.c                              |  181 +++
> > >  cxl/lib/libcxl.sym                            |    9 +
> > >  cxl/lib/private.h                             |   14 +
> > >  cxl/libcxl.h                                  |   21 +-
> > >  cxl/list.c                                    |    3 +
> > >  cxl/memdev.c                                  |    4 +-
> > >  cxl/region.c                                  |   27 +-
> > >  daxctl/device.c                               |   72 +-
> > >  daxctl/lib/libdaxctl.c                        |   44 +
> > >  daxctl/lib/libdaxctl.sym                      |    5 +
> > >  daxctl/libdaxctl.h                            |    1 +
> > >  test/cxl-dcd.sh                               | 1267 +++++++++++++++++
> > >  test/meson.build                              |    2 +
> > >  util/json.h                                   |    1 +
> > >  20 files changed, 1771 insertions(+), 27 deletions(-)
> > >  create mode 100644 test/cxl-dcd.sh
> > > 
> > > 
> > > base-commit: bbd403a03fa2a1551c1a10bbf78f32027c718758
> > > -- 
> > > 2.43.0
> > > 
> > 
