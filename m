Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2741F930
	for <nvdimm@lists.linux.dev>; Thu, 10 Apr 2025 01:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744247141; cv=none; b=dKf4GFovzNj0E5lAyEZVyuyGNzUCRym9Wt+6Mcef7z0vPobWLBwxI7OnJZ9ixKIDB+AEUZBZd6erC5wwZIboVRckxvKqA3JbKK//bMRGDPg69cJD06uIzNOBWKWmL4Idrdqp0CwUyGI4EbFL3X0rMUVXwETGxu/Ji8j/H1dreMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744247141; c=relaxed/simple;
	bh=NHyy+dT47wgoaxqkJxxAHtN6f0EvVruudiCU98rqoOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e6ocEHmOdkUVNz/V+a1+dszsfjFg+1qWl4VysN5inIcJT2bJ8xhbC/PmbXI5DpUrhZ8g7277akVJjG2I72YKhQVeiF0BG3S2CouPAq9ruwzjAcuyWopl+1TOoHMTNk1OISK0zWR+ouhbydEi08M44pC5InzPfapJNzwFRGlmiFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ih8lJ4bT; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ih8lJ4bT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744247140; x=1775783140;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NHyy+dT47wgoaxqkJxxAHtN6f0EvVruudiCU98rqoOk=;
  b=ih8lJ4bT18u8w3pRzGPnf8XMCP9AoZa38xTnNIxtR7jyODdvhChqDcNn
   6cbhwWQ7pRfRvVL3jGMTFr2t4bJ2rIR+qykFwV0q3iKLQ/6QmxTbP6w0+
   O92ZRhadkmRwFt89VlLJ5wnsBJbQ0JfpbLUYHIWzz6Qi7M/fxvEEeFwqR
   cAB5073IYlWcvDxEM7r9rYpttj4RaJSQGFx/ARSh5wzgiLQOieuBPzaMN
   iHgMKuG6JPd57trH472cwF5tPy52WAgos+WRYWuY3dFwHf3tFDvrQhg/A
   raXzE5VmOoW737/C6tK7huihymk/kAuSfApYpbrU3osQyexQKqx1l0lmB
   w==;
X-CSE-ConnectionGUID: 8raETTXlTkSj3TH5fAlhSw==
X-CSE-MsgGUID: XSyLC+4eRx2Yebu7+IwmdQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="56385494"
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="56385494"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 18:05:37 -0700
X-CSE-ConnectionGUID: bGK3daUvTO6Ss9z+Jc0moQ==
X-CSE-MsgGUID: dyJct4prRPCE+tXVaUAmkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,201,1739865600"; 
   d="scan'208";a="128603151"
Received: from ldmartin-desk2.corp.intel.com (HELO [10.125.111.236]) ([10.125.111.236])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 18:05:36 -0700
Message-ID: <3466b294-612f-4ca2-8df3-a20fdef4514b@intel.com>
Date: Wed, 9 Apr 2025 18:05:35 -0700
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

Yes. Needed for using BIT() for EFFECTS_MASK. 

DJ
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

