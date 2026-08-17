Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B8432B110
	for <nvdimm@lists.linux.dev>; Mon, 17 Aug 2026 04:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786942351; cv=none; b=BZ9LfMPuH1PMOhiZZFlUJEXGOQW1pNXbf33oJ43oNtY18njlKl+l3UvXn5xmJKCoidyD5pryr2Kp1Jb7fmN/WFfkIGF2oHMQK1MDWueJBhLQJd0Lvtd2IrQUfoycIXfPH7b0KXGpraFwOTjQqJ7iPkcztx1mh8XKQOr/Vk9NSRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786942351; c=relaxed/simple;
	bh=GJRSgVBGJeat3wAEG8z33jEB2lg7XxYymKLeUaKrn1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2PhFraMuXSI2n1Nkxire+A/ebvfCSWCxEUS4ds/gL3CaIsnidvrvpxwGQaBDAitivSCRi8Fp8+UQpOywZbnjxQNN3YML74rTaJBtWL+uqTl7zDZ6wvwX1CFo9YF7LgVKc9asb9lN1CGsQbrx11cH1E36koWIplw7OAQNc+rIc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KOv/UINK; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KOv/UINK"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-45eb2e6402aso1053543fac.0
        for <nvdimm@lists.linux.dev>; Sun, 16 Aug 2026 21:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786942348; x=1787547148; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lXCFBr15COi95qp1EsFgIG/0N/CfzI8VoEXN2Vn844Q=;
        b=KOv/UINKkLFJ1cAx+7YH0CNP8e0XNgX7YKoO/xdfyHcGx45wlOoLw90yaQ2CzPCPnc
         kaoMJ+eDOO6c7Qfroam1R9ZfL8gIz+BNWFZYpo4Tfcz6L+pKOaTgi2IsOvV+JJ0nyuxl
         HKLNtj0KQtLamDkFFwcFTAH8SfZU0oU5N86dZKUChZuRzk/EhFthphB6ezyZPiGbVv0W
         iZI0J+44blsKw057TGVuCeV3c9i3Skk2je++Fm4rWYn25+BIjzAB7Y1OvWJlgiFg6USH
         AOyd/nTYSW/y7Qo4ylWl5xDKzIgQ2a5s9zqgbuzUut4SlFabkJEn5/EFwQljNLK7kVSU
         9RXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786942348; x=1787547148;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lXCFBr15COi95qp1EsFgIG/0N/CfzI8VoEXN2Vn844Q=;
        b=o7lHweFaN57KMOG1eDLmfqpU8qwMUKmILrh+opmusq0DahqMRZAXksBmV5zNbh+TjS
         Qoe6PlkjLhpf3B0Se20n96usNetZ0Cyu1crnPd76KOFPn+tjyG5kmRlJlLRZY7QaUxiM
         R1TL7RKHuf2U3ae5E2UrXpvWRGYUTyjKfi8J6L4zWZPIbd3E9flnCsxLQPXYwtSnhvvx
         fR5FaYdBZSbw/niychhy8G44co9es5yfJehzRxjgowqyyvEHVHO3iu5q2kbGa2i2y3Pd
         XFSBXSaAVhk7+5NX/96DuPumDEpcYXGZSynPy3rJhakkmznYIkAXfWOBj41Dnxq4gfvm
         lnWQ==
X-Forwarded-Encrypted: i=1; AHgh+RqrJJiWMUgg6ZpY6VLDO+/GLPNRRVmH3KpHg8lE4DL6w366uaj9yn4ncO/XBWseDwDOwgqx2uQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzuk5I/l+wZBnrU1KjC9DIyApb24fa3kCv7mA8u4O9epryDMlYs
	NKOWD1+rpARY6S4hIq7T7S3ZzXrRCOevZFWXooM0qhHjkXwcIEeLPLs/
X-Gm-Gg: AR+sD131er0DFNMcx9g+ii6yQrg6EiLrtqK1Ma/6cDDIieMe2tWGqRwJzpoCtpsB6kF
	G3C7ESC5eDkQFD6CIm2WMj0hpmGInWhApBLwViGsaU6SRN0enH2oiCQsffBbGnr7qKPpNT2Wwry
	+EJ7iGZ+FDY0tVWgDoaUIL1aCXd9KormNscRcmAhV43968k1kuYFEVISsjjrhx2jiRXuxAE1dkP
	HzP9PyDTRk9ep1QWi3is2ESjUcqyCBzzQJBon5QW0sOFS5YF40ZRYPYycVVWI5R/kqX1Mhq/TSq
	qGWqbKXbZtcZvbNOy7E4tZC50DQFcOhV8/7EP1QI4HRKJjiYGks9au9dCS+KO8ra9PM1pOsHR71
	10SaL++3C3UgH2JIRV4I/AdXxczCPZ8qwWYR+o4e0KC9F+XPmctlY8B11ubdHnHMrtjhTUPFEQE
	xgvBu8fuhBYoitshqFVTUw8eiAWhsgh0i7TY5YrxBn0Tg15nLRlvqS1Ha3XO+K0hUKWmLuB8GCv
	IokxqoQxW0K/pPiX9IKqtHLXoke4NjsOw==
X-Received: by 2002:a05:6871:680c:b0:448:c6ce:9617 with SMTP id 586e51a60fabf-45e91ce96b6mr18797832fac.5.1786942348251;
        Sun, 16 Aug 2026 21:52:28 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:a::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-45f22aea368sm300381fac.5.2026.08.16.21.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 21:52:27 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: Rakie Kim <rakie.kim@sk.com>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Sun, 16 Aug 2026 21:52:24 -0700
Message-ID: <20260817045225.1807518-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aoJY53BJztPQYumw@gourry-fedora-PF4VCD3F>
References: 
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 16 Aug 2026 20:46:16 -0400 Gregory Price <gourry@gourry.net> wrote:

> On Thu, Aug 13, 2026 at 03:23:48PM +0900, Rakie Kim wrote:
> > On Wed, 12 Aug 2026 22:37:06 -0400 Gregory Price <gourry@gourry.net> wrote:
> > 
> > The cpuset.mems = 0,2 you describe is the node set of package 0, so
> > the tasks in that cgroup use node0 and node2 wherever they run.
> > 
> 
> I think you are over-complicating the explanation and that's making it
> hard for folks to reason about this.
> 
> My best understanding here is for multi-socket systems, weighted
> interleave as-designed is inherently sub-optimal for scaled workloads
> that utilize multi-socket ("package") memory resources (DRAM, CXL...)

I was thinking about this and I think Gregory is right here.

I wonder how much of the framing around this series can be preserved /
simplified if we just say "prevent tasks from allocating memory
cross-socket".

I also wonder if instead of limiting this to weighted interleave,
this can sit on top of other mpols and just nodemasks against
cross-socket nodes.

> I think there is also an assumption that total memory utilization is
> less than the total capacity - otherwise some of the assumptions here
> break, but that comes with the general weighted interleave story.
> 
> I'm getting back from vacation, I will take a closer look this week.

I am also out on vacation this week : -)
I'll take a closer look along with the code next week as well.

Thanks, Rakie and Gregory!
Joshua
