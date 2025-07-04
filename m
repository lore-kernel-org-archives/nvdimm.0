Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AC12BDC13
	for <nvdimm@lists.linux.dev>; Fri,  4 Jul 2025 08:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751617639; cv=none; b=iPJ9WA+zwIxA38LeGZRBOF3n7mkQsfZ2Te2FPXZArRhz0Wz7cKlw82SUNZ777Ye0HcOFip4mCJBZMls2D/EI336IUCiHd7V8CtyJenpmT5IXplpm1Jqrrjv6OPTGTDo6H4Nr0JwzIFfUNdN/cGdW6qN0eWj+QC9eKvZt+6clUOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751617639; c=relaxed/simple;
	bh=Ax7r7LsDUqgFOF/VvslSmOmKLT1oZFVJhHP1ZiTTjjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u/QOivUIHB+aqBZTIyTb075xYuTg99YGo7VRCyAZpWdi46Kn0mJqfEwIM84Go7GpyXsEIfRixuMaQd++OxRoEdK00m31aHsXki2qGF3/C971svngXWn9rUZpnZsKbh70mVWUFGfxV5ge3lUDmDITXuKzaAlpudcViyP7bayLpXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eo3d2eyA; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eo3d2eyA"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-60867565fb5so1059114a12.3
        for <nvdimm@lists.linux.dev>; Fri, 04 Jul 2025 01:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751617635; x=1752222435; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gmqVjk3StBYQz0vLDf82oFRdTLo20cALrcm7o2Qh9dw=;
        b=eo3d2eyApw6xIj1brAgeuU5En9b8oPv2whQInXUdu/ERJT4IGknPEm0uzatPUYua2t
         rwZeoa7jH3XGNe+H12TCooyZbgcnB6ArXtb2G03qpIG7uy5kKI/06/9tyqT+aJYcQwWk
         t+bYMhrs+WWTGdlO5nfhXXlyanjWJvMLDQBef7dPX6lfVRV+/spHOjabQs+BXi6efUPq
         sl4+50zuWB8QU7VswLDeb5pyeH+JyplXIeavrlvRMZ+i4MKmgROFYOm9fRAdee7UYicL
         epoftfPnP7id/04ArG12cUy0LpukOIoycp1q6rwaMXtZkcB0GnYBkfqfD2iFySGiqx9n
         C17A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751617635; x=1752222435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmqVjk3StBYQz0vLDf82oFRdTLo20cALrcm7o2Qh9dw=;
        b=PRBF+4++BFlcKHEhRyBWj6GNPckyLoSI106cwcl/dearVeHve1sSiyOfRriGBw3BbI
         t2pYZztIaju8QAoEs0eKQlpjfktan5Va9ida9tICzFIMoPSLRZ/x93QZ+RpBQGGAKdKe
         0l8Ti2q6NDLLMBfRqqZpDuv9GylaNAwDA0aqCy55K++9ED3D0XYwit+AY1miJvcjgb3C
         sSUlXJhL818tHVBbPUuOhdYar8eah/U/C9PvepPO595hfsND3fcv1CwdyN1GTIO65sBx
         cjt0fBtzq/ORv5geZgjYjQJaLtyEu6E97LSfs8dGQ7q7PwVxcTWZaiUM5UDduomJZ1ex
         7J4Q==
X-Forwarded-Encrypted: i=1; AJvYcCX0XoLLhbyrYyZUZl/2GjPqUrx2VB/wBl6QELAuWz4i0ff2dkDKg3+Uw0crhQ5NPooWGFzvlb8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrwpAKZPk7m+vHQXYn1+N7k32Xw2U5ZQllkaGdebJp12UHx69G
	pEXE7JpaGriWCiuz3Wmr6pIwJqWZD4b0+g9Rive0rKG4OIzAC/Y0H5s+oT1bdCSXfHyRCBa/8SW
	lzCh2CHfxAm1lQ06VSRcRnsaFk7l4E14=
X-Gm-Gg: ASbGncvWegY31JvON4cmsuLLoJGACHuFD9Kg+63Gyf6VYp9wsfrG8c7b8VqsoYSUsLG
	sTLvSIfidzLLYGAb2WdgRDkUYh8do3GMyl8Ybvd3kUuDRyF7ARHBPLFSFtPxkQBPbcJEFnCFul/
	wmA0s1yYxkGm1dSBFcCP2buHX+Cv0v01kkTM4LvZZgBOs=
