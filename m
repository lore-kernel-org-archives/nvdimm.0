Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16EA191F91
	for <nvdimm@lists.linux.dev>; Thu,  2 Jan 2025 18:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735841849; cv=none; b=L0wqNtZScmS3bsSYVFtec0ruUoIUUYsxEEVJppzJ/WviBkBTkIh+g+1ETpurzRTmM0zxmuUdrjGr5jttevTiaoGqncvdhBzSfa0TjrDHQ91+uIrH7zunA2XXRy9c/biiJ41D4+dwE5pVE1nyaP0FzDBb7yEd+doxxzsCXN9PbO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735841849; c=relaxed/simple;
	bh=56KyMH36kkt8ZIoRmqH2Gmj+Cu5YZ7EcdIm5YbsdOdw=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d2xT/nvuEADO0RvWJJH4j8WCy23wKR/GIRXzz781bHVD+P88COBUkjexiRsnV4QF6tqkM49m6h+ixhyDS4V3NjJD4WvLH7y9i06qpFzhxxaZ5zLE8Yln4hRQX+Oy1eGT6jj+j8VzkGJAXvcEVS9Vz+3Xrl61rZ9r2EdJ5XOFb4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A6PAMLCu; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A6PAMLCu"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2165cb60719so160825725ad.0
        for <nvdimm@lists.linux.dev>; Thu, 02 Jan 2025 10:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735841846; x=1736446646; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KcsYGT2jr/Cwk+E0bZ78S9/+2iE2NBGtFjNzzo30vdQ=;
        b=A6PAMLCuSjSx2Cfp2yCi+KyrWK5/gY18hCh33gyOzya1hsvq9Z4BdL1RT+n9ct2ytB
         7q7IrTZZA5NF6Mad14m6bCDZpvMwz7gNqNHIEdm7ph5J2N61wc/OPd9cve7kx5F56Qrf
         Dvm7OI/C4XmnRM5Vtz22iNHDfPHhTIGALnP9RWxTajjZiEreqDGa7GNkdpuW6gmPS55L
         u1PLsvHqxeinIbInTdVkFm1wWEP70FctMF1TV05gVDeqlqWD3gyeganHrvlUjozlUIzJ
         8OO9bOZ9Q9GI9+hzt5AyVpohLtlUcBdSV+h90532BVkgHK121PAwEYk5oqULoWECNp+4
         m0bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735841846; x=1736446646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KcsYGT2jr/Cwk+E0bZ78S9/+2iE2NBGtFjNzzo30vdQ=;
        b=LstuA6BfRzJy7nxkmojKYCg+qNKJmyPzFB4QinAH1cEsQ2Mn59V0k8PhVvIbiLpTog
         A6jVtvUe5HI1/tNgzrpO9IHwJ2PGUMu7RpCiJBPHaYAwQtj6v3yWDU7DSSDjHcYAZyGu
         +rTYpX6lJ0P6bgFSz25h1jEjQcW15Ph71zu/ARWzfBrLxICq11UUruIr/+1TaVD19CAR
         oC39/M98/gR01IonSQHAgkbmhfgn7+s626O/JTg9rfRq6PqZlgxsJC6WwMlzSj0BxbaD
         o20SMUT6P/ZvBqDYr4A/PiVC2fNpemjdrr8duNc82d5IH1foKu9hRRF5U5VjkhM1CPKB
         04NA==
X-Forwarded-Encrypted: i=1; AJvYcCXtzh1L2ZA29anUE5mqH7eli6g0h1/+ZFOaa+bvlPvUxQf7SwSKxriL5OS2Y/e9k0uLlMHsc+4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxWyL+GUD3kD6KyxiWY4vj3rpnR1Cn34q9CexGmBiorf2KCX+8q
	cvZn5XLLIlIx4q9ZLR4QMNHOhROub7HViXkfgZod0c6O/kXtnqdY
