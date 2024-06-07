Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D41314F9E6;
	Fri,  7 Jun 2024 06:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717741047; cv=none; b=DN7IotDN+HR4Gamr7A969rxZgXeOscWF0rrrBCnhaZ00ZPuzUrSmzHY79wDb5W6Bq2PUsv/fawCXtTpJQyWS+brwfjuWbxM9mZRyG8ZZ9BylOQ/VASVFuyzHZsYLwuqsBZguUsxnnEUdL3sGZU/FpN993mL5RddM7V8dj2/CtJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717741047; c=relaxed/simple;
	bh=DjaYR7ERe+IMXETrguYnQO6EYhGCiRei+rA+k9E2IcU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mwwMMOcVHwcNySMChe24jBVmVVTe+sCOd9UulWvpLR7AM5D6BiBq9zewDia4Dg7mf2U+3QQ1K3MuusAS1oMCyaGWZY2jOpYoqNijMk0e3HsD4JyeAYzw7iuFCBw8k9cctCyYtKAvnuTnI3fo1wGBzsogBPrtZrEHxM0VvtnQ18A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ChTKROGS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NEpozFE/; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ChTKROGS; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NEpozFE/; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ChTKROGS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NEpozFE/";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ChTKROGS";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NEpozFE/"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9E01C21B47;
	Fri,  7 Jun 2024 06:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717741044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2M0pbYzp/+9jLX6wx8JxZUgDMrmgAaeAyAKANTN8+VI=;
	b=ChTKROGSugOIdi/A8FXVQ0Q+Ny/xo/6XTpUATgDVGcIOxw238u7K6maRU3BVJDaulZBAez
	kpZQGf3CAZivdqI6Tw8LOS36w/PXrc9npbEfc5CEjpb+omRCj7xH+ATb2vQB8SAFmTD5Hv
	5rpKC1CfJ5rKYdBwKVo40CtMfs7ysBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717741044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2M0pbYzp/+9jLX6wx8JxZUgDMrmgAaeAyAKANTN8+VI=;
	b=NEpozFE/lCV2gDmmG9+zTlcPSWKqmzXJJUIYBbPd1IJeSAi0d4g89y3PND6+rmFAkWJCtd
	wq6rDbscTYprtZDw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ChTKROGS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="NEpozFE/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717741044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2M0pbYzp/+9jLX6wx8JxZUgDMrmgAaeAyAKANTN8+VI=;
	b=ChTKROGSugOIdi/A8FXVQ0Q+Ny/xo/6XTpUATgDVGcIOxw238u7K6maRU3BVJDaulZBAez
	kpZQGf3CAZivdqI6Tw8LOS36w/PXrc9npbEfc5CEjpb+omRCj7xH+ATb2vQB8SAFmTD5Hv
	5rpKC1CfJ5rKYdBwKVo40CtMfs7ysBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717741044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2M0pbYzp/+9jLX6wx8JxZUgDMrmgAaeAyAKANTN8+VI=;
	b=NEpozFE/lCV2gDmmG9+zTlcPSWKqmzXJJUIYBbPd1IJeSAi0d4g89y3PND6+rmFAkWJCtd
	wq6rDbscTYprtZDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA958133F3;
	Fri,  7 Jun 2024 06:17:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EDcfK/OlYmZEYAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 07 Jun 2024 06:17:23 +0000
Message-ID: <42862fed-2045-4a06-936b-d844187dca90@suse.de>
Date: Fri, 7 Jun 2024 08:17:23 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] block: use kstrtoul in flag_store
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
 <20240607055912.3586772-8-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240607055912.3586772-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.50
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 9E01C21B47
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,lst.de:email,nvidia.com:email]

On 6/7/24 07:59, Christoph Hellwig wrote:
> Use the text to integer helper that has error handling and doesn't modify
> the input pointer.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>   block/blk-integrity.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

