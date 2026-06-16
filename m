Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC03429814
	for <nvdimm@lists.linux.dev>; Tue, 16 Jun 2026 10:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781605773; cv=none; b=AbQDzhsbALVG1oh4StL7OfyIcFZkZD6FlN43nAs/EA9tOjeFs51n5e9jdQrZIZgEjG5hM+DX8Lc7LFtq60Gx4BC/Fbuhs0gOHXsuPhBCRNgRBP8QJRZ6nJzDa+603Yid4vXm2hji6nNpng+rtkdpzaoojff2QYTyHqjD9tkEeFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781605773; c=relaxed/simple;
	bh=ve2uwwPkDboz/Uhj9eJTwaySVS2MzKq96F1habaED4Y=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g5ZywkbBEu0Qs2JUb/AeANJHBFJlaZ10WByhAih3UA2i3LgRDM3+1Xmtnax0AdG7dR9xsZWiTkBYwGPxvteLk+3Ls6FLn2hx4vG1OH/bYutaFgtsIQEpOQqUDJh8alkf3nV0vgqsGEqA2s6P7qx0BWXV4sCRdjr1j9RpHSxvN2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eh2ewyXi; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eh2ewyXi"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-304e83724bfso5951913eec.0
        for <nvdimm@lists.linux.dev>; Tue, 16 Jun 2026 03:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781605771; x=1782210571; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VAaAOReEyL2M0s30MsLH4Obk7QQ31tms3r9xJL5cJAg=;
        b=Eh2ewyXixY+uFicsCPO+ABcOKW+pLMtXRNDbS5qkRxsK0EfI5HZUSdbaFx2HYkKijD
         Rmo0yoPN2IyXYxRgdkurGjaU9YwEfv1Z0S7ku+FOecCzlkhX1W/Nk/0CqONS9gPiMpuv
         TvRM+0lusJD1VvUbSltNlcDuMXGFW2AQTxx4x5bKkaNachnVtQUJoGN/yF397gwkUIuZ
         Ri7PAjqi/euUhHOchH5pBbpao7B0kNpO2g2gYnXoDJhKcFY6VDA8nUG4bs0ai9CjpP5O
         IsL7w/vJVLLeHU3/j7riQe+rdv/7rSx+J0ICGPyKXe2ZEsAC56nhDSJXnp7zN8H13rAP
         hbGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781605771; x=1782210571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VAaAOReEyL2M0s30MsLH4Obk7QQ31tms3r9xJL5cJAg=;
        b=C6Cq4jSrhaLWHNOnI+d8ig7F0DParr1WpQf0mCbFukDWLG6CQHVAMEUPWNJAnkY3NC
         cK1K8UmAWshBJTEb2MMdknbSIw84x8y6Sym1WjaQvwUZUhu79GVoH8m4UmAgfyi+h9ZI
         l7KsIwiX/++q8Cq/vB1TZp2Dq4FSBGRM+7jF2QhDTv70P46sAN5kIXY+NpohrwEpcNAd
         w3MYVW/0eQIbemn+bU1bkFk4r4emOtpJe/BtCTtELcLXubb6WiS8PC3xP8SykjvZchbK
         3OfMpbqch+APrEIqX9grbSUOrYGQ6rRaCjx6I7qE2V60i1SLlgEeFzr9d+bazNcFVp/4
         8uow==
X-Forwarded-Encrypted: i=1; AFNElJ/hphZmAVF2JcoxMzV1odJak/gmk8Vp2IuBVCffzIHPD76XLVnM4G3TmD86CBcLs1H+kz/l8lM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyK+tnH775XUKOo2nShN9fDeZ0IkxQgUgg0oTpcxvpXTolmAnK6
	wSPV9pcEL/C1gnxDEc1XXO2BaNLKxaIDA+mmDHjd8dXqXtbV8PhHjtEt
