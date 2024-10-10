Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138BF1E2029
	for <nvdimm@lists.linux.dev>; Thu, 10 Oct 2024 18:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728586049; cv=none; b=OB0gRMYn6ZKJcuo9ZTpzBYgNo0d8Zz5bgLA4AxL7gdofLKQTXfNkUTBMesRBrpzUuNod2C9fr5eC2QZoTXy8Q2EgmyrUgiOK3VwNk/Subj2VIDTcss/ca2/kssgH8ljWENTi8H07KKb3JIZCBIJShzCJSVlPgY8n1YGWVNAv8Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728586049; c=relaxed/simple;
	bh=9vs5tziIIS3nCdRfGbG36l/mT5xyiYeXHMHVxja+k0o=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=b961Jmz6m2LSSTixPHHlRIXYPLl7pAq0Ug4XHzeaYJ3AaJfiLZOLS6/8uE3JgQDSiQkaGy04agpkxu9d9Jg9YulPw0dUrgW2wwgxqs4/ikWlfbvxCuARQJhhAkyW2eoetkdOcHsHYGp+aCgiCfkUpZzVZmcbfv17CsVu4cWAkUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y4bWeGMy; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y4bWeGMy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728586048; x=1760122048;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=9vs5tziIIS3nCdRfGbG36l/mT5xyiYeXHMHVxja+k0o=;
  b=Y4bWeGMygzNULkNTp72mE6D36Qkb98zAMuSZz6GzVlq55vc2zK7KE4o4
   sNIuJJUghPNnemEQTDSyNRyck0OKs/sb+JPE2Fl9ekezNWD280YpJ4enw
   vzWhzhUTMmvygFU+0fp84aE3/rej91lf4HnNkK1xtX/Di/6OvbfSjq/D6
   AWhq6XIzWTtpgS6OKkvSyQ5LnclEo+yqBa8b2dHAbyir9vPm7MC0BoBm7
   Ljt3uYwJl06FCXDz7zoGOPJ401Gqchvp27U5fCNxs8+SAXyYf8O7zBR2D
   wfZOxe986ebwkV3rhMSeBhulB1/S39W5aPK1OMiuw9gsNkVYR8HOQHnHB
   w==;
X-CSE-ConnectionGUID: lzunYxu4R7qkjiAWRiJsnA==
X-CSE-MsgGUID: txbfNFFdSlSRMaGfiNEp5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11221"; a="27840877"
X-IronPort-AV: E=Sophos;i="6.11,193,1725346800"; 
   d="scan'208";a="27840877"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 11:47:27 -0700
X-CSE-ConnectionGUID: icxbKZmeSGGVO6EJIVlo5A==
X-CSE-MsgGUID: Ulr4jhA1RAqVxfv48sR/dQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,193,1725346800"; 
   d="scan'208";a="107399210"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.78])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 11:47:27 -0700
Date: Thu, 10 Oct 2024 11:47:25 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [ANNOUNCE] ndctl v80
Message-ID: <ZwghPVR1c5tl4csC@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

A new ndctl release is available[1].

This release incorporates functionality up through the 6.11 kernel.

Highlights include support for listing CXL media-errors, usability
fixups in daxctl create-device, the addition of a firmware revision
to CXL memdev listings, and misc unit test and build fixes.

A shortlog is appended below.

[1]: https://github.com/pmem/ndctl/releases/tag/v80


Alison Schofield (13):
      util/trace: move trace helpers from ndctl/cxl/ to ndctl/util/
      util/trace: add an optional pid check to event parsing
      util/trace: pass an event_ctx to its own parse_event method
      util/trace: add helpers to retrieve tep fields by type
      libcxl: add interfaces for GET_POISON_LIST mailbox commands
      cxl/list: collect and parse media_error records
      cxl/list: add --media-errors option to cxl list
      cxl/test: add cxl-poison.sh unit test
      cxl/test: add test case for region info to cxl-events.sh
      cxl/list: add firmware_version to default memdev listings
      test/daxctl-create.sh: use bash math syntax to find available size
      test/daxctl-create.sh: use CXL DAX regions instead of efi_fake_mem
      test/rescan-partitions.sh: refine search for created partition

Jeff Moyer (2):
      ndctl/keys.c: don't leak fd in error cases
      libndctl: major and minor numbers are unsigned

Jerry James (1):
      ndctl.spec.in: enable libtrace{event|fs} support for Fedora

Li Zhijian (2):
      daxctl: fail create-device if extra parameters are present
      daxctl: remove unused options in create-device usage message

Miroslav Suchy (1):
      ndctl.spec.in: use SPDX formula for license
