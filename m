Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BB92AD2C
	for <nvdimm@lists.linux.dev>; Mon, 21 Oct 2024 05:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729487148; cv=none; b=kh+14/h7r4ShmLappgWSh56lUtYjs9mSEbVMxfmUS8EcDs6WtrYceAu8eWwTzLNfo+FbaPkkHINbD5y7IN0rjueEPgHHkG4tdv9FqOcRVZxnSf0zKNIBesb3rRLeTQAsmhKecdUEfAo0onpacacOCcMRZJ/pvkgHSft7re1WfYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729487148; c=relaxed/simple;
	bh=GLrEqgmMPB/GA95v0r56PbDtB7QDhPi2djkryKyLBE8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=qHGl5jyZ31fEZAtmCWdO7rfG/5c5G/ObSpvUOPmbtpLLy4Jr7CAzLLpxSNbVm6WZ4XSkVN7d14yCI9DrZneBFsOIyWJ+rmwGMgYT7Jiuk+2+kso4hqDdeHTkozz4CQFx+3oqdGKSucJGlYw2c9DQFpBjbg+zXE2/eUxjobh8Hnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sDxgE9kY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xjfLMVup; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sDxgE9kY; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=xjfLMVup; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sDxgE9kY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xjfLMVup";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sDxgE9kY";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xjfLMVup"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3DFC221CD2;
	Mon, 21 Oct 2024 05:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729487144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5hc2OuJEyBmrL0PAyUQuGkYbobhanXgxf6/z2xVOLPk=;
	b=sDxgE9kYqySxOP8oDh/Rofz6RfiSQ8U/CHb2xtqS0vw6vFN9/4CE/E3nsUPaAGmmu3WsXX
	QJ/NDTQdBiIcmieIDxXAzqNp/tfHwZJoG7UThM0kywJgdySagk/IWF0HcTr2DmGwj4dGXL
	0DpeCvR3/Cx/ThyapQ/D2VflgxieAYQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729487144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5hc2OuJEyBmrL0PAyUQuGkYbobhanXgxf6/z2xVOLPk=;
	b=xjfLMVuprW2D4gAOC+bx0d9N9EUs8i29ov8z3bB4FldtnH8xn2B839H9YDws2dmeqUXC0h
	lcmfS+B6oniK4qDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sDxgE9kY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xjfLMVup
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1729487144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5hc2OuJEyBmrL0PAyUQuGkYbobhanXgxf6/z2xVOLPk=;
	b=sDxgE9kYqySxOP8oDh/Rofz6RfiSQ8U/CHb2xtqS0vw6vFN9/4CE/E3nsUPaAGmmu3WsXX
	QJ/NDTQdBiIcmieIDxXAzqNp/tfHwZJoG7UThM0kywJgdySagk/IWF0HcTr2DmGwj4dGXL
	0DpeCvR3/Cx/ThyapQ/D2VflgxieAYQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1729487144;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5hc2OuJEyBmrL0PAyUQuGkYbobhanXgxf6/z2xVOLPk=;
	b=xjfLMVuprW2D4gAOC+bx0d9N9EUs8i29ov8z3bB4FldtnH8xn2B839H9YDws2dmeqUXC0h
	lcmfS+B6oniK4qDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DCBB8136DC;
	Mon, 21 Oct 2024 05:05:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Jxv5JSbhFWffKQAAD6G6ig
	(envelope-from <colyli@suse.de>); Mon, 21 Oct 2024 05:05:42 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: Removing a misleading warning message?
From: Coly Li <colyli@suse.de>
In-Reply-To: <6712b7bf2c1cd_10a03294b3@dwillia2-mobl3.amr.corp.intel.com.notmuch>
Date: Mon, 21 Oct 2024 13:05:25 +0800
Cc: Alison Schofield <alison.schofield@intel.com>,
 nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B9A63332-6963-45A2-A399-7C6005399583@suse.de>
References: <15237B14-B55B-4737-9A98-D76AEDB4AEAD@suse.de>
 <ZxElg0RC_S1TY2cd@aschofie-mobl2.lan>
 <6712b7bf2c1cd_10a03294b3@dwillia2-mobl3.amr.corp.intel.com.notmuch>
To: Dan Williams <dan.j.williams@intel.com>
X-Mailer: Apple Mail (2.3776.700.51)
X-Rspamd-Queue-Id: 3DFC221CD2
X-Spam-Level: 
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	SUBJECT_ENDS_QUESTION(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_DN_SOME(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	APPLE_MAILER_COMMON(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -3.51
X-Spam-Flag: NO



> 2024=E5=B9=B410=E6=9C=8819=E6=97=A5 03:32=EF=BC=8CDan Williams =
<dan.j.williams@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Alison Schofield wrote:
>>=20
>> + linux-cxl mailing list
>=20
> Thanks for forwarding...
>=20
>> On Fri, Oct 11, 2024 at 05:58:52PM +0800, Coly Li wrote:
>>> Hi list,
>>>=20
>>> Recently I have a report for a warning message from CXL subsystem,
>>> [ 48.142342] cxl_port port2: Couldn't locate the CXL.cache and =
CXL.mem capability array header.
>>> [ 48.144690] cxl_port port3: Couldn't locate the CXL.cache and =
CXL.mem capability array header.
>>> [ 48.144704] cxl_port port3: HDM decoder capability not found
>>> [ 48.144850] cxl_port port4: Couldn't locate the CXL.cache and =
CXL.mem capability array header.
>>> [ 48.144859] cxl_port port4: HDM decoder capability not found
>>> [ 48.170374] cxl_port port6: Couldn't locate the CXL.cache and =
CXL.mem capability array header.
>>> [ 48.172893] cxl_port port7: Couldn't locate the CXL.cache and =
CXL.mem capability array header.
>>> [ 48.174689] cxl_port port7: HDM decoder capability not found
>>> [ 48.175091] cxl_port port8: Couldn't locate the CXL.cache and =
CXL.mem capability array header.
>>> [ 48.175105] cxl_port port8: HDM decoder capability not found
>>>=20
>>> After checking the source code I realize this is not a real bug,
>>> just a warning message that expected device was not detected.  But
>>> from the above warning information itself, users/customers are
>>> worried there is something wrong (IMHO indeed not).
>>>=20
>>> Is there any chance that we can improve the code logic that only
>>> printing out the warning message when it is really a problem to be
>>> noticed?=20
>=20
> There is a short term fix and a long term fix. The short term fix =
could
> be to just delete the warning message, or downgrade it to dev_dbg(), =
for
> now since it is more often a false positive than not. The long term =
fix,
> and the logic needed to resolve false-positive reports, is to flip the
> capability discovery until *after* it is clear that there is a
> downstream endpoint capable of CXL.cachemem.
>=20
> Without an endpoint there is no point in reporting that a potentially
> CXL capable port is missing cachemem registers.
>=20
> So, if you want to send a patch changing that warning to dev_dbg() for
> now I would support that.

A patch posted by the above suggestion. Thanks in advance for reviewing.

Coly Li=
