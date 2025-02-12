Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906CA21129F
	for <nvdimm@lists.linux.dev>; Wed, 12 Feb 2025 16:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739376643; cv=none; b=Ax/rvvRoZZXbv/8cQARccJHcNRYOcBAB66RzLReisLf8hms584/AoqVLvelSfH7+9ENE9I9ajcMamz2CQtX0MpjsiWKhGjCwHiELrHcb1egqIp7oPt9DL4jb+b/2sI2EdK+1/bbwaadeZhMmdgf5bK8L5C6M3bKz3cYiKMQbM7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739376643; c=relaxed/simple;
	bh=tDdBYk3jbWtdFnyKfyQKmUbv1yHxieq0Zk6TnnOIh54=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=l28J4omgjvOLw+j0hmqO4zqNKPMF8lZrw/46YzXDatpKEuWHD9aKjKfE+SOGRO0r7LFWmeUuiqqZkxB67EZ0S2PthrPdrgBX+Taj8evnrtAuxCDSqs9RpsTTeWLhfp/SvKnjKKeHYB4nWQCnt5P5MH+c/z7LF6rqmZsT+5LoM+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NsW5jP9j; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NsW5jP9j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739376642; x=1770912642;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=tDdBYk3jbWtdFnyKfyQKmUbv1yHxieq0Zk6TnnOIh54=;
  b=NsW5jP9j7BvZjy9sjz00wNaWIXdaiH0bXFhfKyHMGM2e1W2oQW9FK3TO
   a8meyopHTuigQaptFhXfTqyBQVKDVsapZHq72VAOQgPmnbaUJTyCg+Pr/
   LLFZoojkgnsrwJJlsVYHZTfV6m9YHYo68SJ/HKeRBkizBu78Glrr4Nwlf
   Ax6p26Kle8c0jOsZcs7uXyyzBNXJa8vqmV+CPd3moOddJ5Bdzylq8jOex
   z/JUp1gcJlD12IkChTAv6//u7+k2TwIdblWiRrLEySdrORn3RhId/xk+t
   1VWuRLNBkNS5NbkIWhlroV6ZAoBclsVSSctNbuec5jJ8PT2iU9e9/Ywnp
   A==;
X-CSE-ConnectionGUID: TzDhcimQT2W3C6Lvq8bniw==
X-CSE-MsgGUID: H/Ww6CX0T/CaaRlFgxaXiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="40075268"
X-IronPort-AV: E=Sophos;i="6.13,280,1732608000"; 
   d="scan'208";a="40075268"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 08:10:41 -0800
X-CSE-ConnectionGUID: PeGIZWf0QVCT/oamOYolNw==
X-CSE-MsgGUID: G+E7kyFBRimsijky3UExZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,280,1732608000"; 
   d="scan'208";a="112827051"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.108.128]) ([10.125.108.128])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 08:10:40 -0800
Message-ID: <b45134fe-d6cf-425c-9128-62195a258056@intel.com>
Date: Wed, 12 Feb 2025 09:10:39 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] util/strbuf: remove unused cli infrastructure
 imports