X-Gm-Gg: Acq92OFVknudHLp9UQeXKnPBMM3vLBbPz9EEXtZvxE4UeB1V+MrHA/saMjgyyqaPasN
	+SeNs5EePWnjrtlU64thMm6dTGWWMwcZSuPFEgqNb2h4dWK31+Odn5SPuxZH/Rw4V6leesA97Tc
	7gZ3N1P93KvtF5jwpZc7y1qqy0bE30RKb79QZllKpVe91S+NqpZpMXTxn7j7Oao6gy5qZrCckat
	HEigfnUDZKQXQdPtNrXW9RaqOV0mpKMLUL/VX5v1F+s6rsqfnEmYD2SLUlA2Bf66HO3FUOostNu
	DW3IwBezJSCYElIp+siOwVd62uBW8yCgfWTE8XS+pJ3TSuImaZM1LYCl0tBunW6mnHQx1LMYkoQ
	uBI5jtYXUaerR1qno1uVZat1uEDkxu8a7DlPZn0UYorhAoPXN0xOuB5MxkAvwxoNWU2jcLD4k1y
	wouUPtM4412+ps4JIMNCHvUELQ4b4bw8CakF5g5lyxEgTRhswiKL/IueMhPSfPOoj8riqOqRcuq
	c4GR28=
X-Received: by 2002:a05:7300:4316:b0:307:287f:9bbc with SMTP id 5a478bee46e88-30ba5f6f0c3mr1711640eec.25.1781605770632;
        Tue, 16 Jun 2026 03:29:30 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ba6b7f840sm3719345eec.19.2026.06.16.03.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 03:29:30 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 16 Jun 2026 03:29:29 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH v10 29/31] tools/testing/cxl: Make event logs dynamic
Message-ID: <ajEliRrWpV0ERJCi@AnisaLaptop.localdomain>
References: <cover.1779528761.git.anisa.su@samsung.com>
 <41c47ec44202b7a2491f89752247d8968758e213.1779528761.git.anisa.su@samsung.com>
 <70c4f06b-557a-4239-9326-8646b85315a7@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70c4f06b-557a-4239-9326-8646b85315a7@intel.com>

