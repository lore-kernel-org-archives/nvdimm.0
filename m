Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5878148E0EC
	for <nvdimm@lists.linux.dev>; Mon, 12 Oct 2026 14:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814928; cv=none; b=UPx0ODJm+2zCx88SlLZr+9PaFaAg+fIAoA6Oekg8JE6UV+c3tMx/0zgeCsSaZo8JoLs+7HpSA5tB2JO9Z+tvaNMxVJyZmTW8IXAmq76QVzu9Zz7yv1Syl26jzah1Lnj+4fRifp4kCc6V3JdVtq9Qrw2CRJxdSbDncJtfhies1LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814928; c=relaxed/simple;
	bh=WpQuDBiCl+JkZB7wvzf2ljSF+awDmdv9CETj1moBpo8=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=UNCOi89fduMvHcHPJs7I5Fw2AABpFztlQsHQh90HJPyRur+2vPL839X7IEAPJs5Md6dGimSubjYXgVoLO0N/gCotVT7hztgXIFkZGaC3N8AntddfkNDIaLs9N2AYOJn+xfeYoDOBtvYrFf6sG1h/0NL/m63kA8rZzhA5sIgcwvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Ed/5Piuo; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Ed/5Piuo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1791814902; x=1792419702; i=markus.elfring@web.de;
	bh=WpQuDBiCl+JkZB7wvzf2ljSF+awDmdv9CETj1moBpo8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Ed/5Piuoyl0virAcYYM1Ec0FGYRndLUa+SNGQERHC/2d8kCF64pdi7OCjkofv5ac
	 Zz2uBQovSfqfHC4Bh0ZF2mgqR3MHHWnuBWTSyX0HpBxbRSCJ/jjoQJ0go7ITdPBj9
	 KVQBnOW1a7+7vcd3WlrPqRimPltjBVwZpaGDqcF60cZA/PFJiKE2Cg96rEroq83+0
	 WYF7kNzFdntXZwlHShe4Bn/YNggRCFyLkcWNkbKb9et/bBpynwHGJmHflGolUyWVc
	 wp2aLYymHrbwEgB05iTdIcQo+GQs4eiyf8NgsRKU4y/hgT4C0dzm8biN6UVhfDXjG
	 c5rsyVqhxsq7Hmp/sg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N6sG3-1wZxub0ogB-00xzCG; Mon, 12
 Oct 2026 16:21:42 +0200
Message-ID: <c37fdba1-0fd0-483e-bc0c-1767f2cd32be@web.de>
Date: Mon, 12 Oct 2026 16:21:39 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Jianyun Gao <jianyungao89@gmail.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>,
 Alison Schofield <alison.schofield@intel.com>, Dan Williams
 <djbw@kernel.org>, Dave Jiang <dave.jiang@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>
References: <20261011132017.31131-1-jianyungao89@gmail.com>
Subject: Re: [PATCH] dax: fix dax_core_init error return code
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20261011132017.31131-1-jianyungao89@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:nu/EhIBzCsaE8qYl9jkWds6saI5RuRBB7RPjMBv3/YGqk3QxfMq
 BlWA8lARJ60d3V/0MIas7yNHcgVQG9M+5wxs16rXfSz54ocIYHc/OIaGf1lFOp8vc7MviVb
 b0+bUhVIVpQiBKUD+tVimjYFZ8s2z0SK8QvotOR+ef7oRJiwyicIqFJRbbS3qtVOYdvNp+4
 Tj437xwtgjkulMFeapSUQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:CzFg+wzBXNA=;/lh5TMWpKy/7RYpwsMAHM9IEdc3
 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
 0rCe/Y2B0Y6jTI/Tk/hso13ho27NBMyPlZ7caE=

> dax_core_init() mistakenly returns 0 on error paths. Change the
> error return to use rc so the actual error code is propagated
> to the caller.

Please reconsider the proposed need for an additional label once more.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?h=v7.3-rc7#n532

Regards,
Markus
