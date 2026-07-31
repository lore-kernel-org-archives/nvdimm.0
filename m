Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3527357D05
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 08:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785488195; cv=none; b=W9aggBu5nXlinYKok7xw7RDCVj8SXHb/JUYBH/klGayR7IThKRzj26f4lJzJrP+69o8VYsbuMCtJK2c68ApXH5HE9bF9M6rMkW/YI8eab2wAkx7NZePKGVZCENf4Lvsmot6JyhQiI2YDhMjnau23/GAnOG4pX3P9iQXUl63zMAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785488195; c=relaxed/simple;
	bh=7/1fOYKAF+TojUQv/yXjM8VlWc5l8O3G6B/c2rWtze4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=smFasYYYInW2cbxG2Iw+ao9GhN62EPanLOFVMLuLdrd1a+0xJCMLNIN4yn0nxR4ILtJjN27iAxUmyqAo4WicCWdlFXSRxpHpUPLI52GQjAbNvBHtPC3ZTDM8QNVBXNOVAwSO2oAOoRdclWEldnrh2WYsH8/cj+vTG2WO5WFV6qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c4yBocwa; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c4yBocwa"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 387B0204C;
	Fri, 31 Jul 2026 01:56:29 -0700 (PDT)
Received: from GX9GF4H4XN (unknown [10.1.26.143])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 912843F86F;
	Fri, 31 Jul 2026 01:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785488193; bh=7/1fOYKAF+TojUQv/yXjM8VlWc5l8O3G6B/c2rWtze4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=c4yBocwaqIuqEWKvb4tzOO0QYg+NRXTVwTAox04FfQMait8/mJexDjKMLBhCqw7BY
	 Jjlq/H+VN5LHobZOey/aurH99UXEwnRA429JjXToxk9CJBPzmK/zPST8QycrlH+4rr
	 wlSmVnoewyJ1K90hb08Qupy9QbHqMKUNWuafr6wQ=
From: Seunguk Shin <seunguk.shin@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>,  Alexander Viro
 <viro@zeniv.linux.org.uk>,  Christian Brauner <brauner@kernel.org>,
  Matthew Wilcox <willy@infradead.org>,  Jan Kara <jack@suse.cz>,
  <linux-fsdevel@vger.kernel.org>,  <nvdimm@lists.linux.dev>,
  <Nick.Connolly@arm.com>,  <ffidencio@nvidia.com>
Subject: Re: [PATCH v4, RESEND] fs/dax: check zero or empty entry before
 converting xarray entry
In-Reply-To: <20260730103804.063ce671588b02c2596d5de3@linux-foundation.org>
	(Andrew Morton's message of "Thu, 30 Jul 2026 10:38:04 -0700")
References: <m2v79wmxig.fsf@arm.com>
	<20260730103804.063ce671588b02c2596d5de3@linux-foundation.org>
Date: Fri, 31 Jul 2026 09:56:30 +0100
Message-ID: <m25x1vzge9.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Hi Andrew,

Thank you for looking into this.

> Are there any known userspace-visible runtime effects of this?

Yes. I'm trying to fix this because it caused kernel panic on a VM with DAX in
kata-containers project:
https://github.com/kata-containers/kata-containers/commit/1c154b4c15cfc63e06ad1c48a801064677e874e2

I'll add kernel panic message in the commit log like patch v2:
https://lore.kernel.org/all/m2tsvmue92.fsf@arm.com/

Thank you.