On Fri, May 29, 2026 at 03:58:58PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:43 AM, Anisa Su wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > The event logs test was created as static arrays as an easy way to mock
> > events.  Dynamic Capacity Device (DCD) test support requires events be
> > generated dynamically when extents are created or destroyed.
> > 
> > The current event log test has specific checks for the number of events
> > seen including log overflow.
> > 
> > Modify mock event logs to be dynamically allocated.  Adjust array size
> > and mock event entry data to match the output expected by the existing
> > event test.
> > 
> > Use the static event data to create the dynamic events in the new logs
> > without inventing complex event injection for the previous tests.
> > 
> > Simplify log processing by using the event log array index as the
> > handle.  Add a lock to manage concurrency required when user space is
> > allowed to control DCD extents
> > 
> > Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > ---
> >  tools/testing/cxl/test/mem.c | 265 +++++++++++++++++++++--------------
> >  1 file changed, 161 insertions(+), 104 deletions(-)
> > 
> > diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> > index 271c7ad8cc32..fe1dadddd18e 100644
> > --- a/tools/testing/cxl/test/mem.c
> > +++ b/tools/testing/cxl/test/mem.c
> > @@ -142,18 +142,26 @@ static struct {
> >  
> >  #define PASS_TRY_LIMIT 3
> >  
> > -#define CXL_TEST_EVENT_CNT_MAX 15
> > +#define CXL_TEST_EVENT_CNT_MAX 16
> > +/* 1 extra slot to accommodate that handles can't be 0 */
> > +#define CXL_TEST_EVENT_ARRAY_SIZE (CXL_TEST_EVENT_CNT_MAX + 1)
> >  
> >  /* Set a number of events to return at a time for simulation.  */
> >  #define CXL_TEST_EVENT_RET_MAX 4
> >  
> > +/*
> > + * @last_handle: last handle (index) to have an entry stored
> > + * @current_handle: current handle (index) to be returned to the user on get_event
> > + * @nr_overflow: number of events added past the log size
> > + * @lock: protect these state variables
> > + * @events: array of pending events to be returned.
> > + */
> >  struct mock_event_log {
> > -	u16 clear_idx;
> > -	u16 cur_idx;
> > -	u16 nr_events;
> > +	u16 last_handle;
> > +	u16 current_handle;
> >  	u16 nr_overflow;
> > -	u16 overflow_reset;
> > -	struct cxl_event_record_raw *events[CXL_TEST_EVENT_CNT_MAX];
> > +	rwlock_t lock;
> > +	struct cxl_event_record_raw *events[CXL_TEST_EVENT_ARRAY_SIZE];
> >  };
> >  
> >  struct mock_event_store {
> > @@ -194,56 +202,65 @@ static struct mock_event_log *event_find_log(struct device *dev, int log_type)
> >  	return &mdata->mes.mock_logs[log_type];
> >  }
> >  
> > -static struct cxl_event_record_raw *event_get_current(struct mock_event_log *log)
> > -{
> > -	return log->events[log->cur_idx];
> > -}
> > -
> > -static void event_reset_log(struct mock_event_log *log)
> > -{
> > -	log->cur_idx = 0;
> > -	log->clear_idx = 0;
> > -	log->nr_overflow = log->overflow_reset;
> > -}
> > -
> >  /* Handle can never be 0 use 1 based indexing for handle */
> > -static u16 event_get_clear_handle(struct mock_event_log *log)
> > +static u16 event_inc_handle(u16 handle)
> >  {
> > -	return log->clear_idx + 1;
> > +	handle = (handle + 1) % CXL_TEST_EVENT_ARRAY_SIZE;
> > +	if (handle == 0)
> > +		handle = 1;
> > +	return handle;
> >  }
> >  
> > -/* Handle can never be 0 use 1 based indexing for handle */
> > -static __le16 event_get_cur_event_handle(struct mock_event_log *log)
> > -{
> > -	u16 cur_handle = log->cur_idx + 1;
> > -
> > -	return cpu_to_le16(cur_handle);
> > -}
> > -
> > -static bool event_log_empty(struct mock_event_log *log)
> > -{
> > -	return log->cur_idx == log->nr_events;
> > -}
> > -
> > -static void mes_add_event(struct mock_event_store *mes,
> > +/* Add the event or free it on overflow */
> > +static void mes_add_event(struct cxl_mockmem_data *mdata,
> >  			  enum cxl_event_log_type log_type,
> >  			  struct cxl_event_record_raw *event)
> >  {
> > +	struct device *dev = mdata->mds->cxlds.dev;
> >  	struct mock_event_log *log;
> >  
> >  	if (WARN_ON(log_type >= CXL_EVENT_TYPE_MAX))
> >  		return;
> >  
> > -	log = &mes->mock_logs[log_type];
> > +	log = &mdata->mes.mock_logs[log_type];
> > +
> > +	guard(write_lock)(&log->lock);
> >  
> > -	if ((log->nr_events + 1) > CXL_TEST_EVENT_CNT_MAX) {
> > +	dev_dbg(dev, "Add log %d cur %d last %d\n",
> > +		log_type, log->current_handle, log->last_handle);
> > +
> > +	/* Check next buffer */
> > +	if (event_inc_handle(log->last_handle) == log->current_handle) {
> >  		log->nr_overflow++;
> > -		log->overflow_reset = log->nr_overflow;
> > +		dev_dbg(dev, "Overflowing log %d nr %d\n",
> > +			log_type, log->nr_overflow);
> > +		devm_kfree(dev, event);
> >  		return;
> >  	}
> >  
> > -	log->events[log->nr_events] = event;
> > -	log->nr_events++;
> > +	dev_dbg(dev, "Log %d; handle %u\n", log_type, log->last_handle);
> > +	event->event.generic.hdr.handle = cpu_to_le16(log->last_handle);
> > +	log->events[log->last_handle] = event;
> > +	log->last_handle = event_inc_handle(log->last_handle);
> > +}
> > +
> > +static void mes_del_event(struct device *dev,
> > +			  struct mock_event_log *log,
> > +			  u16 handle)
> > +{
> > +	struct cxl_event_record_raw *record;
> > +
> > +	lockdep_assert(lockdep_is_held(&log->lock));
> 
> lockdep_assert_held(&log->lock);
> 
fixed

> > +
> > +	dev_dbg(dev, "Clearing event %u; record %u\n",
> > +		handle, log->current_handle);
> > +	record = log->events[handle];
> > +	if (!record)
> > +		dev_err(dev, "Mock event index %u empty?\n", handle);
> 
> err but continue?
> 
now returns;

> > +
> > +	log->events[handle] = NULL;
> > +	log->current_handle = event_inc_handle(log->current_handle);
> > +	devm_kfree(dev, record);
> >  }
> >  
> >  /*
> > @@ -257,6 +274,7 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
> >  	struct cxl_get_event_payload *pl;
> >  	struct mock_event_log *log;
> >  	int ret_limit;
> > +	u16 handle;
> >  	u8 log_type;
> >  	int i;
> >  
> > @@ -276,22 +294,31 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
> >  	memset(cmd->payload_out, 0, struct_size(pl, records, 0));
> >  
> >  	log = event_find_log(dev, log_type);
> > -	if (!log || event_log_empty(log))
> > +	if (!log)
> >  		return 0;
> >  
> >  	pl = cmd->payload_out;
> >  
> > -	for (i = 0; i < ret_limit && !event_log_empty(log); i++) {
> > -		memcpy(&pl->records[i], event_get_current(log),
> > -		       sizeof(pl->records[i]));
> > -		pl->records[i].event.generic.hdr.handle =
> > -				event_get_cur_event_handle(log);
> > -		log->cur_idx++;
> > +	guard(read_lock)(&log->lock);
> > +
> > +	handle = log->current_handle;
> > +	dev_dbg(dev, "Get log %d handle %u last %u\n",
> > +		log_type, handle, log->last_handle);
> > +	for (i = 0; i < ret_limit && handle != log->last_handle;
> > +	     i++, handle = event_inc_handle(handle)) {
> > +		struct cxl_event_record_raw *cur;
> > +
> > +		cur = log->events[handle];
> > +		dev_dbg(dev, "Sending event log %d handle %d idx %u\n",
> > +			log_type, le16_to_cpu(cur->event.generic.hdr.handle),
> > +			handle);
> > +		memcpy(&pl->records[i], cur, sizeof(pl->records[i]));
> > +		pl->records[i].event.generic.hdr.handle = cpu_to_le16(handle);
> >  	}
> >  
> >  	cmd->size_out = struct_size(pl, records, i);
> >  	pl->record_count = cpu_to_le16(i);
> > -	if (!event_log_empty(log))
> > +	if (handle != log->last_handle)
> >  		pl->flags |= CXL_GET_EVENT_FLAG_MORE_RECORDS;
> >  
> >  	if (log->nr_overflow) {
> > @@ -313,8 +340,8 @@ static int mock_get_event(struct device *dev, struct cxl_mbox_cmd *cmd)
> >  static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
> >  {
> >  	struct cxl_mbox_clear_event_payload *pl = cmd->payload_in;
> > -	struct mock_event_log *log;
> >  	u8 log_type = pl->event_log;
> > +	struct mock_event_log *log;
> >  	u16 handle;
> >  	int nr;
> >  
> > @@ -325,23 +352,20 @@ static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
> >  	if (!log)
> >  		return 0; /* No mock data in this log */
> >  
> > -	/*
> > -	 * This check is technically not invalid per the specification AFAICS.
> > -	 * (The host could 'guess' handles and clear them in order).
> > -	 * However, this is not good behavior for the host so test it.
> > -	 */
> > -	if (log->clear_idx + pl->nr_recs > log->cur_idx) {
> > -		dev_err(dev,
> > -			"Attempting to clear more events than returned!\n");
> > -		return -EINVAL;
> > -	}
> > +	guard(write_lock)(&log->lock);
> >  
> >  	/* Check handle order prior to clearing events */
> > -	for (nr = 0, handle = event_get_clear_handle(log);
> > -	     nr < pl->nr_recs;
> > -	     nr++, handle++) {
> > +	handle = log->current_handle;
> > +	for (nr = 0; nr < pl->nr_recs && handle != log->last_handle;
> > +	     nr++, handle = event_inc_handle(handle)) {
> > +
> > +		dev_dbg(dev, "Checking clear of %d handle %u plhandle %u\n",
> > +			log_type, handle,
> > +			le16_to_cpu(pl->handles[nr]));
> > +
> >  		if (handle != le16_to_cpu(pl->handles[nr])) {
> > -			dev_err(dev, "Clearing events out of order\n");
> > +			dev_err(dev, "Clearing events out of order %u %u\n",
> > +				handle, le16_to_cpu(pl->handles[nr]));
> >  			return -EINVAL;
> >  		}
> >  	}
> > @@ -350,25 +374,12 @@ static int mock_clear_event(struct device *dev, struct cxl_mbox_cmd *cmd)
> >  		log->nr_overflow = 0;
> >  
> >  	/* Clear events */
> > -	log->clear_idx += pl->nr_recs;
> > -	return 0;
> > -}
> > -
> > -static void cxl_mock_event_trigger(struct device *dev)
> > -{
> > -	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > -	struct mock_event_store *mes = &mdata->mes;
> > -	int i;
> > -
> > -	for (i = CXL_EVENT_TYPE_INFO; i < CXL_EVENT_TYPE_MAX; i++) {
> > -		struct mock_event_log *log;
> > +	for (nr = 0; nr < pl->nr_recs; nr++)
> > +		mes_del_event(dev, log, le16_to_cpu(pl->handles[nr]));
> > +	dev_dbg(dev, "Delete log %d cur %d last %d\n",
> > +		log_type, log->current_handle, log->last_handle);
> >  
> > -		log = event_find_log(dev, i);
> > -		if (log)
> > -			event_reset_log(log);
> > -	}
> > -
> > -	cxl_mem_get_event_records(mdata->mds, mes->ev_status);
> > +	return 0;
> >  }
> >  
> >  struct cxl_event_record_raw maint_needed = {
> > @@ -509,8 +520,27 @@ static int mock_set_timestamp(struct cxl_dev_state *cxlds,
> >  	return 0;
> >  }
> >  
> > -static void cxl_mock_add_event_logs(struct mock_event_store *mes)
> > +/* Create a dynamically allocated event out of a statically defined event. */
> > +static void add_event_from_static(struct cxl_mockmem_data *mdata,
> > +				  enum cxl_event_log_type log_type,
> > +				  struct cxl_event_record_raw *raw)
> >  {
> > +	struct device *dev = mdata->mds->cxlds.dev;
> > +	struct cxl_event_record_raw *rec;
> > +
> > +	rec = devm_kmemdup(dev, raw, sizeof(*rec), GFP_KERNEL);
> > +	if (!rec) {
> > +		dev_err(dev, "Failed to alloc event for log\n");
> > +		return;
> 
> Should we silently swallow out of memory error instead of just fail?
> 
returns -ENOMEM

function return type changes to int. Return value propagated through
cxl_mock_add_event_logs(), so all calls to add_event_from_static() below
looks like

rc = rc ?: add_event_from_static(...);

> DJ
> 
Thanks,
Anisa

> > +	}
> > +	mes_add_event(mdata, log_type, rec);
> > +}
> > +
> > +static void cxl_mock_add_event_logs(struct cxl_mockmem_data *mdata)
> > +{
> > +	struct mock_event_store *mes = &mdata->mes;
> > +	struct device *dev = mdata->mds->cxlds.dev;
> > +
> >  	put_unaligned_le16(CXL_GMER_VALID_CHANNEL | CXL_GMER_VALID_RANK |
> >  			   CXL_GMER_VALID_COMPONENT | CXL_GMER_VALID_COMPONENT_ID_FORMAT,
> >  			   &gen_media.rec.media_hdr.validity_flags);
> > @@ -523,43 +553,60 @@ static void cxl_mock_add_event_logs(struct mock_event_store *mes)
> >  	put_unaligned_le16(CXL_MMER_VALID_COMPONENT | CXL_MMER_VALID_COMPONENT_ID_FORMAT,
> >  			   &mem_module.rec.validity_flags);
> >  
> > -	mes_add_event(mes, CXL_EVENT_TYPE_INFO, &maint_needed);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_INFO,
> > +	dev_dbg(dev, "Generating fake event logs %d\n",
> > +		CXL_EVENT_TYPE_INFO);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_INFO, &maint_needed);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_INFO,
> >  		      (struct cxl_event_record_raw *)&gen_media);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_INFO,
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_INFO,
> >  		      (struct cxl_event_record_raw *)&mem_module);
> >  	mes->ev_status |= CXLDEV_EVENT_STATUS_INFO;
> >  
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &maint_needed);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
> > +	dev_dbg(dev, "Generating fake event logs %d\n",
> > +		CXL_EVENT_TYPE_FAIL);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &maint_needed);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
> > +		      (struct cxl_event_record_raw *)&mem_module);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
> >  		      (struct cxl_event_record_raw *)&dram);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
> >  		      (struct cxl_event_record_raw *)&gen_media);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
> >  		      (struct cxl_event_record_raw *)&mem_module);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL,
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL,
> >  		      (struct cxl_event_record_raw *)&dram);
> >  	/* Overflow this log */
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FAIL, &hardware_replace);
> >  	mes->ev_status |= CXLDEV_EVENT_STATUS_FAIL;
> >  
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FATAL, &hardware_replace);
> > -	mes_add_event(mes, CXL_EVENT_TYPE_FATAL,
> > +	dev_dbg(dev, "Generating fake event logs %d\n",
> > +		CXL_EVENT_TYPE_FATAL);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FATAL, &hardware_replace);
> > +	add_event_from_static(mdata, CXL_EVENT_TYPE_FATAL,
> >  		      (struct cxl_event_record_raw *)&dram);
> >  	mes->ev_status |= CXLDEV_EVENT_STATUS_FATAL;
> >  }
> >  
> > +static void cxl_mock_event_trigger(struct device *dev)
> > +{
> > +	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
> > +	struct mock_event_store *mes = &mdata->mes;
> > +
> > +	cxl_mock_add_event_logs(mdata);
> > +	cxl_mem_get_event_records(mdata->mds, mes->ev_status);
> > +}
> > +
> >  static int mock_gsl(struct cxl_mbox_cmd *cmd)
> >  {
> >  	if (cmd->size_out < sizeof(mock_gsl_payload))
> > @@ -1684,6 +1731,14 @@ static void cxl_mock_test_feat_init(struct cxl_mockmem_data *mdata)
> >  	mdata->test_feat.data = cpu_to_le32(0xdeadbeef);
> >  }
> >  
> > +static void init_event_log(struct mock_event_log *log)
> > +{
> > +	rwlock_init(&log->lock);
> > +	/* Handle can never be 0 use 1 based indexing for handle */
> > +	log->current_handle = 1;
> > +	log->last_handle = 1;
> > +}
> > +
> >  static int cxl_mock_mem_probe(struct platform_device *pdev)
> >  {
> >  	struct device *dev = &pdev->dev;
> > @@ -1767,7 +1822,9 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
> >  	if (rc)
> >  		dev_dbg(dev, "No CXL Features discovered\n");
> >  
> > -	cxl_mock_add_event_logs(&mdata->mes);
> > +	for (int i = 0; i < CXL_EVENT_TYPE_MAX; i++)
> > +		init_event_log(&mdata->mes.mock_logs[i]);
> > +	cxl_mock_add_event_logs(mdata);
> >  
> >  	cxlmd = devm_cxl_add_memdev(cxlds, NULL);
> >  	if (IS_ERR(cxlmd))
> 
