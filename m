Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE3B021DF9673
 for <linux-nvdimm@lists.01.org>; Tue,  8 Aug 2017 08:56:05 -0700 (PDT)
Subject: Re: [PATCH v4 3/8] dmaengine: Add DMA_MEMCPY_SG transaction op
References: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
 <150212397144.23722.92320326335988578.stgit@djiang5-desk3.ch.intel.com>
 <6015c583-9f9f-f21e-590a-4ff9184c3a8f@codeaurora.org>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <5495b257-8a7b-0488-d5ff-f7ab69ac5300@intel.com>
Date: Tue, 8 Aug 2017 08:58:21 -0700
MIME-Version: 1.0
In-Reply-To: <6015c583-9f9f-f21e-590a-4ff9184c3a8f@codeaurora.org>
Content-Language: en-US
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
To: Sinan Kaya <okaya@codeaurora.org>, "Koul, Vinod" <vinod.koul@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 08/08/2017 06:16 AM, Sinan Kaya wrote:
> Hi Dave,
> 
> On 8/7/2017 12:39 PM, Dave Jiang wrote:
>> Adding a dmaengine transaction operation that allows copy to/from a
>> scatterlist and a flat buffer.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  Documentation/dmaengine/provider.txt |    3 +++
>>  drivers/dma/dmaengine.c              |    2 ++
>>  include/linux/dmaengine.h            |    6 ++++++
>>  3 files changed, 11 insertions(+)
>>
> 
> I was wondering if you could add a test like DMA_SG to dmatest so that we
> also have a validation suite as well.

Yes good idea. I may add it as a follow on if Vinod doesn't object.

> 
> Sinan
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
