Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8063C0A11
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 06:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782368260; cv=none; b=aV1YhIWzeBHDrf2RMVrEKo4Da6Nhk49N9/Mylek+Ld2FYyMOIdCgPqGcSn4DPDEBfl/T3m82cvoxb9S6/azm6sCnn/5I2/LsKMqlW7Y9nOpUodFHerVHbuW1L+imCuWnYVa+gZn4PgDkb12PLUdVNdVSdH0Nkiwu6ZuiiNb5Lok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782368260; c=relaxed/simple;
	bh=MjrRvZfIQlTaSIsENJMumq0U/x+Pmcq/letq6s5ydTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QPo0YhqBbqw6qu8nvNT4Xgr+MBb3GY1y3XBjhrMG3fYzDC7rGZgF3He3U2qgkbidZ1QdExDuH3Fc3oBugoDHjGj/Kz0Bif/l65t63waCbTIS3gIwE3Dw7RO95mnbsJ031Hpw2xrd+dXy0sbVvq52zPj7szpzT80B91iZpRRpJMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qbcZ4cUo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=YkCJXl0Q; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=n5GkZTym; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SxiLqY4c; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qbcZ4cUo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="YkCJXl0Q";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="n5GkZTym";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SxiLqY4c"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3017271833;
	Thu, 25 Jun 2026 06:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lsDZDuDxKlvNW8EPVPGqWeW6c2wLvDVP/aYJ1SGOw1s=;
	b=qbcZ4cUoNNNrBS8sol12QF8a20XBCri1pgE/tbEdP9ig/UFZv6rgUEzcBD7fEqjllibg/M
	2DamV6U48sRwmzWWHVtfG5yBHYzRzIrN4YjYuL+/AZ/KZYMdJnh7KqsYUnsiNmlqVqw+sd
	xs8bhKwszOVTMgmzHEbqt9qbD0w9zis=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368257;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lsDZDuDxKlvNW8EPVPGqWeW6c2wLvDVP/aYJ1SGOw1s=;
	b=YkCJXl0QMcZ5eO9Wh0jGxv+7rTwJYQzwe9ARpYn0YEXCxC4d23jhg0GVTLww7bCO2z3BAO
	DxQ5Hxdo5cGHW9DA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782368256; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lsDZDuDxKlvNW8EPVPGqWeW6c2wLvDVP/aYJ1SGOw1s=;
	b=n5GkZTymO0+yOwrypTZxvOLlmvqBerJvEj15XaIGob78rgtYBHPQ1psIEuTOvqOsRNcc3t
	ohqU2GpqweS7euy88WjypV8xCKCpPj4fJ5M7hInIC9kC9l8FefQfnH7SkHxPDLO4KU+es9
	tjCrQN6zsPu1BSEV2Uf6LN3Wm+Fmorc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782368256;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lsDZDuDxKlvNW8EPVPGqWeW6c2wLvDVP/aYJ1SGOw1s=;
	b=SxiLqY4czk0sQSzuZDu3RT6Wr3/E4Up9OPuVaJflrlwJbTYsGooecfrd8fqUtk8oos1KTM
	3Fc5qxS9lcGZmaAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B2A4779A8;
	Thu, 25 Jun 2026 06:17:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uH2uEP/HPGp0PQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 25 Jun 2026 06:17:35 +0000
Message-ID: <8e42587a-d614-4259-ae6b-5bca1479b425@suse.de>
Date: Thu, 25 Jun 2026 08:17:34 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 8/9] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
 kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
 gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, alison.schofield@intel.com,
 Smita.KoralahalliChannabasappa@amd.com, ira.weiny@intel.com,
 apopple@nvidia.com
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-9-gourry@gourry.net>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20260624145744.3532049-9-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[28];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MID_RHS_MATCH_FROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	R_RATELIMIT(0.00)[to_ip_from(RL7dfuuh4jrqtijtc3c3mfetss)];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gourry.net:email,suse.de:email,suse.de:mid,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 

On 6/24/26 4:57 PM, Gregory Price wrote:
> There is no atomic mechanism to offline and remove an entire
> multi-block DAX kmem device.  This is presently done in two steps:
>      1. offline all
>      2. remove all).
> 
> This creates a race condition where another entity operates directly
> on the memory blocks and can cause hot-unplug to fail / unbind to
> deadlock.
> 
> Add a new 'state' sysfs attribute that enables an atomic whole-device
> hotplug operation across its entire memory region.
> 
> daxX.Y/state mirrors the per-block memoryX/state ABI:
>    - [offline, online, online_kernel, online_movable]
>    - "unplugged" - is added specifically for dax0.0/state
> 
> The valid writable states include:
>    - "unplugged":      memory blocks are not present
>    - "online":         memory is online, zone chosen by the kernel
>    - "online_kernel":  memory is online in ZONE_NORMAL
>    - "online_movable": memory is online in ZONE_MOVABLE
> 
> Valid transitions:
>    - unplugged                -> online[_kernel|_movable]
>    - online[_kernel|_movable] -> unplugged
>    - offline                  -> unplugged
> 
> A device can only be onlined from "unplugged", so it must be returned
> there before being onlined into a different state.
> 
> For backwards compatibility the memory blocks are always created at
> probe - existing tools expect them to be present after kmem binds.
> 
> "offline" is therefore a reportable state but is not writable: it only
> arises from the legacy auto_online_blocks=offline policy.  Onlining
> such a device through this attribute requires unplugging it first in
> an effort to get drivers creating DAX devices to set a default.
> 
> Unplug is atomic across the whole device: dax_kmem_do_hotremove()
> collects every added range and offlines/removes them in one operation.
> Either the operation succeeds or is entirely rolled back.
> 
> Unbind Note:
>    We used to call remove_memory() during unbind, which would fire a
>    BUG() if any of the memory blocks were online at that time.  We lift
>    this into a WARN in the cleanup routine and don't attempt hotremove
>    if ->state is not DAX_KMEM_UNPLUGGED or MMOP_OFFLINE.
> 
>    An offline dax device memory is removed on unbind as before.
> 
>    If online at unbind, the resources are leaked (as before), but now
>    we prevent deadlock if a memory region is impossible to hotremove.
> 
> Suggested-by: Hannes Reinecke <hare@suse.de>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   Documentation/ABI/testing/sysfs-bus-dax |  26 +++
>   drivers/base/memory.c                   |   9 +
>   drivers/dax/kmem.c                      | 224 ++++++++++++++++++++----
>   include/linux/memory_hotplug.h          |   1 +
>   4 files changed, 224 insertions(+), 36 deletions(-)
> 
That looks good, but question remains:

Why do we need to treat the 'unbind' call as a given thing?
If we know that we cannot handle online memory during unbind,
can't we just disallow unbind in that case?
I don't think it's too much to ask from an admin to offline
the memory first, _especially_ as now we have a simple knob
to do that ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
