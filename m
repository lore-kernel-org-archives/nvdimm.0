Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5885E28852E
	for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 17:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777051765; cv=none; b=tPJAwIliuykpjisd4tzLabYskMxueZSM80tb/a/yuSDQvhRz7jGi2dKwx+1OpC2V/sNSFKKZDSzjxQNWBBCLel9QhgcIfolQ9eeifRqmXUmpaeFSm+Kzt21lVQZEozLDjgTJn3URe05c6Gv7FTiqMegPvFc+FX0hOHNbjENKfJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777051765; c=relaxed/simple;
	bh=hVvt9c8c4eWT57jkwRWLBGFn1vnZek926LtW06dMedQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hDoX64D9J+Wdq1KvG3WLx5GYvBGEKafQBYdFzGamWKkICodA6QXH7q4P9O6L97qarYVbjZzutVcoYGsJFcTb5I+UkSExjiAa6ZRP70+mH5hBFphXKrTUyA2C/frF61Vd41H27p4RVn+3Iopc1GYQOuTvVscTR7GwqzNqJ2ZUh4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--fvdl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G4Q67wig; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--fvdl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G4Q67wig"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c797efdaa9cso4113442a12.3
        for <nvdimm@lists.linux.dev>; Fri, 24 Apr 2026 10:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777051764; x=1777656564; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f7t+a1aWdVNT0iPLk92g40wmtJOhwN3/erB4JEhY870=;
        b=G4Q67wigR3PjwQwrQD2dTwUNPmliNeAJp8QasT8ZzcDF0OdSQz3oXEDEW1NRRa/P4m
         JptdjKZNRhhPiTK+tulaeF4JJ0QpyUwEnOtaQpXC0aK7JuuE6sl+z9KWwayqbYkBPEmM
         jHpOl+c2c93AoKYjq4ZvPkkhOeXtlvxtCAO9znUCydudVOV3++1dSOv+c9G2I5s/cIYl
         dVDKrcsQEw5yNX0uCOJg3MW5QygW78tuO5nsquPH7qo6ZJYkokr04be5SVgaxp8jmyCd
         uKLuyPLyKOmxiXFOrCLYyubbgAjkD9u/dsWqMMOqcEwl/taYA0vNo3wR0WyGV5sSL/mU
         7Z9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777051764; x=1777656564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f7t+a1aWdVNT0iPLk92g40wmtJOhwN3/erB4JEhY870=;
        b=kwwcnKf5zshOW5hW7a4uBtoMKU3rX+1Kf1C9VXiVwRMn3KuEY3+5sn3M/t1hQIdDeR
         uMiF4cTcbkM6sbxXGPnPI38p9dMOO+t+7D1zNy2YPnB9PKOkuqksKTvmAJCFoex8oumT
         qbKi2ir185ccC+uxwoyn8d93LYDH/coB2EovVofL0M9FXOTsEC6wsQ72GQJUzrpgQ/rH
         mipBiL+SWxZfYNwg697nol4xA4aMSJtZwoMad67UdAQ4jzAa6A++BBi/kH2OGr5lX9dA
         W0KJWI3Afcx4cwHXx2QwPdDBd9djjcxs63Qe3Emb/YHBoyUTxtfyqhhWrcKxOh1rWkQ/
         Zhog==
X-Forwarded-Encrypted: i=1; AFNElJ8hk+oPIAksa8rgSDFT7WSvRRpL2CxzBzEF5A/q3FKpwVqrYkGyJjB/mVmujgNRsioTe3kZUtg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLMzDAx99FQC2j3WITUZkVZ6N8fqi6SeCa0dhfNi2E0bYYwnej
	6dEiw9Q8VQBVCuxZjvgEm50Gp6vgJrCqjgTuDjxEQ9YuDvDRk9vD8k+ith5L0/uZX6zCSwiuHg=
	=
X-Received: from pgah12.prod.google.com ([2002:a05:6a02:4e8c:b0:c79:67c5:c6b0])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:99a9:b0:39b:be6f:3d4d
 with SMTP id adf61e73a8af0-3a08d73f02cmr38112724637.23.1777051763548; Fri, 24
 Apr 2026 10:29:23 -0700 (PDT)
Date: Fri, 24 Apr 2026 17:13:44 +0000
In-Reply-To: <20260423170219.281618-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260423170219.281618-1-dave.jiang@intel.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424172912.548636-1-fvdl@google.com>
Subject: Re: [RFC PATCH 00/12] dax: Add DAX to guest memfd support for KVM
From: Frank van der Linden <fvdl@google.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, djbw@kernel.org, 
	iweiny@kernel.org, pasha.tatashin@soleen.com, mclapinski@google.com, 
	rppt@kernel.org, joao.m.martins@oracle.com, jic23@kernel.org, 
	gourry@gourry.net, john@groves.net, rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"

Dave Jiang <dave.jiang@intel.com> wrote:
> This RFC series is created as a proof of concept to connect device DAX to guest
> memory by riding on top of guest memfd in order to prove out that device DAX
> can be used as guest memory. The series seeks to jump start a discussion on
> if there are interests in creating a DAX bridge to utilize CXL memory for guest
> memory until the N_PRIVATE implementation by Gregory [1] is available upstream
> and DAX users are ready to move to the new scheme. Once there's an established
> consensus of interest, we can move the discussion to the best way to implement
> the DAX bridge and the future of device DAX as guest.
> 
> I did the bare minimal to get the PoC to pass a modified version of KVM gmem
> selftest (guest_memfd_test) in order to prove out that DAX can go in the gmem
> path. A DAX char dev is created and the fd is passed in user space with
> vm_set_user_memory_region2(). The DAX region is passed in as a whole when used
> unlike memfd where any size can be passed in to be allocated.
> 
> The folks on the cc line are people that Dan Williams has mentioned that may be
> of interest to this.
> 
> [1]: https://lore.kernel.org/linux-cxl/aeWV1CvP9ImZ3eEG@gourry-fedora-PF4VCD3F/T/#t

One of the main ideas behind guest_memfd is that the memory is managed
by the kernel only, so it knows what it has and that it can trust
the memory. This RFC passes an fd in via the ioctl(), which I think
breaks that model.

Since there is interest for several different allocation backends
(default, hugetlb, zone_device), it might be better to use a model
where guest_memfd has the option for backend allocators to register
themselves in the kernel. The ioctl can then select one by their
id/name (could be just a string). They can be configured using
e.g. sysfs (like hugetlb already is).

This would also allow easy experimentation with new allocators,
having an allocator with BPF control, etc.

- Frank
