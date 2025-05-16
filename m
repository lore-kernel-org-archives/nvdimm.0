Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61380233727
	for <nvdimm@lists.linux.dev>; Fri, 16 May 2025 10:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747390019; cv=none; b=l/V327EGDf6iOl0cCmPuEKY3DR7CfVULyliEKoXMhlk+xZI2xDxR4cqX+GaZU8+QKT0IdTOM9//jX10wXYPleXsnhvflJ8l6xZNwdQszaUDBSmiVb7aM9krLfkV/jlZfXNwwdX20xUymQHR7weB5uklCW4u+4qnQuOUTle06l3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747390019; c=relaxed/simple;
	bh=PZ1hzhVLhPa3dLDbMLplQU4Z4StkFXuYbw7/HI9oWu0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jkoxq+HasRX32V/G1m8kPL5xo5sigfhaFeX3qWLHyHQ4lOWAs8C9jpzK2Jtm+ohDfi9N910mNdz0fJ1c30ycXklGvkD8JKisHwtiAdryPKw9UnTJjFMDLS/tQmAo0t2w0L8obruckI3hzeoQ5OxKX4nP3pAvNhMtQOGBvkXS81s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=GXqgLloI; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="GXqgLloI"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-47698757053so26247231cf.0
        for <nvdimm@lists.linux.dev>; Fri, 16 May 2025 03:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1747390016; x=1747994816; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sYr4H36z0vOGSYanC1w0/PBFKEWt1tWAZvghYgV0VXg=;
        b=GXqgLloIxnvxHNUzIfpEKQ0jmhnpxeODWbY7S+ZxtUe01eyZJCUzuLd1nJ7f4/bGAQ
         fAhnvk63m6pjKxtfURr8ysP4oqxp3BDdN3kYLF5qWWU7lHst2cPICy9n+dGb639jhWE+
         OYcTEIQckx8uMpkSsYDFy2Px7RYqYDo+yu4BA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747390016; x=1747994816;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sYr4H36z0vOGSYanC1w0/PBFKEWt1tWAZvghYgV0VXg=;
        b=nrbfTdrpYGgumszI9I8RO470N8M/saFfvAglcOqCrZZRNNbR3uaUk9CVtKhQp9dNi0
         ufzPV7jUaw3kVtrd1G5odDgG1u7omuLpeCyM8RXUUYMpctD+px9TLmBERSGgy1SEbmyW
         ppWD3wEwChnE4WoX9zbRj1ELymqED2/AaQlqdj4gfjsWxUOj9V1CAm/vUSNKBAea6l9u
         d6rg2RxI6gJg4ohPbA1Us13odjjSG/qWtkN+0Ah2LHBALXsfLB9JPrsyrJTlUsE5ma9K
         hsazfXAXdYRLg+LG1T1k7snXK/zYKqjYEQOhZHqGPAvgtif+GqNoeYT7zKuLxm+SyoAx
         exKA==
X-Forwarded-Encrypted: i=1; AJvYcCWVc94y6rKcmXt2VjWDUGRM9MQZhGnwYeLF3M/7O5vXebmdbArw73L1HttVK9vty0593BEgTas=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzo6iuSJrctuwnRu/8NQ0aeGvPn9y3vV6GsLXrwBIIY+dtIO4kn
	/2iiTb7OuMw+wC9cSEA9bV8X7WdZP3FeME10V77IUqijQZ11bZsZ6MupK8OlT3oZL6OPj7RC3Yg
	p8TUgLJvCrfOAFp85HMU7NY6zon443WNZkhy2vLbgGw==
X-Gm-Gg: ASbGnctNeh/DwfW0SrFZ048/qP88gNwyeA62jUsVGU4WriYuLFoP+5HVygI4UCitsgX
	sIV9m2IQsn4WM4ws0q6huWHjD6liJauIydNaClspShjk2O3Hnco8YCdjzaECOUivCAnG3ZhiL7C
	rhCFAuhKmV891tnJ3tj3Tg4tVs3IkMRMI=
X-Google-Smtp-Source: AGHT+IFq1iLsujGv3MRAp/42wUNDp8Fjtx0tUWAIAmM1RivLIsnYNC1bAGTr6piq4vefDLhpVhUdj5QcvATegQP1E2k=
X-Received: by 2002:a05:622a:1f9b:b0:477:13b7:8336 with SMTP id
 d75a77b69052e-494ae391ca0mr49345951cf.17.1747390016120; Fri, 16 May 2025
 03:06:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250421013346.32530-1-john@groves.net> <20250421013346.32530-14-john@groves.net>
 <nedxmpb7fnovsgbp2nu6y3cpvduop775jw6leywmmervdrenbn@kp6xy2sm4gxr>
 <20250424143848.GN25700@frogsfrogsfrogs> <5rwwzsya6f7dkf4de2uje2b3f6fxewrcl4nv5ba6jh6chk36f3@ushxiwxojisf>
 <20250428190010.GB1035866@frogsfrogsfrogs> <CAJfpegtR28rH1VA-442kS_ZCjbHf-WDD+w_FgrAkWDBxvzmN_g@mail.gmail.com>
 <20250508155644.GM1035866@frogsfrogsfrogs> <CAJfpegt4drCVNomOLqcU8JHM+qLrO1JwaQbp69xnGdjLn5O6wA@mail.gmail.com>
 <20250515020624.GP1035866@frogsfrogsfrogs>
In-Reply-To: <20250515020624.GP1035866@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 16 May 2025 12:06:44 +0200
X-Gm-Features: AX0GCFvDzLpmkF12kGaynggeZWP00Cr6BBFBchrM1Bqzro0NRWRGfjqCVUyzE8E
Message-ID: <CAJfpegsKf8Zog3Q6Vd1kBmD6anLSdyYyxy4BjD-dvcyWOyr4QQ@mail.gmail.com>
Subject: Re: [RFC PATCH 13/19] famfs_fuse: Create files with famfs fmaps
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <John@groves.net>, Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Luis Henriques <luis@igalia.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Jeff Layton <jlayton@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Petr Vorel <pvorel@suse.cz>, Brian Foster <bfoster@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 May 2025 at 04:06, Darrick J. Wong <djwong@kernel.org> wrote:

> Yeah, it's confusing.  The design doc tries to clarify this, but this is
> roughly what we need for fuse:
>
> FUSE_IOMAP_OP_WRITE being set means we're writing to the file.
> FUSE_IOMAP_OP_ZERO being set means we're zeroing the file.
> Neither of those being set means we're reading the file.
>
> (3 different operations)

Okay, I get why these need to be distinct cases.

Am I right that the only read is sanely cacheable?

> FUSE_IOMAP_OP_DIRECT being set means directio, and it not being set
> means pagecache.
>
> (and one flag, for 6 different types of IO)

Why does this make a difference?

Okay, maybe I can imagine difference allocation strategies.  Which
means that it only matters for the write case?

> FUSE_IOMAP_OP_REPORT is set all by itself for things like FIEMAP and
> SEEK_DATA/HOLE.

Which should again always be the same as the read case, no?

Thanks,
Miklos
