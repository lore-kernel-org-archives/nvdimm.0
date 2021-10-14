Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE052C83
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 22:35:01 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id 133so6850569pgb.1
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 15:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hb8ILp8FAEU4P38VkNEP4kdPalHGHFqMjJBuelQ6Dps=;
        b=YQS2WshOK3xOcS7uVhN74wWBRsmwAWmPJRH0hPpDCL4pRNA7YQB5yYZjYaeVls8/Sc
         NpX9G0zf6A69Cdw+1Q6Wpiyc8mDxmgCIg8/4KIGAUpXgXuTN6VLWNRNbA2v9Oo06H4cW
         fXqq9T6a7Ysd81U5YeL9mbr27BxHGV5U2rxPEUGCASVfJ5n85DxCsQK8b5Bbfd0oTsNd
         6NTg3pWk9nWQ482E7RgzXVYenLggvUSl2/uxWfnToP4yafhRe84MAZHfqb29BuTUZcq2
         AyybaCUFL7EqdgCXLK4glW7wjq4pr86NJYgYtRSnBqCLbkXr5no8RdiPIL23xrdRocwJ
         yWGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hb8ILp8FAEU4P38VkNEP4kdPalHGHFqMjJBuelQ6Dps=;
        b=q5+RJQVycd5+f9N8DwsCLGYiV9Eb9PKl8/Bo8i3yui5utYXjuM4UOq62zIpE82pY1g
         +FarGlOVWjXP4iEtg65r64HV2pGEUUe0iowRzMNSg5AYJfZ2TAwOP5s1ZK9Z1j/MmpAH
         b8zSu2fEzMaaoOiGw5TYG3ffRwnOmQjpU0z1Zjy98+GIhuEZFLTRdYNKQtDgRueilNom
         pV6u3KoIQOqmRX8pfUusleeQCwZAf0c5Kvbb4hc/xBwbYDDXf3ZfU2iwzhB+UxUkL+1I
         XuU9dLvj4wUMO+VbHPHlZStpvGQHLVdaqgx9CQ1cPpEHwN/p2LlDL41kOTbxZ2BUkkTk
         Wl6w==
X-Gm-Message-State: AOAM533OGC7fQSg0cG+IjkCdRrf271khFA1semy/K7Zczh59qtnBlLbF
	JN4o6nqNKjsw4RoLfCY/CyAqXBbubySY+dx73U8wTA==
X-Google-Smtp-Source: ABdhPJw2KU4WYkUnCIMO0A0aDpmcS8O9Wfjd5OpMmRJ6bvsCdgO+CwZSHX09zlmqa6FakJ79lGXKSWZ45p762lz3d3g=
X-Received: by 2002:a05:6a00:1a01:b0:44c:1ec3:364f with SMTP id
 g1-20020a056a001a0100b0044c1ec3364fmr8271567pfv.86.1634250901067; Thu, 14 Oct
 2021 15:35:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com> <20211007082139.3088615-14-vishal.l.verma@intel.com>
In-Reply-To: <20211007082139.3088615-14-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 15:34:50 -0700
Message-ID: <CAPcyv4gf-yR7dcLEK+L6VV7m3=1sY6CtRiWAziHw9VNBLv6E6A@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 13/17] cxl: add commands to read, write, and zero labels
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add the following cxl-cli commands: read-labels, write-labels,
> zero-labels. They operate on a CXL memdev, or a set of memdevs, and
> allow interacting with the label storage area (LSA) on the device.
>
> Add man pages for the above cxl-cli commands.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
[..]
> diff --git a/Documentation/cxl/cxl-write-labels.txt b/Documentation/cxl/cxl-write-labels.txt
> new file mode 100644
> index 0000000..c4592b3
> --- /dev/null
> +++ b/Documentation/cxl/cxl-write-labels.txt
> @@ -0,0 +1,32 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-write-labels(1)
> +===================
> +
> +NAME
> +----
> +cxl-write-labels - write data to the label area on a memdev
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl write-labels <mem> [-i <filename>]'
> +
> +include::labels-description.txt[]
> +Read data from the input filename, or stdin, and write it to the given
> +<mem> device. Note that the device must not be active in any region,

