Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5CD4204F;
	Fri,  7 Jun 2024 06:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717741086; cv=none; b=rc9NfhJ34+BR53Kb3xd2lg2bOmda6vqagCLp0F/djU5i2f1KtgMR9AXK7ke3fo12orp9v24dFY5aBNxvq94bZoa6zVq0Hx8y4Ody8pTmumzplTQH9unMc0qAcgGQPxY7WVnNeTcRlI+PiFZpvwmHTf3WylLuk0Hm5TV9DaXkCd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717741086; c=relaxed/simple;
	bh=c2k60Xk6sv5jd/cZCqGPv5cEupz3AWt5o/IjBDd8Uq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gQqwQf5ULdNQJrT6WrplsJ/cgjx0TIMOP8/20yUmNGqKj9dP1IOrd3ZGVGA1snkoN0OZL9wJ9m7uDZfgx3968gE6Lr/NmifmyG/84qR9zw1xDvN+oWQUSGXWZZ9tBNaKUj0ZVMd7gMRBF7tlPHhDwD8hSQgwuDAN1rnUo7aHJGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A3OK6E3f; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=qgv2/PCd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=OTdva8hC; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lwQi3UbO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A3OK6E3f";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="qgv2/PCd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="OTdva8hC";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lwQi3UbO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C84921B47;
	Fri,  7 Jun 2024 06:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717741082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9JttketIPnK3CUu5JLRXu+4te9oL1QmKKrvUlLsQllA=;
	b=A3OK6E3fd6DC9ROrjkQgKJE0QmfFx28jPVIu1cv5ASfEDW0nbRMebWozXqSKeXtVWB+Anm
	YDS85NIXSW1cHRFKdZDcEAcAGfYrsyBCoEqLMSSTBYXR1zyHrTwpQdPtXVmUosJbjMZTGG
	qdjogUkGU/OC8+ySxv1skg/kV8Ic3Wk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717741082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9JttketIPnK3CUu5JLRXu+4te9oL1QmKKrvUlLsQllA=;
	b=qgv2/PCd3vrHta0sqsurfGf5BoPWXA5991hyzzhlZSeg4aHk8Ri6763EojuMJl3O6NW3MJ
	qwdxUx2jvy06uuAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717741081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9JttketIPnK3CUu5JLRXu+4te9oL1QmKKrvUlLsQllA=;
	b=OTdva8hCgRpKPS4y2wB89WUIEW2tkS17odt5aGnI7ZeBITL1T4qoz8tAqWOQj7HVd4RHWs
	H+0okDvDG3AHVvmfxAnDplzTHtNXe6lh2dqtyPzGg0/byMS9L5AdBpfRHBpSdRgKicZ21W
	jlSSQ0HCWjCjVnz1Iv47iWUeggPEckg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717741081;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9JttketIPnK3CUu5JLRXu+4te9oL1QmKKrvUlLsQllA=;
	b=lwQi3UbOZOHK5xZBBB8/5Hh2qPvyjchOKtANVnFEQqry+eXMwVr5AiKBbpgca82QvdsvQC
	RZo62sJgidF+mkAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA9F3133F3;
	Fri,  7 Jun 2024 06:17:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6DppKBemYmZEYAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 07 Jun 2024 06:17:59 +0000
Message-ID: <d05afd60-f306-4ec7-a97c-2c86f7b6c5bd@suse.de>
Date: Fri, 7 Jun 2024 08:17:59 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] block: don't require stable pages for non-PI
 metadata
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
 <20240607055912.3586772-9-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240607055912.3586772-9-hch@lst.de>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Score: -4.29
X-Spam-Flag: NO

On 6/7/24 07:59, Christoph Hellwig wrote:
> Non-PI metadata doesn't contain checksums and thus doesn't require
> stable pages.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-integrity.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

