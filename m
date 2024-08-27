Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFA41BFE00
	for <nvdimm@lists.linux.dev>; Tue, 27 Aug 2024 16:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724774564; cv=none; b=LVhnMiQd2JHbhx+zkONCwl8cJ7d/Tq9lwo3iKiVCymvkmDev0WNpBND5sRzCPZLeSZdP8iK3Xqb8i/H6zuOEPQtaNQt8JmAdW2Vq6/SGINGhD/x4Z65HItabm6fl0J9RFcnE4tlo6X8X0iqSaC5vFTjIGgyViVDNj/rONYwdTZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724774564; c=relaxed/simple;
	bh=bftQR8XAiOa4Kj1zRha66tu+wQd2k7qmj7VrqkjwAew=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MN8JBI7rpPqp6HbNXqZVgLpqsIpWIuWCGiuKISCAxv15+VM+yme7TFfMEW+olrqy01j9ljemAFYyBLy8Zo/UuBmysboLD/SirPJae8pCNc3LNKqYwixaQjY/8ADNDDnDRb1hkJOMyUAtTZeFpGxxyT235bNDdsKMtci3FnyrtPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nSs8Je97; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nSs8Je97"
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e0875f1e9edso5488003276.1
        for <nvdimm@lists.linux.dev>; Tue, 27 Aug 2024 09:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724774561; x=1725379361; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YUynhOlcmLN7T5QW4XtgVMkPbI5R+at4MqJPO3psk2k=;
        b=nSs8Je97KLb1FBXvhLR+TsGuww7q2Cjk34lDCvoQoMWRnJuJFP6SU1myjEN0xMuTnZ
         tWPqWxiM6LFnerxsBVdfFcCCgfD0tHzfA6uVmc/wm9uqxSUvdGBuk8VWdekJ0/j71QML
         KXdfovT6h5rzugVMxc1SeI0VUKRf6XBk+EQkuLIg9dQtoNNN354xcgdCVDeBKyT/LBbz
         8OywIxoLVTnymcvn5jLejnc+9HqkmlQ1Pr73pn2JL7Hl0P/CtlGQQtMVhXlMWPrprSFs
         e0TpFTDYEHeQ0p+Copq4OTygI9yiwpbuj28MXhdx9cRr9lqyRuMeqvuuSoC2dXtipAI/
         A6Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724774561; x=1725379361;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YUynhOlcmLN7T5QW4XtgVMkPbI5R+at4MqJPO3psk2k=;
        b=P54baBO1Ot1FTBcaTyJj50IzJ9bHwFFWdp98i/d/jpLNANzJH1cFDiqR9LpC/Upphj
         u3QLOOyaL4L5PmZC4Yu5Z+DEiUK3jvEz9v/znz5wFE6xhyuWmUKAc2JBgTbjCnv1H5b+
         XMMr6+4sf//cyD3Qp9/s0aluBjJmrzZlVZ0QVD255rGtDgwwtfqNxOL4OJ8uOyMH7Zze
         ZJ6gtJw89egm31B76VDqSUsczebmFkuorPCKqiQtildJcXS4Kzc4v7+S8xoqFzD7yhRe
         OPf9QA9ruZyCF2lt7SnWM1HwyezlIa6pXoHzdoBmRsGHxLH8cBVGlotqCFFNS62d9fsc
         qQhg==
X-Forwarded-Encrypted: i=1; AJvYcCWbtYuJBCYeoAspAapluc7NOXmKtwUk8k7ybdZGmtP4Ppae5i0eHTcQhU/XXOE7ls0X12XEg4M=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx49G6JJLXM28vU2Egcyq0vevOuIw2F/H+W94bgWpuNRSywhvZu
	v5cnzdVk0ZCPh3LmAuK7CH6PNuH9LtehTrqT3h7jLp7vTVJW3h/L
X-Google-Smtp-Source: AGHT+IExAE08HkQ1ORhHjbfWeAfdnCQmLvshPsVsu4uByYzu2KqQJJMTlxqXuTwlDzVPJS9Zd5JWcQ==
X-Received: by 2002:a05:6902:2202:b0:e13:d6f2:1181 with SMTP id 3f1490d57ef6-e1a2a5da391mr3211223276.26.1724774560695;
        Tue, 27 Aug 2024 09:02:40 -0700 (PDT)
