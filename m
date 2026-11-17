Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794896901;
	b=3dW1LsvLqfjZedWwZDqi2CjxpHZ9Wk2WTUA1aFGBToEX7hTs4cLmNYV7Zd+YJGrj7WPi
	 coAF/PgaO6SjzbTQfHjHeNKzAuDXlgqhswfWb9UZ4FgoSVZMN/Ft7HXYG+D4vy37zt++8
	 YmnFNR28tyUl0fNdCxIXGY6pM5PTBl9WeOw99Yx1Z5yvi+Jvve/2Gk6pNTu5bfAtSqbHF
	 i+HQjS7HsK4q8yOvY9UjO+EIqt+HDx3J7OotMUx8sWIbq3+UgRJ7EJj3wsisAs561JtAV
	 CnAB6/xRtoNcMZ9lXVlNr426KCONaCyW66CeWj7pKwNQAEagJoNRv6guw82ZTJ0DdMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794896901;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=tuZl/9PgkO4+JI7Whd0Kd2da7HJ9ig7Fz1mk57ILQSI=;
	b=jwrlvwQZ67BOko1YcfJdy832+7lQt+sO8wicgAwJVfdET4VZTJ0NISDfzG1A/7yJ87wn
	 OdnyiQMWj1OmngMljRmVz3uUus5Nm0x6HivPj6Krbf/hl9vpNIKHZ8uq4AqyxdR6FSOeC
	 wncQdaVbsotzMF9VP12w2yv2f1v5do6/Y0thPDipoK7NJbloGuQWhm42EKkflrKMd1bqt
	 7V4HxpJfe4oU4F8hGz9ZDINYVZf+pKT3iDcZDBc0jLSBUQNLVxNG/hHzSFuKjL3Oe3BxF
	 GTITbJmwLQDNjq0nRkaOZi2ltbhMiu42YEx41KfHChh/hTuFPjjjmiOzqWsIyjN9knw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Vt4qMaQP;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2B2606A31C
	for <nvdimm@lists.linux.dev>; Tue, 17 Nov 2026 06:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD2B2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Vt4qMaQP
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8c20d68c83fso332078b3a.0
        for <nvdimm@lists.linux.dev>; Mon, 16 Nov 2026 22:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794896900; x=1795501700; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tuZl/9PgkO4+JI7Whd0Kd2da7HJ9ig7Fz1mk57ILQSI=;
        b=Vt4qMaQPHwDcf4te6iFh+s8oVO3gMX5Hg7svlTX+qvAoqIL57TGz3beF1OZLQMDx75
         rUeQA1jmhD1kNgM/6oRZ/rU25/GOQJv/67OSJKyfgzvRaUbWo/ygtG492HxOu400Ndtk
         AciPhTAhn1n+w061S7b9Mtn31Cbx36m2E3dRt8sqyMI6wA/+uecxHCZYN4yvjG9yuM2o
         Ao/fhjOmYKPY7uQQD72R/rrs0NNYGsIsiTJMCehChiMfGmh5xEqurw/YX1MxHW6BClE5
         43PcnJRmL43HNzK9WnuvmOqmPcTkwHw69avwR7xIa+k0IpMSZD7m/C3LH7A55wm9kJeA
         aTpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794896900; x=1795501700;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tuZl/9PgkO4+JI7Whd0Kd2da7HJ9ig7Fz1mk57ILQSI=;
        b=I8yuKTYdd7QwOY8RhmB71tN8QanC6lC8CCJDrIDsUomZvYsA/CWXbeyTRgD0wTW3if
         VRVI5kmYv+seNZEICxwNQ0fzR8VzxN3tOYO3NtSvtPo8ooQu02YyGZgkmcZxq/V8hgCn
         5pMRHrA95zj1DxUufAm8RZcxC8BMX7S7UFc+ME8JWdnGsdy+pTkcErrASWQ006MlMVnc
         7EuwEyow6p+jC4WVP6u0fmr+UDTZuPYAVxJNGn6nkOYfzGbqfsEe8wLSF/xz5j6fxN/p
         V1S8+6dUr921Hxx0spTuX7NEvcCL3sBlOhQz824Bf8vFjodRlfL1qML4Wn2OzGe5GivD
         8D3Q==
