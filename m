Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4507F611A
	for <nvdimm@lists.linux.dev>; Wed, 17 Jan 2024 05:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705469083; cv=none; b=RHXDb6/dCLIZX2yLocyJpL6XKDm67IMb2dgZpYPk+M3Xxfs2w3rTfvGjdCFDZ82HgO7aqkNC1RwM1aqW/6+Ujz+P669prYCe24MbtEG8XMU//W20Ydl3IU/Ui+tzep24VCRu6dR/Md4cwOl+pTCAyHCsy97ZnFpJgkC2WZdNlKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705469083; c=relaxed/simple;
	bh=HEDIonH0WP/lXG0Bd31YDJ6AkBXPbko870At2fBrPQ0=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To; b=EGXnwAtwWqF4AXzoBC2PEGY5ennKSHwx04RYXvg5vdhFBi7fRRO13Sz/Iu8lio5fIuCCLUCB3CI2bAvUxEa7T4F2SVysXM2qa44y1gIVFCWgLFIlxIStWogLye6P6DSPE6g7qHdE9D4sqyl1qBNcESeoTWwQ8kM7dxSbPefTphY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kQNeZX28; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kQNeZX28"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705469082; x=1737005082;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=HEDIonH0WP/lXG0Bd31YDJ6AkBXPbko870At2fBrPQ0=;
  b=kQNeZX281ua4GfTSeWUOonix6CHkFmZrQ0DoZCllyk5OHeJYH4Irh7ap
   Jw5vxV+Dxxfgz6M/wD7XQF2u11zXOXs2+BC7TGkA80pepjqLPEGP7YGYn
   Tk2BG3NXdMr1Ud8wtpsXm5S410rPulQ2BN38Xed2P75hW11hMEOVgLYxN
   c0yF1FMiDZMOpbXmYOVwwgkONrdAzekyt59tWPq5Or/TlMrpGqpvBLpe8
   45X/ozvjRCuRjbbryJerWrOIV72TtRJgEpxQiuMsrZ/PoG7S8ofKE4FI0
   VkNMekOTPReOckD9w5Nv95ft08q9JKlsm3MIOk/11SVSxovRKUfXP/21o
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="21552302"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="21552302"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 21:24:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="903412186"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="903412186"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.51.13])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2024 21:24:41 -0800
Date: Tue, 16 Jan 2024 21:24:39 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH] tools/testing/cxl: Disable "missing prototypes /
 declarations" warnings
Message-ID: <ZadklwbUFupTA6c1@aschofie-mobl2>
References: <170543983780.460832.10920261849128601697.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <170543983780.460832.10920261849128601697.stgit@dwillia2-xfh.jf.intel.com>

On Tue, Jan 16, 2024 at 01:17:17PM -0800, Dan Williams wrote:
> Prevent warnings of the form:
> 
> tools/testing/cxl/test/mock.c:44:6: error: no previous prototype for
> ‘__wrap_is_acpi_device_node’ [-Werror=missing-prototypes]
> 
> tools/testing/cxl/test/mock.c:63:5: error: no previous prototype for
> ‘__wrap_acpi_table_parse_cedt’ [-Werror=missing-prototypes]
> 
> tools/testing/cxl/test/mock.c:81:13: error: no previous prototype for
> ‘__wrap_acpi_evaluate_integer’ [-Werror=missing-prototypes]
> 
> ...by locally disabling some warnings.
> 
> It turns out that:
> 
> Commit 0fcb70851fbf ("Makefile.extrawarn: turn on missing-prototypes globally")
> 
> ...in addition to expanding in-tree coverage, also impacts out-of-tree
> module builds like those in tools/testing/cxl/.
> 
> Filter out the warning options on unit test code that does not effect
> mainline builds.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com


> ---
>  tools/testing/cxl/Kbuild      |    2 ++
>  tools/testing/cxl/test/Kbuild |    2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/tools/testing/cxl/Kbuild b/tools/testing/cxl/Kbuild
> index 0b12c36902d8..caff3834671f 100644
> --- a/tools/testing/cxl/Kbuild
> +++ b/tools/testing/cxl/Kbuild
> @@ -65,4 +65,6 @@ cxl_core-y += config_check.o
>  cxl_core-y += cxl_core_test.o
>  cxl_core-y += cxl_core_exports.o
>  
> +KBUILD_CFLAGS := $(filter-out -Wmissing-prototypes -Wmissing-declarations, $(KBUILD_CFLAGS))
> +
>  obj-m += test/
> diff --git a/tools/testing/cxl/test/Kbuild b/tools/testing/cxl/test/Kbuild
> index 61d5f7bcddf9..6b1927897856 100644
> --- a/tools/testing/cxl/test/Kbuild
> +++ b/tools/testing/cxl/test/Kbuild
> @@ -8,3 +8,5 @@ obj-m += cxl_mock_mem.o
>  cxl_test-y := cxl.o
>  cxl_mock-y := mock.o
>  cxl_mock_mem-y := mem.o
> +
> +KBUILD_CFLAGS := $(filter-out -Wmissing-prototypes -Wmissing-declarations, $(KBUILD_CFLAGS))
> 
> 
