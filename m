Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B881C3A75A8
	for <nvdimm@lists.linux.dev>; Fri, 29 May 2026 22:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780095544; cv=none; b=QCyocVo2RCGNm+JzJub82V3fbRLc48jjn2mKPfoJPReQR3c/YP2zWKVIluNqTEMiF2g8guhd1kKV/EVE9h+XnnvVuyN71ZbngJsNt/Ps+ZP+JJp0KmJq9g65vatxCyopGCLsJERQrHOU/O4wzkdjny6c0SqtxZRgC6/M0esRWL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780095544; c=relaxed/simple;
	bh=QArrFfpQqV2mPabNPPlN6Hi15ax7EUWXH16RpEUYzo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EvAfZbV6g0z9ygWNwjHSVG8qzXAhIBl0i4IXpBViNh3qjmEyhcc4hfj3q1gv+qUP6LKuIimLHWzBUPX8ZppOPN7FlMvRUjKq3gOearSYK+J8Z4Cy27PPf3DSN6QqKvyDRx5d3RRuYnCnfxoTC7WzhRGSYyl8t33fl9ZYE/jKcYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NUo/HDTh; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NUo/HDTh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780095542; x=1811631542;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QArrFfpQqV2mPabNPPlN6Hi15ax7EUWXH16RpEUYzo8=;
  b=NUo/HDThsnuGGAAlKEFBvreGy61U+NMcXiq/0hrCn4qjBLH5qgmOq763
   PuNY3FIYMVRYpc1cBcSAcc0vTpXIwlidbNwakzcH9n0LHgpuFkLKaEtiT
   x9q443l2U+kbZGniOBqEWohQcaWw9QXmsOkLJTmmWrac9co6xPGtBYAUB
   6jy70vc4uFrSeZOT0bG5INUiOxAR069kDMeoaXAeKpKYm+iUM2ficXbv0
   wkyux+mwJ0q77ykM6BkMFoM+ofcdnVB01DNZNr+E+2iknuuhA1zcY4J9q
   GuuHPyY+MLIkgE+zUBCZ6zE5C3oJZmUbbuh64nn2X2YIAtFEPoDSbrPLm
   g==;
X-CSE-ConnectionGUID: ljE/nJdSRLCIIS4otNhDcw==
X-CSE-MsgGUID: G3TbGF1PTGSaBikf+Zm8fQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="84580595"
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="84580595"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 15:59:02 -0700
X-CSE-ConnectionGUID: qppaGMeGRFKmUuqidNTjvA==
X-CSE-MsgGUID: rbgvuPVRRJ2Oe6dyBvlTVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="266609608"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.111.151]) ([10.125.111.151])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 15:58:59 -0700
Message-ID: <70c4f06b-557a-4239-9326-8646b85315a7@intel.com>
Date: Fri, 29 May 2026 15:58:58 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 29/31] tools/testing/cxl: Make event logs dynamic
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, John Groves
 <John@Groves.net>, Gregory Price <gourry@gourry.net>,
 Ira Weiny <ira.weiny@intel.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <41c47ec44202b7a2491f89752247d8968758e213.1779528761.git.anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <41c47ec44202b7a2491f89752247d8968758e213.1779528761.git.anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:43 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> The event logs test was created as static arrays as an easy way to mock
