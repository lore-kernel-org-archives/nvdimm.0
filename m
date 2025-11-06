Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B7F18E1F;
	Thu,  6 Nov 2025 05:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762406027; cv=none; b=nYGdk5buGf8u6zSXmpelKc5Gl+NfcaSaCcfXUZTlACmfEmWG8uxipeJRYZ4skJ+im6jMzjANu0fP0ie2taF6EF8AVFLwOjZ4OLRr26wu5TnT+mW8N6LrwHIarDFw1eWD1wFbwsZjrf4UeUc9p+C91sEaFTZ9bvR8YfdrHpGmFS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762406027; c=relaxed/simple;
	bh=J+8wlaHncRyt5SuSvOxykND65Ahpqc/GJDJTp5Wja1M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kkCT9ASBEdRtTSfGRmqoI/DefoOlzhUsyM8iD4EHDd8XXDmD/yGI0uk/WTUiO3qrlletKf6yqWpdLJRX7uEAXCk7mc7e1HGwlVgN5VBygK+Zy6K4lZBVPSq3yphJGDoO8TlRYR1rDVywD96haUcqlyJcbgaJMQUeQHBsdxzue6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SiyzmSMD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SiyzmSMD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=JsKq5nmO2jT0eHLlJVsQ+S/I+VhNGWO6qyv/96A5DjQ=; b=SiyzmSMDoOX+cWc9fOaTckdy/j
	Ehw6UbT/+v3JKkTgKhCfYdQPUE8H8/WUV80/gONHoC3g8lLkLh43ytZTZObWKFV2AUh4xLlSNBz5o
	UdJG5hcSDfWAvOsU/hKcLDJFOqj2mFH3xOC/cMdCVrKRVzjgxgNhh4ER+uK3bs8Yqtm2ny2Uwu0Jz
	n4e/+SEvSO3klkaedu3Wu+DhybdhFfRYokvQ5JkgKbblZoDiAcYXiRsfAQH1zVDUDThlbZ805FcLF
	MGCkhu6FXn8T9PJflLhv9xC9Auw96AEpnuoMYqlNzv3+JqKL60Mz1DWkba5kT41gpminKWvSb7Vyj
	EkcWvJdg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vGsJU-0000000EsOg-3dew;
	Thu, 06 Nov 2025 05:13:36 +0000
Message-ID: <101dc854-cb33-4d69-983c-3ec8d9fea5aa@infradead.org>
Date: Wed, 5 Nov 2025 21:13:35 -0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: btt: Unwrap bit 31-30 nested table
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux NVDIMM <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jonathan Corbet <corbet@lwn.net>
References: <20251105124707.44736-2-bagasdotme@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251105124707.44736-2-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/5/25 4:47 AM, Bagas Sanjaya wrote:
> Bit 31-30 usage table is already formatted as reST simple table, but it
> is wrapped in literal code block instead. Unwrap it.
> 
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

LGTM. Thanks.

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>


> ---
>  Documentation/driver-api/nvdimm/btt.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/driver-api/nvdimm/btt.rst b/Documentation/driver-api/nvdimm/btt.rst
> index 107395c042ae07..2d8269f834bd60 100644
> --- a/Documentation/driver-api/nvdimm/btt.rst
> +++ b/Documentation/driver-api/nvdimm/btt.rst
> @@ -83,7 +83,7 @@ flags, and the remaining form the internal block number.
>  ======== =============================================================
>  Bit      Description
>  ======== =============================================================
> -31 - 30	 Error and Zero flags - Used in the following way::
> +31 - 30	 Error and Zero flags - Used in the following way:
>  
>  	   == ==  ====================================================
>  	   31 30  Description
> 
> base-commit: 27600b51fbc8b9a4eba18c8d88d7edb146605f3f

-- 
~Randy