X-Gm-Message-State: APuU4Z9vHWSyACEGcelJ4I5FJnV7NQKwZk6/N7mGWpZtRag55N8wETvs
	0vQOND0kAqcFL4RwrwBWyGf1VbHzeLTKTISvyApH/YbCj13w8TPPz3UMlT7zdmCYReRo7j7J
X-Gm-Gg: AYBFou2lAHx3vvxAzTJlRBxt2G1wNKsdaY/37Cegcs/HHSIm1whbgQS0vlnBsDYRuPy
	FpKXvd5ecB53mR+w10tDw2mRdJAr+XnxrVZjwjpIoHJLp5/UWSyV39cj4c6I5cF/NyxLjDEX9Z9
	BDFT/FUMYdmwMQWIQ+OFkyJqG6Qg4HmpZ+0oqH7CqtL6D27OAVBBdi9ZyROlZo463UxoyglEWLi
	fh7rjubvPfp6qMaWatLb9UTDmV7HCja6+XrYjif6emY5PE9xityUvrZkNfgJcdlqBaXWGGE3lTL
	/TQbOTIY6R4foejmxfUpyyh3+q4SNUYNmnNyAwoVKItmWvidQjBsxihhf0MU4YHfNkGgsOGB6Sm
	0173dkYzQVY+3Bk4RbyZIHnf2WLMlS1/nsKLFWs1mG4MqOSycZF316+bXEDPbD+aiYYWhqocUdk
	45h66J32SwNnve/pmU1KkI7IYlSlvM3RSzZHxh5M1KM7vyZ1FhtMMCk6Ic0vCfnDPcZtQDRuxru
	zXy9+9c+TNstdKnvDHVfZK4n5gaUyy6rrofSeZ4rn3BhxeUHGnqMrnGnat3W8fIftt/XwdCJt3A
	nAKasrYGgwN4bxcgN7617FgAx9NOavlA
X-Received: by 2002:a05:6a20:e211:b0:3f8:f0b1:e7b3 with SMTP id adf61e73a8af0-3fd2a1f7d05mr1363642637.7.1794896899925;
        Mon, 16 Nov 2026 22:28:19 -0800 (PST)
Received: from Yee-680G4.lan ([46.16.129.105])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc18851ecsm4956170a12.13.2026.11.16.22.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 22:28:19 -0800 (PST)
From: YeeLi <seven.yi.lee@gmail.com>
To: nvdimm@lists.linux.dev
Cc: yeeli <seven.yi.lee@gmail.com>
Subject: [ndctl PATCH 0/2] ndctl: fix option table termination and multi-ID filters
Date: Tue, 17 Nov 2026 14:28:06 +0800
Message-Id: <20261117062808.4004617-1-seven.yi.lee@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: yeeli <seven.yi.lee@gmail.com>

This series fixes two small bugs found while reviewing ndctl v85.

Patch 1 adds the missing OPT_END() to key_options[].  Without it the
option parser walks past the end of the array and interprets the
adjacent sanitize_options[] array, so setup-passphrase lists and
accepts options that belong to sanitize-dimm.

Patch 2 makes util_bus_filter(), util_region_filter() and
util_dimm_filter() parse the current strtok_r() token instead of the
start of the duplicated identifier string.  Numeric lists such as
"0 1" therefore only matched their first entry.

Both issues were reproduced with the commands and harnesses described
in the individual patches.  The fixes were built and tested on an
x86 test system.

AI disclosure: the bug analysis, reproducers and initial fixes were
produced with the help of an AI coding assistant (DeepSeek V4.1
Flash, running in OpenCode).  The prompts asked for a review of
ndctl v85 for reproducible bugs, then for fixes to the option-table
termination and filter token parsing.  The assistant identified the
missing OPT_END(), wrote a harness for the filter bug, and proposed
both changes.  The submitter reviewed and verified the changes and
added the Signed-off-by tags; the assistant did not add them.

yeeli (2):
  ndctl/dimm: add missing OPT_END() to key_options
  ndctl/filter: parse the current token in util_*_filter

 ndctl/dimm.c   |  1 +
 ndctl/filter.c | 12 ++++++------
 2 files changed, 7 insertions(+), 6 deletions(-)

-- 
2.34.1