X-Google-Smtp-Source: AGHT+IGLkTQtUTcFlGN4yvxvN7TfmyiTnt88AODK3Pj9YzmDgae8AZpRUopQhqnS3eokpzIIJST/uqAmRG6quLm9PRk=
X-Received: by 2002:a17:907:c5cd:b0:ae0:d7c7:97ee with SMTP id
 a640c23a62f3a-ae3fbd8097dmr135529566b.41.1751617634954; Fri, 04 Jul 2025
 01:27:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703185032.46568-1-john@groves.net> <20250703185032.46568-19-john@groves.net>
In-Reply-To: <20250703185032.46568-19-john@groves.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 4 Jul 2025 10:27:03 +0200
X-Gm-Features: Ac12FXzoQQuUSkwO4WI6CczHSELRUoH6Tv15qKAcyDn_VDYQm1YX8QzT980ajJM
Message-ID: <CAOQ4uxj0Q5bnMNyOEA96H9yP=mPoM5LsyzEuKu184cDKaQuJpg@mail.gmail.com>
Subject: Re: [RFC V2 18/18] famfs_fuse: Add documentation
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
	linux-fsdevel@vger.kernel.org, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>, Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 3, 2025 at 8:51=E2=80=AFPM John Groves <John@groves.net> wrote:
>
> Add Documentation/filesystems/famfs.rst and update MAINTAINERS
>
> Signed-off-by: John Groves <john@groves.net>
> ---
>  Documentation/filesystems/famfs.rst | 142 ++++++++++++++++++++++++++++
>  Documentation/filesystems/index.rst |   1 +
>  MAINTAINERS                         |   1 +
>  3 files changed, 144 insertions(+)
>  create mode 100644 Documentation/filesystems/famfs.rst


Considering "Documentation: fuse: Consolidate FUSE docs into its own
subdirectory"
https://lore.kernel.org/linux-fsdevel/20250612032239.17561-1-bagasdotme@gma=
il.com/

I wonder if famfs and virtiofs should be moved into fuse subdir?
To me it makes more sense, but it's not a clear cut.

