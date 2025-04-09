Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B697C1B6CE4
	for <nvdimm@lists.linux.dev>; Wed,  9 Apr 2025 23:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744240237; cv=none; b=lw+QUWQyemiEwLfgbC1cUiKoSfgH76v50udrysE1TId2/0tDQ7ZCChIUVvd2+RsVBKJXq/UZPklLCAvp92ANcgmE5eDwYwFQUViJ1tX8+NsRUkLbqb4C3o6MvE0iNHusWafiSP0beSHyWtrLV5i/TAsa4naANymVX6pp8GDUlHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744240237; c=relaxed/simple;
	bh=u/n1aGmfJVgYwSs7QCF5pzObc3G0d4j4oIh8RMHqRTY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OR4eE1Xr+xNrgfAE/YWtTEZq5Vex/8k2g2h8NDH1ewJKDuE47oVPR1v71OXAyCSJ2KUtjFXjfvy72BVF+S/sgPAPo0cXRaG5TxhWHvjFvXvt69j34TkPs8WdQq0YwkDvCzDI1EtvFkNIpqN8oFW/rY4qHaJQFBIKm/YFfeXtJdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d+Di66rD; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d+Di66rD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744240236; x=1775776236;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=u/n1aGmfJVgYwSs7QCF5pzObc3G0d4j4oIh8RMHqRTY=;
  b=d+Di66rDH+LBa+VFZhNi5YXr28ocvNrxX1pSImaJYKvonp4pDEISr+Sg
   78ITTJ033tys0NTOtWe/4ArMenimi2Z7K0nxpme8SXmW1s+mMd09zj8CE
   lSbaiijGjESj8RbJzq+0IlJ0aeSN5nAmzeYEDtWTp6HOrDFD0veCIRc5m
   YEMBE8o3j6Z8807zVGI8F5jOZ0DpweRxaGX1Fep2SvvF7o52gvbIjH5pn
   fgxj9iuPM29XkLbpG45MzgBkCPQB7aLemWCkkVl42lp8uKBjDmnWGb95f
   uJ5wq8Bu0A/9+dMCvMEKPfOwxhglYJGmyCFGuFym7arfAnJlzxxCU5Lfg
   g==;
X-CSE-ConnectionGUID: 7ryKX7nzQgKWlNWSR8eE6Q==
X-CSE-MsgGUID: IlBMbX+ZTra1FlWT2Z9KNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="55916489"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="55916489"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 16:10:35 -0700
X-CSE-ConnectionGUID: 3Z8dVSIgQOmShvUYqrpciw==
X-CSE-MsgGUID: EX3LycqjRUaB+7xsOGbZYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="159690303"
Received: from ldmartin-desk2.corp.intel.com (HELO [10.125.111.236]) ([10.125.111.236])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 16:10:34 -0700
Message-ID: <c0094e14-3eec-4be1-b83d-e2e2c301da51@intel.com>
Date: Wed, 9 Apr 2025 16:10:30 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [NDCTL PATCH v4 3/3] cxl/test: Add test for cxl features device
To: Alison Schofield <alison.schofield@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <20250218230116.2689627-1-dave.jiang@intel.com>
 <20250218230116.2689627-4-dave.jiang@intel.com>
 <Z_bbK_XRsyYz4ezA@aschofie-mobl2.lan>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <Z_bbK_XRsyYz4ezA@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/9/25 1:40 PM, Alison Schofield wrote:
> On Tue, Feb 18, 2025 at 03:59:56PM -0700, Dave Jiang wrote:
>> Add a unit test to verify the features ioctl commands. Test support added
>> for locating a features device, retrieve and verify the supported features
>> commands, retrieve specific feature command data, retrieve test feature
>> data, and write and verify test feature data.
>>
> 
> Let's revisit the naming -
> 
> If the script is cxl-feature.sh then would the C program make sense as
> feature-control.c or ???

I don't have strong opinions on this. I can change it to feature-control.c. 

DJ

