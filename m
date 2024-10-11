Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D34320B1F3
	for <nvdimm@lists.linux.dev>; Fri, 11 Oct 2024 09:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728640751; cv=none; b=SOSJjXfYtsYKGF4MmrtKqd+JV1/NmIjW4cYFpli1AS5j/DlEec4CnQ/nPqtp3NnSSzNrmFqDpfnz45gBWS8zCF05bokVw+cJk5o3XK0LPeYRWqDWuW7PYRyxRZp0M2WgT4SYce2JxxLZrVJ312qGr127yH3Fbpclg2dekjcSp3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728640751; c=relaxed/simple;
	bh=5gafY4ZT7avuy7Y1VqEpCA311SEKnqvcV+aZVGStUgg=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=UfMCS21p8qHNSRCL4HlVHoafBsBcWh8FQCx1V8kapgFc2nTsnoawyjPuDpctnvjEC2U4tQJeEZh4jHroAkn6uhgl5t976G9rKjTR2mgdyKKRtgnplfoWxMusq4eqEkTpWo+kRxEu63vKIm++dW/3RUkW4q5kkooHqkS/rU0YAZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b6vI41Ym; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0VjNHFwi; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=b6vI41Ym; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=0VjNHFwi; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b6vI41Ym";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0VjNHFwi";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="b6vI41Ym";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="0VjNHFwi"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 23D611FF72
	for <nvdimm@lists.linux.dev>; Fri, 11 Oct 2024 09:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728640748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5gafY4ZT7avuy7Y1VqEpCA311SEKnqvcV+aZVGStUgg=;
	b=b6vI41YmSM0jvS7R0CRmy9Nib++PwnCm2PXfMA/cHvhkOvltnRN/oR+88YD3kxLZJWYdGr
	81ETddyaAIrSWAPosqYVfKOFihR7k1lU43AvWBcQWF0iibdGoNR4fFw0P0KgiYwI2xXKP1
	+DANreBVdUiBkfR0Lx93R2EtYboWsZM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728640748;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5gafY4ZT7avuy7Y1VqEpCA311SEKnqvcV+aZVGStUgg=;
	b=0VjNHFwiW3xno0NHeef4ktjfKjOU0UGpQKDvEKF7FbX0pGw3EkQJA3D43uJN3oV3oSkAXq
	jZivsilTvhcB/WAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=b6vI41Ym;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0VjNHFwi
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1728640748; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5gafY4ZT7avuy7Y1VqEpCA311SEKnqvcV+aZVGStUgg=;
	b=b6vI41YmSM0jvS7R0CRmy9Nib++PwnCm2PXfMA/cHvhkOvltnRN/oR+88YD3kxLZJWYdGr
	81ETddyaAIrSWAPosqYVfKOFihR7k1lU43AvWBcQWF0iibdGoNR4fFw0P0KgiYwI2xXKP1
	+DANreBVdUiBkfR0Lx93R2EtYboWsZM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1728640748;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5gafY4ZT7avuy7Y1VqEpCA311SEKnqvcV+aZVGStUgg=;
	b=0VjNHFwiW3xno0NHeef4ktjfKjOU0UGpQKDvEKF7FbX0pGw3EkQJA3D43uJN3oV3oSkAXq
	jZivsilTvhcB/WAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F3C31370C
	for <nvdimm@lists.linux.dev>; Fri, 11 Oct 2024 09:59:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zNYUE+v2CGcMOQAAD6G6ig
	(envelope-from <colyli@suse.de>)
	for <nvdimm@lists.linux.dev>; Fri, 11 Oct 2024 09:59:07 +0000
From: Coly Li <colyli@suse.de>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Removing a misleading warning message?
Message-Id: <15237B14-B55B-4737-9A98-D76AEDB4AEAD@suse.de>
Date: Fri, 11 Oct 2024 17:58:52 +0800
To: nvdimm@lists.linux.dev
X-Mailer: Apple Mail (2.3776.700.51)
X-Rspamd-Queue-Id: 23D611FF72
X-Spam-Score: -2.67
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.67 / 50.00];
	BAYES_HAM(-2.16)[96.00%];
	SUBJECT_ENDS_QUESTION(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[nvdimm@lists.linux.dev];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	APPLE_MAILER_COMMON(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:mid,suse.de:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Hi list,

Recently I have a report for a warning message from CXL subsystem,
[ 48.142342] cxl_port port2: Couldn't locate the CXL.cache and CXL.mem =
capability array header.
[ 48.144690] cxl_port port3: Couldn't locate the CXL.cache and CXL.mem =
capability array header.
[ 48.144704] cxl_port port3: HDM decoder capability not found
[ 48.144850] cxl_port port4: Couldn't locate the CXL.cache and CXL.mem =
capability array header.
[ 48.144859] cxl_port port4: HDM decoder capability not found
[ 48.170374] cxl_port port6: Couldn't locate the CXL.cache and CXL.mem =
capability array header.
[ 48.172893] cxl_port port7: Couldn't locate the CXL.cache and CXL.mem =
capability array header.
[ 48.174689] cxl_port port7: HDM decoder capability not found
[ 48.175091] cxl_port port8: Couldn't locate the CXL.cache and CXL.mem =
capability array header.
[ 48.175105] cxl_port port8: HDM decoder capability not found

After checking the source code I realize this is not a real bug, just a =
warning message that expected device was not detected.
But from the above warning information itself, users/customers are =
worried there is something wrong (IMHO indeed not).

Is there any chance that we can improve the code logic that only =
printing out the warning message when it is really a problem to be =
noticed?=20

Thanks in advance.

Coly Li=20=
