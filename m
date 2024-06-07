Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453451BC2F;
	Fri,  7 Jun 2024 06:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717740985; cv=none; b=RU2aiGmc4gqaHL8hsE6HyrMlsKHsNs7WIoj0sJWQaU4rpbm6dY+l+fJN9JqaJwS5NbvpNwJv7vJGhqB65fQAgkIALZ5TmWI6b527VnU01APsW+NSKYeg8kMSHADXjYCcwQVPFvPhpxcsE76e4ibIeRjHiRpIpRYOQzF64EEfQak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717740985; c=relaxed/simple;
	bh=T5qiTukQ83BUdnwawGBRne2wENjElTubZESdGgTbzkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jM/jdxn+5+pzjmGiwSgy3+zsocHCYMaxjvwnn0Q8ux1o0pzP8mpr9RPPYsWY+dgmIEYL5Il4RnSKJFEhPcV4EJvDDMQUB91r1OdhtvC5W10a81SmwaKNAY2/Us0EvB3AZw0KxsCr3nMYrtRxskVILkQlXRChpaOtRsJB1csacE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AZqpuK0v; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6JfsCqcn; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AZqpuK0v; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=6JfsCqcn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AZqpuK0v";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6JfsCqcn";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AZqpuK0v";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6JfsCqcn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 609E91FB81;
	Fri,  7 Jun 2024 06:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717740981; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SHoMRi67YFXr24VW/2m+SfX3nUx/QKU2B2W/8riq+oA=;
	b=AZqpuK0v9UMSlQi27m2zCScuWFueLSvZNOVXwJSDZcPlYMD8W30ThSjBY41vssFoxGBmC6
	o2was3LyD6otClnQR7kIpwgxXkqYBk1MsORQi2l7HFFrxSQyeLUaFRxEiMumZUBrKubiA/
	Sb66iYy2Z48YHNocQqE1BTR0WmLwGlc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717740981;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SHoMRi67YFXr24VW/2m+SfX3nUx/QKU2B2W/8riq+oA=;
	b=6JfsCqcnPioAzrXx+TC5yMXhoLX1+II+tDBM7kukqEy30Qai95C2FdGXWaZUNQR9v0MXTM
	ki3AVYEYni8iWrAA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717740981; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SHoMRi67YFXr24VW/2m+SfX3nUx/QKU2B2W/8riq+oA=;
	b=AZqpuK0v9UMSlQi27m2zCScuWFueLSvZNOVXwJSDZcPlYMD8W30ThSjBY41vssFoxGBmC6
	o2was3LyD6otClnQR7kIpwgxXkqYBk1MsORQi2l7HFFrxSQyeLUaFRxEiMumZUBrKubiA/
	Sb66iYy2Z48YHNocQqE1BTR0WmLwGlc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717740981;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SHoMRi67YFXr24VW/2m+SfX3nUx/QKU2B2W/8riq+oA=;
	b=6JfsCqcnPioAzrXx+TC5yMXhoLX1+II+tDBM7kukqEy30Qai95C2FdGXWaZUNQR9v0MXTM
	ki3AVYEYni8iWrAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3A4ED133F3;
	Fri,  7 Jun 2024 06:16:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2EX3CLSlYmZEYAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 07 Jun 2024 06:16:20 +0000
Message-ID: <40991d1b-d42d-401f-9281-5293b3e1b173@suse.de>
Date: Fri, 7 Jun 2024 08:16:20 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] block: remove the blk_flush_integrity call in
 blk_integrity_unregister
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
 <20240607055912.3586772-6-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240607055912.3586772-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.989];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,lst.de:email,suse.de:email]
X-Spam-Score: -4.29
X-Spam-Flag: NO

On 6/7/24 07:58, Christoph Hellwig wrote:
> Now that there are no indirect calls for PI processing there is no
> way to dereference a NULL pointer here.  Additionally drivers now always
> freeze the queue (or in case of stacking drivers use their internal
> equivalent) around changing the integrity profile.
> 
> This is effectively a revert of commit 3df49967f6f1 ("block: flush the
> integrity workqueue in blk_integrity_unregister").
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-integrity.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/block/blk-integrity.c b/block/blk-integrity.c
> index 17d37badfbb8bc..24f04575096d39 100644
> --- a/block/blk-integrity.c
> +++ b/block/blk-integrity.c
> @@ -401,8 +401,6 @@ void blk_integrity_unregister(struct gendisk *disk)
>   	if (!bi->tuple_size)
>   		return;
>   
> -	/* ensure all bios are off the integrity workqueue */
> -	blk_flush_integrity();
>   	blk_queue_flag_clear(QUEUE_FLAG_STABLE_WRITES, disk->queue);
>   	memset(bi, 0, sizeof(*bi));
>   }

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