Received: from fan ([50.205.20.42])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e178e4b3883sm2584126276.32.2024.08.27.09.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 09:02:40 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Tue, 27 Aug 2024 09:02:11 -0700
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Fan Ni <nifan.cxl@gmail.com>, ira.weiny@intel.com,
	Dave Jiang <dave.jiang@intel.com>,
	Navneet Singh <navneet.singh@intel.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v3 18/25] cxl/extent: Process DCD events and realize
 region extents
Message-ID: <Zs34b4DoMmd9GO28@fan>
References: <20240816-dcd-type2-upstream-v3-0-7c9b96cba6d7@intel.com>
 <20240816-dcd-type2-upstream-v3-18-7c9b96cba6d7@intel.com>
 <Zsj_8IckEFpwmA5L@fan>
 <20240827130829.00004660@Huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827130829.00004660@Huawei.com>

On Tue, Aug 27, 2024 at 01:08:29PM +0100, Jonathan Cameron wrote:
> On Fri, 23 Aug 2024 14:32:32 -0700
> Fan Ni <nifan.cxl@gmail.com> wrote:
> 
> > On Fri, Aug 16, 2024 at 09:44:26AM -0500, ira.weiny@intel.com wrote:
> > > From: Navneet Singh <navneet.singh@intel.com>
> > > 
> > > A dynamic capacity device (DCD) sends events to signal the host for
> > > changes in the availability of Dynamic Capacity (DC) memory.  These
> > > events contain extents describing a DPA range and meta data for memory
> > > to be added or removed.  Events may be sent from the device at any time.
> > > 
> > > Three types of events can be signaled, Add, Release, and Force Release.
> > > 
> > > On add, the host may accept or reject the memory being offered.  If no
> > > region exists, or the extent is invalid, the extent should be rejected.
> > > Add extent events may be grouped by a 'more' bit which indicates those
> > > extents should be processed as a group.
> > > 
> > > On remove, the host can delay the response until the host is safely not
> > > using the memory.  If no region exists the release can be sent
> > > immediately.  The host may also release extents (or partial extents) at
> > > any time.  Thus the 'more' bit grouping of release events is of less
> > > value and can be ignored in favor of sending multiple release capacity
> > > responses for groups of release events.
> > > 
> > > Force removal is intended as a mechanism between the FM and the device
> > > and intended only when the host is unresponsive, out of sync, or
> > > otherwise broken.  Purposely ignore force removal events.
> > > 
> > > Regions are made up of one or more devices which may be surfacing memory
> > > to the host.  Once all devices in a region have surfaced an extent the
> > > region can expose a corresponding extent for the user to consume.
> > > Without interleaving a device extent forms a 1:1 relationship with the
> > > region extent.  Immediately surface a region extent upon getting a
> > > device extent.
> > > 
> > > Per the specification the device is allowed to offer or remove extents
> > > at any time.  However, anticipated use cases can expect extents to be
> > > offered, accepted, and removed in well defined chunks.
> > > 
> > > Simplify extent tracking with the following restrictions.
> > > 
> > > 	1) Flag for removal any extent which overlaps a requested
> > > 	   release range.
> > > 	2) Refuse the offer of extents which overlap already accepted
> > > 	   memory ranges.
> > > 	3) Accept again a range which has already been accepted by the
> > > 	   host.  (It is likely the device has an error because it
> > > 	   should already know that this range was accepted.  But from
> > > 	   the host point of view it is safe to acknowledge that
> > > 	   acceptance again.)
> > > 
> > > Management of the region extent devices must be synchronized with
> > > potential uses of the memory within the DAX layer.  Create region extent
> > > devices as children of the cxl_dax_region device such that the DAX
> > > region driver can co-drive them and synchronize with the DAX layer.
> > > Synchronization and management is handled in a subsequent patch.
> > > 
> > > Process DCD events and create region devices.
> > > 
> > > Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> > > Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > >   
> > 
> > One minor change inline.
> Hi Fan,
> 
> Crop please.  I scanned past it 3 times when scrolling without noticing
> what you'd actually commented on.

Sure. I will crop in the future.
Thanks for the tips, Jonathan.

Fan

> 
> > > +/* See CXL 3.0 8.2.9.2.1.5 */  
> > 
> > Update the reference to reflect CXL 3.1.
> > 
> > Fan
> > 
