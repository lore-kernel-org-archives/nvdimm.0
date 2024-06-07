Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDB213F43A;
	Fri,  7 Jun 2024 06:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717740686; cv=none; b=blY1iNhgJLsn+KAme8+4Fx3dqENAlNwu19+3whKDOLBQTIJ748indBedhgjpZadPEZC45b8S9hC2epiAKNlh27XmSEna6FQnrd+JFnEWlJHySCVUT1sRQueOoILrOmOWaWx5cxhPpxaOa8ZwHIpUQJhSrhoSiBniS9JAko+6mkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717740686; c=relaxed/simple;
	bh=i/EYipB0iJCI2ABmPMYNrWh/KGwBXvgaAV+NUHhFUuc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UBgX46Pmlz1fELRyhHlAslRDy+dYnwtoqaFSy1H9vKBgnYhSqkyNvY6Fn8E6mHBVjVO/GCmuuqNTNiBWThtoVFoRpg0DSIcAHOFj9BQDL3FMiNXGpAlNRzuiv/A9r7VtjjDyaPTOsLwo0dYN7I8phaQu05nWASjLhVaqcVeVc2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mL29cYRW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NZNv9Bn6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=mL29cYRW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NZNv9Bn6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mL29cYRW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NZNv9Bn6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="mL29cYRW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NZNv9Bn6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9409D21AF8;
	Fri,  7 Jun 2024 06:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717740682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RvqliOnmKfjiMZl0V1XZynI3cF2Xpc2ZtFB1HlXqiHo=;
	b=mL29cYRW1f23r4FVBRbYR68plEQFrexctQayRPO2D9AstwLPEI6uBM3x7OBH4ohZ1ucVeq
	Lh2RN7Euhe/g2Tu3oAnHQj14uB76Bn/IWEme7jksPh1U/lqNyvha9QdUVlQK3GhvP4DmT6
	OTX1tmQSjXRAz+8lk/RRBuyb9PSfJ+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717740682;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RvqliOnmKfjiMZl0V1XZynI3cF2Xpc2ZtFB1HlXqiHo=;
	b=NZNv9Bn67bWQM3WcXHyVwNWhhFB7+tcv3blRovrJXywEe6NBIujRzGEmozgyEBpidXPD9v
	ZTf0LF4cOq4/foCQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mL29cYRW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NZNv9Bn6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717740682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RvqliOnmKfjiMZl0V1XZynI3cF2Xpc2ZtFB1HlXqiHo=;
	b=mL29cYRW1f23r4FVBRbYR68plEQFrexctQayRPO2D9AstwLPEI6uBM3x7OBH4ohZ1ucVeq
	Lh2RN7Euhe/g2Tu3oAnHQj14uB76Bn/IWEme7jksPh1U/lqNyvha9QdUVlQK3GhvP4DmT6
	OTX1tmQSjXRAz+8lk/RRBuyb9PSfJ+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717740682;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RvqliOnmKfjiMZl0V1XZynI3cF2Xpc2ZtFB1HlXqiHo=;
	b=NZNv9Bn67bWQM3WcXHyVwNWhhFB7+tcv3blRovrJXywEe6NBIujRzGEmozgyEBpidXPD9v
	ZTf0LF4cOq4/foCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B11A133F3;
	Fri,  7 Jun 2024 06:11:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sAVvHImkYmbBXgAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 07 Jun 2024 06:11:21 +0000
Message-ID: <be9b4b44-3edc-4267-9927-12ba2e55e61c@suse.de>
Date: Fri, 7 Jun 2024 08:11:21 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/11] block: remove the BIP_IP_CHECKSUM flag
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
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 Bart Van Assche <bvanassche@acm.org>, Kanchan Joshi <joshi.k@samsung.com>
References: <20240607055912.3586772-1-hch@lst.de>
 <20240607055912.3586772-4-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240607055912.3586772-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9409D21AF8
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,suse.de:dkim,suse.de:email]

On 6/7/24 07:58, Christoph Hellwig wrote:
> Remove the BIP_IP_CHECKSUM as sd can just look at the per-disk
> checksum type instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>   block/bio-integrity.c | 3 ---
>   drivers/scsi/sd.c     | 6 +++---
>   include/linux/bio.h   | 5 ++---
>   3 files changed, 5 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

