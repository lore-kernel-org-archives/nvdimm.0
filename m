Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5A21CB9F4
	for <nvdimm@lists.linux.dev>; Tue, 15 Oct 2024 15:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729004595; cv=none; b=WdG9t6VXXHm1snPrAaRnv+bVh8QibB4/ozNyER7PyTdcspkCsOzYXcYFDRX3XvTIiW3TVarYuzwhWy7rJvwhl27t1b4wSyeHiM/NLgOU8YPac5gtpCAohhNmQI1e2xrpCpK+UNd5wghboYhkHoHDK4CiPxBiQtHt+kA+nf+onfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729004595; c=relaxed/simple;
	bh=CN9mt60+HYnFvhNLWXz/tszphf+objzWA9SsrJedVrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mvb9J38zL8edZeraY2BV+X6451PV92nfKipEiK2wUcEBgBiWQ3wO358cWOr1wY/rWHrNllJJe07r0uoIW/XNN++HijENGIqLpOHKBTis4r+i+4RCqmq2p0+oNLVZn8Rnrbq8pOKC68HUxbkKq4Kp3hoGZlSQxIoCNt7HS07qRYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U1qwVUBn; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U1qwVUBn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729004594; x=1760540594;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CN9mt60+HYnFvhNLWXz/tszphf+objzWA9SsrJedVrE=;
  b=U1qwVUBnKO0liOGRxzjQUkFxnaiNxtf95r3v8Lzhg93mkU8S/rN6vcHz
   K6dydIGS7KSbZQB3FuKekX2IH+R8XzwvYCmACm7D1i7OB6iG9QqWASQyr
   33NmtVb6fBs7kNkfL3hkcyQ2fSANE7E0xc86M+xO/a8uzHYKqM+TJRVvj
   5G0hydooL+KtQB9cMcfi3ma7qy4ThzBDTNohJGdUOWvEu2WzncwBPcdfw
   iQaxr/7+CkB10HW4/oLNVKWoLkvjJj+G4qQEzVGRapW6YrM60hSzdk5Wi
   Lhm6gs/f5jdMXMjeV9N0bIol0HiYbD4ZlhSwqko90KMj9l6M8YTb/eFSm
   w==;
X-CSE-ConnectionGUID: 4HzcuKEDTkiRoh5iaxhbqA==
X-CSE-MsgGUID: ZW0z34tAQq6RJjfSRztZcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11225"; a="39797261"
X-IronPort-AV: E=Sophos;i="6.11,205,1725346800"; 
   d="scan'208";a="39797261"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 08:03:13 -0700
X-CSE-ConnectionGUID: K4AGjJODR+u1eTtmmZx/MA==
X-CSE-MsgGUID: VFb+fQloS2enTGkjG48sBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,205,1725346800"; 
   d="scan'208";a="77542618"
Received: from inaky-mobl1.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.108.104])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 08:03:13 -0700
Date: Tue, 15 Oct 2024 08:03:10 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Zhijian Li (Fujitsu)" <lizhijian@fujitsu.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
Subject: Re: [ndctl PATCH] test/security.sh: add missing jq requirement check
Message-ID: <Zw6ELmhPn17NiQeY@aschofie-mobl2.lan>
References: <20241014064951.1221095-1-lizhijian@fujitsu.com>
 <254daa12-810b-4b2c-a927-0d12094ecc4d@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <254daa12-810b-4b2c-a927-0d12094ecc4d@fujitsu.com>

On Mon, Oct 14, 2024 at 06:56:12AM +0000, Zhijian Li (Fujitsu) wrote:
> 
> 
> On 14/10/2024 14:49, Li Zhijian wrote:
> > Add jd requirement check explicitly like others so that the test can
> > be skipped when no jd is installed.
> 
> Fix a typo
> s/jd/jq
> 

Thanks! I'll fix up the typo when I apply it.
Reviewed-by: Alison Schofield <alison.schofield@intel.com>

