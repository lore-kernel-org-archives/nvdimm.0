Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F60234B1AC
	for <nvdimm@lists.linux.dev>; Thu, 19 Feb 2026 16:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771518117; cv=none; b=MrsX8kaRSNozxCxaWrJkKqvhqxoKj1qaX6n0WKRZuhKtPEVdIF2zQ+HmHPTpV9P4jG7LbkjpXyDsQsvrQao2aNLNwLZE1CiHLfYnUuw3mOaJtkzw5dCOn8vL6Ii53sS+e+/ULbUWHZfDNvjoYWvJI977TMEpYFzg0yQ72Tpt40M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771518117; c=relaxed/simple;
	bh=bbrvKuUbJMxjfPRyQn5a0x4qovBxvrZ93fIJ/R5aibE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gf2g01RWDTGDVPpk6DQAlutEakB38S0d8OMov/I+FRZjgG9bhw0kafVU2dzCSU2QgkGdYKD2DIAMDTAgSS/AJ4MVSHcdtY5omXuwjvVUwaviTIehcxZ/EO6YFsf0ugSDl+CbkeQSc91E5z07ngrh4x7n7udN9uL4fBnRgG0EixA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A2ST6qXQ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A2ST6qXQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771518117; x=1803054117;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bbrvKuUbJMxjfPRyQn5a0x4qovBxvrZ93fIJ/R5aibE=;
  b=A2ST6qXQqolv97prPEDiMrL5HVQWHpbW6ELTSkDdchU6f/TI4jNMRAY6
   xoZ2hd5jEKFHbjZe8T/WvDF8f7dB0TMQJYcRmMxDc2s00rGAZeMIvPa/N
   mUocYbMJQ3/T3NKrpMNYPkaeQ8B8PX+Mmbuhl3TJQHU05mnd8dhl8McNc
   jHmwBnLoO4giip2zOwNEcCNSxO61Y0abRzsvixRRhojBFdnb+OwAI+X0m
   aMPfmhFCGq/5ZxDSXBOASvKLXswwgk10ToEaujb3W1UICWmSWQMHmz553
   n1PZRyimRym6HIwa/aJJXwKphs/yh4ghJsMXajceETyYdLc+KWblMUjVu
   A==;
X-CSE-ConnectionGUID: oUOAj6DKQnOUv1IOzPTJcQ==
X-CSE-MsgGUID: ow0K4v1zQIWzRcP8QATySQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="72650261"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="72650261"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 08:21:56 -0800
X-CSE-ConnectionGUID: LS+mcgySQ3SV8kcPkNMX5Q==
X-CSE-MsgGUID: wzAgoTZ4SkCSlQfRdX22PQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="212483558"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO [10.125.110.20]) ([10.125.110.20])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 08:21:52 -0800
Message-ID: <cdcebdb0-9231-4561-8e88-6379bb93268e@intel.com>
Date: Thu, 19 Feb 2026 09:21:51 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V7 09/19] famfs_fuse: magic.h: Add famfs magic numbers
To: John Groves <john@jagalactic.com>, John Groves <John@Groves.net>,
 Miklos Szeredi <miklos@szeredi.hu>, Dan Williams <dan.j.williams@intel.com>,
 Bernd Schubert <bschubert@ddn.com>,
 Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>, John Groves <jgroves@fastmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 David Hildenbrand <david@kernel.org>, Christian Brauner
 <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>,
 Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong
 <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>,
 Bagas Sanjaya <bagasdotme@gmail.com>, James Morse <james.morse@arm.com>,
 Fuad Tabba <tabba@google.com>, Sean Christopherson <seanjc@google.com>,
 Shivank Garg <shivankg@amd.com>, Ackerley Tng <ackerleytng@google.com>,
 Gregory Price <gourry@gourry.net>, Aravind Ramesh <arramesh@micron.com>,
 Ajay Joshi <ajayjoshi@micron.com>,
 "venkataravis@micron.com" <venkataravis@micron.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <0100019bd33b1f66-b835e86a-e8ae-443f-a474-02db88f7e6db-000000@email.amazonses.com>
 <20260118223224.92472-1-john@jagalactic.com>
 <0100019bd33d0dd3-81bc3562-6f64-4689-9312-6b6cec095540-000000@email.amazonses.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <0100019bd33d0dd3-81bc3562-6f64-4689-9312-6b6cec095540-000000@email.amazonses.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 1/18/26 3:32 PM, John Groves wrote:
> From: John Groves <john@groves.net>
> 
> Famfs distinguishes between its on-media and in-memory superblocks. This
> reserves the numbers, but they are only used by the user space
> components of famfs.
> 
> Signed-off-by: John Groves <john@groves.net>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

squash the defines with usage patch?

> ---
>  include/uapi/linux/magic.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
> index 638ca21b7a90..712b097bf2a5 100644
> --- a/include/uapi/linux/magic.h
> +++ b/include/uapi/linux/magic.h
> @@ -38,6 +38,8 @@
>  #define OVERLAYFS_SUPER_MAGIC	0x794c7630
>  #define FUSE_SUPER_MAGIC	0x65735546
>  #define BCACHEFS_SUPER_MAGIC	0xca451a4e
> +#define FAMFS_SUPER_MAGIC	0x87b282ff
> +#define FAMFS_STATFS_MAGIC      0x87b282fd
>  
>  #define MINIX_SUPER_MAGIC	0x137F		/* minix v1 fs, 14 char names */
>  #define MINIX_SUPER_MAGIC2	0x138F		/* minix v1 fs, 30 char names */

