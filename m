Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DCF2E84A;
	Fri,  7 Jun 2024 06:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717741322; cv=none; b=HKaiWdZSzW517W7rtBCKSHTkmZXrLq6L6GU7dnclu2B2eVP7xi69CnNpJNbrHAHppRhrZlD3oVlSEzhpV0qNgW2dRLKLUGkYX415WNWYuVzq/wMkWMEIb/almDIvnh2O/NW6y3cVE5eyw7lsITUDwqg/Nt1QS0R2ahDRsNyaC6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717741322; c=relaxed/simple;
	bh=XrYmy5LnN3y15f1gWeKbF+lezC3Y5nc10BN9Jnasm2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CrdG1dl2pFPdf3fwWiVxXb9Ki7piHxV/9MCkHcC+P2Hx5Wwtuci2AusP9BgLOrESrvluqMgT0LiovmR25IqCbcKBtszhqk514LQfq+vvD90gT8vnLCRe3ls7nC/2D41/RyQfyaZW+wDhvRqB1Mqnj5qZF2AYwGpmSJflM9kPe1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DsSzyneZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vWXNs0gh; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DsSzyneZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vWXNs0gh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DsSzyneZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vWXNs0gh";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DsSzyneZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vWXNs0gh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B7AD621B47;
	Fri,  7 Jun 2024 06:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717741318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WaemESl57lfqptUDNpmGBWES97DgowPxufI/sNy55z0=;
	b=DsSzyneZ49TQZPCDBz4/PVFPOLqdc/GuMpySMYvu/3h/pmh0/3Yzd61ZiXygE/Nck9Vzkj
	PHdx0Vcqn0kO5L73PpHXHJa8oA534KE2MRy+/0g7MQxS4vqpzZVg4cTZ/wpoxGzuyF3+dz
	XYFrp5/a23wV2pyjadHn4Wx63oBAx3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717741318;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WaemESl57lfqptUDNpmGBWES97DgowPxufI/sNy55z0=;
	b=vWXNs0gh/OZqFxAO1wqHuIVN2EK1ujrSZscPcL7zMfCaRDFh+7b4gJ8NbV6EkQqtsSSt2Z
	eJWFDXBF5MfSWYAw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717741318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WaemESl57lfqptUDNpmGBWES97DgowPxufI/sNy55z0=;
	b=DsSzyneZ49TQZPCDBz4/PVFPOLqdc/GuMpySMYvu/3h/pmh0/3Yzd61ZiXygE/Nck9Vzkj
	PHdx0Vcqn0kO5L73PpHXHJa8oA534KE2MRy+/0g7MQxS4vqpzZVg4cTZ/wpoxGzuyF3+dz
	XYFrp5/a23wV2pyjadHn4Wx63oBAx3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717741318;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WaemESl57lfqptUDNpmGBWES97DgowPxufI/sNy55z0=;
	b=vWXNs0gh/OZqFxAO1wqHuIVN2EK1ujrSZscPcL7zMfCaRDFh+7b4gJ8NbV6EkQqtsSSt2Z
	eJWFDXBF5MfSWYAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A96C2133F3;
	Fri,  7 Jun 2024 06:21:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sBMBJwWnYmaVYQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 07 Jun 2024 06:21:57 +0000
Message-ID: <2be1eba2-e332-4b61-a2cb-ee1441315ff2@suse.de>
Date: Fri, 7 Jun 2024 08:21:57 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/11] block: invert the BLK_INTEGRITY_{GENERATE,VERIFY}
 flags
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
 <20240607055912.3586772-11-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240607055912.3586772-11-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.989];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.de:email,nvidia.com:email,lst.de:email];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,lst.de:email,nvidia.com:email]

On 6/7/24 07:59, Christoph Hellwig wrote:
> Invert the flags so that user set values will be able to persist
> revalidating the integrity information once we switch the integrity
> information to queue_limits.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>   block/bio-integrity.c         |  4 ++--
>   block/blk-integrity.c         | 18 +++++++++---------
>   include/linux/blk-integrity.h |  4 ++--
>   3 files changed, 13 insertions(+), 13 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

