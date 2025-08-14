Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2976219303
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 18:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755195937; cv=none; b=V6qZ3uqGjhKqSvsATZpID3qeENz9y5kRad/CbHtrRXMGs74V5z79aYP/TeCfjl6PLIroJIPpnxq3SlnJgh/n2DbD9+Z45CqABvBxwPs17fH/LJEzEb4gOcqkRLmDrx2DvElQwcOdWX+4YT5LOe6+mh8RqJIHbLG0Ue9+y5AuHvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755195937; c=relaxed/simple;
	bh=QlxV/Fo/vL6WCJNsSwAfnDwsEr9HvLtREXvO8jaWoVo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CLDsRkObHHDVcwTQuLD8fu74lhl2NgcajIVdEu5grVaaJxL4mPRgAnwoIfRuh1XfWm1Ad2OQ9ydf3aMossUCwHRYffDm7uapeqGmzY1W3rsw7BaR+zz7g5njLzNGER1ozmQ5+15BGRqJ6POXafDz9wl7DWkiD+eIHrYH10QVdVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=PMRTW0vK; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="PMRTW0vK"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b109bcceb9so12982441cf.2
        for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 11:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1755195935; x=1755800735; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZaG/9Mc3gO9Z05dXGGeK8opCDGdDbOMVGSG4B2PlDgg=;
        b=PMRTW0vKlbcaYmF3TYwtuVrQi+D4WZeo3JZ9zFTWya1RC1ulJlGFSMYiWr+4p1fdH/
         5KM+ijy8VXS7por5w0ratvhTXjPqKRLvmCQ71H5tgzLCYO8LXwAvPLJ7kpSMd4ulZuzE
         udyCjR2D0QC7EHL/4PI74tqkaGJMbt7NP9K6A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755195935; x=1755800735;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZaG/9Mc3gO9Z05dXGGeK8opCDGdDbOMVGSG4B2PlDgg=;
        b=uD9f/1crnHZ5cmXwnCryhNtRnOvmlrb7EW4J5i2w0Uy7HDq5vCD8j0bqtvShnzVWm1
         SIxzjnp9uNgyav3ZvNGlqs4J6KRHWPSTh8boAoN4XAyuxXzlXL21zzVhIobOrYLYHAZ1
         TT3B7EP8FrOhimydmC/au+bVT8PpXAfRuAY8S5ysgYMrqIFD6/N6GuqUU3MEIchT7GnT
         5vBy45naxNLVT3kAPSntkrgP8awOjJyp2u70lCzgjOUzbox61vWqQSssf+XA6QtiE2GQ
         tOtuEsE5MoWcIvHTB3NkAr9Rz4JZjCsqJtuwNQUm3lGcDPd6C/F+4lEpsOc41SJfei9/
         I0Pw==
X-Forwarded-Encrypted: i=1; AJvYcCXqJL+Twyo1uTuLKdYmc2RZN3V1ne4l1hdXDveON9lXSCGcBio3a6ONjB5Xzzr6/ps2nsj/6DM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcGbkddD//gOxr8P419jOIOq3pdkFhr8vVFnfhQYCg/oFqH7Cr
	SBOJsIwi7V7tOm75pqO50yYwgWgakGt2uP5ixf3MeP+AJhfmBgkaI667tkw2ROoqBRjWPkgzSIZ
	+Tjl2wn6Ie2BsN1/0InOgza47PNLTW0BiMYyGMHPF+A==
X-Gm-Gg: ASbGncvs7htdj5WDrBuHpSyd9YDeyjis6uWx2n8M/fySv8EwlB8k8tCQOgUnAahiTzF
	MW0lljNGqhIQv2DRWqk5M0x+44QyqUhlgTJ8eqX+0Kwnb4pIZR5aIytukycv13n7sLK/YprMkLz
	AzIY0A66ISZxzo0uyWsON7wFj6nMTKxrr1yzWvYLNCHiIclFhKdbUzlBexscAM18SaXYLy43Qjg
	dXO
X-Google-Smtp-Source: AGHT+IGSn0lQHqZ9RP9BbaqY15avh0lMZ+NAOhYoifmbXNq37t8nR6rR8emWPkr9ymaCKi05XQKiq/L5hGeuPEvoQWk=
X-Received: by 2002:a05:622a:2c3:b0:4af:21f6:2523 with SMTP id
 d75a77b69052e-4b119812238mr5676291cf.6.1755195934739; Thu, 14 Aug 2025
 11:25:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703185032.46568-1-john@groves.net> <20250703185032.46568-15-john@groves.net>
 <CAJfpegv19wFrT0QFkwFrKbc6KXmktt0Ba2Lq9fZoihA=eb8muA@mail.gmail.com> <20250814171941.GU7942@frogsfrogsfrogs>
In-Reply-To: <20250814171941.GU7942@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Aug 2025 20:25:23 +0200
X-Gm-Features: Ac12FXxTdDrnRb7Tf9wOWEPTOrq-mapbwGaLhT9s1IZLVbyqxOHLM2quCQmv3sc
Message-ID: <CAJfpegv8Ta+w4CTb7gvYUTx3kka1-pxcWX_ik=17wteU9XBT1g@mail.gmail.com>
Subject: Re: [RFC V2 14/18] famfs_fuse: GET_DAXDEV message and daxdev_table
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <John@groves.net>, Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 14 Aug 2025 at 19:19, Darrick J. Wong <djwong@kernel.org> wrote:
> What happens if you want to have a fuse server that hosts both famfs
> files /and/ backing files?  That'd be pretty crazy to mix both paths in
> one filesystem, but it's in theory possible, particularly if the famfs
> server wanted to export a pseudofile where everyone could find that
> shadow file?

Either FUSE_DEV_IOC_BACKING_OPEN detects what kind of object it has
been handed, or we add a flag that explicitly says this is a dax dev
or a block dev or a regular file.  I'd prefer the latter.

Thanks,
Miklos
