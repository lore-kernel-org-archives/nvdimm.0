Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DB122371B
	for <nvdimm@lists.linux.dev>; Wed, 14 May 2025 21:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747259997; cv=none; b=cplXUNr/JLoeMPb5r52tOPAaYSdHQ804gpqjjYinb/UR5MGshBto3LewC2/B/tGvZU9s9QHNT2uIjN+JYok801NbBv0OLODHx4UsB3iMBm+SgHQr+81XGVxOPwwTeBwOrwDb7z747/pzxmF3oiglYV5NjXie1onouTatQybuTk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747259997; c=relaxed/simple;
	bh=nYqvmRQhVtU3WiNMEOBNM7n4QrXuTmWKGzlMDxZMhKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kjEmNftjVsHZMH45maos9NDbe9Cl6fFPW7WvwoneldQ4miDm2PQ78xMTmREehHgtUjcxMfyIjYV+dUzyic17FKN2byqeCWK/uFiM3KWTjqm5gNKd6pvwwiPZlTKIAGS9pcj6Og7lRtzGl0E465FEh3iFx5T9CIW2HpcfNlSI6EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MwQ/r2jJ; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MwQ/r2jJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747259995; x=1778795995;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nYqvmRQhVtU3WiNMEOBNM7n4QrXuTmWKGzlMDxZMhKo=;
  b=MwQ/r2jJ34mYfUIBFRGUf1A6bvp0SeJ5pLGnZpltD3fL8cPlH1GL8xOr
   00ZGmnWLmjZn07OHq5H6EZR+oOq8U3JhM5zLQhV/4LS4yO5fc+IeZnjur
   j/dL2Ch/PeUziHrGwgsEfYsO5DgHl5ajqXKvZwyL7gLWWHu1fXmisxO+w
   c5PE7MT/kCVDF9TekmDnkYqh1Ldj7bmqThNaB9gnbzwT0QRp+vjhZecaE
   3v5oO47RQyrGrLoci9QbFiTMDxCN6bgYC6SQzFehX3rxgSkKOppROxO/M
   qwB2UXHs77Q4V+kO8I0MczZOQeBvGVqTadtEq1Wu8XzGFvpNLAnWWRRiN
   Q==;
X-CSE-ConnectionGUID: 5CSPsx3wSU2n5z90+P8bTw==
X-CSE-MsgGUID: 3uG/DmblSAWte6HtPVQy+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11433"; a="36800434"
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="36800434"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 14:59:55 -0700
X-CSE-ConnectionGUID: uR7v3s5uRGKEiaPLfky7Lw==
X-CSE-MsgGUID: nUF43/uFRPOYSkBSd6heYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,289,1739865600"; 
   d="scan'208";a="143274536"
Received: from brlerfal-mobl.amr.corp.intel.com (HELO [10.125.212.236]) ([10.125.212.236])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 14:59:55 -0700
Message-ID: <f7cc054c-cd3d-4aac-b26b-5e90e060fd14@linux.intel.com>
Date: Wed, 14 May 2025 14:59:46 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] test/meson.build: use the default POSIX locale for
 unit tests
To: alison.schofield@intel.com, nvdimm@lists.linux.dev
Cc: Vishal Verma <vishal.l.verma@intel.com>
References: <20250514185707.1452195-1-alison.schofield@intel.com>
Content-Language: en-US
From: Marc Herbert <Marc.Herbert@linux.intel.com>
In-Reply-To: <20250514185707.1452195-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-05-14 11:57, alison.schofield@intel.com wrote:
> From: Alison Schofield <alison.schofield@intel.com>
> 
> A user reported that unit test inject-smart.sh fails with locale
> set to LANG=cs.CZ-UTF-8.[1] That locale uses commas as separators
> whereas the unit test expects periods.
> 
> Set LC_ALL=C in the meson.build test environment to fix this and
> to make sure the bash scripts can rely on predictable output when
> parsing in general.
> 
> This failing test case now passes:
> LANG=cs.CZ.UTF-8 meson test -C build inject-smart.sh
> 
> Tidy up by moving the test_env definition out of the for loop.
> 
> [1] https://github.com/pmem/ndctl/issues/254
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>


Reviewed-by: Marc Herbert <marc.herbert@linux.intel.com>



