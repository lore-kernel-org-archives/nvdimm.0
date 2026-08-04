Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98DE2EC0A6
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 18:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785867005; cv=none; b=YV84T7GVLnH0FbznImul2RcUHih/Avc2ITRU4lIjQwWPmgiP1pFhUcBWawbjdKyeygg/Arkb8m4AOFy8gZ2z7o8GQcQWXvr5b2RmCE4Ht+GsIwsnraqgglfJP5mPFT3atuHLDl3lNcr3aH+aFvaoGyZQLbhihXgtlih/MJlHK40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785867005; c=relaxed/simple;
	bh=4DzNlfV0nu22s4oTVgl3zMJGFMkBmYe8BcT3HGooQ1o=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gkflF9lHk++gD7BszQIPiIofet4zHT5TWCLr9KPOdnG+Z5YLr3a2zZ+1xduw8ABaZalUKRLy5zG+OH2C7j+093VBwAR5Ambuf11mzfXQLMSVTJOAi1V1NAuGIlYTiwSTQtE4ush+2MQWh6VUJThoPpMAi9oM+a/eGDFSS4I/3AI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8U00Vq1; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8U00Vq1"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cfff5f88dbso2121125ad.3
        for <nvdimm@lists.linux.dev>; Tue, 04 Aug 2026 11:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785867000; x=1786471800; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qs7yGJO2dUWBigiOU3NbR/yvvnHHod0LNbMlLn9fo94=;
        b=j8U00Vq1shluHaR+zk3Vp2c/okAz5mcVvXl54xM5Ql2DuZ1esG6sWP5T8BK9AYiHR+
         xwG2PSN1UiRumUyoGOiyAXkSDcVCdp7c1m5M5BQ0mlo9NzcY94eTr2WHOlpXj2PnFyWh
         cX/ezY5JJ5yjUJ4sA5IyxBj4nU6B25xQwgGH/EvEg+OVhzjbQfSJ0oHtTwjLwf17ZpJL
         u+GahtmRVX5vD4gCweqoRFs9LUGmQzl6fQFF5tN3fd4bCMqDlg35tefzsDwF08mRZM7y
         6HLf1s9tUT2D9eSqGT2xlPPbAq4tJEftNV6yNVuWGPkeS3fJdakpnj45MgK0dJes+t1R
         7QVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785867000; x=1786471800;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qs7yGJO2dUWBigiOU3NbR/yvvnHHod0LNbMlLn9fo94=;
        b=CcB7kfETYQ3Mn87kVzu538aTRy04v/8w8kNAel7NA8ZUFhdjHWPjYIFMUkkodz/XtR
         PjQv+1I6SkNQNZHD2rTOAkKctDUM02BMNO3Cu4Ev7OS9GciF1YtBsO0S71cf4Zwc+R8O
         Kpz/oery1AyJfCsFgdFdXNejaZUi8XY7lOxaOHR1JoPcXqltzUtY7HmJ61Fb8f4q+oWH
         RNQ976mZUOwUWuv91UcEtK2KFZdfR8QVtnA/AYFqQcAm+wMx5z4RuQ8P1jtB+jJBoKHj
         OjBZaILX9A6u8hGbSBFH0UnkPMEdAwwfdLmETuVzBdQJcyhnbOY1dKndB15qTAJnoiSw
         uIhQ==
X-Forwarded-Encrypted: i=1; AHgh+RqFfFK8RpZawqLB4S0zwCjqIuqH5cWj3SqKwfKIvdaQ+IjAPw6HfT0L1xFKOzDIQe5rycj7UU0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwKEUAN37Q3eoqcqaKQLzB8VlBWIZxi0Ih+SAIuAPuBylXUecf
	wmVyMUeXq/9EHjj40sxZwNpCXslFgfXFfiSFEddrsNvMMwApSx5Fo9cP
X-Gm-Gg: AR+sD12C30If/EB4Y3UW7WgJm84AbHwRmsT8S0IwiBWzjtoYoAlaJY/a5w2Ay8/M6cM
	kvI1WkK31yNFZbMB+f+klA6m+AduDTtmFm6h54bhtAs0xw5Qhz6oY7z7xoMofOYe5S0sl7DP48z
	TjEhCwNqB0XVgDActr89Y/fgColEubDId4lMY2vQcCPGurJhoIHy1jw/Fwy1uz5+ZvWmLI+1aMg
	yhP021WR/Ln0rSnkDUc+FtNq2FZC4TtP++3lOaUGDKC5UdExGt+oVTx5PJCTXrwXtqajLM5z0XE
	V/KEsPyyI3evzRVW6g/K4LYuO4aAfSb0FoHproh5XZgpHjszvywgj8GkQDhkS5nYi+NaIZht8QM
	/X0udgkEI7fJRpVCxZVeoZep8ton+665uS2EaSnPiLvSg39mZHuL8yyunycBKoarv3k6lFv2SU8
	CheWN9kX8zdgRtCR/OK6m4ZDB9CnzAWpngmDDHaejyZ/Ukd3VDQpaHvLRx
X-Received: by 2002:a17:902:d486:b0:2cf:8363:5ab7 with SMTP id d9443c01a7336-2d0ca9a2657mr5745495ad.26.1785866999776;
        Tue, 04 Aug 2026 11:09:59 -0700 (PDT)
Received: from cxlqual ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0aa4cf714sm11507535ad.67.2026.08.04.11.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:09:59 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 5 Aug 2026 03:10:28 +0900
To: Gregory Price <gourry@gourry.net>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>, Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Wonjae Lee <wj28.lee@samsung.com>,
	Junhee Park <jh9934.park@samsung.com>,
	Heesoo Kim <habil.kim@samsung.com>
Subject: Re: [PATCH v12 1/8] cxl/mbox: Flag support for Dynamic Capacity
 Devices (DCD)
Message-ID: <anIrFAYITF2L2UOY@cxlqual>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-2-anisa.su@samsung.com>
 <anIJFdtTEmofty6U@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anIJFdtTEmofty6U@gourry-fedora-PF4VCD3F>

On Tue, Aug 04, 2026 at 11:45:34AM -0400, Gregory Price wrote:
> On Fri, Jul 31, 2026 at 01:48:06AM -0700, Anisa Su wrote:
> > From: Ira Weiny <iweiny@kernel.org>
> > 
> > Per the CXL 4.0 specification software must check the Command Effects
> > Log (CEL) for dynamic capacity command support.
> > 
> > Detect support for the DCD commands while reading the CEL, including:
> > 
> >         Get DC Config
> >         Get DC Extent List
> >         Add DC Response
> >         Release DC
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Signed-off-by: Ira Weiny <iweiny@kernel.org>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> > Tested-by: Junhee Park <jh9934.park@samsung.com>
> > Tested-by: Heesoo Kim <habil.kim@samsung.com>
> > 
> 
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> 
Thanks for taking a look : )
- Anisa
