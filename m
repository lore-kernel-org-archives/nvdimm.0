Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A1242F70C
	for <nvdimm@lists.linux.dev>; Mon, 27 Jul 2026 17:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785173132; cv=none; b=ZNs0LJX7v2oYGjFqWwvWfF6Z1YBe1Z43jxaFG6I7Z+tVIJ6mJOckc7212MDSxMv+fRi7sS42qgqmhlFaoLHjDOvjSdP7uNS71Uk3wXqhmNQAHPng2aK2xOhndKc8cujwc1zbHIDtJyNuTkxWBzE8zXgsBe22VphZxFd+ANpOYkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785173132; c=relaxed/simple;
	bh=xIc7mbEEDl2XzJ10CqzA3H5i8CNoTKHQjJm395IfRYM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pOVstTQwMEeHUfYUjXzzg3yTXIq4Xw3w5EsFdeH6JQiYyzaZFRCw9eB7j2tmd1K7dyXgQ4sV+ZM3MagP7+qfu0swMuvXlkkWRJsNblWNIxOskO4SlvA2sKzyM8fbtJvueCg+AZdNtN+H/fIcaJe0v47OaYNnfkcGgrlPAjfH+kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FIWeoE5i; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FIWeoE5i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785173128; x=1816709128;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xIc7mbEEDl2XzJ10CqzA3H5i8CNoTKHQjJm395IfRYM=;
  b=FIWeoE5iJW8OUC/vfsOnZ8qxoSrpX/xooM7XyRcRvf4Ma3/5Jto9Ki/U
   o/dvpfqpLlawJIKyrE6UjaUTaC+/wOhPjle1h/j19mohXXkT+nqPy5Kaf
   bNVxFjztP9ZtJ6tPDXjnpAusHivTw+roOFCoJywB9u25X2CuY+6CoZPdn
   BcyQ8Ag0cMAglGPL2fXQpIkjf3xJTE0oPl/s46x/P8HYe5T8dUNpbNGLL
   G9rZy9LhRm1S92HGIGBK8WlP/O8hjuu8koQ82BBW3Hic0xvdLJ4yZxL7w
   kevIqt4jdbXkh+ed2RnH164zQSv/kpXjhyXCyOkkPsKzpDx0iaZZqOvVs
   A==;
X-CSE-ConnectionGUID: DGtIJKGsTNqakKK0O/MwoQ==
X-CSE-MsgGUID: LD1zux/RT96mirC4QDN9sw==
X-IronPort-AV: E=McAfee;i="6800,10657,11858"; a="85616621"
X-IronPort-AV: E=Sophos;i="6.25,188,1779174000"; 
   d="scan'208";a="85616621"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 10:25:24 -0700
X-CSE-ConnectionGUID: eJcnvQFeQH2jgYbho+PJBA==
X-CSE-MsgGUID: qV4n0T5IRLyMVSQ2csM7uw==
X-ExtLoop1: 1
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.111.47]) ([10.125.111.47])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 10:25:22 -0700
Message-ID: <ce2fc791-e84b-49e7-8d9b-f864ee82aa25@intel.com>
Date: Mon, 27 Jul 2026 10:25:21 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/9] ACPI: nfit: core: drop unused assignment of
 acpi_device_id::driver_data
To: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>, Zhang Rui <rui.zhang@intel.com>,
 Kai-Heng Feng <kaihengf@nvidia.com>, Tony Luck <tony.luck@intel.com>,
 Borislav Petkov <bp@alien8.de>, Hanjun Guo <guohanjun@huawei.com>,
 Mauro Carvalho Chehab <mchehab@kernel.org>,
 Shuai Xue <xueshuai@linux.alibaba.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Sudeep Holla <sudeep.holla@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Alison Schofield <alison.schofield@intel.com>, Ira Weiny <iweiny@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 nvdimm@lists.linux.dev
References: <20260727-acpi-refactor-v1-0-ff900aa326ee@thegoodpenguin.co.uk>
 <20260727-acpi-refactor-v1-7-ff900aa326ee@thegoodpenguin.co.uk>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260727-acpi-refactor-v1-7-ff900aa326ee@thegoodpenguin.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/27/26 5:10 AM, Pawel Zalewski (The Capable Hub) wrote:
> This module sets the acpi_device_id::driver_data to 0 but
> the field is not actually used within the module, we can
> just drop it from the table.
> 
> While we are at it - used a named initializer for the
> acpi_device_id::id field to increase readability and
> drop explicitly setting the list terminator fields.
> 
> Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  drivers/acpi/nfit/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index cb771d9cadb2..5732df5d53f0 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -3515,8 +3515,8 @@ void __acpi_nfit_notify(struct device *dev, acpi_handle handle, u32 event)
>  EXPORT_SYMBOL_GPL(__acpi_nfit_notify);
>  
>  static const struct acpi_device_id acpi_nfit_ids[] = {
> -	{ "ACPI0012", 0 },
> -	{ "", 0 },
> +	{ .id = "ACPI0012" },
> +	{ }
>  };
>  MODULE_DEVICE_TABLE(acpi, acpi_nfit_ids);
>  
> 

