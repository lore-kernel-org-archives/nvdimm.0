Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEAD278E63
	for <nvdimm@lists.linux.dev>; Mon,  7 Jul 2025 06:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751869515; cv=none; b=HCp4cN6pDYq+LyNiVgRTJTCgzavxF3FGdvLlyebeWdqSHqg83U6DYUP9MvzlAjHH6DuhF0gbLGJtoImtW5T4xFmIqHh4rShNMPBYHCfUE2R7GjfBsnvuu5XggIptS+rjmPRqZQ29utS8s0l+nSYADXTdIwdVBOnY1D9ZHZabo1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751869515; c=relaxed/simple;
	bh=L1OJFZePJC7bm+TGpqgXhtHPxDrMC7hzgIqvLtOGIeE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tUVTy6UtAm3El6OWILBt0yZPV4Mw3BKQweNmSrTUsg8ktN8HSENa7awJzVx1g7nLIXog21p3J5W0F+aa4P8sKIZrc0o8sF5l7VjEBfFGUsVnmcX3kiVbj0WPyPGCBshsuxnOIHXDjculuzAWH1Y06P2+CMdtL4Z+YTqiLuVF1co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=V48NXUfD; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="V48NXUfD"
Message-ID: <e9386b67-9c4c-415e-91d8-511ac8d0ded5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751869512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vMXBEkTsI7ndCSL5SBx4dyxJbRzHSLL2t1hoBK/+038=;
	b=V48NXUfDPPkP9rAIAXNmboO99SKyX46T3QjGrGoD26aoCtb56O84XZ5u2CUocciZ5cZgKX
	zYi4I92NJiUt4flXdDJyO6ANnjhIZ26H0hh0waeLkBTHIX46PKCmqaWcj1jZFi8WOVgWBB
	lTbQeUoOwYdcBQ+/XGCIGJrnT4gVUfQ=
Date: Mon, 7 Jul 2025 14:25:06 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH v1 02/11] dm-pcache: add backing device management
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: mpatocka@redhat.com, agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
 hch@lst.de, dan.j.williams@intel.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev, dm-devel@lists.linux.dev
References: <20250624073359.2041340-1-dongsheng.yang@linux.dev>
 <20250624073359.2041340-3-dongsheng.yang@linux.dev>
 <20250701145650.00004e72@huawei.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20250701145650.00004e72@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 7/1/2025 9:56 PM, Jonathan Cameron 写道:
> On Tue, 24 Jun 2025 07:33:49 +0000
> Dongsheng Yang <dongsheng.yang@linux.dev> wrote:
>
>> This patch introduces *backing_dev.{c,h}*, a self-contained layer that
>> handles all interaction with the *backing block device* where cache
>> write-back and cache-miss reads are serviced.  Isolating this logic
>> keeps the core dm-pcache code free of low-level bio plumbing.
>>
>> * Device setup / teardown
>>    - Opens the target with `dm_get_device()`, stores `bdev`, file and
>>      size, and initialises a dedicated `bioset`.
>>    - Gracefully releases resources via `backing_dev_stop()`.
>>
>> * Request object (`struct pcache_backing_dev_req`)
>>    - Two request flavours:
>>      - REQ-type – cloned from an upper `struct bio` issued to
>>        dm-pcache; trimmed and re-targeted to the backing LBA.
>>      - KMEM-type – maps an arbitrary kernel memory buffer
>>        into a freshly built.
>>    - Private completion callback (`end_req`) propagates status to the
>>      upper layer and handles resource recycling.
>>
>> * Submission & completion path
>>    - Lock-protected submit queue + worker (`req_submit_work`) let pcache
>>      push many requests asynchronously, at the same time, allow caller
>>      to submit backing_dev_req in atomic context.
>>    - End-io handler moves finished requests to a completion list processed
>>      by `req_complete_work`, ensuring callbacks run in process context.
>>    - Direct-submit option for non-atomic context.
>>
>> * Flush
>>    - `backing_dev_flush()` issues a flush to persist backing-device data.
>>
>> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
>> ---
>>   drivers/md/dm-pcache/backing_dev.c | 292 +++++++++++++++++++++++++++++
>>   drivers/md/dm-pcache/backing_dev.h |  88 +++++++++
>>   2 files changed, 380 insertions(+)
>>   create mode 100644 drivers/md/dm-pcache/backing_dev.c
>>   create mode 100644 drivers/md/dm-pcache/backing_dev.h
>> +
>> +struct pcache_backing_dev_req *backing_dev_req_create(struct pcache_backing_dev *backing_dev,
>> +						struct pcache_backing_dev_req_opts *opts)
>> +{
>> +	if (opts->type == BACKING_DEV_REQ_TYPE_REQ)
>> +		return req_type_req_create(backing_dev, opts);
>> +	else if (opts->type == BACKING_DEV_REQ_TYPE_KMEM)
>>
> returned in earlier branch so go with simpler
>
> 	if (opts->type..)

Hi Jonathan,

This looks good, I am willing to do this change.


Thanx

Dongsheng

> Or use a switch statement if you expect to get more entries in this over time.
>
>> +		return kmem_type_req_create(backing_dev, opts);
>> +
>> +	return NULL;
>> +}
>> +
>> +void backing_dev_flush(struct pcache_backing_dev *backing_dev)
>> +{
>> +	blkdev_issue_flush(backing_dev->dm_dev->bdev);
>> +}
>
