Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36AB2F24
	for <nvdimm@lists.linux.dev>; Tue,  8 Feb 2022 21:08:50 +0000 (UTC)
Received: by mail-pj1-f54.google.com with SMTP id om7so305363pjb.5
        for <nvdimm@lists.linux.dev>; Tue, 08 Feb 2022 13:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TbfFLqtAKf/HCrfP56BRPK+rMEDHFMHhskweoQwcuho=;
        b=4My1wWFjHKFVdiJ8+3rB8Rhm+gAkQLWMJRcunoLPBYT/dB4PsmBPq09pKhFgSczBH7
         GgGH/xvQ0o8NaxFkms/iYNjGEAKIQhtJVkSCxUcnEufa8c/Vh6Rmoim2ZHcfJYZHBRf5
         LOB8Fn0tmO4cY+vi51MkFiQtremZxc5Ve5grmNN8+CoIoinvpxkR8ojRUKbUbURncjY7
         8Q0DzMeDscY3UYMSF9kdktkSZp0k0HT9d7kx0KyHIZAXWuUCMEoEVfVW7+LNrvq/8Szb
         r9XmmWWebGIFV2FUzlaPy5jwAnwdRL9evHerwPW64Ij24lZBlVIt2BPUcAWsz02W2fZL
         2xlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TbfFLqtAKf/HCrfP56BRPK+rMEDHFMHhskweoQwcuho=;
        b=qJI6Q9le/iS7/lWGBC3FxBFUgrNGTFSxWC5mmg9dm/OYAbryyh8QB8+sztIOabtYEf
         zTIm+dd8TnriFhe18dXxXcdZytDzKF4lPXdOQOwGIr29GufO1BGVjsLkdDmTbHmkGcba
         cAlsWkMG+qPkydsqnULT3DFHhhM0HeOnr3NGt0TNtBryd7OmPG3u59AgxaMvAOxO/t+S
         jW7TQopRtl9vm5jdU3CYyxKRjbekEyCZf5kZhiPVfLcGkLprk9a5Nd4PC6xG4QDKI3DB
         Yi9GPw+zUuYpVEMS76JGhpYE61CN1wCOGu4ICwcZHn82M/F9PQbz9EqlqPrzmQJ3YXV3
         HB7A==
X-Gm-Message-State: AOAM530o7cbVKKd/l3ItJReEQ93Ga1A5E/SVkeTOyRXwwKC0keAEzXzY
	0xuEy/My6aemYi8pNfKjDCLDdA4dtMtLzr+SIghPJXYGdQbmfg==
X-Google-Smtp-Source: ABdhPJy+timTwi/c8qvlAjs97VUIlp1bNKcFV+FnNreka5W5li8oZWEwnHWTcJ3bH3kkrpJheFKNEDfSwnebMOS4EpE=
X-Received: by 2002:a17:90a:2f01:: with SMTP id s1mr3400183pjd.8.1644354530180;
 Tue, 08 Feb 2022 13:08:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1644271559.git.alison.schofield@intel.com> <bc2efdbb83c4320ea97c75409ea8bb812e476ed6.1644271559.git.alison.schofield@intel.com>
