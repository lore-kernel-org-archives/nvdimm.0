Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4932B1EA74
	for <nvdimm@lists.linux.dev>; Mon,  8 Jul 2024 20:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720472219; cv=none; b=q2YMMxpjUk9XI4gnffz5OzH4zdqD/0b5xhXKnLHM85XXpsrZYN9QtS8h1xbPYMYngScg6+c8hkn0p4WVwwSJgNy6sXSqIVjjtqsTuuatbJGwn+YSiz9s4tfUNFSizp4RTDdaUKcB0Q3Ai7GaxD/ApchKbAAZMHfNxDxE6PAwn+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720472219; c=relaxed/simple;
	bh=Hyj9bbq09DzCn5Ot+Yw6VpSUjwgE6ok381CKCCf9nh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJjG0sFfh3Ufh3ONliHJ3cGUe7U2RuEBW1flwDcxDV5aHWgkYcoq/1CXXuw5Ls1qFPC/IPlRNEEhCxBOSHHlC3PyUdN0uO2nqb0XpClgQND9jmKly7D63y/pJrKs1NHurAioAnhoSzQDUi6uIFZqVP7pq01Nb5cWmF6Zp2fK6WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N+GW31uF; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N+GW31uF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720472218; x=1752008218;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Hyj9bbq09DzCn5Ot+Yw6VpSUjwgE6ok381CKCCf9nh8=;
  b=N+GW31uFYd7nNH4FBI7mjcLzi8Y7wrkoriqVc26ne6htfLaWGUG0q5pz
   fix1wzdfMqqPGRAfxtfXDedOuMYyQ4ITJRI6Gu4GGSTJDAmhzNeUYxyR8
   cQUD8M+FxOF5O4xx871e8qCfNa8tdMmH9z6mhVRGwWeTt+npC8/IbAQmA
   j/m+0ahCOHEGlBY3Nkm6M4UCBXlPVfaxRihB4T9H1FolomSqmwpookV8V
   vDduMKKN/O29NggY87zxUn4Z72LeaCisN5KCJ7HmVk8MsQWBQBrdZK0IT
   dpt38sfoMwWNXSLdfltBWw7WG2Gd1YyRXDxuGs9T7METcSnOV35nMJe8m
   A==;
X-CSE-ConnectionGUID: gJlzpYjWS4Syylwagfyb2g==
X-CSE-MsgGUID: eZ+H/UWUQaKzVXtH6G3N2w==
X-IronPort-AV: E=McAfee;i="6700,10204,11127"; a="20599162"
X-IronPort-AV: E=Sophos;i="6.09,193,1716274800"; 
   d="scan'208";a="20599162"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 13:56:57 -0700
X-CSE-ConnectionGUID: BIvVlcKpTCGAiKgzwb4Jmg==
X-CSE-MsgGUID: dGd2blTSRVCkV9Emi4YkKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,193,1716274800"; 
   d="scan'208";a="85164181"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.105.241])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2024 13:56:57 -0700
Date: Mon, 8 Jul 2024 13:56:55 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: "Xingtao Yao (Fujitsu)" <yaoxt.fnst@fujitsu.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [ndctl PATCH v13 7/8] cxl/list: add --media-errors option to cxl
 list
Message-ID: <ZoxSl2tBU5ARmLuC@aschofie-mobl2>
References: <cover.1720241079.git.alison.schofield@intel.com>
 <76eb7636d1aab2fecd60d18617828d004adb58d9.1720241079.git.alison.schofield@intel.com>
 <OSZPR01MB6453378E193594694EFD71BD8DDA2@OSZPR01MB6453.jpnprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <OSZPR01MB6453378E193594694EFD71BD8DDA2@OSZPR01MB6453.jpnprd01.prod.outlook.com>

On Mon, Jul 08, 2024 at 02:26:11AM +0000, Xingtao Yao (Fujitsu) wrote:
> >  -v::
> >  --verbose::
> >  	Increase verbosity of the output. This can be specified
> > @@ -431,7 +485,7 @@ OPTIONS
> >  	  devices with --idle.
> >  	- *-vvv*
> >  	  Everything *-vv* provides, plus enable
> > -	  --health and --partition.
> > +	  --health, --partition, --media-errors.
> insert  an “and”  before "--media-errors" may be better.

Well...I'm not a fan of the "and', but since it was there before,
and it is still used in the single -v case, I'll put it back to
be the same.

Eagle eye! Thanks for testing it out!

--Alison

> 
> Tested-by: Xingtao Yao <yaoxt.fnst@fujitsu.com>
