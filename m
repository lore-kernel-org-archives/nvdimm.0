Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDF4824BF
	for <nvdimm@lists.linux.dev>; Wed, 22 May 2024 11:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716377338; cv=none; b=YcQnKXS17kt39mvxfU3ZNHfL3OxMDoPjq7iguxnY8mm4skfl+4eJ1YxC7v9I236/GJAqo7OnjjK0Xfg29HZVlaRgVPNo6+mQUwLCR9h93wzPitsoTH2E26M34eIJEDAVgRCRzU5UOJ5QN063brPqgBM09hwF+beD6jqeK4+HRdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716377338; c=relaxed/simple;
	bh=3bJdJ8HW1Na5LLk+AGH4z17x+8X++BBtE11tCH2eQoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eMBfw/L1Dm2R0THaXqnLnRH+ydQvNfeucB1zQYqekq4w0QPcnCGXIFqnN9fSHg5wuZnoTTwEUJYh21CubicNoS99iA3wACkXyvOW40qdezVyrzQopLaJP2EnHQTVKmhDovjAVIxUcrRGcfd8GK6tvtntuDKxt6g4tFHDY8Kj5Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=ULNzzmVI; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ULNzzmVI"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a61b70394c0so370251666b.1
        for <nvdimm@lists.linux.dev>; Wed, 22 May 2024 04:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1716377335; x=1716982135; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KNstTbNFBCd+HhKurLCnuPWR0z0UVPvAuThP/LhWOd0=;
        b=ULNzzmVIiuychJWL28nGeUPSK36lKNeKg9kNF68yveL/R7q2WZ5AXfwKoYQ6v4wWMD
         JUih6JWVeNsYhNxNGfdGePpX/M+NvMLwbuagLhYu+SuWYAdcaKajSNDtmLPpmbDkDPSu
         cqVRigrnHoNxekSQ0gGWyTlG6ErT2/LUbZm8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716377335; x=1716982135;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KNstTbNFBCd+HhKurLCnuPWR0z0UVPvAuThP/LhWOd0=;
        b=QUgwiV9XdQis81Te4H7AMw2KU/esXUtpV9fJpu0cMrzKQnAl66RW2hLtnDeohC4z2h
         Z7/Rb5Uxtf2mjKVzqOK/8Abqr+AbuhFBJHZql5i6GFoM497hHRui7n+cP6o+afLlnAga
         E5ld2L2AVS4DvbYAvWd4OirIKhWS/Qy5YIvPhMOqfneAYIbG1ocUYzx5Fh//3YDmxeoy
         XnA7k/gxZOGu5edJzsCyFYAU1fCjCqFweNodkbafzPbu1kRHlYd2i7DhPNl5zQTQ9Z3B
         68UQ7zaCullH+2Zh1iUljTGrkbQ0dE+laKsnxpxt5EHtqFaX6yr2CBOnX62mYmGS5hHt
         C7lg==
X-Forwarded-Encrypted: i=1; AJvYcCVPnI5i0kpnsIz4By4OXxcTdGTF1FCVesRophyU17ZB87dImaZtAr2kSILK8/e8JJ67oCe6437JpJsLqWNCj/i9hYq+Kgld
X-Gm-Message-State: AOJu0YyHJQyAqtZd9jLiSJYhqppC0h4RUzripw/BDyY+QRZM3vdEBdQi
	BRfEkJWEmdht26JpdQBDLB8ueQtJb0fV2wfUVmr2C+cvCXwAkCE+LA9C8OiqO/qPsbc2PyslFqa
	KaKT954lQg7ZhQfWVchw/lb4oEPlGjY9jkgvpVA==
X-Google-Smtp-Source: AGHT+IE5WaF87K/wVsaT0a6gSy0rGBzZLsdh108SeEf5aQ3zolCWJBW1NV7c9ET+Od7JRp7Fevvf53iJJIu4qKo7s5M=
X-Received: by 2002:a17:906:1589:b0:a59:c52b:993c with SMTP id
 a640c23a62f3a-a62281fc3b7mr84214066b.77.1716377334095; Wed, 22 May 2024
 04:28:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1708709155.git.john@groves.net> <CAOQ4uxiPc5ciD_zm3jp5sVQaP4ndb40mApw5hx2DL+8BZNd==A@mail.gmail.com>
 <CAJfpegv8XzFvty_x00UehUQxw9ai8BytvGNXE8SL03zfsTN6ag@mail.gmail.com>
 <CAOQ4uxg9WyQ_Ayh7Za_PJ2u_h-ncVUafm5NZqT_dt4oHBMkFQg@mail.gmail.com>
 <kejfka5wyedm76eofoziluzl7pq3prys2utvespsiqzs3uxgom@66z2vs4pe22v>
 <CAJfpegvQefgKOKMWC8qGTDAY=qRmxPvWkg2QKzNUiag1+q5L+Q@mail.gmail.com> <CAOQ4uxiY-qHSssaX82_LmFdjp5=mqgAhGgbkjAPSXcZ+yRecKw@mail.gmail.com>
In-Reply-To: <CAOQ4uxiY-qHSssaX82_LmFdjp5=mqgAhGgbkjAPSXcZ+yRecKw@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 May 2024 13:28:42 +0200
Message-ID: <CAJfpegvAuPtKzR1A4GdaZTB_EDqPu53wUf97D1QOUo9VKkTV9Q@mail.gmail.com>
Subject: Re: [RFC PATCH 00/20] Introduce the famfs shared-memory file system
To: Amir Goldstein <amir73il@gmail.com>
Cc: John Groves <John@groves.net>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, linux-cxl@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, 
	gregory.price@memverge.com, Vivek Goyal <vgoyal@redhat.com>, 
	Bernd Schubert <bernd.schubert@fastmail.fm>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 May 2024 at 12:16, Amir Goldstein <amir73il@gmail.com> wrote:

> The first open would cache the extent list in fuse_inode and
> second open would verify that the extent list matches.
>
> Last file close could clean the cache extent list or not - that
> is an API decision.

Well, current API clears the mapping, and I would treat the fi->fb as
a just a special case of the extent list.  So by default I'd keep this
behavior, but perhaps it would make sense to optionally allow the
mapping to remain after the last close.  For now this is probably not
relevant...

Thanks,
Miklos
