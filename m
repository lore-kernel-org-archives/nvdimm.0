Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D528B3769EC
	for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 13:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812439; cv=none; b=n/9OcX/V+tsfgQOJVB/MTuvP4dvTv7rlXtMGfnAMi+9M4b1+A8mIxIJWHH4i12UYQskxSfYM2dVKABqRRoojnzX3kbgDtwwcNX8wUXjMBwf0GqHmRFtMmU8FKsTJmBPh9YT8UYfvloKdGBrNL1melkZ0HQcIgSa7uCDJLVMvG+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812439; c=relaxed/simple;
	bh=mMPPeIFptLyGPXIYfPTvGNVI7I2NU5VstFd6t9YJ/WQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=ND6vZ/xA76BAi34jocDGujCVJj3ajXtqf+cRtKMtMUVuisbkXVIt/xGz9nS6MoYyUT+zPu95rHxnRpVdq5akb9p+7HuQ3bWR/ggWMywKEaYvTqyzuivnOUkN3hLKSmGuYSIuQX4LKZCjGnKAZGpx0ceMFX+cQaGHXrsxU8XGpYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=PbEyMuVx; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="PbEyMuVx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1791812415; x=1792417215; i=markus.elfring@web.de;
	bh=mMPPeIFptLyGPXIYfPTvGNVI7I2NU5VstFd6t9YJ/WQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=PbEyMuVx6Cuo4CzFeFZoRui6gv+jkaMprqgK3XEmGlOFuzSBM85pfprEJchZ+nys
	 ++t4i4EY1UGqg8+GZjgp8XwZO5AXVAE8k5wPdptjtRAnJcv2Q5L4b1zjDX3SdRyLr
	 b9DcXWmwZ6JFgOshM0KNY9VH0lsTAqNaK37zOO3Thdl3ksU+fxvzk/ZBN18k/Qa95
	 SpzKz7ifEDPcGOsMNZiHp8J5R+D1sC1a8/XoeAWAhw2xXnylVSSC6xCTG00KSWnjA
	 31kxOYFv5CEq2H2lpdRaPgb4nZNuOykDVLCLcF22pwWE+IFTOccbT/O4UVxnU9BIO
	 Ite/BBVdajvxxaMy1w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mkmzr-1wnE5g1aD1-00c4bi; Mon, 12
 Oct 2026 15:40:15 +0200
Message-ID: <cfb6c91e-c39d-402d-9f70-4b9bf75d88a1@web.de>
Date: Mon, 12 Oct 2026 15:40:13 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jianyun Gao <jianyungao89@gmail.com>, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>,
 Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>
References: <20261010021010.19575-1-jianyungao89@gmail.com>
Subject: Re: [PATCH] dax: fix wrong error code returned from
 dax_dedupe_file_range_compare()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20261010021010.19575-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Uf6X4rKclDQVEwH0b4p13tIVRpQjW62k9OkwIEP2ar4IkPht9ox
 /QZFGz46Xrs3T+fLelQZtR271BEKAG/5XvPDClbP0qqc34JlbuE4w//BezqD0mKxIWcQz9u
 eX9pn7ZtmFwNkAw1q5tvVDUe7lR82SU9CPIgrP58l8dC1eQykf+l6XrcAezYYR8/Vm4qpb8
 wU3h6wAXEjRISiQ+w1lww==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:aCTrBGJaRpQ=;TD6AjCfokU21coZZPhk1RxweJLy
 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
 7bzY71x7707EA4jLqZ7vCuv5tqrDY=

=E2=80=A6
> Return 'status' instead to propagate the actual error code.

How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D and =
=E2=80=9CCc=E2=80=9D) accordingly?

See also:
* https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?h=3Dv7.3-rc7#n145
* https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/stable-kernel-rules.rst?h=3Dv7.3-rc7#n34


Regards,
Markus
