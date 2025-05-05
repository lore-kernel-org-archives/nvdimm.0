Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFD413B7A3
	for <nvdimm@lists.linux.dev>; Mon,  5 May 2025 21:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746479099; cv=none; b=en+tPe6UDlRXLT8DXSHSl2xdFkrr/SYqEb/HvZKv1oIcpOKpOnPu8cwEmuGBFHX8whqUHIWJrjOHXTMEG6Ab3bkLObi1UmjA2rO1C2nrbHLGgLiyIAtu430JdoMVNanC2tErluruOPYIAIXnJM1nnxowLCCUfAKoDocZE2EEba8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746479099; c=relaxed/simple;
	bh=FGiWGc+82PiPbIk6BF5/UnObbgn45qQJgVgN4UIx1T4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LbyXBv0QOZJzEzDhRSyBHFInlgY9gylHMsajPeK3t+8SN0dyI1ewX+PT/yFRp4fXfyN4pGg1hNiBao82c2C84rQ0bvP3sJo/mpPI18BOg2sPepjx4/0H15foadO33xMJZBftG4f425aUugT5T/aXfO1nelARDCLwCSySofn3zlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RK7GWy4H; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RK7GWy4H"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-22c33677183so59031015ad.2
        for <nvdimm@lists.linux.dev>; Mon, 05 May 2025 14:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746479097; x=1747083897; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f203cTbIpPkVhyyjjbKF+s15CLqMptv+0eTp+x4sYXs=;
        b=RK7GWy4HSYkcHKY88suJgtm57oWWEYacoFbAAdGJvV33DyVXh3n7T4xZuQwns/XkiG
         ZbmLzCZN1tOVsiYH5D0CyQvZEOY9IIV1YsgVpobzzHHwoaNf3nLj6GH86MXFLBVrbdp2
         UQD6G3PTjLSkqzhpk4Z8rnu/nMMhzgsczy6DMou1ECyGfjcwSRj9K5kLDfcUiYVU9XRL
         XibBfchHYHVudbEAXrhH8WM9gErjqIcnjqPgk1Wo2Z6UNu4q0U1MwAJ8Gndn8tVEC9K+
         HhnR8iZFlfWeHB2NFu4IXkve/ELvdjAQB+bNz209QxkEGwTG0OtFjyn3pFK541aeKAHG
         pP6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746479097; x=1747083897;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f203cTbIpPkVhyyjjbKF+s15CLqMptv+0eTp+x4sYXs=;
        b=pz/mb8v43pCdrJrG67oHo8EPg8FUVxcN9N99Eo7YTV7f/EjT1yuFh2ToonECL9OSCV
         TM0HpbYMZHtM7nMRUyoSKMJioX7Ip53rcnJDYorvXuLDHFUlnIKXXy0FxekZQB0Zssfd
         knj2WIqblCQ4CapZEW/APLefzM8GvynQYviiQ8QbzfVvvDtcLsIJNJazmpALOtYhNi7v
         Psv3NWVFSbVF8o1S88lbO4QXFRLUF7JMY/qPFFCckO24GI5A1rSMRcO+cPQ+/f1nPaoD
         d2p1ROHaDh5ZKPk5qKu21LoAOC0DcCn3dVkGZsFC7iXz8QEAqd5x/ppzb0QUadEzANT4
         g/Nw==
X-Forwarded-Encrypted: i=1; AJvYcCVu2h983YlZslNAKNnyXVPXEH1tvjmOyd6hgr3NLiW6UbmYu4H2L15ItMI9a34qJ2eZXIJTiGY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx059roAUjDhJ2LbyhNRKWL3m6t3JaBtXagtv0wwz/xEbWG2fKz
	0xHvlhN3eFq0Dn4gX/JfxrpScCjO76iOZcCJoaRH+k09FpK0z2q4
X-Gm-Gg: ASbGncvBGdGJ1sgq7/Z0W6Qub2HmwA64isa+hVLYZuFYZM0lNkVi2ii/rlwv/ei5OHa
	IYzQclf4+OFyXrZqb+rXsOsg3pPwMJCBG2fC9GT5b4M/1uJ51wSudetIjJRCKHfdZH1i5+tnrSQ
	7hoUhmSx7CQwc7gk6G+Vb/BmyGaTWJoUd2v/lath4AP66miWKFTHPFJDeS8oAU/++r2SzGbhpEm
	sGmDcjjuUF2y7o+lyWln5YBPbxMhg37NTcwItfoYcxzg7oAqp2zbOzwJI8kiU7XWsC3tugUqQbG
	CEwYEXcKzSB/O2T4iIXfpwuAYfpEghw=
X-Google-Smtp-Source: AGHT+IEpMlyP16CP04/9tmk3lHcgVxz6nJ39N1Oa0bFBCxZGfdK56DSPwOXRU3TsqUpZZQ+683qOAQ==
X-Received: by 2002:a17:902:d482:b0:223:67ac:8929 with SMTP id d9443c01a7336-22e1e6ec76amr132240305ad.0.1746479096883;
        Mon, 05 May 2025 14:04:56 -0700 (PDT)
Received: from lg ([2607:fb90:87e0:9bc2:145c:221c:4526:62fe])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151eb3b0sm59890325ad.103.2025.05.05.14.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 14:04:56 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Mon, 5 May 2025 14:04:51 -0700
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 01/19] cxl/mbox: Flag support for Dynamic Capacity
 Devices (DCD)
Message-ID: <aBkn813skYvTv7QC@lg>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250413-dcd-type2-upstream-v9-1-1d4911a0b365@intel.com>
 <20250414151950.00001823@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414151950.00001823@huawei.com>

On Mon, Apr 14, 2025 at 03:19:50PM +0100, Jonathan Cameron wrote:
> On Sun, 13 Apr 2025 17:52:09 -0500
> Ira Weiny <ira.weiny@intel.com> wrote:
> 
> > Per the CXL 3.1 specification software must check the Command Effects
> > Log (CEL) for dynamic capacity command support.
> > 
> > Detect support for the DCD commands while reading the CEL, including:
> > 
> > 	Get DC Config
> > 	Get DC Extent List
> > 	Add DC Response
> > 	Release DC
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> 
> > +
> > +static bool cxl_verify_dcd_cmds(struct cxl_memdev_state *mds, unsigned long *cmds_seen)
> 
> It's not immediately obvious to me what the right behavior
> from something called cxl_verify_dcd_cmds() is.  A comment might help with that.
> 
> I think all it does right now is check if any bits are set. In my head
> it was going to check that all bits needed for a useful implementation were
> set. I did have to go check what a 'logical and' of a bitmap was defined as
> because that bit of the bitmap_and() return value wasn't obvious to me either!

The code only checks if any DCD command (48xx) is supported, if any is
set, it will set "dcd_supported".
As you mentioned, it seems we should check all the related commands are
supported, otherwise it is not valid implementation.

Fan
> 
> 
> > +{
> > +	DECLARE_BITMAP(all_cmds, CXL_DCD_ENABLED_MAX);
> > +	DECLARE_BITMAP(dst, CXL_DCD_ENABLED_MAX);
> > +
> > +	bitmap_fill(all_cmds, CXL_DCD_ENABLED_MAX);
> > +	return bitmap_and(dst, cmds_seen, all_cmds, CXL_DCD_ENABLED_MAX);
> > +}
> > +
> 
> 

-- 
Fan Ni
