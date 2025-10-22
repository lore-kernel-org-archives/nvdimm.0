Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628DD315D29
	for <nvdimm@lists.linux.dev>; Wed, 22 Oct 2025 18:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761158261; cv=none; b=B1s4HP/Z8H2kylSmaZBWVqH8HRD51IBrHSZ44SNKqdF53IU3wZnPVDw7oGzvAl5wY2Y1f9qgSSHXVrrok4DSQFvHtsh4DqCgtajmVGow9ChDprc9lXPHGGk6vgXKjD9DdWlFFyC6G4gj2dq2bXbtNMdzv7+7vN1ajJTiXh2lm+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761158261; c=relaxed/simple;
	bh=/3ibONR+ICCfqlyEe1cuQJbe/d34c70GW+NnKh27318=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b98cP2rBbhmyCZXVYCjPtBvb6EWIRQrEBF/2xh3FZIE6XZhLIEBZP8GVH7bmiyL9CI6HxRwfwml0ADV8abMrEJBP6uTbKhz6Xm4FVzpgKVZYSvmRH5FZAuDuphnBrsEL7bPJDOJ6rM2KQd7NtccWDXF7yjr++/+EJ2hRTo8iAEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ixrypA1E; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ixrypA1E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761158259; x=1792694259;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/3ibONR+ICCfqlyEe1cuQJbe/d34c70GW+NnKh27318=;
  b=ixrypA1ETODVcjo7IHe3GrvPOVlTVyNfrSXsY0o9lot0s+DCcdpcHcZ0
   cI5cOEIyQoQKWtVRvMgqRZa4/BwxCS4JAk0Fv2JS2UL19+4LUYWla0p/h
   r6a5SCscOHSkygstV5hDnq9U8zTIoNuWlHN8y9c4RcMa5ls6/WB2ccjHz
   n/UNTEau0FybAEA95HW2n/6/ozTqhv4TGFS+Ud+CmpCk2ToM0XoFwO3Z7
   iqPPc1IbK2nOautg8Svaf/H86mD0YJNF2ursC8Eksyo5MvRWKt8hPE4JJ
   jNURnQjrsS1O/lwYMrAXmq+oantTMdxMgU69sRLKt8Pzot9JlVaZM7fk6
   Q==;
X-CSE-ConnectionGUID: 93NCK6mzQiiwXOnTkxn82g==
X-CSE-MsgGUID: Cwc8TGTORlGSkgXpAi9qeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="80755685"
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="80755685"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:37:39 -0700
X-CSE-ConnectionGUID: Dt8T8Tc8S9OsS2cN2wHSXg==
X-CSE-MsgGUID: pHCQ0NluTtuORNX1L5ZwZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,247,1754982000"; 
   d="scan'208";a="221138292"
Received: from mherber2-mac13.jf.intel.com (HELO [10.88.27.157]) ([10.88.27.157])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 11:37:38 -0700
Message-ID: <a9806830-6ce7-4d1b-a72d-7fa123e8b326@linux.intel.com>
Date: Wed, 22 Oct 2025 11:37:37 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] ndctl/test: fully reset nfit_test in pmem_ns unit
 test
Content-Language: en-GB
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
Cc: Marc Herbert <marc.herbert@intel.com>
References: <20251021212648.997901-1-alison.schofield@intel.com>
From: Marc Herbert <marc.herbert@linux.intel.com>
In-Reply-To: <20251021212648.997901-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-10-21 14:26, Alison Schofield wrote:
> The pmem_ns unit test frequently fails when run as part of the full
> suite, yet passes when executed alone.
> 
> [...]
> > Replace the NULL context parameter when calling ndctl_test_init()
> with the available ndctl_ctx to ensure pmem_ns can find usable PMEM
> regions.
> 
> Reported-by: Marc Herbert <marc.herbert@intel.com>
> Closes: https://github.com/pmem/ndctl/issues/290
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  test/pmem_namespaces.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/test/pmem_namespaces.c b/test/pmem_namespaces.c
> index 4bafff5164c8..7b8de9dcb61d 100644
> --- a/test/pmem_namespaces.c
> +++ b/test/pmem_namespaces.c
> @@ -191,7 +191,7 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
>  
>  	if (!bus) {
>  		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
> -		rc = ndctl_test_init(&kmod_ctx, &mod, NULL, log_level, test);
> +		rc = ndctl_test_init(&kmod_ctx, &mod, ctx, log_level, test);
>  		ndctl_invalidate(ctx);
>  		bus = ndctl_bus_get_by_provider(ctx, "nfit_test.0");
>  		if (rc < 0 || !bus) {

Thanks Alison! This does fix the crash, so you can also add my Tested-By:!

But to test, I had to combine this fix with this temporary hack from
https://github.com/pmem/ndctl/issues/290

--- a/test/pmem_namespaces.c
+++ b/test/pmem_namespaces.c
@@ -189,7 +189,7 @@ int test_pmem_namespaces(int log_level, struct ndctl_test *test,
 			bus = NULL;
 	}
 
-	if (!bus) {
+	if (!bus || true) {
 		fprintf(stderr, "ACPI.NFIT unavailable falling back to nfit_test\n");
 		rc = ndctl_test_init(&kmod_ctx, &mod, NULL, log_level, test);
 		ndctl_invalidate(ctx);



... which explains why I disagree with... the commit message! I don't think
this necessary fix "closes" https://github.com/pmem/ndctl/issues/290 entirely.

This fix does stop  the test from failing which is great and it lowers dramatically
the severity of 290. But we still don't know why ACPI.NFIT is "available" most of
the time and... sometimes not. In other words, we still don't know why this test is
non-deterministic. Of course, there will always be some non-determinism because
the kernel and QEMU are too complex to be deterministic but I don't think
non-determism should extend to test fixtures and test code themselves like this.
Why 290 should stay open IMHO.

Also, this feels like a (missed?) opportunity to add better logging of this
non-determinism, I mean stuff like:
https://github.com/pmem/ndctl/issues/290#issuecomment-3260168362
This is test code, it should not be mean with logging. All bash scripts run
with "set -x" already so this would not make much difference to the total
volume.


Generally speaking, tests should follow a CLEAN - TEST - CLEAN logic to
minimize interferences; as much as time allows[*]. Bug 290 demonstrates that:
1. Some unknown test running before pmem-ns does not clean properly after itself, and
2. The pmem-ns test is not capable of creating a deterministic setup for itself.

We still have no clue about 1. and 2. is not mitigated with logs
and source comments. So there's still an open bug there.

Marc




[*] there are practical limits: rebooting QEMU for each test would be too slow.
