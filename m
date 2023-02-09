Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5147C33EA
	for <nvdimm@lists.linux.dev>; Thu,  9 Feb 2023 11:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JmItCF/Hc3iPs7Ks538UlyC8NCqGwOSthlT2H4VZr0Y=;
  b=ZXkW9FyaSmUgOLCRyeqZMrPe36YkHENMgjMO6d8Fbo5lBbOxeN8dCpr6
   GbzVAAgPebDKZKbOfrDGJEEjtUAGfhvYl6N3bQoEapqprPej+ei/BiZyq
   MPde4ZhRuEUrhxZEqafE5pwJwjbY8Z2zQ+NV+skSKvPPjPkeuotp7JOv0
   M=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Brice.Goglin@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.97,283,1669071600"; 
   d="scan'208";a="47293240"
Received: from unknown (HELO [193.50.110.246]) ([193.50.110.246])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 12:04:48 +0100
Message-ID: <e885b2a7-0405-153c-a578-b863a4e00977@inria.fr>
Date: Thu, 9 Feb 2023 12:04:47 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH ndctl v2 0/7] cxl: add support for listing and creating
 volatile regions
Content-Language: en-US
To: Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
Cc: Gregory Price <gregory.price@memverge.com>,
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Dan Williams
 <dan.j.williams@intel.com>, nvdimm@lists.linux.dev,
 Ira Weiny <ira.weiny@intel.com>
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
From: Brice Goglin <Brice.Goglin@inria.fr>
In-Reply-To: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


Le 08/02/2023 à 21:00, Vishal Verma a écrit :
> While enumeration of ram type regions already works in libcxl and
> cxl-cli, it lacked an attribute to indicate pmem vs. ram. Add a new
> 'type' attribute to region listings to address this. Additionally, add
> support for creating ram regions to the cxl-create-region command. The
> region listings are also updated with dax-region information for
> volatile regions.
>
> This also includes fixed for a few bugs / usability issues identified
> along the way - patches 1, 4, and 6. Patch 5 is a usability improvement
> where based on decoder capabilities, the type of a region can be
> inferred for the create-region command.
>
> These have been tested against the ram-region additions to cxl_test
> which are part of the kernel support patch set[1].
> Additionally, tested against qemu using a WIP branch for volatile
> support found here[2]. The 'run_qemu' script has a branch that creates
> volatile memdevs in addition to pmem ones. This is also in a branch[3]
> since it depends on [2].
>
> These cxl-cli / libcxl patches themselves are also available in a
> branch at [4].
>
> [1]: https://lore.kernel.org/linux-cxl/167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com/
> [2]: https://gitlab.com/jic23/qemu/-/commits/cxl-2023-01-26
> [3]: https://github.com/pmem/run_qemu/commits/vv/ram-memdevs
> [4]: https://github.com/pmem/ndctl/tree/vv/volatile-regions


Hello Vishal

I am trying to play with this but all my attempts failed so far. Could 
you provide Qemu and cxl-cli command-lines to get a volatile region 
enabled in a Qemu VM?

Thanks

Brice