...just add:

    "or actively registered with the nvdimm subsystem,"


> +otherwise the kernel will not allow write access to the device's label
> +data area.
> +
> +OPTIONS
> +-------
> +include::labels-options.txt[]
> +-i::
> +--input::
> +       input file
> +
> +SEE ALSO
> +--------
> +linkcxl:cxl-read-labels[1],
> +linkcxl:cxl-zero-labels[1],
> +CXL-2.0 9.13.2
> diff --git a/Documentation/cxl/cxl-zero-labels.txt b/Documentation/cxl/cxl-zero-labels.txt
> new file mode 100644
> index 0000000..bf95b24
> --- /dev/null
> +++ b/Documentation/cxl/cxl-zero-labels.txt
> @@ -0,0 +1,29 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-zero-labels(1)
> +==================
> +
> +NAME
> +----
> +cxl-zero-labels - zero out the label area on a set of memdevs
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl zero-labels' <mem0> [<mem1>..<memN>] [<options>]
> +
> +include::labels-description.txt[]
> +This command resets the device to its default state by
> +deleting all labels.
> +
> +OPTIONS
> +-------
> +include::labels-options.txt[]
> +
> +include::../copyright.txt[]
> +
> +SEE ALSO
> +--------
> +linkcxl:cxl-read-labels[1],
> +linkcxl:cxl-write-labels[1],
> +CXL-2.0 9.13.2
> diff --git a/Documentation/cxl/labels-description.txt b/Documentation/cxl/labels-description.txt
> new file mode 100644
> index 0000000..f60bd5d
> --- /dev/null
> +++ b/Documentation/cxl/labels-description.txt
> @@ -0,0 +1,8 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +DESCRIPTION
> +-----------
> +The region label area is a small persistent partition of capacity
> +available on some CXL memory devices. The label area is used to
> +and configure or determine the set of memory devices participating
> +in different interleave sets.
> diff --git a/Documentation/cxl/labels-options.txt b/Documentation/cxl/labels-options.txt
> new file mode 100644
> index 0000000..06fbac3
> --- /dev/null
> +++ b/Documentation/cxl/labels-options.txt
> @@ -0,0 +1,17 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +<memory device(s)>::
> +include::memdev-option.txt[]
> +
> +-s::
> +--size=::
> +       Limit the operation to the given number of bytes. A size of 0
> +       indicates to operate over the entire label capacity.
> +
> +-O::
> +--offset=::
> +       Begin the operation at the given offset into the label area.
> +
> +-v::
> +       Turn on verbose debug messages in the library (if libcxl was built with
> +       logging and debug enabled).
> diff --git a/Documentation/cxl/memdev-option.txt b/Documentation/cxl/memdev-option.txt
> new file mode 100644
> index 0000000..e778582
> --- /dev/null
> +++ b/Documentation/cxl/memdev-option.txt
> @@ -0,0 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
> +A 'memX' device name, or a memdev id number. Restrict the operation to
> +the specified memdev(s). The keyword 'all' can be specified to indicate
> +the lack of any restriction.
> diff --git a/cxl/builtin.h b/cxl/builtin.h
> index 3797f98..78eca6e 100644
> --- a/cxl/builtin.h
> +++ b/cxl/builtin.h
> @@ -5,4 +5,9 @@
>
>  struct cxl_ctx;
>  int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_write_labels(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_read_labels(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_zero_labels(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_init_labels(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_check_labels(int argc, const char **argv, struct cxl_ctx *ctx);
>  #endif /* _CXL_BUILTIN_H_ */
> diff --git a/cxl/cxl.c b/cxl/cxl.c
> index a7725f8..4b1661d 100644
> --- a/cxl/cxl.c
> +++ b/cxl/cxl.c
> @@ -61,6 +61,9 @@ static struct cmd_struct commands[] = {
>         { "version", .c_fn = cmd_version },
>         { "list", .c_fn = cmd_list },
>         { "help", .c_fn = cmd_help },
> +       { "zero-labels", .c_fn = cmd_zero_labels },
> +       { "read-labels", .c_fn = cmd_read_labels },
> +       { "write-labels", .c_fn = cmd_write_labels },
>  };
>
>  int main(int argc, const char **argv)
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> new file mode 100644
> index 0000000..ffc66df
> --- /dev/null
> +++ b/cxl/memdev.c
> @@ -0,0 +1,314 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2020-2021 Intel Corporation. All rights reserved. */
> +#include <stdio.h>
> +#include <errno.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <limits.h>
> +#include <util/log.h>
> +#include <util/filter.h>
> +#include <cxl/libcxl.h>
> +#include <util/parse-options.h>
> +#include <ccan/minmax/minmax.h>
> +#include <ccan/array_size/array_size.h>
> +
> +struct action_context {
> +       FILE *f_out;
> +       FILE *f_in;
> +};
> +
> +static struct parameters {
> +       const char *outfile;
> +       const char *infile;
> +       unsigned len;
> +       unsigned offset;
> +       bool verbose;
> +} param;
> +
> +#define fail(fmt, ...) \
> +do { \
> +       fprintf(stderr, "cxl-%s:%s:%d: " fmt, \
> +                       VERSION, __func__, __LINE__, ##__VA_ARGS__); \
> +} while (0)
> +
> +#define BASE_OPTIONS() \
> +OPT_BOOLEAN('v',"verbose", &param.verbose, "turn on debug")
> +
> +#define READ_OPTIONS() \
> +OPT_STRING('o', "output", &param.outfile, "output-file", \
> +       "filename to write label area contents")
> +
> +#define WRITE_OPTIONS() \
> +OPT_STRING('i', "input", &param.infile, "input-file", \
> +       "filename to read label area data")
> +
> +#define LABEL_OPTIONS() \
> +OPT_UINTEGER('s', "size", &param.len, "number of label bytes to operate"), \
> +OPT_UINTEGER('O', "offset", &param.offset, \
> +       "offset into the label area to start operation")
> +
> +static const struct option read_options[] = {
> +       BASE_OPTIONS(),
> +       LABEL_OPTIONS(),
> +       READ_OPTIONS(),
> +       OPT_END(),
> +};
> +
> +static const struct option write_options[] = {
> +       BASE_OPTIONS(),
> +       LABEL_OPTIONS(),
> +       WRITE_OPTIONS(),
> +       OPT_END(),
> +};
> +
> +static const struct option zero_options[] = {
> +       BASE_OPTIONS(),
> +       LABEL_OPTIONS(),
> +       OPT_END(),
> +};
> +
> +static int action_zero(struct cxl_memdev *memdev, struct action_context *actx)
> +{
> +       int rc;
> +
> +       if (cxl_memdev_is_active(memdev)) {
> +               fprintf(stderr, "%s: memdev active, abort label write\n",
> +                       cxl_memdev_get_devname(memdev));
> +               return -EBUSY;
> +       }
> +
> +       rc = cxl_memdev_zero_label(memdev);
> +       if (rc < 0)
> +               fprintf(stderr, "%s: label zeroing failed: %s\n",
> +                       cxl_memdev_get_devname(memdev), strerror(-rc));
> +
> +       return rc;
> +}
> +
> +static int action_write(struct cxl_memdev *memdev, struct action_context *actx)
> +{
> +       size_t size = param.len, read_len;
> +       unsigned char *buf;
> +       int rc;
> +
> +       if (cxl_memdev_is_active(memdev)) {

Similar cxl_memdev_nvdimm_bridge_active() comment as before...

...but other than that nothing else jumps out:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
