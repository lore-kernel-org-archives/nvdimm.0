Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9604114F110;
	Fri,  7 Jun 2024 06:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717740607; cv=none; b=LQoGaKICcnRy0xvKtqGObq9YKW0QbETY/HTzUJjlEK3H3g496PJlSZdV/bNDZjljqBAfCQqmiiIXtUc5cgKIyalMytAi5RotH6KrAU/OH7vKVTUVwWYBeqGXUl4aETFi9/L+Hss1X9oprMZ4o3L0Y6H/KicUhwUAGlQeunLQ6ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717740607; c=relaxed/simple;
	bh=a21Ymn5IawAllvPUebaEavu6EuO0TgXwfG1O9vN+zmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NElQ6e0+xDKvxrvjQOyQwN240Rd9ci4w0bRzV9CyvsJa9Ro4sx8FtZU3IivUL6SAJDMTRxBgMseRMRkkYB5Cg0f229gyrZf8ghlCEHdiIS7Sk8QcZ/Pfao/sUxrc2xRzhChmIN5pAnSROritMWuHP4iB1Jxv70PEvLtUYNA193E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2XyDnxCV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nbp8I1Ae; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=2XyDnxCV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nbp8I1Ae; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2XyDnxCV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nbp8I1Ae";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="2XyDnxCV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nbp8I1Ae"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7FE8421AF8;
	Fri,  7 Jun 2024 06:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717740603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vcAZgMGv5uCjKks7xsO1WGWQ4FtmR4EYjMR6EHCFmao=;
	b=2XyDnxCVPn+7cSrs1lsU4/sKcgqUO5wLX+JKJMqOBnlhlwLkcHgZF3mAMyTAckO1pk1teW
	5amLozEhfhyZnBkqPqgp6yZ7Z1o+8ZKxPzQr37ltupd2ugD4MY+DRaQlMkdq1cRJ/4iE5s
	ofBj7XJhhqyaQ7QTjZNfUgbUVUjaffg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717740603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vcAZgMGv5uCjKks7xsO1WGWQ4FtmR4EYjMR6EHCFmao=;
	b=nbp8I1Ae6sOzehtpt0NzBx9pl6e99WeUsGsLxlh8M54FuCIk3o28btbOMt3TooLwMrK1BP
	qLW1BvT3PlTwShBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2XyDnxCV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nbp8I1Ae
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717740603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vcAZgMGv5uCjKks7xsO1WGWQ4FtmR4EYjMR6EHCFmao=;
	b=2XyDnxCVPn+7cSrs1lsU4/sKcgqUO5wLX+JKJMqOBnlhlwLkcHgZF3mAMyTAckO1pk1teW
	5amLozEhfhyZnBkqPqgp6yZ7Z1o+8ZKxPzQr37ltupd2ugD4MY+DRaQlMkdq1cRJ/4iE5s
	ofBj7XJhhqyaQ7QTjZNfUgbUVUjaffg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717740603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vcAZgMGv5uCjKks7xsO1WGWQ4FtmR4EYjMR6EHCFmao=;
	b=nbp8I1Ae6sOzehtpt0NzBx9pl6e99WeUsGsLxlh8M54FuCIk3o28btbOMt3TooLwMrK1BP
	qLW1BvT3PlTwShBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B15CF133F3;
	Fri,  7 Jun 2024 06:10:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GWdWKTqkYmbBXgAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 07 Jun 2024 06:10:02 +0000
Message-ID: <2fac9e43-151c-46ef-b81c-4c6f371a3590@suse.de>
Date: Fri, 7 Jun 2024 08:10:01 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] dm-integrity: use the nop integrity profile
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
 Milan Broz <gmazyland@gmail.com>
References: <20240607055912.3586772-1-hch@lst.de>
 <20240607055912.3586772-2-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240607055912.3586772-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.50 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,redhat.com,huawei.com,intel.com,grimberg.me,nvidia.com,vger.kernel.org,lists.linux.dev,lists.infradead.org,gmail.com];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,suse.de:dkim,suse.de:email];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7FE8421AF8
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -4.50

On 6/7/24 07:58, Christoph Hellwig wrote:
> Use the block layer built-in nop profile instead of duplicating it.
> 
> Tested by:
> 
> $ dd if=/dev/urandom of=key.bin bs=512 count=1
> 
> $ cryptsetup luksFormat -q --type luks2 --integrity hmac-sha256 \
>   	--integrity-no-wipe /dev/nvme0n1 key.bin
> $ cryptsetup luksOpen /dev/nvme0n1 luks-integrity --key-file key.bin
> 
> and then doing mkfs.xfs and simple I/O on the mount file system.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Milan Broz <gmazyland@gmail.com>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>   drivers/md/dm-crypt.c     |  4 ++--
>   drivers/md/dm-integrity.c | 20 --------------------
>   2 files changed, 2 insertions(+), 22 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

