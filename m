Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5719D4CB36;
	Fri,  7 Jun 2024 06:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717741237; cv=none; b=hFn2QX4HJkU96+hWWcM6DWoSwQf32KHAz+8+vDuM3uYQf33N2afzmuf4KYGu+oA+3qyNgPL+W5PllsG8kpnPIWt2af0kQm0htvGzMHSPF67lPFDOmPvyMC3a1glJVn2GVjijAww3w2J3E30PJJONnZrLRQp4yiPSuIkOVYp0+Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717741237; c=relaxed/simple;
	bh=PkcZW5W/DEIVvQToXE52qPDl90497sf8+PWEr7okS0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=in01j8mQOOnOfW0aFFQYCLF+tdSuL2sx8CPG7Q3GtAfUK82HMO/Pyr3x8WTZ2EHnaptAofF9aQm2AdS4OL3ATL45Rtv4ciJXjsrks/ovf0bxHNGCIyJSPF8ApCmxCJabKur2ENKETd3ecsRlOpAriczclxQCW+pYlWR0ztc8jlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a/BTDtAd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JQPB1Wbg; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=a/BTDtAd; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JQPB1Wbg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a/BTDtAd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JQPB1Wbg";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="a/BTDtAd";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JQPB1Wbg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 67B861FB81;
	Fri,  7 Jun 2024 06:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717741234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rq9nYjWX5QjyjUqX6I6axUyZpuuyXyO4zh+3o2apteA=;
	b=a/BTDtAdN7FVVxzWaK4ljzPAm5G+wkhQrZT/7jr0ue+jzyn1sQhFx5Ar4OlY4AmS1p0NAb
	pgOFsipb7TiawItNpwaHmQgvuLzTv0eTzzksR/eFM2fuwM0EJ1EFYoZmfkQcUkwyI4Pjhk
	prQtAz9fLZuv7E9idK8bgjrCL/M2sTk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717741234;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rq9nYjWX5QjyjUqX6I6axUyZpuuyXyO4zh+3o2apteA=;
	b=JQPB1WbgBvYWSZErgyXfOxrZdOjNBcdWx5HEUU5HlM3FEvBpuNxD/WvJLs30d7iQl3dteZ
	zz7FR9UTtQ8+GJAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717741234; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rq9nYjWX5QjyjUqX6I6axUyZpuuyXyO4zh+3o2apteA=;
	b=a/BTDtAdN7FVVxzWaK4ljzPAm5G+wkhQrZT/7jr0ue+jzyn1sQhFx5Ar4OlY4AmS1p0NAb
	pgOFsipb7TiawItNpwaHmQgvuLzTv0eTzzksR/eFM2fuwM0EJ1EFYoZmfkQcUkwyI4Pjhk
	prQtAz9fLZuv7E9idK8bgjrCL/M2sTk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717741234;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rq9nYjWX5QjyjUqX6I6axUyZpuuyXyO4zh+3o2apteA=;
	b=JQPB1WbgBvYWSZErgyXfOxrZdOjNBcdWx5HEUU5HlM3FEvBpuNxD/WvJLs30d7iQl3dteZ
	zz7FR9UTtQ8+GJAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 90D40133F3;
	Fri,  7 Jun 2024 06:20:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wv1vIbGmYmaVYQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 07 Jun 2024 06:20:33 +0000
Message-ID: <4070de4c-30c0-4322-bfe5-44b0797037c9@suse.de>
Date: Fri, 7 Jun 2024 08:20:32 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/11] block: bypass the STABLE_WRITES flag for protection
 information
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240607055912.3586772-1-hch@lst.de>
 <20240607055912.3586772-10-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240607055912.3586772-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.989];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,lst.de:email,suse.de:email]
X-Spam-Score: -4.29
X-Spam-Flag: NO

On 6/7/24 07:59, Christoph Hellwig wrote:
> Currently registering a checksum-enabled (aka PI) integrity profile sets
> the QUEUE_FLAG_STABLE_WRITE flag, and unregistering it clears the flag.
> This can incorrectly clear the flag when the driver requires stable
> writes even without PI, e.g. in case of iSCSI or NVMe/TCP with data
> digest enabled.
> 
> Fix this by looking at the csum_type directly in bdev_stable_writes and
> not setting the queue flag.  Also remove the blk_queue_stable_writes
> helper as the only user in nvme wants to only look at the actual
> QUEUE_FLAG_STABLE_WRITE flag as it inherits the integrity configuration
> by other means.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-integrity.c         |  6 ------
>   drivers/nvme/host/multipath.c |  3 ++-
>   include/linux/blkdev.h        | 12 ++++++++----
>   3 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/block/blk-integrity.c b/block/blk-integrity.c
> index 1d2d371cd632d3..bec0d1df387ce9 100644
> --- a/block/blk-integrity.c
> +++ b/block/blk-integrity.c
> @@ -379,9 +379,6 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
>   	bi->tag_size = template->tag_size;
>   	bi->pi_offset = template->pi_offset;
>   
> -	if (bi->csum_type != BLK_INTEGRITY_CSUM_NONE)
> -		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, disk->queue);
> -
>   #ifdef CONFIG_BLK_INLINE_ENCRYPTION
>   	if (disk->queue->crypto_profile) {
>   		pr_warn("blk-integrity: Integrity and hardware inline encryption are not supported together. Disabling hardware inline encryption.\n");
> @@ -404,9 +401,6 @@ void blk_integrity_unregister(struct gendisk *disk)
>   
>   	if (!bi->tuple_size)
>   		return;
> -
> -	if (bi->csum_type != BLK_INTEGRITY_CSUM_NONE)
> -		blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
>   	memset(bi, 0, sizeof(*bi));
>   }
>   EXPORT_SYMBOL(blk_integrity_unregister);
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index d8b6b4648eaff9..12c59db02539e5 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -875,7 +875,8 @@ void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid)
>   		nvme_mpath_set_live(ns);
>   	}
>   
> -	if (blk_queue_stable_writes(ns->queue) && ns->head->disk)
> +	if (test_bit(QUEUE_FLAG_STABLE_WRITES, &ns->queue->queue_flags) &&
> +	    ns->head->disk)
>   		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES,
>   				   ns->head->disk->queue);
>   #ifdef CONFIG_BLK_DEV_ZONED
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index bdd33388e1ced8..f9089750919c6b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -571,8 +571,6 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
>   #define blk_queue_noxmerges(q)	\
>   	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
>   #define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, &(q)->queue_flags)
> -#define blk_queue_stable_writes(q) \
> -	test_bit(QUEUE_FLAG_STABLE_WRITES, &(q)->queue_flags)
>   #define blk_queue_io_stat(q)	test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_flags)
>   #define blk_queue_add_random(q)	test_bit(QUEUE_FLAG_ADD_RANDOM, &(q)->queue_flags)
>   #define blk_queue_zone_resetall(q)	\
> @@ -1300,8 +1298,14 @@ static inline bool bdev_synchronous(struct block_device *bdev)
>   
>   static inline bool bdev_stable_writes(struct block_device *bdev)
>   {
> -	return test_bit(QUEUE_FLAG_STABLE_WRITES,
> -			&bdev_get_queue(bdev)->queue_flags);
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +#ifdef CONFIG_BLK_DEV_INTEGRITY
> +	/* BLK_INTEGRITY_CSUM_NONE is not available in blkdev.h */
> +	if (q->integrity.csum_type != 0)
> +		return true;
> +#endif
> +	return test_bit(QUEUE_FLAG_STABLE_WRITES, &q->queue_flags);
>   }
>   
>   static inline bool bdev_write_cache(struct block_device *bdev)

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

