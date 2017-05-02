Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7C65B21A134B8
 for <linux-nvdimm@lists.01.org>; Tue,  2 May 2017 16:55:48 -0700 (PDT)
Date: Tue, 2 May 2017 17:54:25 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH v5] ndctl: add clear error support for ndctl
Message-ID: <20170502235424.GB11414@omniknight.lm.intel.com>
References: <149375673867.14088.8455971000052942105.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149375673867.14088.8455971000052942105.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 05/02, Dave Jiang wrote:
> Adding ndctl support that will allow clearing of bad blocks for a device.
> Initial implementation will only support device dax devices. The ndctl
> takes a device path and parameters of the starting bad block, and the number
> of bad blocks to clear.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> 
> v2: Addressed comments from Vishal
> - added bounds checking for the badblocks region.
> - updated verbiage to use badblocks instead of poison.
> - set default len to 1.
> - fixed error out for stat
> - fixed error out that was copy/paste error
> - remove duplicate check_min_kver() in shell script
> - fixed logic of checking empty badblocks
> 
> v3: Addressed comments from Toshi
> - Fixed bad region path for badblocks
> 
> v4: Address comments from Toshi
> - Added error output for length that exceeds badblock coverage.
> 
> v5: Address comments from Toshi
> - Made -l 0 to error out and no length means 1 block cleared.
> 
>  Documentation/Makefile.am           |    1 
>  Documentation/ndctl-clear-error.txt |   40 ++++++
>  builtin.h                           |    1 
>  ndctl/Makefile.am                   |    1 
>  ndctl/clear-error.c                 |  241 +++++++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl.c                |   70 ++++++++++
>  ndctl/lib/libndctl.sym              |    2 
>  ndctl/libndctl.h.in                 |   10 +
>  ndctl/ndctl.c                       |    4 -
>  test/Makefile.am                    |    1 
>  test/ndctl-clear-error-dax.sh       |   68 ++++++++++
>  11 files changed, 438 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ndctl-clear-error.txt
>  create mode 100644 ndctl/clear-error.c
>  create mode 100755 test/ndctl-clear-error-dax.sh
> 
> diff --git a/Documentation/Makefile.am b/Documentation/Makefile.am
> index d72085d..7bf1caa 100644
> --- a/Documentation/Makefile.am
> +++ b/Documentation/Makefile.am
> @@ -14,6 +14,7 @@ man1_MANS = \
>  	ndctl-create-namespace.1 \
>  	ndctl-destroy-namespace.1 \
>  	ndctl-check-namespace.1 \
> +	ndctl-clear-error.1 \
>  	ndctl-list.1 \
>  	daxctl-list.1
>  
> diff --git a/Documentation/ndctl-clear-error.txt b/Documentation/ndctl-clear-error.txt
> new file mode 100644
> index 0000000..b56cdb7
> --- /dev/null
> +++ b/Documentation/ndctl-clear-error.txt
> @@ -0,0 +1,40 @@
> +ndctl-clear-error(1)
> +====================
> +
> +NAME
> +----
> +ndctl-clear-error - clear badblocks for a device
> +
> +SYNOPSIS
> +--------
> +[verse]
> +'ndctl clear-error' [<options>]
> +
> +EXAMPLES
> +--------
> +
> +Clear poison (bad blocks) for the provided device
> +[verse]
> +ndctl clear-error -f /dev/dax0.0 -s 0 -l 8
> +
> +Clear poison (bad blocks) at block offset 0 for 8 blocks on device /dev/dax0.0
> +
> +OPTIONS
> +-------
> +-f::
> +--file::
> +	The device/file to be cleared of poison (bad blocks).
> +
> +-s::
> +--start::
> +	The offset where the poison (bad block) starts for this device.
> +	Typically this is acquired from the sysfs badblocks file.
> +
> +-l::
> +--len::
> +	The number of badblocks to clear in size of 512 bytes increments. The
> +	length must fit within the badblocks range. If the length exceeds the
> +	badblock range or is 0, the command will fail. Not providing a len
> +	will result in a single block being cleared.
> +
> +

