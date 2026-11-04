Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793807690;
	b=vvYiSmyxFGuUuz1CXnoCubtfoBbouqMm2FgDKz21QKlLjEWN+p8aWrSix0NqNoDQF6wo
	 CL67WXDlDXlRY7XrFHys/Un/je3KQ3WgV5n8M1ioI/Z+bB9oKj0lAYB7ifTMYewQa/2ms
	 cKz1MShwYYkuWrry2+FWQo/WqiKAw5iEJKoz0xrHgOcsV38/ZGhNKBirv6qQgXEbifLGn
	 QqD6iMMGWmdHMUMF/nfFxAJwNTpZ1/6b17dOKP+nRdm2sNC1Af/GiO/Fl3AAGISUH/E6M
	 PfOcaWa4ptHLCs5plZXzDfNz2m4eUMUwlNm3Jbu41VMEUg3phNrCBt7ACpc7BNTvpwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793807690;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=P4hQv7IO2J3h+dygp0Q4re8KRq63JJ/rgZi19NJuO6o=;
	b=SamZU3idjUDXgZeShAlgOY0uJz10gJLOgRZgoVlVJUQ7l5FnqC3kgWKpitaFDWIMJuWy
	 TZM759XT+BVwbZgKyldGaG1kmXRSYanm+kb6havHhsABWSNqw5CSDc1LRdF+GsYK13orQ
	 +/RblY9sInqSDsbbLdue2x5gzOm3Gi9x70xvJG3hwwbw0GTBb5CTLycn3JEJxiw4Pf9nD
	 zy5H376PxnLQ7PAok9hIX/Xxtb/mqhuGn4CnDVdtMbTs9wjDEf4G0ehulIZtpchXF8LbG
	 iAVJZhx7lE35l7dA8hWUPuK9iD9P3St2f9D0BDBWEX4UDbG6ctbRQOvHok6f88FiE/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IbiIMteI;
	arc=none smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7FA606A328
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 15:54:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E7FA606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IbiIMteI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793807689; x=1825343689;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+9k5qeGQIu769mNAC2LulOPxwHYXWRB9DSkRtN0Vngc=;
  b=IbiIMteIbZeRFBJeCfP2UO1ZU6tONyCUUtwViwKROmsptuRXFOxpCaJi
   fsT+L2a5nyWTnZbCZpp0qRGc+s5WO8e7u8ndLiVp4U4SYDTh8USYl0lgd
   0cON9H/8eNsB2qmwuBwSm54imXj6VTxmx8QxZHh0vklbQfOqiDZMNxmDJ
   EAZp/K/nKkpsbAyITwz1j9VAP++SNG+4UtZMv5M72IkuYCENgQ+etF/JP
   /xvt/3pa8Jfw1+cGkc2CUx3N9+XwRBlx2j4n4I0kPQ+THC2FSH+uUi2Ge
   wVPPBEuHumeDznRhd8vypLLN7L6k9A9t5Q8/vpGp1zpOCkdhcqsFpNHHJ
   Q==;
X-CSE-ConnectionGUID: ouWqUEK5SsqrE3o5wXarJg==
X-CSE-MsgGUID: R+GKpRR3Tuax2Qt2ImZlhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2603577"
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="2603577"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 07:54:48 -0800
X-CSE-ConnectionGUID: n6IkS+DmTxSz1fnmudDqdA==
X-CSE-MsgGUID: kfazqDcjTya7TfH/DVUBmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,195,1787036400"; 
   d="scan'208";a="7100773"
Received: from sghuge-mobl2.amr.corp.intel.com (HELO [10.125.110.38]) ([10.125.110.38])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 07:54:47 -0800
Message-ID: <08b649be-cbb4-4795-838c-dabda6852158@intel.com>
Date: Wed, 4 Nov 2026 08:54:46 -0700
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: Update CXL, NVDIMM, DAX, and others for djbw
To: Frank Li <Frank.li@oss.nxp.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
 linux-kernel@vger.kernel.org, Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron <jic23@kernel.org>,
 Vinod Koul <vkoul@kernel.org>, Frank Li <Frank.Li@kernel.org>
References: <20261103201547.4079847-1-dave.jiang@intel.com>
 <autNpAFXuBVywP8Q@lizhi-Precision-Tower-5810>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <autNpAFXuBVywP8Q@lizhi-Precision-Tower-5810>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/4/26 8:22 AM, Frank Li wrote:
> On Tue, Nov 03, 2026 at 01:15:47PM -0700, Dave Jiang wrote:
>> Dan is no longer with us. Removing entries in MAINTAINERS to prevent
>> people from keep emailing his address.
>>
>> async_tx will be essentially orphaned. There has been discussion of
>> deprecation for the feature on the dmaengine mailing list.
>>
>> fsdax will no longer have a maintainer. But there are reviewers still
>> and Alison Schofield will continue to wrangle patches for DAX overall.
>>
>> Cc: Alison Schofield <alison.schofield@intel.com>
>> Cc: Vishal Verma <vishal.l.verma@intel.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Davidlohr Bueso <dave@stgolabs.net>
>> Cc: Jonathan Cameron <jic23@kernel.org>
>> Cc: Vinod Koul <vkoul@kernel.org>
>> Cc: Frank Li <Frank.Li@kernel.org>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>
>> ---
>> For FSDAX, Jan or Willy if you guys want to step up and be the
>> maintainer please let me know and I'll update the entry. Thanks.
>> ---
>>  MAINTAINERS | 12 ++----------
>>  1 file changed, 2 insertions(+), 10 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 14e4daf8ea8a..32b86033b5f1 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -4285,8 +4285,7 @@ S:	Maintained
>>  F:	crypto/rsa*
>>
>>  ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
>> -R:	Dan Williams <djbw@kernel.org>
>> -S:	Odd fixes
>> +S:	Orphan
> 
> Can you put my name here now until it is full removed. I have some cleanup
> patch need be merged in case take more time to remove it totally.

Thanks for stepping up Frank. Will do.

DJ

> 
> Frank
> 
>>  W:	http://sourceforge.net/projects/xscaleiop
>>  F:	Documentation/crypto/async-tx-api.rst
>>  F:	crypto/async_tx/
>> @@ -6715,7 +6714,6 @@ M:	Jonathan Cameron <jic23@kernel.org>
>>  M:	Dave Jiang <dave.jiang@intel.com>
>>  M:	Alison Schofield <alison.schofield@intel.com>
>>  M:	Vishal Verma <vishal.l.verma@intel.com>
>> -M:	Dan Williams <djbw@kernel.org>
>>  R:	Ira Weiny <iweiny@kernel.org>
>>  R:	Li Ming <ming.li@zohomail.com>
>>  R:	Richard Cheng <icheng@nvidia.com>
>> @@ -7610,7 +7608,6 @@ S:	Maintained
>>  F:	scripts/dev-needs.sh
>>
>>  DEVICE DIRECT ACCESS (DAX)
>> -M:	Dan Williams <djbw@kernel.org>
>>  M:	Vishal Verma <vishal.l.verma@intel.com>
>>  M:	Dave Jiang <dave.jiang@intel.com>
>>  M:	Alison Schofield <alison.schofield@intel.com>
>> @@ -10304,12 +10301,11 @@ F:	include/linux/fcntl.h
>>  F:	include/uapi/linux/fcntl.h
>>
>>  FILESYSTEM DIRECT ACCESS (DAX)
>> -M:	Dan Williams <djbw@kernel.org>
>>  R:	Matthew Wilcox <willy@infradead.org>
>>  R:	Jan Kara <jack@suse.cz>
>>  L:	linux-fsdevel@vger.kernel.org
>>  L:	nvdimm@lists.linux.dev
>> -S:	Supported
>> +S:	Odd Fixes
>>  F:	fs/dax.c
>>  F:	include/linux/dax.h
>>  F:	include/trace/events/fs_dax.h
>> @@ -13444,7 +13440,6 @@ F:	drivers/platform/x86/intel/hid.c
>>
>>  INTEL I/OAT DMA DRIVER
>>  M:	Dave Jiang <dave.jiang@intel.com>
>> -R:	Dan Williams <djbw@kernel.org>
>>  L:	dmaengine@vger.kernel.org
>>  S:	Supported
>>  Q:	https://patchwork.kernel.org/project/linux-dmaengine/list/
>> @@ -15267,7 +15262,6 @@ K:	libie
>>
>>  LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
>>  M:	Vishal Verma <vishal.l.verma@intel.com>
>> -M:	Dan Williams <djbw@kernel.org>
>>  M:	Dave Jiang <dave.jiang@intel.com>
>>  M:	Alison Schofield <alison.schofield@intel.com>
>>  L:	nvdimm@lists.linux.dev
>> @@ -15277,7 +15271,6 @@ P:	Documentation/nvdimm/maintainer-entry-profile.rst
>>  F:	drivers/nvdimm/btt*
>>
>>  LIBNVDIMM PMEM: PERSISTENT MEMORY DRIVER
>> -M:	Dan Williams <djbw@kernel.org>
>>  M:	Vishal Verma <vishal.l.verma@intel.com>
>>  M:	Dave Jiang <dave.jiang@intel.com>
>>  M:	Alison Schofield <alison.schofield@intel.com>
>> @@ -15296,7 +15289,6 @@ F:	Documentation/devicetree/bindings/pmem/pmem-region.yaml
>>  F:	drivers/nvdimm/of_pmem.c
>>
>>  LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
>> -M:	Dan Williams <djbw@kernel.org>
>>  M:	Vishal Verma <vishal.l.verma@intel.com>
>>  M:	Dave Jiang <dave.jiang@intel.com>
>>  M:	Alison Schofield <alison.schofield@intel.com>
>>
>> base-commit: abf8c33470f78e2226ee3dcdc69004660020ab47
>> --
>> 2.54.0
>>