In-Reply-To: <bc2efdbb83c4320ea97c75409ea8bb812e476ed6.1644271559.git.alison.schofield@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 Feb 2022 13:08:39 -0800
Message-ID: <CAPcyv4g+fcHL-_v2LXLqnz=ZE59dCTd3KU_y8MjBJubniV7eVg@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 6/6] cxl: add command set-partition
To: "Schofield, Alison" <alison.schofield@intel.com>
Cc: Ben Widawsky <ben.widawsky@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 7, 2022 at 3:06 PM <alison.schofield@intel.com> wrote:
>
> From: Alison Schofield <alison.schofield@intel.com>
>
> CXL devices may support both volatile and persistent memory capacity.
> The amount of device capacity set aside for each type is typically
> established at the factory, but some devices also allow for dynamic
> re-partitioning, add a command for this purpose.
>
> Synopsis:
>
> cxl set-partition <mem0> [<mem1>..<memN>] [<options>]
>
> -t, --type=3D<type>       'pmem' or 'volatile' (Default: 'pmem')
> -s, --size=3D<size>       size in bytes (Default: all partitionable capac=
ity)
> -a, --align             allow alignment correction
> -v, --verbose           turn on debug
>
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  Documentation/cxl/cxl-set-partition.txt |  60 ++++++++
>  Documentation/cxl/meson.build           |   1 +
>  cxl/builtin.h                           |   1 +
>  cxl/cxl.c                               |   1 +
>  cxl/memdev.c                            | 196 ++++++++++++++++++++++++
>  5 files changed, 259 insertions(+)
>  create mode 100644 Documentation/cxl/cxl-set-partition.txt
>
> diff --git a/Documentation/cxl/cxl-set-partition.txt b/Documentation/cxl/=
cxl-set-partition.txt
> new file mode 100644
> index 0000000..e20afba
> --- /dev/null
> +++ b/Documentation/cxl/cxl-set-partition.txt
> @@ -0,0 +1,60 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +cxl-set-partition(1)
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +NAME
> +----
> +cxl-set-partition - set the partitioning between volatile and persistent=
 capacity on a CXL memdev
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'cxl set-partition <mem> [ [<mem1>..<memN>] [<options>]'
> +
> +DESCRIPTION
> +-----------
> +Partition the device into volatile and persistent capacity.

I wonder if this should briefly describe the theory of operation of
partitioning of CXL devices. I.e. that this command is only relevant
for devices that support dual capacity (volatile + pmem) and only dual
capacity devices that have partitionable as opposed to static capacity
assignments. Maybe a reference to how to use 'cxl list' to determine
if 'cxl set-partition' is even relevant for the given memdev?


 The change
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
> +-t::
> +--type=3D::
> +       Type of partition, 'pmem' or 'volatile', to create.

s/create/modify/

...since the partition is statically present, just variably sized.

> +       Default: 'pmem'
> +
> +-s::
> +--size=3D::
> +       Size of the <type> partition in bytes. Size must align to the
> +       devices alignment size. Use 'cxl list -m <memdev> -I' to find
> +       the 'partition_alignment_size', or, use the 'align' option.
> +       Default: All partitionable capacity is assigned to <type>.
> +
> +-a::
> +--align::
> +       This option allows the size of the partition to be increased to
> +       meet device alignment requirements.

Perhaps reword this to say it auto-aligns so that the user can specify
the minimum size of the partition?