> 
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>> v4:
>> - Adjust for kernel changes of input/out data structures
>> - Setup test script to error out if not -ENODEV
>> - Remove kernel 6.15 check
>> ---
>>  test/cxl-features.sh |  31 ++++
>>  test/fwctl.c         | 383 +++++++++++++++++++++++++++++++++++++++++++
>>  test/meson.build     |  45 +++++
>>  3 files changed, 459 insertions(+)
>>  create mode 100755 test/cxl-features.sh
>>  create mode 100644 test/fwctl.c
>>
>> diff --git a/test/cxl-features.sh b/test/cxl-features.sh
> 
> snip
> 
>> diff --git a/test/fwctl.c b/test/fwctl.c
>> new file mode 100644
>> index 000000000000..ca39e30f6dca
>> --- /dev/null
>> +++ b/test/fwctl.c
>> @@ -0,0 +1,383 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +// Copyright (C) 2024-2025 Intel Corporation. All rights reserved.
>> +#include <errno.h>
>> +#include <fcntl.h>
>> +#include <stdio.h>
>> +#include <endian.h>
>> +#include <stdint.h>
>> +#include <stdlib.h>
>> +#include <syslog.h>
>> +#include <string.h>
>> +#include <unistd.h>
>> +#include <sys/ioctl.h>
>> +#include <cxl/libcxl.h>
>> +#include <cxl/features.h>
>> +#include <fwctl/fwctl.h>
>> +#include <fwctl/cxl.h>
>> +#include <linux/uuid.h>
>> +#include <uuid/uuid.h>
>> +#include <util/bitmap.h>
> 
> Not clear bitmap.h is needed?
> 
>> +
>> +static const char provider[] = "cxl_test";
>> +
>> +UUID_DEFINE(test_uuid,
>> +	    0xff, 0xff, 0xff, 0xff,
>> +	    0xff, 0xff,
>> +	    0xff, 0xff,
>> +	    0xff, 0xff,
>> +	    0xff, 0xff, 0xff, 0xff, 0xff, 0xff
>> +);
>> +
>> +#define CXL_MBOX_OPCODE_GET_SUPPORTED_FEATURES	0x0500
>> +#define CXL_MBOX_OPCODE_GET_FEATURE		0x0501
>> +#define CXL_MBOX_OPCODE_SET_FEATURE		0x0502
>> +
>> +#define GET_FEAT_SIZE	4
>> +#define SET_FEAT_SIZE	4
>> +#define EFFECTS_MASK	(BIT(0) | BIT(9))
>> +
>> +#define MAX_TEST_FEATURES	1
>> +#define DEFAULT_TEST_DATA	0xdeadbeef
>> +#define DEFAULT_TEST_DATA2	0xabcdabcd
>> +
>> +struct test_feature {
>> +	uuid_t uuid;
>> +	size_t get_size;
>> +	size_t set_size;
>> +};
>> +
>> +static int send_command(int fd, struct fwctl_rpc *rpc, struct fwctl_rpc_cxl_out *out)
>> +{
>> +	if (ioctl(fd, FWCTL_RPC, rpc) == -1) {
>> +		fprintf(stderr, "RPC ioctl error: %s\n", strerror(errno));
>> +		return -errno;
>> +	}
>> +
>> +	if (out->retval) {
>> +		fprintf(stderr, "operation returned failure: %d\n", out->retval);
>> +		return -ENXIO;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> Above the send_command() is factored out and reused. How about doing similar with
> the ioctl setup - ie a setup_and_send_command() that setups up the ioctl and calls
> send_command(). That removes redundancy in *get_feature, *set_feature, *get_supported.
> 
> 
>> +
>> +static int cxl_fwctl_rpc_get_test_feature(int fd, struct test_feature *feat_ctx,
>> +					  const uint32_t expected_data)
>> +{
>> +	struct cxl_mbox_get_feat_in *feat_in;
>> +	struct fwctl_rpc_cxl_out *out;
>> +	struct fwctl_rpc rpc = {0};
>> +	struct fwctl_rpc_cxl *in;
>> +	size_t out_size, in_size;
>> +	uint32_t val;
>> +	void *data;
>> +	int rc;
>> +
>> +	in_size = sizeof(*in) + sizeof(*feat_in);
>> +	rc = posix_memalign((void **)&in, 16, in_size);
>> +	if (rc)
>> +		return -ENOMEM;
>> +	memset(in, 0, in_size);
> 
> How about de-duplicating the repeated posix_memalign() + memset() pattern into
> one helper func like alloc_aligned_memory() - including the memset on success.
> 
> 
>> +	feat_in = &in->get_feat_in;
>> +
>> +	uuid_copy(feat_in->uuid, feat_ctx->uuid);
>> +	feat_in->count = feat_ctx->get_size;
>> +
>> +	out_size = sizeof(*out) + feat_ctx->get_size;
>> +	rc = posix_memalign((void **)&out, 16, out_size);
>> +	if (rc)
>> +		goto free_in;
>> +	memset(out, 0, out_size);
>> +
>> +	in->opcode = CXL_MBOX_OPCODE_GET_FEATURE;
>> +	in->op_size = sizeof(*feat_in);
>> +
>> +	rpc.size = sizeof(rpc);
>> +	rpc.scope = FWCTL_RPC_CONFIGURATION;
>> +	rpc.in_len = in_size;
>> +	rpc.out_len = out_size;
>> +	rpc.in = (uint64_t)(uint64_t *)in;
>> +	rpc.out = (uint64_t)(uint64_t *)out;
>> +
>> +	rc = send_command(fd, &rpc, out);
>> +	if (rc)
>> +		goto free_all;
>> +
>> +	data = out->payload;
>> +	val = le32toh(*(__le32 *)data);
>> +	if (memcmp(&val, &expected_data, sizeof(val)) != 0) {
>> +		rc = -ENXIO;
>> +		goto free_all;
>> +	}
>> +
>> +free_all:
>> +	free(out);
>> +free_in:
>> +	free(in);
>> +	return rc;
>> +}
>> +
> snip
> 
>> +static int test_fwctl_features(struct cxl_memdev *memdev)
>> +{
>> +	struct test_feature feat_ctx;
>> +	unsigned int major, minor;
>> +	int fd, rc;
>> +	char path[256];
>> +
>> +	major = cxl_memdev_get_fwctl_major(memdev);
>> +	minor = cxl_memdev_get_fwctl_minor(memdev);
>> +
>> +	if (!major && !minor)
>> +		return -ENODEV;
>> +
>> +	sprintf(path, "/dev/char/%d:%d", major, minor);
>> +
>> +	fd = open(path, O_RDONLY, 0644);
>> +	if (!fd) {
>> +		fprintf(stderr, "Failed to open: %d\n", -errno);
>> +		return -errno;
>> +	}
> 
> Needs to be "if (fd < 0)"  as open() returns -1 on failure.
> 
> snip 

