Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9645E4C6D
	for <nvdimm@lists.linux.dev>; Tue, 25 Jul 2023 03:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690254984; x=1721790984;
  h=from:to:cc:subject:references:date:in-reply-to:
   message-id:mime-version;
  bh=eXqEf3qlKPxbWMmz2TfO/Y35RDERdVQkGU4AZ8/UTeY=;
  b=k77MfzbH8Xg133JCoC2ULtHsEdH7oybY3z7HYJHy6KRwJzQY9pTFIXJ+
   yyppUV7Gojh+ZMI+q6n1kp4voq70MmuGw4cf6wVY0yqtTlDsqaF9IdsdM
   CcDhRFIcc/uIfSZQiorAU3lMhPCZq3jEORilhhcHGk5gLwRZ/yUbzPzAD
   lv4BMrP2jBGlrKpHroIFLG3r7y6HlinmG76aNGt46k4EsBp1ncytvfYmA
   y3a+04vDIbELVev6MKE2nWgMfmowjMtTRSNi9tk2m8PSPG7A2ej1tCLFE
   2Eb11FUY8bpFambxlEANf8zhEFmkZ0p+Q6gaYTRpvN/S7XZHkYE5w4/6N
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="347211944"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="347211944"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 20:16:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="729174386"
X-IronPort-AV: E=Sophos;i="6.01,229,1684825200"; 
   d="scan'208";a="729174386"
Received: from yhuang6-desk2.sh.intel.com (HELO yhuang6-desk2.ccr.corp.intel.com) ([10.238.208.55])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 20:16:19 -0700
From: "Huang, Ying" <ying.huang@intel.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  <linux-mm@kvack.org>,
  <linux-kernel@vger.kernel.org>,  <linux-cxl@vger.kernel.org>,
  <nvdimm@lists.linux.dev>,  <linux-acpi@vger.kernel.org>,  "Aneesh Kumar K
 . V" <aneesh.kumar@linux.ibm.com>,  Wei Xu <weixugc@google.com>,  Dan
 Williams <dan.j.williams@intel.com>,  Dave Hansen <dave.hansen@intel.com>,
  "Davidlohr Bueso" <dave@stgolabs.net>,  Johannes Weiner
 <hannes@cmpxchg.org>,  "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
  Michal Hocko <mhocko@kernel.org>,  Yang Shi <shy828301@gmail.com>,
  Rafael J Wysocki <rafael.j.wysocki@intel.com>, Dave Jiang
 <dave.jiang@intel.com>
Subject: Re: [PATCH RESEND 1/4] memory tiering: add abstract distance
 calculation algorithms management
References: <20230721012932.190742-1-ying.huang@intel.com>
	<20230721012932.190742-2-ying.huang@intel.com>
	<87r0owzqdc.fsf@nvdebian.thelocal>
Date: Tue, 25 Jul 2023 11:14:38 +0800
In-Reply-To: <87r0owzqdc.fsf@nvdebian.thelocal> (Alistair Popple's message of
	"Tue, 25 Jul 2023 12:13:49 +1000")
Message-ID: <87r0owy95t.fsf@yhuang6-desk2.ccr.corp.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii

Hi, Alistair,

Thanks a lot for comments!

Alistair Popple <apopple@nvidia.com> writes:

> Huang Ying <ying.huang@intel.com> writes:
>
>> The abstract distance may be calculated by various drivers, such as
>> ACPI HMAT, CXL CDAT, etc.  While it may be used by various code which
>> hot-add memory node, such as dax/kmem etc.  To decouple the algorithm
>> users and the providers, the abstract distance calculation algorithms
>> management mechanism is implemented in this patch.  It provides
>> interface for the providers to register the implementation, and
>> interface for the users.
>
> I wonder if we need this level of decoupling though? It seems to me like
> it would be simpler and better for drivers to calculate the abstract
> distance directly themselves by calling the desired algorithm (eg. ACPI
> HMAT) and pass this when creating the nodes rather than having a
> notifier chain.

Per my understanding, ACPI HMAT and memory device drivers (such as
dax/kmem) may belong to different subsystems (ACPI vs. dax).  It's not
good to call functions across subsystems directly.  So, I think it's
better to use a general subsystem: memory-tier.c to decouple them.  If
it turns out that a notifier chain is unnecessary, we can use some
function pointers instead.

> At the moment it seems we've only identified two possible algorithms
> (ACPI HMAT and CXL CDAT) and I don't think it would make sense for one
> of those to fallback to the other based on priority, so why not just
> have drivers call the correct algorithm directly?

For example, we have a system with PMEM (persistent memory, Optane
DCPMM, or AEP, or something else) in DIMM slots and CXL.mem connected
via CXL link to a remote memory pool.  We will need ACPI HMAT for PMEM
and CXL CDAT for CXL.mem.  One way is to make dax/kmem identify the
types of the device and call corresponding algorithms.  The other way
(suggested by this series) is to make dax/kmem call a notifier chain,
then CXL CDAT or ACPI HMAT can identify the type of device and calculate
the distance if the type is correct for them.  I don't think that it's
good to make dax/kem to know every possible types of memory devices.

>> Multiple algorithm implementations can cooperate via calculating
>> abstract distance for different memory nodes.  The preference of
>> algorithm implementations can be specified via
>> priority (notifier_block.priority).
>
> How/what decides the priority though? That seems like something better
> decided by a device driver than the algorithm driver IMHO.

Do we need the memory device driver specific priority?  Or we just share
a common priority?  For example, the priority of CXL CDAT is always
higher than that of ACPI HMAT?  Or architecture specific?

And, I don't think that we are forced to use the general notifier chain
interface in all memory device drivers.  If the memory device driver has
better understanding of the memory device, it can use other way to
determine abstract distance.  For example, a CXL memory device driver
can identify abstract distance by itself.  While other memory device drivers
can use the general notifier chain interface at the same time.

--
Best Regards,
Huang, Ying
