Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C652C80
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 22:19:20 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id l10-20020a17090a384a00b001b22190e075so10080339pjf.3
        for <nvdimm@lists.linux.dev>; Thu, 06 Jan 2022 14:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qdMFx/QzoWX1+IsHVch7VB0wvIBZ3X//+6+hiPtIjgU=;
        b=N7ZsI2oOLr2Oi+fdo5EhNd7p6qy3DtpaDsrd3M1NkDP7fxWsSlbPtAymMQattl+5U1
         6qoeo1hghGIoTH+voaWPbrI3iKHxC6W3IWTl5cnYZjBzIZphXhSulDGlsnNVYv3V0sXy
         qJxe1QPFg3UfHeCHAn0OuKd0CAkK5g2l/uil9yeVfgVbEYyJQfhNtIkQdLCalOgj9ODl
         CVi31MvrEBDt2FMuJa55tekR3MlCKnkK2W2S7f/AVdUuAkvYVjQ721zscBBxS3feFRqs
         bYe5LDS748YTqhL3z8PwdmWiWSKRw0uwunHa2BOQfvfQpKJT9iitViZbzbHfDIBCbG0N
         7VKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qdMFx/QzoWX1+IsHVch7VB0wvIBZ3X//+6+hiPtIjgU=;
        b=qu11DAqMVwrCF1UTZ6+LnD6xRVbizuZTs+IVSn9P9h6UfG8tpt+HOHXRvT6Sygm8te
         PltwJfBzcFe6Yk/Xe2D6mMd8adY/GbT6r13LRi8cXVsje4GKfrEflXXCYXTtivoX+LJd
         ZYZgcdcbaxOYVs3gEw5M5MyvV3+KsL7rHuI1ESkWtqThiFXQiI93EgpixWRUEOscgx+j
         W3pmHRqoIWhVpIdIUSSBQYJYczW1uI9e7MY1g/jyI/w+TwHt3tzVXIBx2LAhpuIbiInH
         kTO+6tcX9X5GyEUlk3n0PopzMKefohHBe9lk77yKEoEsFUn0dH74lq5imlttg6R2S9uZ
         N0QQ==
X-Gm-Message-State: AOAM5301V22ZQGJN1oY6y741o/aOIG0gXYnFLJUORopv8gY2ZiwpifYw
	i8fHAOkan9cE4P5EzgX9lVdPT+gfK82NyliqYxA/RQ==
X-Google-Smtp-Source: ABdhPJz7wSNyUpzVxsu0sLTZhQQykIHmLvm6Oa4jrE6skLZv8EmqFOvoaCUvHrD0KiVH1jILnBBXFTpEDT4IlkLcQic=
X-Received: by 2002:a17:902:8488:b0:149:8545:5172 with SMTP id
 c8-20020a170902848800b0014985455172mr46479336plo.132.1641507559738; Thu, 06
 Jan 2022 14:19:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1641233076.git.alison.schofield@intel.com> <fd590fbbc2f1abaeca1fd368d26c4e90c3a89d69.1641233076.git.alison.schofield@intel.com>
In-Reply-To: <fd590fbbc2f1abaeca1fd368d26c4e90c3a89d69.1641233076.git.alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 6 Jan 2022 14:19:08 -0800
Message-ID: <CAPcyv4gYjDo7vuFYqJgUL6mvOKosrzLRMxTA8tB0v86s08f_VA@mail.gmail.com>
Subject: Re: [ndctl PATCH 7/7] cxl: add command set-partition-info
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 3, 2022 at 12:11 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> The command 'cxl set-partition-info' operates on a CXL memdev,
> or a set of memdevs, allowing the user to change the partition
> layout of the device.
>
> Synopsis:
> Usage: cxl set-partition-info <mem0> [<mem1>..<memN>] [<options>]
>
>     -v, --verbose         turn on debug
>     -s, --volatile_size <n>
>                           next volatile partition size in bytes
>
> The MAN page explains how to find partitioning capabilities and
> restrictions.
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  Documentation/cxl/cxl-set-partition-info.txt | 27 ++++++
>  Documentation/cxl/partition-description.txt  | 15 ++++
>  Documentation/cxl/partition-options.txt      | 19 +++++
>  Documentation/cxl/Makefile.am                |  3 +-
>  cxl/builtin.h                                |  1 +
>  cxl/cxl.c                                    |  1 +
>  cxl/memdev.c                                 | 89 ++++++++++++++++++++
>  7 files changed, 154 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/cxl/cxl-set-partition-info.txt
>  create mode 100644 Documentation/cxl/partition-description.txt
>  create mode 100644 Documentation/cxl/partition-options.txt
>
> diff --git a/Documentation/cxl/cxl-set-partition-info.txt b/Documentation=
/cxl/cxl-set-partition-info.txt
> new file mode 100644
> index 0000000..32418b6
> --- /dev/null
> +++ b/Documentation/cxl/cxl-set-partition-info.txt
> @@ -0,0 +1,27 @@
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
> +include::partition-description.txt[]
> +Partition the device on the next device reset using the volatile capacit=
y
> +requested. Using this command to change the size of the persistent capac=
ity
> +shall result in the loss of stored data.
> +
> +OPTIONS
> +-------
> +include::partition-options.txt[]
> +
> +SEE ALSO
> +--------
> +linkcxl:cxl-list[1],
> +CXL-2.0 8.2.9.5.2
> diff --git a/Documentation/cxl/partition-description.txt b/Documentation/=
cxl/partition-description.txt
> new file mode 100644
> index 0000000..b3efac8
> --- /dev/null
> +++ b/Documentation/cxl/partition-description.txt
> @@ -0,0 +1,15 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +DESCRIPTION
> +-----------
> +Partition the device into volatile and persistent capacity. The change
> +in partitioning will become the =E2=80=9Cnext=E2=80=9D configuration, to=
 become active
