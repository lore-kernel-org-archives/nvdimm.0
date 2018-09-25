Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CC4A9211575C7
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 14:50:43 -0700 (PDT)
From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] nvdimm: Set device node in nd_device_register
Date: Tue, 25 Sep 2018 21:50:29 +0000
Message-ID: <1537912228.7585.93.camel@intel.com>
References: <20180925204801.6182.73167.stgit@localhost.localdomain>
 <20180925205307.6182.26453.stgit@localhost.localdomain>
 <CAPcyv4jpUNP4mySPr5jYogpf5ZMPgpTu9oOjC89ZYHa=vL1JwQ@mail.gmail.com>
 <bcd44872-1961-79ff-f1a5-8ab2c2a99c20@linux.intel.com>
 <CAPcyv4jhxGubqLiHC=jqy2Bn7XQALUUoFcfEVKCUSeqGWCstLA@mail.gmail.com>
 <c6a5b7b0-954a-d84f-4927-03e51a016394@linux.intel.com>
In-Reply-To: <c6a5b7b0-954a-d84f-4927-03e51a016394@linux.intel.com>
Content-Language: en-US
Content-ID: <2B2A0EDE7DC21647BB4FD603D30878FC@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "alexander.h.duyck@linux.intel.com" <alexander.h.duyck@linux.intel.com>
Cc: "zwisler@kernel.org" <zwisler@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2018-09-25 at 14:35 -0700, Alexander Duyck wrote:
[..]
> Yeah, I kind of gathered that. If you want to move it feel free to.

Thanks for the flexibility, applied.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