git am warns about whitespace at the end of the file:

Applying: ndctl: add clear error support for ndctl
.git/rebase-apply/patch:93: new blank line at EOF.
+
warning: 1 line adds whitespace errors.

> diff --git a/builtin.h b/builtin.h
> index a8bc848..f522d00 100644
> --- a/builtin.h
> +++ b/builtin.h
> @@ -30,4 +30,5 @@ int cmd_test(int argc, const char **argv, void *ctx);
>  #ifdef ENABLE_DESTRUCTIVE
>  int cmd_bat(int argc, const char **argv, void *ctx);
>  #endif
> +int cmd_clear_error(int argc, const char **argv, void *ctx);
>  #endif /* _NDCTL_BUILTIN_H_ */
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index d346c04..8123169 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -11,6 +11,7 @@ ndctl_SOURCES = ndctl.c \
>  		 ../util/log.c \
>  		list.c \
>  		test.c \
> +		clear-error.c \
>  		../util/json.c
>  
>  if ENABLE_SMART
> diff --git a/ndctl/clear-error.c b/ndctl/clear-error.c
> new file mode 100644
> index 0000000..597e821
> --- /dev/null
> +++ b/ndctl/clear-error.c
> @@ -0,0 +1,241 @@
> +#include <stdio.h>
> +#include <errno.h>
> +#include <stdlib.h>
> +#include <stdint.h>
> +#include <stdbool.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> +#include <libgen.h>
> +#include <string.h>
> +#include <limits.h>
> +#include <ccan/short_types/short_types.h>
> +#include <ccan/array_size/array_size.h>
> +#include <util/filter.h>

array_size.h and filter.h seem unused.