> +on the next device reset.
> +
> +Use "cxl list -m <memdev> -P" to examine the partition capacities
> +supported on a device. Paritionable capacity must exist on the
> +device. A partition_alignment of zero means no partitionable
> +capacity is available.
> +
> +Using this command to change the size of the persistent capacity shall
> +result in the loss of data stored.
> diff --git a/Documentation/cxl/partition-options.txt b/Documentation/cxl/=
partition-options.txt
> new file mode 100644
> index 0000000..84e49c9
> --- /dev/null
> +++ b/Documentation/cxl/partition-options.txt
> @@ -0,0 +1,19 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +<memory device(s)>::
> +include::memdev-option.txt[]
> +
> +-s::
> +--size=3D::
> +       Size in bytes of the volatile partition requested.
> +
> +       Size must align to the devices partition_alignment.
> +       Use 'cxl list -m <memdev> -P' to find partition_alignment.
> +
> +       Size must be less than or equal to the devices partitionable byte=
s.
> +       (total_capacity - volatile_only_capacity - persistent_only_capaci=
ty)
> +       Use 'cxl list -m <memdev> -P' to find *_capacity values.
> +
> +-v::
> +       Turn on verbose debug messages in the library (if libcxl was buil=
t with
> +       logging and debug enabled).
> diff --git a/Documentation/cxl/Makefile.am b/Documentation/cxl/Makefile.a=
m
> index efabaa3..c5faf04 100644
> --- a/Documentation/cxl/Makefile.am
> +++ b/Documentation/cxl/Makefile.am
> @@ -22,7 +22,8 @@ man1_MANS =3D \
>         cxl-list.1 \
>         cxl-read-labels.1 \
>         cxl-write-labels.1 \
> -       cxl-zero-labels.1
> +       cxl-zero-labels.1 \
> +       cxl-set-partition-info.1
>
>  EXTRA_DIST =3D $(man1_MANS)
>
> diff --git a/cxl/builtin.h b/cxl/builtin.h
> index 78eca6e..7f11f28 100644
> --- a/cxl/builtin.h
> +++ b/cxl/builtin.h
> @@ -10,4 +10,5 @@ int cmd_read_labels(int argc, const char **argv, struct=
 cxl_ctx *ctx);
