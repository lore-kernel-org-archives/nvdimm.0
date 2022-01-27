Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6982CA2
	for <nvdimm@lists.linux.dev>; Thu, 27 Jan 2022 01:45:05 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id j10so914496pgc.6
        for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 17:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tYGK3wY4fdBRiVN5u48Y7M8NvjV74Kds/0Hqs31NUKk=;
        b=T8MjxwC21g/W/VMj9bBTRnkhzmDWvX9Vo0/FxC1/XNa2tQTuVa0/UChFLc4QeEjNa0
         +rTtsF2HgzcYoStq2Ycxt1V4hTOGzJ8xlo0PeELiVJGx5JcdBxExxFSre25bgOCp6FBg
         dE/tvM4PfMdTFzWzAShPRWeD51ptqFUuQYcusqdr8ZfuipNraEoftYDnnNI0PpFCJ2Kp
         BjD6KiBzlDtovrzlaKqR+oI1Y5oWq+ejdKuCQ16OEeOYzDYEIbt9lwIMHa9n81Qn83s4
         Exi0aSYlsTDd9TgfsjnW5ft9vCnQGcLW+znFICAGbZCyk0behEcxZFG4qnwoAmzeIciA
         nbbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tYGK3wY4fdBRiVN5u48Y7M8NvjV74Kds/0Hqs31NUKk=;
        b=GLvpOTixpoLAxFb24VpVJvmxFt3cPnSUx+RzCAYCCB/aiZS4koygUJfXwWCxEc2yUn
         KjcOpizGK6bja/xNLjToZKxhkl1TLcI7GieiSNB9Q+/l1Zd1Eus6PjajlRDs+HKFNKS8
         +Fb6tLkzmuB2qGKF5Yvirc2p5SJIupcUQe4yvT2QHbzy6Kj7KYzO9bz/qrX7bLNtOpE1
         N+g7DL8svgelVfMPF5rlbzL3VuTBFSZh2a+YLYjLFHTdpi3dnYk5/+EelSGLFkKhW01f
         Sm6LyFg7ywJgGG1NsE+HXIhaxL0xKWs87XbfSzgJ34CcgBOVwENwSXs/geuDWd/Rr742
         zFqg==
X-Gm-Message-State: AOAM532NhL2tmSS0p7/PWwzb5ktmCazrRvwjFTFcOL/vBG4jSxHZ9A/U
	HSQ/GYspkM8Nn6nqw/IS2J7VfCkqQ7+HGs1k/EwXdQ==
X-Google-Smtp-Source: ABdhPJxjy5VA2QU5lfhoTOMwxvSDWV/AzlYSz9OA8wBGSB0C6aZ8GQECMrLT8IMY6QEWAtZHUAfbB3VW6Hei0TVDfgg=
X-Received: by 2002:a63:4717:: with SMTP id u23mr1223011pga.74.1643247905301;
 Wed, 26 Jan 2022 17:45:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1642535478.git.alison.schofield@intel.com> <d8760a4a0ca5b28be4eee27a2581ca8c2abe3e49.1642535478.git.alison.schofield@intel.com>
In-Reply-To: <d8760a4a0ca5b28be4eee27a2581ca8c2abe3e49.1642535478.git.alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 26 Jan 2022 17:44:54 -0800
Message-ID: <CAPcyv4gx+mvAPEmYstUXAsjWY=Aq7zb4y4V+QGzwnauk1F8DEw@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 6/6] cxl: add command set-partition-info
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 18, 2022 at 12:20 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> Users may want to change the partition layout of a memory
> device using the CXL command line tool.

How about:

CXL devices may support both volatile and persistent memory capacity.
The amount of device capacity set aside for each type is typically
established at the factory, but some devices also allow for dynamic
re-partitioning, add a command for this purpose.

> Add a new CXL command,
> 'cxl set-partition-info', that operates on a CXL memdev, or a
> set of memdevs, and allows the user to change the partition
> layout of the device(s).
>
> Synopsis:
> Usage: cxl set-partition-info <mem0> [<mem1>..<memN>] [<options>]

It's unfortunate that the specification kept the word "info" in the
set-partition command name, let's leave it out of this name and just
call this 'cxl set-partition'.

>
>         -v, --verbose           turn on debug
>         -s, --volatile_size <n>
>                                 next volatile partition size in bytes

Some users will come to this tool with the thought, "I want volatile
capacity X", others "I want pmem capacity Y". All but the most
advanced users will not understand how the volatile setting affects
the pmem and vice versa, nor will they understand that capacity might
be fixed and other capacity is dynamic. So how about a set of options
like:

-t, --type=3D<volatile,pmem>
-s,--size=3D<size>

...where by default -t is 'pmem' and -s is '0' for 100% of the dynamic
capacity set to PMEM.

The tool can then help the user get what they want relative to
whatever frame of reference led them to read the set-partition man
page. The tool can figure out the details behind the scenes, or warn
them if they want something impossible like setting PMEM capacity to
1GB on a device where 2GB of PMEM is statically allocated.

This also helps with future proofing in case there are other types
that come along.

>
> The included MAN page explains how to find the partitioning
> capabilities and restrictions of a CXL memory device.
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  Documentation/cxl/cxl-set-partition-info.txt |  53 ++++++++++
>  Documentation/cxl/meson.build                |   1 +
>  cxl/builtin.h                                |   1 +
>  cxl/cxl.c                                    |   1 +
>  cxl/memdev.c                                 | 101 +++++++++++++++++++
>  5 files changed, 157 insertions(+)
>  create mode 100644 Documentation/cxl/cxl-set-partition-info.txt
>
> diff --git a/Documentation/cxl/cxl-set-partition-info.txt b/Documentation=
/cxl/cxl-set-partition-info.txt
> new file mode 100644
> index 0000000..d99a1b9
> --- /dev/null
> +++ b/Documentation/cxl/cxl-set-partition-info.txt
> @@ -0,0 +1,53 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-set-partition-info(1)
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> +
> +NAME
> +----
> +cxl-set-partition-info - set the partitioning between volatile and persi=
stent capacity on a CXL memdev
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl set-partition-info <mem> [ [<mem1>..<memN>] [<options>]'
> +
> +DESCRIPTION
> +-----------
> +Partition the device into volatile and persistent capacity. The change
> +in partitioning will become the =E2=80=9Cnext=E2=80=9D configuration, to=
 become active
> +on the next device reset.
> +
> +Use "cxl list -m <memdev> -I" to examine the partitioning capabilities
> +of a device. A partition_alignment_bytes value of zero means there are
> +no partitionable bytes available and therefore the partitions cannot be
> +changed.
> +
> +Using this command to change the size of the persistent capacity shall
> +result in the loss of data stored.
> +
> +OPTIONS
> +-------
> +<memory device(s)>::
> +include::memdev-option.txt[]
> +
> +-s::
> +--size=3D::

This is "--volatile_size" in the current patch, but that's moot with
feedback to move to a --type + --size scheme.

> +        Size in bytes of the volatile partition requested.
> +
> +        Size must align to the devices partition_alignment_bytes.
> +        Use 'cxl list -m <memdev> -I' to find partition_alignment_bytes.

This a static 256M, that can just be documented here.

> +
> +        Size must be less than or equal to the device's partitionable by=
tes.
> +        Calculate partitionable bytes by subracting the volatile_only_by=
tes,

s/subracting/subtracting/

...but rather than teaching the user to input valid values, tell them
the validation and translation the tool will do on their behalf with
the input based on type and the details they don't need to worry
about.
