Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB3C194AE6
	for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 13:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783862842; cv=none; b=WWyw+NGeEuanI7or36uGCBfJkljaFhdwDGYp5JFuK44E+Zu7c3jV7nUfZ9hfZdHqXXTZzv4aPycmJP8PJOZS33xZV0CRVv7mKyz/1JUkwYwd/NUs8vZPRYbEUzV08MOu5kb7livgcdKCrMq9MB+isTTZPDPormGzqNwQ3cSv+cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783862842; c=relaxed/simple;
	bh=C1OxfgN3DhSdqYDbXsPTR7ElZOA1GuCHr6TwBj4Hxbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TWY4083nBvBDkPaqZ9R8TJgWzoykNC2RjYSLIC2nhKULD7TXDx/4yQ/i2uqO0A2q5QtOvyILcNrnmCgGj1AGdiLoOhdCn/cBLrwuwn+qsB0JFWC+yU82xgaOLgul8MSSHZEunPWBz8/0LtYQJCRNInk/jdxknPsJBOBrZg5CbRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=L4jGkiQe; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="L4jGkiQe"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c16ac21acso15007041cf.0
        for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 06:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783862840; x=1784467640; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uSgtWeg1aBZ0AWclvm9S4U5A86HaOMNd5qnnD7jgo3w=;
        b=L4jGkiQeBQapn4kJlRP254+XkPePh+hp+SEoLlaNzwVq/Ca88f09pCzUyMOkItqjWq
         tM0jd5qvZicgcJyvcpL+GGEUAeqMuzeLyclOzqWiPaAt3dIHlCw46mBdE8xr28CuNHpw
         xabDw6/WnSd9TEkuaVYm277ea8rtIgaZ22xduJEkMTnnrvzXS/6n3xkQf6oeJy7Pbqxr
         3IrqQ+Y1K9WwN3YfqZB3uiA2zzLLRhOkYPOQ+UOzch3KurS8K62LGO07aAdbH20v31RW
         RQiAf8pffSreC6io4RQJ+4vJOpWf1LOEqwiRSgSrJe203iWBXBIwpw+5zgWQkn5engQg
         gfQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783862840; x=1784467640;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uSgtWeg1aBZ0AWclvm9S4U5A86HaOMNd5qnnD7jgo3w=;
        b=NtkcJbl+4r+A8RVgzXlKU51LvedUy4FXWPpG5DJhyyphLPJzVTzdkeirO2QB1oG1zH
         VylsNfj0FoZxLyfDRw9SDEUM8UWnnbQzTm39TpOfr075GbzsKiiA9H512vqpVLC1u6Vw
         jQgUO76bIf01zulobqyE0eQEqhsLHwAwyLkB/QLixWnk8tIET5dzZcXhtSQsjrAchzvb
         rp4I38ZKnCNpwaaowOGPg8vI+25Tm0Q8Lr2874Ztz0nXotvVQFGAT/h88Q5sD1J3vq3E
         LlVP+Mo7gDnJiSMMy0optzTEhqQzxwbL9x2l9b+4vMRLowvhw4NecKfDjGqIXpIj9w4O
         255w==
X-Forwarded-Encrypted: i=1; AHgh+RracKGjKWqysq2bThZOl3WE96qeMhft2052UyCCP4oJ4C7g5LP53142rnIZqEWuApM8SF+59mc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWi1DsFPe5RJ8Axt9VSOn3MbhcFvkZbfTwfoFxmZKZHxhq2icf
	t9DZAZkpffX4CbN3Kxhzj+7mbEHJ0FiCy3Gi3re8RbJbPc//klOCY3K5gvu0/NzaDL4=
X-Gm-Gg: AfdE7cnuMFRsDCFBDRsgMmt9x63g5A1X/GSFASq9L5v19VxeeB2PmOd86JEfpyq2TJI
	Z4n1hOCLv2aOulEvfcaQ7Ssj+aYlS+IY7j/eYMA0tjTbWGodf7MwzSa0dM9eu+JGgSy54NDQZio
	N2om1ZxR4/HoPQZRzqE8N0DpqGGUNXvZwwKjuwXG29zLkJglh3H5rIOUj2uBtT+FeewI8lkxiHQ
	zDXMeCRs5jeJUImsOpq4EMZXP4l93lGIs3vEYzRmDjOm5pPBqfONZLahRIW2PzIJkO/80j8cktl
	mUmbOs/F5/UrEeIOdRSpsGnJwp3OCq9BQVciIxiHqy9cGYwqEKG6Hk9t5+JUDBx4TDlTsx7+iHo
	hXWSzaRiUfdAp0G3RODCyz5UkWXhDvwpNwFzv3svVXNd+4Pdg6Gx6TyB7DsfBLbYzQi5FAAupfR
	L4o8JLEhKxI4ZzxChxRdo3ku904ukJx0PtEqrmygJsETTYJy9lqDj4a4k62bF9dXvZwlt6
X-Received: by 2002:ac8:5a47:0:b0:51a:8c99:1f18 with SMTP id d75a77b69052e-51cbf281a2bmr56325921cf.71.1783862840152;
        Sun, 12 Jul 2026 06:27:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caab6e9f4sm64833651cf.2.2026.07.12.06.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 06:27:19 -0700 (PDT)
Date: Sun, 12 Jul 2026 09:27:14 -0400
From: Gregory Price <gourry@gourry.net>
To: "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 07/10] dax: plumb hotplug online_type through dax
Message-ID: <alOWMnIBleLQBBke@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-8-gourry@gourry.net>
 <6a5016bf71df4_3b7ee5100b3@djbw-dev.notmuch>
 <alAb7Q_Ku5dVRKZ7@gourry-fedora-PF4VCD3F>
 <alBLJoM86ujz5Fg1@gourry-fedora-PF4VCD3F>
 <6a51920acece6_35cf3310061@djbw-dev.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a51920acece6_35cf3310061@djbw-dev.notmuch>

On Fri, Jul 10, 2026 at 05:44:58PM -0700, Dan Williams (nvidia) wrote:
> Gregory Price wrote:
> > On Thu, Jul 09, 2026 at 06:08:45PM -0400, Gregory Price wrote:
> > > On Thu, Jul 09, 2026 at 02:46:39PM -0700, Dan Williams (nvidia) wrote:
> > > 
> > > This was more a matter of having the DEFAULT set consistently across
> > > the dax driver variant probe() functions to make the behavior explicit.
> > > I didn't want an un-set value bug to creep in here somehow.
> > > 
> > > Happy to drop them if you think that's unneeded.
> > > 
> > 
> > Ah
> > 
> > Not setting the value in each of those places is equivalent to setting
> > MMOP_OFFLINE (0), so better to just set DEFAULT regardless.
> > 
> > So unless you have strong feelings i will keep them as-is.
> 
> Right, the mild feelings are only coming from the changelog mismatch
> which says "Oh no, device-dax drivers can not specify their online type
> besides the default" and all this series does is keep the status quo.
> 
> That can be had by just having unconditional:
> 
>      online_type = mhp_get_default_online_type();
> 
> ...in dev_dax_kmem_probe() and get rid of dev_dax->online_type until the
> first user arrives. If you are respinning the series and that patch
> drops, yay. If not, oh well.

Oh, it took me a second, I see what you're saying better.

I can drop .online type and follow up with the .online_type + CXL build
time patch as a separate series as you suggest.  Keeps this series
clean.

~Gregory