>
> diff --git a/Documentation/filesystems/famfs.rst b/Documentation/filesyst=
ems/famfs.rst
> new file mode 100644
> index 000000000000..0d3c9ba9b7a8
> --- /dev/null
> +++ b/Documentation/filesystems/famfs.rst
> @@ -0,0 +1,142 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +.. _famfs_index:
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +famfs: The fabric-attached memory file system
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +- Copyright (C) 2024-2025 Micron Technology, Inc.
> +
> +Introduction
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Compute Express Link (CXL) provides a mechanism for disaggregated or
> +fabric-attached memory (FAM). This creates opportunities for data sharin=
g;
> +clustered apps that would otherwise have to shard or replicate data can
> +share one copy in disaggregated memory.
> +
> +Famfs, which is not CXL-specific in any way, provides a mechanism for
> +multiple hosts to concurrently access data in shared memory, by giving i=
t
> +a file system interface. With famfs, any app that understands files can
> +access data sets in shared memory. Although famfs supports read and writ=
e,
> +the real point is to support mmap, which provides direct (dax) access to
> +the memory - either writable or read-only.
> +
> +Shared memory can pose complex coherency and synchronization issues, but
> +there are also simple cases. Two simple and eminently useful patterns th=
at
> +occur frequently in data analytics and AI are:
> +
> +* Serial Sharing - Only one host or process at a time has access to a fi=
le
> +* Read-only Sharing - Multiple hosts or processes share read-only access
> +  to a file
> +
> +The famfs fuse file system is part of the famfs framework; user space
> +components [1] handle metadata allocation and distribution, and provide =
a
> +low-level fuse server to expose files that map directly to [presumably
> +shared] memory.
> +
> +The famfs framework manages coherency of its own metadata and structures=
,
> +but does not attempt to manage coherency for applications.
> +
> +Famfs also provides data isolation between files. That is, even though
> +the host has access to an entire memory "device" (as a devdax device), a=
pps
> +cannot write to memory for which the file is read-only, and mapping one
> +file provides isolation from the memory of all other files. This is pret=
ty
> +basic, but some experimental shared memory usage patterns provide no suc=
h
> +isolation.
> +
> +Principles of Operation
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Famfs is a file system with one or more devdax devices as a first-class
> +backing device(s). Metadata maintenance and query operations happen
> +entirely in user space.
> +
> +The famfs low-level fuse server daemon provides file maps (fmaps) and
> +devdax device info to the fuse/famfs kernel component so that
> +read/write/mapping faults can be handled without up-calls for all active
> +files.
> +
> +The famfs user space is responsible for maintaining and distributing
> +consistent metadata. This is currently handled via an append-only
> +metadata log within the memory, but this is orthogonal to the fuse/famfs
> +kernel code.
> +
> +Once instantiated, "the same file" on each host points to the same share=
d
> +memory, but in-memory metadata (inodes, etc.) is ephemeral on each host
> +that has a famfs instance mounted. Use cases are free to allow or not
> +allow mutations to data on a file-by-file basis.
> +
> +When an app accesses a data object in a famfs file, there is no page cac=
he
> +involvement. The CPU cache is loaded directly from the shared memory. In
> +some use cases, this is an enormous reduction read amplification compare=
d
> +to loading an entire page into the page cache.
> +
> +
> +Famfs is Not a Conventional File System
> +---------------------------------------
> +
> +Famfs files can be accessed by conventional means, but there are
> +limitations. The kernel component of fuse/famfs is not involved in the
> +allocation of backing memory for files at all; the famfs user space
> +creates files and responds as a low-level fuse server with fmaps and
> +devdax device info upon request.
> +
> +Famfs differs in some important ways from conventional file systems:
> +
> +* Files must be pre-allocated by the famfs framework; allocation is neve=
r
> +  performed on (or after) write.
> +* Any operation that changes a file's size is considered to put the file
> +  in an invalid state, disabling access to the data. It may be possible =
to
> +  revisit this in the future. (Typically the famfs user space can restor=
e
> +  files to a valid state by replaying the famfs metadata log.)
> +
> +Famfs exists to apply the existing file system abstractions to shared
> +memory so applications and workflows can more easily adapt to an
> +environment with disaggregated shared memory.
> +
> +Memory Error Handling
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Possible memory errors include timeouts, poison and unexpected
> +reconfiguration of an underlying dax device. In all of these cases, famf=
s
> +receives a call from the devdax layer via its iomap_ops->notify_failure(=
)
> +function. If any memory errors have been detected, access to the affecte=
d
> +daxdev is disabled to avoid further errors or corruption.
> +
> +In all known cases, famfs can be unmounted cleanly. In most cases errors
> +can be cleared by re-initializing the memory - at which point a new famf=
s
> +file system can be created.
> +
> +Key Requirements
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +The primary requirements for famfs are:
> +
> +1. Must support a file system abstraction backed by sharable devdax memo=
ry
> +2. Files must efficiently handle VMA faults
> +3. Must support metadata distribution in a sharable way
> +4. Must handle clients with a stale copy of metadata
> +
> +The famfs kernel component takes care of 1-2 above by caching each file'=
s
> +mapping metadata in the kernel.
> +
> +Requirements 3 and 4 are handled by the user space components, and are
> +largely orthogonal to the functionality of the famfs kernel module.
> +
> +Requirements 3 and 4 cannot be met by conventional fs-dax file systems
> +(e.g. xfs) because they use write-back metadata; it is not valid to moun=
t
> +such a file system on two hosts from the same in-memory image.
> +
> +
> +Famfs Usage
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Famfs usage is documented at [1].
> +
> +
> +References
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +- [1] Famfs user space repository and documentation
> +      https://github.com/cxl-micron-reskit/famfs
> diff --git a/Documentation/filesystems/index.rst b/Documentation/filesyst=
ems/index.rst
> index 2636f2a41bd3..5aad315206ee 100644
> --- a/Documentation/filesystems/index.rst
> +++ b/Documentation/filesystems/index.rst
> @@ -90,6 +90,7 @@ Documentation for filesystem implementations.
>     ext3
>     ext4/index
>     f2fs
> +   famfs
>     gfs2
>     gfs2-uevents
>     gfs2-glocks
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 02688f27a4d0..faa7de4a43de 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8814,6 +8814,7 @@ M:        John Groves <John@Groves.net>
>  L:     linux-cxl@vger.kernel.org
>  L:     linux-fsdevel@vger.kernel.org
>  S:     Supported
> +F:     Documentation/filesystems/famfs.rst
>  F:     fs/fuse/famfs.c
>  F:     fs/fuse/famfs_kfmap.h
>
> --
> 2.49.0
>
