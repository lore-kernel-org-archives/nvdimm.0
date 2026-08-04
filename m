Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF07477292
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 18:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785867180; cv=none; b=dlaTIDeM4AUj2+J5suOSUHR3AmBWfrK56HY8+6esaLbrq5QgJNwrQf7KKLH5km8ff9oYeOewQ/4OH8XexCQRkk+M2M8ITZv0T51ovvg+d+qvY7lqjy+WZjg/Qrtu46xXEJpnSSmedqjaAPXHHa6+8S1p2Ii4lt7a77vJpNvUh18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785867180; c=relaxed/simple;
	bh=NT9Qi2eMGwG0QI/OnKkKdPaeDSMLaxRU32STllPny8s=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tzk9EhuTOakXE97xAMvT8CM11LyXpHSCYMAfXxW+IR/sP4pkkRBex8Kzq+covyMAhUMnngrKxLgFZanKTtwJum6oDzOh83WlOLhnHwpGThRbXzENeAjrj2kcYXCGFvm+1GxADS5wp+ww4IyLe8iLJ9c8x+ZbJt2d8u3dkzkMAWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qgh84hDV; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qgh84hDV"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38511175ad3so85959a91.2
        for <nvdimm@lists.linux.dev>; Tue, 04 Aug 2026 11:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785867177; x=1786471977; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yX7DTtC7q+PlU+NI840IY/UHNK94JJqd3SZG9x5s1lY=;
        b=Qgh84hDV8LWfW0yWfiHWNryYjMTor/r+6yTXISeYtGOpr9eKW/rZFbrn3hITRyDby8
         kBBQ74s+sz72KkE1kuAgxTvrCxEveQIKCJLuSr6U1IFS9deeAhPez93Fb2HYfn8uVA4F
         Yq3SADlDa60ztRDmRuXh6bh8GhrDFPiIJlrX3XeoQpAyW6GDbF+ckSoTbKF+c0H8R2e+
         5s3YPnxywDrDV9NpQvlEbbUx+FclGpDu4ftOZ+22Tuv/mMfx2zwYfnKAjSd+iGozL95A
         NJ6JB0RyNhcSkmTXDJtrsXKA6uFR2D9QE0H8eSa9gD3JgYlr5y12Qujq004dXraKpyIN
         ajnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785867177; x=1786471977;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yX7DTtC7q+PlU+NI840IY/UHNK94JJqd3SZG9x5s1lY=;
        b=qHhPvFZN6OKn5y/Qe8PVQqst7FS7uY0zq7tZmn+QKNIxIGZb4AzzLVtNGwMA9KQlHS
         0HgBLNI2ZG5ZM+NIaNF3qNpRzcyg/WhwJ3hHBGBZqYcRTEVeUerwg13r050OXJYq2fzs
         MTF0DvumCqBXOwWW8sxi5ZbDga7RoX/YqloO/g6GL/bTgfqaMRXtI18fGEnzE2l1yQgA
         /DSCTMH3QtuiGGnw+Z0/5FOdZVQ/pz+ZbWGP7+gpWNZpoFUJg8nLDOuW5bX6R3I5iPra
         gTBc+Q8slFV4kPWi41CwUg9yk5fHcWtNptEAKXorvnM1P3Pd73k57yiEv36DCRqq51Hk
         NNOg==
X-Forwarded-Encrypted: i=1; AHgh+RqcYPUtxmbkARiFqSbTnmJTIZtiqZkAdJwFTGVY6Lw73aUqktOkYYQeTbJ4dxt9DQ3KmJFIo5k=@lists.linux.dev
X-Gm-Message-State: AOJu0YyT4nqgHstFPzC+Ebyw8EsCi//HhGkvk+lVneDXs/p7YS5aqoU+
	rcofwIERSqJUsXB/9ySAsn3An90F+GWX0S9BOvQueeu4FAalnTXs3SpD
X-Gm-Gg: AR+sD11mP/Y9C7keciKj9R03EkTqqFA2SELaJ9Wjn5rNOk+Xm9IczvPHMJR9uuanH3l
	USfDESNL4QWpqIFxu+NdpzVq30c5vXWmVZWPsmNYmnYHanfpJG6RJEWs0Bpq1DoWvzhVkMZ0SVx
	Yl6RcU4EgT7qHiagFHeVHKyvwv3DfvopzHCdUDLIN9NdmRp88YCCl4OKCccIRUo1JWGGayof6EQ
	8WOqgzO9ukeQgp8Q4KAoe3ETfWFo4BKKzIQnoPFz17AyM8m11CYDabMv88F94MWDqkBsBr9TIj1
	SccEO4pNRx6mwAQzRWNOgWAki2QK2jacO+hgRenmPmi3B/OQH43MAUuG6Dke3FASgGElNpcyTq3
	Fjl0eYmJOmXP7UdLKOFtMxJeFVqqX7JyzqwtwEVrHBKbc8qcC/aeo6BkJVbuK3SotUIES8BnucL
	65W42My6ujfjOW+/HskakWDzsNF9BntwEI7Tm5V/cbAD4exyW3JuzEevxq
