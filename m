Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4F35A7C
	for <nvdimm@lists.linux.dev>; Fri, 30 Sep 2022 17:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664559218; x=1696095218;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K6OH4w/539eMA95sHGQdynwkjrO1dx+kL7S/6jjI+uY=;
  b=dUD4uYsmrflY44lt/CEP564sH8yc4bGXBDFlAM/BJc+O1RuOBhT72Qoq
   JJDjwo+tbJhROE3zKo0roYHQn0FAmWRVzN9Bxi/V/4OsO6WtCCBN4Zb0S
   5Jf1ckHdJHb74+N+47pI98b7n+2x+duaGFA5RnUQfTAwhhnh3THP6Zhs0
   WWkIBiC4QafBPZpDw3dVFbRW3YtdklPRAzgok5QLdw0oNhGe/LNMoLDRM
   ZBwZ3nJYtr6Aql0jniFcjIqddQUyN6rU9T15Fuv7kJed3HlA+xSeoOSdZ
   gEntcN/fE2Lxzn6hphtvRdeQ20WclNXxD2y1cpQFAJXUcpDeJa0cwwl6V
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="364094055"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="364094055"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 10:33:38 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="622843957"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="622843957"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.36.70])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 10:33:38 -0700
Date: Fri, 30 Sep 2022 10:33:36 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dharmesh Pitroda <dpitroda@marvell.com>
Cc: "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Subject: Re: [cxl PATCH] add support for CXL mailbox command
Message-ID: <YzcocNVDYe1/pqeL@aschofie-mobl2>
References: <CY4PR1801MB1896EA05EAD04A6A954106ABC9569@CY4PR1801MB1896.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR1801MB1896EA05EAD04A6A954106ABC9569@CY4PR1801MB1896.namprd18.prod.outlook.com>

Hi Dharmesh,

Please resend following the ndctl contribution guidelines here:
https://github.com/pmem/ndctl/blob/main/CONTRIBUTING.md

Thanks,
Alison

On Fri, Sep 30, 2022 at 03:43:20PM +0000, Dharmesh Pitroda wrote:
> change detail- add support for cxl mailbox command from "cxl" cli
> 
> update cxl code for all supported mailbox command, start with 2 basic mailbox command get-partition-info and get-supported-log
> 
> [root@fedora dp]# ./cxl/cxl --list-cmds
> version
> list
> help
> zero-labels
> read-labels
> write-labels
> disable-memdev
> enable-memdev
> reserve-dpa
> free-dpa
> disable-port
> enable-port
> set-partition
> disable-bus
> create-region
> enable-region
> disable-region
> destroy-region
> mbx_get_partition_info
> mbx_get_supp_log
> [root@fedora dp]#
> [root@fedora dp]# ./cxl/cxl mbx_get_supp_log mem0
> num_of_sup_log_entry = 1
> log_identifier = 0d a9 c0 b5 bf 41 4b 78 8f 79 96 b1 62 3b 3f 17
> log_size = 52
> cxl memdev: cmd_mbx_get_supp_log: get_supplog 1 mem
> [root@fedora dp]# ./cxl/cxl mbx_get_partition_info mem0
> active_volatile = 0
> active_persistent = 2
> next_volatile = 0
> next_persistent = 0
> cxl memdev: cmd_mbx_get_partition_info: get_partition 1 mem
> [root@fedora dp]#
> 
> Attaching patch.
> 
> --
> --
> Regards,
> Dharmesh
> 