To: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>
References: <20250212034020.1865719-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20250212034020.1865719-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/11/25 8:40 PM, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> The ndctl cli interface is built around an imported perf cli
> infrastructure which was originally from git. [1]
> 
> A recent static analysis scan exposed an integer overflow issue in
> sysbuf_read() and although that is fixable, the function is not used
> in ndctl. Further examination revealed additional unused functionality
> in the string buffer handling import and a subset of that has already
> been obsoleted from the perf cli.
> 
> In the interest of not maintaining unused code, remove the unused code
> in util/strbuf.h,c. Ndctl, including cxl-cli and daxctl, are mature
> cli's so it seems ok to let this functionality go after 14 years.
> 
> In the interest of not touching what is not causing an issue, the
> entirety of the original import was not reviewed at this time.
> 
> [1] 91677390f9e6 ("ndctl: import cli infrastructure from perf")
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  util/strbuf.c | 51 ---------------------------------------------------
>  util/strbuf.h |  7 -------
>  2 files changed, 58 deletions(-)
> 
> diff --git a/util/strbuf.c b/util/strbuf.c
> index 6c8752562720..16fc847dd1c7 100644
> --- a/util/strbuf.c
> +++ b/util/strbuf.c
> @@ -60,30 +60,6 @@ void strbuf_grow(struct strbuf *sb, size_t extra)
>  	ALLOC_GROW(sb->buf, sb->len + extra + 1, sb->alloc);
>  }
>  
> -static void strbuf_splice(struct strbuf *sb, size_t pos, size_t len,
> -				   const void *data, size_t dlen)
> -{
> -	if (pos + len < pos)
> -		die("you want to use way too much memory");
> -	if (pos > sb->len)
> -		die("`pos' is too far after the end of the buffer");
> -	if (pos + len > sb->len)
> -		die("`pos + len' is too far after the end of the buffer");
> -
> -	if (dlen >= len)
> -		strbuf_grow(sb, dlen - len);
> -	memmove(sb->buf + pos + dlen,
> -			sb->buf + pos + len,
> -			sb->len - pos - len);
> -	memcpy(sb->buf + pos, data, dlen);
> -	strbuf_setlen(sb, sb->len + dlen - len);
> -}
> -
> -void strbuf_remove(struct strbuf *sb, size_t pos, size_t len)
> -{
> -	strbuf_splice(sb, pos, len, NULL, 0);
> -}
> -
>  void strbuf_add(struct strbuf *sb, const void *data, size_t len)
>  {
>  	strbuf_grow(sb, len);
> @@ -114,30 +90,3 @@ void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
>  	}
>  	strbuf_setlen(sb, sb->len + len);
>  }
> -
> -ssize_t strbuf_read(struct strbuf *sb, int fd, ssize_t hint)
> -{
> -	size_t oldlen = sb->len;
> -	size_t oldalloc = sb->alloc;
> -
> -	strbuf_grow(sb, hint ? hint : 8192);
> -	for (;;) {
> -		ssize_t cnt;
> -
> -		cnt = read(fd, sb->buf + sb->len, sb->alloc - sb->len - 1);
> -		if (cnt < 0) {
> -			if (oldalloc == 0)
> -				strbuf_release(sb);
> -			else
> -				strbuf_setlen(sb, oldlen);
> -			return -1;
> -		}
> -		if (!cnt)
> -			break;
> -		sb->len += cnt;
> -		strbuf_grow(sb, 8192);
> -	}
> -
> -	sb->buf[sb->len] = '\0';
> -	return sb->len - oldlen;
> -}
> diff --git a/util/strbuf.h b/util/strbuf.h
> index c9b7d2ef5cf8..3f810a5de8d7 100644
> --- a/util/strbuf.h
> +++ b/util/strbuf.h
> @@ -56,7 +56,6 @@ struct strbuf {
>  #define STRBUF_INIT  { 0, 0, strbuf_slopbuf }
>  
>  /*----- strbuf life cycle -----*/
> -extern void strbuf_init(struct strbuf *buf, ssize_t hint);
>  extern void strbuf_release(struct strbuf *);
>  extern char *strbuf_detach(struct strbuf *, size_t *);
>  
> @@ -81,9 +80,6 @@ static inline void strbuf_addch(struct strbuf *sb, int c) {
>  	sb->buf[sb->len++] = c;
>  	sb->buf[sb->len] = '\0';
>  }
> -
> -extern void strbuf_remove(struct strbuf *, size_t pos, size_t len);
> -
>  extern void strbuf_add(struct strbuf *, const void *, size_t);
>  static inline void strbuf_addstr(struct strbuf *sb, const char *s) {
>  	strbuf_add(sb, s, strlen(s));
> @@ -92,7 +88,4 @@ static inline void strbuf_addstr(struct strbuf *sb, const char *s) {
>  __attribute__((format(printf,2,3)))
>  extern void strbuf_addf(struct strbuf *sb, const char *fmt, ...);
>  
> -/* XXX: if read fails, any partial read is undone */
> -extern ssize_t strbuf_read(struct strbuf *, int fd, ssize_t hint);
> -
>  #endif /* __NDCTL_STRBUF_H */
> 
> base-commit: a3d56f0ca5679b7c78090c1a8b0b9f1f9901e5e0

