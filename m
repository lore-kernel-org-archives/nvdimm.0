Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B74C4A31
	for <nvdimm@lists.linux.dev>; Sun, 19 May 2024 05:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716098369; cv=none; b=Y234EkHt2jZySVMPUK7y2Td4QyksyJ0Nm2airdbYAv28+bJsfQft339XXF/VAQpeKWvJx5EpZMMv0B1wy2gpKTL92npATALggIa/A7iKjiLLJ0uClYrKKtbX9hetEa7nbFp5f2W+RKWoR2N4Pehz6A5jEeCkeoEY8tm72+a+0do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716098369; c=relaxed/simple;
	bh=NmN54ee38hsuoKztnpSGK2jQepru5rXH4Gp4EPxGG/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LWYYd7m2L2Kx84gvhxHjBTqZbyh25fRE20ERTbfDVtv7w13OK5KT3MNzNMNJ8r+RxhtybWgFKz1djyJf+sH3DFb2C0KvPP7+Rz+v4sIrNn+kDVxst7I5PpiaE+wYJTgcE3nbW+vbeJbRZETtVWWpX9iG9cjr0hMj3LLgGMzOotE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e1drI8MX; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e1drI8MX"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-792d65cd7a8so109864485a.1
        for <nvdimm@lists.linux.dev>; Sat, 18 May 2024 22:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716098367; x=1716703167; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l9NrPccSk3dxue6yKBry7lygPcaCTpzVb/uwrQLilDQ=;
        b=e1drI8MXdZRKC4XKDe5eiyCU6u+weDdc63djXwx563XuBULRLl5R+0QWdRxgxjqnWd
         WZJhFCXr3aQ71MVRe7E9MU042oHQbmWtgHtsHQpjBk2/PmYqBM4d9xUTz27ptXsjBb1q
         if8x6m8ULHrI3269JCuBKI5nr6HvmvETjjaP5vyzxTWnJlHuG+jKNNp8Ln54BcSgXSLp
         LR2aQc0+n2iDD0IZBrQOY4a3URPCYeDhDo6qfCjcyn69I5YDM+InZjPPxMmmFnGDmlyy
         5lbHZ9+uP2OjUtZyO1JK4CpPdUeLHUfAU16UTCWTPLmme06B5orI+Z6YJklfC4TUiNpe
         ieQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716098367; x=1716703167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l9NrPccSk3dxue6yKBry7lygPcaCTpzVb/uwrQLilDQ=;
        b=U2l1mHK+nx3cqXMbOU3UHSWLPReOUIjWy/JfyZSurwReC4slCjVJpNoaWa3QASo9tB
         CL+qlpSqayoliKdaEkxCsopqXAI/VKKtPus1PXdcaKeHdnXBV+s3olXOPnsUgcR4SD45
         SNMfH7uFbRmr3/vLfK5BMZxFsg6nCw5m5wZbl9imWqhzGS/TwVIF0wWf3k/2TnAIbr2I
         BX2oB56/s0qYQtUYsVV9TPMP5HRWG1l+fwichFpdjenrViVcmAQe7HBrxSIEXsAOybKu
         HDRU4I8DRXppSzNF6fsDO8iEHbUQjGEUSq6z0VmwcEMYlB1dtMyxesSMVjuURnhmBTKC
         sLfw==
X-Forwarded-Encrypted: i=1; AJvYcCVmRnV1wsKnwsIhKGOXWRa+wV+Lj4aXgSyUGt1DlN19vFFQJ6W6OScr2qEiEpdM2WcZbY8JxjPiiD84EtY2wgyfxps5aOfT
X-Gm-Message-State: AOJu0Yzc7au0w8+LSPDR4Jbi9wFwR3oKxm9ueaA81v/8MjipCGDnBL/p
	wdzU+x1mgFOYPQRNJCz9JFZyyO02BRp5cBeQ2bUYjNcHraEgSpnmH4Ic4n9YvoZ14YEM3oaZXUx
	GHEdJmYplde6Lj51F1925UlVbPnA=
