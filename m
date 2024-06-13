Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C06144D34;
	Thu, 13 Jun 2024 13:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718286041; cv=none; b=YeHWvuvexFH4w5UAzC1oz4INsjh0XXtvsXVrcF/B+ySy4UPoKwJ2T3eTKXe0kmj8MmG/96fGqZlqP6Gg1+GNvw6rLzwR3BW2czUgwsaZ1pqwuKYx7ZJtz2UZ98It+3XhixB9dOjBdMgGRDsNtkn08pAc1i0F5vLaJtYNS/F0uQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718286041; c=relaxed/simple;
	bh=5x2tr/c47eGH0UqX1yJcGB4nj1JF6JFSSjyLYFm56+8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SAJLx9SgwfTAVv+hhroQs+7PTdE2OZor0OSxTGbWi0p4paOCOwDwFXrCyuH4ej7k2YWZwxhpIXs+KrEg/WjB2BC0G8g8hwVYyVofiqRiC6y8zoW0S9zk16xsq/jmeaaj95GQ2pbn3LkB86FF3N2RRWF/aLpo4r8UJChy9f0jlZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hb22nKVe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KXEgcG1y; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=hb22nKVe; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=KXEgcG1y; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hb22nKVe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KXEgcG1y";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="hb22nKVe";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="KXEgcG1y"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 73B1A37229;
	Thu, 13 Jun 2024 13:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718286037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iJBzu8xkHvqARXEasLdKwhnxPndyRRjGj5ylB7pzv9o=;
	b=hb22nKVeViWDEo6mwYbFmXvGv3iDM3Ql0OTlDiQbdpWmDgBI0y99XFKs2c6uyQL7IuyZlJ
	kKMQe6lRTA1cn53YwkdNxtpq3ZUeADuDo9H8i4iaMMg7RRMujZwHcDAYFuFmHJmd3vamB7
	hzfKmzgZjwlXtFtaUYuIZxzYVqJwiv4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718286037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iJBzu8xkHvqARXEasLdKwhnxPndyRRjGj5ylB7pzv9o=;
	b=KXEgcG1yv7o3tP6dKcziYgARlsIQBaKVXOueq6233SAksmG0NWdl1c3QL6mk1gKQQrQxRR
	QMrQ9ef+OXJSohDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hb22nKVe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=KXEgcG1y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1718286037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iJBzu8xkHvqARXEasLdKwhnxPndyRRjGj5ylB7pzv9o=;
	b=hb22nKVeViWDEo6mwYbFmXvGv3iDM3Ql0OTlDiQbdpWmDgBI0y99XFKs2c6uyQL7IuyZlJ
	kKMQe6lRTA1cn53YwkdNxtpq3ZUeADuDo9H8i4iaMMg7RRMujZwHcDAYFuFmHJmd3vamB7
	hzfKmzgZjwlXtFtaUYuIZxzYVqJwiv4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1718286037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iJBzu8xkHvqARXEasLdKwhnxPndyRRjGj5ylB7pzv9o=;
	b=KXEgcG1yv7o3tP6dKcziYgARlsIQBaKVXOueq6233SAksmG0NWdl1c3QL6mk1gKQQrQxRR
	QMrQ9ef+OXJSohDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3E7F913A87;
	Thu, 13 Jun 2024 13:40:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6i/gDNX2amYZPwAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 13 Jun 2024 13:40:37 +0000
Message-ID: <bc0d7973-1b5a-4735-ae87-0fb49f4e04b2@suse.de>
Date: Thu, 13 Jun 2024 15:40:36 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/12] block: move integrity information into queue_limits
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
References: <20240613084839.1044015-1-hch@lst.de>
 <20240613084839.1044015-13-hch@lst.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240613084839.1044015-13-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 73B1A37229
X-Spam-Score: -4.50
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[20];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:email,suse.de:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

On 6/13/24 10:48, Christoph Hellwig wrote:
> Move the integrity information into the queue limits so that it can be
> set atomically with other queue limits, and that the sysfs changes to
> the read_verify and write_generate flags are properly synchronized.
> This also allows to provide a more useful helper to stack the integrity
> fields, although it still is separate from the main stacking function
> as not all stackable devices want to inherit the integrity settings.
> Even with that it greatly simplifies the code in md and dm.
> 
> Note that the integrity field is moved as-is into the queue limits.
> While there are good arguments for removing the separate blk_integrity
> structure, this would cause a lot of churn and might better be done at a
> later time if desired.  However the integrity field in the queue_limits
> structure is now unconditional so that various ifdefs can be avoided or
> replaced with IS_ENABLED().  Given that tiny size of it that seems like
> a worthwhile trade off.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   Documentation/block/data-integrity.rst |  49 +-------
>   block/blk-integrity.c                  | 124 ++-----------------
>   block/blk-settings.c                   | 118 +++++++++++++++++-
>   block/t10-pi.c                         |  12 +-
>   drivers/md/dm-core.h                   |   1 -
>   drivers/md/dm-integrity.c              |  27 ++---
>   drivers/md/dm-table.c                  | 161 +++++--------------------
>   drivers/md/md.c                        |  72 +++--------
>   drivers/md/md.h                        |   5 +-
>   drivers/md/raid0.c                     |   7 +-
>   drivers/md/raid1.c                     |  10 +-
>   drivers/md/raid10.c                    |  10 +-
>   drivers/md/raid5.c                     |   2 +-
>   drivers/nvdimm/btt.c                   |  13 +-
>   drivers/nvme/host/core.c               |  70 +++++------
>   drivers/scsi/sd.c                      |   8 +-
>   drivers/scsi/sd.h                      |  12 +-
>   drivers/scsi/sd_dif.c                  |  34 +++---
>   include/linux/blk-integrity.h          |  27 ++---
>   include/linux/blkdev.h                 |  12 +-
>   include/linux/t10-pi.h                 |  12 +-
>   21 files changed, 289 insertions(+), 497 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