X-Gm-Gg: ASbGncur0bxtPDXPJnvYkUleeyg7Qe92eBBgLL9HO76WvrQGUogxQ3fChsOqD7sK/Wb
	UfHTaA5WUrhOZ+QINUHfZ65YWtE1ExTDmL/hrFpCi6gOsKTGdNq7tixtyzRnk5HipBc8snPgiZI
	zqyPI1ga0waOPNntDFPbKajkCvhuViF6dZxr+Onm0czfyd2MEetw0kIvEMzw0OQThjoHDB+MmKl
	33/o/sFYG/SO0KvZ/z+L2QasEw7Wd1tlljFJ+r2cZON6yJWVG7wVlseIcUk
X-Google-Smtp-Source: AGHT+IGUftEvjzgeM5eRfZJQJDkV96dM36oyQ3FUyp6cKSKianTN7IVhYXtyu9gI0RnxWUv7Qt/Czg==
X-Received: by 2002:a05:6a21:78a5:b0:1e1:a0b6:9882 with SMTP id adf61e73a8af0-1e5e046331fmr66924613637.17.1735841845904;
        Thu, 02 Jan 2025 10:17:25 -0800 (PST)
Received: from smc-140338-bm01 ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad816305sm24535993b3a.31.2025.01.02.10.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 10:17:25 -0800 (PST)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Thu, 2 Jan 2025 18:17:22 +0000
To: Zijun Hu <zijun_hu@icloud.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@kernel.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas@t-8ch.de>,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-sound@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-block@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net, arm-scmi@vger.kernel.org,
	linux-efi@vger.kernel.org, linux-gpio@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-mediatek@lists.infradead.org,
	linux-hwmon@vger.kernel.org, linux-media@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-serial@vger.kernel.org, netdev@vger.kernel.org,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Alison Schofield <alison.schofield@intel.com>
Subject: Re: [PATCH v4 01/11] libnvdimm: Replace namespace_match() with
 device_find_child_by_name()
Message-ID: <Z3bYMiOG0u3Jtv3h@smc-140338-bm01>
References: <20241211-const_dfc_done-v4-0-583cc60329df@quicinc.com>
 <20241211-const_dfc_done-v4-1-583cc60329df@quicinc.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211-const_dfc_done-v4-1-583cc60329df@quicinc.com>

On Wed, Dec 11, 2024 at 08:08:03AM +0800, Zijun Hu wrote:
> From: Zijun Hu <quic_zijuhu@quicinc.com>
> 
> Simplify nd_namespace_store() implementation by
> using device_find_child_by_name().
> 
> Reviewed-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> ---
>  drivers/nvdimm/claim.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index 030dbde6b0882050c90fb8db106ec15b1baef7ca..9e84ab411564f9d5e7ceb687c6491562564552e3 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -67,13 +67,6 @@ bool nd_attach_ndns(struct device *dev, struct nd_namespace_common *attach,
>  	return claimed;
>  }
>  
> -static int namespace_match(struct device *dev, void *data)
> -{
> -	char *name = data;
> -
> -	return strcmp(name, dev_name(dev)) == 0;
> -}
> -
>  static bool is_idle(struct device *dev, struct nd_namespace_common *ndns)
>  {
>  	struct nd_region *nd_region = to_nd_region(dev->parent);
> @@ -168,7 +161,7 @@ ssize_t nd_namespace_store(struct device *dev,
>  		goto out;
>  	}
>  
> -	found = device_find_child(dev->parent, name, namespace_match);
> +	found = device_find_child_by_name(dev->parent, name);

Looks good to me.
Just one general question.
The function device_find_child checks parent and parent->p, but
device_find_child_by_name only checks parent although they share the
code except the match function. Why that?

Fan
>  	if (!found) {
>  		dev_dbg(dev, "'%s' not found under %s\n", name,
>  				dev_name(dev->parent));
> 
> -- 
> 2.34.1
> 

-- 
Fan Ni (From gmail)