X-Google-Smtp-Source: AGHT+IH3KgC5/5RTYZFFyAgi3gGOQGkSBTIG6FnrvcN+/pNJE8X5PHNe6d/ZdqiUCwpFLg5jGKiFsKPx3NTMctwKRHM=
X-Received: by 2002:a37:c44c:0:b0:793:343:6db5 with SMTP id
 af79cd13be357-79303437020mr998126385a.11.1716098367007; Sat, 18 May 2024
 22:59:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1708709155.git.john@groves.net> <CAOQ4uxiPc5ciD_zm3jp5sVQaP4ndb40mApw5hx2DL+8BZNd==A@mail.gmail.com>
 <CAJfpegv8XzFvty_x00UehUQxw9ai8BytvGNXE8SL03zfsTN6ag@mail.gmail.com>
In-Reply-To: <CAJfpegv8XzFvty_x00UehUQxw9ai8BytvGNXE8SL03zfsTN6ag@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 19 May 2024 08:59:15 +0300
Message-ID: <CAOQ4uxg9WyQ_Ayh7Za_PJ2u_h-ncVUafm5NZqT_dt4oHBMkFQg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/20] Introduce the famfs shared-memory file system
To: Miklos Szeredi <miklos@szeredi.hu>, John Groves <john@groves.net>
Cc: John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, john@jagalactic.com, 
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, dave.hansen@linux.intel.com, 
	gregory.price@memverge.com, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2024 at 12:55=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu>=
 wrote:
>
> On Thu, 29 Feb 2024 at 07:52, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > I'm not virtiofs expert, but I don't think that you are wrong about thi=
s.
> > IIUC, virtiofsd could map arbitrary memory region to any fuse file mmap=
ed
> > by virtiofs client.
> >
> > So what are the gaps between virtiofs and famfs that justify a new file=
system
> > driver and new userspace API?
>
> Let me try to fill in some gaps.  I've looked at the famfs driver
> (even tried to set it up in a VM, but got stuck with the EFI stuff).
>
> - famfs has an extent list per file that indicates how each page
> within the file should be mapped onto the dax device, IOW it has the
> following mapping:
>
>   [famfs file, offset] -> [offset, length]
>
> - fuse can currently map a fuse file onto a backing file:
>
>   [fuse file] -> [backing file]
>
> The interface for the latter is
>
>    backing_id =3D ioctl(dev_fuse_fd, FUSE_DEV_IOC_BACKING_OPEN, backing_m=
ap);
> ...
>    fuse_open_out.flags |=3D FOPEN_PASSTHROUGH;
>    fuse_open_out.backing_id =3D backing_id;

FYI, library and example code was recently merged to libfuse:
https://github.com/libfuse/libfuse/pull/919

>
> This looks suitable for doing the famfs file - > dax device mapping as
> well.  I wouldn't extend the ioctl with extent information, since
> famfs can just use FUSE_DEV_IOC_BACKING_OPEN once to register the dax
> device.  The flags field could be used to tell the kernel to treat
> this fd as a dax device instead of a a regular file.
>
> Letter, when the file is opened the extent list could be sent in the
> open reply together with the backing id.  The fuse_ext_header
> mechanism seems suitable for this.
>
> And I think that's it as far as API's are concerned.
>
> Note: this is already more generic than the current famfs prototype,
> since multiple dax devices could be used as backing for famfs files,
> with the constraint that a single file can only map data from a single
> dax device.
>
> As for implementing dax passthrough, I think that needs a separate
> source file, the one used by virtiofs (fs/fuse/dax.c) does not appear
> to have many commonalities with this one.  That could be renamed to
> virtiofs_dax.c as it's pretty much virtiofs specific, AFAICT.
>
> Comments?

Would probably also need to decouple CONFIG_FUSE_DAX
from CONFIG_FUSE_VIRTIO_DAX.

What about fc->dax_mode (i.e. dax=3D mount option)?

What about FUSE_IS_DAX()? does it apply to both dax implementations?

Sounds like a decent plan.
John, let us know if you need help understanding the details.

> Am I missing something significant?

Would we need to set IS_DAX() on inode init time or can we set it
later on first file open?

Currently, iomodes enforces that all opens are either
mapped to same backing file or none mapped to backing file:

fuse_inode_uncached_io_start()
{
...
        /* deny conflicting backing files on same fuse inode */

The iomodes rules will need to be amended to verify that:
- IS_DAX() inode open is always mapped to backing dax device
- All files of the same fuse inode are mapped to the same range
  of backing file/dax device.

Thanks,
Amir.
