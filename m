Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FC237EFE2;
	Tue,  2 Jun 2026 20:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780432650; cv=none; b=VKdO9U+MtChbUmpEmXTUEDJQxbvpRm07uR0W3/SItE2uVeQamPL68Gpm739gZIreA/7bPeIxg1canQ8SQskfRnX91ztDwU19Mi1+r6IaPzHHQ/cPPbyDNvolJyv8fStSdwniQfUH9tFilebyIy2w2kjgZVQYtZw2CwAgXsbb21U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780432650; c=relaxed/simple;
	bh=pHwD0ZV1CEAMNsXx/yt+effMomSWCNvi3CFB34MYIdk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rJZrYnzf1T0aTyXxywo5Mh+ft1vefIEmzpeHiZRolzBxb2LHZ5tsKj9+9XPW6GlHLjgYgMNkDuXphrVseU29F8tbphC5YgaL08pcQe0jtGWFx5eOCf0anZcDnIG75VVmINHpFUJ1pFR/OGYtWrNGFPbD7WruLAAABf9y08hexcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvEOYDcA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvEOYDcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E0651F00898;
	Tue,  2 Jun 2026 20:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780432648;
	bh=pHwD0ZV1CEAMNsXx/yt+effMomSWCNvi3CFB34MYIdk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=jvEOYDcADvlGRRYIOLhBJ9fraq492rgPCR9NNwxrkm1WgOgwIS9DZZE6WO+OKQWOj
	 HgTONB8mKBSHVkLVQw9p4dZD1YvkZyfE4eP2vGawFp8cTMKgGZnaXrbPNHA7iXpvKO
	 tIi0EWxzVT/Joq8wQYV4JvHjV3SLdlVQJhH2cg6Pi/IJrwINyUyE4GZYgUjSmhYP0l
	 IqkPj0r/ajPzK1dweOETJ2+uo+G6GSjS6FTxMiUlcm7WRQHMJqmdlQw5PJIvezNu/A
	 QwEf1e/4pe17gdpl6AWUHoPAG2/FRk2AinFLrWnZEIWagdNAm/mc2rWPWAo2ls/ig3
	 dsJmE1RNbNm6Q==
From: Thomas Gleixner <tglx@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>, Peter Zijlstra <peterz@infradead.org>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, Miguel
 Ojeda <ojeda@kernel.org>, Christian Brauner <brauner@kernel.org>, Marco
 Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton
 <akpm@linux-foundation.org>
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel-team@meta.com, Dmitry Ilvokhin <d@ilvokhin.com>
Subject: Re: [PATCH v5 2/4] genirq: Move NULL check into irqdesc_lock guard
 unlock expression
In-Reply-To: <ab457810653e4356e29b2d74ba616478bd9328ad.1780064327.git.d@ilvokhin.com>
References: <cover.1780064327.git.d@ilvokhin.com>
 <ab457810653e4356e29b2d74ba616478bd9328ad.1780064327.git.d@ilvokhin.com>
Date: Tue, 02 Jun 2026 22:37:26 +0200
Message-ID: <87se747k6x.ffs@fw13>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Jun 02 2026 at 07:12, Dmitry Ilvokhin wrote:

> irqdesc_lock uses __DEFINE_UNLOCK_GUARD() directly with a custom
> constructor that can set .lock to NULL.
>
> In preparation for removing the NULL check from __DEFINE_UNLOCK_GUARD(),
> move the NULL check into the irqdesc_lock unlock expression, making the
> NULL handling explicit at the call site.
>
> No functional change.
>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Acked-by: Thomas Gleixner <tglx@kernel.org>
