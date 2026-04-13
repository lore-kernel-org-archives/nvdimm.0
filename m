Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F74C3E51D0
	for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 19:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776110360; cv=none; b=hbfHouzJimap+ncXVd0aHGHPaQg1ZOE5oLRwJDWHCx4Kr8XLO3cnWdwEU7xmW1R3uSU+HgnQuJQ9tmsDuEv31/qqBUCWPi5S/G863kyWhkQARrrhwDvbIGvw+HG1uVxK4otk64zwLbwC7VoolV1Pk8SKUNnvyWxFMq1MkNM+KJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776110360; c=relaxed/simple;
	bh=dkvR6+DO0Np/gQd4zUN6ufz3HgdPmilT+Y3eAl7ElY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ie4NFOpo+OfUPmpdI28D0/H8Ty4E3SVsnFh8i2tyMkyzIz05uwwINxflbBCiKT1N1vbmHnGiz6mimM044eTtXvrd29C5Cuy2irrFrUjpU92lnzjR+SqO7y5nltBC/bcBs4CA4XC4FmsjmM7+Iyg+tojVIXzIfUu7QDV+hiNAkTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=DVpjbn2u; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="DVpjbn2u"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8e0a768331cso167479885a.0
        for <nvdimm@lists.linux.dev>; Mon, 13 Apr 2026 12:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776110357; x=1776715157; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1azq21Esoe1p/aY/WIwRSLCrXwL5NJKdtQZKDmxglNA=;
        b=DVpjbn2uF4zUq5Wm3okHf19ai0veD1LKjYKMAYrVlQ7WiMHzSotDcdph4NJHfUv6i2
         8wNV7eCpLTC4Vix9qlSGYMbppD7dolssZDNOYcGK7b04iPTbMpYIL+DzLERuASfPvsco
         Z3K8hRXL8B1FhAwB7QlNZcwzSj/NFOFFwMa7HmRNi8vGE9j+ixxRKP1gySdjQ+Sp0wFm
         4Ih3ZspNXLcMUNtHJpWk2y8jWJ+RKcn9n5CHdXYIOEJ7FEM/G31oZ0ceC6RmAzJVcPJv
         flpbh6/ze9sUIheSoo76YRCSBhbbGj6h4WCKT0NG03kXZt2JLWLmdQE2wMGlYNddn9Qs
         Cw0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776110357; x=1776715157;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1azq21Esoe1p/aY/WIwRSLCrXwL5NJKdtQZKDmxglNA=;
        b=chOTv0nr+9Fx3nQ4EX/eotoeLLAihncFXxoeqizHHC6D1yjd3mDyO0zm6V6IVoMwoc
         AhQ+FdyY0YVhgb/b9sZpwakMZdwzFzVxxPdVHTZny50/AGdaVaMmcUKQguL2rAVU9X0W
         2xxbPIqe1ZArqBzGej6nmVXifWmcbWBJ9oTi4bEMuhPMiBpSy8hY48KcUEE4+amZBQ+o
         Z4Dq5ul3kkLBK8yiFUN8LwwutE1G/Gl1c7XEJUxqnXmLzDfmlTp7FFUN5jK5pVkt7k8u
         sY0DAXvRY0BSSpNqJRbFcRHVyGp6ve9S7vaBXp2lngYr6reMRC/XU94UyWynDFpN6h2Z
         9RJA==
X-Forwarded-Encrypted: i=1; AFNElJ+8yFmjTGDOxNfx/fRgZs5LIal7WBuOoqP2aCzFjAt4dtIcbrJsGpuaBnuFeFwa/mlyvJmNSSo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxkbWZ4LwsXxhkAsbz+EYfumKEkwc5wdhxGoDWh9XQNUTTEJS+K
	rJBVoReXzmTHC9RBkXbI8e3FysB8AZOiFlWfhI28f1z+KNPGHZoO+tPXo92sGz3lezs=
X-Gm-Gg: AeBDiet/6EOBMpT28l5rQaMXExuGWr014XFRxxeoivMjyutUGdvD+HeGCaTmiBS2whF
	A+uyfsBmbDZ1Pm4DPPZ0H21AUQouTcTJWaMNReYmJtrkEPLX9g4qYlns0fgC23uxxSuptQAw5yO
	8Edy/epuQiDvCOS3RSVvc9g6ltn4dnoMIJcPJLTSrTRzVFe5d9YNaQ7JCQo+yCrs7veQmB1IzTy
	+8QwNyK6+J7D6SXsXoDOuhaPWOwL8SdS+qYc3zAmSfW21XVkM3DvRMZQcNOaN89a3bvoSo1SZX3
	9MaxYiRC0aZss5mT2qxFSbLZmlk1mjE/+liQySdhvsFaqgcaavBi+K5yogTnVFOqKwOLA3VISag
	n9Gxk8t72276wyS0Wr5Wy0SiLXSc1Ex1bGln81s3EGFbne4l5x+h0M93iZAADdBQQ5ZVcaROoFp
	b83l1RN0kaQOWLra2nxjjJYvqCh9YHPFfkXifoeDR8EHHGk/EAQeF/g5s7miX+qePoJ0PBQKrRA
	PpfN6UgE+eunP1nPvfm/4XvFixr5ZPXYw==
X-Received: by 2002:a05:620a:44ce:b0:8d8:9434:9379 with SMTP id af79cd13be357-8dc444ad8d1mr2489658185a.18.1776110357176;
        Mon, 13 Apr 2026 12:59:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8aca259724csm53270746d6.12.2026.04.13.12.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 12:59:16 -0700 (PDT)
Date: Mon, 13 Apr 2026 15:59:14 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com, osalvador@suse.de,
	dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
Message-ID: <ad1LEgvfwzgvvWPO@gourry-fedora-PF4VCD3F>
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321104021.4a6074330131a2058e8706bd@linux-foundation.org>
 <ab7_AVLgzLaDRcv5@gourry-fedora-PF4VCD3F>
 <a4be48f2-ab0a-4808-a7db-2532ec65ad0b@kernel.org>
 <ad1GJRyAfIAhj1iz@gourry-fedora-PF4VCD3F>
 <478c5700-8bf5-42b9-ad71-bbc618b36c9c@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <478c5700-8bf5-42b9-ad71-bbc618b36c9c@kernel.org>

On Mon, Apr 13, 2026 at 09:40:49PM +0200, David Hildenbrand (Arm) wrote:
> > 
> > I don't think this is a very large lift, just a slightly larger hotplug
> > locking scope.  But then - the per-range thing in this set should just
> > work, so let me know if it's worth the extra churn.
> 
> Well, you can rather cleanly undo the operation if any offlining fails.
> If that's not a requirement, then no need to change it!
> 

It's not a requirement for me, but maybe it makes sense that

   echo unplug > dax0.0/hotplug

Either fully succeeds or fully rolls back.  Otherwise `cat hotplug`
would have to report "¯\_(ツ)_/¯".

So makes sense, i'll come back around on this.

~Gregory
