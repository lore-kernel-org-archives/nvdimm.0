Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C4502095E010
 for <linux-nvdimm@lists.01.org>; Fri, 11 Aug 2017 10:52:25 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH v4 0/8] Adding blk-mq and DMA support to pmem block driver
Date: Fri, 11 Aug 2017 17:54:41 +0000
Message-ID: <AT5PR84MB0082569134EDF375011A6185AB890@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <150212381454.23722.1549806704988615279.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
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
To: Dave Jiang <dave.jiang@intel.com>, "vinod.koul@intel.com" <vinod.koul@intel.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of
> Dave Jiang
> Sent: Monday, August 7, 2017 11:39 AM
> To: vinod.koul@intel.com; dan.j.williams@intel.com
> Cc: dmaengine@vger.kernel.org; linux-nvdimm@lists.01.org
> Subject: [PATCH v4 0/8] Adding blk-mq and DMA support to pmem block driver
> 
...
> The following series implements adds blk-mq support to the pmem block
> driver
> and also adds infrastructure code to ioatdma and dmaengine in order to
> support copying to and from scatterlist in order to process block
> requests provided by blk-mq. The usage of DMA engines available on certain
> platforms allow us to drastically reduce CPU utilization and at the same
> time
> maintain performance that is good enough. Experimentations have been done
> on
> DRAM backed pmem block device that showed the utilization of DMA engine is
> beneficial. User can revert back to original behavior by providing
> queue_mode=0 to the nd_pmem kernel module if desired.

This needs the same error handling as memcpy_mcsafe():
* if pmem is the source, skip over known bad addresses already 
in the ARS list (don't purposely force the DMA engine to run
into errors)
* add any newly detected bad addresses that the DMA engine
finds to the ARS list (so they can be avoided in the future)
* if pmem is the destination, clear those addresses from the ARS
list (since fresh new data is being written)

If the DMA engine handles uncorrectable memory errors well and the
CPU does not survive UCEs, it would be preferable to use the DMA
engine instead of the CPU for all transfers - not just large
transfers.  

---
Robert Elliott, HPE Persistent Memory


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
