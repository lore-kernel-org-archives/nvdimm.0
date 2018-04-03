Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 71A5E226C7C2E
 for <linux-nvdimm@lists.01.org>; Tue,  3 Apr 2018 08:29:58 -0700 (PDT)
Subject: Re: [PATCH 5/6] nfit, address-range-scrub: rework and simplify ARS
 state machine
References: <152273076087.38372.4803377088477706610.stgit@dwillia2-desk3.amr.corp.intel.com>
 <152273078779.38372.13062348829183334140.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <f4c0ca57-3c4a-9805-a66a-6a61aec2b108@intel.com>
Date: Tue, 3 Apr 2018 08:29:54 -0700
MIME-Version: 1.0
In-Reply-To: <152273078779.38372.13062348829183334140.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>


On 4/2/2018 9:46 PM, Dan Williams wrote:
> ARS is an operation that can take 10s to 100s of seconds to find media
> errors that should rarely be present. If the platform crashes due to
> media errors in persistent memory, the expectation is that the BIOS will
> report those known errors in a 'short' ARS request.
>
> A 'short' ARS request asks platform firmware to return an ARS payload
> with all known errors, but without issuing a 'long' scrub. At driver
> init a short request is issued to all PMEM ranges before registering
> regions. Then, in the background, a long ARS is scheduled for each
> region.
>
> The ARS implementation is simplified to centralize ARS completion work
> in the ars_complete() helper called from ars_status_process_records().
> The timeout is removed since there is no facility to cancel ARS, and
> system init is never blocked waiting for a 'long' ARS. The ars_state
> flags are used to coordinate ARS requests from driver init, ARS requests
> from userspace, and ARS requests in response to media error
> notifications.
>
> Given that there is no notification of ARS completion the implementation
> still needs to poll, but now it backs off exponentially to a maximum
> poll period of 30 minutes.
>
> Suggested-by: Toshi Kani <toshi.kani@hpe.com>
> Co-developed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>   drivers/acpi/nfit/core.c |  415 +++++++++++++++++++---------------------------
>   drivers/acpi/nfit/nfit.h |    4
>   2 files changed, 174 insertions(+), 245 deletions(-)
>
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 9ba60f58d929..29a033f3455d 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -35,16 +35,6 @@ static bool force_enable_dimms;
>   module_param(force_enable_dimms, bool, S_IRUGO|S_IWUSR);
>   MODULE_PARM_DESC(force_enable_dimms, "Ignore _STA (ACPI DIMM device) status");
>   
> -static unsigned int scrub_timeout = NFIT_ARS_TIMEOUT;
> -module_param(scrub_timeout, uint, S_IRUGO|S_IWUSR);
> -MODULE_PARM_DESC(scrub_timeout, "Initial scrub timeout in seconds");
> -
> -/* after three payloads of overflow, it's dead jim */
> -static unsigned int scrub_overflow_abort = 3;
> -module_param(scrub_overflow_abort, uint, S_IRUGO|S_IWUSR);
> -MODULE_PARM_DESC(scrub_overflow_abort,
> -		"Number of times we overflow ARS results before abort");
> -
>   static bool disable_vendor_specific;
>   module_param(disable_vendor_specific, bool, S_IRUGO);
>   MODULE_PARM_DESC(disable_vendor_specific,
> @@ -1251,7 +1241,7 @@ static ssize_t scrub_show(struct device *dev,
>   
>   		mutex_lock(&acpi_desc->init_mutex);
>   		rc = sprintf(buf, "%d%s", acpi_desc->scrub_count,
> -				work_busy(&acpi_desc->work)
> +				work_busy(&acpi_desc->dwork.work)
>   				&& !acpi_desc->cancel ? "+\n" : "\n");
>   		mutex_unlock(&acpi_desc->init_mutex);
>   	}
> @@ -2452,7 +2442,8 @@ static int ars_start(struct acpi_nfit_desc *acpi_desc, struct nfit_spa *nfit_spa
>   	memset(&ars_start, 0, sizeof(ars_start));
>   	ars_start.address = spa->address;
>   	ars_start.length = spa->length;
> -	ars_start.flags = acpi_desc->ars_start_flags;
> +	if (test_bit(ARS_SHORT, &nfit_spa->ars_state))
> +		ars_start.flags = ND_ARS_RETURN_PREV_DATA;
>   	if (nfit_spa_type(spa) == NFIT_SPA_PM)
>   		ars_start.type = ND_ARS_PERSISTENT;
>   	else if (nfit_spa_type(spa) == NFIT_SPA_VOLATILE)
> @@ -2500,9 +2491,56 @@ static int ars_get_status(struct acpi_nfit_desc *acpi_desc)
>   	return cmd_rc;
>   }
>   
> +static void ars_complete(struct acpi_nfit_desc *acpi_desc,
> +		struct nfit_spa *nfit_spa)
> +{
> +	struct nd_cmd_ars_status *ars_status = acpi_desc->ars_status;
> +	struct acpi_nfit_system_address *spa = nfit_spa->spa;
> +	struct nd_region *nd_region = nfit_spa->nd_region;
> +	struct device *dev;
> +
> +	if ((ars_status->address >= spa->address && ars_status->address
> +				< spa->address + spa->length)
> +			|| (ars_status->address < spa->address)) {
> +		/*
> +		 * Assume that if a scrub starts at an offset from the
> +		 * start of nfit_spa that we are in the continuation
> +		 * case.
> +		 *
> +		 * Otherwise, if the scrub covers the spa range, mark
> +		 * any pending request complete.
> +		 */
> +		if (ars_status->address + ars_status->length
> +				>= spa->address + spa->length)
> +				/* complete */;
> +		else
> +			return;
> +	} else
> +		return;
> +
> +	if (test_bit(ARS_DONE, &nfit_spa->ars_state))
> +		return;
> +
> +	if (!test_and_clear_bit(ARS_REQ, &nfit_spa->ars_state))
> +		return;
> +
> +	if (nd_region) {
> +		dev = nd_region_dev(nd_region);
> +		nvdimm_region_notify(nd_region, NVDIMM_REVALIDATE_POISON);
> +	} else
> +		dev = acpi_desc->dev;
> +
> +	dev_dbg(dev, "ARS: range %d %s complete\n", spa->range_index,
> +			test_bit(ARS_SHORT, &nfit_spa->ars_state)
> +			? "short" : "long");
> +	clear_bit(ARS_SHORT, &nfit_spa->ars_state);
> +	set_bit(ARS_DONE, &nfit_spa->ars_state);
> +}
> +
>   static int ars_status_process_records(struct acpi_nfit_desc *acpi_desc,
> -		struct nd_cmd_ars_status *ars_status)
> +		struct nfit_spa *nfit_spa)
>   {
> +	struct nd_cmd_ars_status *ars_status = acpi_desc->ars_status;
>   	struct nvdimm_bus *nvdimm_bus = acpi_desc->nvdimm_bus;
>   	int rc;
>   	u32 i;
> @@ -2513,6 +2551,9 @@ static int ars_status_process_records(struct acpi_nfit_desc *acpi_desc,
>   	 */
>   	if (ars_status->out_length < 44)
>   		return 0;
> +
> +	ars_complete(acpi_desc, nfit_spa);
> +
>   	for (i = 0; i < ars_status->num_records; i++) {
>   		/* only process full records */
>   		if (ars_status->out_length
> @@ -2792,229 +2833,117 @@ static int acpi_nfit_query_poison(struct acpi_nfit_desc *acpi_desc,
>   	if (rc < 0 && rc != -ENOSPC)
>   		return rc;
>   
> -	if (ars_status_process_records(acpi_desc, acpi_desc->ars_status))
> +	if (ars_status_process_records(acpi_desc, nfit_spa))
>   		return -ENOMEM;
>   
>   	return 0;
>   }
>   
> -static void acpi_nfit_async_scrub(struct acpi_nfit_desc *acpi_desc,
> -		struct nfit_spa *nfit_spa)
> +static int init_ars(struct acpi_nfit_desc *acpi_desc, struct nfit_spa *nfit_spa,
> +		int query_rc)
>   {
> -	struct acpi_nfit_system_address *spa = nfit_spa->spa;
> -	unsigned int overflow_retry = scrub_overflow_abort;
> -	u64 init_ars_start = 0, init_ars_len = 0;
> -	struct device *dev = acpi_desc->dev;
> -	unsigned int tmo = scrub_timeout;
>   	int rc;
>   
> -	if (!test_bit(ARS_REQ, &nfit_spa->ars_state) || !nfit_spa->nd_region)
> -		return;
> +	switch (query_rc) {
> +	case 0:
> +		/* ARS is idle, lets look for critical known errors... */
> +		break;
> +	case -EBUSY:
> +		/*
> +		 * ARS is already running, some agent thought it was ok
> +		 * to busy ARS before handing off to the nfit driver.
> +		 */
> +		clear_bit(ARS_SHORT, &nfit_spa->ars_state);
> +		rc = query_rc;
> +		goto out;
> +	case -ENOSPC:
> +		/* ARS continuation needed... */
> +		clear_bit(ARS_SHORT, &nfit_spa->ars_state);
> +		rc = query_rc;
> +		goto out;
> +	default:
> +		rc = query_rc;
> +		goto out;
> +	}
>   
> +	WARN_ON_ONCE(!test_bit(ARS_SHORT, &nfit_spa->ars_state));
>   	rc = ars_start(acpi_desc, nfit_spa);
> -	/*
> -	 * If we timed out the initial scan we'll still be busy here,
> -	 * and will wait another timeout before giving up permanently.
> -	 */
> -	if (rc < 0 && rc != -EBUSY)
> -		return;
> -
> -	do {
> -		u64 ars_start, ars_len;
> -
> -		if (acpi_desc->cancel)
> -			break;
> +	if (rc == 0)
>   		rc = acpi_nfit_query_poison(acpi_desc, nfit_spa);
> -		if (rc == -ENOTTY)
> -			break;
> -		if (rc == -EBUSY && !tmo) {
> -			dev_warn(dev, "range %d ars timeout, aborting\n",
> -					spa->range_index);
> -			break;
> -		}
> -
> -		if (rc == -EBUSY) {
> -			/*
> -			 * Note, entries may be appended to the list
> -			 * while the lock is dropped, but the workqueue
> -			 * being active prevents entries being deleted /
> -			 * freed.
> -			 */
> -			mutex_unlock(&acpi_desc->init_mutex);
> -			ssleep(1);
> -			tmo--;
> -			mutex_lock(&acpi_desc->init_mutex);
> -			continue;
> -		}
> -
> -		/* we got some results, but there are more pending... */
> -		if (rc == -ENOSPC && overflow_retry--) {
> -			if (!init_ars_len) {
> -				init_ars_len = acpi_desc->ars_status->length;
> -				init_ars_start = acpi_desc->ars_status->address;
> -			}
> -			rc = ars_continue(acpi_desc);
> -		}
> -
> -		if (rc < 0) {
> -			dev_warn(dev, "range %d ars continuation failed\n",
> -					spa->range_index);
> -			break;
> -		}
> -
> -		if (init_ars_len) {
> -			ars_start = init_ars_start;
> -			ars_len = init_ars_len;
> -		} else {
> -			ars_start = acpi_desc->ars_status->address;
> -			ars_len = acpi_desc->ars_status->length;
> -		}
> -		dev_dbg(dev, "spa range: %d ars from %#llx + %#llx complete\n",
> -				spa->range_index, ars_start, ars_len);
> -		/* notify the region about new poison entries */
> -		nvdimm_region_notify(nfit_spa->nd_region,
> -				NVDIMM_REVALIDATE_POISON);
> -		break;
> -	} while (1);
> +out:
> +	if (acpi_nfit_register_region(acpi_desc, nfit_spa))
> +		set_bit(ARS_FAILED, &nfit_spa->ars_state);
> +	return rc;
>   }
>   
>   static void acpi_nfit_scrub(struct work_struct *work)
>   {
> -	struct device *dev;
> -	u64 init_scrub_length = 0;
>   	struct nfit_spa *nfit_spa;
> -	u64 init_scrub_address = 0;
> -	bool init_ars_done = false;
>   	struct acpi_nfit_desc *acpi_desc;
> -	unsigned int tmo = scrub_timeout;
> -	unsigned int overflow_retry = scrub_overflow_abort;
>   
> -	acpi_desc = container_of(work, typeof(*acpi_desc), work);
> -	dev = acpi_desc->dev;
> -
> -	/*
> -	 * We scrub in 2 phases.  The first phase waits for any platform
> -	 * firmware initiated scrubs to complete and then we go search for the
> -	 * affected spa regions to mark them scanned.  In the second phase we
> -	 * initiate a directed scrub for every range that was not scrubbed in
> -	 * phase 1. If we're called for a 'rescan', we harmlessly pass through
> -	 * the first phase, but really only care about running phase 2, where
> -	 * regions can be notified of new poison.
> -	 */
> -
> -	/* process platform firmware initiated scrubs */
> - retry:
> +	acpi_desc = container_of(work, typeof(*acpi_desc), dwork.work);
>   	mutex_lock(&acpi_desc->init_mutex);
>   	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
> -		struct nd_cmd_ars_status *ars_status;
> -		struct acpi_nfit_system_address *spa;
> -		u64 ars_start, ars_len;
> -		int rc;
> +		struct acpi_nfit_system_address *spa = nfit_spa->spa;
> +		int rc, ridx = spa->range_index;
> +		int type = nfit_spa_type(spa);
> +		struct device *dev;
>   
>   		if (acpi_desc->cancel)
> -			break;
> -
> -		if (nfit_spa->nd_region)
> +			goto out;
> +		if (type != NFIT_SPA_PM && type != NFIT_SPA_VOLATILE)
>   			continue;
> -
> -		if (init_ars_done) {
> -			/*
> -			 * No need to re-query, we're now just
> -			 * reconciling all the ranges covered by the
> -			 * initial scrub
> -			 */
> -			rc = 0;
> -		} else
> -			rc = acpi_nfit_query_poison(acpi_desc, nfit_spa);
> -
> -		if (rc == -ENOTTY) {
> -			/* no ars capability, just register spa and move on */
> -			acpi_nfit_register_region(acpi_desc, nfit_spa);
> +		if (test_bit(ARS_FAILED, &nfit_spa->ars_state))
>   			continue;
> -		}
> -
> -		if (rc == -EBUSY && !tmo) {
> -			/* fallthrough to directed scrub in phase 2 */
> -			dev_warn(dev, "timeout awaiting ars results, continuing...\n");
> -			break;
> -		} else if (rc == -EBUSY) {
> -			mutex_unlock(&acpi_desc->init_mutex);
> -			ssleep(1);
> -			tmo--;
> -			goto retry;
> -		}
>   
> -		/* we got some results, but there are more pending... */
> -		if (rc == -ENOSPC && overflow_retry--) {
> -			ars_status = acpi_desc->ars_status;
> -			/*
> -			 * Record the original scrub range, so that we
> -			 * can recall all the ranges impacted by the
> -			 * initial scrub.
> -			 */
> -			if (!init_scrub_length) {
> -				init_scrub_length = ars_status->length;
> -				init_scrub_address = ars_status->address;
> +		rc = acpi_nfit_query_poison(acpi_desc, nfit_spa);
> +		if (!nfit_spa->nd_region)
> +			rc = init_ars(acpi_desc, nfit_spa, rc);
> +
> +		dev = nd_region_dev(nfit_spa->nd_region);
> +		if (!dev)
> +			dev = acpi_desc->dev;
> +
> +		switch (rc) {
> +		case -EBUSY:
> +busy:
> +			dev_dbg(dev, "ARS: range %d ARS busy\n", ridx);
> +			queue_delayed_work(nfit_wq, &acpi_desc->dwork,
> +					acpi_desc->scrub_tmo * HZ);
> +			acpi_desc->scrub_tmo = min(30U * 60U,
> +					acpi_desc->scrub_tmo * 2);
> +			goto out;
> +		case 0:
> +			if (test_bit(ARS_REQ, &nfit_spa->ars_state)) {
> +				acpi_desc->scrub_tmo = 1;
> +				rc = ars_start(acpi_desc, nfit_spa);
> +				clear_bit(ARS_DONE, &nfit_spa->ars_state);
> +				dev_dbg(dev, "ARS: range %d ARS start (%d)\n",
> +						spa->range_index, rc);
> +				if (rc == 0 || rc == -EBUSY)
> +					goto busy;
> +				goto fail;
>   			}
> +			break;
> +		case -ENOSPC:
> +			acpi_desc->scrub_tmo = 1;
>   			rc = ars_continue(acpi_desc);
> -			if (rc == 0) {
> -				mutex_unlock(&acpi_desc->init_mutex);
> -				goto retry;
> -			}
> -		}
> -
> -		if (rc < 0) {
> -			/*
> -			 * Initial scrub failed, we'll give it one more
> -			 * try below...
> -			 */
> +			clear_bit(ARS_DONE, &nfit_spa->ars_state);
> +			if (rc == -EBUSY || rc == 0)
> +				goto busy;
> +			/* fall through */
> +		default:
> +fail:
> +			dev_dbg(dev, "ARS: range %d failed (%d)\n", ridx, rc);
> +			set_bit(ARS_FAILED, &nfit_spa->ars_state);
>   			break;
>   		}
> -
> -		/* We got some final results, record completed ranges */
> -		ars_status = acpi_desc->ars_status;
> -		if (init_scrub_length) {
> -			ars_start = init_scrub_address;
> -			ars_len = ars_start + init_scrub_length;
> -		} else {
> -			ars_start = ars_status->address;
> -			ars_len = ars_status->length;
> -		}
> -		spa = nfit_spa->spa;
> -
> -		if (!init_ars_done) {
> -			init_ars_done = true;
> -			dev_dbg(dev, "init scrub %#llx + %#llx complete\n",
> -					ars_start, ars_len);
> -		}
> -		if (ars_start <= spa->address && ars_start + ars_len
> -				>= spa->address + spa->length)
> -			acpi_nfit_register_region(acpi_desc, nfit_spa);
>   	}
>   
> -	/*
> -	 * For all the ranges not covered by an initial scrub we still
> -	 * want to see if there are errors, but it's ok to discover them
> -	 * asynchronously.
> -	 */
> -	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
> -		/*
> -		 * Flag all the ranges that still need scrubbing, but
> -		 * register them now to make data available.
> -		 */
> -		if (!nfit_spa->nd_region) {
> -			set_bit(ARS_REQ, &nfit_spa->ars_state);
> -			acpi_nfit_register_region(acpi_desc, nfit_spa);
> -		}
> -	}
> -	acpi_desc->init_complete = 1;
> -
> -	list_for_each_entry(nfit_spa, &acpi_desc->spas, list)
> -		acpi_nfit_async_scrub(acpi_desc, nfit_spa);
>   	acpi_desc->scrub_count++;
> -	acpi_desc->ars_start_flags = 0;
>   	if (acpi_desc->scrub_count_state)
>   		sysfs_notify_dirent(acpi_desc->scrub_count_state);
> +out:
>   	mutex_unlock(&acpi_desc->init_mutex);
>   }
>   
> @@ -3026,8 +2955,11 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
>   		int rc, type = nfit_spa_type(nfit_spa->spa);
>   
>   		/* PMEM and VMEM will be registered by the ARS workqueue */
> -		if (type == NFIT_SPA_PM || type == NFIT_SPA_VOLATILE)
> +		if (type == NFIT_SPA_PM || type == NFIT_SPA_VOLATILE) {
> +			set_bit(ARS_REQ, &nfit_spa->ars_state);
> +			set_bit(ARS_SHORT, &nfit_spa->ars_state);
>   			continue;
> +		}
>   		/* BLK apertures belong to BLK region registration below */
>   		if (type == NFIT_SPA_BDW)
>   			continue;
> @@ -3037,9 +2969,7 @@ static int acpi_nfit_register_regions(struct acpi_nfit_desc *acpi_desc)
>   			return rc;
>   	}
>   
> -	acpi_desc->ars_start_flags = 0;
> -	if (!acpi_desc->cancel)
> -		queue_work(nfit_wq, &acpi_desc->work);
> +	queue_delayed_work(nfit_wq, &acpi_desc->dwork, 0);
>   	return 0;
>   }
>   
> @@ -3174,49 +3104,34 @@ int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
>   }
>   EXPORT_SYMBOL_GPL(acpi_nfit_init);
>   
> -struct acpi_nfit_flush_work {
> -	struct work_struct work;
> -	struct completion cmp;
> -};
> -
>   static void flush_probe(struct work_struct *work)
>   {
> -	struct acpi_nfit_flush_work *flush;
> -
> -	flush = container_of(work, typeof(*flush), work);
> -	complete(&flush->cmp);
>   }
>   
>   static int acpi_nfit_flush_probe(struct nvdimm_bus_descriptor *nd_desc)
>   {
>   	struct acpi_nfit_desc *acpi_desc = to_acpi_nfit_desc(nd_desc);
>   	struct device *dev = acpi_desc->dev;
> -	struct acpi_nfit_flush_work flush;
> -	int rc;
> +	struct work_struct flush;
> +
>   
> -	/* bounce the device lock to flush acpi_nfit_add / acpi_nfit_notify */
> +	/* Bounce the device lock to flush acpi_nfit_add / acpi_nfit_notify */
>   	device_lock(dev);
>   	device_unlock(dev);
>   
> -	/* bounce the init_mutex to make init_complete valid */
> +	/* Bounce the init_mutex to ensure initial scrub work is queued */
>   	mutex_lock(&acpi_desc->init_mutex);
> -	if (acpi_desc->cancel || acpi_desc->init_complete) {
> -		mutex_unlock(&acpi_desc->init_mutex);
> -		return 0;
> -	}
> +	mutex_unlock(&acpi_desc->init_mutex);
>   
>   	/*
> -	 * Scrub work could take 10s of seconds, userspace may give up so we
> -	 * need to be interruptible while waiting.
> +	 * Queue one work in the stream and flush to ensure initial
> +	 * registration work is complete.
>   	 */
> -	INIT_WORK_ONSTACK(&flush.work, flush_probe);
> -	init_completion(&flush.cmp);
> -	queue_work(nfit_wq, &flush.work);
> -	mutex_unlock(&acpi_desc->init_mutex);
> +	INIT_WORK_ONSTACK(&flush, flush_probe);
> +	queue_work(nfit_wq, &flush);
> +	flush_work(&flush);
>   
> -	rc = wait_for_completion_interruptible(&flush.cmp);
> -	cancel_work_sync(&flush.work);
> -	return rc;
> +	return 0;
>   }
>   
>   static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
> @@ -3235,7 +3150,7 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
>   	 * just needs guarantees that any ars it initiates are not
>   	 * interrupted by any intervening start reqeusts from userspace.
>   	 */
> -	if (work_busy(&acpi_desc->work))
> +	if (work_busy(&acpi_desc->dwork.work))
>   		return -EBUSY;
>   
>   	return 0;
> @@ -3244,11 +3159,9 @@ static int acpi_nfit_clear_to_send(struct nvdimm_bus_descriptor *nd_desc,
>   int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc, u8 flags)
>   {
>   	struct device *dev = acpi_desc->dev;
> +	int scheduled = 0, busy = 0;
>   	struct nfit_spa *nfit_spa;
>   
> -	if (work_busy(&acpi_desc->work))
> -		return -EBUSY;
> -
>   	mutex_lock(&acpi_desc->init_mutex);
>   	if (acpi_desc->cancel) {
>   		mutex_unlock(&acpi_desc->init_mutex);
> @@ -3258,17 +3171,31 @@ int acpi_nfit_ars_rescan(struct acpi_nfit_desc *acpi_desc, u8 flags)
>   	list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
>   		struct acpi_nfit_system_address *spa = nfit_spa->spa;
>   
> -		if (nfit_spa_type(spa) != NFIT_SPA_PM)
> +		if (nfit_spa_type(spa) == NFIT_SPA_DCR)
>   			continue;
>   
> -		set_bit(ARS_REQ, &nfit_spa->ars_state);
> +		if (test_bit(ARS_FAILED, &nfit_spa->ars_state))
> +			continue;
> +
> +		if (test_and_set_bit(ARS_REQ, &nfit_spa->ars_state))
> +			busy++;
> +		else {
> +			if (flags == ND_ARS_RETURN_PREV_DATA)

if (flags & ND_ARS_RETURN_PREV_DATA)?

I think the spec allows other bits set in the flag byte.


> +				set_bit(ARS_SHORT, &nfit_spa->ars_state);
> +			scheduled++;
> +		}
> +	}
> +	if (scheduled) {
> +		queue_delayed_work(nfit_wq, &acpi_desc->dwork, 0);
> +		dev_dbg(dev, "ars_scan triggered\n");
>   	}
> -	acpi_desc->ars_start_flags = flags;
> -	queue_work(nfit_wq, &acpi_desc->work);
> -	dev_dbg(dev, "ars_scan triggered\n");
>   	mutex_unlock(&acpi_desc->init_mutex);
>   
> -	return 0;
> +	if (scheduled)
> +		return 0;
> +	if (busy)
> +		return -EBUSY;
> +	return -ENOTTY;
>   }
>   
>   void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
> @@ -3295,7 +3222,8 @@ void acpi_nfit_desc_init(struct acpi_nfit_desc *acpi_desc, struct device *dev)
>   	INIT_LIST_HEAD(&acpi_desc->dimms);
>   	INIT_LIST_HEAD(&acpi_desc->list);
>   	mutex_init(&acpi_desc->init_mutex);
> -	INIT_WORK(&acpi_desc->work, acpi_nfit_scrub);
> +	acpi_desc->scrub_tmo = 1;
> +	INIT_DELAYED_WORK(&acpi_desc->dwork, acpi_nfit_scrub);
>   }
>   EXPORT_SYMBOL_GPL(acpi_nfit_desc_init);
>   
> @@ -3319,6 +3247,7 @@ void acpi_nfit_shutdown(void *data)
>   
>   	mutex_lock(&acpi_desc->init_mutex);
>   	acpi_desc->cancel = 1;
> +	cancel_delayed_work_sync(&acpi_desc->dwork);
>   	mutex_unlock(&acpi_desc->init_mutex);
>   
>   	/*
> diff --git a/drivers/acpi/nfit/nfit.h b/drivers/acpi/nfit/nfit.h
> index efb6c6bcde42..7b2e074ac39a 100644
> --- a/drivers/acpi/nfit/nfit.h
> +++ b/drivers/acpi/nfit/nfit.h
> @@ -198,17 +198,17 @@ struct acpi_nfit_desc {
>   	u8 ars_start_flags;
>   	struct nd_cmd_ars_status *ars_status;
>   	size_t ars_status_size;
> -	struct work_struct work;
> +	struct delayed_work dwork;
>   	struct list_head list;
>   	struct kernfs_node *scrub_count_state;
>   	unsigned int scrub_count;
>   	unsigned int scrub_mode;
>   	unsigned int cancel:1;
> -	unsigned int init_complete:1;
>   	unsigned long dimm_cmd_force_en;
>   	unsigned long bus_cmd_force_en;
>   	unsigned long bus_nfit_cmd_force_en;
>   	unsigned int platform_cap;
> +	unsigned int scrub_tmo;
>   	int (*blk_do_io)(struct nd_blk_region *ndbr, resource_size_t dpa,
>   			void *iobuf, u64 len, int rw);
>   };
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
