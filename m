Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8688A1DE2D8
	for <nvdimm@lists.linux.dev>; Mon, 14 Jul 2025 22:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533193; cv=none; b=S3tijdi6cK2HxyxqfMkGDppfX5L8H6qyvxKpJmPHUaMFQYQPTSN5VuYizO8B/grspffRu3cSB9OK4sSNUVJXzBDDyTsQoGaV2+RkaMPtCIq7DW0+PInIYPwoI/4GCe1SE4agY0rhJ1ICG71Q/Kimr1wrg1JB6z4NEKTVGjvqBcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533193; c=relaxed/simple;
	bh=KHikLRAvLAWccDh6KWRsx4zSb7I4VWCifL/HsMOZbkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jiIB+TpdZr6hjMc5PXd0ePvB5qtZwOEXgv1TDm5UgyYTqwtxVK5F0hSXd4juUzz/MpNk4hxhSmOJ3u0pNeTySAZDxlqlfcGESG5xK+MdSl3R+BGONq5FUEhXxUhhxdboddS3fmnidn779JWKHFJJWh6wmzNKtg8d4PUtM2X5iSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oLBMumwn; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oLBMumwn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752533191; x=1784069191;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KHikLRAvLAWccDh6KWRsx4zSb7I4VWCifL/HsMOZbkg=;
  b=oLBMumwnRjVtDKrZAot7Tkr2oo9N5G7DqgPEWJSxflWIa29cH9RjLAt1
   5Td+Rwl74mihlQhHat3t+1krpYrws53VSrNvJRjTHF+UB5Y07mVqDMuR4
   yt0quXluRSn1eZJUn276Y/U20OSIYlSH8fJYbBoOYk6ZX2lNcb+8k9b95
   4+o7xiD7fvJVyt95WvrZsE7HgMW2hPgQCTHxACBtzCQssOzMCIVg9WIzS
   eOGmM3xROSVjr7Y2Ubn5B1Rg5QyyS3rQkJUAyMs8DJoHI9D3dfWjoLU4M
   gRK5sUSphiB8Ybc0P1F1uLP1mN78R6X3kzKIlLJ+hApDFaM3u9C8Xjois
   Q==;
X-CSE-ConnectionGUID: UoB1g/vPQSm+vSsU55eycw==
X-CSE-MsgGUID: 8k74TcKEQFOfYlDSkLOqbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="66097481"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="66097481"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 15:46:30 -0700
X-CSE-ConnectionGUID: Xqr59AfASL+Hq7baB79qbA==
X-CSE-MsgGUID: 5UWPc+QlRviidl2ANpHszw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="157763698"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.125.111.97]) ([10.125.111.97])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 15:46:29 -0700
Message-ID: <bb66089e-71e8-4d0d-89b3-ed2e30a482f0@intel.com>
Date: Mon, 14 Jul 2025 15:46:28 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH v2] cxl: Add helper function to verify port is in
 memdev hierarchy
To: "Verma, Vishal L" <vishal.l.verma@intel.com>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Cc: "Schofield, Alison" <alison.schofield@intel.com>
References: <20250711223350.3196213-1-dave.jiang@intel.com>
 <4da519268938070b448f56d55535f0e3ea4585b0.camel@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <4da519268938070b448f56d55535f0e3ea4585b0.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/14/25 3:27 PM, Verma, Vishal L wrote:
> On Fri, 2025-07-11 at 15:33 -0700, Dave Jiang wrote:
>> 'cxl enable-port -m' uses cxl_port_get_dport_by_memdev() to find the
>> memdevs that are associated with a port in order to enable those
>> associated memdevs. When the kernel switch to delayed dport
>> initialization by enumerating the dports during memdev probe, the
>> dports are no longer valid until the memdev is probed. This means
>> that cxl_port_get_dport_by_memdev() will not find any memdevs under
>> the port.
>>
>> Add a new helper function cxl_port_is_memdev_hierarchy() that checks if a
> 
> Stale commit message - since the actual helper is called
> cxl_memdev_is_port_ancestor() ?

Ooops. Maybe Alison can fix it up when she applies if there are no other changes.

> 
>> port is in the memdev hierarchy via the memdev->host_path where the sysfs
>> path contains all the devices in the hierarchy. This call is also backward
>> compatible with the old behavior.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>> v2:
>> - Remove usages of cxl_port_get_dport_by_memdev() and add documentation to explain
>>   when cxl_port_get_dport_by_memdev() should be used. (Alison)
>> ---
>>  Documentation/cxl/lib/libcxl.txt |  5 +++++
>>  cxl/filter.c                     |  2 +-
>>  cxl/lib/libcxl.c                 | 31 +++++++++++++++++++++++++++++++
>>  cxl/lib/libcxl.sym               |  5 +++++
>>  cxl/libcxl.h                     |  3 +++
>>  cxl/port.c                       |  4 ++--
>>  6 files changed, 47 insertions(+), 3 deletions(-)