>  int cmd_zero_labels(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_init_labels(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_check_labels(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_set_partition_info(int argc, const char **argv, struct cxl_ctx *=
ctx);
>  #endif /* _CXL_BUILTIN_H_ */
> diff --git a/cxl/cxl.c b/cxl/cxl.c
> index 4b1661d..3153cf0 100644
> --- a/cxl/cxl.c
> +++ b/cxl/cxl.c
> @@ -64,6 +64,7 @@ static struct cmd_struct commands[] =3D {
>         { "zero-labels", .c_fn =3D cmd_zero_labels },
>         { "read-labels", .c_fn =3D cmd_read_labels },
>         { "write-labels", .c_fn =3D cmd_write_labels },
> +       { "set-partition-info", .c_fn =3D cmd_set_partition_info },
>  };
>
>  int main(int argc, const char **argv)
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index 5ee38e5..fa63317 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -6,6 +6,7 @@
>  #include <unistd.h>
>  #include <limits.h>
>  #include <util/log.h>
> +#include <util/size.h>
>  #include <util/filter.h>
>  #include <cxl/libcxl.h>
>  #include <util/parse-options.h>
> @@ -23,6 +24,7 @@ static struct parameters {
>         unsigned len;
>         unsigned offset;
>         bool verbose;
> +       unsigned long long volatile_size;
>  } param;
>
>  #define fail(fmt, ...) \
> @@ -47,6 +49,10 @@ OPT_UINTEGER('s', "size", &param.len, "number of label=
 bytes to operate"), \
>  OPT_UINTEGER('O', "offset", &param.offset, \
>         "offset into the label area to start operation")
>
> +#define SET_PARTITION_OPTIONS() \
> +OPT_U64('s', "volatile_size",  &param.volatile_size, \
> +       "next volatile partition size in bytes")
> +
>  static const struct option read_options[] =3D {
>         BASE_OPTIONS(),
>         LABEL_OPTIONS(),
> @@ -67,6 +73,12 @@ static const struct option zero_options[] =3D {
>         OPT_END(),
>  };
>
> +static const struct option set_partition_options[] =3D {
> +       BASE_OPTIONS(),
> +       SET_PARTITION_OPTIONS(),
> +       OPT_END(),
> +};
> +
>  static int action_zero(struct cxl_memdev *memdev, struct action_context =
*actx)
>  {
>         size_t size;
> @@ -174,6 +186,73 @@ out:
>         return rc;
>  }
>
> +static int validate_partition(struct cxl_memdev *memdev,
> +               unsigned long long volatile_request)
> +{
> +       unsigned long long total_cap, volatile_only, persistent_only;
> +       unsigned long long partitionable_bytes, partition_align_bytes;
> +       const char *devname =3D cxl_memdev_get_devname(memdev);
> +       struct cxl_cmd *cmd;
> +       int rc;
> +
> +       cmd =3D cxl_cmd_new_identify(memdev);
> +       if (!cmd)
> +               return -ENXIO;
> +       rc =3D cxl_cmd_submit(cmd);
> +       if (rc < 0)
> +               goto err;
> +       rc =3D cxl_cmd_get_mbox_status(cmd);
> +       if (rc !=3D 0)
> +               goto err;
> +
> +       partition_align_bytes =3D cxl_cmd_identify_get_partition_align(cm=
d);
> +       if (partition_align_bytes =3D=3D 0) {
> +               fprintf(stderr, "%s: no partitionable capacity\n", devnam=
e);
> +               rc =3D -EINVAL;
> +               goto err;
> +       }
> +
> +       total_cap =3D cxl_cmd_identify_get_total_capacity(cmd);
> +       volatile_only =3D cxl_cmd_identify_get_volatile_only_capacity(cmd=
);
> +       persistent_only =3D cxl_cmd_identify_get_persistent_only_capacity=
(cmd);
> +
> +       partitionable_bytes =3D total_cap - volatile_only - persistent_on=
ly;
> +
> +       if (volatile_request > partitionable_bytes) {
> +               fprintf(stderr, "%s: volatile size %lld exceeds partition=
able capacity %lld\n",
> +                       devname, volatile_request, partitionable_bytes);
> +               rc =3D -EINVAL;
> +               goto err;
> +       }
> +       if (!IS_ALIGNED(volatile_request, partition_align_bytes)) {
> +               fprintf(stderr, "%s: volatile size %lld is not partition =
aligned %lld\n",
> +                       devname, volatile_request, partition_align_bytes)=
;
> +               rc =3D -EINVAL;
> +       }
> +err:
> +       cxl_cmd_unref(cmd);
> +       return rc;
> +}
> +
> +static int action_set_partition(struct cxl_memdev *memdev,
> +               struct action_context *actx)
> +{
> +       const char *devname =3D cxl_memdev_get_devname(memdev);
> +       unsigned long long volatile_request;
> +       int rc;
> +
> +       volatile_request =3D param.volatile_size;
> +
> +       rc =3D validate_partition(memdev, volatile_request);
> +       if (rc)
> +               return rc;
> +
> +       rc =3D cxl_memdev_set_partition_info(memdev, volatile_request, 0)=
;
> +       if (rc)
> +               fprintf(stderr, "%s error: %s\n", devname, strerror(-rc))=
;
> +       return rc;

One of the conventions from ndctl is that any command that modifies an
object should also emit the updated state of that object in JSON. For
example, "ndctl reconfigure-namespace" arranges for:

                unsigned long flags =3D UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
                struct json_object *jndns;

                if (isatty(1))
                        flags |=3D UTIL_JSON_HUMAN;
                jndns =3D util_namespace_to_json(ndns, flags);
                if (jndns)
                        printf("%s\n", json_object_to_json_string_ext(jndns=
,
                                                JSON_C_TO_STRING_PRETTY));

...to dump the updated state of the namespace, so a similar
util_memdev_to_json() seems appropriate here. However, perhaps that
can come later. I have work-in-progress patches to move the core of
cxl/list.c to a cxl_filter_walk() helper that would allow you to just
call that to dump a listing for all the memdevs that were passed on
the command line.
