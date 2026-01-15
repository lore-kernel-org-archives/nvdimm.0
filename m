Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F933242AD
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 23:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768521308; cv=none; b=WkWhyr81Hr7oz+vwvoyzCOYo9G8z9jaenPDanQpR9uM6jUOyH7dbNCkBd7cZ3/68wG5Gtt0ra40uszASJK//gPxTmxk84+//0RFGHz+34OCCYw7bA/csBZXF3C8hUmrVN7ipyhJhg+biM3SlMUUhXOKgA64qrlNn2k4IRWZM0Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768521308; c=relaxed/simple;
	bh=eTvubCr1gBMWIBW+1QFNInrVxxoKYmZ2cW03K6L3bAs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KrfJBwpWxy4Q+X/UPmD+1uuuV1sc6AjPGKCS1KzCv8Q7N8oWexWTS2wUeZtWTMBAj2xRicHggbfByvtUue1hrjrGv5ZnZjxt7bg9d4iEQ69cmx/5OFJCCzFBOjajbeBfO1p14GuN2sCaL/39+57656qMvwsAh8ApZ9aX+Kcp0TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fIyRlefv; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fIyRlefv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768521307; x=1800057307;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=eTvubCr1gBMWIBW+1QFNInrVxxoKYmZ2cW03K6L3bAs=;
  b=fIyRlefvWn2/49SwcVnp3dR5wq5gVmdL0fOrh6QpVIxbnYFfeYMHgkkm
   pRqLw8vT+0HG9NgR42loxzxT4GijYxlLvo2kCqJ/WPcMrtdWrka32xJnf
   yKkdLGK1iwGjPJ8u7wYG6iscVmSvb+Iam9XEmy7n6Nw3STmZkZeavXew8
   7dYSSfAPunzyfgQQ19lniZyCa4Zf6v3HwfrHN4eltBXE+WWsZ2oJEv+Tn
   Y6azcr4ot80sgL/PYsOwL9Hz6qGaHDJbdgwGCbNYsDuwKXqq++84zslnn
   skJ31l3oqAFqxltR7BJgtwz38J/n/zxexUr4XTZJZWkoU4JhSYokEXNge
   Q==;
X-CSE-ConnectionGUID: anUh2HEdTqyaOqAnVhVfTQ==
X-CSE-MsgGUID: 715SpqFlRZqO2uaPnBuLbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="81285724"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="81285724"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 15:55:06 -0800
X-CSE-ConnectionGUID: OGD7UST1SMOr1RrAP8gJAQ==
X-CSE-MsgGUID: z5WPPNwRQPCQHEcqEV49Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="209227892"
Received: from c02x38vbjhd2mac.jf.intel.com ([10.88.27.175])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 15:55:06 -0800
From: Marc Herbert <marc.herbert@linux.intel.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH] daxctl: Replace basename() usage with strrchr()
In-Reply-To: <20260115221630.528423-1-alison.schofield@intel.com> (Alison
	Schofield's message of "Thu, 15 Jan 2026 14:16:28 -0800")
References: <20260115221630.528423-1-alison.schofield@intel.com>
Date: Thu, 15 Jan 2026 15:54:54 -0800
Message-ID: <m2a4yee8j5.fsf@C02X38VBJHD2mac.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Hi Alison,

Alison Schofield <alison.schofield@intel.com> writes:
>  	argc = parse_options(argc, argv, options, u, 0);
> -	if (argc > 0)
> -		device = basename(argv[0]);
> +	if (argc > 0) {
> +		device = strrchr(argv[0], '/');
> +		device = device ? device + 1 : argv[0];
> +	}
>  


1. I would add a one-line comment in both places, something like "This
is like basename but without the bugs and portability issues" because:

  1.a) It's much faster to read such a comment than understanding the code.
  1.b) Not everyone knows how much of GNU/POSIX disaster is "basename".
       You summarized it well in the commit message but it's unlikely
       anyone will fetch the commit message from git without such a comment.

  To avoid duplicating the comment, a small "my_basename()" inline
  function would not hurt while at it.


2. I believe this (unlike basename) returns an empty string when the
   argument has a trailing slash. Now, an argument with a trailing slash
   would probably be garbage and I'm OK with the "Garbage IN, garbage
   OUT" principle. BUT I also believe in the "Proportionate Response"
   principle, which means a small amount of garbage IN should IMHO not
   be punished by some utterly baffling error message or (much worse) a
   crash. Did you/could you test what happens with a trailing slash? If
   the resulting failure makes some kind of sense then don't change
   anything.

Note even when rare in interactive use, "Garbage IN" becomes more
frequent in automation. Then good luck making sense of a cryptic error
when you can't even reproduce the elaborate test configuration and test
bugs that trigger it.
