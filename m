Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x231.google.com (mail-ua0-x231.google.com
 [IPv6:2607:f8b0:400c:c08::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B0C221D19922
 for <linux-nvdimm@lists.01.org>; Tue,  8 Aug 2017 11:24:35 -0700 (PDT)
Received: by mail-ua0-x231.google.com with SMTP id q25so18992542uah.1
 for <linux-nvdimm@lists.01.org>; Tue, 08 Aug 2017 11:26:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149756654995.49071.10157586966796129090.stgit@djiang5-desk3.ch.intel.com>
References: <149756654995.49071.10157586966796129090.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 8 Aug 2017 11:26:50 -0700
Message-ID: <CAPcyv4h322MS49xZBCGdwL21DO8TcrV3AesBy5WOFM5Yon-KNQ@mail.gmail.com>
Subject: Re: [PATCH] ndctl: daxctl: Adding io option for daxctl
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Finally circling back on this...

On Thu, Jun 15, 2017 at 3:42 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> The daxctl io option allows I/Os to be performed between block/file to
> and from device dax files. It also provides a way to zero a device dax
> device.
>
> i.e. daxctl io --input=/home/myfile --output=/dev/dax1.0
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  Documentation/Makefile.am   |    3
>  Documentation/daxctl-io.txt |   71 +++++
>  daxctl/Makefile.am          |    5
>  daxctl/daxctl.c             |    2
>  daxctl/io.c                 |  567 +++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 646 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/daxctl-io.txt
>  create mode 100644 daxctl/io.c
>
> diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
> index c7e0758..8efdbc2 100644
> --- a/Documentation/Makefile.am
> +++ b/Documentation/Makefile.am
> @@ -26,7 +26,8 @@ man1_MANS = \
>         ndctl-destroy-namespace.1 \
>         ndctl-check-namespace.1 \
>         ndctl-list.1 \
> -       daxctl-list.1
> +       daxctl-list.1 \
> +       daxctl-io.1
>
>  CLEANFILES = $(man1_MANS)
>
> diff --git a/Documentation/daxctl-io.txt b/Documentation/daxctl-io.txt
> new file mode 100644
> index 0000000..c3ddd15
> --- /dev/null
> +++ b/Documentation/daxctl-io.txt
> @@ -0,0 +1,71 @@
> +daxctl-io(1)
> +===========
> +
> +NAME
> +----
> +daxctl-io - Perform I/O on Device-DAX devices or zero a Device-DAX device.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'daxctl io' [<options>]
> +
> +There must be a Device-DAX device involved whether as the input or the output
> +device. Read from a Device-DAX device and write to a file, a block device,
> +another Device-DAX device, or stdout (if no output is provided). Write
> +to a Device-DAX device from a file, a block device, or stdin, or another
> +Device-DAX device.

Why does it matter if a block-device is involved? I.e. this should
operate between a device-dax instance and a file descriptor. It
shouldn't matter what that file descriptor represents.

> +
> +No length specified will default to input file/device length. If input is
> +a special char file then length will be the output file/device length.
> +
> +No input will default to stdin. No output will default to stdout.
> +
> +For a Device-DAX device, attempts to clear badblocks within range of writes
> +will be performed.
> +
> +EXAMPLE
> +-------
> +[verse]
> +# daxctl io --zero /dev/dax1.0
> +
> +# daxctl io --input=/dev/dax1.0 --output=/home/myfile --len=2097152 --seek=4096
> +
> +# cat /dev/zero | daxctl io --output=/dev/dax1.0
> +
> +# daxctl io --input=/dev/zero --output=/dev/dax1.0 --skip=4096
> +
> +OPTIONS
> +-------
> +-i::
> +--input=::
> +       Input device or file to read from.
> +
> +-o::
> +--output=::
> +       Output device or file to write to.
> +
> +-z::
> +--zero::
> +       Zero the output device for 'len' size. Or the entire device if no
> +       length was provided. The output device must be a Device DAX device.
> +
> +-l::
> +--len::
> +       The length in bytes to perform the I/O.
> +
> +-s::
> +--seek::
> +       The number of bytes to skip over on the output before performing a
> +       write.
> +
> +-k::
> +--skip::
> +       The number of bytes to skip over on the input before performing a read.
> +
> +COPYRIGHT
> +---------
> +Copyright (c) 2017, Intel Corporation. License GPLv2: GNU GPL
> +version 2 <http://gnu.org/licenses/gpl.html>.  This is free software:
> +you are free to change and redistribute it.  There is NO WARRANTY, to
> +the extent permitted by law.
> diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
> index fe467d0..1ba1f07 100644
> --- a/daxctl/Makefile.am
> +++ b/daxctl/Makefile.am
> @@ -5,10 +5,13 @@ bin_PROGRAMS = daxctl
>  daxctl_SOURCES =\
>                 daxctl.c \
>                 list.c \
> +               io.c \
>                 ../util/json.c
>
>  daxctl_LDADD =\
>         lib/libdaxctl.la \
> +       ../ndctl/lib/libndctl.la \
>         ../libutil.a \
>         $(UUID_LIBS) \
> -       $(JSON_LIBS)
> +       $(JSON_LIBS) \
> +       -lpmem
> diff --git a/daxctl/daxctl.c b/daxctl/daxctl.c
> index 91a4600..db2e495 100644
> --- a/daxctl/daxctl.c
> +++ b/daxctl/daxctl.c
> @@ -67,11 +67,13 @@ static int cmd_help(int argc, const char **argv, void *ctx)
>  }
>
>  int cmd_list(int argc, const char **argv, void *ctx);
> +int cmd_io(int argc, const char **argv, void *ctx);
>
>  static struct cmd_struct commands[] = {
>         { "version", cmd_version },
>         { "list", cmd_list },
>         { "help", cmd_help },
> +       { "io", cmd_io },
>  };
>
>  int main(int argc, const char **argv)
> diff --git a/daxctl/io.c b/daxctl/io.c
> new file mode 100644
> index 0000000..92e2878
> --- /dev/null
> +++ b/daxctl/io.c
> @@ -0,0 +1,567 @@
> +/*
> + * Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */
> +#include <stdio.h>
> +#include <errno.h>
> +#include <stdlib.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/sysmacros.h>
> +#include <sys/param.h>
> +#include <sys/mman.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <limits.h>
> +#include <libgen.h>
> +#include <libpmem.h>
> +#include <util/json.h>
> +#include <util/filter.h>
> +#include <json-c/json.h>
> +#include <daxctl/libdaxctl.h>
> +#include <ccan/short_types/short_types.h>
> +#include <util/parse-options.h>
> +#include <ccan/array_size/array_size.h>
> +#include <ndctl/ndctl.h>
> +
> +enum io_direction {
> +       IO_READ = 0,
> +       IO_WRITE,
> +};
> +
> +struct io_dev {
> +       int fd;
> +       int major;
> +       int minor;
> +       void *mmap;
> +       const char *parm_path;
> +       char *real_path;
> +       uint64_t offset;
> +       enum io_direction direction;
> +       bool is_dax;
> +       bool is_char;
> +       bool is_new;
> +       bool need_trunc;
> +       struct ndctl_ctx *ndctx;
> +       struct ndctl_region *region;
> +       struct ndctl_dax *dax;
> +       uint64_t size;
> +};
> +
> +static struct {
> +       struct io_dev dev[2];
> +       bool zero;
> +       uint64_t len;
> +       struct ndctl_cmd *ars_cap;
> +       struct ndctl_cmd *clear_err;
> +} io = {
> +       .dev[0].fd = -1,
> +       .dev[1].fd = -1,
> +};
> +
> +#define fail(fmt, ...) \
> +do { \
> +       fprintf(stderr, "daxctl-%s:%s:%d: " fmt, \
> +                       VERSION, __func__, __LINE__, ##__VA_ARGS__); \
> +} while (0)
> +
> +static bool is_stdinout(struct io_dev *io_dev)
> +{
> +       return (io_dev->fd == STDIN_FILENO ||
> +                       io_dev->fd == STDOUT_FILENO) ? true : false;
> +}
> +
> +static int setup_device(struct io_dev *io_dev, struct ndctl_ctx *ctx,
> +               size_t size)
> +{
> +       int flags, rc;
> +
> +       if (is_stdinout(io_dev))
> +               return 0;
> +
> +       if (io_dev->is_new)
> +               flags = O_CREAT|O_WRONLY|O_TRUNC;
> +       else if (io_dev->need_trunc)
> +               flags = O_RDWR | O_TRUNC;
> +       else
> +               flags = O_RDWR;
> +
> +       io_dev->fd = open(io_dev->parm_path, flags, S_IRUSR|S_IWUSR);
> +       if (io_dev->fd == -1) {
> +               rc = -errno;
> +               perror("open");
> +               return rc;
> +       }
> +
> +       if (!io_dev->is_dax)
> +               return 0;
> +
> +       flags = (io_dev->direction == IO_READ) ? PROT_READ : PROT_WRITE;
> +       io_dev->mmap = mmap(NULL, size, flags, MAP_SHARED, io_dev->fd, 0);
> +       if (io_dev->mmap == MAP_FAILED) {
> +               rc = -errno;
> +               perror("mmap");
> +               return rc;
> +       }
> +
> +       return 0;
> +}
> +
> +static int match_device(struct io_dev *io_dev, struct daxctl_region *dregion)
> +{
> +       struct daxctl_dev *dev;
> +
> +       daxctl_dev_foreach(dregion, dev) {
> +               if (io_dev->major == daxctl_dev_get_major(dev) &&
> +                       io_dev->minor == daxctl_dev_get_minor(dev)) {
> +                       io_dev->is_dax = true;
> +                       io_dev->size = daxctl_dev_get_size(dev);
> +                       return 1;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static int find_dax_device(struct io_dev *io_dev, struct ndctl_ctx *ndctx,
> +               enum io_direction dir)
> +{
> +       struct ndctl_bus *bus;
> +       struct ndctl_region *region;
> +       struct ndctl_dax *dax;
> +       struct daxctl_region *dregion;
> +       struct stat st;
> +       int rc;
> +       char cdev_path[256];
> +       char link_path[256];
> +       char *dev_name;
> +
> +       if (is_stdinout(io_dev)) {
> +               io_dev->size = ULONG_MAX;
> +               return 0;
> +       }
> +
> +       rc = stat(io_dev->parm_path, &st);
> +       if (rc == -1) {
> +               rc = -errno;
> +               if (rc == -ENOENT && dir == IO_WRITE) {
> +                       io_dev->is_new = true;
> +                       io_dev->size = ULONG_MAX;
> +                       return 0;
> +               }
> +               perror("stat");
> +               return rc;
> +       }
> +
> +       if (S_ISREG(st.st_mode)) {
> +               if (dir == IO_WRITE) {
> +                       io_dev->need_trunc = true;
> +                       io_dev->size = ULONG_MAX;
> +               } else
> +                       io_dev->size = st.st_size;
> +               return 0;
> +       } else if (S_ISBLK(st.st_mode)) {
> +               io_dev->size = st.st_size;
> +               return 0;
> +       } else if (S_ISCHR(st.st_mode)) {
> +               io_dev->size = ULONG_MAX;
> +               io_dev->is_char = true;
> +               io_dev->major = major(st.st_rdev);
> +               io_dev->minor = minor(st.st_rdev);
> +       } else
> +               return -ENODEV;
> +
> +       rc = snprintf(cdev_path, 255, "/sys/dev/char/%u:%u", io_dev->major,
> +                       io_dev->minor);
> +       if (rc < 0) {
> +               fail("snprintf\n");
> +               return -ENXIO;
> +       }
> +
> +       rc = readlink(cdev_path, link_path, 255);
> +       if (rc == -1) {
> +               rc = errno;
> +               perror("readlink");
> +               return rc;
> +       }
> +       link_path[rc] = '\0';
> +       dev_name = basename(link_path);
> +
> +       ndctl_bus_foreach(ndctx, bus)
> +               ndctl_region_foreach(bus, region)
> +                       ndctl_dax_foreach(region, dax) {
> +                               if (strncmp(dev_name,
> +                                               ndctl_dax_get_devname(dax),
> +                                               256))
> +                                       continue;

Drop this ndctl_dax_get_devname() check, it will fail in the case
where the device-dax instance name does not match the parent nvdimm
region name. In fact, we shouldn't be looking for the ndctl
infrastructure at all unless we're attempting error clearing. Consider
the case where a dax instance is not associated with a libnvdimm
device, like we want to support with the HMAT enabling.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
