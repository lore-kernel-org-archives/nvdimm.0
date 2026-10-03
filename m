Received: from mail-pj2-f42.google.com (mail-pj2-f42.google.com [74.125.227.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C7E3469EE
	for <nvdimm@lists.linux.dev>; Sat,  3 Oct 2026 06:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791009146; cv=none; b=apohjqcGNlfbQEMphonymwA7BzTK5MQUXoui/GdmPKb3k2X1How3HT9zBhx+5G6eRyI0fuNPVNIvP6xjM1fOHmkO0UoWpTNA+U6SEBdKM4Q6naEf+mhacVDE0OJpwEMuu4Ex1j+/VKSiHIINjHdC2r8J6kcGSFwSERS5G9/f6L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791009146; c=relaxed/simple;
	bh=VuiMGsvrxoxHYIMjTtEAMKJLNMC58E+oDp1FFjB26XU=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:In-Reply-To:
	 References:MIME-Version; b=dyAB5+YPK9KLyhRkb6RY1+RHqA57NSetwksESYDkKQb3An4hlxWwKkG0lCvGJqXXedQyycbWBFCQ9fYpVc7QjQdFjw70uUWDCdVLdarTPHdmrAWRmmCQuowcW6A/bkSnuScafSRYsKO4HdeE6sc5+6JuQpcViBmwdlHtOOe6OO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AUlCyWP6; arc=none smtp.client-ip=74.125.227.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AUlCyWP6"
Received: by mail-pj2-f42.google.com with SMTP id 98e67ed59e1d1-396ccb65437so91952a91.3
        for <nvdimm@lists.linux.dev>; Fri, 02 Oct 2026 23:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791009144; x=1791613944; darn=lists.linux.dev;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vr5KVZoPR0cul9dM0w9bT4mgxCHNEHDqUMfTuf7KfX8=;
        b=AUlCyWP6FEmyhNDXfL1CNQya4XPGQpa0Sff8L1dmBY6qxibD2vTvJUAsg2JH9m1kIJ
         tJ94oJQTZZgF0yqFY9hvEvLnEZMnr7rJkn6E3UgGnTghPW9XOe5T44izCogHmLXuanrO
         qUctE500xxHTAowgENNSwXxRG6ES0dX79eQ/9oTvgK2DKGjODKuzslKzLwczevpSpdlp
         gomP6q5uTukC6rUNt5rRZeCxFHb9HI9H/wUY1MWiB+J7QbcvQISEUcJxExs1kfi3593Y
         4070rlpoyrAJgCdeRTL0HC84wNcIrTXXGw6HNUv9U/Kzyo0xAMJp5LteSl5CgzZQJGy7
         2zZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791009144; x=1791613944;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vr5KVZoPR0cul9dM0w9bT4mgxCHNEHDqUMfTuf7KfX8=;
        b=m7vuX9IJXtkwhAZA2gOSyab1wRI0KAeLsIAkpxy24Op3gtrchAGRNiDhFU+fMHh33l
         qD7FBsJdptumrjicfKGFHZSDV61EtSrK560xXVOp3OzQbD3ErHzTGjl3CkxYQBv7wfFU
         EGOY0PQGMIi3abLs0BqnsISfOFRBYDBBDq5sQ8zKAbl1jfifAZk2FghIlYXyZgPA0V/9
         Qn+Q2dunXQhhIa61FEMCBiQwIBipVtTSjuZUpE9Syy1mZ8qL+l+0b4Rq4ZVxyop+AO6R
         Ncsq6YhmFmXf+oun0cALl7rXxVG/tLy9H/u+E4pU5T6Byhanz+MmxXcks4FmFueB6G2j
         ZAdg==
X-Forwarded-Encrypted: i=1; AKwUvBxs4Q4gLUJJdeTrLzWGZHYIV2L0QKGpKCd5+QE1FlmD39DvDC2FGyG24I8lRCQK7tMr+OenXfw=@lists.linux.dev
X-Gm-Message-State: AFq9FYK4swsoEZcmRTzVyL6PeJJ/upHkmDYKMKA7cdQO/PTnXGLOeery
	lOZbOW3tQ4hEoE8rM0PzgJSdHechsyuQIjX7VXYVLUjtJFzZMK/0pCcP
X-Gm-Gg: AYBFou1J0X8Wv6YcYMdVvVUwxCcLxH3DST9H1uYtiosT1OB9D1rkALSTOB1uRCM8iF5
	nBxSCCu6EyeEN9o89gVcA7FbKET+vKs0N1G727Himlabz2RoFqR1ZHAi3wHPtXgXtJsf7y2GjJK
	epUJOSi2Qwgzt0o7b5Ql/+eTEJsmTtk02BhGpoVUFyL6G2/C+/lOFoIECsfSq/ltQ7T2eGkZkwP
	hiecMwBvuuctcfQbsAdg+VReqWewQ9mXFEqAGZw+cLjAihwzj6zrf/ZvyyQVBUCrfQIDeg75Trv
	DGxjjU6sGq000xkentM2bHaf5qeSvSrzj6RXbshYc1Zob4f6+KcE1u9XkH+2Flkfb5dGnWeDlBB
	386TgTp/Rrk9Za2OTWwSIvCh94CKG/rCg8Dsjv/q/Qw/DBdwXo3X7cPMp7Fx7sBq2Rgp7DiWjNL
	TTQpI6Lo3hPSnYx/ySaIphoiqiikwXLubpevYukv7X4kjNy3hGVsFCEZlQghp6JyvR1xtUxLEWG
	897m+maseNH73EP76jhBqtl0yTBEMNm52PI+QRAEZhVqI1mwxsDz6KpZZoBXL2HMdajHK3rroAN
	G247xJVfqIhA9A==
X-Received: by 2002:a17:90a:1650:b0:3a0:7261:d58e with SMTP id 98e67ed59e1d1-3a6e622a50cmr2049092a91.22.1791009143685;
        Fri, 02 Oct 2026 23:32:23 -0700 (PDT)
Received: from localhost ([153.61.198.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78d6b5c3dsm1823004a91.13.2026.10.02.23.32.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2026 23:32:22 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Sat, 03 Oct 2026 06:32:21 +0000
Message-Id: <DLUZR540Z45R.3RTC4COS2IW2V@gmail.com>
Cc: "Jonathan Corbet" <corbet@lwn.net>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Gow" <david@davidgow.net>, "Petr
 Mladek" <pmladek@suse.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "Shuvam Pandey" <shuvampandey1@gmail.com>,
 "Steven Rostedt" <rostedt@goodmis.org>, =?utf-8?q?G=C3=BCnther_Noack?=
 <gnoack@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 =?utf-8?q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, "Andy Shevchenko"
 <andriy.shevchenko@linux.intel.com>, "Masami Hiramatsu"
 <mhiramat@kernel.org>, "Mathieu Desnoyers"
 <mathieu.desnoyers@efficios.com>, "Jiri Kosina" <jikos@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko" <andrii@kernel.org>,
 "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Song Liu"
 <song@kernel.org>, "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa"
 <jolsa@kernel.org>, "Emil Tsalapatis" <emil@etsalapatis.com>, "Ihor
 Solodrai" <ihor.solodrai@linux.dev>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, =?utf-8?q?Uwe_Kleine-K=C3=B6nig?=
 <u.kleine-koenig@baylibre.com>, "Madhavan Srinivasan"
 <maddy@linux.ibm.com>, "Michael Ellerman" <mpe@ellerman.id.au>, "Nicholas
 Piggin" <npiggin@gmail.com>, "Shivaprasad G Bhat" <sbhat@linux.ibm.com>,
 "Thorsten Blum" <blum@kernel.org>, "Alison Schofield"
 <alison.schofield@intel.com>, "Dave Jiang" <dave.jiang@intel.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Guangshuo Li"
 <lgs201920130244@gmail.com>, "Ira Weiny" <iweiny@kernel.org>,
 =?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, "Vishal
 Verma" <vishal.l.verma@intel.com>, "Randy Dunlap" <rdunlap@infradead.org>,
 "Shuah Khan" <skhan@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
 <bpf@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
 <linux-trace-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
 <nvdimm@lists.linux.dev>, <linux-doc@vger.kernel.org>,
 <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH v4 00/11] seq_buf: Add seq_buf_strlen()
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Kees Cook" <kees@kernel.org>, "Bill Wendling" <morbo@google.com>
In-Reply-To: <20261003035906.too.263-kees@kernel.org>
References: <20261003035906.too.263-kees@kernel.org>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

On Fri, Oct 02, 2026 at 08:59 PM Kees Cook <kees@kernel.org> wrote:
>   seq_buf: Add seq_buf_terminate()
>   bpf: Remove dead newline stripping from format_disasm_line()

For bpf bits:
Acked-by: Alexei Starovoitov <ast@kernel.org>
