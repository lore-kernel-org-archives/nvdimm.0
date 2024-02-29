Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA1E39FD1
	for <nvdimm@lists.linux.dev>; Thu, 29 Feb 2024 06:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709189566; cv=none; b=eSwIEPqOrKBIYv1rqD9laSPzuKLwoguaXjpw0QR/192iQLJnDRyYmzbKx0JSrUwHq90MSIsSr8QHI7zrEmXTpte3htflhWURuKaXQuBVlZHI47EV+u46aRuE7kwAVHijp7rQomx40TTI+7XKgFqkOZEJAvMuTLAvwenFfrYVb7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709189566; c=relaxed/simple;
	bh=QEJAoHeT2wh90dI+ZjoF1ZHx+LcAYE5U/em2XDUBioM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=atALxQJHlNUCOMFuP3B8F7t8lQcteFeA4/+hI/nZzZ837GXor4FByfQ2NKljMTvF5CgtM/BdvbLMfMocOUgkU+PHeL6VjCd6HHmVPEu6cWuAIH8f5E3M4Un9WNxQvFdzjpYr6NxTsCWi2UHnfbdoBiN4kCYI4xj5puvv56ROQ7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DVAuQxWa; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DVAuQxWa"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-42ea808d0f7so3407371cf.3
        for <nvdimm@lists.linux.dev>; Wed, 28 Feb 2024 22:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709189564; x=1709794364; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iPX1yFcE2Qv3sy/mqTmODI/j9a9JW9C8YeAhgYmhLGs=;
        b=DVAuQxWapHRtG9sGkMVsDmccTiFLjodwgAnLRdo4oD+39Wgf0fmtKWocx6ZljHkFnd
         Wh7aKaFjGPOVzqW/L6s6beA09dbFRDsgcGy1SlTjsbcj82NJ2hAYUtO1oyJjVzi7MFy9
         K094jL54aCsh+IIY5KTJr2Bxq+60gZ4fs+0uJgxDk5+gfF63sj3bhKyR0NoOEO7kLoHH
         rPDvYK2F71GDAkdseOuDjLI8h4h8iYTX27eoBcyAFiRamJQETkHnyBaZ6vmH1cZzd6vX
         3GtJjEW/Fj8yaO3BwfW+XjGzbuaOaibT9u1FgtN0tyNRl+UmNTK5kuJw+OM98CAt1RGL
         Arqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709189564; x=1709794364;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iPX1yFcE2Qv3sy/mqTmODI/j9a9JW9C8YeAhgYmhLGs=;
        b=fu4rIeaQmaV6mJ1KVEHRqcAc+uUbSKoWmOMUjgIK35gV0Phpke0CdFQLfSoKdS6i1t
         r0DyjxqW3/f/o9hULjD0Griol6Vc6RN7EJhMPKer/zo1Bruyy0uNjIVTnP3mdAqegS7B
         6OrqhicqKT2YBao7Qn02BigrqI2IGDn7ZN6hkoA5KBVjzTmRRj4S7JTHhxP4pBu2UvGw
         qEcwVM8uEmw4/WLk4TjBdFbS/sXONDGjXbfNljJFzS+zRCC9zK1014eN1yO2GXrsvyk9
         XXUHEZrxeEBR3KB6lzzZzcgCQP10kWlaeK4BM9oKIy3ONqWP4xhdxDLGShbnIMMGCQO6
         ORcA==
X-Forwarded-Encrypted: i=1; AJvYcCVD+6rVYQKhYIAPGWcoNlYvz/OhqEq4j0sM9sU9UuhbhPW/gPJhRtBZGwi5ZWk3FygBpKJGPR0YVcplyRat5ssHh5iTg+22
X-Gm-Message-State: AOJu0YyaeNkbjgbMmMxoCCMVE0FvLQOy+7SUi9OnXZh5gMlq3ODIbHpZ
	TMH/MQ1/s0bSzGIbbbZMVYuQZ7xm5ZnaKRqSHI8wkjkrIUHzeM0RPQkVx+I1c2Gzalnl0SnBMTK
	tP57c/o9FiNXi+eZKnM55Fezgwy4=
X-Google-Smtp-Source: AGHT+IFn20kiezhjvNWVPNWkvhcd3j6u19avlEPGAe1WEmIZ6yWLp27W9XetikSPB9EKVwpdSFz5h3OKt1KsGriybmc=
X-Received: by 2002:ac8:7f82:0:b0:42e:8c8f:42f6 with SMTP id
 z2-20020ac87f82000000b0042e8c8f42f6mr1421021qtj.40.1709189563696; Wed, 28 Feb
 2024 22:52:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1708709155.git.john@groves.net>
In-Reply-To: <cover.1708709155.git.john@groves.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Feb 2024 08:52:32 +0200
Message-ID: <CAOQ4uxiPc5ciD_zm3jp5sVQaP4ndb40mApw5hx2DL+8BZNd==A@mail.gmail.com>
Subject: Re: [RFC PATCH 00/20] Introduce the famfs shared-memory file system
To: John Groves <John@groves.net>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, 
	gregory.price@memverge.com, Miklos Szeredi <miklos@szeredi.hu>, 
	Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 7:42=E2=80=AFPM John Groves <John@groves.net> wrote=
:
>
> This patch set introduces famfs[1] - a special-purpose fs-dax file system
> for sharable disaggregated or fabric-attached memory (FAM). Famfs is not
> CXL-specific in anyway way.
>
> * Famfs creates a simple access method for storing and sharing data in
>   sharable memory. The memory is exposed and accessed as memory-mappable
>   dax files.
> * Famfs supports multiple hosts mounting the same file system from the
>   same memory (something existing fs-dax file systems don't do).
> * A famfs file system can be created on either a /dev/pmem device in fs-d=
ax
>   mode, or a /dev/dax device in devdax mode (the latter depending on
>   patches 2-6 of this series).
>
> The famfs kernel file system is part the famfs framework; additional
> components in user space[2] handle metadata and direct the famfs kernel
> module to instantiate files that map to specific memory. The famfs user
> space has documentation and a reasonably thorough test suite.
>

So can we say that Famfs is Fuse specialized for DAX?

I am asking because you seem to have asked it first:
https://lore.kernel.org/linux-fsdevel/0100018b2439ebf3-a442db6f-f685-4bc4-b=
4b0-28dc333f6712-000000@email.amazonses.com/
I guess that you did not get your answers to your questions before or at LP=
C?

I did not see your question back in October.
Let me try to answer your questions and we can discuss later if a new dedic=
ated
kernel driver + userspace API is really needed, or if FUSE could be used as=
 is
extended for your needs.

You wrote:
"...My naive reading of the existence of some sort of fuse/dax support
for virtiofs
suggested that there might be a way of doing this - but I may be wrong
about that."

I'm not virtiofs expert, but I don't think that you are wrong about this.
IIUC, virtiofsd could map arbitrary memory region to any fuse file mmaped
by virtiofs client.

So what are the gaps between virtiofs and famfs that justify a new filesyst=
em
driver and new userspace API?

Thanks,
Amir.
