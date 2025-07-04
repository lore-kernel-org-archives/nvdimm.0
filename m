Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B9A1DF247
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 23:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751671750; cv=none; b=njImtOMwCxis6KO91xY8+5yTrNMDyRE6koQC0aLlH34LuUpQcpl54AClaw5TQ66lrSDZGCjhyHtfvWIbdW7FqTSzng9cLs2O89h61VMfN0o/1/N92tSo5Ghq3V2Viln5QCKF3siD50CQrwFYdSfcO8NO+ZY9kHzP0Q17H++HzWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751671750; c=relaxed/simple;
	bh=tb8VBPJk816dMuwf1mAIMCyy1yCn7uftotKSToGx4zY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZKNHhCFG7DpMDUtC9XDWkzd6T7bnbmPbNLfAEHmkUSMmmIYPIeCoeauJknJK4BYGl4AMtUE4jcZJCh3VNG1cTGDzjyxB/ZAgqgXFQvVeemmcvmIuUc3LoA8gCJM9/x+22xOObR7K/j6aeztRuU2unhmQCZ32BetUseCAbSJwuso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WplcZUjB; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WplcZUjB"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-23c8f179e1bso3428095ad.1
        for <nvdimm@lists.linux.dev>; Fri, 04 Jul 2025 16:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751671748; x=1752276548; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QuwFRRF8QKbV+T5Rtpk9+ke6COijCSDaKe6s+BtINKI=;
        b=WplcZUjB+b05icLnq2N0HiV/tA5Amdsx/wsDf+MIjVhHxpi4QUKZDyPJCnLlL1GRW6
         Mot2m6sSanIGk6PeshZkPNkEmxHDs9fFqJCG77OJEtMNABzBKV+x/PfAIP/sg1A312Cg
         U7g4fIMQId7Ipa8vm/OI7OoPUPqjh68azfO9lahgdor8PdCWcuzInDnaNjb7EKH2JHVX
         LUl9nxm8QAcqxYsO89ZFtkBzrICzs8t+GoOL5/iADSD/XNZcPQLTnbOu8iOiqupoqTOX
         xhzweV89Z2QwC49D+Oq7aLtZDpVu9h0iPw9mbxW75uy2y/89Vx8uSF5myPpOWyx4OFpn
         dOmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751671748; x=1752276548;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QuwFRRF8QKbV+T5Rtpk9+ke6COijCSDaKe6s+BtINKI=;
        b=h+31Yj/mua4jPdTipQPegeAbt9gTn46l9Zl2QfxzqTq/1aoFr16TAXg8CXcZlTWPOF
         eiZf3sG79d2Dx2eVF+rgvXavq1KgLrZHqzuBqdNAb2qJNGwKqGlSqabpVb3vsupBqLzF
         OmM7Rpt4dM0MhZvMbhhR9vdv35bPSdS5/7P/uJsnL+zszUE8g5nY018xunOegwAS/RTO
         VqmLKhaqJFdbAoElkjUYryYq99v78IxoPWS3Mv2Y3JMbk120qmqY8CGLYA49DGoLTPgE
         ecZ92i3fCPOsmo5+d56RbNKCK1eUpTPgwMZzRRGli4SY+Gtfr2sdoXVzAFe2EpKBDaTs
         lkRQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+nEuX2xqeLafN1Xlp1IuYr7LP7Av12iywV5NloxF4KJ5uD5Ecs4bzBoGr7knrZk7Dvxa2dWM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzxa0AO0NLtohdh6FaBbfYuk4b59wAlQ1N+BKPFPkSZZ9snQ06L
	B2TTQo25eQZj4/QNo0uhxpQhNkpk+j1RQRYnSHbjmCA4C3Yaazijs3BD
X-Gm-Gg: ASbGncvmG9OlriLGLBMKU6OC44UT+MEfm0SMVzPSkS/zxPZcChd4/Zk8K3/b7KztG+/
	26ncJ98SiZ+GqJtN8VlBvu56TarFOAr7xLHd5hgku2Dxfm6tcVyXLV5v/lkYKMTHj1KPBTCWaVd
	PAzN1lmf1+KcixHjl6KFohq7hRnImll28ysWFkV+KqkUemlq1YO7/F15RttKStnBdDixciH6jXH
	liSjBTbfZhXtzxL31IRQHipGvwaS/I2WZsPqOe6aD/sMJjEpgGujol6Ahe7Eic15pQv1AwkC1lB
	QtvUU4+L4zp39t19lib3qREcpXLP0Rls29YAUwClnx9h/I25HW6lCYy8xoeuEw==
X-Google-Smtp-Source: AGHT+IEmWW8RNAKSZbgocL/eZEJbLbFOSAUUCEKiyVb4oP1j89S88LZhuuNGHm/fWdWQBli8Lf9cWQ==
X-Received: by 2002:a17:902:ccc4:b0:235:e942:cb9d with SMTP id d9443c01a7336-23c8747dfafmr48499875ad.17.1751671748171;
        Fri, 04 Jul 2025 16:29:08 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c845bdfe8sm29463235ad.244.2025.07.04.16.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jul 2025 16:29:07 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 0D9A54206889; Sat, 05 Jul 2025 06:29:03 +0700 (WIB)
Date: Sat, 5 Jul 2025 06:29:03 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>, John Groves <John@groves.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Miklos Szeredi <miklos@szeredb.hu>,
	Bernd Schubert <bschubert@ddn.com>,
	John Groves <jgroves@micron.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 18/18] famfs_fuse: Add documentation
Message-ID: <aGhjv37uw3w4nZ2C@archie.me>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-19-john@groves.net>
 <aGcf4AhEZTJXbEg3@archie.me>
 <87ecuwk83h.fsf@trenco.lwn.net>
 <aGdQM-lcBo6T5Hog@archie.me>
 <aGgkVA81Zms8Xgel@casper.infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aGgkVA81Zms8Xgel@casper.infradead.org>

On Fri, Jul 04, 2025 at 07:58:28PM +0100, Matthew Wilcox wrote:
> On Fri, Jul 04, 2025 at 10:53:23AM +0700, Bagas Sanjaya wrote:
> > On Thu, Jul 03, 2025 at 08:22:58PM -0600, Jonathan Corbet wrote:
> > > Bagas.  Stop.
> > > 
> > > John has written documentation, that is great.  Do not add needless
> > > friction to this process.  Seriously.
> > > 
> > > Why do I have to keep telling you this?
> > 
> > Cause I'm more of perfectionist (detail-oriented)...
> 
> Reviews aren't about you.  They're about producing a better patch.
> Do your reviews produce better patches or do they make the perfect the
> enemy of the good?

I'm looking for any Sphinx warnings, but if there's none, I check for
better wording or improving the docs output.

-- 
An old man doll... just what I always wanted! - Clara