> +#include <util/parse-options.h>
> +#include <util/log.h>
> +#include <ndctl/libndctl.h>
> +#include <ndctl.h>
> +
> +struct clear_err {
> +	const char *dev_name;
> +	u64 bb_start;
> +	unsigned int bb_len;
> +	struct ndctl_cmd *ars_cap;
> +	struct ndctl_cmd *clear_err;
> +	struct ndctl_bus *bus;
> +	struct ndctl_region *region;
> +	struct ndctl_dax *dax;
> +	struct ndctl_ctx *ctx;
> +} clear_err;
> +
> +static int send_clear_error(struct ndctl_bus *bus, u64 start, u64 size)
> +{
> +	u64 cleared;
> +	int rc;
> +
> +	clear_err.clear_err = ndctl_bus_cmd_new_clear_error(
> +			start, size, clear_err.ars_cap);
> +	if (!clear_err.clear_err) {
> +		error("%s: bus: %s failed to create cmd\n",
> +				__func__, ndctl_bus_get_provider(bus));
> +		return -ENXIO;
> +	}
> +
> +	rc = ndctl_cmd_submit(clear_err.clear_err);
> +	if (rc) {
> +		error("%s: bus: %s failed to submit cmd: %d\n",
> +				__func__, ndctl_bus_get_provider(bus), rc);
> +		ndctl_cmd_unref(clear_err.clear_err);
> +		return rc;
> +	}
> +
> +	cleared = ndctl_cmd_clear_error_get_cleared(clear_err.clear_err);
> +	if (cleared != size) {
> +		error("%s: bus: %s expected to clear: %ld actual: %ld\
> +n",

Accidental newline?

> +				__func__, ndctl_bus_get_provider(bus),
> +				size, cleared);
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int get_ars_cap(struct ndctl_bus *bus, u64 start, u64 size)
> +{
> +	int rc;
> +
> +	clear_err.ars_cap = ndctl_bus_cmd_new_ars_cap(bus, start, size);
> +	if (!clear_err.ars_cap) {
> +		error("%s: bus: %s failed to create cmd\n",
> +				__func__, ndctl_bus_get_provider(bus));
> +		return -ENOTTY;
> +	}
> +
> +	rc = ndctl_cmd_submit(clear_err.ars_cap);
> +	if (rc) {
> +		error("%s: bus: %s failed to submit cmd: %d\n",
> +				__func__, ndctl_bus_get_provider(bus), rc);
> +		ndctl_cmd_unref(clear_err.ars_cap);
> +		return rc;
> +	}
> +
> +	if (ndctl_cmd_ars_cap_get_size(clear_err.ars_cap) <
> +			sizeof(struct nd_cmd_ars_status)){
> +		error("%s: bus: %s expected size >= %zd got: %d\n",
> +				__func__, ndctl_bus_get_provider(bus),
> +				sizeof(struct nd_cmd_ars_status),
> +				ndctl_cmd_ars_cap_get_size(clear_err.ars_cap));
> +		ndctl_cmd_unref(clear_err.ars_cap);
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int match_dev(struct clear_err *ce, char *dev_name)
> +{
> +	ndctl_bus_foreach(ce->ctx, ce->bus) {
> +		ndctl_region_foreach(ce->bus, ce->region) {
> +			ndctl_dax_foreach(ce->region, ce->dax) {
> +				if (strncmp(basename(dev_name),
> +					ndctl_dax_get_devname(ce->dax), 256)
> +						== 0) {
> +					return 0;
> +				}
> +			}
> +		}
> +	}

Since all of these blocks are one-liners, the braces could be removed

> +
> +	return -ENODEV;
> +}
> +
> +static int check_user_input_range(struct ndctl_region *region,
> +		unsigned long long start, unsigned int len)
> +{
> +	struct badblock *bb;
> +	int fit = 0;
> +
> +	ndctl_region_badblock_foreach(region, bb) {
> +		if (start >= bb->offset &&
> +				start + len <= bb->offset + bb->len) {
> +			fit = 1;
> +			break;
> +		}
> +	}
> +
> +	return fit;
> +}

This can probably be slightly simplified:
	ndctl_region_badblock_foreach(region, bb)
		if (start >= bb->offset &&
			start + len <= bb->offset + bb->len)
			return 1;
	return 0;

i.e. no need to break if all you are doing is returning, and no need for
the 'fit' variable.

> +
> +static int clear_error(struct clear_err *ce)
> +{
> +	struct stat stats;
> +	int rc;
> +	char dev_name[256];
> +	uint64_t base;
> +	unsigned long long start;
> +	unsigned int len;
> +
> +	strncpy(dev_name, ce->dev_name, 256);
> +
> +	rc = stat(dev_name, &stats);
> +	if (rc < 0) {
> +		perror("stat failed");
> +		error("Unable to stat %s\n", dev_name);
> +		return -1;
> +	}
> +
> +	if (!S_ISCHR(stats.st_mode)) {
> +		error("%s not DAX device\n", dev_name);
> +		return -1;
> +	}
> +

A more general question, we're restricting the clear-error command to
dax devs, but is there any reason to do that? Why not just allow
clearing errors for normal namespaces too using this?

> +	rc = ndctl_new(&ce->ctx);
> +	if (rc)
> +		return rc;
> +
> +	if ((rc = match_dev(ce, dev_name)) < 0)
> +		goto cleanup;
> +
> +	base = ndctl_region_get_resource(ce->region);
> +	if (base == ULLONG_MAX) {
> +		rc = -ERANGE;
> +		goto cleanup;
> +	}
> +
> +	if (check_user_input_range(ce->region, clear_err.bb_start,
> +				clear_err.bb_len) == 0) {
> +		rc = -EINVAL;
> +		error("Badblocks region input out of range.\n");
> +		goto cleanup;
> +	}
> +
> +	start = base + clear_err.bb_start * 512;
> +	len = clear_err.bb_len * 512;
> +
> +	rc = get_ars_cap(ce->bus, start, len);
> +	if (rc) {
> +		fprintf(stderr, "get_ars_cap failed\n");
> +		goto cleanup;
> +	}
> +
> +	rc = send_clear_error(ce->bus, start, len);
> +	if (rc) {
> +		fprintf(stderr, "send_clear_error failed\n");
> +		goto cleanup;
> +	}
> +
> +	rc = 0;
> +
> +cleanup:
> +	ndctl_unref(ce->ctx);
> +	return rc;
> +}
> +
> +int cmd_clear_error(int argc, const char **argv, void *ctx)
> +{
> +	int i, rc;
> +	const char * const u[] = {
> +		"ndctl clear-error [<options>]",
> +		NULL
> +	};
> +	const struct option options[] = {
> +		OPT_STRING('f', "file", &clear_err.dev_name, "device-name",
> +			"device/file name to be operated on"),
> +		OPT_U64('s', "start", &clear_err.bb_start,
> +				"badblock start"),
> +		OPT_UINTEGER('l', "len", &clear_err.bb_len, "badblock length"),
> +		OPT_END(),
> +	};
> +
> +	/*
> +	 * Set default len to 1. when no option is passed, 1
> +	 * block is cleared.
> +	 */
> +	clear_err.bb_len = 1;
> +	argc = parse_options(argc, argv, options, u, 0);
> +
> +	for (i = 0; i < argc; i++)
> +		error("Unknown parameter \"%s\"\n", argv[i]);
> +
> +	if (argc)
> +		usage_with_options(u, options);
> +
> +	if (!clear_err.dev_name) {
> +		error("Missing device/file name passed in\n");
> +		usage_with_options(u, options);
> +		return -EINVAL;
> +	}
> +
> +	if (clear_err.bb_len == 0) {
> +		error("Clearing with 0 length, failed.\n");
> +		return -EINVAL;
> +	}
> +
> +	rc = clear_error(&clear_err);
> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ac1fc63..4663680 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -229,6 +229,8 @@ struct ndctl_region {
>  		int state;
>  		unsigned long long cookie;
>  	} iset;
> +	FILE *badblocks;
> +	struct badblock bb;
>  };
>  
>  /**
> @@ -1867,6 +1869,74 @@ NDCTL_EXPORT struct ndctl_dimm *ndctl_region_get_next_dimm(struct ndctl_region *
>  	return NULL;
>  }
>  
> +static int regions_badblocks_init(struct ndctl_region *region)
> +{
> +	struct ndctl_ctx *ctx = ndctl_region_get_ctx(region);
> +	char *bb_path;
> +	int rc = 0;
> +
> +	/* if the file is already opened */

s/opened/open/

> +	if (region->badblocks) {
> +		fclose(region->badblocks);
> +		region->badblocks = NULL;
> +	}
> +
> +	if (asprintf(&bb_path, "%s/badblocks",
> +				region->region_path) < 0) {
> +		rc = -errno;
> +		err(ctx, "region badblocks path allocation failure\n");
> +		return rc;
> +	}
> +
> +	region->badblocks = fopen(bb_path, "r");
> +	if (!region->badblocks) {
> +		rc = -errno;
> +		err(ctx, "region badblocks fopen failed\n");
> +		return -rc;
> +	}
> +
> +	free(bb_path);
> +	return rc;
> +}
> +
> +NDCTL_EXPORT struct badblock *ndctl_region_get_next_badblock(struct ndctl_region *region)
> +{
> +	int rc;
> +	char *buf = NULL;
> +	size_t rlen = 0;
> +
> +	if (!region->badblocks)
> +		return NULL;
> +
> +	rc = getline(&buf, &rlen, region->badblocks);
> +	if (rc == -1)
> +		return NULL;

>From the man page:
	If *lineptr is set to NULL and *n is set 0 before the call, then
	getline() will allocate a buffer for storing the line. This
	buffer should be freed by the user program even if getline()
	failed.
So you should have a free in the error case.

> +
> +	rc = sscanf(buf, "%llu %u", &region->bb.offset, &region->bb.len);
> +	free(buf);
> +	if (rc == EOF) {
> +		/* end of the road, clean up */
> +		fclose(region->badblocks);
> +		region->badblocks = NULL;
> +		region->bb.offset = 0;
> +		region->bb.len = 0;
> +		return NULL;
> +	}

I think the EOF condition here will never be reached? getline() itself
will return -1 on EOF.

Also, we should check for rc to be exactly '2' to make sure exactly two
items were matched. If the badblocks 'page' in the kernel runs out of
space, the sysfs file can be abruptly truncated with just a sector
number, but no length. In this case, it is probably best to entirely
ignore that entry.

> +
> +	return &region->bb;
> +}
> +
> +NDCTL_EXPORT struct badblock *ndctl_region_get_first_badblock(struct ndctl_region *region)
> +{
> +	int rc;
> +
> +	rc = regions_badblocks_init(region);
> +	if (rc < 0)
> +		return NULL;
> +
> +	return ndctl_region_get_next_badblock(region);
> +}
> +
>  static struct nd_cmd_vendor_tail *to_vendor_tail(struct ndctl_cmd *cmd)
>  {
>  	struct nd_cmd_vendor_tail *tail = (struct nd_cmd_vendor_tail *)
> diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
> index b5a085c..a1b5baf 100644
> --- a/ndctl/lib/libndctl.sym
> +++ b/ndctl/lib/libndctl.sym
> @@ -116,6 +116,8 @@ global:
>  	ndctl_dimm_get_available_labels;
>  	ndctl_region_get_first;
>  	ndctl_region_get_next;
> +	ndctl_region_get_first_badblock;
> +	ndctl_region_get_next_badblock;
>  	ndctl_region_get_id;
>  	ndctl_region_get_devname;
>  	ndctl_region_get_interleave_ways;
> diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
> index 6ee8a35..2c45d2d 100644
> --- a/ndctl/libndctl.h.in
> +++ b/ndctl/libndctl.h.in
> @@ -372,6 +372,10 @@ int ndctl_cmd_get_status(struct ndctl_cmd *cmd);
>  unsigned int ndctl_cmd_get_firmware_status(struct ndctl_cmd *cmd);
>  int ndctl_cmd_submit(struct ndctl_cmd *cmd);
>  
> +struct badblock {
> +	unsigned long long offset;
> +	unsigned int len;
> +};
>  struct ndctl_region;
>  struct ndctl_region *ndctl_region_get_first(struct ndctl_bus *bus);
>  struct ndctl_region *ndctl_region_get_next(struct ndctl_region *region);
> @@ -379,6 +383,12 @@ struct ndctl_region *ndctl_region_get_next(struct ndctl_region *region);
>          for (region = ndctl_region_get_first(bus); \
>               region != NULL; \
>               region = ndctl_region_get_next(region))
> +struct badblock *ndctl_region_get_first_badblock(struct ndctl_region *region);
> +struct badblock *ndctl_region_get_next_badblock(struct ndctl_region *region);
> +#define ndctl_region_badblock_foreach(region, badblock) \
> +        for (badblock = ndctl_region_get_first_badblock(region); \
> +             badblock != NULL; \
> +             badblock = ndctl_region_get_next_badblock(region))
>  unsigned int ndctl_region_get_id(struct ndctl_region *region);
>  const char *ndctl_region_get_devname(struct ndctl_region *region);
>  unsigned int ndctl_region_get_interleave_ways(struct ndctl_region *region);
> diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
> index 4b08c9b..8aff623 100644
> --- a/ndctl/ndctl.c
> +++ b/ndctl/ndctl.c
> @@ -29,7 +29,8 @@ static int cmd_help(int argc, const char **argv, void *ctx)
>  {
>  	const char * const builtin_help_subcommands[] = {
>  		"enable-region", "disable-region", "zero-labels",
> -		"enable-namespace", "disable-namespace", NULL };
> +		"enable-namespace", "disable-namespace",
> +		"clear-error", NULL };
>  	struct option builtin_help_options[] = {
>  		OPT_END(),
>  	};
> @@ -67,6 +68,7 @@ static struct cmd_struct commands[] = {
>  	{ "write-labels", cmd_write_labels },
>  	{ "init-labels", cmd_init_labels },
>  	{ "check-labels", cmd_check_labels },
> +	{ "clear-error", cmd_clear_error },
>  	{ "list", cmd_list },
>  	{ "help", cmd_help },
>  	#ifdef ENABLE_TEST
> diff --git a/test/Makefile.am b/test/Makefile.am
> index 9353a34..3cd159e 100644
> --- a/test/Makefile.am
> +++ b/test/Makefile.am
> @@ -10,6 +10,7 @@ TESTS =\
>  	clear.sh \
>  	dax-errors.sh \
>  	daxdev-errors.sh \
> +	ndctl-clear-error-dax.sh \
>  	btt-check.sh \
>  	label-compat.sh \
>  	blk-exhaust.sh
> diff --git a/test/ndctl-clear-error-dax.sh b/test/ndctl-clear-error-dax.sh
> new file mode 100755
> index 0000000..646b601
> --- /dev/null
> +++ b/test/ndctl-clear-error-dax.sh
> @@ -0,0 +1,68 @@
> +#!/bin/bash -x
> +DEV=""
> +NDCTL="../ndctl/ndctl"
> +BUS="-b nfit_test.0"
> +BUS1="-b nfit_test.1"
> +json2var="s/[{}\",]//g; s/:/=/g"
> +rc=77
> +
> +check_min_kver()
> +{
> +	local ver="$1"
> +	: "${KVER:=$(uname -r)}"
> +
> +	[ -n "$ver" ] || return 1
> +	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
> +}
> +
> +check_min_kver "4.12" || { echo "kernel $KVER lacks dax dev error handling"; exit $rc; }
> +
> +set -e
> +
> +err() {
> +	echo "test/clear: failed at line $1"
> +	exit $rc
> +}
> +
> +set -e
> +trap 'err $LINENO' ERR
> +
> +# setup (reset nfit_test dimms)
> +modprobe nfit_test
> +$NDCTL disable-region $BUS all
> +$NDCTL zero-labels $BUS all
> +$NDCTL enable-region $BUS all
> +
> +rc=1
> +
> +query=". | sort_by(.available_size) | reverse | .[0].dev"
> +region=$($NDCTL list $BUS -t pmem -Ri | jq -r "$query")
> +
> +# create dax
> +chardev="x"
> +json=$($NDCTL create-namespace $BUS -r $region -t pmem -m dax -a 4096)
> +chardev=$(echo $json | jq -r ". | select(.mode == \"dax\") | .daxregion.devices[0].chardev")
> +[ $chardev = "x" ] && echo "fail: $LINENO" && exit 1
> +
> +json1=$($NDCTL list $BUS)
> +eval $(echo $json1 | sed -e "$json2var")

minor nit, but useless-use-of-echo :)
	eval $(sed -e "$json2var" <<< "$json1")
should do the same thing

> +
> +read sector len < /sys/bus/platform/devices/nfit_test.0/$dev/$region/badblocks
> +echo "sector: $sector len: $len"
> +
> +# clearing using ndctl
> +$NDCTL clear-error -f /dev/$chardev -s $sector -l $len
> +
> +# check badblocks, should be empty
> +if read sector len < /sys/bus/platform/devices/nfit_test.0/$dev/$region/badblocks; then
> +	[ -n "$sector" ] && echo "fail: $LINENO" && exit 1
> +else
> +	echo "badblocks empty, expected"
> +fi
> +
> +
> +$NDCTL disable-region $BUS all
> +$NDCTL disable-region $BUS1 all
> +modprobe -r nfit_test
> +
> +exit 0
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
