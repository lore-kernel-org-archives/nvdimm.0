Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DD43A0B33
	for <nvdimm@lists.linux.dev>; Mon,  9 Feb 2026 18:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770662140; cv=none; b=IsvTbCjnaZtQ07XS8A5UFAKTjs2n3dixzf3ArQSrOaXCrPXuDX9HA00dLYMdo9Zc6aIx7KGwpQCP2Lh0QACJ3Q2P0ScLbjnOihyDVPMHba7FT0bDnj/EcxCzhj4ZuQW/4Dv6GFYWIVkPLZBdBQv2yuoaSfPbISJl6dh/rWhsuxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770662140; c=relaxed/simple;
	bh=eTeMJ3KYmF07l8795G4hM7EcGncQJijHAf18TTU1x/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=X+71a+Yo3RRPtLg1RkqJDwMp5gtSl6YMyFg1TieYml1kTLC9sK1A/JgCnpnQ8p0mICz+neqm6+ZhhXXHoiWQLluaieKBkV6OEqbfnd8K65v6kiep7OzmFcOLVYhtfVGvSOy/ArH/4OgDKAg0y7qRg4ojtgttJegYwgYdxA70U/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aD1XChDE; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aD1XChDE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770662140; x=1802198140;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=eTeMJ3KYmF07l8795G4hM7EcGncQJijHAf18TTU1x/4=;
  b=aD1XChDELkRuWNrA5NY+O5KDFfqetib63UmQbPI9Qq8gGHnkN2LvyB/8
   8midk+WabRYuUHuuEHaSVxSvXoRBN4xXQkUs979FxwJfUoff3F1Q7+jYi
   KBvwvj1ery/oGWrwXQNuNr6olQJm0C2y+EybtEvU8WjnRiZIuitwdKrIa
   Rg//kuWBsttXNQsQztsAW+qUBM5he8KfTwDWf5SJ96dZIk7LX+1lPkW4W
   9jUhtXN2uzj357oYThMSxNKzt21AKoJyQgMuridpwMtZ9ZjRNbItesRF1
   8QkKH11DATrnh6tMiM7/hx3EDsG9s6UKQipZAGTQn1S+Bjt1nwJm11K6i
   w==;
X-CSE-ConnectionGUID: 1346KX/jSrG5bcMYKsLLiQ==
X-CSE-MsgGUID: nN7nmUuDT/29IwgzaUiKPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="75408226"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="75408226"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 10:35:37 -0800
X-CSE-ConnectionGUID: mPkBM/9WR5WEoMDYnLWTdg==
X-CSE-MsgGUID: py4pIWzLST2dcU6t7/K3Mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="249291927"
Received: from jmaxwel1-mobl.amr.corp.intel.com (HELO [10.125.111.252]) ([10.125.111.252])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 10:35:37 -0800
Message-ID: <dbbd3c90-14aa-4c1c-be67-60006959bdfa@intel.com>
Date: Mon, 9 Feb 2026 11:35:35 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH 1/2] util/sysfs: save and use errno properly in read
 and write paths
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
References: <b74bfd8623fcfc4cf1078991b22b8c899147f5fb.1768530600.git.alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <b74bfd8623fcfc4cf1078991b22b8c899147f5fb.1768530600.git.alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/15/26 7:43 PM, Alison Schofield wrote:
> The close() system call may modify errno. In __sysfs_read_attr(),
> errno is used after close() for both logging and the return value,
> which can result in reporting the wrong error. In write_attr(),
> errno is saved before close(), but the saved value was not used
> for logging.
> 
> Without this fix, if close() modifies errno, users may see incorrect
> error messages that don't reflect the actual failure and the function
> may return the wrong error code causing the calling code to handle
> the error incorrectly.
> 
> Save errno immediately after read() in __sysfs_read_attr(), matching
> the existing write_attr() pattern, and use the saved values for both
> logging and return paths.
> 
> Found while preparing a patch to expand the log messages in sysfs.c
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  util/sysfs.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/util/sysfs.c b/util/sysfs.c
> index 968683b19f4e..5a12c639fe4d 100644
> --- a/util/sysfs.c
> +++ b/util/sysfs.c
> @@ -21,18 +21,19 @@
>  int __sysfs_read_attr(struct log_ctx *ctx, const char *path, char *buf)
>  {
>  	int fd = open(path, O_RDONLY|O_CLOEXEC);
> -	int n;
> +	int n, rc;
>  
>  	if (fd < 0) {
>  		log_dbg(ctx, "failed to open %s: %s\n", path, strerror(errno));
>  		return -errno;
>  	}
>  	n = read(fd, buf, SYSFS_ATTR_SIZE);
> +	rc = -errno;
>  	close(fd);
>  	if (n < 0 || n >= SYSFS_ATTR_SIZE) {
>  		buf[0] = 0;
> -		log_dbg(ctx, "failed to read %s: %s\n", path, strerror(errno));
> -		return -errno;
> +		log_dbg(ctx, "failed to read %s: %s\n", path, strerror(-rc));
> +		return rc;
>  	}
>  	buf[n] = 0;
>  	if (n && buf[n-1] == '\n')
> @@ -57,7 +58,7 @@ static int write_attr(struct log_ctx *ctx, const char *path,
>  	if (n < len) {
>  		if (!quiet)
>  			log_dbg(ctx, "failed to write %s to %s: %s\n", buf, path,
> -					strerror(errno));
> +					strerror(-rc));
>  		return rc;
>  	}
>  	return 0;

