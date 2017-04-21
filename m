Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23F0A2195406F
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 17:08:06 -0700 (PDT)
Date: Thu, 20 Apr 2017 18:06:44 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl: add clear error support for ndctl
Message-ID: <20170421000644.GB10645@omniknight.lm.intel.com>
References: <149246870330.39964.18236077747861521230.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149246870330.39964.18236077747861521230.stgit@djiang5-desk3.ch.intel.com>
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

On 04/17, Dave Jiang wrote:
> Adding ndctl support that will allow clearing of bad blocks for a device.
> Initial implementation will only support device dax devices. The ndctl
> takes a device path and parameters of the starting bad block, and the number
> of bad blocks to clear.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  test/Makefile.am              |    1 +
>  test/ndctl-clear-error-dax.sh |   78 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 79 insertions(+)
>  create mode 100755 test/ndctl-clear-error-dax.sh

The diffstat seems to be truncated?
The patch mostly looks fine, a few comments below.
Generally, do you think it is worth checking if what we're about to
clear is actually in the badblocks list?
Do we want to allow sending an arbitrary clear-error to a location that
may not actually be bad?

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
> index 0000000..89a5013
> --- /dev/null
> +++ b/Documentation/ndctl-clear-error.txt
> @@ -0,0 +1,37 @@
> +ndctl-clear-error(1)
> +====================
> +
> +NAME
> +----
> +ndctl-clear-error - clear poison for a device

I think generally everywhere, we should use 'badblocks' instead of
poison. Poison implies cache line granularity, and we only expose
badblocks to users. This patch uses 'errors', 'poison', and 'badblocks'
to refer to the same thing -- I think we can keep the command name
'clear-error', and use 'badblock(s)' everywhere else.

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

Instead of using the -f and file path selection for the dax node, can we
use the namespaceX.Y notation like other ndctl commands? Or is there
some other complication with dax namespaces that prevents that..

> +
> +-s::
> +--start::
> +	The offset where the poison (bad block) starts for this device.
> +	Typically this is acquired from the sysfs badblocks file.
> +
> +-l::
> +--len::
> +	The number of badblocks to clear in size of 512 bytes increments.

Just a thought - perhaps len could default to '1'. That way, if only -s
is provided, that one block will get cleared.

> +
> +
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
> index 0000000..52a2304
> --- /dev/null
> +++ b/ndctl/clear-error.c
> @@ -0,0 +1,212 @@
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
> +#include <util/parse-options.h>
> +#include <util/log.h>
> +#include <ndctl/libndctl.h>
> +#include <ndctl.h>
> +
> +struct clear_err {
> +	const char *dev_name;
> +	u64 bb_start;
> +	u64 bb_len;
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
> +		fprintf(stderr, "%s: bus: %s failed to create cmd\n",
> +				__func__, ndctl_bus_get_provider(bus));
> +		return -ENXIO;
> +	}
> +
> +	rc = ndctl_cmd_submit(clear_err.clear_err);
> +	if (rc) {
> +		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
> +				__func__, ndctl_bus_get_provider(bus), rc);
> +		ndctl_cmd_unref(clear_err.clear_err);
> +		return rc;
> +	}
> +
> +	cleared = ndctl_cmd_clear_error_get_cleared(clear_err.clear_err);
> +	if (cleared != size) {
> +		fprintf(stderr, "%s: bus: %s expected to clear: %ld actual: %ld\
> +n",
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
> +		fprintf(stderr, "%s: bus: %s failed to create cmd\n",
> +				__func__, ndctl_bus_get_provider(bus));
> +		return -ENOTTY;
> +	}
> +
> +	rc = ndctl_cmd_submit(clear_err.ars_cap);
> +	if (rc) {
> +		fprintf(stderr, "%s: bus: %s failed to submit cmd: %d\n",
> +				__func__, ndctl_bus_get_provider(bus), rc);
> +		ndctl_cmd_unref(clear_err.ars_cap);
> +		return rc;
> +	}
> +
> +	if (ndctl_cmd_ars_cap_get_size(clear_err.ars_cap) <
> +			sizeof(struct nd_cmd_ars_status)){
> +		fprintf(stderr, "%s: bus: %s expected size >= %zd got: %d\n",
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
> +
> +	return -ENODEV;
> +}
> +
> +static int clear_error(struct clear_err *ce)
> +{
> +	struct stat stats;
> +	int rc;
> +	char dev_name[256];
> +	uint64_t base;
> +	u64 start, len;
> +
> +	strncpy(dev_name, ce->dev_name, 256);
> +
> +	rc = stat(dev_name, &stats);
> +	if (rc < 0) {
> +		perror("stat failed");
> +		fprintf(stderr, "Unable to verify %s\n", dev_name);

'verify' seems ambiguous, perhaps just use stat? cp complains with stat
failed, for example..
If we can use namespaceX.Y then maybe this is redundant anyway.

> +		return -1;
> +	}
> +
> +	if (!S_ISCHR(stats.st_mode)) {
> +		fprintf(stderr, "%s not DAX device\n", dev_name);
> +		return -1;
> +	}
> +
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
> +		fprintf(stderr, "get_ars_cap failed\n");

copy/paste eror? s/get_ars_cap/send_clear_error/

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
> +		OPT_U64('l', "len", &clear_err.bb_len, "badblock length"),
> +		OPT_END(),
> +	};
> +
> +	argc = parse_options(argc, argv, options, u, 0);
> +
> +	for (i = 0; i < argc; i++)
> +		error("unknown parameter \"%s\"\n", argv[i]);
> +
> +	if (argc)
> +		usage_with_options(u, options);
> +
> +	if (!clear_err.dev_name) {
> +		error("missing device/file name passed in\n");
> +		usage_with_options(u, options);
> +		return -EINVAL;
> +	}
> +
> +	if (clear_err.bb_len == 0) {
> +		error("bad blocks length not set\n");
> +		usage_with_options(u, options);
> +		return -EINVAL;
> +	}
> +
> +	rc = clear_error(&clear_err);
> +	if (rc)
> +		return rc;
> +
> +	return 0;
> +}
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
> index 0000000..2b0aca5
> --- /dev/null
> +++ b/test/ndctl-clear-error-dax.sh
> @@ -0,0 +1,78 @@
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
> +check_min_kver()
> +{
> +	local ver="$1"
> +	: "${KVER:=$(uname -r)}"
> +
> +	[ -n "$ver" ] || return 1
> +	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
> +}

defined twice?

> +
> +check_min_kver "4.6" || { echo "kernel $KVER lacks clear poison support"; exit $rc; }

4.12 implies 4.6, so this can be skipped, right?

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
> +
> +read sector len < /sys/bus/platform/devices/nfit_test.0/$dev/$region/badblocks
> +echo "sector: $sector len: $len"
> +
> +# clearing using ndctl
> +$NDCTL clear-error -f /dev/$chardev -s $sector -l $len
> +
> +# check badblocks, should be empty
> +if read sector len < /sys/bus/platform/devices/nfit_test.0/$dev/$region/badblocks; then
> +	echo "badblocks empty, expected"
> +fi

Is this test right?
If the badblocks file is empty, the read will fail, and the 'if' will
not trigger. Seems like you want the reverse.

> +[ -n "$sector" ] && echo "fail: $LINENO" && exit 1
> +
> +
> +$NDCTL disable-region $BUS all
> +$NDCTL disable-region $BUS1 all
> +modprobe -r nfit_test
> +
> +exit 0
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
