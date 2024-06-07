Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BC21BC2F;
	Fri,  7 Jun 2024 06:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717741018; cv=none; b=ciXoKUjU3akHQIPsVTmkrreUjF5W+rcDylQeQU+aTSrBrZUcPJcdyCmXfVDFXJcI09VzDXcBV4RoCSR7abUVt0OlF21q9ClvDVB+3D5A36kLhnWy4M72sTd9eqowFf3+ghGdwDBojctLYnMCHSd13NKQlQ0VziRq6ffkSYDCgeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717741018; c=relaxed/simple;
	bh=ZS72ovf1NuKKsVTa+gbRDOQpriY0UOnJoXX6Q1Fkfr4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bMxvG3AVNrSuletTk1dGt0cDHDCDQ4flgURA+aCfmJY+HwZuT/J6xBoOKCxuPzadK5+hNNM+5hsFb3NRDobqTVUkIIzy/J05kL9UgmBDbnJDtgDWjuQO27Ds7GZtsLOVzVY15mJbHFwHPJKvlheFORTL0YDtj7ncuJp6KEtifXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=E+pN/UqJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3LfYFCsC; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=E+pN/UqJ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3LfYFCsC; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="E+pN/UqJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3LfYFCsC";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="E+pN/UqJ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3LfYFCsC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 54FCC1FB81;
	Fri,  7 Jun 2024 06:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717741015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=al8SITxWTc6HwyedyVkaWtcrdqYPE8wNuPMrOM/oRzc=;
	b=E+pN/UqJ0V2K/1mCseYswFqlvlZp1b0Hx+Nn+SgSVhdF3w/Rj8TjCTlCwIzQS7Y5mS8fPs
	UYQYFkpCKkO2YCsT1xSbfTDkCWTi9hlnR9Ewem+yDuSRwCFYIaZc9zMsoG1UignWaN86Bd
	wsQ1xeDdDx8aAYkTYkA7URmeVsbpO0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717741015;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=al8SITxWTc6HwyedyVkaWtcrdqYPE8wNuPMrOM/oRzc=;
	b=3LfYFCsCdgIfeiMeAAAu3hxp4RmIXSviDRzVROhAMTcpvSZbE7Hh61KgJAU9Y2eF8Z5F9A
	hp/7j408Fvgf+jDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1717741015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=al8SITxWTc6HwyedyVkaWtcrdqYPE8wNuPMrOM/oRzc=;
	b=E+pN/UqJ0V2K/1mCseYswFqlvlZp1b0Hx+Nn+SgSVhdF3w/Rj8TjCTlCwIzQS7Y5mS8fPs
	UYQYFkpCKkO2YCsT1xSbfTDkCWTi9hlnR9Ewem+yDuSRwCFYIaZc9zMsoG1UignWaN86Bd
	wsQ1xeDdDx8aAYkTYkA7URmeVsbpO0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1717741015;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=al8SITxWTc6HwyedyVkaWtcrdqYPE8wNuPMrOM/oRzc=;
	b=3LfYFCsCdgIfeiMeAAAu3hxp4RmIXSviDRzVROhAMTcpvSZbE7Hh61KgJAU9Y2eF8Z5F9A
	hp/7j408Fvgf+jDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E8E8133F3;
	Fri,  7 Jun 2024 06:16:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GKOTENalYmZEYAAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 07 Jun 2024 06:16:54 +0000
Message-ID: <bb87fe27-2235-4515-9ca6-b2a7ff113f67@suse.de>
Date: Fri, 7 Jun 2024 08:16:54 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] block: factor out flag_{store,show} helper for
 integrity
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
 <20240607055912.3586772-7-hch@lst.de>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20240607055912.3586772-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.29
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.990];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,imap1.dmz-prg2.suse.org:helo,lst.de:email]

On 6/7/24 07:59, Christoph Hellwig wrote:
> Factor the duplicate code for the generate and verify attributes into
> common helpers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>   block/blk-integrity.c | 53 +++++++++++++++++++++----------------------
>   1 file changed, 26 insertions(+), 27 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

