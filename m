Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B079422568612
 for <linux-nvdimm@lists.01.org>; Thu,  8 Mar 2018 16:04:05 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3 2/2] ndctl: merge firmware-update to dimm.c as one of
 the dimm ops
Date: Fri, 9 Mar 2018 00:10:07 +0000
Message-ID: <1520554205.6316.55.camel@intel.com>
References: <152037991431.39785.10704524597897615503.stgit@djiang5-desk3.ch.intel.com>
 <152037998114.39785.6202884508699614720.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <152037998114.39785.6202884508699614720.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <947A08E9E4BDF44EA69E166B55F5BAE3@intel.com>
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


On Tue, 2018-03-06 at 16:46 -0700, Dave Jiang wrote:
> Since update-firmware replicate a lot of the parsing code that dimm.c
> already uses, moving update-firmware to dimm.c and utilize the
> already
> working functionalities.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/Makefile.am       |    1 
>  ndctl/dimm.c            |  466
> +++++++++++++++++++++++++++++++++++++++
>  ndctl/firmware-update.h |   45 ++++
>  ndctl/update.c          |  558 -----------------------------------
> ------------
>  4 files changed, 509 insertions(+), 561 deletions(-)
>  create mode 100644 ndctl/firmware-update.h
>  delete mode 100644 ndctl/update.c

I think this patch is missing the man pages update. Remove the -d or --
dimm from it, and also somehow the longer description of the options
have been dropped (See the OPTIONS section in other man pages), so
perhaps add that back while at it (of course only -f needed anymore).

Also since the command now accepts BASE_OPTIONS, (--bus and --verbose), 
lets add those to the man page as well.

