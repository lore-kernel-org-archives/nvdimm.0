Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793114614;
	b=wAG82JKtRkVEEemgUf0ObCvvQUsS8x8Hw25dtbeQKsr5bywlZLqbbMBpgKqtCdlfVagO
	 lN8aHVo+14RbQNqTourXuYHzN5tU7VS63b1jw3FwXmL7pvzyrxcQxlkv1Odd/BMw4aSoi
	 NS1iRwWGRJv4hJUB5rmJoJJcieG6nhyhMAAHJf3ABEH9HR0jQ/zoNaEKjWVUJ9VQgc3mj
	 PcVY6yyUYTjP29cw/A5q7k0fSWpKtJy4cfNk8U/XlDzVbkGz0+S4vXYxi9Jx8C+vaN0KJ
	 1KKMhWL4VT0Kbs8SAV7Q+VOu4FGi/qnHF2K6iabVH7TKnorg3vJ/CIQ1cw5B3UDOKhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793114614;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=o4MCacgqmcIhu72Pqd5WSak1rE8sMgXVDdXw5pwBbUI=;
	b=W8+DkWwKMEPbyFbLr0D4VJez9iQN6lHGyMz7PR5n7+RfUF5KxulhopPa+XsP6vpQIxTg
	 mR7tRXQ8GVSVlwlsmigYnW3/sJo0rV/nmdj5p/z3zL7qmA93XW8TZg7+HfajJBnrNoZMK
	 04jw9HzcrOzXssfGQW8BkD9zBUYT/I3X1V4wpLm2eAfcbxHvhRSJP8XoP/CmepUXB7gJs
	 zxKqveVdV9QPgaM2l6g3a71H+d2m61b2LBcX/G+Pt0tfus1Jwc3f19qkvnrhq+IMYe8yH
	 z96Gg9LBI4XcCQMTzvLwr7QF30x+5TCua7rtuW1M6sMX0EsMxrpJKk8x8E+rG8fHsdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rqHpzfRS;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="1BbipH8/";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bm0pTj5e;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=tnS43vbY;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75CB606A31B
	for <nvdimm@lists.linux.dev>; Tue, 27 Oct 2026 15:23:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B75CB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rqHpzfRS;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1BbipH8/;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bm0pTj5e;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=tnS43vbY
Received: from kunlun.suse.cz (unknown [IPv6:2a07:de40:b306:2000::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 56ACB1F397;
	Tue, 27 Oct 2026 15:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793114611; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o4MCacgqmcIhu72Pqd5WSak1rE8sMgXVDdXw5pwBbUI=;
	b=rqHpzfRSfK9ucO8LjHmVaGfrwMEUNyRcVG9MGDqkONUZhCuuTQ0DK6V8o8qsEhVXiRsnR1
	DrnmsdyvkMQ7VkdFQ7NQgtta5xnVyTs2nJdW3WRko7E3bBBWV66cMDmpwETiFcm/TgQzXm
	QUzaDyOy/v7sZRnwMLHCs67Eu+q49ug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793114611;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o4MCacgqmcIhu72Pqd5WSak1rE8sMgXVDdXw5pwBbUI=;
	b=1BbipH8/K+o3T4KZL99WkZtMZ+3VFexfs85Qu+CmJJNsEgItTvEjaOFPkdOKN4AheH0qXV
	B+3KI+Vaag90sYCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bm0pTj5e;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=tnS43vbY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793114609; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o4MCacgqmcIhu72Pqd5WSak1rE8sMgXVDdXw5pwBbUI=;
	b=bm0pTj5e0VotHoX1Cn3ceSpYxEcxZv6/fhBiI+rz9yI5l1BaufrXbD+3XzVbdXgg2xrsNP
	H8M2m1djfgOU0yvWE74vPW+WK7z33CVhRU4mQoL7PCkZQOxGwVK+8zUlZdpHqWV189TKP8
	/kmVoOeN9QNTJcrBZCVoQ6XcFzk5OpM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793114609;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o4MCacgqmcIhu72Pqd5WSak1rE8sMgXVDdXw5pwBbUI=;
	b=tnS43vbYoGYklTH19QydhozF5hV+q4R7LvsQP0E12nvzYMD+wKq+Ixi5Fg78JHqi6Ihitn
	w+41Dd/JcYAn1oCw==
Date: Tue, 27 Oct 2026 16:23:28 +0100
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: nvdimm@lists.linux.dev
Subject: Re: writing to "bind" and "unbind" sysfs files now causes a kernel
 TAINT
Message-ID: <auDB8NDtiKu8qktd@kunlun.suse.cz>
References: <CAJruOm8=jt3UxrnCKAahyGY1ownbssM4+PvaSTXHJ89WjpUk2A@mail.gmail.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJruOm8=jt3UxrnCKAahyGY1ownbssM4+PvaSTXHJ89WjpUk2A@mail.gmail.com>
X-Rspamd-Queue-Id: 56ACB1F397
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-7.46 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	HFILTER_HOSTNAME_UNKNOWN(2.50)[];
	ONCE_RECEIVED(1.20)[];
	HFILTER_HELO_IP_A(1.00)[kunlun.suse.cz];
	RDNS_NONE(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-0.996];
	HFILTER_HELO_NORES_A_OR_MX(0.30)[kunlun.suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.15)[-0.747];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.de:+];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b306:2000::2:from];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim]
X-Spam-Score: -7.46

Hello

On Tue, Oct 27, 2026 at 11:11:32AM -0400, Jeff Moyer wrote:
> See:
> 10dde2bd6688 ("module: pull out add_taint_module() to be public")
> de2dbaabbc2f ("module: fix up documentation for add_taint() and
> add_taint_module()")
> fcbfaffee51a ("driver core: add TAINT_FORCED_BIND for when userspace
> manually messes with devices and drivers")
> 
> and the discussion here:
> https://lore.kernel.org/all/20260914-bind_taint-v4-0-eadf8a090903@linuxfoundation.org/
> 
> As I'm sure folks are aware, writing to "bind" is how namespaces are
> configured.  I don't know what the answer is, here.  I'm just raising
> awareness.

Is that limited to nvdimm or is cxl also using bind?

Thanks

Michal
