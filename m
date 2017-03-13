Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-CY1-obe.outbound.protection.outlook.com
 (mail-cys01nam02on070c.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe45::70c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DCB3E803A5
 for <linux-nvdimm@lists.01.org>; Mon, 13 Mar 2017 16:26:38 -0700 (PDT)
Subject: Re: [ndctl PATCH v3 6/7] ndctl: add a BTT check utility
References: <20170304061307.13530-1-vishal.l.verma@intel.com>
 <20170304061307.13530-7-vishal.l.verma@intel.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <58C72AA6.1020700@hpe.com>
Date: Mon, 13 Mar 2017 19:26:30 -0400
MIME-Version: 1.0
In-Reply-To: <20170304061307.13530-7-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Vishal,

Thanks for all your work on this.  I finally got a chance to do some
testing and have a few usability suggestions for you to consider.

On 03/04/2017 01:13 AM, Vishal Verma wrote:
<snip>
> +int namespace_check(struct ndctl_namespace *ndns, struct check_opts *opts)
> +{
> +	const char *devname = ndctl_namespace_get_devname(ndns);
> +	int raw_mode, rc, disabled_flag = 0, open_flags;
> +	struct btt_sb *btt_sb;
> +	struct btt_chk *bttc;
> +	char path[50];
> +
> +	bttc = calloc(1, sizeof(*bttc));
> +	if (bttc == NULL)
> +		return -ENOMEM;
> +
> +	log_init(&bttc->ctx, devname, "NDCTL_CHECK_NAMESPACE");
> +	if (opts->verbose)
> +		bttc->ctx.log_priority = LOG_DEBUG;
> +
> +	bttc->opts = opts;
> +	bttc->start_off = BTT_START_OFFSET;
> +	bttc->sys_page_size = sysconf(_SC_PAGESIZE);
> +	bttc->rawsize = ndctl_namespace_get_size(ndns);
> +	ndctl_namespace_get_uuid(ndns, bttc->parent_uuid);
> +
> +	info(bttc, "checking %s\n", devname);
> +	if (ndctl_namespace_is_active(ndns)) {
> +		if (opts->force) {
> +			rc = ndctl_namespace_disable_safe(ndns);
> +			if (rc)
> +				return rc;
> +			disabled_flag = 1;
> +		} else {
> +			err(bttc, "%s: check aborted, namespace online\n",
> +				devname);
> +			rc = -EBUSY;
> +			goto out_bttc;
> +		}
> +	}
> +
> +	/* In typical usage, the current raw_mode should be false. */
> +	raw_mode = ndctl_namespace_get_raw_mode(ndns);
> +
> +	/*
> +	 * Putting the namespace into raw mode will allow us to access
> +	 * the btt metadata.
> +	 */
> +	rc = ndctl_namespace_set_raw_mode(ndns, 1);
> +	if (rc < 0) {
> +		err(bttc, "%s: failed to set the raw mode flag: %d\n",
> +			devname, rc);
> +		goto out_ns;
> +	}

When I ran the utility as non-root, I got this:
$ ndctl check-namespace namespace3.0
namespace3.0: namespace_check: namespace3.0: failed to set the raw mode flag: -6
error checking namespaces: No such device or address

I think it ought to end with Permission denied, which it would do if
ndctl_namespace_get_raw_mode() returned with -errno rather than a hard
coded ENXIO.

If that's main reason that setting the raw mode flag can fail, then the
err() could be an info().  That would simplify the output.

> +	/*
> +	 * Now enable the namespace.  This will result in a pmem device
> +	 * node showing up in /dev that is in raw mode.
> +	 */
> +	rc = ndctl_namespace_enable(ndns);
> +	if (rc != 0) {
> +		err(bttc, "%s: failed to enable in raw mode: %d\n",
> +			devname, rc);
> +		goto out_ns;
> +	}
> +
> +	sprintf(path, "/dev/%s", ndctl_namespace_get_block_device(ndns));
> +	bttc->path = path;
> +
> +	btt_sb = malloc(sizeof(*btt_sb));
> +	if (btt_sb == NULL) {
> +		rc = -ENOMEM;
> +		goto out_ns;
> +	}
> +
> +	if (!bttc->opts->repair)
> +		open_flags = O_RDONLY|O_EXCL;
> +	else
> +		open_flags = O_RDWR|O_EXCL;
> +
> +	bttc->fd = open(bttc->path, open_flags);
> +	if (bttc->fd < 0) {
> +		err(bttc, "unable to open %s: %s\n",
> +			bttc->path, strerror(errno));
> +		rc = -errno;
> +		goto out_sb;
> +	}
> +
> +	rc = btt_info_read_verify(bttc, btt_sb, bttc->start_off);
> +	if (rc) {
> +		rc = btt_recover_first_sb(bttc);
> +		if (rc) {
> +			info(bttc, "Unable to recover any BTT info blocks\n");
> +			goto out_close;

When I ran this on a namespace that never had a BTT, I thought I'd get a error
basically saying that I'm screwed, but instead I got:

$ sudo ndctl check-namespace namespace1.0
error checking namespaces: No such device or address

It seems like the info() above is rather important and should be an err().
For a checker, maybe verbose should be the default anyway.

> +		}
> +		rc = btt_info_read_verify(bttc, btt_sb, bttc->start_off);
> +		if (rc)
> +			goto out_close;
> +	}
> +	rc = btt_discover_arenas(bttc);
> +	if (rc)
> +		goto out_close;
> +
> +	rc = btt_create_mappings(bttc);
> +	if (rc)
> +		goto out_close;
> +
> +	rc = btt_check_arenas(bttc);
> +
> +	btt_remove_mappings(bttc);
> + out_close:
> +	close(bttc->fd);
> + out_sb:
> +	free(btt_sb);
> + out_ns:
> +	ndctl_namespace_set_raw_mode(ndns, raw_mode);
> +	ndctl_namespace_disable_invalidate(ndns);
> +	if (disabled_flag)
> +		if(ndctl_namespace_enable(ndns) < 0)
> +			info(bttc, "%s: failed to re-enable namespace\n",
> +				devname);

I didn't get this error but it seems rather important too.

Thanks,

- ljk

> + out_bttc:
> +	free(bttc);
> +	return rc;
> +}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