> events.  Dynamic Capacity Device (DCD) test support requires events be
> generated dynamically when extents are created or destroyed.
> 
> The current event log test has specific checks for the number of events
> seen including log overflow.
> 
> Modify mock event logs to be dynamically allocated.  Adjust array size
> and mock event entry data to match the output expected by the existing
> event test.
> 
> Use the static event data to create the dynamic events in the new logs
> without inventing complex event injection for the previous tests.
> 
> Simplify log processing by using the event log array index as the
> handle.  Add a lock to manage concurrency required when user space is
> allowed to control DCD extents
> 
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  tools/testing/cxl/test/mem.c | 265 +++++++++++++++++++++--------------
>  1 file changed, 161 insertions(+), 104 deletions(-)
> 
> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index 271c7ad8cc32..fe1dadddd18e 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c
> @@ -142,18 +142,26 @@ static struct {
>  
>  #define PASS_TRY_LIMIT 3
>  
> -#define CXL_TEST_EVENT_CNT_MAX 15
> +#define CXL_TEST_EVENT_CNT_MAX 16
> +/* 1 extra slot to accommodate that handles can't be 0 */
> +#define CXL_TEST_EVENT_ARRAY_SIZE (CXL_TEST_EVENT_CNT_MAX + 1)
>  
>  /* Set a number of events to return at a time for simulation.  */
>  #define CXL_TEST_EVENT_RET_MAX 4
>  
> +/*
> + * @last_handle: last handle (index) to have an entry stored
> + * @current_handle: current handle (index) to be returned to the user on get_event
> + * @nr_overflow: number of events added past the log size
> + * @lock: protect these state variables
> + * @events: array of pending events to be returned.
> + */
>  struct mock_event_log {
> -	u16 clear_idx;
> -	u16 cur_idx;
> -	u16 nr_events;
> +	u16 last_handle;
> +	u16 current_handle;
>  	u16 nr_overflow;
> -	u16 overflow_reset;
> -	struct cxl_event_record_raw *events[CXL_TEST_EVENT_CNT_MAX];
> +	rwlock_t lock;
> +	struct cxl_event_record_raw *events[CXL_TEST_EVENT_ARRAY_SIZE];
>  };
>  
>  struct mock_event_store {
> @@ -194,56 +202,65 @@ static struct mock_event_log *event_find_log(struct device *dev, int log_type)
>  	return &mdata->mes.mock_logs[log_type];
>  }
>  
> -static struct cxl_event_record_raw *event_get_current(struct mock_event_log *log)
> -{
> -	return log->events[log->cur_idx];
> -}
> -
> -static void event_reset_log(struct mock_event_log *log)
> -{
> -	log->cur_idx = 0;
> -	log->clear_idx = 0;
> -	log->nr_overflow = log->overflow_reset;
> -}
> -
>  /* Handle can never be 0 use 1 based indexing for handle */
> -static u16 event_get_clear_handle(struct mock_event_log *log)
> +static u16 event_inc_handle(u16 handle)
>  {
> -	return log->clear_idx + 1;
> +	handle = (handle + 1) % CXL_TEST_EVENT_ARRAY_SIZE;
> +	if (handle == 0)
> +		handle = 1;
> +	return handle;
>  }
>  
> -/* Handle can never be 0 use 1 based indexing for handle */
> -static __le16 event_get_cur_event_handle(struct mock_event_log *log)
> -{
> -	u16 cur_handle = log->cur_idx + 1;
> -
> -	return cpu_to_le16(cur_handle);
> -}
> -
> -static bool event_log_empty(struct mock_event_log *log)
> -{
> -	return log->cur_idx == log->nr_events;
> -}
> -
> -static void mes_add_event(struct mock_event_store *mes,
> +/* Add the event or free it on overflow */
> +static void mes_add_event(struct cxl_mockmem_data *mdata,
>  			  enum cxl_event_log_type log_type,
>  			  struct cxl_event_record_raw *event)
>  {
> +	struct device *dev = mdata->mds->cxlds.dev;
>  	struct mock_event_log *log;
>  
>  	if (WARN_ON(log_type >= CXL_EVENT_TYPE_MAX))
>  		return;
>  
> -	log = &mes->mock_logs[log_type];
> +	log = &mdata->mes.mock_logs[log_type];
> +
> +	guard(write_lock)(&log->lock);
>  
> -	if ((log->nr_events + 1) > CXL_TEST_EVENT_CNT_MAX) {
> +	dev_dbg(dev, "Add log %d cur %d last %d\n",
> +		log_type, log->current_handle, log->last_handle);
> +
> +	/* Check next buffer */
> +	if (event_inc_handle(log->last_handle) == log->current_handle) {
>  		log->nr_overflow++;
> -		log->overflow_reset = log->nr_overflow;
> +		dev_dbg(dev, "Overflowing log %d nr %d\n",
> +			log_type, log->nr_overflow);
> +		devm_kfree(dev, event);
>  		return;
>  	}
>  
> -	log->events[log->nr_events] = event;
> -	log->nr_events++;
> +	dev_dbg(dev, "Log %d; handle %u\n", log_type, log->last_handle);
> +	event->event.generic.hdr.handle = cpu_to_le16(log->last_handle);
> +	log->events[log->last_handle] = event;
> +	log->last_handle = event_inc_handle(log->last_handle);
> +}
> +
> +static void mes_del_event(struct device *dev,
> +			  struct mock_event_log *log,
> +			  u16 handle)
> +{
> +	struct cxl_event_record_raw *record;
> +
> +	lockdep_assert(lockdep_is_held(&log->lock));

lockdep_assert_held(&log->lock);

> +
> +	dev_dbg(dev, "Clearing event %u; record %u\n",
> +		handle, log->current_handle);
> +	record = log->events[handle];
> +	if (!record)
> +		dev_err(dev, "Mock event index %u empty?\n", handle);

err but continue?

> +
> +	log->events[handle] = NULL;
> +	log->current_handle = event_inc_handle(log->current_handle);
> +	devm_kfree(dev, record);
>  }
>  
>  /*
> @@ -257,6 +274,7 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
>  	struct cxl_get_event_payload *pl;
>  	struct mock_event_log *log;
>  	int ret_limit;
> +	u16 handle;
>  	u8 log_type;
>  	int i;
>  
> @@ -276,22 +294,31 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
>  	memset(cmd->payload_out, 0, struct_size(pl, records, 0));
>  
>  	log = event_find_log(dev, log_type);
> -	if (!log || event_log_empty(log))
> +	if (!log)
>  		return 0;
>  
>  	pl = cmd->payload_out;
>  
> -	for (i = 0; i < ret_limit && !event_log_empty(log); i++) {
> -		memcpy(&pl->records[i], event_get_current(log),
> -		       sizeof(pl->records[i]));
> -		pl->records[i].event.generic.hdr.handle =
> -				event_get_cur_event_handle(log);
> -		log->cur_idx++;
> +	guard(read_lock)(&log->lock);
> +
> +	handle = log->current_handle;
> +	dev_dbg(dev, "Get log %d handle %u last %u\n",
> +		log_type, handle, log->last_handle);
> +	for (i = 0; i < ret_limit && handle != log->last_handle;
> +	     i++, handle = event_inc_handle(handle)) {
> +		struct cxl_event_record_raw *cur;
> +
> +		cur = log->events[handle];
> +		dev_dbg(dev, "Sending event log %d handle %d idx %u\n",
> +			log_type, le16_to_cpu(cur->event.generic.hdr.handle),
> +			handle);
> +		memcpy(&pl->records[i], cur, sizeof(pl->records[i]));
> +		pl->records[i].event.generic.hdr.handle = cpu_to_le16(handle);
>  	}
>  
>  	cmd->size_out = struct_size(pl, records, i);
>  	pl->record_count = cpu_to_le16(i);
> -	if (!event_log_empty(log))
> +	if (handle != log->last_handle)
>  		pl->flags |= CXL_GET_EVENT_FLAG_MORE_RECORDS;
>  
>  	if (log->nr_overflow) {
> @@ -313,8 +340,8 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
>  static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
>  {
>  	struct cxl_mbox_clear_event_payload *pl = cmd->payload_in;
> -	struct mock_event_log *log;
>  	u8 log_type = pl->event_log;
> +	struct mock_event_log *log;
>  	u16 handle;
>  	int nr;
>  
> @@ -325,23 +352,20 @@ static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
>  	if (!log)
>  		return 0; /* No mock data in this log */
>  
> -	/*
> -	 * This check is technically not invalid per the specification AFAICS.
> -	 * (The host could 'guess' handles and clear them in order).
> -	 * However, this is not good behavior for the host so test it.
> -	 */
> -	if (log->clear_idx + pl->nr_recs > log->cur_idx) {
> -		dev_err(dev,
> -			"Attempting to clear more events than returned!\n");
> -		return -EINVAL;
> -	}
> +	guard(write_lock)(&log->lock);
>  
>  	/* Check handle order prior to clearing events */
> -	for (nr = 0, handle = event_get_clear_handle(log);
> -	     nr < pl->nr_recs;
> -	     nr++, handle++) {
> +	handle = log->current_handle;
> +	for (nr = 0; nr < pl->nr_recs && handle != log->last_handle;
> +	     nr++, handle = event_inc_handle(handle)) {
> +
> +		dev_dbg(dev, "Checking clear of %d handle %u plhandle %u\n",
> +			log_type, handle,
> +			le16_to_cpu(pl->handles[nr]));
> +
>  		if (handle != le16_to_cpu(pl->handles[nr])) {
> -			dev_err(dev, "Clearing events out of order\n");
> +			dev_err(dev, "Clearing events out of order %u %u\n",
> +				handle, le16_to_cpu(pl->handles[nr]));
>  			return -EINVAL;
>  		}
>  	}
> @@ -350,25 +374,12 @@ static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
>  		log->nr_overflow = 0;
>  
>  	/* Clear events */
> -	log->clear_idx += pl->nr_recs;
> -	return 0;
> -}
> -
> -static void cxl_mock_event_trigger(struct device *dev)
> -{
> -	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> -	struct mock_event_store *mes = &mdata->mes;
> -	int i;
> -
> -	for (i = CXL_EVENT_TYPE_INFO; i < CXL_EVENT_TYPE_MAX; i++) {
> -		struct mock_event_log *log;
> +	for (nr = 0; nr < pl->nr_recs; nr++)
> +		mes_del_event(dev, log, le16_to_cpu(pl->handles[nr]));
> +	dev_dbg(dev, "Delete log %d cur %d last %d\n",
> +		log_type, log->current_handle, log->last_handle);
>  
> -		log = event_find_log(dev, i);
> -		if (log)
> -			event_reset_log(log);
> -	}
> -
> -	cxl_mem_get_event_records(mdata->mds, mes->ev_status);
> +	return 0;
>  }
>  
>  struct cxl_event_record_raw maint_needed = {
> @@ -509,8 +520,27 @@ static int mock_set_timestamp(struct cxl_dev_state *cxlds,
>  	return 0;
>  }
>  
> -static void cxl_mock_add_event_logs(struct mock_event_store *mes)
> +/* Create a dynamically allocated event out of a statically defined event. */
> +static void add_event_from_static(struct cxl_mockmem_data *mdata,
> +				  enum cxl_event_log_type log_type,
> +				  struct cxl_event_record_raw *raw)
>  {
> +	struct device *dev = mdata->mds->cxlds.dev;
> +	struct cxl_event_record_raw *rec;
> +
> +	rec = devm_kmemdup(dev, raw, sizeof(*rec), GFP_KERNEL);
> +	if (!rec) {
> +		dev_err(dev, "Failed to alloc event for log\n");
> +		return;

Should we silently swallow out of memory error instead of just fail?

DJ

> +	}
> +	mes_add_event(mdata, log_type, rec);
> +}
> +
> +static void cxl_mock_add_event_logs(struct cxl_mockmem_data *mdata)
> +{
> +	struct mock_event_store *mes = &mdata->mes;
> +	struct device *dev = mdata->mds->cxlds.dev;
> +
>  	put_unaligned_le16(CXL_GMER_VALID_CHANNEL | CXL_GMER_VALID_RANK |
>  			   CXL_GMER_VALID_COMPONENT | CXL_GMER_VALID_COMPONENT_ID_FORMAT,
>  			   &gen_media.rec.media_hdr.validity_flags);
> @@ -523,43 +553,60 @@ static void cxl_mock_add_event_logs(struct mock_event_store *mes)
>  	put_unaligned_le16(CXL_MMER_VALID_COMPONENT | CXL_MMER_VALID_COMPONENT_ID_FORMAT,
>  			   &mem_module.rec.validity_flags);
>  
> -	mes_add_event(mes, CXL_EVENT_TYPE_INFO, &maint_needed);
> -	mes_add_event(mes, CXL_EVENT_TYPE_INFO,
> +	dev_dbg(dev, "Generating fake event logs %d\n",
> +		CXL_EVENT_TYPE_INFO);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_INFO, &maint_needed);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_INFO,
>  		      (struct cxl_event_record_raw *)&gen_media);
> -	mes_add_event(mes, CXL_EVENT_TYPE_INFO,
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_INFO,
>  		      (struct cxl_event_record_raw *)&mem_module);
>  	mes->ev_status |= CXLDEV_EVENT_STATUS_INFO;
>  
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &maint_needed);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
> +	dev_dbg(dev, "Generating fake event logs %d\n",
> +		CXL_EVENT_TYPE_FAIL);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &maint_needed);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
> +		      (struct cxl_event_record_raw *)&mem_module);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
>  		      (struct cxl_event_record_raw *)&dram);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
>  		      (struct cxl_event_record_raw *)&gen_media);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
>  		      (struct cxl_event_record_raw *)&mem_module);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
>  		      (struct cxl_event_record_raw *)&dram);
>  	/* Overflow this log */
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
>  	mes->ev_status |= CXLDEV_EVENT_STATUS_FAIL;
>  
> -	mes_add_event(mes, CXL_EVENT_TYPE_FATAL, &hardware_replace);
> -	mes_add_event(mes, CXL_EVENT_TYPE_FATAL,
> +	dev_dbg(dev, "Generating fake event logs %d\n",
> +		CXL_EVENT_TYPE_FATAL);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FATAL, &hardware_replace);
> +	add_event_from_static(mdata, CXL_EVENT_TYPE_FATAL,
>  		      (struct cxl_event_record_raw *)&dram);
>  	mes->ev_status |= CXLDEV_EVENT_STATUS_FATAL;
>  }
>  
> +static void cxl_mock_event_trigger(struct device *dev)
> +{
> +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> +	struct mock_event_store *mes = &mdata->mes;
> +
> +	cxl_mock_add_event_logs(mdata);
> +	cxl_mem_get_event_records(mdata->mds, mes->ev_status);
> +}
> +
>  static int mock_gsl(struct cxl_mbox_cmd *cmd)
>  {
>  	if (cmd->size_out < sizeof(mock_gsl_payload))
> @@ -1684,6 +1731,14 @@ static void cxl_mock_test_feat_init(struct cxl_mockmem_data *mdata)
>  	mdata->test_feat.data = cpu_to_le32(0xdeadbeef);
>  }
>  
> +static void init_event_log(struct mock_event_log *log)
> +{
> +	rwlock_init(&log->lock);
> +	/* Handle can never be 0 use 1 based indexing for handle */
> +	log->current_handle = 1;
> +	log->last_handle = 1;
> +}
> +
>  static int cxl_mock_mem_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> @@ -1767,7 +1822,9 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
>  	if (rc)
>  		dev_dbg(dev, "No CXL Features discovered\n");
>  
> -	cxl_mock_add_event_logs(&mdata->mes);
> +	for (int i = 0; i < CXL_EVENT_TYPE_MAX; i++)
> +		init_event_log(&mdata->mes.mock_logs[i]);
> +	cxl_mock_add_event_logs(mdata);
>  
>  	cxlmd = devm_cxl_add_memdev(cxlds, NULL);
>  	if (IS_ERR(cxlmd))