> +
> +-v::
> +        Turn on verbose debug messages in the library (if libcxl was bui=
lt with
> +        logging and debug enabled).
> +
> +include::../copyright.txt[]
> +
> +SEE ALSO
> +--------
> +linkcxl:cxl-list[1],
> +CXL-2.0 8.2.9.5.2
> diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.buil=
d
> index 96f4666..e927644 100644
> --- a/Documentation/cxl/meson.build
> +++ b/Documentation/cxl/meson.build
> @@ -34,6 +34,7 @@ cxl_manpages =3D [
>    'cxl-disable-memdev.txt',
>    'cxl-enable-port.txt',
>    'cxl-disable-port.txt',
> +  'cxl-set-partition.txt',
>  ]
>
>  foreach man : cxl_manpages
> diff --git a/cxl/builtin.h b/cxl/builtin.h
> index 3123d5e..7bbad98 100644
> --- a/cxl/builtin.h
> +++ b/cxl/builtin.h
> @@ -14,4 +14,5 @@ int cmd_disable_memdev(int argc, const char **argv, str=
uct cxl_ctx *ctx);
>  int cmd_enable_memdev(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_disable_port(int argc, const char **argv, struct cxl_ctx *ctx);
>  int cmd_enable_port(int argc, const char **argv, struct cxl_ctx *ctx);
> +int cmd_set_partition(int argc, const char **argv, struct cxl_ctx *ctx);
>  #endif /* _CXL_BUILTIN_H_ */
> diff --git a/cxl/cxl.c b/cxl/cxl.c
> index c20c569..ab4bbec 100644
> --- a/cxl/cxl.c
> +++ b/cxl/cxl.c
> @@ -68,6 +68,7 @@ static struct cmd_struct commands[] =3D {
>         { "enable-memdev", .c_fn =3D cmd_enable_memdev },
>         { "disable-port", .c_fn =3D cmd_disable_port },
>         { "enable-port", .c_fn =3D cmd_enable_port },
> +       { "set-partition", .c_fn =3D cmd_set_partition },
>  };
>
>  int main(int argc, const char **argv)
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index 90b33e1..5d97610 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -6,11 +6,14 @@
>  #include <unistd.h>
>  #include <limits.h>
>  #include <util/log.h>
> +#include <util/json.h>
> +#include <util/size.h>
>  #include <cxl/libcxl.h>
>  #include <util/parse-options.h>
>  #include <ccan/minmax/minmax.h>
>  #include <ccan/array_size/array_size.h>
>
> +#include "json.h"
>  #include "filter.h"
>
>  struct action_context {
> @@ -26,6 +29,9 @@ static struct parameters {
>         bool verbose;
>         bool serial;
>         bool force;
> +       bool align;
> +       const char *type;
> +       const char *size;
>  } param;
>
>  static struct log_ctx ml;
> @@ -51,6 +57,14 @@ OPT_UINTEGER('O', "offset", &param.offset, \
>  OPT_BOOLEAN('f', "force", &param.force,                                \
>             "DANGEROUS: override active memdev safety checks")
>
> +#define SET_PARTITION_OPTIONS() \
> +OPT_STRING('t', "type",  &param.type, "type",                  \
> +       "'pmem' or 'volatile' (Default: 'pmem')"),              \
> +OPT_STRING('s', "size",  &param.size, "size",                  \
> +       "size in bytes (Default: all partitionable capacity)"), \
> +OPT_BOOLEAN('a', "align",  &param.align,                       \
> +       "allow alignment correction")
> +
>  static const struct option read_options[] =3D {
>         BASE_OPTIONS(),
>         LABEL_OPTIONS(),
> @@ -82,6 +96,12 @@ static const struct option enable_options[] =3D {
>         OPT_END(),
>  };
>
> +static const struct option set_partition_options[] =3D {
> +       BASE_OPTIONS(),
> +       SET_PARTITION_OPTIONS(),
> +       OPT_END(),
> +};
> +
>  static int action_disable(struct cxl_memdev *memdev, struct action_conte=
xt *actx)
>  {
>         if (!cxl_memdev_is_enabled(memdev))
> @@ -209,6 +229,171 @@ out:
>         return rc;
>  }
>
> +static unsigned long long
> +partition_align(const char *devname, unsigned long long volatile_size,
> +               unsigned long long alignment, unsigned long long partitio=
nable)
> +{
> +       if (IS_ALIGNED(volatile_size, alignment))
> +               return volatile_size;
> +
> +       if (!param.align) {
> +               log_err(&ml, "%s: size %lld is not partition aligned %lld=
\n",
> +                       devname, volatile_size, alignment);
> +               return ULLONG_MAX;
> +       }
> +
> +       /* Align based on partition type to fulfill users size request */
> +       if (strcmp(param.type, "pmem") =3D=3D 0)
> +               volatile_size =3D ALIGN_DOWN(volatile_size, alignment);
> +       else
> +               volatile_size =3D ALIGN(volatile_size, alignment);
> +
> +       /* Fail if the align pushes size over the partitionable limit. */
> +       if (volatile_size > partitionable) {
> +               log_err(&ml, "%s: aligned partition size %lld exceeds par=
titionable size %lld\n",
> +                       devname, volatile_size, partitionable);
> +               volatile_size =3D ULLONG_MAX;
> +       }
> +
> +       return volatile_size;
> +}
> +
> +static unsigned long long
> +param_size_to_volatile_size(const char *devname, unsigned long long size=
,
> +               unsigned long long partitionable)
> +{
> +       /* User omits size option. Apply all partitionable capacity to ty=
pe. */
> +       if (size =3D=3D ULLONG_MAX)
> +               return (strcmp(param.type, "pmem") =3D=3D 0) ? 0 : partit=
ionable;

Somewhat inefficient to keep needing to parse the string parameter
buffer. How about plumb an 'enum cxl_setpart_type type' argument to
all the functions that are parsing param.type?

Where @type is:

enum cxl_setpart_type {
    CXL_SETPART_PMEM,
    CXL_SETPART_VOLATILE,
};

Other than the above,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
