Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8494D305E39
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 13:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755178603; cv=none; b=tLwYAZMCl6pFuCLcgqhET55VrOe7tqOVcDo0AAZGFhEzgaF1La6kN24x3SBfy8p7SmV1jhIVmY/SR3T7nrRZQEIZpjq/C7n8J+wUOCADVXnJypQ6R7PbhEne+uuoaftKtLHPQ6SdwB1WUdDE5noTpCtHfsGcV/NTyLwqOQEtzXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755178603; c=relaxed/simple;
	bh=5pu5CCcwVsrYR5S/WgA6wkxRR40hQbEFvk1WFQLNauI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q4eZdRQDIx6jvDHZq5DWkmfDS2/AAAzQikvu/wfBALnUHuH8cM3n/D0oJ5rlVQgp261pgtPBn/3z2M5cJ8d1qOAS7PPyBdLodk4+TL2zQ3cTu+apgI4fqX/rxetSqtvrMl3uP7mwXjKyjrcM97M10fDT1RVkNx6aRuhOnrgM7RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Ogv+rnT+; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Ogv+rnT+"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b109acc6c7so8544671cf.1
        for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 06:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1755178600; x=1755783400; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xiJ+voUm58mOt9ANl6l8BPcmKr+2Gr+D+s+NWbUh7rs=;
        b=Ogv+rnT+uEBLx9aYExwKES+jbFX1+bGfbwpL3CIHBNZ7Wg482f+UiQVvxGrtcDJNRm
         Ooa8dPvtdq3IHzItm2HlXFPPVIyllbTtuWoKzSe+LHmYmTF2IsmC/vG+rS76yDEx5oMt
         0zAfLEVLNgXUP4z+95J28+ebEHxVKQUtBk7xw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755178600; x=1755783400;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xiJ+voUm58mOt9ANl6l8BPcmKr+2Gr+D+s+NWbUh7rs=;
        b=jzM34qQ2BC6Q6kIkmTtk+SnILerZgv+SMakPOz3vQR3TjnExP1cW13ZkhoOJ3we++c
         HLdyg2OMfKA+WzEnJ7AYWJpNC58WzzL7wLx1gQ3Mgt+G40WBTu4hMzJE5n5YyeC8PUIf
         EPcl9uSyTZvH/4CtdeEVpckBN13he2oepd647NakCLm3FtO5AA4bhlRGyh0Wz5OHu+5K
         9ZBV+f0iStpl/vgzL0vdicFbaLr+FzMtad6ZlUeRa3tR7suI3AGDJ647Zh9MdpEzcG7z
         TclgMxVw3bgLuxCzxEHXWGbIoOx5lFH1uFBYemEZdADeOJDztTaGIoZpV/tO6piagHvn
         +BvA==
X-Forwarded-Encrypted: i=1; AJvYcCVQFTJZLD2VTc3yL558zazt0oKckYyiZ94IuRButFUdcPBv3QZm7DBVHkiQjn78xCtfW85kKcc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxaXOtUM6WA58D5HnatBI2I8a+qnEYeVmINiir0GMEx9oCzr6G1
	5kOnz4oevojmdesL8bUt8X92kqi8byg/1XX7UcRcG1ebJe0meofDSvf2a43kUCxJLpngNZnCd5u
	/wFJT3PJMTCuKwuzKz7Uj7QGAbqCsYuYm/7OdYPExXA==
X-Gm-Gg: ASbGnctRtgqANzlNyxKsHW6TXpAE+nuzQWV7Fj5d0UffMmQh+QipdNoXRDFcS0ACT4u
	i1zXfGlGsrsxavd1VbtzbgHNf01gV/y5m65nVvhnoRA6Wp9Y2rrt/4/M2dRVrRC4Oq0XLSaMEMP
	URE0oLZdnOi0CQvA66zpLZjGAVwvmHlfGIflbvT6RlnUI3SQoX6JLrFoMJ1l+Akv923b9JuVF/T
	CC5
X-Google-Smtp-Source: AGHT+IGRLUNSdSZic/AfvkGEhcJ0i0UexRhcMwBfu+hTgWYJPH7NmUnalP/saR/GroY1O9C7uFRCx1HrQwBXZpKp4dE=
X-Received: by 2002:ac8:590b:0:b0:4b0:7e22:36bd with SMTP id
 d75a77b69052e-4b10a97a743mr43862441cf.23.1755178598536; Thu, 14 Aug 2025
 06:36:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703185032.46568-1-john@groves.net> <20250703185032.46568-13-john@groves.net>
In-Reply-To: <20250703185032.46568-13-john@groves.net>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Aug 2025 15:36:26 +0200
X-Gm-Features: Ac12FXz5KYhharzGRoAiyFuPvtQSxT3MxOHi7MhrKR_P4gCMelGIrgjr1IHTKO4
Message-ID: <CAJfpegv6wHOniQE6dgGymq4h1430oc2EyV3OQ2S9DqA20nZZUQ@mail.gmail.com>
Subject: Re: [RFC V2 12/18] famfs_fuse: Plumb the GET_FMAP message/response
To: John Groves <John@groves.net>
Cc: Dan Williams <dan.j.williams@intel.com>, Miklos Szeredi <miklos@szeredb.hu>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
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
> Upon completion of an OPEN, if we're in famfs-mode we do a GET_FMAP to
> retrieve and cache up the file-to-dax map in the kernel. If this
> succeeds, read/write/mmap are resolved direct-to-dax with no upcalls.

Nothing to do at this time unless you want a side project:  doing this
with compound requests would save a roundtrip (OPEN + GET_FMAP in one
go).

> GET_FMAP has a variable-size response payload, and the allocated size
> is sent in the in_args[0].size field. If the fmap would overflow the
> message, the fuse server sends a reply of size 'sizeof(uint32_t)' which
> specifies the size of the fmap message. Then the kernel can realloc a
> large enough buffer and try again.

There is a better way to do this: the allocation can happen when we
get the response.  Just need to add infrastructure to dev.c.

> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 6c384640c79b..dff5aa62543e 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -654,6 +654,10 @@ enum fuse_opcode {
>         FUSE_TMPFILE            = 51,
>         FUSE_STATX              = 52,
>
> +       /* Famfs / devdax opcodes */
> +       FUSE_GET_FMAP           = 53,
> +       FUSE_GET_DAXDEV         = 54,

Introduced too early.

> +
>         /* CUSE specific operations */
>         CUSE_INIT               = 4096,
>
> @@ -888,6 +892,16 @@ struct fuse_access_in {
>         uint32_t        padding;
>  };
>
> +struct fuse_get_fmap_in {
> +       uint32_t        size;
> +       uint32_t        padding;
> +};

As noted, passing size to server really makes no sense.  I'd just omit
fuse_get_fmap_in completely.

> +
> +struct fuse_get_fmap_out {
> +       uint32_t        size;
> +       uint32_t        padding;
> +};
> +
>  struct fuse_init_in {
>         uint32_t        major;
>         uint32_t        minor;
> @@ -1284,4 +1298,8 @@ struct fuse_uring_cmd_req {
>         uint8_t padding[6];
>  };
>
> +/* Famfs fmap message components */
> +
> +#define FAMFS_FMAP_MAX 32768 /* Largest supported fmap message */
> +

Hmm, Darrick's interface gets one extents at a time.   This one tries
to get the whole map in one go.

The single extent thing can be inefficient even for plain block fs, so
it would be nice to get multiple extents.  The whole map has an
artificial limit that currently may seem sufficient but down the line
could cause pain.

I'm still hoping some common ground would benefit both interfaces.
Just not sure what it should be.

Thanks,
Miklos
