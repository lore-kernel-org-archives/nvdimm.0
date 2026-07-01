Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D88437FF7B
	for <nvdimm@lists.linux.dev>; Wed,  1 Jul 2026 06:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782886412; cv=none; b=Xj8vFJYc1hOGckzp3m6V6bLOAsHNyT6g/ncfKSYyspB2lzPqrpu7THuHxDX2JRv6pN7upy4U+WmZ99f9zp6YMPEtfFalpNFu6dnU0osr7RJedTALypj2MOaNuqREkcMNOA1hKzChbGnMBG6TUTK88HXg+uM56KI4gurn9bTJJzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782886412; c=relaxed/simple;
	bh=5IugnX6ei1qX95xqi+Dab5Sz2YMHXwt1aK+XcCyrIao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aRMWh3OpAYCDaQsKVA3GuZirqidCSWnDy7O77vHKv+e9okv2TaKA+0nkLq9R5/nsbSHZ7S7TS2EXR/YEO1L1yRMjcDM7bTCxqRC2U6ERMK1zEFsKgSfEu19FdXBoBIDmp9EB95pv9Ne3BxVAxqeA3dpxFF77ESYcfpI1sDv0abA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nVkPquKq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IgLbW7hT; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nVkPquKq; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IgLbW7hT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nVkPquKq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IgLbW7hT";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nVkPquKq";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IgLbW7hT"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 386CC75FA2;
	Wed,  1 Jul 2026 06:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782886409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYQUm/ch17JGjQTwSu+BBLhvek6prevgXa6ce8KlIcw=;
	b=nVkPquKqfnuglwRA64kO/65FlsWtnZVcUr3tQjW84mZEt5kIK1Id+IAvCnd8COFWAMIdCN
	A+LLI/gXRqAumQ6m6nZvELRBDLiulChfZexd6Z8RaTTDRKPx8SMbetsUAzw04D6Lu6YrUo
	3Tt20D3L669qjQts1PWJhNHngCyL2zI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782886409;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYQUm/ch17JGjQTwSu+BBLhvek6prevgXa6ce8KlIcw=;
	b=IgLbW7hT3Aoo3CqPjJU1FBDZYQCfBqX2sBw4KqeELLYrzoJwo6zrbQBzA6udP+eNK09Hw4
	2Irk1zJbX7sxlFAg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782886409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYQUm/ch17JGjQTwSu+BBLhvek6prevgXa6ce8KlIcw=;
	b=nVkPquKqfnuglwRA64kO/65FlsWtnZVcUr3tQjW84mZEt5kIK1Id+IAvCnd8COFWAMIdCN
	A+LLI/gXRqAumQ6m6nZvELRBDLiulChfZexd6Z8RaTTDRKPx8SMbetsUAzw04D6Lu6YrUo
	3Tt20D3L669qjQts1PWJhNHngCyL2zI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782886409;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KYQUm/ch17JGjQTwSu+BBLhvek6prevgXa6ce8KlIcw=;
	b=IgLbW7hT3Aoo3CqPjJU1FBDZYQCfBqX2sBw4KqeELLYrzoJwo6zrbQBzA6udP+eNK09Hw4
	2Irk1zJbX7sxlFAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 88874779AA;
	Wed,  1 Jul 2026 06:13:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9virHwiwRGoNTQAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 01 Jul 2026 06:13:28 +0000
Message-ID: <abde41f0-7d40-42ba-a232-cc0538cd0e4b@suse.de>
Date: Wed, 1 Jul 2026 08:13:28 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, alison.schofield@intel.com, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <akQ_xlJtXNgnGUdf@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <akQ_xlJtXNgnGUdf@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[28];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RL7dfuuh4jrqtijtc3c3mfetss)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid]
X-Spam-Level: 

On 7/1/26 12:14 AM, Gregory Price wrote:
> On Tue, Jun 30, 2026 at 05:18:41PM -0400, Gregory Price wrote:
>> There is no atomic mechanism to offline and remove an entire
>> multi-block DAX kmem device.  This is presently done in two steps:
> 
> ... snip snip snip ...
> 
> Sashiko pointed out a false-positive, but adding a fixup patch
> here that adds additional consistency.
> 
> On total failure - release all resources.  This makes the sysfs
> interface consistent with the probe failure path.
> 

Speaking of which ...
With this patch we now have _two_ interfaces to do the same thing.
And both will be generating uevents.
Which is far from ideal (one could easily envision _conflicting_
udev rules, one set doing an 'online' on the old interface,
and another set doing an 'offline' on the new interface...)
Is there a way to not sending uevents for the old interface
or to make it configurable?
The old interface had the nasty side effect of generating
_tons_ of uevents during booting, and on larger machines we
even had seen udev acting as a fork-bomb during booting,
taking down the entire machine (we had to restrict udev
to 512 threads max to avoid that from happening).
So if we could disable uevents for the old interface
things would be _so_ much easier ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