X-Received: by 2002:a17:90b:51c2:b0:38f:23d6:b4b4 with SMTP id 98e67ed59e1d1-3903c6809f6mr725038a91.22.1785867177031;
        Tue, 04 Aug 2026 11:12:57 -0700 (PDT)
Received: from cxlqual ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38febfdae85sm1787046a91.3.2026.08.04.11.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 11:12:56 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 5 Aug 2026 03:13:25 +0900
To: Alison Schofield <alison.schofield@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
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
Message-ID: <anIrxeDKMRKU4dlu@cxlqual>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-2-anisa.su@samsung.com>
 <anIZiJ8E0EXs2kS0@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anIZiJ8E0EXs2kS0@aschofie-mobl2.lan>

On Tue, Aug 04, 2026 at 09:55:36AM -0700, Alison Schofield wrote:
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
> > ---
> > Changes:
> > 1. mbox.c: leave mds->dcd_supported false so the hardware enablement
> >    patches can be upstreamed ahead of the extent and DAX work; the
> >    event handling patch re-enables it.
> > ---
> >  drivers/cxl/core/mbox.c | 44 +++++++++++++++++++++++++++++++++++++++++
> >  drivers/cxl/cxlmem.h    | 20 +++++++++++++++++++
> >  2 files changed, 64 insertions(+)
> > 
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 7c6c5b7450a5..4790524c32a7 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -165,6 +165,38 @@ static void cxl_set_security_cmd_enabled(struct cxl_security_state *security,
> >  	}
> >  }
> >  
> > +static bool cxl_is_dcd_command(u16 opcode)
> > +{
> > +#define CXL_MBOX_OP_DCD_CMDS 0x48
> > +
> > +	return (opcode >> 8) == CXL_MBOX_OP_DCD_CMDS;
> > +}
> > +
> > +static void cxl_set_dcd_cmd_enabled(u16 opcode, unsigned long *cmd_mask)
> > +{
> > +	switch (opcode) {
> > +	case CXL_MBOX_OP_GET_DC_CONFIG:
> > +		set_bit(CXL_DCD_ENABLED_GET_CONFIG, cmd_mask);
> > +		break;
> > +	case CXL_MBOX_OP_GET_DC_EXTENT_LIST:
> > +		set_bit(CXL_DCD_ENABLED_GET_EXTENT_LIST, cmd_mask);
> > +		break;
> > +	case CXL_MBOX_OP_ADD_DC_RESPONSE:
> > +		set_bit(CXL_DCD_ENABLED_ADD_RESPONSE, cmd_mask);
> > +		break;
> > +	case CXL_MBOX_OP_RELEASE_DC:
> > +		set_bit(CXL_DCD_ENABLED_RELEASE, cmd_mask);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +}
> > +
> > +static bool cxl_verify_dcd_cmds(unsigned long *cmds_seen)
> > +{
> > +	return bitmap_full(cmds_seen, CXL_DCD_ENABLED_MAX);
> > +}
> > +
> >  static bool cxl_is_poison_command(u16 opcode)
> >  {
> >  #define CXL_MBOX_OP_POISON_CMDS 0x43
> > @@ -757,6 +789,7 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
> >  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> >  	struct cxl_cel_entry *cel_entry;
> >  	const int cel_entries = size / sizeof(*cel_entry);
> > +	DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX) = {};
> >  	struct device *dev = mds->cxlds.dev;
> >  	int i, ro_cmds = 0, wr_cmds = 0;
> >  
> > @@ -785,11 +818,22 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
> >  			enabled++;
> >  		}
> >  
> > +		if (cxl_is_dcd_command(opcode)) {
> > +			cxl_set_dcd_cmd_enabled(opcode, dcd_cmds);
> > +			enabled++;
> > +		}
> > +
> >  		dev_dbg(dev, "Opcode 0x%04x %s\n", opcode,
> >  			enabled ? "enabled" : "unsupported by driver");
> >  	}
> >  
> >  	set_features_cap(cxl_mbox, ro_cmds, wr_cmds);
> > +	/*
> > +	 * Disabled until event handling implemented.
> > +	 */
> > +	if (cxl_verify_dcd_cmds(dcd_cmds))
> > +		dev_dbg(dev, "Device supports DCD; capability disabled\n");
> > +	mds->dcd_supported = false;
> >  }
> 
> Hi Anisa,
> 
> I read and agree with the other reviewers that this does not need to
> mirror the poison and security command handling.
> 
> The one-use cxl_verify_dcd_cmds() helper still seems excessive. The
> bitmap can be checked directly here:
> 
>     if (bitmap_full(dcd_cmds, CXL_DCD_ENABLED_MAX))
>             dev_dbg(dev, "Device supports DCD; capability disabled\n");
> 
> And then once DCD is ready to be enabled, the assignment can become:
> 
>     mds->dcd_supported =
>             bitmap_full(dcd_cmds, CXL_DCD_ENABLED_MAX);
> 
> -- Alison

Applied :) Thanks Alison!

- Anisa
