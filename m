Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AFF3112DE
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 13:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755179953; cv=none; b=RkBNUCSOVy2FJuJtiUn6dXuU3svyGf8YV1n4jjDesj1pd/WZ4d6SsyRleLuHVzxhVsuHfI/8RBHcTVBXaQz+TvWD298pnEx9oaYJ3jAlb790MTsW3PlJLlgAgprU4gehW85ReKimg+f6qUwahRvmfJbP3Ji4D0d9LLo4gOGWQDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755179953; c=relaxed/simple;
	bh=4ExxKGDx0fgiOXw8CTywAcBsJ8ogwJcpwNnL1i5YNn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lEqAgw+4xUjiZeaBr6KontaHut9DCriuGZUwiZL+IvrcXlunBfpLaz9q2EIsuyI1P/62at6bpCap2V0hBQgZ+HgBJq1ctFv0ijHoOoB3G+U6gwaAdiZyWFMaih2q/5Yb4IYwtSBbp0HGcZHxuPD3T8+PvbWdiOAWEqnOY5kGuvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=qnE5gkc+; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="qnE5gkc+"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7e8706ac44eso136905685a.3
        for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 06:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1755179950; x=1755784750; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4ZZu0s3S5A8+/SIi2GUbQjh84N2xIaZ27oBHRZEOGZ0=;
        b=qnE5gkc+2IEy7ruVvtRVzKhnSOFaxZZJu6wYkFnSbFFJPp/uSxu53BMjJ8l+nEse2r
         ieBO3g7coGyhmw2kW6C32csp3/7HNRIYbUey+ebnACBrl/iHmXv/S+GzqKqDR2lDrAvd
         WhBFrUXI+x4AYltqY9UCqIVhTY4r0trf8xlxU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755179950; x=1755784750;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ZZu0s3S5A8+/SIi2GUbQjh84N2xIaZ27oBHRZEOGZ0=;
        b=bR70Yaa3WCe17LB4EaGdL1fwF3vdUEIS+ERKicMjtWeDm/oTLt1F0979mTIdBE1sny
         yAhA6fVwHy2g1XGGIby1y+xDscJKnqxGD/IY/pp+NF+Y5nTmkX3S+3ObwyaPbAKF8pBs
         2D0YiQRPoFfQ2jiujmLkxuoZfxwsCHoueogHAlKhbObQD6SXKXf4NInIUAw/zilfBRWs
         8jT9PtEYSy0YDr64bJnC7gln+LilZfSTM3TUZMLiRViFfgjfY3fNE53O471xD5BAwcRH
         OLmqLUkvRs/euk7FyCk6m1C8uDzn15F4ZERPuf+IAum2VqztvKgSDnV1pwWMLORzzJVn
         irlA==
X-Forwarded-Encrypted: i=1; AJvYcCVfPtdzhKCc491lRJqVt0CFp8h8MOq1md+1VOqTdriEL6l6UhBwDPd0pIi3zCgEYJdZJTuLKUc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRcGO9KZJdc96iUFDYSIimdFF4Az0lVxS3D7+n+wMWZRC/AG6N
	ZAmw8f1xfpqRLvR8WELifd4BansGTWW1j6M+akU0ueH6QJWS0//STpo87X/OFLRCrCGouUFhxZ9
	JNFZkYUM6ymXmST26mnhxeoSPJVvNkg/708zv4Uns2w==
X-Gm-Gg: ASbGncukMI46ZjNqgkr9FTyj/wCNCFqiBkNg12Hhz4REfXYPMYxnnKB7eA9AAzCvf4q
	42VXcd6MLdooRulRkVj+WD8eRe8XFiUlevxFjvvxwghV8Tq9FEBN1AZlQC7sUcv0EqO5UuUSwP8
	W+yY2ywJlLAZuZ9TBPzE74HR72TMm1TE5iIOLXdkFdtTTaeJWbGGakz957gmjW85tTxRp3uWHtC
	CRc
X-Google-Smtp-Source: AGHT+IHDCZisldsHFROueT1mDv+N2w5BriAS/91vOctNmeG6Etw7NNZmRk8u6yHZ87xrdPA7iktx621LgwaHh85teV4=
X-Received: by 2002:a05:620a:e0a:b0:7e6:8545:5505 with SMTP id
 af79cd13be357-7e8705a2a88mr419769985a.55.1755179950579; Thu, 14 Aug 2025
 06:59:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703185032.46568-1-john@groves.net> <20250703185032.46568-15-john@groves.net>
In-Reply-To: <20250703185032.46568-15-john@groves.net>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Aug 2025 15:58:58 +0200
X-Gm-Features: Ac12FXxPrNeYbLt2gO4V6U2nB86--yn65EeQtUloUgMUUdsnzFSb_AaNjXQhYqI
Message-ID: <CAJfpegv19wFrT0QFkwFrKbc6KXmktt0Ba2Lq9fZoihA=eb8muA@mail.gmail.com>
Subject: Re: [RFC V2 14/18] famfs_fuse: GET_DAXDEV message and daxdev_table
To: John Groves <John@groves.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	Jonathan Cameron <Jonathan.Cameron@huawei.com>, Stefan Hajnoczi <shajnocz@redhat.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 3 Jul 2025 at 20:54, John Groves <John@groves.net> wrote:
>
> * The new GET_DAXDEV message/response is enabled
> * The command it triggered by the update_daxdev_table() call, if there
>   are any daxdevs in the subject fmap that are not represented in the
>   daxdev_dable yet.

This is rather convoluted, the server *should know* which dax devices
it has registered, hence it shouldn't need to be explicitly asked.

And there's already an API for registering file descriptors:
FUSE_DEV_IOC_BACKING_OPEN.  Is there a reason that interface couldn't
be used by famfs?

Thanks,
Miklos
