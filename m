Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A4715C13E
	for <nvdimm@lists.linux.dev>; Tue, 20 Aug 2024 19:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724183947; cv=none; b=Ex4jrQ2SO3ncDVQEHe/6fY4VBYxyHzRypWSE5cgEY2Zaybf7jYjVz7ehNMIztq02kGBV+tA2OgKrdFYiBwlMUc2Z5EcuUADAKNrmIpRg/HNI7m5oSzvgjkFYaWBpYrxP+s05Qh+offeM5JsL3XW7Ju+2TDHLaZBn4VikH/AQEDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724183947; c=relaxed/simple;
	bh=xhAVo+kjcvMHnq1gFSCI2mBbqvKq52RVOl845p1g/Uk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=crx1o3In7uBztGMsCVj6AoicMtJQbWUg1oJnFHEEHV84ZT31cZVdlg2EoMo8Vr2JAknzBP4YulmVVXh3pGEeScCSMk1u4/xO/ZDJIOVbDlhi33e04GmdhyKd6DKljHhW9jABFqikndQxgrK6Mk5e4hhe+HwH/5j/xAMOJLDPMEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MDWkoWTz; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MDWkoWTz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724183945; x=1755719945;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=xhAVo+kjcvMHnq1gFSCI2mBbqvKq52RVOl845p1g/Uk=;
  b=MDWkoWTzMLnsqU/Bx/QEpY5QaO8VjUxkssS0XHV3j/HMmE9wnDbRTJQl
   pqhNMYEbKrUL03Ng3RG+51ZZTXHu2CfxiZhIvuxkdN7btYH6UNtImDY6q
   yj0uqxFD3v1Co9nHgROXXkd57V6t9/w/rm1+yl0vlPBUsVxTOnS72MQdy
   kbn6LLnNGqASRSb/50xd8eq1O0sP79oVEmSTdvALz0CqbI4pMzzZ4VEA/
   U1vrzwVvefOChy6DiTTY+rBwkXQmiUPHM40RNaLkXDWux27HmdeVpyUdm
   0tV98+IKsl0bB4e8Xc4VfYnb3bNTT6B70Qbg7pSZJPDbsuL+bdXepIaQF
   w==;
X-CSE-ConnectionGUID: hnlFfacPQ/mZVpIF/Bmaqw==
X-CSE-MsgGUID: RX5wwjKHTXi7jYwgxPt4AA==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="40023802"
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="40023802"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 12:59:04 -0700
X-CSE-ConnectionGUID: pGpHl6dfSCq2RvfGioguOA==
X-CSE-MsgGUID: xUR6hFW9Tz+Jt2XUIo5jFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,162,1719903600"; 
   d="scan'208";a="65199041"
Received: from cdpresto-mobl2.amr.corp.intel.com.amr.corp.intel.com (HELO [10.125.108.88]) ([10.125.108.88])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 12:59:04 -0700
Message-ID: <5eed5740-d77e-4774-95e5-2320ae1386a5@intel.com>
Date: Tue, 20 Aug 2024 12:59:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH ndctl 1/2] ndctl/keys.c: don't leak fd in error cases
To: jmoyer@redhat.com, nvdimm@lists.linux.dev
References: <20240820182705.139842-1-jmoyer@redhat.com>
 <20240820182705.139842-2-jmoyer@redhat.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20240820182705.139842-2-jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/20/24 11:26 AM, jmoyer@redhat.com wrote:
> From: Jeff Moyer <jmoyer@redhat.com>
> 
> Static analysis points out that fd is leaked in some cases.  The
> change to the while loop is optional.  I only did that to make the
> code consistent.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/keys.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/ndctl/keys.c b/ndctl/keys.c
> index 2c1f474..cc55204 100644
> --- a/ndctl/keys.c
> +++ b/ndctl/keys.c
> @@ -108,7 +108,7 @@ char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
>  	struct stat st;
>  	ssize_t read_bytes = 0;
>  	int rc, fd;
> -	char *blob, *pl, *rdptr;
> +	char *blob = NULL, *pl, *rdptr;
>  	char prefix[] = "load ";
>  	bool need_prefix = false;
>  
> @@ -125,16 +125,16 @@ char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
>  	rc = fstat(fd, &st);
>  	if (rc < 0) {
>  		fprintf(stderr, "stat: %s\n", strerror(errno));
> -		return NULL;
> +		goto out_close;
>  	}
>  	if ((st.st_mode & S_IFMT) != S_IFREG) {
>  		fprintf(stderr, "%s not a regular file\n", path);
> -		return NULL;
> +		goto out_close;
>  	}
>  
>  	if (st.st_size == 0 || st.st_size > 4096) {
>  		fprintf(stderr, "Invalid blob file size\n");
> -		return NULL;
> +		goto out_close;
>  	}
>  
>  	*size = st.st_size;
> @@ -166,15 +166,13 @@ char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
>  			fprintf(stderr, "Failed to read from blob file: %s\n",
>  					strerror(errno));
>  			free(blob);
> -			close(fd);
> -			return NULL;
> +			blob = NULL;
> +			goto out_close;
>  		}
>  		read_bytes += rc;
>  		rdptr += rc;
>  	} while (read_bytes != st.st_size);
>  
> -	close(fd);
> -
>  	if (postfix) {
>  		pl += read_bytes;
>  		*pl = ' ';
> @@ -182,6 +180,8 @@ char *ndctl_load_key_blob(const char *path, int *size, const char *postfix,
>  		rc = sprintf(pl, "keyhandle=%s", postfix);
>  	}
>  
> +out_close:
> +	close(fd);
>  	return blob;
>  }
>  
