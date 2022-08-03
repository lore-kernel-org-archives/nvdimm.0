Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF301C2F
	for <nvdimm@lists.linux.dev>; Wed,  3 Aug 2022 16:29:24 +0000 (UTC)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lycdr5rjLz67tfn;
	Thu,  4 Aug 2022 00:25:04 +0800 (CST)
Received: from lhrpeml500005.china.huawei.com (7.191.163.240) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 3 Aug 2022 18:29:15 +0200
Received: from localhost (10.202.226.42) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 3 Aug
 2022 17:29:14 +0100
Date: Wed, 3 Aug 2022 17:29:13 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Davidlohr Bueso <dave@stgolabs.net>
CC: Dave Jiang <dave.jiang@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <dan.j.williams@intel.com>, <bwidawsk@kernel.org>,
	<ira.weiny@intel.com>, <vishal.l.verma@intel.com>,
	<alison.schofield@intel.com>
Subject: Re: [PATCH RFC 01/15] cxl/pmem: Introduce nvdimm_security_ops with
 ->get_flags() operation
Message-ID: <20220803172913.000057fb@huawei.com>
In-Reply-To: <20220715210904.bwqbahyya7kwixim@offworld>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
	<165791931828.2491387.3280104860123759941.stgit@djiang5-desk3.ch.intel.com>
	<20220715210904.bwqbahyya7kwixim@offworld>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhreml740-chm.china.huawei.com (10.201.108.190) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Fri, 15 Jul 2022 14:09:04 -0700
Davidlohr Bueso <dave@stgolabs.net> wrote:

> On Fri, 15 Jul 2022, Dave Jiang wrote:
> 
> >+config CXL_PMEM_SECURITY
> >+	tristate "CXL PMEM SECURITY: Persistent Memory Security Support"
> >+	depends on CXL_PMEM
> >+	default CXL_BUS
> >+	help
> >+	  CXL memory device "Persistent Memory Data-at-rest Security" command set
> >+	  support. Support opcode 0x4500..0x4505. The commands supported are "Get
> >+	  Security State", "Set Passphrase", "Disable Passphrase", "Unlock",
> >+	  "Freeze Security State", and "Passphrase Secure Erase". Security operation
> >+	  is done through nvdimm security_ops.
> >+
> >+	  See Chapter 8.2.9.5.6 in the CXL 2.0 specification for a detailed description
> >+	  of the Persistent Memory Security.
> >+
> >+	  If unsure say 'm'.  
> 
> Is there any fundamental reason why we need to add a new CXL Kconfig option
> instead of just tucking this under CXL_PMEM?

Agreed. I can't immediately see why we'd have this separately configurable.

Other than this looks good to me.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