> 
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index e0db97ba..213cabd7 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -15,7 +15,6 @@ ndctl_SOURCES = ndctl.c \
>  		util/json-smart.c \
>  		util/json-firmware.c \
>  		inject-error.c \
> -		update.c \
>  		inject-smart.c
>  
>  if ENABLE_DESTRUCTIVE
> diff --git a/ndctl/dimm.c b/ndctl/dimm.c
> index 7259506f..0638ec53 100644
> --- a/ndctl/dimm.c
> +++ b/ndctl/dimm.c
> @@ -13,6 +13,8 @@
>  #include <stdio.h>
>  #include <errno.h>
>  #include <stdlib.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
>  #include <unistd.h>
>  #include <limits.h>
>  #include <syslog.h>
> @@ -28,12 +30,14 @@
>  #include <util/parse-options.h>
>  #include <ccan/minmax/minmax.h>
>  #include <ccan/array_size/array_size.h>
> +#include <ndctl/firmware-update.h>
>  
>  struct action_context {
>  	struct json_object *jdimms;
>  	enum ndctl_namespace_version labelversion;
>  	FILE *f_out;
>  	FILE *f_in;
> +	struct update_context update;
>  };
>  
>  static int action_disable(struct ndctl_dimm *dimm, struct
> action_context *actx)
> @@ -371,6 +375,440 @@ static int action_read(struct ndctl_dimm *dimm,
> struct action_context *actx)
>  	return rc;
>  }
>  
> +static int update_verify_input(struct action_context *actx)
> +{
> +	int rc;
> +	struct stat st;
> +
> +	rc = fstat(fileno(actx->f_in), &st);
> +	if (rc == -1) {
> +		rc = -errno;
> +		fprintf(stderr, "fstat failed: %s\n",
> strerror(errno));
> +		return rc;
> +	}
> +
> +	if (!S_ISREG(st.st_mode)) {
> +		fprintf(stderr, "Input not a regular file.\n");
> +		return -EINVAL;
> +	}
> +
> +	if (st.st_size == 0) {
> +		fprintf(stderr, "Input file size is 0.\n");
> +		return -EINVAL;
> +	}
> +
> +	actx->update.fw_size = st.st_size;
> +	return 0;
> +}
> +
> +static int verify_fw_size(struct update_context *uctx)
> +{
> +	struct fw_info *fw = &uctx->dimm_fw;
> +
> +	if (uctx->fw_size > fw->store_size) {
> +		error("Firmware file size greater than DIMM
> store\n");
> +		return -ENOSPC;
> +	}
> +
> +	return 0;
> +}
> +
> +static int submit_get_firmware_info(struct ndctl_dimm *dimm,
> +		struct action_context *actx)
> +{
> +	struct update_context *uctx = &actx->update;
> +	struct fw_info *fw = &uctx->dimm_fw;
> +	struct ndctl_cmd *cmd;
> +	int rc;
> +	enum ND_FW_STATUS status;
> +
> +	cmd = ndctl_dimm_cmd_new_fw_get_info(dimm);
> +	if (!cmd)
> +		return -ENXIO;
> +
> +	rc = ndctl_cmd_submit(cmd);
> +	if (rc < 0)
> +		return rc;
> +
> +	status = ndctl_cmd_fw_xlat_firmware_status(cmd);
> +	if (status != FW_SUCCESS) {
> +		fprintf(stderr, "GET FIRMWARE INFO on DIMM %s
> failed: %#x\n",
> +				ndctl_dimm_get_devname(dimm),
> status);
> +		return -ENXIO;
> +	}
> +
> +	fw->store_size = ndctl_cmd_fw_info_get_storage_size(cmd);
> +	if (fw->store_size == UINT_MAX)
> +		return -ENXIO;
> +
> +	fw->update_size = ndctl_cmd_fw_info_get_max_send_len(cmd);
> +	if (fw->update_size == UINT_MAX)
> +		return -ENXIO;
> +
> +	fw->query_interval =
> ndctl_cmd_fw_info_get_query_interval(cmd);
> +	if (fw->query_interval == UINT_MAX)
> +		return -ENXIO;
> +
> +	fw->max_query = ndctl_cmd_fw_info_get_max_query_time(cmd);
> +	if (fw->max_query == UINT_MAX)
> +		return -ENXIO;
> +
> +	fw->run_version = ndctl_cmd_fw_info_get_run_version(cmd);
> +	if (fw->run_version == ULLONG_MAX)
> +		return -ENXIO;
> +
> +	rc = verify_fw_size(uctx);
> +	ndctl_cmd_unref(cmd);
> +	return rc;
> +}
> +
> +static int submit_start_firmware_upload(struct ndctl_dimm *dimm,
> +		struct action_context *actx)
> +{
> +	struct update_context *uctx = &actx->update;
> +	struct fw_info *fw = &uctx->dimm_fw;
> +	struct ndctl_cmd *cmd;
> +	int rc;
> +	enum ND_FW_STATUS status;
> +
> +	cmd = ndctl_dimm_cmd_new_fw_start_update(dimm);
> +	if (!cmd)
> +		return -ENXIO;
> +
> +	rc = ndctl_cmd_submit(cmd);
> +	if (rc < 0)
> +		return rc;
> +
> +	status = ndctl_cmd_fw_xlat_firmware_status(cmd);
> +	if (status != FW_SUCCESS) {
> +		fprintf(stderr, "START FIRMWARE UPDATE on DIMM %s
> failed: %#x\n",
> +				ndctl_dimm_get_devname(dimm),
> status);
> +		if (status == FW_EBUSY)
> +			fprintf(stderr, "Another firmware upload in
> progress or finished.\n");

Line >80 char, should be an easy fix without breaking up the string..
There are a few other instances of this.

> +		return -ENXIO;
> +	}
> +
> +	fw->context = ndctl_cmd_fw_start_get_context(cmd);
> +	if (fw->context == UINT_MAX) {
> +		fprintf(stderr, "Retrieved firmware context invalid
> on DIMM %s\n",
> +				ndctl_dimm_get_devname(dimm));
> +		return -ENXIO;
> +	}
> +
> +	uctx->start = cmd;
> +
> +	return 0;
> +}
> +
> +static int get_fw_data_from_file(FILE *file, void *buf, uint32_t
> len)
> +{
> +	size_t rc;
> +
> +	rc = fread(buf, len, 1, file);
> +	if (rc != 1) {
> +		if (feof(file))
> +			fprintf(stderr, "Firmware file shorter than
> expected\n");
> +		else if (ferror(file))
> +			fprintf(stderr, "Firmware file read
> error\n");
> +		return -EBADF;
> +	}
> +
> +	return len;
> +}
> +
> +static int send_firmware(struct ndctl_dimm *dimm,
> +		struct action_context *actx)
> +{
> +	struct update_context *uctx = &actx->update;
> +	struct fw_info *fw = &uctx->dimm_fw;
> +	struct ndctl_cmd *cmd = NULL;
> +	ssize_t read;
> +	int rc = -ENXIO;
> +	enum ND_FW_STATUS status;
> +	uint32_t copied = 0, len, remain;
> +	void *buf;
> +
> +	buf = malloc(fw->update_size);
> +	if (!buf)
> +		return -ENOMEM;
> +
> +	remain = uctx->fw_size;
> +
> +	while (remain) {
> +		len = min(fw->update_size, remain);
> +		read = get_fw_data_from_file(actx->f_in, buf, len);
> +		if (read < 0) {
> +			rc = read;
> +			goto cleanup;
> +		}
> +
> +		cmd = ndctl_dimm_cmd_new_fw_send(uctx->start,
> copied, read,
> +				buf);
> +		if (!cmd) {
> +			rc = -ENXIO;
> +			goto cleanup;
> +		}
> +
> +		rc = ndctl_cmd_submit(cmd);
> +		if (rc < 0)
> +			goto cleanup;
> +
> +		status = ndctl_cmd_fw_xlat_firmware_status(cmd);
> +		if (status != FW_SUCCESS) {
> +			error("SEND FIRMWARE failed: %#x\n",
> status);
> +			rc = -ENXIO;
> +			goto cleanup;
> +		}
> +
> +		copied += read;
> +		remain -= read;
> +
> +		ndctl_cmd_unref(cmd);
> +		cmd = NULL;
> +	}
> +
> +cleanup:
> +	ndctl_cmd_unref(cmd);
> +	free(buf);
> +	return rc;
> +}
> +
> +static int submit_finish_firmware(struct ndctl_dimm *dimm,
> +		struct action_context *actx)
> +{
> +	struct update_context *uctx = &actx->update;
> +	struct ndctl_cmd *cmd;
> +	int rc;
> +	enum ND_FW_STATUS status;
> +
> +	cmd = ndctl_dimm_cmd_new_fw_finish(uctx->start);
> +	if (!cmd)
> +		return -ENXIO;
> +
> +	rc = ndctl_cmd_submit(cmd);
> +	if (rc < 0)
> +		goto out;
> +
> +	status = ndctl_cmd_fw_xlat_firmware_status(cmd);
> +	if (status != FW_SUCCESS) {
> +		fprintf(stderr, "FINISH FIRMWARE UPDATE on DIMM %s
> failed: %#x\n",
> +				ndctl_dimm_get_devname(dimm),
> status);
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +out:
> +	ndctl_cmd_unref(cmd);
> +	return rc;
> +}
> +
> +static int submit_abort_firmware(struct ndctl_dimm *dimm,
> +		struct action_context *actx)
> +{
> +	struct update_context *uctx = &actx->update;
> +	struct ndctl_cmd *cmd;
> +	int rc;
> +	enum ND_FW_STATUS status;
> +
> +	cmd = ndctl_dimm_cmd_new_fw_abort(uctx->start);
> +	if (!cmd)
> +		return -ENXIO;
> +
> +	rc = ndctl_cmd_submit(cmd);
> +	if (rc < 0)
> +		goto out;
> +
> +	status = ndctl_cmd_fw_xlat_firmware_status(cmd);
> +	if (!(status & ND_CMD_STATUS_FIN_ABORTED)) {
> +		fprintf(stderr, "Firmware update abort on DIMM %s
> failed: %#x\n",
> +				ndctl_dimm_get_devname(dimm),
> status);
> +		rc = -ENXIO;
> +		goto out;
> +	}
> +
> +out:
> +	ndctl_cmd_unref(cmd);
> +	return rc;
> +}
> +
> +static int query_fw_finish_status(struct ndctl_dimm *dimm,
> +		struct action_context *actx)
> +{
> +	struct update_context *uctx = &actx->update;
> +	struct fw_info *fw = &uctx->dimm_fw;
> +	struct ndctl_cmd *cmd;
> +	int rc;
> +	enum ND_FW_STATUS status;
> +	bool done = false;
> +	struct timespec now, before, after;
> +	uint64_t ver;
> +
> +	cmd = ndctl_dimm_cmd_new_fw_finish_query(uctx->start);
> +	if (!cmd)
> +		return -ENXIO;
> +
> +	rc = clock_gettime(CLOCK_MONOTONIC, &before);
> +	if (rc < 0)
> +		goto out;
> +
> +	now.tv_nsec = fw->query_interval / 1000;
> +	now.tv_sec = 0;
> +
> +	do {
> +		rc = ndctl_cmd_submit(cmd);
> +		if (rc < 0)
> +			break;
> +
> +		status = ndctl_cmd_fw_xlat_firmware_status(cmd);
> +		switch (status) {
> +		case FW_SUCCESS:
> +			ver = ndctl_cmd_fw_fquery_get_fw_rev(cmd);
> +			if (ver == 0) {
> +				fprintf(stderr, "No firmware
> updated.\n");
> +				rc = -ENXIO;
> +				goto out;
> +			}
> +
> +			printf("Image updated successfully to DIMM
> %s.\n",
> +					ndctl_dimm_get_devname(dimm)
> );
> +			printf("Firmware version %#lx.\n", ver);
> +			printf("Cold reboot to activate.\n");
> +			done = true;
> +			rc = 0;
> +			break;
> +		case FW_EBUSY:
> +			/* Still on going, continue */
> +			rc = clock_gettime(CLOCK_MONOTONIC, &after);
> +			if (rc < 0) {
> +				rc = -errno;
> +				goto out;
> +			}
> +
> +			/*
> +			 * If we expire max query time,
> +			 * we timed out
> +			 */
> +			if (after.tv_sec - before.tv_sec >
> +					fw->max_query / 1000000) {
> +				rc = -ETIMEDOUT;
> +				goto out;
> +			}
> +
> +			/*
> +			 * Sleep the interval dictated by firmware
> +			 * before query again.
> +			 */
> +			rc = nanosleep(&now, NULL);
> +			if (rc < 0) {
> +				rc = -errno;
> +				goto out;
> +			}
> +			break;
> +		case FW_EBADFW:
> +			fprintf(stderr, "Firmware failed to verify
> by DIMM %s.\n",
> +					ndctl_dimm_get_devname(dimm)
> );
> +		case FW_EINVAL_CTX:
> +		case FW_ESEQUENCE:
> +			done = true;
> +			rc = -ENXIO;
> +			goto out;
> +		case FW_ENORES:
> +			fprintf(stderr, "Firmware update sequence
> timed out: %s\n",
> +					ndctl_dimm_get_devname(dimm)
> );
> +			rc = -ETIMEDOUT;
> +			done = true;
> +			goto out;
> +		default:
> +			fprintf(stderr, "Unknown update status: %#x
> on DIMM %s\n", 

Trailing whitespace warning here:
.git/rebase-apply/patch:398: trailing whitespace.
			fprintf(stderr, "Unknown update status: %#x on
DIMM %s\n", 
warning: 1 line adds whitespace errors.

> +					status,
> ndctl_dimm_get_devname(dimm));
> +			rc = -EINVAL;
> +			done = true;
> +			goto out;
> +		}
> +	} while (!done);
> +
> +out:
> +	ndctl_cmd_unref(cmd);
> +	return rc;
> +}
> +
> +static int update_firmware(struct ndctl_dimm *dimm,
> +		struct action_context *actx)
> +{
> +	int rc;
> +
> +	rc = submit_get_firmware_info(dimm, actx);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = submit_start_firmware_upload(dimm, actx);
> +	if (rc < 0)
> +		return rc;
> +
> +	printf("Uploading firmware to DIMM %s.\n",
> +			ndctl_dimm_get_devname(dimm));

This can be a future cleanup, but all of dimm.c (not just fw update
parts) has a mix of util/util.h error() style statements, fprintfs, and
 printfs. I think we should clean this up to use the util/log.h style
logging facilities, and that will work well with --verbose flags. Right
now some of the other dimm_action logging is done via this, but afaics,
the verbosity has no effect on any of the update fw logging.

> +
> +	rc = send_firmware(dimm, actx);
> +	if (rc < 0) {
> +		fprintf(stderr, "Firmware send failed.
> Aborting!\n");
> +		rc = submit_abort_firmware(dimm, actx);
> +		if (rc < 0)
> +			fprintf(stderr, "Aborting update sequence
> failed.\n");
> +		return rc;
> +	}
> +
> +	/*
> +	 * Done reading file, reset firmware file back to beginning
> for
> +	 * next update.
> +	 */
> +	rewind(actx->f_in);
> +
> +	rc = submit_finish_firmware(dimm, actx);
> +	if (rc < 0) {
> +		fprintf(stderr, "Unable to end update sequence.\n");
> +		rc = submit_abort_firmware(dimm, actx);
> +		if (rc < 0)
> +			fprintf(stderr, "Aborting update sequence
> failed.\n");
> +		return rc;
> +	}
> +
> +	rc = query_fw_finish_status(dimm, actx);
> +	if (rc < 0)
> +		return rc;
> +
> +	return 0;
> +}
> +
> +static int action_update(struct ndctl_dimm *dimm, struct
> action_context *actx)
> +{
> +	int rc;
> +
> +	rc = ndctl_dimm_fw_update_supported(dimm);
> +	switch (rc) {
> +	case -ENOTTY:
> +		error("DIMM firmware update not supported by
> ndctl.");
> +		return rc;
> +	case -EOPNOTSUPP:
> +		error("DIMM firmware update not supported by the
> kernel");
> +		return rc;
> +	case -EIO:
> +		error("DIMM firmware update not supported by either
> platform firmware or the kernel.");
> +		return rc;
> +	}
> +
> +	rc = update_verify_input(actx);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = update_firmware(dimm, actx);
> +	if (rc < 0)
> +		return rc;
> +
> +	ndctl_cmd_unref(actx->update.start);
> +
> +	return rc;
> +}
> +
>  static struct parameters {
>  	const char *bus;
>  	const char *outfile;
> @@ -462,6 +900,10 @@ OPT_BOOLEAN('j', "json", &param.json, "parse
> label data into json")
>  OPT_STRING('i', "input", &param.infile, "input-file", \
>  	"filename to read label area data")
>  
> +#define UPDATE_OPTIONS() \
> +OPT_STRING('f', "firmware", &param.infile, "firmware-file", \
> +	"firmware filename for update")
> +
>  #define INIT_OPTIONS() \
>  OPT_BOOLEAN('f', "force", &param.force, \
>  		"force initialization even if existing index-block
> present"), \
> @@ -480,6 +922,12 @@ static const struct option write_options[] = {
>  	OPT_END(),
>  };
>  
> +static const struct option update_options[] = {
> +	BASE_OPTIONS(),
> +	UPDATE_OPTIONS(),
> +	OPT_END(),
> +};
> +
>  static const struct option base_options[] = {
>  	BASE_OPTIONS(),
>  	OPT_END(),
> @@ -545,9 +993,13 @@ static int dimm_action(int argc, const char
> **argv, void *ctx,
>  		}
>  	}
>  
> -	if (!param.infile)
> +	if (!param.infile) {
> +		if (action == action_update) {
> +			usage_with_options(u, options);
> +			return -EINVAL;
> +		}
>  		actx.f_in = stdin;
> -	else {
> +	} else {
>  		actx.f_in = fopen(param.infile, "r");
>  		if (!actx.f_in) {
>  			fprintf(stderr, "failed to open: %s:
> (%s)\n",
> @@ -707,3 +1159,13 @@ int cmd_enable_dimm(int argc, const char
> **argv, void *ctx)
>  			count > 1 ? "s" : "");
>  	return count >= 0 ? 0 : EXIT_FAILURE;
>  }
> +
> +int cmd_update_firmware(int argc, const char **argv, void *ctx)
> +{
> +	int count = dimm_action(argc, argv, ctx, action_update,
> update_options,
> +			"ndctl update-firmware <nmem0>
> [<nmem1>..<nmemN>] [<options>]");
> +
> +	fprintf(stderr, "updated %d nmem%s.\n", count >= 0 ? count :
> 0,
> +			count > 1 ? "s" : "");
> +	return count >= 0 ? 0 : EXIT_FAILURE;
> +}
> diff --git a/ndctl/firmware-update.h b/ndctl/firmware-update.h
> new file mode 100644
> index 00000000..a7576889
> --- /dev/null
> +++ b/ndctl/firmware-update.h
> @@ -0,0 +1,45 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2018 Intel Corporation. All rights reserved. */
> +
> +#ifndef _FIRMWARE_UPDATE_H_
> +#define _FIRMWARE_UPDATE_H_
> +
> +#define ND_CMD_STATUS_SUCCESS	0
> +#define ND_CMD_STATUS_NOTSUPP	1
> +#define	ND_CMD_STATUS_NOTEXIST	2
> +#define ND_CMD_STATUS_INVALPARM	3
> +#define ND_CMD_STATUS_HWERR	4
> +#define ND_CMD_STATUS_RETRY	5
> +#define ND_CMD_STATUS_UNKNOWN	6
> +#define ND_CMD_STATUS_EXTEND	7
> +#define ND_CMD_STATUS_NORES	8
> +#define ND_CMD_STATUS_NOTREADY	9
> +
> +/* extended status through ND_CMD_STATUS_EXTEND */
> +#define ND_CMD_STATUS_START_BUSY	0x10000
> +#define ND_CMD_STATUS_SEND_CTXINVAL	0x10000
> +#define ND_CMD_STATUS_FIN_CTXINVAL	0x10000
> +#define ND_CMD_STATUS_FIN_DONE		0x20000
> +#define ND_CMD_STATUS_FIN_BAD		0x30000
> +#define ND_CMD_STATUS_FIN_ABORTED	0x40000
> +#define ND_CMD_STATUS_FQ_CTXINVAL	0x10000
> +#define ND_CMD_STATUS_FQ_BUSY		0x20000
> +#define ND_CMD_STATUS_FQ_BAD		0x30000
> +#define ND_CMD_STATUS_FQ_ORDER		0x40000
> +
> +struct fw_info {
> +	uint32_t store_size;
> +	uint32_t update_size;
> +	uint32_t query_interval;
> +	uint32_t max_query;
> +	uint64_t run_version;
> +	uint32_t context;
> +};
> +
> +struct update_context {
> +	size_t fw_size;
> +	struct fw_info dimm_fw;
> +	struct ndctl_cmd *start;
> +};
> +
> +#endif
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
